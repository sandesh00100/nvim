return {
  'folke/paint.nvim',
  opts = {
    highlights = {
      {
        filter = {filetype = 'markdown'},
        pattern = ".*QUESTION.*",
        hl = "Constant"
      },
      {
        filter = {filetype = 'lua'},
        pattern = ".*ex\\..*",
        hl = "constant"
      }
    }
  }
}
