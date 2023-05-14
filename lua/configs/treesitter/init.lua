require'nvim-treesitter.configs'.setup {
  ensure_installed = {"go", "ruby", "javascript", "typescript", "lua" },

  sync_install = false,

  auto_install = true,

  highlight = {
    enable = true,
  },
}
