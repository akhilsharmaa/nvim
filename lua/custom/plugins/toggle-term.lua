return {

  'akinsho/toggleterm.nvim',
  version = '*',
  cmd = 'ToggleTerm',

  keys = {
    { '<C-/>', '<cmd>ToggleTerm<cr>', desc = 'Toggle Terminal', mode = { 'n', 'i', 't' } },
    { '<leader>t_', '<cmd>ToggleTerm size=15 direction=horizontal<cr>', desc = 'Terminal Horizontal' },
    { '<leader>t|', '<cmd>ToggleTerm size=80 direction=vertical<cr>', desc = 'Terminal Vertical' },
    { '<leader>tf', '<cmd>ToggleTerm direction=float<cr>', desc = 'Terminal Float' },
    {
      '<leader>tg',
      function()
        _LAZYGIT_TOGGLE()
      end,
      desc = 'LazyGit',
    },
    {
      '<leader>tn',
      function()
        _NODE_TOGGLE()
      end,
      desc = 'Node REPL',
    },
    {
      '<leader>tp',
      function()
        _PYTHON_TOGGLE()
      end,
      desc = 'Python REPL',
    },
    {
      '<leader>th',
      function()
        _HTOP_TOGGLE()
      end,
      desc = 'Htop',
    },
  },

  opts = {
    size = function(term)
      if term.direction == 'horizontal' then
        return 15
      elseif term.direction == 'vertical' then
        return vim.o.columns * 0.4
      end
      return 20
    end,

    open_mapping = [[<C-/>]],
    hide_numbers = true,
    shade_terminals = true,
    shading_factor = -30,
    start_in_insert = true,
    insert_mappings = true,
    terminal_mappings = true,
    persist_size = true,
    persist_mode = true,
    direction = 'float',
    close_on_exit = true,
    shell = vim.o.shell,
    auto_scroll = true,

    float_opts = {
      border = 'curved',
      width = function()
        return math.floor(vim.o.columns * 0.85)
      end,
      height = function()
        return math.floor(vim.o.lines * 0.8)
      end,
      -- winblend = 20, -- more opaque
      title_pos = 'center',
    },

    highlights = {
      Normal = { guibg = '#181818' },
      NormalFloat = { guibg = '#181818' },
      FloatBorder = { guifg = '#6e6e6e', guibg = '#181818', style = 'bold' },
    },

    winbar = {
      enabled = true,
      name_formatter = function(term)
        return string.format('  Terminal #%d ', term.id)
      end,
    },
  },

  config = function(_, opts)
    require('toggleterm').setup(opts)
    local Terminal = require('toggleterm.terminal').Terminal

    -- LazyGit
    local lazygit = Terminal:new {
      cmd = 'lazygit',
      dir = 'git_dir',
      direction = 'float',
      float_opts = {
        border = 'curved',
        width = function()
          return math.floor(vim.o.columns * 0.9)
        end,
        height = function()
          return math.floor(vim.o.lines * 0.9)
        end,
        winblend = 0,
      },
      on_open = function(term)
        vim.cmd 'startinsert!'
        vim.api.nvim_buf_set_keymap(term.bufnr, 'n', 'q', '<cmd>close<CR>', { noremap = true, silent = true })
      end,
    }
    function _LAZYGIT_TOGGLE()
      lazygit:toggle()
    end

    -- Node REPL
    local node = Terminal:new {
      cmd = 'node',
      direction = 'float',
      float_opts = { border = 'curved', winblend = 0 },
    }
    function _NODE_TOGGLE()
      node:toggle()
    end

    -- Python REPL
    local python = Terminal:new {
      cmd = 'python3',
      direction = 'float',
      float_opts = { border = 'curved', winblend = 0 },
    }
    function _PYTHON_TOGGLE()
      python:toggle()
    end

    -- Htop
    local htop = Terminal:new {
      cmd = 'htop',
      direction = 'float',
      float_opts = {
        border = 'curved',
        width = function()
          return math.floor(vim.o.columns * 0.9)
        end,
        height = function()
          return math.floor(vim.o.lines * 0.9)
        end,
        winblend = 0,
      },
    }
    function _HTOP_TOGGLE()
      htop:toggle()
    end

    -- Better terminal navigation
    function _G.set_terminal_keymaps()
      local o = { buffer = 0, noremap = true, silent = true }
      vim.keymap.set('t', '<esc><esc>', [[<C-\><C-n>]], o)
      vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], o)
      vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], o)
      vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], o)
      vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], o)
      vim.keymap.set('t', '<C-w>', [[<C-\><C-n><C-w>]], o)
    end

    vim.cmd 'autocmd! TermOpen term://* lua set_terminal_keymaps()'
  end,
}
