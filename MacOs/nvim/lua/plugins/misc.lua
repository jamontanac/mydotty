return {
  { "tpope/vim-surround" },
  { "tpope/vim-sleuth" },
  { "tpope/vim-repeat" },
  { "norcalli/nvim-colorizer.lua" },
  {
    "jiaoshijie/undotree",
    dependencies = "nvim-lua/plenary.nvim",
    config = true,
    keys = { -- load the plugin only when using it's keybinding:
      { "<leader>u", "<cmd>lua require('undotree').toggle()<cr>" },
    },
  },
}
