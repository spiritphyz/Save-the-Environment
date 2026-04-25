/**
 * Session Stats Extension
 *
 * Displays session statistics in the status bar (left of built-in session token count):
 * turns, tool calls, tool results, total tokens, and cost.
 * Reconstructs counts from session history on start/reload.
 *
 * turns — number of LLM responses (assistant messages)
 * calls — number of tool calls made by the LLM
 * results — number of tool results returned
 * tokens — total tokens (input + output + cache)
 * cost — accumulated cost
 */

import type { ExtensionAPI } from "@mariozechner/pi-coding-agent";

export default function (pi: ExtensionAPI) {
  let turns = 0;
  let toolCalls = 0;
  let toolResults = 0;
  let totalTokens = 0;
  // let totalCost = 0;

  function fmt(n: number): string {
    if (n >= 1_000_000) return `${(n / 1_000_000).toFixed(1)}M`;
    if (n >= 1_000) return `${(n / 1_000).toFixed(1)}k`;
    return `${n}`;
  }

  function fmtCost(n: number): string {
    if (n < 0.01) return `$${n.toFixed(4)}`;
    return `$${n.toFixed(2)}`;
  }

  function updateStatus(ctx: { ui: { theme: any; setStatus: any } }) {
    const t = ctx.ui.theme;
    const parts = [
      t.fg("dim", "Turns: ") + t.fg("accent", `${turns}`),
      t.fg("dim", "Tool Calls: ") + t.fg("accent", `${toolCalls}`),
      t.fg("dim", "Tool Results: ") + t.fg("accent", `${toolResults}`),
      t.fg("dim", "Tokens(I+O+Cache): ") + t.fg("accent", fmt(totalTokens)),
      // t.fg("dim", "cost:") + t.fg("accent", fmtCost(totalCost)),
    ];
    ctx.ui.setStatus("session-stats", parts.join(t.fg("dim", " │ ")));
  }

  // Reconstruct stats from session history
  pi.on("session_start", async (_event, ctx) => {
    turns = 0;
    toolCalls = 0;
    toolResults = 0;
    totalTokens = 0;
    // totalCost = 0;

    for (const entry of ctx.sessionManager.getBranch()) {
      if (entry.type !== "message") continue;
      const msg = entry.message;

      if (msg.role === "assistant") {
        turns++;
        if (msg.usage) {
          totalTokens += msg.usage.totalTokens ?? 0;
          // totalCost += msg.usage.cost?.total ?? 0;
        }
        if (Array.isArray(msg.content)) {
          for (const part of msg.content) {
            if (part.type === "toolCall") toolCalls++;
          }
        }
      } else if (msg.role === "toolResult") {
        toolResults++;
      }
    }

    updateStatus(ctx);
  });

  // Update on each turn end
  pi.on("turn_end", async (event, ctx) => {
    turns++;
    if (event.message?.usage) {
      totalTokens += event.message.usage.totalTokens ?? 0;
      // totalCost += event.message.usage.cost?.total ?? 0;
    }
    if (Array.isArray(event.message?.content)) {
      for (const part of event.message.content) {
        if ((part as any).type === "toolCall") toolCalls++;
      }
    }
    if (event.toolResults) {
      toolResults += event.toolResults.length;
    }
    updateStatus(ctx);
  });
}
