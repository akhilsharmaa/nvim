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


				bg1 = '#181818', -- GitHub dark primary background
				bg2 = '#181818', -- GitHub dark secondary background
				bg_sidebar = '#141414', -- Sidebar / float background
			},
		},
		groups = {
			nightfox = {
				-- Main editor background
				Normal              = { fg = '#cdcecf', bg = 'palette.bg1' }, -- or use direct hex like bg = "#1a1a2e"
				NormalFloat         = { bg = 'palette.bg_sidebar' },

				-- Editor UI elements
				CursorLine          = { bg = '#21262d' }, -- Current line highlight
				Visual              = { bg = '#264f78' }, -- Selection background
				Search              = { fg = '#0d1117', bg = '#e3b341' }, -- Search highlight
				LineNr              = { fg = '#6e7681' }, -- Line numbers
				CursorLineNr        = { fg = '#f0f6fc', style = 'bold' }, -- Current line number
				SignColumn          = { bg = 'palette.bg1' }, -- Git signs column
				StatusLine          = { fg = '#f0f6fc', bg = '#21262d' }, -- Status line

				-- Window separators - WHITE COLOR
				WinSeparator        = { fg = '#262626', bg = 'palette.bg1' }, -- Modern separator
				-- VertSplit = { fg = "#ffffff", bg = "NONE" }, -- Legacy separator

				-- Syntax highlighting - GitHub Dark colors
				Comment             = { fg = '#75715e', style = 'italic' }, -- Warm gray for comments
				String              = { fg = '#ffd866' }, -- Yellow for strings
				Function            = { fg = '#a9dc76', style = 'bold' }, -- Green for functions
				Keyword             = { fg = '#ff6188', style = 'bold' }, -- Pink-red for keywords
				Type                = { fg = '#78dce8' }, -- Cyan for types
				Constant            = { fg = '#ae81ff' }, -- Purple for constants
				Variable            = { fg = '#f8f8f2' }, -- Off-white for variables
				Number              = { fg = '#ae81ff' }, -- Purple for numbers
				Boolean             = { fg = '#ae81ff' }, -- Purple for booleans
				Operator            = { fg = '#ff6188' }, -- Pink-red for operators

				-- Neo-tree
				NeoTreeNormal       = { bg = 'palette.bg2', fg = '#cdcecf' },
				NeoTreeNormalNC     = { bg = 'palette.bg2', fg = '#cdcecf' },
				NeoTreeWinSeparator = { fg = '#262626', bg = 'palette.bg2' },
				NeoTreeEndOfBuffer  = { fg = 'palette.bg2' },
			},
		},
	},
}
