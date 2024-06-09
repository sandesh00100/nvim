return {
	"L3MON4D3/LuaSnip",
	-- follow latest release.
	version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
	-- install jsregexp (optional!).
	build = "make install_jsregexp",
  config = function ()
    local ls = require("luasnip")
    local s = ls.s 
    local fmt = require("luasnip.extras.fmt").fmt
    local i = ls.insert_node
    local rep = require("luasnip.extras").rep

    ls.add_snippets("all", {
      -- Code block snippets
      ls.parser.parse_snippet("bash","```bash\n$0\n```"),
      ls.parser.parse_snippet("java","```bash\n$0\n```"),
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
      -- Using some of lua snips methods
      s("rep", fmt([[
      local {} = {}
      ]], {i(1, "default"), rep(1)})
      )

    })
  end
}
