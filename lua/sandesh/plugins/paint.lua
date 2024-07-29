return {
  'folke/paint.nvim',
  opts = {
    highlights = {
      {
        filter = {filetype = 'markdown'},
        pattern = ".*(QUESTION: .*?)",
        hl = "question"
      },
      {
        filter = {filetype = 'markdown'},
        pattern = ".*Q:.*",
        hl = "constant"
      }
    }
  }
}
-- Q: sdfsdf
