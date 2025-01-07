local jdtls = require 'jdtls'
local jdtls_dap = require 'jdtls.dap'
local jdtls_setup = require 'jdtls.setup'
local home = os.getenv 'HOME'

local root_markers = { '.git', 'mvnw', 'gradlew', 'pom.xml', 'build.gradle' }
local root_dir = jdtls_setup.find_root(root_markers)

local project_name = vim.fn.fnamemodify(root_dir, ':p:h:t')
local workspace_dir = home .. '/.cache/jdtls/workspace' .. project_name
local lsp = require 'vim.lsp'

function mk_config()
  local capabilities = lsp.protocol.make_client_capabilities()
  capabilities.workspace.configuration = true
  capabilities.textDocument.completion.completionItem.snippetSupport = true
  return {
    flags = {
      allow_incremental_sync = true,
    },
    handlers = {},
    capabilities = capabilities,
    init_options = {},
    settings = {},
  }
end

local config = mk_config()
config.settings = {
  java = {
    references = {
      includeDecompiledSources = true,
    },
    format = {
      enabled = true,
      settings = {
        url = home .. '/.config/nvim/lua/lspconfig/intellij-java-google-style.xml',
        profile = 'GoogleStyle',
      },
    },
    eclipse = {
      downloadSources = true,
    },
    maven = {
      downloadSources = true,
    },
    signatureHelp = { enabled = true },
    contentProvider = { preferred = 'fernflower' },
    completion = {
      favoriteStaticMembers = {
        'org.hamcrest.MatcherAssert.assertThat',
        'org.hamcrest.Matchers.*',
        'org.hamcrest.CoreMatchers.*',
        'org.junit.jupiter.api.Assertions.*',
        'java.util.Objects.requireNonNull',
        'java.util.Objects.requireNonNullElse',
        'org.mockito.Mockito.*',
      },
      filteredTypes = {
        'com.sun.*',
        'io.micrometer.shaded.*',
        'java.awt.*',
        'jdk.*',
        'sun.*',
      },
      importOrder = {
        'java',
        'javax',
        'com',
        'org',
      },
    },
    sources = {
      organizeImports = {
        starThreshold = 9999,
        staticStarThreshold = 9999,
      },
    },
    codeGeneration = {
      toString = {
        template = '${object.className}{${member.name()}=${member.value}, ${otherMembers}}',
      },
      useBlocks = true,
    },
    configuration = {
      runtimes = {
        {
          name = 'JavaSE-21',
          path = '/Library/Java/JavaVirtualMachines/openjdk-21.jdk/Contents/Home',
        },
      },
    },
    home = '/Library/Java/JavaVirtualMachines/openjdk.jdk/Contents/Home',
  },
}

config.cmd = {
  'java',
  '-Declipse.application=org.eclipse.jdt.ls.core.id1',
  '-Dosgi.bundles.defaultStartLevel=4',
  '-Declipse.product=org.eclipse.jdt.ls.core.product',
  '-Dlog.protocol=true',
  '-Dlog.level=ALL',
  '-Xmx1g',
  '-javaagent:' .. home .. '/.local/share/nvim/mason/packages/jdtls/lombok.jar',
  '-Xbootclasspath/a:' .. home .. '/.local/share/nvim/mason/packages/jdtls/lombok.jar',
  '--add-modules=ALL-SYSTEM',
  '--add-opens',
  'java.base/java.util=ALL-UNNAMED',
  '--add-opens',
  'java.base/java.lang=ALL-UNNAMED',

  '-jar',
  vim.fn.glob(home .. '/.local/share/nvim/mason/packages/jdtls/plugins/org.eclipse.equinox.launcher_*.jar'),
  '-configuration',
  home .. '/.local/share/nvim/mason/packages/jdtls/config_mac_arm',
  '-data',
  workspace_dir,
}

config.on_attach = function(_, bufnr)
  ---@diagnostic disable-next-line: missing-fields
  jdtls.setup_dap { hotcodereplace = 'auto' }
  jdtls_dap.setup_dap_main_class_configs()

  vim.keymap.set('n', '<leader>tc', ':lua require("jdtls").test_class()<CR>', { desc = '[T]est: [C]lass' })
  vim.keymap.set('n', '<leader>tC', ':lua require("jdtls").test_class()<CR>', { desc = 'Debug [T]est: [C]lass' })
  vim.keymap.set('n', '<leader>tm', ':lua require("jdtls").test_nearest_method()<CR>', { desc = '[T]est: [M]ethod' })
  vim.keymap.set('n', '<leader>tM', ':lua require("jdtls").test_nearest_method()<CR>', { desc = 'Debug [T]est: [M]ethod' })
  vim.keymap.set('n', '<leader>tl', ':DapToggleRepl<CR>', { desc = '[T]oggle test result [L]ist' })

  require('lsp_signature').on_attach({
    bind = true,
    padding = '',
    handler_opts = {
      border = 'rounded',
    },
    hint_prefix = '󱄑 ',
  }, bufnr)
end

config.on_init = function(client, _)
  if client.config.settings then
    client.notify('workspace/didChangeConfiguration', { settings = client.config.settings })
  end
end

local extendedClientCapabilities = require('jdtls').extendedClientCapabilities
extendedClientCapabilities.resolveAdditionalTextEditsSupport = true

config.init_options = {
  bundles = {},
  extendedClientCapabilities = extendedClientCapabilities,
}

config.filetypes = {
  'java',
}

-- Start Server
require('jdtls').start_or_attach(config)
