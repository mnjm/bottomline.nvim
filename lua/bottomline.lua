--------------------------------------------------------------------------------------------------
--------------------------------- bottomline.nvim ------------------------------------------------
--------------------------------------------------------------------------------------------------
-- Author - mnjm - github.com/mnjm
-- Repo - github.com/mnjm/bottomline.nvim
-- File - lua/bottomline.lua
-- License - Refer github

local M = {}

local modules = {
    config = require('bottomline.config'),
    utils = require('bottomline.utils'),
}

-- Get the current mode
local function get_mode()
    local mode = modules.utils.mode_lookup()
    return string.format(" %s ", mode), "BLMode"
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
    ret = string.format("%s %s %s ", ret, M.config.git_symbols.branch, gitsigns.head)
    return ret
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
    ret = ret ~= "" and string.format("%s", ret) or ""
    return ret
end

-- Get filepath with flags(modified, readonly, helpfile, preview)
local function get_filepath()
    return " %<%F%m%r%h%w "
end

-- Get filetype
local function get_filetype()
    local icon = modules.utils.get_icon(vim.fn.expand("%p"))
    local ftype = vim.bo.filetype
    if ftype == '' then return '' end
    return string.format(' %s %s ', icon, ftype):lower()
end

-- Get column, linenumber and percent of document
local function get_lineinfo()
  if vim.bo.filetype == "alpha" then
    return ""
  end
  return " %c:%l(%p%%) "
end

-- Display current buffer number
local function get_buffernumber()
    return " B:%n "
end

-- Winbar
local generate_winbar = function()
    local winbar = ""
    if modules.utils.get_active_win_count() > 1 then -- if more than 1 fixed windows in the current tabpage
        winbar = "%#BLWinbarTitle# %<%t%m%r %#BLWinbarFill#"
        if M.config.display_buf_no then
            winbar = winbar .. "%=%#BLWinbarTrail#" .. get_buffernumber()
        end
    end
    -- set winbar
    vim.opt.winbar = winbar
end

M.active = function()
    local mode, mode_color = get_mode()
    mode_color = "%#"..mode_color.."#"
    local lspinfo = get_lspinfo()
    local ret = table.concat {
        mode_color, mode,
        "%#BLGitInfo#", get_gitinfo(),
        "%#BLFill#", "%=",
        mode_color, get_filepath(),
        "%#BLFill#", "%=",
        "%#BLOtherInfo#", lspinfo,
        "%#BLTrail#", get_filetype(),
    }
    if M.config.display_buf_no then
        ret = ret .. table.concat {
            "%#BLGitInfo#", get_lineinfo(),
            mode_color, get_buffernumber(),
        }
    else
        ret = ret .. table.concat {
            mode_color, get_lineinfo(),
        }
    end
    return ret
end

M.inactive = function()
    return table.concat {
        "%#BLFill#", "%=",
        "%#BLTrail#", get_filepath(),
        "%#BLFill#", "%=",
        "%#BLTrail#", get_buffernumber()
    }
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
        'ModeChanged'
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
    modules.utils.setup_highlights(M.config.highlights)
end

function M.setup(cfg)
    -- Exposing plugin
    _G._bottomline = M
    -- Config
    M.config = modules.config.init_config(cfg)
    -- init
    init_bottomline()
    -- Create statusline autocommands
    setup_statusline()
    -- enable winbar
    setup_winbar()
end

return M
