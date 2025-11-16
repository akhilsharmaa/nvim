-- plugins/cmp.lua
-- NvChad/LazyVim style completion configuration

return {
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
}
