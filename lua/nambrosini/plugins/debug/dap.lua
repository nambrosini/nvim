return {
	"mfussenegger/nvim-dap",
	ft = { "go", "go.mod", "rust" },
	event = { "BufNewFile", "BufReadPre" },
	config = function()
		vim.keymap.set("n", "<leader>db", "<cmd>DapToggleBreakpoint<CR>", { desc = "Toggle [D]ebug [B]reakpoint" })
		vim.keymap.set("n", "<leader><F5>", "<cmd>DapTerminate<CR>", { desc = "[D]ebug [T]erminate" })
		vim.keymap.set("n", "<F6>", "<cmd>DapContinue<CR>", { desc = "[D]ebug [C]ontinue" })
		vim.keymap.set("n", "<F7>", "<cmd>DapStepOver<CR>", { desc = "[D]ebug [S]tepOver" })
		vim.keymap.set("n", "<F8>", "<cmd>DapStepInto<CR>", { desc = "[D]ebug [S]tepOver" })
		vim.keymap.set("n", "<F9>", "<cmd>DapStepOut<CR>", { desc = "[D]ebug [S]tepOver" })
	end,
}
