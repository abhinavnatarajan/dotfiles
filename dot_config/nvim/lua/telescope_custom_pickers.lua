local buffers_picker = require("telescope.builtin").buffers
local action_state = require("telescope.actions.state")
local state = require("telescope.state")
local actions = require("telescope.actions")
local bufdelete = require("bufdelete").bufdelete
local Path = require "plenary.path"

local M = {}

M.buffers = function()
  buffers_picker {
    attach_mappings = function(_, map)
      local buffer_delete = function(prompt_bufnr)
        local current_picker = action_state.get_current_picker(prompt_bufnr)
        current_picker:delete_selection(
          function(selection) bufdelete(selection.bufnr, true) end
        )
      end
      map("n", "d", buffer_delete)
      map("i", "<C-d>", buffer_delete)
      return true
    end
  }
end

-- M.projects = function()
--   projects_picker {
--     attach_mappings = function()
--       local cwd = function(prompt_bufnr, prompt)
--         local entry = state.get_selected_entry(prompt_bufnr)
--         if entry == nil then
--           actions.close(prompt_bufnr)
--           return
--         end
--         local project_path = entry.value
--         if prompt == true then
--           actions._close(prompt_bufnr, true)
--         else
--           actions.close(prompt_bufnr)
--         end
--         local cd_successful = project.set_pwd(project_path, "telescope")
--         return project_path, cd_successful
--       end
--       actions.select_default:replace(cwd)
--       return true
--     end
--   }
-- end

-- return Path file on success, otherwise nil
local create = function(file, finder)
  if not file then
    return
  end
  local os_sep = Path.path.sep
  if
    file == ""
    or (finder.files and file == finder.path .. os_sep)
    or (not finder.files and file == finder.cwd .. os_sep)
  then
    if not finder.quiet then
      vim.notify("Please enter a valid file or folder name!", vim.log.levels.WARN)
    end
    return
  end
  file = Path:new(file)
  if not file:is_dir() then
    file:touch { parents = true }
  else
    Path:new(file.filename:sub(1, -2)):mkdir { parents = true }
  end
  return file
end

M.save_as = function(opts)
  local fb_picker = require("telescope").extensions.file_browser
  local fb_utils = require("telescope._extensions.file_browser.utils")
  fb_picker.file_browser {
    prompt_title = "Save as",
    attach_mappings = function()
      local saveas = function(prompt_bufnr)
        local entry = action_state.get_selected_entry()
        local current_picker = action_state.get_current_picker(prompt_bufnr)
        local finder = current_picker.finder
        if entry == nil then
          -- vim.notify("No file selected!", "ERROR")
          local os_sep = Path.path.sep
          local input = (finder.files and finder.path or finder.cwd) .. os_sep .. current_picker:_get_prompt()
          local file = create(input, finder)
          if file then
            -- pretend new file path is entry
            local path = file:absolute()
            state.set_global_key("selected_entry", { path, value = path, path = path, Path = file })
            entry = action_state.get_selected_entry()
          end
        end
        if type(entry) == "table" then
          local entry_path = entry.Path
          if entry_path:is_dir() then
            finder.path = entry_path:absolute()
            fb_utils.redraw_border_title(current_picker)
            current_picker:refresh(
              finder,
              { new_prefix = fb_utils.relative_path_prefix(finder), reset_prompt = true, multi = current_picker._multi }
            )
          else
            actions.close(prompt_bufnr)
            vim.cmd("saveas! " .. entry_path:absolute())
            local close_current = opts.close_current or false
            if close_current then bufdelete(vim.fn.bufnr('#'), true) end
          end
        end
      end
      actions.select_default:replace(saveas)
      return true
    end
  }
end

M.check_save_as = function()
  if vim.api.nvim_buf_get_name(0) == "" then
    require("telescope_custom_pickers").save_as{close_current=true}
  else
    vim.cmd [[w!]]
  end
end

M.config = function(opts)
  return require("telescope").extensions.file_browser.file_browser(vim.tbl_extend("force", opts or {}, {path=(string.gsub(vim.env.MYVIMRC, "/init.lua$", "")), prompt_title="Browse config files"}))
end

M.smart_find_files = function(opts)
  local builtin = require("telescope.builtin")
  local ok = pcall(builtin.git_files, opts)
  if not ok then
    builtin.find_files(opts)
  end
end

return M
