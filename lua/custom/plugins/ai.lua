return {
  {
    'milanglacier/minuet-ai.nvim',
    config = function()
      -- Configure minuet-ai.nvim
      require('minuet').setup {
        provider_options = {
          codestral = {
            model = 'codestral-latest',
            end_point = 'https://codestral.mistral.ai/v1/fim/completions',
            api_key = 'CODESTRAL_API_KEY',
            template = {
              prompt = function(ctx)
                return string.format('<|fim_prefix|>%s\n%s<|fim_suffix|>%s<|fim_middle|>', ctx.language_and_tab, ctx.before_cursor, ctx.after_cursor)
              end,
              suffix = nil,
            },
          },
        },
      }
    end,
  },
  { 'nvim-lua/plenary.nvim' },
  -- optional, if you are using virtual-text frontend, nvim-cmp is not
  -- required.
  { 'hrsh7th/nvim-cmp' },
}
