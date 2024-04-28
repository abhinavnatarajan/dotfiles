version = '0.21.7'

---@diagnostic disable
local xplr = xplr -- The globally exposed configuration to be overridden.
---@diagnostic enable


xplr.config.general.enable_mouse = true
-- The default style of each item for each row.
-- Type: [Style](https://xplr.dev/en/style)
xplr.config.general.default_ui.style = {
  sub_modifiers = {}
}

-- Style for focused item.
xplr.config.general.focus_ui.style = {
	add_modifiers = {
		"Bold",
		"Italic",
	}
}

-- Style for selected rows.
xplr.config.general.selection_ui.style = {
	add_modifiers = {
		"Reversed"
	},
}

-- Style for a selected row that gets the focus.
xplr.config.general.focus_selection_ui.style = {
	add_modifiers = {
		"Bold",
		"Italic",
		"Reversed"
	},
}

xplr.config.general.sort_and_filter_ui.separator.style = {
	add_modifiers = {
    "Dim"
  },
}

-- The content that is placed before the item name for each row by default.
xplr.config.general.default_ui.prefix = "   "
-- The string placed before the item name for a focused row.
xplr.config.general.focus_ui.prefix = "▸[ "
-- The string placed before the item name for a selected row.
xplr.config.general.selection_ui.prefix = "  *"
-- The string placed before item name for a selected row that gets the focus.
xplr.config.general.focus_selection_ui.prefix = "▸[*"

-- Style of the panel borders by default.
xplr.config.general.panel_ui.default.border_style = {
	fg = "Gray",
  add_modifiers = {
    "Dim"
  }
}

-- XPM package manager
local home = os.getenv("HOME")
local xpm_path = home .. "/.local/share/xplr/dtomvan/xpm.xplr"
local xpm_url = "https://github.com/dtomvan/xpm.xplr"

package.path = package.path
  .. ";"
  .. xpm_path
  .. "/?.lua;"
  .. xpm_path
  .. "/?/init.lua"

os.execute(
  string.format(
    "[ -e '%s' ] || git clone '%s' '%s'",
    xpm_path,
    xpm_url,
    xpm_path
  )
)
require("xpm").setup({
  plugins = {
    -- Let xpm manage itself
    'dtomvan/xpm.xplr',
    'gitlab:hartan/web-devicons.xplr',
  },
  auto_install = true,
  auto_cleanup = true,
})
xplr.config.node_types.directory.meta.icon = "󰉋"
xplr.config.node_types.file.meta.icon = ""
xplr.config.node_types.symlink.meta.icon = ""

-- Type: [Mode](https://xplr.dev/en/mode)
xplr.config.modes.builtin.default = {
  name = "default",
  key_bindings = {
    on_key = {
      ["#"] = {
        messages = {
          "PrintAppStateAndQuit",
        },
      },
      ["."] = {
        help = "show hidden",
        messages = {
          {
            ToggleNodeFilter = { filter = "RelativePathDoesNotStartWith", input = "." },
          },
          "ExplorePwdAsync",
        },
      },
      [":"] = {
        help = "action",
        messages = {
          "PopMode",
          { SwitchModeBuiltin = "action" },
        },
      },
      ["G"] = {
        help = "go to bottom",
        messages = {
          "PopMode",
          "FocusLast",
        },
      },
      ["ctrl-a"] = {
        help = "select/unselect all",
        messages = {
          "ToggleSelectAll",
        },
      },
      ["ctrl-f"] = {
        help = "search",
        messages = {
          "PopMode",
          { SwitchModeBuiltin = "search" },
          { SetInputBuffer = "" },
        },
      },
      ["ctrl-i"] = {
        help = "next visited path",
        messages = {
          "NextVisitedPath",
        },
      },
      ["ctrl-o"] = {
        help = "last visited path",
        messages = {
          "LastVisitedPath",
        },
      },
      [")"] = {
        help = "next deep branch",
        messages = {
          "NextVisitedDeepBranch",
        },
      },
      ["("] = {
        help = "prev deep branch",
        messages = {
          "PreviousVisitedDeepBranch",
        },
      },
      ["ctrl-r"] = {
        help = "refresh screen",
        messages = {
          "ClearScreen",
        },
      },
      ["ctrl-u"] = {
        help = "clear selection",
        messages = {
          "ClearSelection",
        },
      },
      ["ctrl-w"] = {
        help = "switch layout",
        messages = {
          { SwitchModeBuiltin = "switch_layout" },
        },
      },
      ["d"] = {
        help = "delete",
        messages = {
          "PopMode",
          { SwitchModeBuiltin = "delete" },
        },
      },
      ["down"] = {
        help = "down",
        messages = {
          "FocusNext",
        },
      },
      ["enter"] = {
        help = "quit with result",
        messages = {
          "PrintResultAndQuit",
        },
      },
      ["f"] = {
        help = "filter",
        messages = {
          "PopMode",
          { SwitchModeBuiltin = "filter" },
        },
      },
      ["g"] = {
        help = "go to",
        messages = {
          "PopMode",
          { SwitchModeBuiltin = "go_to" },
        },
      },
      ["left"] = {
        help = "back",
        messages = {
          "Back",
        },
      },
      ["q"] = {
        help = "quit",
        messages = {
          "Quit",
        },
      },
      ["r"] = {
        help = "rename",
        messages = {
          "PopMode",
          { SwitchModeBuiltin = "rename" },
          {
            BashExecSilently0 = [===[
              NAME=$(basename "${XPLR_FOCUS_PATH:?}")
              "$XPLR" -m 'SetInputBuffer: %q' "${NAME:?}"
            ]===],
          },
        },
      },
      ["ctrl-d"] = {
        help = "duplicate as",
        messages = {
          "PopMode",
          { SwitchModeBuiltin = "duplicate_as" },
          {
            BashExecSilently0 = [===[
              NAME=$(basename "${XPLR_FOCUS_PATH:?}")
              "$XPLR" -m 'SetInputBuffer: %q' "${NAME:?}"
            ]===],
          },
        },
      },
      ["right"] = {
        help = "enter",
        messages = {
          "Enter",
        },
      },
      ["s"] = {
        help = "sort",
        messages = {
          "PopMode",
          { SwitchModeBuiltin = "sort" },
        },
      },
      ["space"] = {
        help = "toggle selection",
        messages = {
          "ToggleSelection"
        },
      },
      ["up"] = {
        help = "up",
        messages = {
          "FocusPrevious",
        },
      },
      ["~"] = {
        help = "go home",
        messages = {
          {
            BashExecSilently0 = [===[
              "$XPLR" -m 'ChangeDirectory: %q' "${HOME:?}"
            ]===],
          },
        },
      },
      ["page-up"] = {
        help = "scroll up",
        messages = {
          "ScrollUp",
        },
      },
      ["page-down"] = {
        help = "scroll down",
        messages = {
          "ScrollDown",
        },
      },
      ["{"] = {
        help = "scroll up half",
        messages = {
          "ScrollUpHalf",
        },
      },
      ["}"] = {
        help = "scroll down half",
        messages = {
          "ScrollDownHalf",
        },
      },
      ["ctrl-n"] = {
        help = "next selection",
        messages = {
          "FocusNextSelection",
        },
      },
      ["ctrl-p"] = {
        help = "prev selection",
        messages = {
          "FocusPreviousSelection",
        },
      },
      ["m"] = {
        help = "move to",
        messages = {
          "PopMode",
          { SwitchModeBuiltin = "move_to" },
          { SetInputBuffer = "" },
        },
      },
      ["c"] = {
        help = "copy to",
        messages = {
          "PopMode",
          { SwitchModeBuiltin = "copy_to" },
          { SetInputBuffer = "" },
        },
      },
    },
    on_number = {
      help = "input",
      messages = {
        "PopMode",
        { SwitchModeBuiltin = "number" },
        "BufferInputFromKey",
      },
    },
  },
}

xplr.config.modes.builtin.default.key_bindings.on_key["v"] =
    xplr.config.modes.builtin.default.key_bindings.on_key["space"]
xplr.config.modes.builtin.default.key_bindings.on_key["V"] =
    xplr.config.modes.builtin.default.key_bindings.on_key["ctrl-a"]
xplr.config.modes.builtin.default.key_bindings.on_key["/"] =
    xplr.config.modes.builtin.default.key_bindings.on_key["ctrl-f"]
xplr.config.modes.builtin.default.key_bindings.on_key["h"] =
    xplr.config.modes.builtin.default.key_bindings.on_key["left"]
xplr.config.modes.builtin.default.key_bindings.on_key["j"] =
    xplr.config.modes.builtin.default.key_bindings.on_key["down"]
xplr.config.modes.builtin.default.key_bindings.on_key["k"] =
    xplr.config.modes.builtin.default.key_bindings.on_key["up"]
xplr.config.modes.builtin.default.key_bindings.on_key["l"] =
    xplr.config.modes.builtin.default.key_bindings.on_key["right"]
xplr.config.modes.builtin.default.key_bindings.on_key["tab"] =
    xplr.config.modes.builtin.default.key_bindings.on_key["ctrl-i"] -- compatibility workaround
xplr.config.modes.builtin.default.key_bindings.on_key["?"] =
    xplr.config.general.global_key_bindings.on_key["f1"]

return {
  on_load = {},
  on_directory_change = {},
  on_focus_change = {},
  on_mode_switch = {},
  on_layout_switch = {},
}
