-- Here is a more advanced example where we pass configuration
-- options to `gitsigns.nvim`. This is equivalent to the following Lua:
--    require('gitsigns').setup({ ... })
--
-- See `:help gitsigns` to understand what the configuration keys do
return {
  { -- Adds git related signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    opts = {
      signs = {
        add = { text = '▎' },
        change = { text = '▎' },
        delete = { text = '' },
        topdelete = { text = '' },
        changedelete = { text = '▎' },
        untracked = { text = '▎' },
      },
      signs_staged = {
        add = { text = '▎' },
        change = { text = '▎' },
        delete = { text = '' },
        topdelete = { text = '' },
        changedelete = { text = '▎' },
      },
      on_attach = function(buffer)
        local gs = package.loaded.gitsigns

        local function map(mode, l, r, desc)
          vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
        end

        map('n', ']h', function()
          if vim.wo.diff then
            vim.cmd.normal { ']c', bang = true }
          else
            gs.nav_hunk 'next'
          end
        end, 'Next Hunk')
        map('n', '[h', function()
          if vim.wo.diff then
            vim.cmd.normal { '[c', bang = true }
          else
            gs.nav_hunk 'prev'
          end
        end, 'Prev Hunk')
        map('n', ']H', function()
          gs.nav_hunk 'last'
        end, 'Last Hunk')
        map('n', '[H', function()
          gs.nav_hunk 'first'
        end, 'First Hunk')
        map({ 'n', 'v' }, '<leader>ghs', ':Gitsigns stage_hunk<CR>', '[G]it [S]tage [H]unk')
        map({ 'n', 'v' }, '<leader>ghr', ':Gitsigns reset_hunk<CR>', '[G]it [R]eset [H]unk')
        map('n', '<leader>ghS', gs.stage_buffer, '[G]it [S]tage [B]uffer')
        map('n', '<leader>ghu', gs.undo_stage_hunk, '[G]it Stage [H]unk [U]ndo')
        map('n', '<leader>ghR', gs.reset_buffer, '[G]it [R]eset [B]uffer')
        map('n', '<leader>ghp', gs.preview_hunk_inline, '[G]it [H]unk [P]review Inline')
        map('n', '<leader>ghb', function()
          gs.blame_line { full = true }
        end, '[G]it [B]lame [L]ine')
        map('n', '<leader>ghB', function()
          gs.blame()
        end, '[G]it [B]lame [B]uffer')
        map('n', '<leader>ghd', gs.diffthis, '[G]it [H]unk [D]iff')
        map('n', '<leader>ghD', function()
          gs.diffthis '~'
        end, '[G]it [H]unk [D]iff This ~')
        map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>', 'GitSigns Select Hunk')
      end,
    },
  },
}
-- vim: ts=2 sts=2 sw=2 et
