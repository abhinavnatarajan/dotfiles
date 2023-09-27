-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- This is where you actually apply your config choices
config.automatically_reload_config = true

config.window_close_confirmation = 'NeverPrompt' -- or 'AlwaysPrompt'

-- Default shell - only on Windows!
config.default_domain = 'WSL:Ubuntu'

config.default_cwd = wezterm.home_dir

-- For example, changing the color scheme:
config.color_scheme = 'OneHalfDark'
config.font = wezterm.font 'FiraCode Nerd Font'
config.font_size = 11

config.use_fancy_tab_bar = true

config.window_frame = {
  -- The font used in the tab bar.
  -- Roboto Bold is the default; this font is bundled
  -- with wezterm.
  -- Whatever font is selected here, it will have the
  -- main font setting appended to it to pick up any
  -- fallback fonts you may have used there.
  font = wezterm.font { family = 'Segoe UI', weight = 400 },

  -- The size of the font in the tab bar.
  -- Default to 10.0 on Windows but 12.0 on other systems
  font_size = 10,

  -- The overall background color of the tab bar when
  -- the window is focused
  active_titlebar_bg = '#333333',

  -- The overall background color of the tab bar when
  -- the window is not focused
  inactive_titlebar_bg = '#333333',
}

config.window_padding = {
  left = 0,
  right = 2,
  top = 0,
  bottom = 0,
}
config.allow_win32_input_mode = true
config.debug_key_events = false
local act = wezterm.action
config.disable_default_key_bindings = true
config.keys = {
  -- clipboard stuff
  { key = 'c', mods = 'SHIFT|CTRL', action = act.CopyTo 'Clipboard' },
  { key = 'C', mods = 'SHIFT|CTRL', action = act.CopyTo 'Clipboard' },
  { key = 'Copy', mods = 'NONE', action = act.CopyTo 'Clipboard' },
  { key = 'v', mods = 'SHIFT|CTRL', action = act.PasteFrom 'Clipboard' },
  { key = 'V', mods = 'SHIFT|CTRL', action = act.PasteFrom 'Clipboard' },
  { key = 'Paste', mods = 'NONE', action = act.PasteFrom 'Clipboard' },
  -- tab management
  { key = ']', mods = 'SUPER', action = act.ActivateTabRelative(1) },
  { key = '[', mods = 'SUPER', action = act.ActivateTabRelative(-1) },
  { key = '\\', mods = 'SUPER', action = act.SpawnTab 'CurrentPaneDomain' },
  { key = 'Delete', mods = 'SUPER', action = act.CloseCurrentTab{ confirm = false } },
  -- some extra stuff
  { key = 'F11', action = act.ToggleFullScreen },
  { key = 'l', mods = 'SHIFT|CTRL', action = act.ShowDebugOverlay },
  { key = 'L', mods = 'SHIFT|CTRL', action = act.ShowDebugOverlay },
  -- needed for some keybindings in vim
  { key = 'Enter', mods = 'SHIFT|CTRL', action = act{SendString="\x1b[13;6u"}},
  { key = 'Enter', mods = 'SHIFT', action = act{SendString="\x1b[13;2u"}},
  { key = 'Enter', mods = 'CTRL', action = act{SendString="\x1b[13;5u"}},

  -- { key = '!', mods = 'CTRL', action = act.ActivateTab(0) },
  -- { key = '!', mods = 'SHIFT|CTRL', action = act.ActivateTab(0) },
  -- { key = '#', mods = 'CTRL', action = act.ActivateTab(2) },
  -- { key = '#', mods = 'SHIFT|CTRL', action = act.ActivateTab(2) },
  -- { key = '$', mods = 'CTRL', action = act.ActivateTab(3) },
  -- { key = '$', mods = 'SHIFT|CTRL', action = act.ActivateTab(3) },
  -- { key = '%', mods = 'ALT|CTRL', action = act.SplitHorizontal{ domain =  'CurrentPaneDomain' } },
  -- { key = '%', mods = 'CTRL', action = act.ActivateTab(4) },
  -- { key = '%', mods = 'SHIFT|ALT|CTRL', action = act.SplitHorizontal{ domain =  'CurrentPaneDomain' } },
  -- { key = '%', mods = 'SHIFT|CTRL', action = act.ActivateTab(4) },
  -- { key = '&', mods = 'CTRL', action = act.ActivateTab(6) },
  -- { key = '&', mods = 'SHIFT|CTRL', action = act.ActivateTab(6) },
  -- { key = '(', mods = 'CTRL', action = act.ActivateTab(-1) },
  -- { key = '(', mods = 'SHIFT|CTRL', action = act.ActivateTab(-1) },
  -- { key = ')', mods = 'CTRL', action = act.ResetFontSize },
  -- { key = ')', mods = 'SHIFT|CTRL', action = act.ResetFontSize },
  -- { key = '*', mods = 'CTRL', action = act.ActivateTab(7) },
  -- { key = '*', mods = 'SHIFT|CTRL', action = act.ActivateTab(7) },
  -- { key = '+', mods = 'CTRL', action = act.IncreaseFontSize },
  -- { key = '+', mods = 'SHIFT|CTRL', action = act.IncreaseFontSize },
  -- { key = '-', mods = 'CTRL', action = act.DecreaseFontSize },
  -- { key = '-', mods = 'SHIFT|CTRL', action = act.DecreaseFontSize },
  -- { key = '-', mods = 'SUPER', action = act.DecreaseFontSize },
  -- { key = '0', mods = 'CTRL', action = act.ResetFontSize },
  -- { key = '0', mods = 'SHIFT|CTRL', action = act.ResetFontSize },
  -- { key = '0', mods = 'SUPER', action = act.ResetFontSize },
  -- { key = '1', mods = 'SHIFT|CTRL', action = act.ActivateTab(0) },
  -- { key = '1', mods = 'SUPER', action = act.ActivateTab(0) },
  -- { key = '2', mods = 'SHIFT|CTRL', action = act.ActivateTab(1) },
  -- { key = '2', mods = 'SUPER', action = act.ActivateTab(1) },
  -- { key = '3', mods = 'SHIFT|CTRL', action = act.ActivateTab(2) },
  -- { key = '3', mods = 'SUPER', action = act.ActivateTab(2) },
  -- { key = '4', mods = 'SHIFT|CTRL', action = act.ActivateTab(3) },
  -- { key = '4', mods = 'SUPER', action = act.ActivateTab(3) },
  -- { key = '5', mods = 'SHIFT|ALT|CTRL', action = act.SplitHorizontal{ domain =  'CurrentPaneDomain' } },
  -- { key = '5', mods = 'SHIFT|CTRL', action = act.ActivateTab(4) },
  -- { key = '5', mods = 'SUPER', action = act.ActivateTab(4) },
  -- { key = '6', mods = 'SHIFT|CTRL', action = act.ActivateTab(5) },
  -- { key = '6', mods = 'SUPER', action = act.ActivateTab(5) },
  -- { key = '7', mods = 'SHIFT|CTRL', action = act.ActivateTab(6) },
  -- { key = '7', mods = 'SUPER', action = act.ActivateTab(6) },
  -- { key = '8', mods = 'SHIFT|CTRL', action = act.ActivateTab(7) },
  -- { key = '8', mods = 'SUPER', action = act.ActivateTab(7) },
  -- { key = '9', mods = 'SHIFT|CTRL', action = act.ActivateTab(-1) },
  -- { key = '9', mods = 'SUPER', action = act.ActivateTab(-1) },
  -- { key = '=', mods = 'CTRL', action = act.IncreaseFontSize },
  -- { key = '=', mods = 'SHIFT|CTRL', action = act.IncreaseFontSize },
  -- { key = '=', mods = 'SUPER', action = act.IncreaseFontSize },
  -- { key = '@', mods = 'CTRL', action = act.ActivateTab(1) },
  -- { key = '@', mods = 'SHIFT|CTRL', action = act.ActivateTab(1) },
  -- { key = 'C', mods = 'CTRL', action = act.CopyTo 'Clipboard' },
  -- { key = 'DownArrow', mods = 'SHIFT|ALT|CTRL', action = act.AdjustPaneSize{ 'Down', 1 } },
  -- { key = 'DownArrow', mods = 'SHIFT|CTRL', action = act.ActivatePaneDirection 'Down' },
  -- { key = 'Enter', mods = 'SHIFT|CTRL', action = act{SendString="\x1b[13;6u"}},
  -- { key = 'F', mods = 'CTRL', action = act.Search 'CurrentSelectionOrEmptyString' },
  -- { key = 'F', mods = 'SHIFT|CTRL', action = act.Search 'CurrentSelectionOrEmptyString' },
  -- { key = 'Insert', mods = 'CTRL', action = act.CopyTo 'PrimarySelection' },
  -- { key = 'Insert', mods = 'SHIFT', action = act.PasteFrom 'PrimarySelection' },
  -- { key = 'K', mods = 'CTRL', action = act.ClearScrollback 'ScrollbackOnly' },
  -- { key = 'K', mods = 'SHIFT|CTRL', action = act.ClearScrollback 'ScrollbackOnly' },
  -- { key = 'L', mods = 'CTRL', action = act.ShowDebugOverlay },
  -- { key = 'LeftArrow', mods = 'SHIFT|ALT|CTRL', action = act.AdjustPaneSize{ 'Left', 1 } },
  -- { key = 'LeftArrow', mods = 'SHIFT|CTRL', action = act.ActivatePaneDirection 'Left' },
  -- { key = 'M', mods = 'CTRL', action = act.Hide },
  -- { key = 'M', mods = 'SHIFT|CTRL', action = act.Hide },
  -- { key = 'N', mods = 'CTRL', action = act.SpawnWindow },
  -- { key = 'N', mods = 'SHIFT|CTRL', action = act.SpawnWindow },
  -- { key = 'P', mods = 'CTRL', action = act.ActivateCommandPalette },
  -- { key = 'P', mods = 'SHIFT|CTRL', action = act.ActivateCommandPalette },
  -- { key = 'PageDown', mods = 'CTRL', action = act.ActivateTabRelative(1) },
  -- { key = 'PageDown', mods = 'SHIFT', action = act.ScrollByPage(1) },
  -- { key = 'PageDown', mods = 'SHIFT|CTRL', action = act.MoveTabRelative(1) },
  -- { key = 'PageUp', mods = 'CTRL', action = act.ActivateTabRelative(-1) },
  -- { key = 'PageUp', mods = 'SHIFT', action = act.ScrollByPage(-1) },
  -- { key = 'PageUp', mods = 'SHIFT|CTRL', action = act.MoveTabRelative(-1) },
  -- { key = 'R', mods = 'CTRL', action = act.ReloadConfiguration },
  -- { key = 'R', mods = 'SHIFT|CTRL', action = act.ReloadConfiguration },
  -- { key = 'RightArrow', mods = 'SHIFT|ALT|CTRL', action = act.AdjustPaneSize{ 'Right', 1 } },
  -- { key = 'RightArrow', mods = 'SHIFT|CTRL', action = act.ActivatePaneDirection 'Right' },
  -- { key = 'T', mods = 'CTRL', action = act.SpawnTab 'CurrentPaneDomain' },
  -- { key = 'T', mods = 'SHIFT|CTRL', action = act.SpawnTab 'CurrentPaneDomain' },
  -- { key = 'Tab', mods = 'CTRL', action = act.ActivateTabRelative(1) },
  -- { key = 'Tab', mods = 'SHIFT|CTRL', action = act.ActivateTabRelative(-1) },
  -- { key = 'U', mods = 'CTRL', action = act.CharSelect{ copy_on_select = true, copy_to =  'ClipboardAndPrimarySelection' } },
  -- { key = 'U', mods = 'SHIFT|CTRL', action = act.CharSelect{ copy_on_select = true, copy_to =  'ClipboardAndPrimarySelection' } },
  -- { key = 'UpArrow', mods = 'SHIFT|ALT|CTRL', action = act.AdjustPaneSize{ 'Up', 1 } },
  -- { key = 'UpArrow', mods = 'SHIFT|CTRL', action = act.ActivatePaneDirection 'Up' },
  -- { key = 'V', mods = 'CTRL', action = act.PasteFrom 'Clipboard' },
  -- { key = 'W', mods = 'CTRL', action = act.CloseCurrentTab{ confirm = true } },
  -- { key = 'W', mods = 'SHIFT|CTRL', action = act.CloseCurrentTab{ confirm = true } },
  -- { key = 'X', mods = 'CTRL', action = act.ActivateCopyMode },
  -- { key = 'X', mods = 'SHIFT|CTRL', action = act.ActivateCopyMode },
  -- { key = 'Z', mods = 'CTRL', action = act.TogglePaneZoomState },
  -- { key = 'Z', mods = 'SHIFT|CTRL', action = act.TogglePaneZoomState },
  -- { key = '[', mods = 'SHIFT|SUPER', action = act.ActivateTabRelative(-1) },
  -- { key = '\"', mods = 'ALT|CTRL', action = act.SplitVertical{ domain =  'CurrentPaneDomain' } },
  -- { key = '\"', mods = 'SHIFT|ALT|CTRL', action = act.SplitVertical{ domain =  'CurrentPaneDomain' } },
  -- { key = '\'', mods = 'SHIFT|ALT|CTRL', action = act.SplitVertical{ domain =  'CurrentPaneDomain' } },
  -- { key = ']', mods = 'SHIFT|SUPER', action = act.ActivateTabRelative(1) },
  -- { key = '^', mods = 'CTRL', action = act.ActivateTab(5) },
  -- { key = '^', mods = 'SHIFT|CTRL', action = act.ActivateTab(5) },
  -- { key = '_', mods = 'CTRL', action = act.DecreaseFontSize },
  -- { key = '_', mods = 'SHIFT|CTRL', action = act.DecreaseFontSize },
  -- { key = 'c', mods = 'SUPER', action = act.CopyTo 'Clipboard' },
  -- { key = 'f', mods = 'SHIFT|CTRL', action = act.Search 'CurrentSelectionOrEmptyString' },
  -- { key = 'f', mods = 'SUPER', action = act.Search 'CurrentSelectionOrEmptyString' },
  -- { key = 'k', mods = 'SHIFT|CTRL', action = act.ClearScrollback 'ScrollbackOnly' },
  -- { key = 'k', mods = 'SUPER', action = act.ClearScrollback 'ScrollbackOnly' },
  -- { key = 'm', mods = 'SHIFT|CTRL', action = act.Hide },
  -- { key = 'm', mods = 'SUPER', action = act.Hide },
  -- { key = 'n', mods = 'SHIFT|CTRL', action = act.SpawnWindow },
  -- { key = 'n', mods = 'SUPER', action = act.SpawnWindow },
  -- { key = 'p', mods = 'SHIFT|CTRL', action = act.ActivateCommandPalette },
  -- { key = 'phys:Space', mods = 'SHIFT|CTRL', action = act.QuickSelect },
  -- { key = 'r', mods = 'SHIFT|CTRL', action = act.ReloadConfiguration },
  -- { key = 'r', mods = 'SUPER', action = act.ReloadConfiguration },
  -- { key = 't', mods = 'SHIFT|CTRL', action = act.SpawnTab 'CurrentPaneDomain' },
  -- { key = 't', mods = 'SUPER', action = act.SpawnTab 'CurrentPaneDomain' },
  -- { key = 'u', mods = 'SHIFT|CTRL', action = act.CharSelect{ copy_on_select = true, copy_to =  'ClipboardAndPrimarySelection' } },
  -- { key = 'v', mods = 'SUPER', action = act.PasteFrom 'Clipboard' },
  -- { key = 'w', mods = 'SUPER', action = act.CloseCurrentTab{ confirm = true } },
  -- { key = 'x', mods = 'SHIFT|CTRL', action = act.ActivateCopyMode },
  -- { key = 'z', mods = 'SHIFT|CTRL', action = act.TogglePaneZoomState },
  -- { key = '{', mods = 'SHIFT|SUPER', action = act.ActivateTabRelative(-1) },
  -- { key = '}', mods = 'SHIFT|SUPER', action = act.ActivateTabRelative(1) },
}

-- and finally, return the configuration to wezterm
return config
