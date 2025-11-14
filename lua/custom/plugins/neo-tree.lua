return {
  {
    'nvim-neo-tree/neo-tree.nvim',
    branch = 'v3.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'MunifTanjim/nui.nvim',
      {
        'nvim-tree/nvim-web-devicons',
        config = function()
          require('nvim-web-devicons').setup()
        end,
        lazy = false,
      },
    },
    lazy = false,
    keys = {
      {
        '<leader>e',
        '<cmd>Neotree toggle<cr>',
        desc = 'Toggle Neo-tree',
      },
    },
  },
}
