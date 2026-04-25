import type { ExtensionAPI } from "@mariozechner/pi-coding-agent";

export default function (pi: ExtensionAPI) {
 pi.registerTool({
	 name: "grep",
	 description: "Search file contents using ripgrep (rg). Fast recursive search with regex support.",
	 parameters: {
		 type: "object",
		 properties: {
			 pattern: { type: "string", description: "Search pattern (regex)" },
			 path: { type: "string", description: "Directory or file to search (default: current dir)" },
			 flags: { type: "string", description: "Additional rg flags, e.g. '-i' for case-insensitive, '-l' for files only" },
		 },
		 required: ["pattern"],
	 },
	 async execute({ pattern, path, flags }) {
		 const args = ["rg", "--color=always", flags || "", pattern, path || "."].filter(Boolean).join(" ");
		 const { stdout, stderr } = await pi.bash(args);
		 return stdout || stderr || "No matches found.";
	 },
 });
}
