local vim = vim
local opt = vim.opt

opt.foldmethod = "expr"
opt.foldlevelstart=99
opt.foldexpr = "nvim_treesitter#foldexpr()"
