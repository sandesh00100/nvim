return {
  "L3MON4D3/LuaSnip",
  -- follow latest release.
  version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
  -- install jsregexp (optional!).
  build = "make install_jsregexp",
  config = function ()
    local ls = require("luasnip")
    local fmt = require("luasnip.extras.fmt").fmt
    -- Snippet methods
    local i = ls.insert_node
    local s = ls.s 
    local f = ls.function_node
    local sn = ls.sn -- snippet node
    local d = ls.dynamic_node
    local t = ls.t
    local c = ls.c
    vim.keymap.set({"i"}, "<C-K>", function() ls.expand() end, {silent = true})
    vim.keymap.set({"i", "s"}, "<C-L>", function() ls.jump( 1) end, {silent = true})
    vim.keymap.set({"i", "s"}, "<C-J>", function() ls.jump(-1) end, {silent = true})
    vim.keymap.set({"i", "s"}, "<C-E>", function()
      if ls.choice_active() then
        ls.change_choice(1)
      end
    end, {silent = true})
    local rep = require("luasnip.extras").rep
    local same = function (index)
      return f(function (arg)
        return arg[1]
      end, {index})
    end

    local split = function (inputstr, sep)
      local t = {}
      -- Matches all characters that's not the seperator
      for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
        table.insert(t, str)
      end
      return t
    end

    local parseArg = function (index)
      return f(function (arg)
        local parts = split(arg[1][1], ".");
        print(parts[#parts]);
        return parts[#parts] or "";
      end, {index})
    end

    local dynamicNode = function (index)
      return d(index, function ()
        local nodes = {}
        table.insert(nodes, t " ")
        -- Get all of the lines of the buffer
        local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
        for _, line in ipairs(lines) do 
          if line:match("local ") then
            print("LINE-------------")
            print(line)
            table.insert(nodes, t(line))
          end
        end
        return sn(nil, c(1, nodes))
      end, {})
    end

    -- Examples for future snippets
    ls.add_snippets("lua", {
      -- Using some of lua snips methods, replicate the first node with the second
      s("rep", fmt([[
      local {} = {}
      ]], {i(1, "default"), rep(1)})
      ),
      -- Function nodes
      s("same", fmt([[
      local {} = {}
      ]], {i(1, "default"), same(1)})
      ),
      s("parseArg", fmt([[
      local {} = {}
      ]], {parseArg(1), i(1)})
      ),
      -- Dynamic nodes
      s("dynamic", fmt([[
      local {} = {}
      ]], {dynamicNode(1), i(2)})
      ),
    });

    ls.add_snippets("markdown", {
      -- Code block snippets
      ls.parser.parse_snippet("bash","```bash\n$0\n```"),
      ls.parser.parse_snippet("java","```bash\n$0\n```"),
      ls.parser.parse_snippet("hr","----------------------------------------------------------------------------------------------------"),
      -- For creating snippets
      ls.parser.parse_snippet("fnode",
      [[
      local $1 = function (index)
        return f(function (arg)
          $0
          return arg[1]
        end, {index})
      end
      ]]
      ),
      -- Mermaid snippets
      ls.parser.parse_snippet("mermaid","```mermaids\n$0\n```"),
      ls.parser.parse_snippet("flowchart","```mermaid\nflowchart $1;\n$0\n```"),
      ls.parser.parse_snippet("timeline",
      [[
      ```mermaid
      timeline
      title $1
      section $2
      $3
      : $4
      ]]
      ),
      -- Obsidian specific
      ls.parser.parse_snippet("relates to",
      [==[
      Relates To::[[$0]]
      ]==]
      ),

    })
  end
}
