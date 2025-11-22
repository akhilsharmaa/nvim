local daytext = function()
	-- Get full name of current weekday
	local dayname = os.date("%A")

	-- Big ASCII art for each day
	local ascii_days = {
		Monday = {
			[[]],
			[[███    ███  ██████  ███    ██ ██████   █████  ██    ██]],
			[[████  ████ ██    ██ ████   ██ ██   ██ ██   ██  ██  ██ ]],
			[[██ ████ ██ ██    ██ ██ ██  ██ ██   ██ ███████   ████  ]],
			[[██  ██  ██ ██    ██ ██  ██ ██ ██   ██ ██   ██    ██   ]],
			[[██      ██  ██████  ██   ████ ██████  ██   ██    ██   ]],
		},
		Tuesday = {
			[[]],
			[[████████ ██    ██ ███████ ███████ ██████   █████  ██    ██]],
			[[   ██    ██    ██ ██      ██      ██   ██ ██   ██  ██  ██ ]],
			[[   ██    ██    ██ █████   ███████ ██   ██ ███████   ████  ]],
			[[   ██    ██    ██ ██           ██ ██   ██ ██   ██    ██   ]],
			[[   ██     ██████  ███████ ███████ ██████  ██   ██    ██   ]],
		},
		Wednesday = {
			[[]],
			[[ ██     ██ ███████ ██████  ███    ██ ███████ ███████ ███████ ██████   █████  ██    ██]],
			[[ ██     ██ ██      ██   ██ ████   ██ ██      ██      ██      ██   ██ ██   ██  ██  ██ ]],
			[[ ██  █  ██ █████   ██   ██ ██ ██  ██ █████   ███████ ███████ ██   ██ ███████   ████  ]],
			[[ ██ ███ ██ ██      ██   ██ ██  ██ ██ ██           ██      ██ ██   ██ ██   ██    ██   ]],
			[[  ███ ███  ███████ ██████  ██   ████ ███████ ███████ ███████ ██████  ██   ██    ██   ]],
		},
		Thursday = {
			[[]],
			[[████████ ██   ██ ██    ██ ██████  ███████ ██████   █████  ██    ██ ]],
			[[   ██    ██   ██ ██    ██ ██   ██ ██      ██   ██ ██   ██  ██  ██  ]],
			[[   ██    ███████ ██    ██ ██████  ███████ ██   ██ ███████   ████   ]],
			[[   ██    ██   ██ ██    ██ ██   ██      ██ ██   ██ ██   ██    ██    ]],
			[[   ██    ██   ██  ██████  ██   ██ ███████ ██████  ██   ██    ██    ]],
		},
		Friday = {
			[[]],
			[[███████ ██████  ██ ██████   █████  ██    ██ ]],
			[[██      ██   ██ ██ ██   ██ ██   ██  ██  ██  ]],
			[[█████   ██████  ██ ██   ██ ███████   ████   ]],
			[[██      ██   ██ ██ ██   ██ ██   ██    ██    ]],
			[[██      ██   ██ ██ ██████  ██   ██    ██    ]],
		},
		Saturday = {
			[[]],
			[[███████  █████  ████████ ██    ██ ██████  ██████   █████  ██    ██ ]],
			[[██      ██   ██    ██    ██    ██ ██   ██ ██   ██ ██   ██  ██  ██  ]],
			[[███████ ███████    ██    ██    ██ ██████  ██   ██ ███████   ████   ]],
			[[     ██ ██   ██    ██    ██    ██ ██   ██ ██   ██ ██   ██    ██    ]],
			[[███████ ██   ██    ██     ██████  ██   ██ ██████  ██   ██    ██    ]],
		},
		Sunday = {
			[[]],
			[[███████ ██    ██ ███    ██ ██████   █████  ██    ██ ]],
			[[██      ██    ██ ████   ██ ██   ██ ██   ██  ██  ██  ]],
			[[███████ ██    ██ ██ ██  ██ ██   ██ ███████   ████   ]],
			[[     ██ ██    ██ ██  ██ ██ ██   ██ ██   ██    ██    ]],
			[[███████  ██████  ██   ████ ██████  ██   ██    ██    ]],
		},
	}
	return ascii_days[dayname]
end

-- ~/.config/nvim/lua/plugins/alpha.lua
return {
	"goolord/alpha-nvim",
	event = "VimEnter",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		local alpha = require("alpha")
		local dashboard = require("alpha.themes.dashboard")


		-- Header
		dashboard.section.header.val = daytext()

		-- Buttons
		dashboard.section.buttons.val = {
			dashboard.button("f", "󰈞  Find file", ":Telescope find_files<CR>"),
			dashboard.button("n", "󰝒  New file", ":ene <BAR> startinsert<CR>"),
			dashboard.button("r", "󰋚  Recent files", ":Telescope oldfiles<CR>"),
			dashboard.button("g", "󰊄  Find text", ":Telescope live_grep<CR>"),
			dashboard.button("c", "  Configuration", ":e $MYVIMRC<CR>"),
			dashboard.button("s", "󰦛  Restore session", ":SessionRestore<CR>"),
			dashboard.button("l", "󰒲  Lazy", ":Lazy<CR>"),
			dashboard.button("q", "󰗼  Quit", ":qa<CR>"),
		}

		-- Footer with stats
		local function footer()
			local stats = require("lazy").stats()
			local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
			return " Neovim loaded " .. stats.loaded .. "/" .. stats.count .. " plugins in " .. ms .. "ms"
		end

		dashboard.section.footer.val = footer()

		-- Highlight groups
		dashboard.section.header.opts.hl = "AlphaHeader"
		dashboard.section.buttons.opts.hl = "AlphaButtons"
		dashboard.section.footer.opts.hl = "AlphaFooter"

		-- Layout
		dashboard.opts.layout = {
			{ type = "padding", val = 2 },
			dashboard.section.header,
			{ type = "padding", val = 2 },
			dashboard.section.buttons,
			{ type = "padding", val = 1 },
			dashboard.section.footer,
		}

		-- Disable folding on alpha buffer
		vim.api.nvim_create_autocmd("FileType", {
			pattern = "alpha",
			callback = function()
				vim.opt_local.foldenable = false
				vim.opt_local.cursorline = false
			end,
		})

		alpha.setup(dashboard.opts)

		-- Update footer after lazy has loaded
		vim.api.nvim_create_autocmd("User", {
			pattern = "LazyVimStarted",
			callback = function()
				dashboard.section.footer.val = footer()
				pcall(vim.cmd.AlphaRedraw)
			end,
		})
	end,
}
