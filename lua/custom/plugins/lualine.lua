-- git utility functions
local function get_git_ahead_behind()
  local handle = io.popen 'git rev-list --count --left-right @{upstream}...head 2>/dev/null'
  if handle then
    local result = handle:read '*a'
    handle:close()
    if result and result ~= '' then
      local behind, ahead = result:match '(%d+)%s+(%d+)'
      if behind and ahead then
        local status = ''
        if tonumber(ahead) > 0 then
          status = status .. '↑' .. ahead
        end
        if tonumber(behind) > 0 then
          status = status .. '↓' .. behind
        end
        return status ~= '' and status or ''
      end
    end
  end
  return nil
end

local function git_remote_repo()
  local handle = io.popen 'git remote get-url origin 2>/dev/null'
  if not handle then
    return ''
  end
  local result = handle:read '*a' or ''
  handle:close()

  result = result:gsub('\n', ''):gsub('%.git$', '')
  result = result:gsub('^git@([^:]+):', 'https://%1/')

  local domain = result:match 'https?://([^/]+)/' or result:match '([^/]+)/'
  local repo = result:match 'https?://[^/]+/(.+)' or result:match '[^/]+/(.+)'
  if not repo then
    return ''
  end

  local icon
  if domain then
    if domain:match 'github%.com' then
      icon = ' '
    elseif domain:match 'gitlab%.com' then
      icon = ' '
    elseif domain:match 'codeberg%.org' then
      icon = ' '
    else
      icon = ' '
    end
  else
    icon = ' '
  end

  return icon .. repo
end

local function lsp()
  local clients = vim.lsp.get_clients { bufnr = 0 }
  if #clients == 0 then
    return '󰒏 '
  end
  local names = {}
  for _, client in ipairs(clients) do
    table.insert(names, client.name)
  end
  return '󰒋 ' .. table.concat(names, ', ')
end

return {
  'nvim-lualine/lualine.nvim',
  lazy = false,
  opts = {
    options = {
      theme = 'onedark',
      component_separators = { left = '', right = '' },
      section_separators = { left = '', right = '' },
      globalstatus = true,
      disabled_filetypes = {
        statusline = { 'neo-tree', 'NvimTree', 'Outline', 'aerial' },
      },
    },

    sections = {
      -- EVIL MODE BLOCK
      lualine_a = {
        {
          'mode',
          color = function()
            local mode = vim.fn.mode()
            local colors = {
              n = { fg = '#000000', bg = '#e06c75' },
              i = { fg = '#000000', bg = '#98c379' },
              v = { fg = '#000000', bg = '#61afef' },
              V = { fg = '#000000', bg = '#61afef' },
              [''] = { fg = '#000000', bg = '#61afef' },
              c = { fg = '#000000', bg = '#c678dd' },
              R = { fg = '#000000', bg = '#d19a66' },
            }
            return colors[mode] or { fg = '#000000', bg = '#5c6370' }
          end,

          use_mode_colors = false,
          padding = { left = 1, right = 1 },
        },
      },

      lualine_b = {
        'branch',
        get_git_ahead_behind,
        'diff',
        'diagnostics',
      },

      lualine_c = {
        git_remote_repo,
      },

      lualine_x = {
        lsp,
      },

      lualine_y = {
        {
          function()
            local api = require 'supermaven-nvim.api'
            if api.is_running() then
              return 'ai  '
            else
              return 'ai  '
            end
          end,
          on_click = function()
            local api = require 'supermaven-nvim.api'
            if api.is_running() then
              api.stop()
              vim.notify('Supermaven stopped', vim.log.levels.INFO)
            else
              api.start()
              vim.notify('Supermaven started', vim.log.levels.INFO)
            end
          end,
        },
      },

      lualine_z = {
        'location',
      },
    },

    inactive_sections = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = { 'filename' },
      lualine_x = { 'location' },
      lualine_y = {},
      lualine_z = {},
    },

    winbar = {},
    inactive_winbar = {},
    extensions = { 'quickfix', 'fzf' },
  },
}
