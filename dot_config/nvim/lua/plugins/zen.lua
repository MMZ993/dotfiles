return {
  {
    "folke/zen-mode.nvim",
    cmd = "ZenMode",
    opts = {
      window = {
        width = 120, -- width of the maximum number of characters of a container
        options = {
          number = false, -- disable number column
          relativenumber = false, -- disable relative numbers
          cursorline = false, -- disable cursorline
          cursorcolumn = false, -- disable cursor column
          foldcolumn = "0", -- disable fold column
          list = false, -- disable whitespace characters
        },
      },
      plugins = {
        -- disable some other plugins when Zen Mode is opened
        options = {
          enabled = true,
          ruler = false, -- disables the ruler text in the last line of the screen
          showcmd = false, -- disables the command in the last line of the screen
        },
        twilight = { enabled = true }, -- enable twilight (dims inactive portions)
        gitsigns = { enabled = false }, -- disables gitsigns
        tmux = { enabled = false }, -- disables the tmux statusline
      },
    },
    keys = {
      { "<leader>uz", "<cmd>ZenMode<cr>", desc = "Zen Mode" },
    },
  },
  {
    "folke/twilight.nvim",
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
    },
  },
}
