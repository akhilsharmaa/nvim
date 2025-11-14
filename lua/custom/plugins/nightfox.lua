return {
	'EdenEast/nightfox.nvim',
	opts = {
		palettes = {
			nightfox = {
				-- Custom palette colors

				-- GitHub Dark authentic colors
				red = '#f85149', -- GitHub red
				green = '#56d364', -- GitHub green
				blue = '#58a6ff', -- GitHub blue
				yellow = '#e3b341', -- GitHub yellow
				orange = '#ffa657', -- GitHub orange
				purple = '#a5a5ff', -- GitHub purple
				comment = '#8b949e', -- GitHub comment gray

				bg1 = '#1a1a1a', -- Custom background color
				bg_sidebar = '#141414', -- Sidebar / float background
			},
		},
		groups = {
			nightfox = {
				-- Main editor background
				Normal = { fg = '#cdcecf', bg = 'palette.bg1' }, -- or use direct hex like bg = "#1a1a2e"
				NormalFloat = { bg = 'palette.bg_sidebar' },

				-- Custom highlight groups
				Comment = { fg = 'palette.comment', style = 'italic' },
				String = { fg = '#a3be8c' },
				Function = { fg = '#88c0d0', style = 'bold' },
				Keyword = { fg = '#81a1c1', style = 'bold' },

				-- Editor UI elements
				CursorLine = { bg = '#21262d' }, -- Current line highlight
				Visual = { bg = '#264f78' }, -- Selection background
				Search = { fg = '#0d1117', bg = '#e3b341' }, -- Search highlight
				LineNr = { fg = '#6e7681' }, -- Line numbers
				CursorLineNr = { fg = '#f0f6fc', style = 'bold' }, -- Current line number
				SignColumn = { bg = 'palette.bg1' }, -- Git signs column
				StatusLine = { fg = '#f0f6fc', bg = '#21262d' }, -- Status line

				-- Window separators - WHITE COLOR
				WinSeparator = { fg = '#262626', bg = 'palette.bg1' }, -- Modern separator
				-- VertSplit = { fg = "#ffffff", bg = "NONE" }, -- Legacy separator

				-- Syntax highlighting - GitHub Dark colors
				Comment = { fg = 'palette.comment', style = 'italic' }, -- Gray comments
				String = { fg = '#a5c261' },    -- Green strings
				Function = { fg = '#d2a8ff', style = 'bold' }, -- Purple functions
				Keyword = { fg = '#ff7b72', style = 'bold' }, -- Red keywords
				Type = { fg = '#ffa657' },      -- Orange types
				Constant = { fg = '#79c0ff' },  -- Blue constants
				Variable = { fg = '#f0f6fc' },  -- White variables
				Number = { fg = '#79c0ff' },    -- Blue numbers
				Boolean = { fg = '#79c0ff' },   -- Blue booleans
				Operator = { fg = '#ff7b72' },  -- Red operators

				-- Neo-tree
				NeoTreeNormal = { bg = 'palette.bg1', fg = '#cdcecf' },
				NeoTreeNormalNC = { bg = 'palette.bg1', fg = '#cdcecf' },
				NeoTreeWinSeparator = { fg = '#262626', bg = 'palette.bg1' },
				NeoTreeEndOfBuffer = { fg = 'palette.bg1' },
			},
		},
	},
}
