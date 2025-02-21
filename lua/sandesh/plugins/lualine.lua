local listFunctions = {}
local function getHarpoon()
 local marks = require('harpoon').get_mark_config().marks
 local total_marks = {}
 for _, file in ipairs(marks) do
   local name = vim.fn.fnamemodify(file.filename, ":t")
   table.insert(total_marks, name)
 end
 if total_marks == 0 then
    return ""
  end

  local nvim_mode = vim.api.nvim_get_mode().mode:sub(1, 1)
  local hp_keymap = {"h", "j", "k", "l"}
  local hl_normal = nvim_mode == "n" and "%#lualine_b_normal#"
    or nvim_mode == "i" and "%#lualine_b_insert#"
    or nvim_mode == "c" and "%#lualine_b_command#"
    or "%#lualine_b_visual#"
  local hl_selected = string.find("vV", nvim_mode)
      and "%#lualine_transitional_lualine_a_visual_to_lualine_b_visual#"
    or "%#lualine_b_diagnostics_warn_normal#"

  local full_name = vim.api.nvim_buf_get_name(0)
  local buffer_name = vim.fn.expand("%:t")
  local output = {}
  for index = 1, #total_marks do
    local mark = total_marks[index]
    if mark == buffer_name or mark == full_name then
      table.insert(output, hl_selected ..  '('..hp_keymap[index]..')選ばれた' .. hl_normal)
    else
      table.insert(output, "(" .. hp_keymap[index] .. ")" .. mark)
    end
  end

  return table.concat(output, " | ")
end

local function getFunction()
  if vim.bo.filetype == 'lua' then
    local currentBuff = vim.api.nvim_get_current_buf()
    local ts_utils = require 'nvim-treesitter.ts_utils'
    local currentNode = ts_utils.get_node_at_cursor()
    while currentNode do
      if currentNode:type() == "function_declaration" or currentNode:type() == "method_declaration" then
        local name_node = currentNode:child(2) -- This depends on the language
        local nodeValue = vim.treesitter.get_node_text(name_node, currentBuff)
        listFunctions[nodeValue] = true
        local length = 0
        for _ in pairs(listFunctions) do
          length = length + 1
          print("Lenght " .. length)
        end
        return nodeValue
      end
      currentNode = currentNode:parent()
    end
  end
  return ''
end

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
    }, getFunction},
    lualine_b = {calculateDate, getHarpoon},
    lualine_c = {'branch', 'diff', 'diagnostics'},
    lualine_x = {},
    lualine_y = {'progress'},
    lualine_z = {{'datetime', color = {bg='#d47772'}, colored = true}}
  },
  winbar = {},
  inactive_winbar = {},
  extensions = {}
  }
}

