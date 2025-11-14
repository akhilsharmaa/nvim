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
		opts = {

			-- Sync current file and cwd behavior
			filesystem = {
				follow_current_file = {
					enabled = true, -- highlight and sync with current file
					leave_dirs_open = false,
				},

				use_libuv_file_watcher = true, -- auto-refresh
				filtered_items = {
					hide_dotfiles = false, -- show dotfiles like your old config
				},

				group_empty_dirs = true, -- like nvim-tree group_empty
			},

			-- Git integration
			default_component_configs = {
				git_status = {
					symbols = {
						added = '✚',
						modified = '',
						deleted = '✖',
						renamed = '',
						untracked = '',
						ignored = '◌',
						unstaged = '✗',
						staged = '✓',
						conflict = '',
					},
				},

				-- Indent + icons
				indent = {
					indent_size = 1,
					with_markers = true, -- indent_markers.enable = true
				},

				icon = {
					folder_closed = '',
					folder_open = '',
					folder_empty = '',
				},

				diagnostics = {
					enabled = true,
					symbols = {
						hint = '',
						info = '',
						warn = '',
						error = '',
					},
				},
			},

			-- Window options (replaces nvim-tree.view)
			window = {
				position = 'left',
				width = 30,
				auto_expand_width = true, -- behaves similar to adaptive_size
			},

			-- Behavior similar to nvim-tree.actions.open_file
			open_files_do_not_replace_types = { 'terminal', 'Trouble', 'qf' },
		},
	},
}
