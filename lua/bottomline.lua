---------------------------------------------------
----------------- BottomLine Main -----------------
---------------------------------------------------
-- Author - mnjm - github.com/mnjm
-- Repo - github.com/mnjm/bottomline.nvim

local M = {}

local default_config = {
    highlights = {
        {'BLFill',          {fg = "#ffffff", bg="#282828", bold = false}},
        {'BLNormalMode',    {fg = "#000000", bg="#5faf00", bold = true}},
        {'BLReplaceMode',   {fg = "#000000", bg="#d7875f", bold = true}},
        {'BLCommandMode',   {fg = "#000000", bg="#ffaf00", bold = true}},
        {'BLInsertMode',    {fg = "#000000", bg="#5fafd7", bold = true}},
        {'BLVisualMode',    {fg = "#000000", bg="#ff5faf", bold = true}},
        {'BLUnknownMode',   {fg = "#000000", bg="#b3684f", bold = true}},
        {'BLTrail',         {fg = "#ffffff", bg="#585858", bold = false}},
        {'BLOtherInfo',     {fg = "#000000", bg="#5f8787", bold = false}},
        {'BLFileInfo',      {fg = "#000000", bg="#00afaf", bold = true}},
    },
    enable_git = true,
    enable_lsp = true,
    enable_winbar = true,
    display_buf_no = false,
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

local validate_config = function(cfg)
    vim.validate({ highlights = { cfg.highlights, "table" } })
    vim.validate({ git_symbols = { cfg.git_symbols, "table" } })
    vim.validate({ lsp_symbols = { cfg.lsp_symbols, "table" } })
    vim.validate({ enable_git = { cfg.enable_git, "boolean" } })
    vim.validate({ enable_lsp = { cfg.enable_lsp, "boolean" } })
    vim.validate({ enable_winbar = { cfg.enable_winbar, "boolean" } })
    vim.validate({ display_buf_no = { cfg.display_buf_no, "boolean" } })
end

local init_config = function(cfg)
    vim.validate({ cfg = { cfg, 'table' } })
    cfg = cfg or {}
    local config = vim.tbl_deep_extend("keep", cfg, default_config)
    validate_config(config)
    return config
end

local setup_highlights = function()
    -- Set highlights listed in config
    local highlights = M.config.highlights
    for _, hl in pairs(highlights) do
        vim.api.nvim_set_hl(0, hl[1], hl[2])
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
--
-- [helperfuc] check if given window is relative
local is_window_relative = function(win_id)
    return vim.api.nvim_win_get_config(win_id).relative ~= ''
end

-- Winbar
local generate_winbar = function()
    local wins = vim.api.nvim_tabpage_list_wins(0) -- get windows in the current tabpage
    -- count fixed (non relative windows)
    local count = 0
    for _, win_id in ipairs(wins) do
        if not is_window_relative(win_id) then count = count + 1 end
    end
    local winbar = ""
    if count > 1 then -- if more than 1 fixed windows in the current tabpage
        winbar = "%#BLFileInfo# %<%t%m%r %#BLFill#"
        if M.config.display_buf_no then
            winbar = winbar .. "%=%#BLFileInfo#" .. get_buffernumber()
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
        "%#BLOtherInfo#", get_gitinfo(),
        "%#BLFill#", "%=",
        "%#BLFileInfo#", get_filepath(),
        "%#BLFill#", "%=",
        "%#BLOtherInfo#", lspinfo,
        "%#BLTrail#", get_filetype(),
    }
    if M.config.display_buf_no then
        ret = ret .. table.concat {
            "%#BLOtherInfo#", get_lineinfo(),
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
    vim.opt.statusline='%!v:lua._bottomline.active()'
    local _au = vim.api.nvim_create_augroup('BottomLine statusline', { clear = true })
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

function M.setup(cfg)
    -- Exposing plugin
    _G._bottomline = M
    -- Config
    M.config = init_config(cfg)
    -- Create highlights
    setup_highlights()
    -- Create statusline autocommands
    setup_statusline()
    -- enable winbar
    setup_winbar()
end

return M
