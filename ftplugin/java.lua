local data_path = vim.fn.stdpath('data') 
local jdtls_path = data_path .. "/mason/packages/jdtls"
local plugins_path = jdtls_path .. "/plugins"
local jdtls = require('jdtls')
local root_markers = { "mvnw", "gradlew", "pom.xml", "build.gradle" }
local root_dir = jdtls.setup.find_root(root_markers)
local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
local workspace_dir = data_path .. '/workspace/'.. project_name
local java_home = '/Library/Java/JavaVirtualMachines/temurin-17.jdk/Contents/Home'
local bundles = {
	vim.fn.glob(data_path .. '/mason/share/java-debug-adapter/com.microsoft.java.debug.plugin.jar')
}
vim.list_extend(bundles, vim.split(vim.fn.glob(data_path .. "/mason/share/java-test/*.jar", 1), "\n"))
local config = {
  -- The command that starts the language server
  -- See: https://github.com/eclipse/eclipse.jdt.ls#running-from-the-command-line
  cmd = {

    -- 💀:
    java_home .. '/bin/java', -- or '/path/to/java17_or_newer/bin/java'
            -- depends on if `java` is in your $PATH env variable and if it points to the right version.

    '-Declipse.application=org.eclipse.jdt.ls.core.id1',
    '-Dosgi.bundles.defaultStartLevel=4',
    '-Declipse.product=org.eclipse.jdt.ls.core.product',
    '-Dlog.protocol=true',
    '-Dlog.level=ALL',
    '-Xmx4g',
    '--add-modules=ALL-SYSTEM',
    '--add-opens', 'java.base/java.util=ALL-UNNAMED',
    '--add-opens', 'java.base/java.lang=ALL-UNNAMED',
    -- 💀
    '-javaagent:' .. jdtls_path .. '/lombok.jar',
	-- This will change based on what version of jdtls you've downloaded
    '-jar', plugins_path .. '/org.eclipse.equinox.launcher_1.6.900.v20240613-2009.jar',
         -- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^                                       ^^^^^^^^^^^^^^
         -- Must point to the                                                     Change this to
         -- eclipse.jdt.ls installation                                           the actual version


    -- 💀
    '-configuration', jdtls_path .. '/config_mac',
                    -- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^        ^^^^^^
                    -- Must point to the                      Change to one of `linux`, `win` or `mac`
                    -- eclipse.jdt.ls installation            Depending on your system.


    -- 💀
    -- See `data directory configuration` section in the README
    '-data', workspace_dir
  },
  -- 💀
  -- This is the default if not provided, yo:u can remove it. Or adjust as needed.
  -- One dedicated LSP server & client will be started per unique root_r
  root_dir = root_dir,

  -- Here you can configure eclipse.jdt.ls specific settings
  -- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
  -- for a list of options
  settings = {
    java = {
      home = java_home, 
      eclipse = {
        downloadSources = true,
      },
      configuration = {
	      runtimes = {
		      {
			      name = "JavaSE-17",
			      path = java_home	
		      }	
	      }
      },
      maven = {
        downloadSources = true,
      },
      implementationsCodeLens = {
        enabled = true,
      },
      referencesCodeLens = {
        enabled = true,
      },
      references = {
        includeDecompiledSources = true,
      }
    },
    signatureHelp = { enabled = true },
    completion = {
      favoriteStaticMembers = {
        "org.hamcrest.MatcherAssert.assertThat",
        "org.hamcrest.Matchers.*",
        "org.hamcrest.CoreMatchers.*",
        "org.junit.jupiter.api.Assertions.*",
        "java.util.Objects.requireNonNull",
        "java.util.Objects.requireNonNullElse",
        "org.mockito.Mockito.*",
      },
      importOrder = {
        "java",
        "javax",
        "com",
        "org"
      },
    },
    sources = {
      organizeImports = {
        starThreshold = 9999,
        staticStarThreshold = 9999,
      },
    },
    extendedClientCapabilities = jdtls.extendedClientCapabilities,
    capabilities = require('cmp_nvim_lsp').default_capabilities(),
    codeGeneration = {
      toString = {
        template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
      },
      useBlocks = true,
    },
  },

  flags = {
    allow_incremental_sync = true,
  },
  init_options = {
    bundles = bundles
  },
}

local dap = require("dap")
vim.keymap.set('n', '<leader>tc', jdtls.test_class, {});
vim.keymap.set('n', '<leader>tm', jdtls.test_nearest_method, {});
vim.keymap.set('n', '<leader>io', jdtls.organize_imports, {});
vim.keymap.set('n', '<leader>db', function ()
	local port = vim.fn.input("Port (Default=5005) >")
	if port == nil or port == '' then
		port = '5005'
	end
	dap.configurations.java = {
		{
			type = 'java';
			request = 'attach';
			name = 'Attach to process';
			hostname = 'localhost';
			port = port;
		}
	}
	dap.continue()
end)

vim.keymap.set('n', '<F5>', dap.continue, {});
vim.keymap.set('n', '<F7>', dap.step_into, {});
vim.keymap.set('n', '<F8>', dap.step_over, {});
vim.keymap.set('n', '<F9>', dap.step_out, {});

vim.keymap.set('n', '<leader>bp', dap.toggle_breakpoint, {});
vim.keymap.set('n', '<leader>rp', dap.repl.open, {});


-- TODO: Add cmp for dap and dap ui
-- TODO: Need to follow https://www.youtube.com/watch?v=kbRIosrvof0&t=489s for having method level debug 
-- TODO: Setting up debugger, might want to move some of this into it's own lua file
config['on_attach'] = function(client, bufnr)
  vim.keymap.set('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', {noremap=true, silent=true})
  jdtls.setup_dap({hotcodereplace='auto'})
  jdtls.dap.setup_dap_main_class_configs()
  require("javaKeyMaps").map_java_keys(bufnr);
  require("lsp_signature").on_attach({
    bind = true, -- This is mandatory, otherwise border config won't get registered.
    floating_window_above_cur_line = false,
    padding = '',
    handler_opts = {
      border = "rounded"
    }
  }, bufnr)
end

-- This starts a new client & server,
-- or attaches to an existing client & server depending on the `root_dir`.
 jdtls.start_or_attach(config)
