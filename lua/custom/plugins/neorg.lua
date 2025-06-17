return {
  'nvim-neorg/neorg',
  lazy = false, -- Disable lazy loading as some `lazy.nvim` distributions set `lazy = true` by default
  version = '*', -- Pin Neorg to the latest stable release
  config = function()
    require('neorg').setup {
      load = {
        ['core.defaults'] = {},
        ['core.concealer'] = {
          icon_preset = 'diamond',
        },
        ['core.dirman'] = {
          config = {
            workspaces = {
              notes = '~/notes',
            },
            default_workspace = 'notes',
          },
        },
        ['core.qol.toc'] = {
          close_after_user = true,
        },
        ['core.summary'] = {},
        ['core.ui.calendar'] = {},
      },
    }
  end,
  keys = {
    { '<leader>ni', '<CMD>Neorg index<CR>', desc = '[N]eorg [I]ndex' },
    { '<leader>nr', '<CMD>Neorg return<CR>', desc = '[N]eorg [R]eturn' },
    { '<leader>nt', '<CMD>Neorg toc<CR>', desc = '[N]eorg [T]oc' },
  },
}
