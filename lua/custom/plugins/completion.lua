-- plugins/cmp.lua
-- NvChad/LazyVim style completion configuration

return {
	{
		'hrsh7th/nvim-cmp',
		event = 'InsertEnter',
		dependencies = {
			'hrsh7th/cmp-nvim-lsp',
			'hrsh7th/cmp-buffer',
			'hrsh7th/cmp-path',
			'L3MON4D3/LuaSnip',
			'saadparwaiz1/cmp_luasnip',
		},
		config = function()
			local cmp = require('cmp')
			local luasnip = require('luasnip')

			cmp.setup({
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},

				completion = {
					completeopt = 'menu,menuone,noinsert',
				},

				preselect = cmp.PreselectMode.Item,

				mapping = cmp.mapping.preset.insert({
					-- Ctrl+Space to trigger completion manually
					['<C-Space>'] = cmp.mapping.complete(),

					-- Tab to navigate forward
					['<Tab>'] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_next_item()
						elseif luasnip.expand_or_jumpable() then
							luasnip.expand_or_jump()
						else
							fallback()
						end
					end, { 'i', 's' }),

					-- Shift-Tab to navigate backward
					['<S-Tab>'] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_prev_item()
						elseif luasnip.jumpable(-1) then
							luasnip.jump(-1)
						else
							fallback()
						end
					end, { 'i', 's' }),

					-- Enter confirms selected item (now auto-selects first)
					['<CR>'] = cmp.mapping.confirm({
						behavior = cmp.ConfirmBehavior.Replace,
						select = true, -- Auto-select first item
					}),

					-- Ctrl+e to close completion menu
					['<C-e>'] = cmp.mapping.abort(),

					-- Scroll documentation window
					['<C-b>'] = cmp.mapping.scroll_docs(-4),
					['<C-f>'] = cmp.mapping.scroll_docs(4),
				}),

				sources = cmp.config.sources({
					{ name = 'nvim_lsp' },
					{ name = 'luasnip' },
					{ name = 'path' },
				}, {
					{ name = 'buffer' },
				}),

				-- Optional: Disable auto-popup (uncomment to enable)
				-- completion = {
				--   autocomplete = false,
				-- },

				-- Optional: Add borders to completion window
				window = {
					completion = cmp.config.window.bordered(),
					documentation = cmp.config.window.bordered(),
				},

				-- Optional: Format completion items
				formatting = {
					format = function(entry, vim_item)
						vim_item.menu = ({
							nvim_lsp = '[LSP]',
							luasnip = '[Snip]',
							buffer = '[Buf]',
							path = '[Path]',
						})[entry.source.name]
						return vim_item
					end,
				},
			})
		end,
	},

	{
		'ray-x/lsp_signature.nvim',
		event = 'VeryLazy',
		opts = {
			bind = true, -- This is mandatory, otherwise border config won't get registered
			handler_opts = {
				border = 'rounded' -- Border style: 'rounded', 'single', 'double', 'shadow'
			},

			-- Floating window settings
			floating_window = true, -- Show signature in floating window
			floating_window_above_cur_line = true, -- Position window above current line
			floating_window_off_x = 1, -- Horizontal offset
			floating_window_off_y = 0, -- Vertical offset

			-- Hint settings (virtual text)
			hint_enable = false, -- Show hint inline as virtual text

			-- Highlighting
			hi_parameter = 'LspSignatureActiveParameter', -- Highlight current parameter

			-- Auto-trigger settings
			auto_close_after = nil, -- Auto close after x seconds (nil = don't auto close)
			extra_trigger_chars = {}, -- Extra characters to trigger signature help

			-- Keybindings
			toggle_key = '<C-k>', -- Toggle signature on/off (in insert mode)
			select_signature_key = '<M-n>', -- Cycle to next signature (if overloaded)

			-- Functionality
			always_trigger = false, -- Show signature when entering function args (can be noisy)
			doc_lines = 10, -- Max lines to show in documentation window
			max_height = 12, -- Max height of signature floating window
			max_width = 80, -- Max width of signature floating window

			-- Transparency
			transparency = nil, -- Set background transparency (0-100), nil = opaque

			-- Timer settings
			timer_interval = 200, -- Debounce timer in ms

			-- Decorations
			padding = ' ', -- Character to pad on left/right of signature
			zindex = 200, -- Z-index of floating window

			-- Advanced
			fix_pos = false, -- Keep window position fixed even when scrolling
			noice = false, -- Set to true if using noice.nvim
		},
		config = function(_, opts)
			require('lsp_signature').setup(opts)
		end
	}
}
