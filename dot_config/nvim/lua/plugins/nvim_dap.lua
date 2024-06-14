local icons = require("icons")
return {
	{
		"mfussenegger/nvim-dap",
		keys = {
			{ "<Leader>Dt", function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint" },
			{ "<Leader>Db", function() require("dap").step_back() end,         desc = "Step Back" },
			{ "<Leader>Ds", function() require("dap").continue() end,          desc = "Start" },
			{ "<Leader>Dc", function() require("dap").continue() end,          desc = "Continue" },
			{ "<Leader>DC", function() require("dap").run_to_cursor() end,     desc = "Run To Cursor" },
			{ "<Leader>Dk", function() require("dap").session() end,           desc = "Get Session" },
			{ "<Leader>Di", function() require("dap").step_into() end,         desc = "Step Into" },
			{ "<Leader>Do", function() require("dap").step_over() end,         desc = "Step Over" },
			{ "<Leader>Du", function() require("dap").step_out() end,          desc = "Step Out" },
			{ "<Leader>Dp", function() require("dap").pause() end,             desc = "Pause session" },
			{ "<Leader>Dr", function() require("dap").repl.toggle() end,       desc = "Toggle Repl" },
			{
				-- terminate() is a "soft" terminate which the debuggee can ignore
				"<Leader>Dq",
				function() require("dap").terminate() end,
				desc = "Terminate session",
			},
			{
				-- disconnect the adapter from the debuggee and terminate the adapter
				-- this will terminate the debuggee if it was launched by the adapter
				"<Leader>Dd",
				function() local dap = require("dap").disconnect() end,
				desc = icons.debug.Disconnect .. " Disconnect debugger"
			},
		},
	},
	{
		"rcarriga/nvim-dap-ui",
		dependencies = {
			'nvim-neotest/nvim-nio',
			"mfussenegger/nvim-dap",
		},
		keys = {
			{ "<Leader>DU", function() require("dapui").toggle() end, desc = "Toggle debugger UI" },
			{ "<Leader>Ds", function() require("dap").continue() end, desc = "Start" },
			{ "<Leader>Dc", function() require("dap").continue() end, desc = "Continue" },
		},
		config = function(_, opts)
			local dap, dapui = require("dap"), require("dapui")
			dapui.setup(opts)

			-- automatically open the ui when we start debugging
			dap.listeners.before.attach.dapui_config = dapui.open
			dap.listeners.before.launch.dapui_config = dapui.open

			-- close the ui when the debugger has terminated or exited
			dap.listeners.before.event_terminated.dapui_config = dapui.close
			dap.listeners.before.event_exited.dapui_config = dapui.close
			-- close the ui when we request the adapter to disconnect
			dap.listeners.before.disconnect.dapui_config = dapui.close
		end,
		opts = {
			controls = {
				element = "repl",
				enabled = true,
				icons = {
					disconnect = icons.debug.Disconnect,
					pause = icons.debug.Pause,
					play = icons.debug.Play,
					run_last = icons.debug.RunLast,
					step_back = icons.debug.StepBack,
					step_into = icons.debug.StepInto,
					step_out = icons.debug.StepOut,
					step_over = icons.debug.StepOver,
					terminate = icons.debug.Terminate
				}
			},
			-- 	element_mappings = {},
			-- 	expand_lines = true,
			-- 	floating = {
			-- 		border = "single",
			-- 		mappings = {
			-- 			close = { "q", "<Esc>" }
			-- 		}
			-- 	},
			-- 	force_buffers = true,
			-- 	icons = {
			-- 		collapsed = "",
			-- 		current_frame = "",
			-- 		expanded = ""
			-- 	},
			-- 	layouts = { {
			-- 		elements = { {
			-- 			id = "scopes",
			-- 			size = 0.25
			-- 		}, {
			-- 			id = "breakpoints",
			-- 			size = 0.25
			-- 		}, {
			-- 			id = "stacks",
			-- 			size = 0.25
			-- 		}, {
			-- 			id = "watches",
			-- 			size = 0.25
			-- 		} },
			-- 		position = "left",
			-- 		size = 40
			-- 	}, {
			-- 		elements = { {
			-- 			id = "repl",
			-- 			size = 0.5
			-- 		}, {
			-- 			id = "console",
			-- 			size = 0.5
			-- 		} },
			-- 		position = "bottom",
			-- 		size = 10
			-- 	} },
			-- 	mappings = {
			-- 		edit = "e",
			-- 		expand = { "<CR>", "<2-LeftMouse>" },
			-- 		open = "o",
			-- 		remove = "d",
			-- 		repl = "r",
			-- 		toggle = "t"
			-- 	},
			-- 	render = {
			-- 		indent = 1,
			-- 		max_value_lines = 100
			-- 	}
		},
	}
}
