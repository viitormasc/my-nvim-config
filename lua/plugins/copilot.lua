return {
  "zbirenbaum/copilot.lua",
  opts = {
    filetypes = {
      ["."] = false,
      css = true,
      cvs = false,
      gitcommit = false,
      gitrebase = false,
      help = false,
      hgcommit = false,
      markdown = false,
      scss = false,
      svn = false,
      yaml = true,
      go = false,
      [""] = false,
    },
    panel = {
      enabled = false,
    },
    suggestion = { 
      -- auto_trigger = true,
      keymap = {
        accept = "<c-]>",
        accept_word = "<a-]>",
        accept_line = "<a-[>",
        next = "<a-n>",
        prev = "<a-p>",
        dismiss = "<a-e>",
        toggle_auto_trigger = "<a-c>",
      },
    },
  },
  config = function(_, opts)
    local copilot = require("copilot")

    copilot.setup(opts)
  end,

  cmd = "Copilot",
  event = "InsertEnter",
}

