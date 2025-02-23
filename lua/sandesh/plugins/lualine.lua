local markdownIntervalTree = {}

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
    return table.concat(output, " | ")
  end
end

local function getRoot(buffnr, language)
  local parser = vim.treesitter.get_parser(buffnr, language, {})
  local tree = parser:parse()[1]
  return tree:root()
end

local function getNodeText(node, buffnr)
  -- Get the range of the name node (start and end positions)
  local name_start_row, name_start_column, name_end_row, name_end_column = node:range()
  -- Get the text 
  return vim.api.nvim_buf_get_text(buffnr, name_start_row, name_start_column, name_end_row, name_end_column, {})[1]
end

local function getMethod()
    local ts_utils = require 'nvim-treesitter.ts_utils'
    local node = ts_utils.get_node_at_cursor()
    local buffNr = vim.api.nvim_get_current_buf()
    local line_number = vim.api.nvim_win_get_cursor(0)[1]
    local file_type = vim.bo[buffNr].filetype
    -- if it's a programming language and we just need the method we're in
    if file_type == 'lua' or file_type == 'java' or file_type == 'python' or file_type == 'typescript' then
      while node do
        if node:type() == 'method_declaration' or node:type() == 'function_declaration' or node:type() == 'function_definition' or node:type() == 'method_definition' then
          local start_row, start_col, end_row, end_col = node:range()

          if line_number >= start_row + 1 and line_number <= end_row + 1 then
            local name_node = node:field("name")[1]
            local start_row_name, start_col_name, end_row_name, end_col_name = name_node:range()
            -- return function name
            return vim.api.nvim_buf_get_text(buffNr, start_row_name, start_col_name, end_row_name, end_col_name, {})[1] .. "()"
          else 
            return ''
          end
        end
        node = node:parent()
      end
    elseif file_type == 'markdown' then
      for key, value in pairs(markdownIntervalTree) do
        local start_line = key[1]
        local end_line = key[2]
        if start_line <= line_number and end_line >= line_number then
          return value["name"]
        end
      end
    end
    return ''
end

local function getSectionText(node, buffnr)
  local atx_heading = node:child(0)
  local name_node = atx_heading:field("heading_content")[1]
  return getNodeText(name_node, buffnr)
end

local function getSection(node, buffnr)
  if node == nil or node:type() ~= 'section' then
    return nil
  end

  local sectionNode = {}
  sectionNode["name"] = getSectionText(node, buffnr)

  for childNode in node:iter_children() do
    local childSection  = getSection(childNode, buffnr)
    if childSection ~= nil then
      -- Make sure section has children
      local children = sectionNode["children"]

      if children == nil then
        children = {}
        sectionNode["children"] = children
      end

      local function_start_row, _, function_end_row, _ = childNode:range()
      children[{function_start_row+1, function_end_row+1}] = childSection
    end
  end
  return sectionNode
end

local function buildMarkdownMap(buffnr)
    -- TODO: Fix this if we upgrade to 10.0
    local query = vim.treesitter.query.parse_query("markdown", [[
      (section) @sec
    ]])

    local root = getRoot(buffnr, 'markdown')

    for id, node in query:iter_captures(root, buffnr, 0, -1) do
      if query.captures[id] == 'sec' and node:parent() == root then
        local function_start_row, _, function_end_row, _ = node:range()
        markdownIntervalTree[{function_start_row+1, function_end_row+1}] = getSection(node, buffnr)
      end
    end
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

vim.api.nvim_create_autocmd({ "BufEnter" , "BufWritePost"}, {
    group = vim.api.nvim_create_augroup("lualine-enter-update", {clear = true}),
    pattern = "*",
    callback = function()
      -- case statement lua
      local buffnr = vim.api.nvim_get_current_buf()
      local fileType = vim.bo[buffnr].filetype
      if fileType == 'markdown' then
        buildMarkdownMap(buffnr)
      end
    end
})

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
    },'mode'},
    lualine_b = {},
    lualine_c = {},
    lualine_x = {},
    lualine_y = { 'filetype','encoding', 'fileformat',},
    lualine_z = {}
  },
  tabline = {
    lualine_a = {'filename', getMethod},
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
