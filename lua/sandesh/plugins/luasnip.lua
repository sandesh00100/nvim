return {
	"L3MON4D3/LuaSnip",
	-- follow latest release.
	version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
	-- install jsregexp (optional!).
	build = "make install_jsregexp",
  config = function ()
    local ls = require("luasnip")
    ls.add_snippets("all", {
      -- Code block snippets
      ls.parser.parse_snippet("bash","```bash\n$0\n```"),
      ls.parser.parse_snippet("java","```bash\n$0\n```"),
      -- Mermaid snippets
      ls.parser.parse_snippet("mermaid","```mermaid\n$0\n```"),
      ls.parser.parse_snippet("flowchart","```mermaid\nflowchart $1;\n$0\n```"),
      ls.parser.parse_snippet("timeline",
      "```mermaid\n"
      ..
      "timeline\n"
      ..
      "\ttitle $1\n"
      ..
      "\t\tsection $2\n"
      ..
      "\t\t\t$3\n"
      ..
      "\t\t\t\t: $4\n"
      ..
      "```"),
    })
  end
}

