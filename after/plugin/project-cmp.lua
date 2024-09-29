local source = {}

---Return trigger characters for triggering completion (optional).
function source:get_trigger_characters()
  return { ': ' }
end

---Invoke completion (required).
---@param params cmp.SourceCompletionApiParams
---@param callback fun(response: lsp.CompletionResponse|nil)
function source:complete(params, callback)
  local projects = {}
  -- table.insert(projects, {label = option})
  -- open a file and read it line by line
  local file = io.open("/tmp/project-cmp-source.txt", "r")
  if file then
    for line in file:lines() do
      -- split string for a line on ': ' and remove the leading and trialing slash
      -- Match any number of characters or whitespace but it has to end with a word
      local project = string.match(line, ": ([%w%s]*%w)%s*$")
      if project then
        print("Project parsed: " .. project)
        table.insert(projects, {label = project})
      end
    end
    file:close()
  else
    print("Error: Unable to open file")
  end
  callback(projects)
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
require('cmp').register_source('project', source)
