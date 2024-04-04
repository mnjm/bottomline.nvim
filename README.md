# bottomline.nvim
**Yet another neovim statusline**

A simple minimal statusline plugin that supports
- gitsigns
- LSP

### Demo
-- TODO: Demp and ss are outdated will update soon :)
![Demo Gif](https://github.com/mnjm/github-media-repo/blob/ddf5161d67e9d15606602c8089d30a93dcddf70a/bottomline.nvim/demo.gif)
### Screenshots
![Demo image](https://github.com/mnjm/github-media-repo/blob/6a351736a158012ff40b008895c2a308e5aa4bdb/bottomline.nvim/1.png)
![Demo image](https://github.com/mnjm/github-media-repo/blob/6a351736a158012ff40b008895c2a308e5aa4bdb/bottomline.nvim/2.png)

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
highlights = {
    -- Active Statusline
    {'BLMode',          {fg = "#000000", bg="#00afaf", bold = true}},
    {'BLGitInfo',       {fg = "#000000", bg="#5f8787", bold = false}},
    {'BLFill',          {fg = "#ffffff", bg="#282828", bold = false}},
    {'BLFile',          {link = 'BLMode'}},
    {'BLLspInfo',       {link = 'BLGitInfo'}},
    {'BLFileType',      {fg = "#ffffff", bg="#585858", bold = false}},
    {'BLLine',          {link = 'BLLspInfo'}},
    {'BLBuf',           {link = 'BLMode'}},
    -- Inactive statusline
    {'BLFileInactive',  {link = 'BLFileType'}},
    {'BLBufInactive',   {link = 'BLFileInactive'}},
},
seperators = { '', '' },
enable_git = true,
enable_lsp = true,
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
```

You can override default config by passing custom config to setup call, for ex

```lua
require('bottomline.nvim').setup({
    highlights = {
        {'BLMode',    {fg = "#000000", bg="#5faf00", bold = true}},
    },
    -- seperators = { '',  '' },
    seperators = { '',  '' },
    enable_lsp = false,
    display_buf_no = true,
    git_symbols = { branch = "" },
})
```

## Addendum
This work is derived from
- https://nuxsh.is-a.dev/blog/custom-nvim-statusline.html
- https://elianiva.my.id/post/neovim-lua-statusline
- and [lualine.nvim](https://github.com/nvim-lualine/lualine.nvim)
