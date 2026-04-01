vim.pack.add({
	{ src = "https://github.com/mfussenegger/nvim-dap" },
	{ src = "rcarriga/nvim-dap-ui" },
	{ src = "nvim-neotest/nvim-nio" },
	{ src = "mason-org/mason.nvim" },
	{ src = "jay-babu/mason-nvim-dap.nvim" },
	{ src = "leoluz/nvim-dap-go" },
})

local map = function(keymap, action, desc)
	vim.keymap.set("n", keymap, action, { desc = desc })
end

map("<F5>", function()
	require("dap").continue()
end, "Debug: Start/Continue")
map("<F1>", function()
	require("dap").step_into()
end, "Debug: Step Into")
map("<F2>", function()
	require("dap").step_over()
end, "Debug: Step Over")
map("<F3>", function()
	require("dap").step_out()
end, "Debug: Step Out")
map("<leader>b", function()
	require("dap").toggle_breakpoint()
end, "Debug: Toggle Breakpoint")
map("<leader>B", function()
	require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
end, "Debug: set breakpoint")
-- Toggle to see last session result. without this, you can't see session output in case of unhandled exception.
map("<f7>", function()
	require("dapui").toggle()
end, "Debug: see last session result.")

local dap = require("dap")
local dapui = require("dapui")

require("mason-nvim-dap").setup({
	-- Makes a best effort to setup the various debuggers with
	-- reasonable debug configurations
	automatic_installation = true,

	-- You can provide additional configuration to the handlers,
	-- see mason-nvim-dap README for more information
	handlers = {},

	-- You'll need to check that you have the required things installed
	-- online, please don't ask me how to install them :)
	ensure_installed = {
		-- Update this to ensure that you have the debuggers for the langs you want
		"delve",
	},
})

-- Dap UI setup
-- For more information, see |:help nvim-dap-ui|
---@diagnostic disable-next-line: missing-fields
dapui.setup({
	-- Set icons to characters that are more likely to work in every terminal.
	--    Feel free to remove or use ones that you like more! :)
	--    Don't feel like these are good choices.
	icons = { expanded = "▾", collapsed = "▸", current_frame = "*" },
	---@diagnostic disable-next-line: missing-fields
	controls = {
		icons = {
			pause = "⏸",
			play = "▶",
			step_into = "⏎",
			step_over = "⏭",
			step_out = "⏮",
			step_back = "b",
			run_last = "▶▶",
			terminate = "⏹",
			disconnect = "⏏",
		},
	},
})

-- Change breakpoint icons
vim.api.nvim_set_hl(0, "DapBreak", { fg = "#e51400" })
vim.api.nvim_set_hl(0, "DapStop", { fg = "#ffcc00" })
local breakpoint_icons = vim.g.have_nerd_font
	and {
		Breakpoint = "",
		BreakpointCondition = "",
		BreakpointRejected = "",
		LogPoint = "",
		Stopped = "",
	}
--   or { Breakpoint = '●', BreakpointCondition = '⊜', BreakpointRejected = '⊘', LogPoint = '◆', Stopped = '⭔' }
for type, icon in pairs(breakpoint_icons) do
	local tp = "Dap" .. type
	local hl = (type == "Stopped") and "DapStop" or "DapBreak"
	vim.fn.sign_define(tp, { text = icon, texthl = hl, numhl = hl })
end

dap.listeners.after.event_initialized["dapui_config"] = dapui.open
dap.listeners.before.event_terminated["dapui_config"] = dapui.close
dap.listeners.before.event_exited["dapui_config"] = dapui.close

-- Install golang specific config
require("dap-go").setup({
	delve = {
		-- On Windows delve must be run attached or it crashes.
		-- See https://github.com/leoluz/nvim-dap-go/blob/main/README.md#configuring
		detached = vim.fn.has("win32") == 0,
	},
})

-- vim: ts=2 sts=2 sw=2 et
