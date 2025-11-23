return {
	"folke/persistence.nvim",
	event = "BufReadPre",
	opts = {
		-- Directory where session files are saved
		dir = vim.fn.expand(vim.fn.stdpath("state") .. "/sessions/"),

		-- Sessionoptions to store in the session
		options = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp" },

		-- Pre-save hook (runs before saving session)
		pre_save = nil,

		-- Save the session when exiting Neovim
		save_empty = false,
	},
	keys = {
		{
			"<leader>rr",
			function()
				require("persistence").load()
			end,
			desc = "Restore Session",
		},
		{
			"<leader>rs",
			function()
				require("persistence").select()
			end,
			desc = "Select Session",
		},
		{
			"<leader>rl",
			function()
				require("persistence").load({ last = true })
			end,
			desc = "Restore Last Session",
		},
		{
			"<leader>rw",
			function()
				require("persistence").save()
			end,
			desc = "Save Session",
		},
		{
			"<leader>rd",
			function()
				require("persistence").stop()
			end,
			desc = "Don't Save Current Session",
		},
	},
}
