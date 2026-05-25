/**
 * verbose-footer.ts
 *
 * Replaces the default pi footer with human-readable token stat labels
 * instead of cryptic symbols (↑ ↓ R W).
 *
 * Footer layout:
 *   Line 1:  ~/cwd  •  session-name     [git-branch]     model-name  •  thinking
 *   Line 2:  Input tokens to model: X | Output tokens generated: X | Cache read: X | Cache write: X
 *   Line 3:  ctx [gauge] pct used/total > [window] [gauge] pct reset > [window] [gauge] pct reset
 *   Line 4:  Cost: $X.XXX // session-stats
 *   Line 5+: Extension statuses
 */

import type { AssistantMessage } from "@earendil-works/pi-ai";
import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";
import { buildSessionContext } from "@earendil-works/pi-coding-agent";
import { truncateToWidth, visibleWidth } from "@earendil-works/pi-tui";
import { execSync } from "node:child_process";
import { existsSync, readFileSync } from "node:fs";
import { homedir } from "node:os";
import { isAbsolute, join, relative, resolve, sep } from "node:path";

// ── Types ──

interface RateWindow {
	label: string;
	usedPercent: number;
	resetsIn?: string;
}

interface UsageSnapshot {
	provider: string;
	windows: RateWindow[];
	error?: string;
	fetchedAt: number;
}

interface GitCache {
	branch: string | null;
	dirty: boolean;
	ahead: number;
	behind: number;
}

// ── Constants ──

const USAGE_REFRESH_INTERVAL = 5 * 60_000; // 5 minutes
const usageCache = new Map<string, UsageSnapshot>();

// Bar chars — shared by context gauge and usage bars
const BAR_FILLED = "━";
const BAR_EMPTY = "─";
const CTX_GAUGE_WIDTH = 12;
const USAGE_BAR_WIDTH = 10;

// ── Git cache ──

let gitCache: GitCache | null = null;

function parseGitStatus(output: string): GitCache {
	let branch: string | null = null;
	let dirty = false;
	let ahead = 0;
	let behind = 0;
	for (const line of output.split("\n")) {
		if (!line) continue;
		if (line.startsWith("# branch.head ")) {
			const head = line.slice("# branch.head ".length).trim();
			branch = head && head !== "(detached)" ? head : null;
			continue;
		}
		if (line.startsWith("# branch.ab ")) {
			const match = line.match(/^# branch\.ab \+(\d+) -(\d+)$/);
			if (match) {
				ahead = parseInt(match[1], 10) || 0;
				behind = parseInt(match[2], 10) || 0;
			}
			continue;
		}
		if (!line.startsWith("# ")) dirty = true;
	}
	return { branch, dirty, ahead, behind };
}

function sameGitCache(a: GitCache | null, b: GitCache | null): boolean {
	if (a === b) return true;
	if (!a || !b) return false;
	return a.branch === b.branch && a.dirty === b.dirty &&
		a.ahead === b.ahead && a.behind === b.behind;
}

function refreshGitCache(): boolean {
	let next: GitCache | null = null;
	try {
		const status = execSync("git status --porcelain=v2 --branch 2>/dev/null", {
			encoding: "utf8",
			timeout: 1000,
		});
		next = parseGitStatus(status.trimEnd());
	} catch {
		next = null;
	}
	const changed = !sameGitCache(gitCache, next);
	gitCache = next;
	return changed;
}

// ── Utility helpers ──

function formatCwd(cwd: string): string {
	const home = process.env.HOME || process.env.USERPROFILE || "";
	if (!home) return cwd;
	const resolvedCwd = resolve(cwd);
	const resolvedHome = resolve(home);
	const rel = relative(resolvedHome, resolvedCwd);
	const inside =
		rel === "" ||
		(rel !== ".." && !rel.startsWith(`..${sep}`) && !isAbsolute(rel));
	if (!inside) return cwd;
	return rel === "" ? "~" : `~${sep}${rel}`;
}

function formatTokens(count: number): string {
	if (count < 1_000) return count.toString();
	if (count < 10_000) return `${(count / 1_000).toFixed(1)}k`;
	if (count < 1_000_000) return `${Math.round(count / 1_000)}k`;
	if (count < 10_000_000) return `${(count / 1_000_000).toFixed(1)}M`;
	return `${Math.round(count / 1_000_000)}M`;
}

function formatTokenCount(tokens: number): string {
	if (tokens >= 1_000_000) {
		const m = tokens / 1_000_000;
		return m % 1 === 0 ? `${m}M` : `${m.toFixed(1).replace(/\.0$/, "")}M`;
	}
	if (tokens >= 1_000) return `${Math.round(tokens / 1_000)}k`;
	return `${tokens}`;
}

function formatResetTime(date: Date): string {
	const diffMs = date.getTime() - Date.now();
	if (diffMs < 0) return "now";
	const diffMins = Math.floor(diffMs / 60000);
	if (diffMins < 60) return `${diffMins}m`;
	const hours = Math.floor(diffMins / 60);
	const mins = diffMins % 60;
	if (hours < 24) return mins > 0 ? `${hours}h${mins}m` : `${hours}h`;
	const days = Math.floor(hours / 24);
	const remainingHours = hours % 24;
	return remainingHours > 0 ? `${days}d${remainingHours}h` : `${days}d`;
}

function clampPercent(value: number): number {
	if (!Number.isFinite(value)) return 0;
	return Math.max(0, Math.min(100, value));
}

function normalizePercent(value: number): number {
	if (!Number.isFinite(value)) return 0;
	const normalized = value <= 1 && value >= 0 ? value * 100 : value;
	return Math.max(0, Math.min(100, normalized));
}

function getWindowLabel(durationMs: number | undefined, fallback: string): string {
	if (!durationMs || !Number.isFinite(durationMs) || durationMs <= 0) return fallback;
	const hourMs = 60 * 60 * 1000;
	const dayMs = 24 * hourMs;
	const weekMs = 7 * dayMs;
	if (Math.abs(durationMs - weekMs) <= hourMs * 2 || fallback === "Week") return "Week";
	if (Math.abs(durationMs - dayMs) <= hourMs * 2 || fallback === "Day") return "Day";
	if (Math.abs(durationMs - 5 * hourMs) <= hourMs * 2 || fallback === "5h") return fallback;
	const hours = Math.round(durationMs / hourMs);
	if (hours >= 1 && hours < 48) return `${hours}h`;
	const days = Math.round(durationMs / dayMs);
	if (days >= 1) return `${days}d`;
	return `${Math.max(1, Math.round(durationMs / 60000))}m`;
}

async function fetchWithTimeout(
	url: string,
	init: RequestInit,
	timeoutMs = 5000,
): Promise<Response> {
	const controller = new AbortController();
	const timeout = setTimeout(() => controller.abort(), timeoutMs);
	try {
		return await fetch(url, { ...init, signal: controller.signal });
	} finally {
		clearTimeout(timeout);
	}
}

// ── Auth helpers ──

function loadAuthJson(): Record<string, any> {
	const authPath = join(homedir(), ".pi", "agent", "auth.json");
	try {
		if (existsSync(authPath)) return JSON.parse(readFileSync(authPath, "utf-8"));
	} catch {}
	return {};
}

function resolveAuthValue(value: unknown): string | undefined {
	if (typeof value !== "string") return undefined;
	const trimmed = value.trim();
	if (!trimmed) return undefined;
	if (trimmed.startsWith("!")) {
		try {
			return (
				execSync(trimmed.slice(1), {
					encoding: "utf-8",
					stdio: ["pipe", "pipe", "pipe"],
					timeout: 2000,
				}).trim() || undefined
			);
		} catch {
			return undefined;
		}
	}
	if (/^[A-Z][A-Z0-9_]*$/.test(trimmed) && process.env[trimmed])
		return process.env[trimmed];
	return trimmed;
}

function getApiKey(providerKey: string, envVar: string): string | undefined {
	if (process.env[envVar]) return process.env[envVar];
	const auth = loadAuthJson();
	const entry = auth[providerKey];
	if (!entry) return undefined;
	if (typeof entry === "string") return resolveAuthValue(entry);
	return resolveAuthValue(entry.key ?? entry.access ?? entry.refresh);
}

function getClaudeToken(): string | undefined {
	const auth = loadAuthJson();
	if (auth.anthropic?.access) return auth.anthropic.access;
	try {
		const keychainData = execSync(
			'security find-generic-password -s "Claude Code-credentials" -w 2>/dev/null',
			{ encoding: "utf-8", stdio: ["pipe", "pipe", "pipe"] },
		).trim();
		if (keychainData) {
			const parsed = JSON.parse(keychainData);
			if (parsed.claudeAiOauth?.accessToken)
				return parsed.claudeAiOauth.accessToken;
		}
	} catch {}
	return undefined;
}

function getCopilotToken(): string | undefined {
	return loadAuthJson()["github-copilot"]?.refresh;
}

function getCodexToken(): { token: string; accountId?: string } | undefined {
	const auth = loadAuthJson();
	if (auth["openai-codex"]?.access)
		return {
			token: auth["openai-codex"].access,
			accountId: auth["openai-codex"]?.accountId,
		};
	const codexPath = join(
		process.env.CODEX_HOME || join(homedir(), ".codex"),
		"auth.json",
	);
	try {
		if (existsSync(codexPath)) {
			const data = JSON.parse(readFileSync(codexPath, "utf-8"));
			if (data.OPENAI_API_KEY) return { token: data.OPENAI_API_KEY };
			if (data.tokens?.access_token)
				return {
					token: data.tokens.access_token,
					accountId: data.tokens.account_id,
				};
		}
	} catch {}
	return undefined;
}

function getGeminiToken(): string | undefined {
	const auth = loadAuthJson();
	if (auth["google-gemini-cli"]?.access) return auth["google-gemini-cli"].access;
	const geminiPath = join(homedir(), ".gemini", "oauth_creds.json");
	try {
		if (existsSync(geminiPath))
			return JSON.parse(readFileSync(geminiPath, "utf-8")).access_token;
	} catch {}
	return undefined;
}

function getMinimaxToken(provider: "minimax" | "minimax-cn"): string | undefined {
	return provider === "minimax"
		? getApiKey("minimax", "MINIMAX_API_KEY")
		: getApiKey("minimax-cn", "MINIMAX_CN_API_KEY");
}

function getKimiToken(): string | undefined {
	return getApiKey("kimi-coding", "KIMI_API_KEY");
}

// ── Usage fetchers ──

async function fetchClaudeUsage(): Promise<UsageSnapshot> {
	const token = getClaudeToken();
	if (!token)
		return { provider: "Claude", windows: [], error: "no-auth", fetchedAt: Date.now() };
	try {
		const res = await fetchWithTimeout("https://api.anthropic.com/api/oauth/usage", {
			headers: {
				Authorization: `Bearer ${token}`,
				"anthropic-beta": "oauth-2025-04-20",
			},
		});
		if (!res.ok)
			return {
				provider: "Claude",
				windows: [],
				error: `HTTP ${res.status}`,
				fetchedAt: Date.now(),
			};
		const data = (await res.json()) as any;
		const windows: RateWindow[] = [];
		if (data.five_hour?.utilization !== undefined) {
			windows.push({
				label: "5h",
				usedPercent: normalizePercent(data.five_hour.utilization),
				resetsIn: data.five_hour.resets_at
					? formatResetTime(new Date(data.five_hour.resets_at))
					: undefined,
			});
		}
		if (data.seven_day?.utilization !== undefined) {
			windows.push({
				label: "Week",
				usedPercent: normalizePercent(data.seven_day.utilization),
				resetsIn: data.seven_day.resets_at
					? formatResetTime(new Date(data.seven_day.resets_at))
					: undefined,
			});
		}
		return { provider: "Claude", windows, fetchedAt: Date.now() };
	} catch (e) {
		return { provider: "Claude", windows: [], error: String(e), fetchedAt: Date.now() };
	}
}

async function fetchCopilotUsage(): Promise<UsageSnapshot> {
	const token = getCopilotToken();
	if (!token)
		return { provider: "Copilot", windows: [], error: "no-auth", fetchedAt: Date.now() };
	try {
		const res = await fetchWithTimeout("https://api.github.com/copilot_internal/user", {
			headers: {
				"Editor-Version": "vscode/1.96.2",
				"User-Agent": "GitHubCopilotChat/0.26.7",
				"X-Github-Api-Version": "2025-04-01",
				Accept: "application/json",
				Authorization: `token ${token}`,
			},
		});
		if (!res.ok)
			return {
				provider: "Copilot",
				windows: [],
				error: `HTTP ${res.status}`,
				fetchedAt: Date.now(),
			};
		const data = (await res.json()) as any;
		const windows: RateWindow[] = [];
		const resetDate = data.quota_reset_date_utc
			? new Date(data.quota_reset_date_utc)
			: undefined;
		const resetsIn = resetDate ? formatResetTime(resetDate) : undefined;
		if (data.quota_snapshots?.premium_interactions) {
			const pi = data.quota_snapshots.premium_interactions;
			windows.push({
				label: "Premium",
				usedPercent: clampPercent(100 - (pi.percent_remaining || 0)),
				resetsIn,
			});
		}
		if (data.quota_snapshots?.chat && !data.quota_snapshots.chat.unlimited) {
			const chat = data.quota_snapshots.chat;
			windows.push({
				label: "Chat",
				usedPercent: clampPercent(100 - (chat.percent_remaining || 0)),
				resetsIn,
			});
		}
		return { provider: "Copilot", windows, fetchedAt: Date.now() };
	} catch (e) {
		return { provider: "Copilot", windows: [], error: String(e), fetchedAt: Date.now() };
	}
}

async function fetchCodexUsage(): Promise<UsageSnapshot> {
	const creds = getCodexToken();
	if (!creds)
		return { provider: "Codex", windows: [], error: "no-auth", fetchedAt: Date.now() };
	try {
		const headers: Record<string, string> = {
			Authorization: `Bearer ${creds.token}`,
			"User-Agent": "pi-agent",
			Accept: "application/json",
		};
		if (creds.accountId) headers["ChatGPT-Account-Id"] = creds.accountId;
		const res = await fetchWithTimeout(
			"https://chatgpt.com/backend-api/wham/usage",
			{ method: "GET", headers },
		);
		if (!res.ok)
			return {
				provider: "Codex",
				windows: [],
				error: `HTTP ${res.status}`,
				fetchedAt: Date.now(),
			};
		const data = (await res.json()) as any;
		const windows: RateWindow[] = [];
		if (data.rate_limit?.primary_window) {
			const pw = data.rate_limit.primary_window;
			const resetDate = pw.reset_at ? new Date(pw.reset_at * 1000) : undefined;
			const durationMs =
				typeof pw.limit_window_seconds === "number"
					? pw.limit_window_seconds * 1000
					: undefined;
			windows.push({
				label: getWindowLabel(durationMs, "5h"),
				usedPercent: clampPercent(pw.used_percent || 0),
				resetsIn: resetDate ? formatResetTime(resetDate) : undefined,
			});
		}
		if (data.rate_limit?.secondary_window) {
			const sw = data.rate_limit.secondary_window;
			const resetDate = sw.reset_at ? new Date(sw.reset_at * 1000) : undefined;
			const durationMs =
				typeof sw.limit_window_seconds === "number"
					? sw.limit_window_seconds * 1000
					: undefined;
			windows.push({
				label: getWindowLabel(durationMs, "Week"),
				usedPercent: clampPercent(sw.used_percent || 0),
				resetsIn: resetDate ? formatResetTime(resetDate) : undefined,
			});
		}
		return { provider: "Codex", windows, fetchedAt: Date.now() };
	} catch (e) {
		return { provider: "Codex", windows: [], error: String(e), fetchedAt: Date.now() };
	}
}

async function fetchGeminiUsage(): Promise<UsageSnapshot> {
	const token = getGeminiToken();
	if (!token)
		return { provider: "Gemini", windows: [], error: "no-auth", fetchedAt: Date.now() };
	try {
		const res = await fetchWithTimeout(
			"https://cloudcode-pa.googleapis.com/v1internal:retrieveUserQuota",
			{
				method: "POST",
				headers: {
					Authorization: `Bearer ${token}`,
					"Content-Type": "application/json",
				},
				body: "{}",
			},
		);
		if (!res.ok)
			return {
				provider: "Gemini",
				windows: [],
				error: `HTTP ${res.status}`,
				fetchedAt: Date.now(),
			};
		const data = (await res.json()) as any;
		const quotas: Record<string, number> = {};
		for (const bucket of data.buckets || []) {
			const model = bucket.modelId || "unknown";
			const frac = bucket.remainingFraction ?? 1;
			if (!quotas[model] || frac < quotas[model]) quotas[model] = frac;
		}
		const windows: RateWindow[] = [];
		let proMin = 1,
			flashMin = 1,
			hasProModel = false,
			hasFlashModel = false;
		for (const [model, frac] of Object.entries(quotas)) {
			if (model.toLowerCase().includes("pro")) {
				hasProModel = true;
				if (frac < proMin) proMin = frac;
			}
			if (model.toLowerCase().includes("flash")) {
				hasFlashModel = true;
				if (frac < flashMin) flashMin = frac;
			}
		}
		if (hasProModel)
			windows.push({ label: "Pro", usedPercent: clampPercent((1 - proMin) * 100) });
		if (hasFlashModel)
			windows.push({
				label: "Flash",
				usedPercent: clampPercent((1 - flashMin) * 100),
			});
		return { provider: "Gemini", windows, fetchedAt: Date.now() };
	} catch (e) {
		return { provider: "Gemini", windows: [], error: String(e), fetchedAt: Date.now() };
	}
}

async function fetchMinimaxUsage(
	provider: "minimax" | "minimax-cn",
): Promise<UsageSnapshot> {
	const token = getMinimaxToken(provider);
	const providerLabel = provider === "minimax-cn" ? "MiniMax CN" : "MiniMax";
	const endpoint =
		provider === "minimax-cn"
			? "https://api.minimaxi.com/v1/api/openplatform/coding_plan/remains"
			: "https://api.minimax.io/v1/api/openplatform/coding_plan/remains";
	if (!token)
		return {
			provider: providerLabel,
			windows: [],
			error: "no-auth",
			fetchedAt: Date.now(),
		};
	try {
		const res = await fetchWithTimeout(endpoint, {
			method: "GET",
			headers: {
				Authorization: `Bearer ${token}`,
				"Content-Type": "application/json",
			},
		});
		if (!res.ok)
			return {
				provider: providerLabel,
				windows: [],
				error: `HTTP ${res.status}`,
				fetchedAt: Date.now(),
			};
		const data = (await res.json()) as any;
		const baseResp = data?.base_resp;
		if (baseResp?.status_code && baseResp.status_code !== 0)
			return {
				provider: providerLabel,
				windows: [],
				error: baseResp.status_msg || `API ${baseResp.status_code}`,
				fetchedAt: Date.now(),
			};
		const remains = Array.isArray(data?.model_remains) ? data.model_remains : [];
		const textBucket =
			remains.find(
				(e: any) =>
					typeof e?.model_name === "string" && /^minimax-m/i.test(e.model_name),
			) ||
			remains.find(
				(e: any) =>
					typeof e?.model_name === "string" && /minimax/i.test(e.model_name),
			) ||
			remains[0];
		if (!textBucket)
			return {
				provider: providerLabel,
				windows: [],
				error: "no-usage-data",
				fetchedAt: Date.now(),
			};
		const windows: RateWindow[] = [];
		const intervalTotal = Number(textBucket.current_interval_total_count) || 0;
		const intervalRemaining =
			Number(textBucket.current_interval_usage_count) || 0;
		if (intervalTotal > 0) {
			const used = intervalTotal - intervalRemaining;
			const durationMs =
				textBucket.start_time && textBucket.end_time
					? Number(textBucket.end_time) - Number(textBucket.start_time)
					: undefined;
			windows.push({
				label: getWindowLabel(durationMs, "5h"),
				usedPercent: clampPercent((used / intervalTotal) * 100),
				resetsIn: textBucket.end_time
					? formatResetTime(new Date(Number(textBucket.end_time)))
					: undefined,
			});
		}
		const weeklyTotal = Number(textBucket.current_weekly_total_count) || 0;
		const weeklyRemaining = Number(textBucket.current_weekly_usage_count) || 0;
		if (weeklyTotal > 0) {
			const used = weeklyTotal - weeklyRemaining;
			const durationMs =
				textBucket.weekly_start_time && textBucket.weekly_end_time
					? Number(textBucket.weekly_end_time) -
						Number(textBucket.weekly_start_time)
					: undefined;
			windows.push({
				label: getWindowLabel(durationMs, "Week"),
				usedPercent: clampPercent((used / weeklyTotal) * 100),
				resetsIn: textBucket.weekly_end_time
					? formatResetTime(new Date(Number(textBucket.weekly_end_time)))
					: undefined,
			});
		}
		return { provider: providerLabel, windows, fetchedAt: Date.now() };
	} catch (e) {
		return {
			provider: providerLabel,
			windows: [],
			error: String(e),
			fetchedAt: Date.now(),
		};
	}
}

async function fetchKimiUsage(): Promise<UsageSnapshot> {
	const token = getKimiToken();
	if (!token)
		return {
			provider: "Kimi Coding",
			windows: [],
			error: "no-auth",
			fetchedAt: Date.now(),
		};
	try {
		const res = await fetchWithTimeout("https://api.kimi.com/coding/v1/usages", {
			method: "GET",
			headers: {
				Authorization: `Bearer ${token}`,
				"Content-Type": "application/json",
			},
		});
		if (!res.ok)
			return {
				provider: "Kimi Coding",
				windows: [],
				error: `HTTP ${res.status}`,
				fetchedAt: Date.now(),
			};
		const data = (await res.json()) as any;
		const windows: RateWindow[] = [];
		for (const limit of data.limits || []) {
			const windowLimit = Number(limit.detail?.limit) || 0;
			const windowRemaining = Number(limit.detail?.remaining) || 0;
			if (windowLimit > 0) {
				const used = windowLimit - windowRemaining;
				const durationMs =
					limit.window?.duration &&
					limit.window?.timeUnit === "TIME_UNIT_MINUTE"
						? limit.window.duration * 60 * 1000
						: undefined;
				windows.push({
					label: getWindowLabel(durationMs, "5h"),
					usedPercent: clampPercent((used / windowLimit) * 100),
					resetsIn: limit.detail?.resetTime
						? formatResetTime(new Date(limit.detail.resetTime))
						: undefined,
				});
			}
		}
		const weeklyLimit = Number(data.usage?.limit) || 0;
		const weeklyRemaining = Number(data.usage?.remaining) || 0;
		if (weeklyLimit > 0) {
			const used = weeklyLimit - weeklyRemaining;
			windows.push({
				label: "Weekly",
				usedPercent: clampPercent((used / weeklyLimit) * 100),
				resetsIn: data.usage?.resetTime
					? formatResetTime(new Date(data.usage.resetTime))
					: undefined,
			});
		}
		return { provider: "Kimi Coding", windows, fetchedAt: Date.now() };
	} catch (e) {
		return {
			provider: "Kimi Coding",
			windows: [],
			error: String(e),
			fetchedAt: Date.now(),
		};
	}
}

// ── Provider detection ──

const PROVIDER_MAP: Record<string, string> = {
	anthropic: "claude",
	"openai-codex": "codex",
	"github-copilot": "copilot",
	"google-gemini-cli": "gemini",
	minimax: "minimax",
	"minimax-cn": "minimax-cn",
	"kimi-coding": "kimi-coding",
};

function detectProvider(modelProvider: string): string | null {
	return PROVIDER_MAP[modelProvider] || null;
}

async function fetchUsageForProvider(provider: string): Promise<UsageSnapshot> {
	switch (provider) {
		case "claude": return fetchClaudeUsage();
		case "codex": return fetchCodexUsage();
		case "copilot": return fetchCopilotUsage();
		case "gemini": return fetchGeminiUsage();
		case "minimax": return fetchMinimaxUsage("minimax");
		case "minimax-cn": return fetchMinimaxUsage("minimax-cn");
		case "kimi-coding": return fetchKimiUsage();
		default:
			return {
				provider: "Unknown",
				windows: [],
				error: "unknown-provider",
				fetchedAt: Date.now(),
			};
	}
}

// ── Context gauge helpers ──

function getContextInfo(ctx: any): { percentage: number; used: number; total: number } {
	const contextWindow = ctx.model?.contextWindow ?? 0;
	if (contextWindow === 0) return { percentage: 0, used: 0, total: 0 };
	const context = buildSessionContext(
		ctx.sessionManager.getEntries(),
		ctx.sessionManager.getLeafId(),
	);
	const lastAssistant = context.messages
		.slice()
		.reverse()
		.find((m: any) => m.role === "assistant" && m.stopReason !== "aborted") as any;
	const usage = lastAssistant?.usage;
	if (!usage) return { percentage: 0, used: 0, total: contextWindow };
	const contextTokens =
		(usage.input ?? 0) +
		(usage.output ?? 0) +
		(usage.cacheRead ?? 0) +
		(usage.cacheWrite ?? 0);
	return {
		percentage: (contextTokens / contextWindow) * 100,
		used: contextTokens,
		total: contextWindow,
	};
}

function renderContextGauge(
	percentage: number,
	theme: any,
	used: number,
	total: number,
): string {
	const clamped = Math.max(0, Math.min(100, percentage));
	const filled = Math.round((clamped / 100) * CTX_GAUGE_WIDTH);
	const empty = CTX_GAUGE_WIDTH - filled;
	const color =
		clamped >= 90
			? "error"
			: clamped >= 70
				? "warning"
				: clamped >= 50
					? "accent"
					: "success";
	const bar =
		theme.fg(color, BAR_FILLED.repeat(filled)) +
		theme.fg("dim", BAR_EMPTY.repeat(empty));
	const counts = total ? ` ${formatTokenCount(used)}/${formatTokenCount(total)}` : "";
	return (
		theme.fg("dim", "ctx ") +
		bar +
		" " +
		theme.fg("dim", `${Math.round(clamped)}%${counts}`)
	);
}

// ── Usage bar / window render helpers ──

function renderUsageBar(usedPercent: number, theme: any): string {
	const clamped = Math.max(0, Math.min(100, usedPercent));
	const filled = Math.round((clamped / 100) * USAGE_BAR_WIDTH);
	const empty = USAGE_BAR_WIDTH - filled;
	const color = clamped >= 92 ? "error" : clamped >= 85 ? "warning" : "success";
	return (
		theme.fg(color, BAR_FILLED.repeat(filled)) +
		theme.fg("dim", BAR_EMPTY.repeat(empty))
	);
}

function renderUsageWindow(window: RateWindow, theme: any): string {
	const dim = (s: string) => theme.fg("dim", s);
	const bar = renderUsageBar(window.usedPercent, theme);
	const pct = dim(`${Math.round(window.usedPercent)}%`);
	const timeStr = window.resetsIn ? " " + dim(window.resetsIn) : "";
	return `${dim(window.label)} ${bar} ${pct}${timeStr}`;
}

// ── Extension ──

export default function (pi: ExtensionAPI) {
	// Module-level usage state (shared across session_start and model_select)
	let latestUsage: UsageSnapshot | null = null;
	let activeProvider: string | null = null;
	let refreshTimer: ReturnType<typeof setInterval> | null = null;
	let tuiRef: { requestRender: () => void } | null = null;

	function stopRefreshTimer(): void {
		if (refreshTimer) {
			clearInterval(refreshTimer);
			refreshTimer = null;
		}
	}

	function startRefreshTimer(): void {
		stopRefreshTimer();
		refreshTimer = setInterval(() => {
			if (!activeProvider) return;
			const provider = activeProvider;
			const cached = usageCache.get(provider);
			fetchUsageForProvider(provider)
				.then((u) => {
					if (!u || activeProvider !== provider) return;
					if (u.windows.length === 0 && u.error && cached?.windows.length) return;
					usageCache.set(provider, u);
					latestUsage = u;
					tuiRef?.requestRender();
				})
				.catch(() => {});
		}, USAGE_REFRESH_INTERVAL);
	}

	function fetchUsage(modelProvider: string): void {
		const provider = detectProvider(modelProvider);
		if (!provider) {
			activeProvider = null;
			latestUsage = null;
			stopRefreshTimer();
			tuiRef?.requestRender();
			return;
		}
		activeProvider = provider;

		// Show cached data immediately if available
		const cached = usageCache.get(provider);
		if (cached && cached.windows.length > 0) {
			latestUsage = cached;
			tuiRef?.requestRender();
		}

		// Fetch fresh in background
		fetchUsageForProvider(provider)
			.then((u) => {
				if (!u || activeProvider !== provider) return;
				if (u.windows.length === 0 && u.error && cached?.windows.length) return;
				usageCache.set(provider, u);
				latestUsage = u;
				tuiRef?.requestRender();
			})
			.catch(() => {});
	}

	function refreshGitFooter(): void {
		if (refreshGitCache()) tuiRef?.requestRender();
	}

	pi.on("session_start", (_event, ctx) => {
		refreshGitCache();

		ctx.ui.setFooter((tui, theme, footerData) => {
			tuiRef = tui;
			const unsub = footerData.onBranchChange(() => refreshGitFooter());

			// Initial usage fetch when the footer is mounted
			if (ctx.model?.provider) {
				fetchUsage(ctx.model.provider);
				startRefreshTimer();
			}

			return {
				dispose: () => {
					unsub();
					tuiRef = null;
					stopRefreshTimer();
				},
				invalidate() {},

				render(width: number): string[] {
					// ── Compute cumulative token stats from ALL session entries ──
					let totalInput = 0;
					let totalOutput = 0;
					let totalCacheRead = 0;
					let totalCacheWrite = 0;
					let totalCost = 0;

					for (const entry of ctx.sessionManager.getBranch()) {
						if (
							entry.type === "message" &&
							entry.message.role === "assistant"
						) {
							const msg = entry.message as AssistantMessage;
							totalInput += msg.usage.input;
							totalOutput += msg.usage.output;
							totalCacheRead += msg.usage.cacheRead;
							totalCacheWrite += msg.usage.cacheWrite;
							totalCost += msg.usage.cost.total;
						}
					}

					const d = (s: string) => theme.fg("dim", s);
					const a = (s: string) => theme.fg("accent", s);

					// ── Line 1: pwd (left) | git branch (center) | model+thinking (right) ──

					// Left: cwd + optional session name
					let leftRaw = formatCwd(ctx.sessionManager.getCwd());
					const sessionName = ctx.sessionManager.getSessionName?.();
					if (sessionName) leftRaw += ` • ${sessionName}`;

					// Right: model id + thinking level
					const modelId = ctx.model?.id || "";
					const thinkingLevel = pi.getThinkingLevel();
					const showThinking = ctx.model?.reasoning && thinkingLevel;
					const rightRaw = showThinking
						? `${modelId} • ${thinkingLevel}`
						: modelId;
					const rightW = visibleWidth(rightRaw);

					// Center: git branch with dirty/ahead/behind indicators
					let branchStr = "";
					if (gitCache?.branch) {
						const color = gitCache.dirty ? "warning" : "success";
						branchStr = theme.fg(color, gitCache.branch);
						if (gitCache.dirty)  branchStr += theme.fg("warning", " *");
						if (gitCache.ahead)  branchStr += theme.fg("success", ` ↑${gitCache.ahead}`);
						if (gitCache.behind) branchStr += theme.fg("error",   ` ↓${gitCache.behind}`);
					}
					const branchW = visibleWidth(branchStr);

					let line1: string;
					if (branchStr && branchW + rightW + 2 <= width) {
						// Center branch within the full line, keeping right part fitting
						const branchPos = Math.max(0, Math.min(
							Math.floor((width - branchW) / 2),  // ideal center
							width - branchW - rightW - 1,       // guarantee right fits
						));
						const leftAvailable = Math.max(0, branchPos - 1);
						const leftTruncated = truncateToWidth(leftRaw, leftAvailable, "...");
						const leftW = visibleWidth(leftTruncated);
						const padLeft  = Math.max(1, branchPos - leftW);
						const padRight = Math.max(1, width - branchPos - branchW - rightW);
						line1 = d(leftTruncated)
							+ " ".repeat(padLeft)
							+ branchStr
							+ " ".repeat(padRight)
							+ d(rightRaw);
					} else {
						// No branch or terminal too narrow — fall back to left + right
						const leftAvailable = Math.max(0, width - rightW - 2);
						const leftTruncated = truncateToWidth(leftRaw, leftAvailable, "...");
						const leftW = visibleWidth(leftTruncated);
						const gap = Math.max(1, width - leftW - rightW);
						line1 = d(leftTruncated + " ".repeat(gap) + rightRaw);
					}

					// ── Line 2: token stats joined on one line ──
					const tokenParts: string[] = [];
					if (totalInput)
						tokenParts.push(
							d("Input to model: ") + a(formatTokens(totalInput)),
						);
					if (totalOutput)
						tokenParts.push(
							d("Output generated: ") + a(formatTokens(totalOutput)),
						);
					if (totalCacheRead)
						tokenParts.push(
							d("Cache read: ") +
								a(formatTokens(totalCacheRead)),
						);
					if (totalCacheWrite)
						tokenParts.push(
							d("Cache write: ") +
								a(formatTokens(totalCacheWrite)),
						);
					const tokenLine = tokenParts.length
						? truncateToWidth(tokenParts.join(d(" | ")), width, d("..."))
						: "";

					// ── Line 3: context gauge + subscription usage windows (same line) ──
					const {
						percentage: ctxPct,
						used: ctxUsed,
						total: ctxTotal,
					} = getContextInfo(ctx);

					const sep3 = " " + d(">") + " ";
					const line3Parts: string[] = [];
					if (ctxTotal > 0)
						line3Parts.push(renderContextGauge(ctxPct, theme, ctxUsed, ctxTotal));
					if (latestUsage && latestUsage.windows.length > 0) {
						for (const w of latestUsage.windows)
							line3Parts.push(renderUsageWindow(w, theme));
					}
					const line3 = line3Parts.length
						? truncateToWidth(line3Parts.join(sep3), width, d("..."))
						: "";

					// ── Line 4: cost + turn stats ──
					const usingSubscription = ctx.model
						? ctx.modelRegistry.isUsingOAuth(ctx.model)
						: false;

					const statuses = footerData.getExtensionStatuses();
					const sessionStats = statuses.get("session-stats") ?? "";
					const remainingStatuses = Array.from(statuses.entries())
						.filter(([key]) => key !== "session-stats")
						.sort(([a], [b]) => a.localeCompare(b))
						.map(([, text]) =>
							text
								.replace(/[\r\n\t]/g, " ")
								.replace(/ +/g, " ")
								.trim(),
						);

					const costStr =
						totalCost || usingSubscription
							? `Cost: $${totalCost.toFixed(3)}${usingSubscription ? " (sub)" : ""}`
							: "";
					const combinedCostStats =
						costStr && sessionStats
							? truncateToWidth(
									d(costStr + " // ") + sessionStats,
									width,
									d("..."),
								)
							: costStr
								? truncateToWidth(d(costStr), width, d("..."))
								: sessionStats
									? truncateToWidth(sessionStats, width, d("..."))
									: "";

					const lines: string[] = [
						line1,
						...(tokenLine ? [tokenLine] : []),
						...(line3 ? [line3] : []),
						...(combinedCostStats ? [combinedCostStats] : []),
						...remainingStatuses.map((s) =>
							truncateToWidth(s, width, d("...")),
						),
					];

					return lines;
				},
			};
		});
	});

	// Refresh usage when the user switches models
	pi.on("model_select", (event, _ctx) => {
		if (!event.model?.provider) return;
		fetchUsage(event.model.provider);
		startRefreshTimer();
	});

	// Refresh git state after each turn (picks up new commits, etc.)
	pi.on("turn_end", () => {
		refreshGitFooter();
	});
}
