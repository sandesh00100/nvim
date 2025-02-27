local cmp = require('cmp')
local luasnip = require('luasnip')
local bufNewFileCache = {}

require('luasnip.loaders.from_vscode').lazy_load()
luasnip.config.setup({})
-- rg "project: " | awk -F ': ' '$2 !=""  {print $2}' | sort | uniq
cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  completion = {
    completeopt = 'menu,menuone,noinsert',
  },
  mapping = cmp.mapping.preset.insert {
    ['<C-j>'] = cmp.mapping.select_next_item(), -- next suggestion
    ['<C-k>'] = cmp.mapping.select_prev_item(), -- previous suggestion
    ['<C-b>'] = cmp.mapping.scroll_docs(-4), -- scroll backward
    ['<C-f>'] = cmp.mapping.scroll_docs(4), -- scroll forward
    ['<C-Space>'] = cmp.mapping.complete {}, -- show completion suggestions
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    -- Tab through suggestions or when a snippet is active, tab to the next argument
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_locally_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    -- Tab backwards through suggestions or when a snippet is active, tab to the next argument
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.locally_jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  },
  sources = cmp.config.sources({
    { name = "nvim_lsp" }, -- lsp 
    { name = "luasnip" }, -- snippets
    { name = "buffer" }, -- text within current buffer
    { name = "path" }, -- file system paths
  }),
  window = {
    -- Add borders to completions popups
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
})

-- Filetype-specific setup
cmp.setup.filetype('markdown', {
  sources = cmp.config.sources({
    { name = 'project' },   -- And a snippet source
    { name = 'fileNames' },   -- And a snippet source
    { name = "nvim_lsp" }, -- lsp 
    { name = "luasnip" }, -- snippets
    { name = "buffer" }, -- text within current buffer
    { name = "path" }, -- file system paths
  })
})
vim.api.nvim_create_augroup("markdown-completion", {clear = true})
vim.api.nvim_create_autocmd("BufEnter", {
    group = "markdown-completion",
    pattern = "*.md",
    callback = function()
      vim.schedule(function ()
        vim.fn.system([[rg --no-filename --no-heading -g '*.md' -e '^tags:.*' 2>/dev/null | awk -F ':' '{print $2}' | tr ',' '\n' | awk '{$1=$1;print}' | sort | uniq > /tmp/tags-cmp-source.txt]])
        vim.fn.system([[rg --no-filename --no-heading -g '*.md' -e '^project:.*' 2>/dev/null | awk -F ':' '{print $2}' | tr ',' '\n' | awk '{$1=$1;print}' | sort | uniq > /tmp/project-cmp-source.txt]])
      end)
    end,
})

local function parseMarkdownHeaders(cwd)
  vim.fn.system("/Users/sandeshshrestha/git/scripts/parseMarkdownFile.py -f " .. cwd .. "| sort | uniq > /tmp/fileCompletion.txt")
  vim.notify("Completed file parsing")
end

vim.api.nvim_create_autocmd("BufNewFile", {
    group = "markdown-completion",
    pattern = "*.md",
    callback = function()
      local bufnr = vim.api.nvim_get_current_buf()
      if bufNewFileCache[bufnr] == nil then
        bufNewFileCache[bufnr] = true
      end
    end,
})


vim.api.nvim_create_autocmd({"VimEnter"},{
  group = "markdown-completion",
  pattern = "*/Notes/*",
  callback = function ()
    vim.schedule(function ()
      -- get the currrent working dir
      local cwd = vim.fn.getcwd()
      parseMarkdownHeaders(cwd)
    end)
  end
})


vim.api.nvim_create_autocmd({"BufWritePost"},{
  group = "markdown-completion",
  pattern = "*/Notes/*",
  callback = function ()
    local bufnr = vim.api.nvim_get_current_buf()
    if bufNewFileCache[bufnr] == true then
      vim.schedule(function ()
        local cwd = vim.fn.getcwd()
        parseMarkdownHeaders(cwd)
        bufNewFileCache[bufnr] = false
      end)
    end
  end
})
