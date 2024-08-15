return {
  'folke/paint.nvim',
  opts = {
    highlights = {
      {
        filter = {filetype = 'markdown'},
        pattern = ".*(QUESTION: .*?)",
        hl = "questioncustom"
      },
      {
        filter = {filetype = 'markdown'},
        pattern = ".*(TODO: .*)",
        hl = "todocustom"
      },{
        filter = {filetype = 'python'},
        pattern = ".*(TODO: .*)",
        hl = "todocustom"
      },{
        filter = {filetype = 'python'},
        pattern = ".*(FIXME: .*)",
        hl = "fixmecustom"
      }
    }
  }
}
-- TODO: sdfsdfsdfiwoejosdf
