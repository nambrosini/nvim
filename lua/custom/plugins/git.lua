return {
  'tpope/vim-fugitive',
  event = 'VeryLazy',
  cmd = { 'Git', 'G' }, -- load plugin only for these commands
  config = function()
    -- No extra config needed, commands are already available
  end,
}
