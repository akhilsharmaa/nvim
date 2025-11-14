return {
  'akinsho/toggleterm.nvim',
  version = '*',
  cmd = 'ToggleTerm',
  keys = {
    { '<C-/>', '<cmd>ToggleTerm<cr>', desc = 'Toggle Terminal', mode = { 'n', 'i', 't' } },
    { '<leader>t_', '<cmd>ToggleTerm size=15 direction=horizontal<cr>', desc = 'Terminal Horizontal' },
    { '<leader>t|', '<cmd>ToggleTerm size=80 direction=vertical<cr>', desc = 'Terminal Vertical' },
    { '<leader>tf', '<cmd>ToggleTerm direction=float<cr>', desc = 'Terminal Float' },
  },
  opts = {
    size = 20,
    open_mapping = [[<C-/>]],
    hide_numbers = true,
    shade_terminals = true,
    start_in_insert = true,
    insert_mappings = true,
    terminal_mappings = true,
    persist_size = true,
    direction = 'float',
    close_on_exit = true,
    shell = vim.o.shell,
    float_opts = {
      border = 'curved',
    },
  },
}
