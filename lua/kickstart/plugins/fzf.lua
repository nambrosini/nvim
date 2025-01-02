-- NOTE: Plugins can specify dependencies.
--
-- The dependencies are proper plugin specifications as well - anything
-- you do for a plugin at the top level, you can do for a dependency.
--
-- Use the `dependencies` key to specify the dependencies of a particular plugin

return {
  'ibhagwan/fzf-lua',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  opts = {},
  keys = {
    { '<leader><leader>', '<cmd>FzfLua buffers<cr>', desc = 'Find Buffer' },
    { '<leader>fb', '<cmd>FzfLua buffers<cr>', desc = '[F]ind [B]uffer' },
    { '<leader>ff', '<cmd>FzfLua files<cr>', desc = '[F]ind [F]iles' },
    { '<leader>fg', '<cmd>FzfLua git_files<cr>', desc = '[F]ind [G]it files' },
    { '<leader>gc', '<cmd>FzfLua git_commits<cr>', desc = '[G]it [C]ommits' },
    { '<leader>gs', '<cmd>FzfLua git_status<cr>', desc = '[G]it [S]tatus' },
    { '<leader>sb', '<cmd>FzfLua lgrep_curbuf<cr>', desc = '[S]earch Current [B]uffer' },
    { '<leader>sc', '<cmd>FzfLua command_history<cr>', desc = '[S]earch [c]ommand history' },
    { '<leader>sd', '<cmd>FzfLua diagnostics_document', desc = '[S]earch Documents [d]iagnostics' },
    { '<leader>sD', '<cmd>FzfLua diagnostics_workspace', desc = '[S]earch Workspace [D]iagnostics' },
    { '<leader>sg', '<cmd>FzfLua live_grep<cr>', desc = '[S]earch [G]rep (Root dir)' },
    { '<leader>sh', '<cmd>FzfLua help_tags<cr>', desc = '[S]earch [H]elp Pages' },
    { '<leader>sk', '<cmd>FzfLua keymaps<cr>', desc = '[S]earch [K]eymaps' },
    { '<leader>sq', '<cmd>FzfLua quickfix<cr>', desc = '[S]earch [Q]uickfix' },
    { '<leader>sR', '<cmd>FzfLua resume<cr>', desc = '[S]earch [R]esume' },
    { '<leader>ss', '<cmd>FzfLua lsp_document_symbols<cr>', desc = '[S]earch [s]ymbol' },
    { '<leader>sS', '<cmd>FzfLua lsp_workspace_symbols<cr>', desc = '[S]earch Workspace [S]ymbol' },
    { '<leader>sw', '<cmd>FzfLua grep_cword<cr>', desc = '[S]earch [w]ord' },
    { '<leader>sw', '<cmd>FzfLua grep_visual<cr>', desc = '[S]earch selection', mode = 'v' },
  },
}
-- vim: ts=2 sts=2 sw=2 et
