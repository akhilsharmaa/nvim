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

  -- clean up output
  result = result:gsub('\n', ''):gsub('%.git$', '')

  -- convert ssh form "git@github.com:user/repo" → "github.com/user/repo"
  result = result:gsub('^git@([^:]+):', 'https://%1/')

  -- extract domain and user/repo
  local domain = result:match 'https?://([^/]+)/' or result:match '([^/]+)/'
  local repo = result:match 'https?://[^/]+/(.+)' or result:match '[^/]+/(.+)'

  if not repo then
    return ''
  end

  -- determine icon based on domain
  local icon
  if domain then
    if domain:match 'github%.com' then
      icon = ' ' -- github icon
    elseif domain:match 'gitlab%.com' then
      icon = ' ' -- gitlab icon
    elseif domain:match 'codeberg%.org' then
      icon = ' '
    else
      icon = ' ' -- generic git icon
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
  local client_names = {}
  for _, client in ipairs(clients) do
    table.insert(client_names, client.name)
  end
  return '󰒋 ' .. table.concat(client_names, ', ')
end

return {
  'nvim-lualine/lualine.nvim',
  lazy = false,
  opts = {
    options = {
      theme = 'onedark',
      component_separators = { left = '|', right = '|' },
      section_separators = { left = '', right = '' },
      globalstatus = true,
      disabled_filetypes = {
        statusline = { 'neo-tree', 'NvimTree', 'Outline', 'aerial' },
        winbar = {},
      },
    },
    sections = {
      lualine_a = { 'mode' },
      lualine_b = {
        'branch',
        'diagnostics',
      },
      lualine_c = {
        'diff',
      },
      lualine_x = {
        lsp,
      },
      lualine_y = {
        git_remote_repo,
        -- Supermaven status component with click to toggle
        {

          function()
            local api = require 'supermaven-nvim.api'
            if api.is_running() then
              return 'ai  '
            else
              return 'ai  '
            end
          end,
          -- color = function()
          --   local api = require("supermaven-nvim.api")
          --   if api.is_running() then
          --     return { fg = "#5170ff", gui = "bold" }
          --   else
          --     return { fg = "#808080", gui = "bold" }
          --   end
          -- end,
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
    refresh = {
      statusline = 1000,
      tabline = 1000,
      winbar = 1000,
      refresh_time = 16,
      events = {
        'winenter',
        'bufenter',
        'bufwritepost',
        'sessionloadpost',
        'filechangedshellpost',
        'vimresized',
        'filetype',
        'cursormoved',
        'cursormovedi',
        'modechanged',
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
    -- Remove winbar sections - let dropbar handle this
    winbar = {},
    inactive_winbar = {},
    extensions = { 'quickfix', 'fzf' },
  },
}
