version = '0.21.8'

---@diagnostic disable
local xplr = xplr -- The globally exposed configuration to be overridden.
---@diagnostic enable

xplr.config.general.enable_mouse = true
--
xplr.config.general.default_ui.style = {}
-- Style for focused item.
xplr.config.general.focus_ui.style = {
  add_modifiers = {
    "Bold",
    "Reversed"
  }
}

-- Style for selected rows.
xplr.config.general.selection_ui.style = {
  add_modifiers = {
    "Italic"
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
xplr.config.general.default_ui.prefix = "    "
-- The string placed before and after the item name for a focused row.
xplr.config.general.focus_ui.prefix = "▸[  "
xplr.config.general.focus_ui.suffix = " ]"
-- The string placed before and after the item name for a selected row.
xplr.config.general.selection_ui.prefix = "  + "
xplr.config.general.selection_ui.suffix = ""
-- The string placed before item name for a selected row that gets the focus.
xplr.config.general.focus_selection_ui.prefix = "▸[+ "
xplr.config.general.focus_selection_ui.suffix = " ]"

-- Style of the panel borders by default.
xplr.config.general.panel_ui.default.border_style = {
  fg = "Gray",
  add_modifiers = {
    "Dim"
  }
}
xplr.config.general.search.algorithm = "Fuzzy" -- Fuzzy or Regex
 
xplr.config.node_types.directory.meta.icon = "󰉋"
xplr.config.node_types.file.meta.icon = ""
xplr.config.node_types.symlink.meta.icon = ""

-- Renders the second column in the table
xplr.fn.builtin.fmt_general_table_row_cols_1 = function(m)
  local nl = xplr.util.paint("\\n", { add_modifiers = { "Italic", "Dim" } })
  local r = m.tree .. m.prefix
  local ls_style = xplr.util.lscolor(m.absolute_path)
  local style = xplr.util.style_mix({ ls_style, m.style })
  if m.meta.icon == nil then
    r = r .. ""
  else
    if m.is_dir or m.is_symlink or (m.is_file and m.meta.icon == "") then
      m.meta.icon = xplr.util.paint(m.meta.icon, ls_style)
    end
    r = r .. m.meta.icon .. " "
  end
  local rel = m.relative_path
  if m.is_dir then
    rel = rel .. "/"
  end
  r = r .. xplr.util.paint(xplr.util.shell_escape(rel), style)
  r = r .. m.suffix .. " "

  if m.is_symlink then
    r = r .. "-> "

    if m.is_broken then
      r = r .. "×"
    else
      local symlink_path =
          xplr.util.shorten(m.symlink.absolute_path, { base = m.parent })
      if m.symlink.is_dir then
        symlink_path = symlink_path .. "/"
      end
      r = r .. symlink_path:gsub("\n", nl)
    end
  end
  return r
end
--
-- Type: [Mode](https://xplr.dev/en/mode)
-- Default mode
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
      ["q"] = {
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
      ["x"] = {
        help = "xpm",
        messages = {
          "PopMode",
          { SwitchModeCustom = "xpm" },
        },
      }
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

-- The builtin search mode.
xplr.config.modes.builtin.search = {
  name = "search",
  prompt = "/",
  key_bindings = {
    on_key = {
      ["up"] = {
        help = "up",
        messages = {
          "FocusPrevious",
        },
      },
      ["down"] = {
        help = "down",
        messages = {
          "FocusNext",
        },
      },
      ["ctrl-z"] = {
        help = "toggle ordering",
        messages = {
          "ToggleSearchOrder",
          "ExplorePwdAsync",
        },
      },
      ["ctrl-a"] = {
        help = "toggle search algorithm",
        messages = {
          "ToggleSearchAlgorithm",
          "ExplorePwdAsync",
        },
      },
      ["ctrl-r"] = {
        help = "regex search",
        messages = {
          "SearchRegexFromInput",
          "ExplorePwdAsync",
        },
      },
      ["ctrl-f"] = {
        help = "fuzzy search",
        messages = {
          "SearchFuzzyFromInput",
          "ExplorePwdAsync",
        },
      },
      ["ctrl-s"] = {
        help = "sort (no search order)",
        messages = {
          "DisableSearchOrder",
          "ExplorePwdAsync",
          { SwitchModeBuiltinKeepingInputBuffer = "sort" },
        },
      },
      ["right"] = {
        help = "enter",
        messages = {
          "Enter",
          { SetInputBuffer = "" },
        },
      },
      ["left"] = {
        help = "back",
        messages = {
          "Back",
          { SetInputBuffer = "" },
        },
      },
      ["tab"] = {
        help = "toggle selection",
        messages = {
          "ToggleSelection",
          "FocusNext",
        },
      },
      ["enter"] = {
        help = "submit",
        messages = {
          "AcceptSearch",
          "PopMode",
        },
      },
      ["esc"] = {
        help = "cancel",
        messages = {
          "CancelSearch",
          "PopMode",
        },
      },
    },
    default = {
      messages = {
        "UpdateInputBufferFromKey",
        "SearchFromInput",
        "ExplorePwdAsync",
      },
    },
  },
}

xplr.config.modes.builtin.search.key_bindings.on_key["ctrl-j"] = xplr.config.modes.builtin.search.key_bindings.on_key["down"]
xplr.config.modes.builtin.search.key_bindings.on_key["ctrl-k"] = xplr.config.modes.builtin.search.key_bindings.on_key["up"]
xplr.config.modes.builtin.search.key_bindings.on_key["ctrl-h"] = xplr.config.modes.builtin.search.key_bindings.on_key["left"]
xplr.config.modes.builtin.search.key_bindings.on_key["ctrl-l"] = xplr.config.modes.builtin.search.key_bindings.on_key["right"]

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
    'abhinavnatarajan/web-devicons.xplr',
    'sayanarijit/fzf.xplr',
    'igorepst/context-switch.xplr'
  },
  auto_install = true,
  auto_cleanup = true,
})
require("fzf").setup{
  mode = "default",
  key = "ctrl-f",
  bin = "fzf",
  args = "--bind 'ctrl-]:toggle-preview'",
  recursive = true,  -- If true, search all files under $PWD
  enter_dir = false,  -- Enter if the result is directory
}
require("context-switch").setup()
return {
  on_load = {},
  on_directory_change = {},
  on_focus_change = {},
  on_mode_switch = {},
  on_layout_switch = {},
}
