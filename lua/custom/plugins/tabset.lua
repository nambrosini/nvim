return {
  'FotiadisM/tabset.nvim',
  config = function()
    local opts = {
      defaults = {
        tabwidth = 4,
        expandtab = true,
      },
      languages = {
        go = {
          tabwidth = 4,
          expandtab = false,
        },
        yaml = {
          tabwidth = 2,
          expandtab = false,
        },
        java = {
          tabwidth = 4,
          expandtab = false,
        }
      },
    }
    require('tabset').setup(opts)
  end,
}
