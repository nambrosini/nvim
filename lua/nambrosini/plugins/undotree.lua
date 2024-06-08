return {
	"mbbill/undotree",
	event = { "BufNewFile", "BufReadPre" },
	config = function()
		vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)
	end,
}
