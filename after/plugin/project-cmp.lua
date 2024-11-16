local source = {}

function source:new()
  local self = setmetatable({cache = {buffNr = nil, projects = nil, tags = nil}},{__index = source})
  return self
end

---Return trigger characters for triggering completion (optional).
function source:get_trigger_characters()
  return { ': ' }
end

---Invoke completion (required).
---@param params cmp.SourceCompletionApiParams
---@param callback fun(response: lsp.CompletionResponse|nil)
function source:complete(params, callback)
  local curBuffNr = vim.api.nvim_get_current_buf()
  local cachedBuffNr = self.cache.buffNr
  local currentLine = vim.api.nvim_get_current_line()

  if string.find(currentLine, "project: ") then
    local cachedProjects = self.cache.projects
    -- Only reload the completion if there is nothing cached or if we move to a new buffer
    if not cachedProjects or cachedBuffNr ~= curBuffNr then
      local projects = {}
      -- open a file and read it line by line
      local file = io.open("/tmp/project-cmp-source.txt", "r")
      if file then
        for line in file:lines() do
          if line and line ~= "" then
            table.insert(projects, {label = line})
          end
        end
        file:close()

        -- Cache the projects
        self.cache.projects = projects
        self.cache.buffNr = curBuffNr
        callback(projects)
      else
        vim.notify("Error: Unable to open file", "error")
      end
    else
      callback(cachedProjects)
    end
  elseif string.find(currentLine, "tags: ") then
    local cachedTags = self.cache.tags
    if not cachedTags or cachedBuffNr ~= curBuffNr then
      local tags = {}
      -- open a file and read it line by line
      local file = io.open("/tmp/tags-cmp-source.txt", "r")
      if file then
        for line in file:lines() do
          -- match everything after a ": "
          if line and line ~= "" then
            table.insert(tags, {label = line})
          end
        end
        file:close()
        -- cache the tags
        self.cache.tags = tags
        self.cache.buffNr = curBuffNr
        callback(tags)
      else
        vim.notify("Error: Unable to open file", "error")
      end
    else
      callback(cachedTags)
    end
  elseif string.find(currentLine, "status: ") then
    callback({{label = "backlog"}, {label = "doing"}, {label = "done"}})
  elseif string.find(currentLine, "priority: ") then
    callback({{label = "High"}, {label = "Medium"}, {label = "Low"}})
  else
    callback({})
  end

end
---Resolve completion item (optional). This is called right before the completion is about to be displayed.
---Useful for setting the text shown in the documentation window (`completion_item.documentation`).
---@param completion_item lsp.CompletionItem
---@param callback fun(completion_item: lsp.CompletionItem|nil)
function source:resolve(completion_item, callback)
  callback(completion_item)
end

---Executed after the item was selected.
---@param completion_item lsp.CompletionItem
---@param callback fun(completion_item: lsp.CompletionItem|nil)
function source:execute(completion_item, callback)
  callback(completion_item)
end
---Register your source to nvim-cmp.
require('cmp').register_source('project', source.new())
