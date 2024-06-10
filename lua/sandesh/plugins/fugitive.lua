return {
  'tpope/vim-fugitive',
  config = function ()
    vim.keymap.set("n", "<leader>gs", vim.cmd.Git)
    vim.keymap.set("n", "<leader>gtd", vim.cmd.Gdiffsplit)
    vim.keymap.set("n", "<leader>gw", vim.cmd.Gwrite)

    -- Still need to figure out what this does
    vim.keymap.set("n", "<leader>gtr", vim.cmd.Gread)

    vim.api.nvim_set_keymap('n', '<leader>gb', ':Git blame<CR>', { noremap = true, desc="Git blame"})
    -- Commit.sh should be in your binaries 
    vim.keymap.set('n', '<leader>gc', function ()
      vim.cmd("!commit.sh")
    end)

    vim.api.nvim_set_keymap('n', '<leader>gp', ':Git pull --rebase origin main<CR>', { noremap = true, desc="Git pull with rebase"})
    vim.api.nvim_set_keymap('n', '<leader>gh', ':Git push<CR>', { noremap = true, desc="Git push"})
    vim.api.nvim_set_keymap('n', '<leader>gh', ':Git push<CR>', { noremap = true, desc="Git push"})
    vim.api.nvim_set_keymap('n', '<leader>pu', ':diffput<CR>', { noremap = true, desc="Put current side's changes"})
    vim.api.nvim_set_keymap('n', '<leader>ge', ':diffget<CR>', { noremap = true, desc="Get the other side's changes"})
    vim.api.nvim_set_keymap('n', '<leader>mer', ':Gvdiffsplit!<CR>', { noremap = true, desc="3 way split"})
  end
}
