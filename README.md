# bottomline.nvim - Yet another neovim statusline

A simple minimal statusline plugin with gitsigns and LSP integrations.

![Demo image](./demo-imgs/1.png)
![Demo image](./demo-imgs/2.png)

## Installation

```
'mnjm/bottomline.nvim'
```
Install with your favorite plugin manager

Dependencies - Optional
- [gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim)
- [nvim-web-devicons](https://github.com/nvim-tree/nvim-web-devicons)

## Configurations

### Default configurations

```
highlights = {
    {'SLDefault',       {fg = "#ffffff", bg="#282828", gui=nil}},
    {'SLNormalMode',    {fg = "#000000", bg="#5faf00", gui="bold"}},
    {'SLReplaceMode',   {fg = "#000000", bg="#d7875f", gui="bold"}},
    {'SLCommandMode',   {fg = "#000000", bg="#ffaf00", gui="bold"}},
    {'SLInsertMode',    {fg = "#000000", bg="#5fafd7", gui="bold"}},
    {'SLVisualMode',    {fg = "#000000", bg="#ff5faf", gui="bold"}},
    {'SLUnknownMode',   {fg = "#000000", bg="#b3684f", gui="bold"}},
    {'SLTrail',         {fg = "#ffffff", bg="#585858", gui=nil}},
    {'SLOtherInfo',     {fg = "#000000", bg="#5f8787", gui=nil}},
    {'SLFileInfo',      {fg = "#000000", bg="#00afaf", gui="bold"}},
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
```

You can pass sub-table to custom configurations to setup call, for ex

```
require('bottomline.nvim').setup({
    highlights = {
        {'SLDefault',       {fg = "#000000", bg="#282828", gui=nil}},
        {'SLNormalMode',    {fg = "#ffffff", bg="#5faf00", gui="bold"}},
    },
    enable_lsp = false,
    git_symbols = { branch = "" },
})
```

## Addendum
This work is derived from
- https://nuxsh.is-a.dev/blog/custom-nvim-statusline.html
- https://elianiva.my.id/post/neovim-lua-statusline

