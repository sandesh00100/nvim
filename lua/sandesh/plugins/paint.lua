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
        pattern = ".*(TODO: .*)",
        hl = "todocustom"
      }
    }
  }
}
-- TODO: sdfsdfsdfiwoejosdf
