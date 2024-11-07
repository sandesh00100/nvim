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
      },{
        filter = {filetype = 'java'},
        pattern = ".*(TODO: .*)",
        hl = "todocustom"
      },{
        filter = {filetype = 'java'},
        pattern = ".*(FIXME: .*)",
        hl = "fixmecustom"
      },{
        filter = {filetype = 'java'},
        pattern = ".*(QUESTION: .*?)",
        hl = "questioncustom"
      }

    }
  }
}
-- TODO: sdfsdfsdfiwoejosdf
