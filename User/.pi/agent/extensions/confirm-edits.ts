/**
 * Confirm Edits Extension
 *
 * Prompts for confirmation before any file edit or write.
 */

import type { ExtensionAPI } from "@mariozechner/pi-coding-agent";

export default function (pi: ExtensionAPI) {
  pi.on("tool_call", async (event, ctx) => {
    if (event.toolName !== "edit" && event.toolName !== "write") return;
    if (!ctx.hasUI) return;

    const path = (event.input as any).path ?? "unknown";
    const ok = await ctx.ui.confirm(
      `✏️  ${event.toolName}`,
      `Allow ${event.toolName} to ${path}?`
    );

    if (!ok) {
      return { block: true, reason: "Blocked by user" };
    }
  });
}
