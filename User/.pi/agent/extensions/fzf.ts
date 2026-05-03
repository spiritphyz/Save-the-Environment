import type { ExtensionAPI } from '@mariozechner/pi-coding-agent';

/* Prevent shell injection when passing pattern to rg.
 * Base64 only outputs [A-Za-z0-9+/=]
 * Values decoded back with base64 -d in subshells.
 */

export default function (pi: ExtensionAPI) {
  pi.registerTool({
    name: 'find',
    description: 'Safely find files by fuzzy matching using ripgrep and fzf',
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
    async execute(_toolCallId: string, { pattern, path }: { pattern: string; path?: string }) {
      const dir = path ?? '.';
      const b64Pattern = Buffer.from(pattern).toString('base64');
      const b64Dir = Buffer.from(dir).toString('base64');
      const { stdout, stderr } = await pi.exec('bash', ['-c',
        `cd "$(printf '%s' '${b64Dir}' | base64 -d)" && rg --files --hidden --no-follow --glob '!{**/node_modules/*,**/.git/*,**/dist/*,**/cache/*,**/storage/*,**/*.DS_Store}' | fzf --filter="$(printf '%s' '${b64Pattern}' | base64 -d)"`
      ]);
      return stdout || stderr || 'No matches found.';
    },
  });
}
