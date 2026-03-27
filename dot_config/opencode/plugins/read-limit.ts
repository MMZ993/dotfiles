import type { Plugin } from "@opencode-ai/plugin"

/**
 * Warns the agent before reading a large file without chunking.
 * Files over 2000 lines must be read with offset + limit to avoid silent truncation.
 */
export const ReadLimitPlugin: Plugin = async ({ $ }) => {
  return {
    "tool.execute.before": async (input, output) => {
      if (input.tool !== "read") return

      const filePath: string = output.args.filePath
      const limit: number | undefined = output.args.limit

      // Already chunking properly — let it through
      if (limit !== undefined && limit <= 2000) return

      let lineCount = 0
      try {
        const result = await $`wc -l < ${filePath}`.text()
        lineCount = parseInt(result.trim(), 10)
      } catch {
        // File unreadable or doesn't exist — let the read tool handle it
        return
      }

      if (lineCount > 2000) {
        throw new Error(
          `File "${filePath}" has ${lineCount} lines — reading it without a limit may silently truncate output at 2000 lines.\n` +
          `Read it in chunks instead:\n` +
          `  - First chunk:  offset=1,    limit=2000\n` +
          `  - Second chunk: offset=2001, limit=2000\n` +
          `  - … and so on until you reach line ${lineCount}.`,
        )
      }
    },
  }
}
