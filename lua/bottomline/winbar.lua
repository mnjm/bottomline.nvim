--------------------------------------------------------------------------------------------------
--------------------------------- bottomline.nvim ------------------------------------------------
--------------------------------------------------------------------------------------------------
-- Author - mnjm - github.com/mnjm
-- Repo - github.com/mnjm/bottomline.nvim
-- File - lua/bottomline/winbar.lua
-- License - Refer github

local M = {}
local utils = nil
local sep_module = nil

-- winbar generator
-- @return winbar string
local generate_winbar = function()
    local winbar = ""
    if utils and utils.get_active_win_count() > 1 then -- if more than 1 fixed windows in the current tabpage
        local sep = sep_module and sep_module.get_seperator("BLWinbarTitle", "BLWinbarFill", 1, true) or ""
        winbar = table.concat({
            "%#BLWinbarTitle# %<%t%m%r ",
            sep,
            "%#BLWinbarFill#"
        })
        if M.config.display_buf_no then
            sep = sep_module and sep_module.get_seperator("BLWinbarBuf", "BLWinbarFill", 2, true) or ""
            winbar = winbar .. table.concat({
                "%=",
                sep,
                "%#BLWinbarBuf# B:%n ",
            })
        end
    end
    -- set winbar
    vim.opt.winbar = winbar
end

-- create winbar aucmds
-- @params cfg winbar config tbl
local setup_winbar = function()
    local _au = vim.api.nvim_create_augroup('BottomLine winbar', { clear = true })
    -- Winbar
    vim.api.nvim_create_autocmd({'WinEnter', 'WinLeave'}, {
        pattern = "*",
        callback = generate_winbar,
        group = _au,
        desc = "Setup winbar statusline",
    })
end

-- initialize winbar
-- @param cfg bottomline config table
-- @param _utils reference to utils module
-- @param _sep_module reference to seperators module
M.init_winbar = function (cfg, _utils, _sep_module)
    -- validate
    vim.validate({ winbar = { cfg.winbar, "table" } })
    -- return if not enabled
    M.config = cfg.winbar
    if not M.config.enable then return end
    -- if seperators not found in winbar config then use bottomline's seperators
    if not M.config.seperators then M.config.seperators = cfg.seperators end
    utils = _utils
    sep_module = _sep_module
    -- setup highlights
    utils.setup_highlights(M.config.highlights)
    -- get transition highlights
    local hl_Ts = sep_module.prepare_seperator_highlights(M.config.seperators, true)
    utils.setup_highlights(hl_Ts)
    -- setup winbar
    setup_winbar()
end

return M
