local M = {
  'akinsho/bufferline.nvim',
  version = '*',
  event = 'VeryLazy',
  dependencies = 'nvim-tree/nvim-web-devicons',
}

function M.config()
  require('bufferline').setup {
    options = {
      mode = 'buffers',
      themable = true,
      numbers = 'none',
      close_command = 'bdelete! %d',
      right_mouse_command = 'bdelete! %d',
      left_mouse_command = 'buffer %d',
      middle_mouse_command = nil,

      -- Diagnostics
      diagnostics = 'nvim_lsp',
      diagnostics_update_in_insert = false,
      diagnostics_indicator = function(count, level)
        local icon = level:match 'error' and ' ' or ' '
        return ' ' .. icon .. count
      end,

      -- Styling
      separator_style = 'thick',
      indicator = {
        icon = '▎',
        style = 'icon',
      },

      -- Icons
      buffer_close_icon = '󰅖',
      modified_icon = '●',
      close_icon = '',
      left_trunc_marker = '',
      right_trunc_marker = '',
      show_buffer_close_icons = true,
      show_close_icon = false,
      show_tab_indicators = true,
      show_duplicate_prefix = true,
      color_icons = true,

      -- Sizing
      max_name_length = 20,
      max_prefix_length = 15,
      tab_size = 20,
      truncate_names = true,

      -- Behavior
      persist_buffer_sort = true,
      always_show_bufferline = true,
      sort_by = 'insert_after_current',

      -- File tree offset - this prevents tabs from overlapping
      offsets = {
        {
          filetype = 'neo-tree',
          text = function()
            return ''
          end,
          padding = 0,
        },
        {
          filetype = 'NvimTree',
          text = function()
            return ''
          end,
          padding = 0,
        },
      },

      -- Custom filter to hide certain buffers
      custom_filter = function(buf_number)
        -- Hide quickfix and help buffers from bufferline
        local buftype = vim.fn.getbufvar(buf_number, '&buftype')
        if buftype == 'quickfix' or buftype == 'help' then
          return false
        end
        return true
      end,
    },

    highlights = {
      fill = {
        bg = {
          attribute = 'bg',
          highlight = 'Normal',
        },
      },
    },
  }
end

M.keys = {
  -- Navigation
  { '<Tab>', '<cmd>BufferLineCycleNext<CR>', desc = 'Next buffer' },
  { '<S-Tab>', '<cmd>BufferLineCyclePrev<CR>', desc = 'Prev buffer' },
  { ']b', '<cmd>BufferLineCycleNext<CR>', desc = 'Next buffer' },
  { '[b', '<cmd>BufferLineCyclePrev<CR>', desc = 'Prev buffer' },

  -- Buffer management
  { '<leader>bc', '<cmd>bdelete<CR>', desc = 'Close buffer' },
  { '<leader>bC', '<cmd>bdelete!<CR>', desc = 'Force close buffer' },
  { '<leader>bp', '<cmd>BufferLineTogglePin<CR>', desc = 'Toggle pin' },
  { '<leader>bP', '<cmd>BufferLineGroupClose ungrouped<CR>', desc = 'Delete non-pinned buffers' },

  -- Close groups
  { '<leader>bl', '<cmd>BufferLineCloseLeft<CR>', desc = 'Close all to the left' },
  { '<leader>br', '<cmd>BufferLineCloseRight<CR>', desc = 'Close all to the right' },
  { '<leader>bo', '<cmd>BufferLineCloseOthers<CR>', desc = 'Close other buffers' },

  -- Pick/Navigate
  { '<leader>bb', '<cmd>BufferLinePick<CR>', desc = 'Pick buffer' },
  { '<leader>bd', '<cmd>BufferLinePickClose<CR>', desc = 'Pick close' },

  -- Move buffers
  { '<leader>bmn', '<cmd>BufferLineMoveNext<CR>', desc = 'Move buffer next' },
  { '<leader>bmp', '<cmd>BufferLineMovePrev<CR>', desc = 'Move buffer prev' },

  -- Sorting
  { '<leader>bse', '<cmd>BufferLineSortByExtension<CR>', desc = 'Sort by extension' },
  { '<leader>bsd', '<cmd>BufferLineSortByDirectory<CR>', desc = 'Sort by directory' },
}

return M
