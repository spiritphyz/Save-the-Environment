import type { ExtensionAPI } from "@mariozechner/pi-coding-agent";
import { Type } from "typebox";
import {
  truncateHead,
  DEFAULT_MAX_BYTES,
  DEFAULT_MAX_LINES,
} from "@mariozechner/pi-coding-agent";

export default function (pi: ExtensionAPI) {
  pi.registerTool({
    name: "grep",
    label: "Grep",
    description: "Safely search file contents using rg. Args passed as an array, so shell never evaluates a string. 'rm -rf' is a literal regex string, not interpreted. 'cat /etc/passwd' is a literal path, so rg never finds it.",
    parameters: Type.Object({
      pattern: Type.String({ description: "Search pattern (regex)" }),
      path: Type.Optional(Type.String({ description: "Directory or file to search (default: current dir)" })),
      flags: Type.Optional(Type.String({ description: "Additional rg flags, e.g. '-i' for case-insensitive, '-l' for files only" })),
    }),

    async execute(toolCallId, params, signal, onUpdate, ctx) {
      // Build argument array — NO string joining, NO shell interpretation
      const args = [
        "--color=never",											// No ANSI codes needed without shell.
        ...(params.flags
          ? params.flags.trim().split(/\s+/)  // Split flags safely.
          : []),                              // rg rejects unknown args.
        params.pattern,												// Passed as a literal string to rg.
        params.path ?? ".",										// Passed as a literal string to rg.
      ];

      const result = await pi.exec("rg", args, { signal });

      const raw = result.stdout || result.stderr || "";
      if (!raw.trim()) return {
        content: [{ type: "text", text: "No matches found." }],
        details: {},
      };

      const truncation = truncateHead(raw, {
        maxLines: DEFAULT_MAX_LINES,
        maxBytes: DEFAULT_MAX_BYTES,
      });

      const text = truncation.truncated
        ? `${truncation.content}\n\n[Output truncated: ${truncation.outputLines}/${truncation.totalLines} lines shown]`
        : truncation.content;

      return {
        content: [{ type: "text", text }],
        details: {},
      };
    },
  });
}
