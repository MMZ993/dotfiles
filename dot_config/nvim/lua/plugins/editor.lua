return {
  -- fzf integration for telescope (faster fuzzy finder)
  {
    "nvim-telescope/telescope-fzf-native.nvim",
    build = "make",
  },

  -- Lazygit integration
  {
    "kdheepak/lazygit.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    opts = {},
    keys = {
      {
        "<leader>gg",
        "<cmd>LazyGit<cr>",
        desc = "Lazygit",
      },
    },
  },
}
