return {
	"stevearc/overseer.nvim",
	dependencies = { "akinsho/toggleterm.nvim" },
	-- version = "*",
	keys = function()
		local cm = require('utils.component_manager')
		local component = cm.register_component('overseer',
			{
				open = function() require('overseer').open() end,
				close = function() require('overseer').close() end,
				is_open = function() return require('overseer.window').is_open() end,
			})
		local toggler = function() component:toggle() end
		local kmaps = {
			{
				"<leader>Om",
				toggler,
				desc = require('icons').ui.History .. " Toggle task manager",
			},
			{
				"<leader>Or",
				"<CMD>OverseerRun RUN<CR>",
				desc = require('icons').ui.Build .. " Run"
			},
			{
				"<leader>Ob",
				"<CMD>OverseerRun BUILD<CR>",
				desc = require('icons').ui.Build .. " Build",
			},
			{
				"<leader>Ot",
				"<CMD>OverseerRun TEST<CR>",
				desc = require('icons').ui.Terminal .. " Run tests",
			},
			{
				"<leader>Oc",
				"<CMD>OverseerRun CLEAN<CR>",
				desc = require('icons').ui.Reload .. " Clean",
			},
			{
				"<leader>Of",
				"<CMD>OverseerRun<CR>",
				desc = require('icons').ui.List .. " Choose task...",
			},
			{
				"<leader>Oi",
				"<CMD>OverseerInfo<CR>",
				desc = require('icons').ui.Information .. " Overseer info",
			},
			{
				"<leader>On",
				"<CMD>OverseerBuild<CR>",
				desc = require('icons').ui.Build .. " New task",
			},
		}
		return kmaps
	end,
	init = function()
		vim.list_extend(
			require('config.keybinds').which_key_defaults,
			{ { "<Leader>O", group = require('icons').ui.Terminal .. " Overseer" } }
		)
	end,
	cmd = {
		"OverseerOpen",
		"OverseerClose",
		"OverseerToggle",
		"OverseerSaveBundle",
		"OverseerLoadBundle",
		"OverseerDeleteBundle",
		"OverseerRunCmd",
		"OverseerRun",
		"OverseerInfo",
		"OverseerBuild",
		"OverseerQuickAction",
		"OverseerTaskAction",
		"OverseerClearCache"
	},
	opts = {
		strategy = {
			"jobstart",
			use_terminal = true,
		},
		dap = true,
		task_list = {
			bindings = {
				r = "<CMD>OverseerQuickAction restart<CR>",
				-- R = "<CMD>OverseerQuickAction retain<CR>",
				d = "<CMD>OverseerQuickAction dispose<CR>",
			},
			max_height = { 1000, 0.3},
		},
		component_aliases = {
			default = {
				-- add components to the default list of components
				{ "open_output",      on_start = "always" },
				{ "display_duration", detail_level = 2 },
				"on_output_summarize",
				"on_exit_set_status",
				"on_complete_notify",
				-- { "on_complete_dispose", require_view = { "SUCCESS", "FAILURE" }, timeout = 300 },
			}
		},
		default_template_prompt = "missing",
		task_launcher = {
			-- Set keymap to false to remove default behavior
			-- You can add custom keymaps here as well (anything vim.keymap.set accepts)
			bindings = {
				i = {
					["<C-CR>"] = "Submit",
					["<C-c>"] = "Cancel",
				},
				n = {
					["<CR>"] = "Submit",
					["<C-s>"] = false,
					["q"] = "Cancel",
					["?"] = "ShowHelp",
				},
			},
		},
		task_editor = {
			-- Set keymap to false to remove default behavior
			-- You can add custom keymaps here as well (anything vim.keymap.set accepts)
			bindings = {
				i = {
					["<CR>"] = "NextOrSubmit",
					["<C-CR>"] = "Submit",
					["<C-s>"] = false,
					["<Tab>"] = "Next",
					["<S-Tab>"] = "Prev",
					["<C-c>"] = "Cancel",
				},
				n = {
					["<CR>"] = "NextOrSubmit",
					["<C-CR>"] = "Submit",
					["<C-s>"] = false,
					["<Tab>"] = "Next",
					["<S-Tab>"] = "Prev",
					["q"] = "Cancel",
					["?"] = "ShowHelp",
				},
			},
		},
		templates = { "builtin", "cmake", "vcpkg" }
	}
}
