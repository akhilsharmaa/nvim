return {
  'folke/trouble.nvim',
  opts = {
    -- Add border to the Trouble window
    win = {
      border = 'single', -- Options: "single", "double", "rounded", "solid", "shadow", or custom
      -- You can also specify only top border
      -- border = { "─", "─", "─", "─", "", "", "", "" },
    },
  },
  config = function(_, opts)
    require('trouble').setup(opts)
    -- Change Trouble window background color
    vim.api.nvim_set_hl(0, 'TroubleNormal', { bg = '#141414' })
    vim.api.nvim_set_hl(0, 'TroubleNormalNC', { bg = '#141414' }) -- NC = Not Current (unfocused)
    -- Customize border color
    -- vim.api.nvim_set_hl(0, "TroubleBorder", { fg = "#7aa2f7", bg = "#1a1b26" })
    -- Optional: Change diagnostics line backgrounds
    vim.api.nvim_set_hl(0, 'TroubleError', { fg = '#f38ba8', bg = '#2d1b1b' })
    vim.api.nvim_set_hl(0, 'TroubleWarning', { fg = '#fab387', bg = '#2d2416' })
    vim.api.nvim_set_hl(0, 'TroubleInformation', { fg = '#89dceb', bg = '#162b33' })
    vim.api.nvim_set_hl(0, 'TroubleHint', { fg = '#94e2d5', bg = '#162d2a' })
  end,
  cmd = 'Trouble',
  keys = {
    {
      '<leader>da',
      '<cmd>Trouble diagnostics toggle<cr>',
      desc = 'Diagnostics (Trouble)',
    },
    {
      '<leader>dX',
      '<cmd>Trouble diagnostics toggle filter.buf=0<cr>',
      desc = 'Buffer Diagnostics (Trouble)',
    },
    {
      '<leader>ds',
      '<cmd>Trouble symbols toggle focus=false<cr>',
      desc = 'Symbols (Trouble)',
    },
    {
      '<leader>dl',
      '<cmd>Trouble lsp toggle focus=false win.position=right<cr>',
      desc = 'LSP Definitions / references / ... (Trouble)',
    },
    {
      '<leader>dL',
      '<cmd>Trouble loclist toggle<cr>',
      desc = 'Location List (Trouble)',
    },
    {
      '<leader>dQ',
      '<cmd>Trouble qflist toggle<cr>',
      desc = 'Quickfix List (Trouble)',
    },
  },
}
