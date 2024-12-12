local function calculateDate()
  local file_name = vim.fn.expand("%:t")
  local year, month, day = file_name:match("(%d+)-(%d+)-(%d+)")
  local day_to_symbol = {
     Monday = '月',
     Tuesday = '火',
     Wednesday='水',
     Thursday='木',
     Friday='金',
     Saturday='土',
     Sunday='日'
  }
  if year and month and day then 
      local timestamp = os.time{year=year, month=month, day=day}
      local day_of_week = os.date("%A", timestamp)
      return day_to_symbol[day_of_week] .. " " .. day_of_week
  end
  return ""
end

return {
  'nvim-lualine/lualine.nvim',
  dependencies = {'nvim-tree/nvim-web-devicons', opt = true},
  opts = {
  options = {
    icons_enabled = true,
    theme = 'auto',
    component_separators = { left = '', right = ''},
    section_separators = { left = '', right = ''},
    disabled_filetypes = {
      statusline = {},
      winbar = {},
    },
    ignore_focus = {},
    always_divide_middle = true,
    always_show_tabline = true,
    globalstatus = false,
    refresh = {
      statusline = 100,
      tabline = 100,
      winbar = 100,
    }
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {},
    lualine_c = {},
    lualine_x = {},
    lualine_y = { 'filetype','encoding', 'fileformat',},
    lualine_z = {}
  },
  tabline = {
    lualine_a = {{
      'filename',
      file_status = true,      -- Displays file status (readonly status, modified status)
      newfile_status = false,  -- Display new file status (new file means no write after created)
      path = 1,                -- 0: Just the filename

      shorting_target = 40,    -- Shortens path to leave 40 spaces in the window
                               -- for other components. (terrible name, any suggestions?)
      symbols = {
        modified = '[+]',      -- Text to show when the file is modified.
        readonly = '[-]',      -- Text to show when the file is non-modifiable or readonly.
        unnamed = '[No Name]', -- Text to show for unnamed buffers.
        newfile = '[New]',     -- Text to show for newly created file before first write
      }
    }},
    lualine_b = {calculateDate, 'branch', 'diff', 'diagnostics'},
    lualine_c = {},
    lualine_x = {},
    lualine_y = {'progress'},
    lualine_z = {'location'}
  },
  winbar = {},
  inactive_winbar = {},
  extensions = {}
  }
}

