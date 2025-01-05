return {
  'tpope/vim-fugitive',
  event = 'VeryLazy',
  cmd = { 'Git', 'G' }, -- load plugin only for these commands
  keys = {
    {
      '<leader>gs',
      '<CMD>Git<CR>',
      { desc = '[G]it [S]tatus' },
    },
  },
}
