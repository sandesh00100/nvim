local source = {}
local cmp =  require('cmp')

function source.new()
  local self = setmetatable({cache = {buffNr = nil, fileReferences = nil, buffNr = nil}},{__index = source})
  return self
end

---Return whether this source is available in the current context or not (optional).
---@return boolean
function source:is_available()
  return true
end


---Return trigger characters for triggering completion (optional).
function source:get_trigger_characters()
  -- trigger characters are '[['  
  return {'['}
end

---Invoke completion (required).
---@param params cmp.SourceCompletionApiParams
---@param callback fun(response: lsp.CompletionResponse|nil)
function source:complete(params, callback)
  local curBuffNr = vim.api.nvim_get_current_buf()
  local cachedBuffNr = self.cache.buffNr
  local cachedFileReferences = self.cache.fileReferences
  local fileReferences = {}
  if not cachedFileReferences or curBuffNr ~= cachedBuffNr then
    local file = io.open("/tmp/fileCompletion.txt", "r")
    fileReferences = {}
    if file then
      for line in file:lines() do
        table.insert(fileReferences, { label = line, cmp.lsp.CompletionItemKind.Text})
      end
      file:close()
    end
    self.cache.fileReferences = fileReferences
    self.cache.buffNr = curBuffNr
  else
    fileReferences = cachedFileReferences
  end
  -- get current line from buffer
  local line = vim.api.nvim_get_current_line()
  -- check if line contains [[
  if string.match(line, '%[%[') then
    callback({items = fileReferences, isIncomplete = true})
    return
  else
    callback({items = {}, isIncomplete = true})
    return
  end
end

---Resolve completion item (optional). This is called right before the completion is about to be displayed.
---Useful for setting the text shown in the documentation window (completion_item.documentation).
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
cmp.register_source('fileNames', source.new())
