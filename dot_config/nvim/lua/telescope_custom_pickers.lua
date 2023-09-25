local buffers_picker = require("telescope.builtin").buffers
local state = require("telescope.actions.state")
local actions = require("telescope.actions")
local bufdelete = require("bufdelete").bufdelete

local M = {}

M.buffers = function()
  buffers_picker {
    attach_mappings = function(_, map)
      local buffer_delete = function(prompt_bufnr)
        local current_picker = state.get_current_picker(prompt_bufnr)
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

M.save_as = function(opts)
  local fb_picker = require("telescope").extensions.file_browser
  local fb_utils = require("telescope._extensions.file_browser.utils")
  fb_picker.file_browser {
    prompt_title = "Save as",
    attach_mappings = function()
      local saveas = function(prompt_bufnr)
        local entry = state.get_selected_entry()
        local current_picker = state.get_current_picker(prompt_bufnr)
        local finder = current_picker.finder
        if entry == nil then
          vim.notify("No file selected! To save a new file use i_<M-c> or n_C.", "ERROR")
        elseif type(entry) == "table" then
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
  if vim.bo.filetype == "" and vim.api.nvim_buf_get_name(0) == "" then
    require("telescope_custom_pickers").save_as{close_current=true}
  else
    vim.cmd [[w!]]
  end
end

M.oldfiles = function(opts)
  return require("telescope.builtin").oldfiles(vim.tbl_extend("force", opts or {}, {prompt_title="Recent files"}))
end

M.live_grep = function(opts)
  return require("telescope.builtin").live_grep(vim.tbl_extend("force", opts or {}, {prompt_title="Search text"}))
end

M.config = function(opts)
  return require("telescope").extensions.file_browser.file_browser(vim.tbl_extend("force", opts or {}, {path=(string.gsub(vim.env.MYVIMRC, "/init.lua$", "")), prompt_title="Browse config files"}))
end

M.workspaces = function(opts)
  return require('auto-session.session-lens').search_session(vim.tbl_extend("force", opts or {}, {previewer = false, prompt_title="Find workspace"}))
end

M.smart_find_files = function(opts)
  local builtin = require("telescope.builtin")
  local ok = pcall(builtin.git_files, opts)
  if not ok then
    builtin.find_files(opts)
  end
end

M.new_file = function()
  local window = require('window-picker').pick_window()
  if window then
    vim.api.nvim_set_current_win(window)
    vim.cmd([[ene | startinsert]])
  end
end
return M
