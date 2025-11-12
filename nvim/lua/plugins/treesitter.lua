return {
  "nvim-treesitter/nvim-treesitter",
  opts = {
    -- Ensure these parsers are installed or add your own
    ensure_installed = { "c", "lua", "vim", "vimdoc", "yaml", "html", "json", "python", "powershell", "bash", "cpp" },
    highlight = {
      enable = true,
      -- additional_vim_regex_highlighting = false,
    },
    indent = {
      enable = true,
    },
    -- You can enable other features here, like folds
    folds = { enable = true },
  },
  -- This ensures the parsers are installed when plugins are installed.
  build = ":TSUpdate",
}
