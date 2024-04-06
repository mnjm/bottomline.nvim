--------------------------------------------------------------------------------------------------
--------------------------------- bottomline.nvim ------------------------------------------------
--------------------------------------------------------------------------------------------------
-- Author - mnjm - github.com/mnjm
-- Repo - github.com/mnjm/bottomline.nvim
-- File - lua/bottomline/config.lua
-- License - Refer github

local M = {}

-- default configurations
local default_config = {
    -- bottomline highlights
    highlights = {
        -- Active Statusline
        BLMode          = {fg = "#000000", bg = "#5faf5f", bold = true},
        BLGitInfo       = {fg = "#000000", bg="#5f8787", bold = false},
        BLFill          = {fg = "#ffffff", bg="#282828", bold = false},
        BLFile          = {link = 'BLMode'},
        BLLspInfo       = {link = 'BLGitInfo'},
        BLFileType      = {fg = "#ffffff", bg = "#878787", bold = false},
        BLLine          = {fg = "#ffffff", bg="#585858", bold = false},
        BLBuf           = {link = 'BLMode'},
        -- Inactive statusline
        BLFileInactive  = {link = 'BLFileType'},
        BLBufInactive   = {link = 'BLFileInactive'},
    },
    seperators = { '', '' },              -- seperators icons
    -- seperators = { '',  '' },
    -- seperators = { '',  '' },
    enable_git = true,                    -- enable git section
    enable_lsp = true,                    -- enable lstp section
    enable_winbar = true,                 -- enable winbar
    display_buf_no = false,               -- add additional buf number section at the end of statusline
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
    winbar = {
        enable = true,
        display_buf_no = true,      -- add additional buf no to end of winbar
        seperators = nil,           -- if this is nil one from Statusline config will be used
        -- Winbar highlights
        highlights = {
            BlWinbarTitle   = {link = 'BLMode'},
            BLWinbarFill    = {link = 'BLFill'},
            BLWinbarBuf     = {link = 'BLGitInfo'},
        }
    }
}

-- winbar config validator
local validate_winbar_config = function (cfg)
    vim.validate({ winbar = { cfg, "table" } })
    -- dont bother checking if winbar is disabled
    if not cfg.enable then return end
    vim.validate({ display_buf_no = { cfg.display_buf_no, "boolean" }})
    if cfg.seperators then vim.validate({ seperators = { cfg.seperators, "table" }}) end
    vim.validate({ highlights = { cfg.highlights, "table" }})
end

-- config validator
-- @param cfg config to validate
local validate_config = function(cfg)
    vim.validate({ highlights = { cfg.highlights, "table" } })
    vim.validate({ seperators = { cfg.seperators, "table" } })
    vim.validate({ git_symbols = { cfg.git_symbols, "table" } })
    vim.validate({ lsp_symbols = { cfg.lsp_symbols, "table" } })
    vim.validate({ enable_git = { cfg.enable_git, "boolean" } })
    vim.validate({ enable_lsp = { cfg.enable_lsp, "boolean" } })
    vim.validate({ display_buf_no = { cfg.display_buf_no, "boolean" } })
end

-- initialize config
-- @param cfg custom config from setup call
M.init_config = function(cfg)
    -- if not not passed create a empty table
    cfg = cfg or {}
    vim.validate({ cfg = { cfg, 'table' } })
    -- extend default_config and keep the changes from custom config (cfg)
    local config = vim.tbl_deep_extend("keep", cfg, default_config)
    validate_config(config)
    validate_winbar_config(config.winbar)
    return config
end

return M
