-- Author - mnjm - github.com/mnjm
-- Repo - github.com/mnjm/bottomline.nvim

---------------------------------------------------
----------------- BottomLine Main -----------------
---------------------------------------------------

local M = {}

local default_config = {
    highlights = {
        {'BLDefault',       {fg = "#ffffff", bg="#282828", gui=nil}},
        {'BLNormalMode',    {fg = "#000000", bg="#5faf00", gui="bold"}},
        {'BLReplaceMode',   {fg = "#000000", bg="#d7875f", gui="bold"}},
        {'BLCommandMode',   {fg = "#000000", bg="#ffaf00", gui="bold"}},
        {'BLInsertMode',    {fg = "#000000", bg="#5fafd7", gui="bold"}},
        {'BLVisualMode',    {fg = "#000000", bg="#ff5faf", gui="bold"}},
        {'BLUnknownMode',   {fg = "#000000", bg="#b3684f", gui="bold"}},
        {'BLTrail',         {fg = "#ffffff", bg="#585858", gui=nil}},
        {'BLOtherInfo',     {fg = "#000000", bg="#5f8787", gui=nil}},
        {'BLFileInfo',      {fg = "#000000", bg="#00afaf", gui="bold"}},
    },
    enable_git = true,
    enable_lsp = true,
    git_symbols = {
        branch = "",
        added = "+",
        removed = "-",
        changed = "~",
    },
    lsp_symbols = {
        error = "Err",
        warn = "Wrn",
        info = "Info",
        hint = "Hint",
    },
}

local init_config = function(cfg)
    cfg = cfg or {}
    M.config = vim.tbl_deep_extend("keep", cfg, default_config)
end

local setup_highlights = function()
    local highlights = M.config.highlights
    for _, highlight in pairs(highlights) do
        local name = highlight[1]
        local fg = highlight[2].fg
        local bg = highlight[2].bg
        local gui = highlight[2].gui == nil and "" or string.format("gui=%s", highlight[2].gui)
        vim.cmd(string.format('hi %s guibg=%s guifg=%s %s', name, bg, fg, gui))
    end
end

-- Show mode
local modes = {
    ["n"] = {"NORMAL", 'BLNormalMode'},
    ["no"] = {"NORMAL", 'BLNormalMode'},
    ["v"] = {"VISUAL", 'BLVisualMode'},
    ["V"] = {"V-LINE", 'BLVisualMode'},
    [""] = {"V-BLOCK", 'BLVisualMode'},
    ["s"] = {"SELECT"},
    ["S"] = {"S-LINE"},
    [""] = {"S-BLOCK"},
    ["i"] = {"INSERT", "BLInsertMode"},
    ["ic"] = {"INSERT", "BLInsertMode"},
    ["R"] = {"REPLACE", "BLReplaceMode"},
    ["Rv"] = {"V-REPLACE", "BLReplaceMode"},
    ["c"] = {"COMMAND", "BLCommandMode"},
    ["cv"] = {"VIM EX"},
    ["ce"] = {"EX"},
    ["r"] = {"PROMPT"},
    ["rm"] = {"MOAR"},
    ["r?"] = {"CONFIRM"},
    ["!"] = {"SHELL"},
    ["t"] = {"TERMINAL"},
}

-- Get the current mode
local function get_mode()
    local current_mode = vim.api.nvim_get_mode().mode
    current_mode = modes[current_mode]
    if current_mode == nil then
        current_mode = {"  ?  ", "BLUnknownMode"}
    end
    if current_mode[2] == nil then
        current_mode[2] = "BLUnknownMode"
    end
    return string.format(" %s ", current_mode[1]), current_mode[2]
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
        {vim.diagnostic.severity.ERROR, default_config.lsp_symbols.error},
        {vim.diagnostic.severity.WARN, default_config.lsp_symbols.warn},
        {vim.diagnostic.severity.INFO, default_config.lsp_symbols.info},
        {vim.diagnostic.severity.HINT, default_config.lsp_symbols.hint},
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

local safe_require = function(module_name)
    local status_ok, mod = pcall(require, module_name)
    if not status_ok then
        return nil
    else
        return mod
    end
end
-- Get filetype
local function get_filetype()
    local file_name, file_ext = vim.fn.expand("%:t"), vim.fn.expand("%:e")
    local dev_icons = safe_require("nvim-web-devicons")
    local icon = ""
    if dev_icons then
        icon = dev_icons.get_icon(file_name, file_ext, { default = true })
    end
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
local set_winbar = function()
    local wins = vim.api.nvim_tabpage_list_wins(0) -- get windows in the current tabpage
    if #wins > 1 then -- if more than 1 windows in the current tabpage
        vim.opt.winbar = table.concat {
            "%#BLFileInfo#", " %<%t%m%r ",
            "%#BLDefault#", "%=",
            "%#BLNormalMode#", get_buffernumber()
        }
        return
    end
    vim.opt.winbar = ""
end

M.active = function()
    local mode, mode_color = get_mode()
    mode_color = "%#"..mode_color.."#"
    local lspinfo = get_lspinfo()
    return table.concat {
        mode_color, mode,
        "%#BLOtherInfo#", get_gitinfo(),
        "%#BLDefault#", "%=",
        "%#BLFileInfo#", get_filepath(),
        "%#BLDefault#", "%=",
        "%#BLOtherInfo#", lspinfo,
        "%#BLTrail#", get_filetype(),
        mode_color, get_lineinfo(),
    }
end

M.inactive = function()
    return table.concat {
        "%#BLDefault#", "%=",
        "%#BLTrail#", get_filepath(),
        "%#BLDefault#", "%=",
        "%#BLTrail#", get_buffernumber()
    }
end

local setup_statusline = function()
    vim.opt.statusline='%!v:lua._bottomline.active()'
    local _au = vim.api.nvim_create_augroup('BottomLine augroup', { clear = true })
    -- enter aucmd
    vim.api.nvim_create_autocmd({'WinEnter', 'BufEnter'}, {
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
    -- Winbar
    vim.api.nvim_create_autocmd({'WinEnter', 'WinLeave'}, {
        pattern = "*",
        callback = set_winbar,
        group = _au,
        desc = "Setup winbar statusline",
    })
end

function M.setup(cfg)
    -- Exposing plugin
    _G._bottomline = M
    -- Config
    init_config(cfg)
    -- Create highlights
    setup_highlights()
    -- Create statusline autocommands
    setup_statusline()
end

return M
