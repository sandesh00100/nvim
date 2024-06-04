return {
  'folke/paint.nvim',
  opts = {
    highlights = {
      {
        filter = {filetype = 'markdown'},
        pattern = "(QUESTION)",
        hl = "Constant"
      }
    }
  }
}
