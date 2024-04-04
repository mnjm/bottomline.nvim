--------------------------------------------------------------------------------------------------
--------------------------------- bottomline.nvim ------------------------------------------------
--------------------------------------------------------------------------------------------------
-- Author - mnjm - github.com/mnjm
-- Repo - github.com/mnjm/bottomline.nvim
-- File - lua/bottomline/utils.lua
-- License - Refer github

local M = {}

-- Copied from lualine.nvim
local mode_map = {
  ['n']      = 'NORMAL',
  ['no']     = 'O-PENDING',
  ['nov']    = 'O-PENDING',
  ['noV']    = 'O-PENDING',
  ['no\22']  = 'O-PENDING',
  ['niI']    = 'NORMAL',
  ['niR']    = 'NORMAL',
  ['niV']    = 'NORMAL',
  ['nt']     = 'NORMAL',
  ['ntT']    = 'NORMAL',
  ['v']      = 'VISUAL',
  ['vs']     = 'VISUAL',
  ['V']      = 'V-LINE',
  ['Vs']     = 'V-LINE',
  ['\22']    = 'V-BLOCK',
  ['\22s']   = 'V-BLOCK',
  ['s']      = 'SELECT',
  ['S']      = 'S-LINE',
  ['\19']    = 'S-BLOCK',
  ['i']      = 'INSERT',
  ['ic']     = 'INSERT',
  ['ix']     = 'INSERT',
  ['R']      = 'REPLACE',
  ['Rc']     = 'REPLACE',
  ['Rx']     = 'REPLACE',
  ['Rv']     = 'V-REPLACE',
  ['Rvc']    = 'V-REPLACE',
  ['Rvx']    = 'V-REPLACE',
  ['c']      = 'COMMAND',
  ['cv']     = 'EX',
  ['ce']     = 'EX',
  ['r']      = 'REPLACE',
  ['rm']     = 'MORE',
  ['r?']     = 'CONFIRM',
  ['!']      = 'SHELL',
  ['t']      = 'TERMINAL',
}

M.mode_lookup = function()
    local mode = vim.api.nvim_get_mode().mode
    local ret = mode_map[mode]
    if not ret then ret = mode end
    return ret
end

M.setup_highlights = function(highlights)
    -- Set highlights listed in config
    if not highlights then return end
    for _, hl in pairs(highlights) do
        vim.api.nvim_set_hl(0, hl[1], hl[2])
    end
end

M.safe_require = function(module_name)
    local status_ok, mod = pcall(require, module_name)
    local ret = status_ok and mod or nil
    return ret
end

M.get_icon = function(fpath)
    local file_name, file_ext = vim.fn.fnamemodify(fpath, ":t"), vim.fn.fnamemodify(fpath, ":e")
    local nvim_icons = M.safe_require("nvim-web-devicons")
    local icon = ""
    if nvim_icons then
        icon = nvim_icons.get_icon(file_name, file_ext, { default = true })
    end
    return icon
end

--  check if given window is relative
M.is_window_relative = function(win_id)
    return vim.api.nvim_win_get_config(win_id).relative ~= ''
end

M.get_active_win_count = function(tab_no)
    if not tab_no then tab_no = 0 end
    local wins = vim.api.nvim_tabpage_list_wins(tab_no) -- get windows in the tabpage tabpage
    -- count fixed (non relative windows)
    local count = 0
    for _, win_id in ipairs(wins) do
        if not M.is_window_relative(win_id) then count = count + 1 end
    end
    return count
end

return M
