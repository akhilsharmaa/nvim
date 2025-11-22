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
			icon = ' '
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

return {

	-- Add nvim-web-devicons first
	{
		'nvim-tree/nvim-web-devicons',
		lazy = false,
		opts = {
			global = true,
		},
	},

	-- Add Kanagawa colorscheme as a dependency
	{
		'rebelot/kanagawa.nvim',
		lazy = false,
		priority = 1000,
		opts = {
			theme = 'wave',
		},
	},

	-- Heirline configuration
	{
		'rebelot/heirline.nvim',
		dependencies = {
			'nvim-tree/nvim-web-devicons',
			'rebelot/kanagawa.nvim',
		},
		event = 'UIEnter',
		opts = {
			global = true,
		},
		config = function()
			vim.o.laststatus = 3 -- enable global statusline

			local heirline = require 'heirline'
			local conditions = require 'heirline.conditions'
			local u = require 'heirline.utils'

			-- Setup Kanagawa colors
			local kanagawa = require('kanagawa.colors').setup { theme = 'wave' }
			local colors = kanagawa.palette
			heirline.load_colors(colors)

			local fn, api, bo = vim.fn, vim.api, vim.bo
			local neotest_ok, neotest = pcall(require, 'neotest')
			local grapple_ok, grapple = pcall(require, 'grapple')

			local winbar_inactive = {
				buftype = {
					'nofile',
					'terminal',
					'prompt',
					'help',
				},
				filetype = {
					'oil',
					'blame',
					'help',
				},
			}
			local ruler_inactive = {
				buftype = {
					'nofile',
					'terminal',
				},
				filetype = {
					'neotest-summary',
					'help',
					'dap-view-term',
				},
			}
			local dap_inactive = {
				filetype = {
					'dap-view-term',
				},
				buftype = {
					'nofile',
				},
			}
			local cmdtype_inactive = {
				':',
				'/',
				'?',
			}

			local Align = { provider = '%=' }
			local Space = { provider = ' ' }
			local LeftSep = { provider = '' }

			local GrappleBlock = {
				condition = function()
					return grapple_ok and grapple.exists()
				end,
				hl = {
					fg = colors.springBlue,
					italic = true,
				},
				provider = function()
					local s = vim.g.catgoose_grapple_scope
					local scope = s == 'git' and ' ' or s == 'git_branch' and ''
					return ('%s%s '):format(scope, grapple.statusline())
				end,
			}

			local NeoTestBlock = {
				condition = function()
					return neotest_ok and conditions.is_active() and #neotest.state.adapter_ids() > 0
				end,
				init = function(self)
					self.adapter_ids = neotest.state.adapter_ids()
					self.buffer = vim.api.nvim_get_current_buf()
				end,
			}
			local GitSourceControl = {
				init = function()
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
							icon = ' '
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

					return icon .. repo .. ' '
				end,
			}

			local NeoTest = {
				condition = function(self)
					local status = neotest.state.status_counts(self.adapter_ids[1],
						{ buffer = self.buffer })
					return status
				end,
				init = function(self)
					self.status = neotest.state.status_counts(self.adapter_ids[1],
						{ buffer = self.buffer })
				end,
				static = {
					icon = {
						passed = ' ',
						failed = ' ',
						skipped = ' ',
						total = ' ',
					},
				},
				{
					condition = function(self)
						return self.status.total > 0
					end,
					init = function(self)
						self.adapter = vim.split(
							vim.split(self.adapter_ids[1], ':', { plain = true })[1],
							'neotest-',
							{ plain = true })[2]
					end,
					provider = function(self)
						return string.format('%s ', self.adapter)
					end,
					hl = {
						fg = colors.springViolet1,
						italic = true,
					},
					{
						{
							condition = function(self)
								return self.status.total > 0
							end,
							provider = function(self)
								return string.format('%s%s ', self.icon.total,
									self.status.total)
							end,
							hl = {
								fg = colors.springViolet2,
								italic = true,
							},
						},
						{
							provider = function(self)
								return string.format('%s%s ', self.icon.passed,
									self.status.passed)
							end,
							hl = function()
								local hl = u.get_highlight 'NeotestPassed'
								hl.italic = true
								return hl
							end,
						},
						{
							condition = function(self)
								return self.status.failed > 0
							end,
							provider = function(self)
								return string.format('%s%s ', self.icon.failed,
									self.status.failed)
							end,
							hl = function()
								local hl = u.get_highlight 'NeotestFailed'
								hl.italic = true
								return hl
							end,
						},
						{
							condition = function(self)
								return self.status.skipped > 0
							end,
							provider = function(self)
								return string.format('%s%s ', self.icon.skipped,
									self.status.skipped)
							end,
							hl = function()
								local hl = u.get_highlight 'NeotestSkipped'
								hl.italic = true
								return hl
							end,
						},
					},
				},
			}
			NeoTestBlock = u.insert(NeoTestBlock, NeoTest, Space)

			-- Winbar components
			local FileNameBlock = {
				condition = function()
					return #api.nvim_buf_get_name(0) > 0
				end,
				init = function(self)
					self.filename = api.nvim_buf_get_name(0)
					local ok, devicons = pcall(require, 'nvim-web-devicons')
					if ok then
						self.icon, self.icon_color = devicons.get_icon_color(self.filename,
							fn.fnamemodify(self.filename, ':e'), { default = true })
					else
						self.icon = ''
						self.icon_color = colors.fg
					end
				end,
				hl = function()
					if conditions.is_active() then
						return {
							bg = colors.sumiInk5,
						}
					else
						return {
							bg = colors.sumiInk4,
						}
					end
				end,
			}

			local FileIcon = {
				provider = function(self)
					return string.format('%s ', self.icon)
				end,
				hl = function(self)
					return {
						fg = self.icon_color,
					}
				end,
			}

			local FileName = {
				provider = function(self)
					local filename = fn.fnamemodify(self.filename, ':.')
					if not conditions.width_percent_below(#filename, 0.25) then
						filename = fn.pathshorten(filename, 3)
					end
					return filename
				end,
				hl = { fg = colors.oldWhite, bold = true },
			}

			local FileFlags = {
				{
					provider = function()
						if bo.modified then
							return '[+] '
						end
					end,
					hl = { fg = colors.oldWhite, bold = true, italic = true },
				},
				{
					provider = function()
						if not bo.modifiable or bo.readonly then
							return ' '
						end
					end,
					hl = { fg = colors.roninYellow, bold = true, italic = true },
				},
			}

			local FileNameModifer = {
				hl = function()
					if bo.modified then
						return { italic = true, force = true }
					end
				end,
			}

			local ActiveSep = {
				hl = function()
					if conditions.is_active() then
						return { fg = colors.sumiInk3 }
					else
						return { fg = colors.sumiInk1 }
					end
				end,
			}

			-- NvChad-inspired: Diagnostics summary in winbar
			local WinbarDiagnostics = {
				condition = conditions.has_diagnostics,
				init = function(self)
					self.errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
					self.warnings = #vim.diagnostic.get(0,
						{ severity = vim.diagnostic.severity.WARN })
				end,
				static = {
					error_icon = function()
						local sign = fn.sign_getdefined 'DiagnosticSignError'
						return (sign and sign[1] and sign[1].text) or 'E'
					end,
					warn_icon = function()
						local sign = fn.sign_getdefined 'DiagnosticSignWarn'
						return (sign and sign[1] and sign[1].text) or 'W'
					end,
				},
				{
					condition = function(self)
						return self.errors > 0
					end,
					provider = function(self)
						return string.format(' %s%s', self.error_icon(), self.errors)
					end,
					hl = u.get_highlight 'DiagnosticSignError',
				},
				{
					condition = function(self)
						return self.warnings > 0
					end,
					provider = function(self)
						return string.format(' %s%s', self.warn_icon(), self.warnings)
					end,
					hl = u.get_highlight 'DiagnosticSignWarn',
				},
			}

			FileNameBlock = u.insert(
				FileNameBlock,
				u.insert(ActiveSep, LeftSep),
				Space,
				unpack(FileFlags),
				u.insert(FileNameModifer, FileName, Space, FileIcon),
				{ provider = '%<' }
			)

			local DiagnosticsBlock = {
				condition = conditions.has_diagnostics,
				init = function(self)
					self.errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
					self.warnings = #vim.diagnostic.get(0,
						{ severity = vim.diagnostic.severity.WARN })
					self.hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
					self.infos = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
				end,
			}
			local Diagnostics = {
				static = {
					error_icon = function()
						local sign = fn.sign_getdefined 'DiagnosticSignError'
						return (sign and sign[1] and sign[1].text) or 'E'
					end,
					warn_icon = function()
						local sign = fn.sign_getdefined 'DiagnosticSignWarn'
						return (sign and sign[1] and sign[1].text) or 'W'
					end,
					info_icon = function()
						local sign = fn.sign_getdefined 'DiagnosticSignInfo'
						return (sign and sign[1] and sign[1].text) or 'I'
					end,
					hint_icon = function()
						local sign = fn.sign_getdefined 'DiagnosticSignHint'
						return (sign and sign[1] and sign[1].text) or 'H'
					end,
				},
				update = { 'DiagnosticChanged', 'BufEnter', 'WinEnter' },
				{
					hl = function()
						if conditions.is_active() then
							return {
								bg = colors.sumiInk3,
							}
						else
							return {
								bg = colors.sumiInk1,
							}
						end
					end,
				},
				{
					condition = function(self)
						return self.errors > 0
					end,
					provider = function(self)
						return string.format('%s%s ', self.error_icon(), self.errors)
					end,
					hl = u.get_highlight 'DiagnosticSignError',
				},
				{
					condition = function(self)
						return self.warnings > 0
					end,
					provider = function(self)
						return string.format('%s%s ', self.warn_icon(), self.warnings)
					end,
					hl = u.get_highlight 'DiagnosticSignWarn',
				},
				{
					condition = function(self)
						return self.infos > 0
					end,
					provider = function(self)
						return string.format('%s%s ', self.info_icon(), self.infos)
					end,
					hl = u.get_highlight 'DiagnosticSignInfo',
				},
				{
					condition = function(self)
						return self.hints > 0
					end,
					provider = function(self)
						return string.format('%s%s ', self.hint_icon(), self.hints)
					end,
					hl = u.get_highlight 'DiagnosticSignHint',
				},
				hl = function()
					if conditions.is_active() then
						return {
							bg = colors.sumiInk3,
						}
					else
						return {
							bg = colors.sumiInk1,
						}
					end
				end,
			}
			DiagnosticsBlock = u.insert(DiagnosticsBlock, Diagnostics, Space)

			local GitBlock = {
				condition = conditions.is_git_repo,
				init = function(self)
					self.status = vim.b.gitsigns_status_dict
					self.has_added = self.status.added and self.status.added > 0
					self.has_removed = self.status.removed and self.status.removed > 0
					self.has_changed = self.status.changed and self.status.changed > 0
					self.has_changes = self.has_added or self.has_removed or self.has_changed
				end,
			}
			local Git = {
				init = function(self)
					local max = 0.35 * vim.api.nvim_win_get_width(0)
					self.status.head = u.count_chars(self.status.head) < max and self.status.head or
					    string.format('%s...', string.sub(self.status.head, 1, max))
				end,
				{
					provider = function(self)
						return string.format('  %s ', self.status.head)
					end,
					hl = { fg = colors.springViolet1, bold = true, italic = true },
				},
				{
					condition = function(self)
						return self.has_added
					end,
					provider = function(self)
						return string.format('+%s ', self.status.added)
					end,
					hl = { fg = colors.autumnGreen, bold = true },
				},
				{
					condition = function(self)
						return self.has_removed
					end,
					provider = function(self)
						return string.format('+%s ', self.status.removed)
					end,
					hl = { fg = colors.autumnRed, bold = true },
				},
				{
					condition = function(self)
						return self.has_changed
					end,
					provider = function(self)
						return string.format('+%s ', self.status.changed)
					end,
					hl = { fg = colors.autumnYellow, bold = true },
				},
				{
					LeftSep,
					hl = function()
						if conditions.is_active() then
							return {
								bg = colors.sumiInk3,
								fg = colors.sumiInk5,
							}
						else
							return {
								fg = colors.sumiInk5,
								bg = colors.sumiInk1,
							}
						end
					end,
				},
				hl = { bg = colors.sumiInk5 },
			}
			GitBlock = u.insert(GitBlock, Git)

			local MacroRecordingBlock = {
				condition = conditions.is_active,
				init = function(self)
					self.register = fn.reg_recording()
				end,
			}
			local MacroRecording = {
				condition = function(self)
					return self.register ~= ''
				end,
				{
					condition = conditions.is_git_repo,
					LeftSep,
				},
				{
					provider = '  ',
					hl = { fg = colors.autumnRed },
				},
				{
					provider = function(self)
						return string.format('%s ', self.register)
					end,
					hl = { bold = true },
				},
				{
					LeftSep,
					hl = { bg = colors.sumiInk3, fg = colors.autumnYellow },
				},
				hl = { bg = colors.autumnYellow, fg = colors.sumiInk1 },
				update = { 'RecordingEnter', 'RecordingLeave' },
			}
			MacroRecordingBlock = u.insert(MacroRecordingBlock, MacroRecording)

			local RulerBlock = {
				condition = function()
					return conditions.is_active() and not conditions.buffer_matches(ruler_inactive)
				end,
			}
			local Ruler = {
				{
					provider = '%l/%L:%c%q',
					hl = {
						fg = colors.springViolet1,
					},
				},
			}
			RulerBlock = u.insert(RulerBlock, Ruler, Space)

			local QuickFixBlock = {
				init = function(self)
					self.quickfix = vim.fn.getqflist { all = 0 }
					self.filename = vim.fn.expand '%:.'
					self.uri = vim.uri_from_fname(vim.fn.expand '%:p')
				end,
				condition = function()
					local quickfix = vim.fn.getqflist { all = 0 }
					return conditions.is_active() and #quickfix.items > 0
				end,
				hl = { fg = colors.springViolet1, italic = true },
			}
			local QuickFix = {
				{
					provider = function(self)
						local idx = 1
						local found = false
						for i, item in ipairs(self.quickfix.items) do
							if item.user_data and item.user_data.uri == self.uri or item.text and item.text == self.filename then
								idx = i
								found = true
								break
							end
						end
						if not found then
							return
						end
						return string.format('%s %s:(%s/%s) ', self.quickfix.nr,
							self.quickfix.title, idx, self.quickfix.size)
					end,
				},
			}
			QuickFixBlock = u.insert(QuickFixBlock, QuickFix, Space)

			local DAPBlock = {
				condition = function()
					local ok, dap = pcall(require, 'dap')
					if not ok then
						return false
					end
					local session = dap.session()
					return session ~= nil and conditions.is_active() and
					    not conditions.buffer_matches(dap_inactive)
				end,
				provider = function()
					local status = require('dap').status()
					status = string.gsub(status, '^Running', 'DAP')
					return string.format(' %s ', status)
				end,
				hl = 'Debug',
			}

			local StatusLines = {
				condition = function()
					local accept = {
						'.env.development',
						'.env.production',
						'.env',
					}
					if vim.tbl_contains(accept, vim.fn.expand '%:t') then
						return true
					end
					if vim.bo.filetype == '' or vim.bo.buftype == 'prompt' or vim.bo.buftype == 'nofile' then
						return false
					end
					for _, c in ipairs(cmdtype_inactive) do
						if vim.fn.getcmdtype() == c then
							return false
						end
					end
					return true
				end,
				GitBlock,
				MacroRecordingBlock,
				Align,
				GrappleBlock,
				QuickFixBlock,
				DAPBlock,
				NeoTestBlock,
				DiagnosticsBlock,
				{
					provider = GitSourceControl.init,
					hl = { bg = colors.null, fg = colors.dragonAqua },
				},
				RulerBlock,
				hl = function()
					if conditions.is_active() then
						return { bg = colors.sumiInk3 }
					else
						return { bg = colors.sumiInk1 }
					end
				end,
			}

			-- Enhanced Winbar with NvChad-inspired elements
			local Winbars = {
				Align,
				FileNameBlock,
				WinbarDiagnostics, -- Show diagnostics count
				Space,
			}

			heirline.setup {
				statusline = StatusLines,
				winbar = Winbars,
				opts = {
					disable_winbar_cb = function(args)
						return conditions.buffer_matches(winbar_inactive, args.buf)
					end,
				},
			}
		end,
	},
}
