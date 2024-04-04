--------------------------------------------------------------------------------------------------
--------------------------------- bottomline.nvim ------------------------------------------------
--------------------------------------------------------------------------------------------------
-- Author - mnjm - github.com/mnjm
-- Repo - github.com/mnjm/bottomline.nvim
-- File - lua/bottomline/seperators.lua
-- License - Refer github

local M = {}

M.seperator_hls = {}
M.enabled = false
M.seperators = nil

local hl_transitions = {
    -- active
    {'BLMode', 'BLGitInfo'},
    {'BLMode', 'BLFill'},
    {'BLGitInfo', 'BLFill'},
    {'BLFile', 'BLFill'},
    {'BLLspInfo', 'BLFill'},
    {'BLFileType', 'BLFill'},
    {'BLFileType', 'BLLspInfo'},
    {'BLLine', 'BLFileType'},
    {'BLBuf', 'BLLine'},
    -- inactive
    {'BLFileInactive', 'BLFill'},
    {'BLBufInactive', 'BLFill'},
}

local is_sep_empty = function(sep)
    local ret = true
    ret = ret and (#sep[1] == 0)
    ret = ret and (#sep[2] == 0)
    return ret
end

M.get_seperator_highlights = function(seps)
    M.enabled = not is_sep_empty(seps)
    local ret = {}
    if not M.enabled then return ret end
    M.seperators = seps
    for _, hl_t in ipairs(hl_transitions) do
        local fg = vim.api.nvim_get_hl(0, { name = hl_t[1], link = false }).bg
        local bg = vim.api.nvim_get_hl(0, { name = hl_t[2], link = false }).bg
        local name = string.format("%s_2_%s", hl_t[1], hl_t[2])
        ret[name] = {fg = fg, bg = bg}
    end
    return ret
end

M.get_sep_with_hl = function(hl_1, hl_2, idx)
    if not M.enabled then return "" end
    local hl_grp = "%#" .. string.format("%s_2_%s", hl_1, hl_2) .. "#"
    return hl_grp .. M.seperators[idx]
end

return M
