# bottomline.nvim
**Yet another neovim statusline**

A simple minimal statusline plugin that supports
- gitsigns
- LSP
- and winbar

### Screenshots
![Demo image](https://github.com/mnjm/github-media-repo/blob/main/bottomline.nvim/ss1.png)
![Demo image](https://github.com/mnjm/github-media-repo/blob/main/bottomline.nvim/ss2.png)
![Demo image](https://github.com/mnjm/github-media-repo/blob/main/bottomline.nvim/ss3.png)

- Checkout [topline.nvim](https://github.com/mnjm/topline.nvim) for tabline plugin

## Installation

```lua
'mnjm/bottomline.nvim'
```
Install with your favorite plugin manager

Dependencies - Optional
- [gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim)
- [nvim-web-devicons](https://github.com/nvim-tree/nvim-web-devicons)

## Configurations

### Default configurations

```lua
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
```

You can override default config by passing custom config to setup call, for ex

```lua
require('bottomline.nvim').setup({
    highlights = {
        BLMode = { fg="#282c34", bg="#98c379", bold=true },
    },
    -- seperators = { '',  '' },
    seperators = { '',  '' },
    git_symbols = { branch = "" },
    winbar = {
        enable = true,
        display_buf_no = true,
    }
})
```

## Addendum
This work is derived from
- https://nuxsh.is-a.dev/blog/custom-nvim-statusline.html
- https://elianiva.my.id/post/neovim-lua-statusline
- and [lualine.nvim](https://github.com/nvim-lualine/lualine.nvim)
