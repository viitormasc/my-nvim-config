return {
  {
    'saghen/blink.cmp',
    dependencies = 'rafamadriz/friendly-snippets',

    version = 'v0.*',

    opts = {
      -- list = { selection = { preselect = true } },
      keymap = {
        preset = 'super-tab', ---@type 'enter' | 'default' | 'super-tab' | 'none'
        ['<CR>'] = { 'accept', 'fallback' },
        ['<Tab>'] = {
          function(cmp)
            if cmp.snippet_active() then
              return cmp.accept()
            else
              return cmp.select_next()
            end
          end,
          'snippet_forward',
          'fallback',
        },
        ['<S-Tab>'] = { 'select_prev', 'snippet_backward', 'fallback' },
      },
      appearance = {
        -- set this to true if you want to use the blink.cmp autocomplete
        use_nvim_cmp_as_default = false,
        nerd_font_variant = 'mono',
      },

      signature = { enabled = true },
    },
  },
}

