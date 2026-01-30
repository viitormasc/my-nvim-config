return {
  cmd = {
    "bash-language-server",
    "start",
  },

  filetypes = {
    "sh",
    "bash",
    "zsh",
  },

  root_markers = {
    ".git",
    ".bashrc",
    ".bash_profile",
    ".zshrc",
    ".shellcheckrc",
  },

  settings = {
    bashIde = {
      globPattern = "*@(.sh|.inc|.bash|.command)",
    },
  },

  single_file_support = true,
}
