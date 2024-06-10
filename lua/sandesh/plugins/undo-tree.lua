return {
  'mbbill/undotree',
  config = function ()
    -- Lets you open up an undo tree
    vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)
  end
}
