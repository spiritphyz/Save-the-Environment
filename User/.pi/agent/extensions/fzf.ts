import type { ExtensionAPI } from '@mariozechner/pi-coding-agent';

/* Preventing shell command injection when passing pattern to fzf.
 *
 * The cleanest way with pi.bash() is to Base64-encode the inputs so no shell
 * metacharacters ever appear in the command.
 *
 * Both pattern and path are now Base64-encoded in Node before being embedded in the command string.
 * Since Base64 output only contains [A-Za-z0-9+/=], it's completely safe inside single quotes —
 * no shell injection is possible regardless of what the input contains. The values are decoded back
 * at runtime via base64 -d in subshells.
 */

export default function (pi: ExtensionAPI) {
  pi.registerTool({
    name: 'find',
    description: 'Find files by name using fzf in non-interactive filter mode.',
    parameters: {
      type: 'object',
      properties: {
        pattern: { type: 'string', description: 'Fuzzy search pattern' },
        path: {
          type: 'string',
          description: 'Directory to search (default: current dir)',
        },
      },
      required: ['pattern'],
    },
    async execute({ pattern, path }) {
      const dir = path || '.';
      const b64Pattern = Buffer.from(pattern).toString('base64');
      const b64Dir = Buffer.from(dir).toString('base64');
      const { stdout, stderr } = await pi.bash(
        `cd "$(printf '%s' '${b64Dir}' | base64 -d)" && fzf --filter="$(printf '%s' '${b64Pattern}' | base64 -d)"`
      );
      return stdout || stderr || 'No matches found.';
    },
  });
}
