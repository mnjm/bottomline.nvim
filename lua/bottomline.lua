--------------------------------------------------------------------------------------------------
--------------------------------- bottomline.nvim ------------------------------------------------
--------------------------------------------------------------------------------------------------
-- Author - mnjm - github.com/mnjm
-- Repo - github.com/mnjm/bottomline.nvim
-- File - lua/bottomline.lua
-- License - Refer github

local M = {}

-- import modules
local config = require('bottomline.config')
local utils = require('bottomline.utils')
local seperators = require('bottomline.seperators')

-- Get the current mode
local function get_mode()
    local mode = utils.mode_lookup()
    return "%#BLMode#" .. string.format(" %s ", mode)
end

-- Get git info
local function get_gitinfo()
    if not M.config.enable_git then
        return ""
    end

    local gitsigns = vim.b.gitsigns_status_dict
    local ret = ""
    if (not gitsigns) or gitsigns.head == "" then
        return ret
    end
    local fmt  = {
        {gitsigns.added, M.config.git_symbols.added},
        {gitsigns.removed, M.config.git_symbols.removed},
        {gitsigns.changed, M.config.git_symbols.changed}
    }
    for _, v in ipairs(fmt) do
        if v[1] and v[1] ~= 0 then
            ret = string.format("%s %s%s", ret, v[2], v[1])
        end
    end
    ret = string.format("%%#BLGitInfo#%s %s %s ", ret, M.config.git_symbols.branch, gitsigns.head)
    -- add seperators
    return ret .. seperators.get_sep_with_hl("BLGitInfo", "BLFill", 1)
end

-- Get lsp info
local function get_lspinfo()
    if not M.config.enable_lsp then
        return ""
    end
    local ret = ""
    local map = {
        {vim.diagnostic.severity.ERROR, M.config.lsp_symbols.error},
        {vim.diagnostic.severity.WARN, M.config.lsp_symbols.warn},
        {vim.diagnostic.severity.INFO, M.config.lsp_symbols.info},
        {vim.diagnostic.severity.HINT, M.config.lsp_symbols.hint},
    }
    for _, s in ipairs(map) do
        local count = #vim.diagnostic.get(0, {severity = s[1]})
        if count ~=0 then
            ret = string.format("%s %s:%s ", ret, s[2], count)
        end
    end
    if not (ret == "") then
        ret = seperators.get_sep_with_hl("BLLspInfo", "BLFill", 2) .. "%#BLLspInfo#" .. ret
    end
    return ret
end

-- Get filepath with flags(modified, readonly, helpfile, preview)
local function get_filepath(active_flag)
    local hl = active_flag and "BLFile" or "BLFileInactive"
    local left_sep = seperators.get_sep_with_hl(hl, "BLFill", 2)
    local right_sep = seperators.get_sep_with_hl(hl, "BLFill", 1)
    local filepath = "%<%F%m%r%h%w"
    return string.format("%s%%#%s# %s %s", left_sep, hl, filepath, right_sep)
end

-- Get filetype
local function get_filetype()
    local icon = utils.get_icon(vim.fn.expand("%p"))
    local ftype = vim.bo.filetype
    if ftype == '' then return '' end
    return "%#BLFileType#" .. string.format(' %s %s ', icon, ftype):lower()
end

-- Get column, linenumber and percent of document
local function get_lineinfo()
  if vim.bo.filetype == "alpha" then
    return ""
  end
  return seperators.get_sep_with_hl("BLLine", "BLFileType", 2) .. "%#BLLine# [%c:%l](%p%%) "
end

-- Display current buffer number
local function get_buffernumber(active_flag)
    local sep, hl = nil, nil
    if active_flag then
        sep = seperators.get_sep_with_hl("BLBuf", "BLLine", 2)
        hl = "%#BLBuf#"
    else
        sep = seperators.get_sep_with_hl("BLBufInactive", "BLFill", 2)
        hl = "%#BLBufInactive#"
    end
    return sep .. hl .. " B:%n "
end

M.active = function()
    local gitinfo = get_gitinfo()
    local mode_sep = seperators.get_sep_with_hl("BLMode",
        gitinfo == "" and "BLFill" or "BLGitInfo", 1)
    local lspinfo = get_lspinfo()
    local ft_sep = seperators.get_sep_with_hl("BLFileType",
        lspinfo == "" and "BLFill" or "BLLspInfo", 2)
    local ret = table.concat {
        get_mode(), mode_sep,           -- mode
        gitinfo,                        -- git info
        "%#BLFill#", "%=",              -- filler
        get_filepath(true),             -- filepath
        "%#BLFill#", "%=",              -- filler
        lspinfo,
        ft_sep, get_filetype(),
        get_lineinfo(),
    }
    if M.config.display_buf_no then
        ret = ret .. table.concat {
            "%#BLBuf#", get_buffernumber(true),
        }
    end
    -- vim.print(ret)
    return ret
end

M.inactive = function()
    return table.concat {
        "%#BLFill#", "%=",
        get_filepath(false),
        "%#BLFill#", "%=",
        get_buffernumber(false),
    }
end

-- Winbar
local generate_winbar = function()
    local winbar = ""
    if utils.get_active_win_count() > 1 then -- if more than 1 fixed windows in the current tabpage
        winbar = "%#BLWinbarTitle# %<%t%m%r %#BLWinbarFill#"
        if M.config.display_buf_no then
            winbar = winbar .. "%=%#BLWinbarBuf#" .. get_buffernumber()
        end
    end
    -- set winbar
    vim.opt.winbar = winbar
end

local setup_statusline = function()
    -- set the statusline
    vim.opt.statusline='%!v:lua._bottomline.active()'
    local _au = vim.api.nvim_create_augroup('BottomLine statusline', { clear = true })
    local refresh_events = {
        'WinEnter',
        'BufEnter',
        'BufWritePost',
        'SessionLoadPost',
        'FileChangedShellPost',
        'VimResized',
        'Filetype',
        'CursorMoved',
        'CursorMovedI',
        'ModeChanged',
    }
    -- refresh aucmd
    vim.api.nvim_create_autocmd(refresh_events, {
        pattern = "*",
        command = 'setlocal statusline=%!v:lua._bottomline.active()',
        group = _au,
        desc = "Setup active statusline",
    })
    -- leave aucmd
    vim.api.nvim_create_autocmd({'WinLeave', 'BufLeave'}, {
        pattern = "*",
        command = 'setlocal statusline=%!v:lua._bottomline.inactive()',
        group = _au,
        desc = "Setup inactive statusline",
    })
end

local setup_winbar = function()
    if not M.config.enable_winbar then return end
    local _au = vim.api.nvim_create_augroup('BottomLine winbar', { clear = true })
    -- Winbar
    vim.api.nvim_create_autocmd({'WinEnter', 'WinLeave'}, {
        pattern = "*",
        callback = generate_winbar,
        group = _au,
        desc = "Setup winbar statusline",
    })
end

local init_bottomline = function()
    -- Create highlights
    utils.setup_highlights(M.config.highlights)
    -- Initialize seperator highlights
    utils.setup_highlights(seperators.get_seperator_highlights(M.config.seperators))
end

function M.setup(cfg)
    -- Exposing plugin
    _G._bottomline = M
    -- Config
    M.config = config.init_config(cfg)
    -- init
    init_bottomline()
    -- Create statusline autocommands
    setup_statusline()
    -- enable winbar
    setup_winbar()
end

return M
