return {
  'nvim-flutter/flutter-tools.nvim',
  lazy = false,
  dependencies = {
    'nvim-lua/plenary.nvim',
    'stevearc/dressing.nvim',
  },
  config = function()
    require('flutter-tools').setup {
      ui = {
        border = 'rounded',
        notification_style = 'plugin',
      },
      decorations = {
        statusline = {
          app_version = true,
          device = true,
          project_config = true,
        },
      },
      outline = {
        open_cmd = string.format('vertical %dvnew', math.floor(vim.o.columns * 0.25)), -- 30% of screen width
        auto_open = false,
      },
      lsp = {
        settings = {
          showTodos = true,
          completeFunctionCalls = true,
          enableSnippets = true,
          updateImportsOnRename = true,
        },
      },
      dev_log = {
        enabled = true,
        filter = nil,
        notify_errors = true,
        open_cmd = '7split',
        focus_on_open = false,
        log_prefix = '', -- Add this to remove the prefix
        line_numbers = false, -- Add this line to hide line numbers
      },
    }

    -- Modern which-key configuration using vim.keymap.set with desc
    vim.keymap.set('n', '<leader>F', '<cmd>📱Flutter<cr>', { desc = '📱Flutter Tools' })
    vim.keymap.set('n', '<leader>Fr', '<cmd>FlutterRun<cr>', { desc = 'Flutter: Run App' })
    vim.keymap.set('n', '<leader>Fq', '<cmd>FlutterQuit<cr>', { desc = 'Flutter: Quit App' })
    vim.keymap.set('n', '<leader>FR', '<cmd>FlutterRestart<cr>', { desc = 'Flutter: Restart App' })
    vim.keymap.set('n', '<leader>Fh', '<cmd>FlutterReload<cr>', { desc = 'Flutter: Hot Reload' })
    vim.keymap.set('n', '<leader>Fd', '<cmd>FlutterDevices<cr>', { desc = 'Flutter: Show Devices' })
    vim.keymap.set('n', '<leader>Fe', '<cmd>FlutterEmulators<cr>', { desc = 'Flutter: Launch Emulators' })
    vim.keymap.set('n', '<leader>Fo', '<cmd>FlutterOutlineToggle<cr>', { desc = 'Flutter: Toggle Outline' })
    vim.keymap.set('n', '<leader>Fl', '<cmd>FlutterLogClear<cr>', { desc = 'Flutter: Clear Logs' })
    vim.keymap.set('n', '<leader>Ft', '<cmd>FlutterDevTools<cr>', { desc = 'Flutter: Open DevTools' })
    vim.keymap.set('n', '<leader>Fp', '<cmd>FlutterPubGet<cr>', { desc = 'Flutter: Pub Get' })
    vim.keymap.set('n', '<leader>Fu', '<cmd>FlutterPubUpgrade<cr>', { desc = 'Flutter: Pub Upgrade' })
    vim.keymap.set('n', '<leader>Fc', '<cmd>FlutterCopyProfilerUrl<cr>', { desc = 'Flutter: Copy Profiler URL' })
  end,
}
