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
        -- Winbar
        BlWinbarTitle   = {fg = "#000000", bg="#5faf00", bold = true},
        BLWinbarFill    = {link = 'BLFill'},
        BLWinbarBuf     = {link = 'BLFileType'},
    },
    seperators = { '', '' },                        -- section seperators
    -- seperators = { '',  '' },
    -- seperators = { '',  '' },
    enable_git = true,                              -- enable git section
    enable_lsp = true,                              -- enable lstp section
    enable_winbar = true,                           -- enable winbar
    display_buf_no = false,                         -- add aditional buf number section at the end of statusline
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

-- config validator
-- @param cfg config to validate
local validate_config = function(cfg)
    vim.validate({ highlights = { cfg.highlights, "table" } })
    vim.validate({ seperators = { cfg.seperators, "table" } })
    vim.validate({ git_symbols = { cfg.git_symbols, "table" } })
    vim.validate({ lsp_symbols = { cfg.lsp_symbols, "table" } })
    vim.validate({ enable_git = { cfg.enable_git, "boolean" } })
    vim.validate({ enable_lsp = { cfg.enable_lsp, "boolean" } })
    vim.validate({ enable_winbar = { cfg.enable_winbar, "boolean" } })
    vim.validate({ display_buf_no = { cfg.display_buf_no, "boolean" } })
end

-- initialize config
-- @param cfg custom config from setup call
M.init_config = function(cfg)
    vim.validate({ cfg = { cfg, 'table' } })
    cfg = cfg or {}
    -- extend default_config and keep the changes from custom config (cfg)
    local config = vim.tbl_deep_extend("keep", cfg, default_config)
    validate_config(config)
    return config
end

return M
