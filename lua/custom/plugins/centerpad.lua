return {
  'smithbm2316/centerpad.nvim',
  keys = {
    {
      '<leader>cp',
      function()
        require('centerpad').toggle()
      end,
      desc = 'Toggle Centerpad',
    },
  },
}
