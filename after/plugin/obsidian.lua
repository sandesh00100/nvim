local createQfListForFiles = function(command)
  vim.fn.jobstart(command, {
    stdout_buffered = true,
    stderr_buffered = true,
    on_stdout = function (_, data, _)
      local qfList = {}
      for _, line in ipairs(data) do
        local result = {}

        -- Split by comma
        for match in line:gmatch("[^,]+") do
            table.insert(result, match)
        end

        local fileName = result[1]
        local text = result[2]
        local lineNum = result[3]

        -- If everything is present then add it to the qf list
        if fileName and text and lineNum then
          local newitem = {filename = 'Daily Notes/' .. fileName, text = text, lnum=lineNum}
          table.insert(qfList, newitem)
        end
      end

    -- Primary sort on file name and secondary on line number
    table.sort(qfList, function(a, b)
        if a.filename ~= b.filename then
          return a.filename < b.filename
        end

        return tonumber(a.lnum ) < tonumber(b.lnum)
    end)

    if #qfList > 0 then
      vim.fn.setqflist(qfList)
      vim.cmd("cc 1")
      vim.cmd("copen")
    end

  end,
    on_stderr = function (_, data, _)
      for _, line in ipairs(data) do
        if line ~= "" then
          print("STD ERR" .. line)
        end
      end
    end
  })
end
-- There is a faster way to do this but it'd be stupid to add that complexity
local setCursorToNearestLink = function ()
  -- coded
  -- Get the current line number
  local currentLine = vim.api.nvim_win_get_cursor(0)[1]
  local cursorcol = vim.api.nvim_win_get_cursor(0)[2] + 1
  local lineContent = vim.api.nvim_buf_get_lines(0, currentLine - 1, currentLine, false)[1]

  local tbl = {string.byte(lineContent, 1, #lineContent)}
  local minIndex = 1
  -- Some large number
  local minDistance = 999999
  -- Loop through the table
  for i = 1, #tbl-1 do
    local startChar = string.char(tbl[i])
    local nextChar = string.char(tbl[i+1])
    -- check if we're on a start link or end link
    local startMatches = startChar == "[" and nextChar == "["
    local endMatches = startChar == "]" and nextChar == "]"
    -- Calculate current distance
    local currentDistance = math.abs(cursorcol-i)
    -- If current distance is lower set that 
    if (startMatches or endMatches) and (currentDistance < minDistance) then
      minDistance = currentDistance
      minIndex = i
    end
  end
  vim.api.nvim_win_set_cursor(0, {currentLine, minIndex - 1})
  return minIndex
end


vim.keymap.set('n', 'gf', function ()
  if setCursorToNearestLink() then
      vim.cmd.ObsidianFollowLink()
  end
end)

vim.keymap.set('n','<leader>ob', function ()
  setCursorToNearestLink()
  vim.cmd.ObsidianOpen()
end, {desc="Open file in Obsidian"})

vim.keymap.set('n','<leader>bl', vim.cmd.ObsidianBacklinks, {desc="Show backlinks in Obsidian"})
vim.keymap.set('n','<leader>ol', vim.cmd.ObsidianLinks, {desc="Show links in Obsidian"})
vim.keymap.set('n','<leader>ot', vim.cmd.ObsidianTags, {desc="Show tags in Obsidian"})
vim.keymap.set('n','<leader>or', vim.cmd.ObsidianRename, {desc="Rename obsidian file"})
vim.keymap.set('n','<leader>ti', vim.cmd.ObsidianTemplate, {desc="Insert template in Obsidian"})

vim.keymap.set('n', '<leader>dt', function ()
  local currentDate = os.date("%Y-%m-%d")
  local noteToday = "Daily Notes/" .. currentDate .. ".md"
  local file = io.open(noteToday, "r")
  if file then
    io.close(file)
    -- Open todays note
    vim.api.nvim_command("edit " .. noteToday)
    local handle = io.popen("ls 'Daily Notes' *.md | sort")
    local result = handle:read("*a")
    handle:close()

    -- Calculate time/dates before +/- 7 days from current
    local currentTime = os.time()  
    local timeMinus7Days = currentTime - (7 * 24 * 60 * 60)  -- Subtract 7 days (7 * 24 hours * 60 minutes * 60 seconds)
    local timePlus7Days = currentTime + (7 * 24 * 60 * 60)  -- Subtract 7 days (7 * 24 hours * 60 minutes * 60 seconds)
    local dateMinus7Days = os.date("%Y-%m-%d", timeMinus7Days)
    local datePlus7Days = os.date("%Y-%m-%d", timePlus7Days)

    local qfList = {}
    local index = 1
    local indexToday = nil

    -- Loop through all of the lines
    for currentFile in result:gmatch("[^\n]+") do
      local fullFile = "Daily Notes/" .. currentFile
      if fullFile == noteToday then
        -- set the index of todays day
        indexToday = index
      end
      if currentFile >= dateMinus7Days and currentFile <= datePlus7Days then
        local date = currentFile:match("(.+)%.")
        local year, month, day = date:match("(%d+)-(%d+)-(%d+)")
        local timestamp = os.time{year=year, month=month, day=day}
        local day_of_week = os.date("%A", timestamp)
        -- Add items in the date range in the quickfix list
        local newitem = {filename =  fullFile, text = day_of_week, lnum=15}
        table.insert(qfList, newitem);
        index = index + 1
      end
    end
    vim.fn.setqflist(qfList)
    vim.cmd("cc " .. indexToday)
  else
    vim.cmd.ObsidianOpen()
  end
end)


vim.keymap.set('n', '<leader>mf', function ()
  local fileName = vim.fn.input({prompt='Add Markdown File: '}) 
  vim.api.nvim_command("edit ".. fileName .. ".md")
end, {desc = "Create a new markdown file"})

-- Checkbox
vim.keymap.set("n", "<leader>ch", vim.cmd.ObsidianToggleCheckbox)

vim.keymap.set('n', '<leader>it', function ()
  createQfListForFiles("~/git/scripts/collectMarkdownChecklist.py -p 'Daily Notes' -n 2 -c 'General Thoughts'")
end)

vim.keymap.set('n', '<leader>if', function ()
  createQfListForFiles("~/git/scripts/collectMarkdownChecklist.py -p 'Daily Notes' -n 2 -c 'Things TODO' -t 'Templates/Templater/Daily Note.md'")
end)

