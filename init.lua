-- vim.g.base46_cache = vim.fn.stdpath "data" .. "/base46/"
-- vim.g.mapleader = " "
--
-- -- bootstrap lazy and all plugins
-- local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
--
-- if not vim.uv.fs_stat(lazypath) then
--   local repo = "https://github.com/folke/lazy.nvim.git"
--   vim.fn.system { "git", "clone", "--filter=blob:none", repo, "--branch=stable", lazypath }
-- end
--
-- vim.opt.rtp:prepend(lazypath)
--
-- local lazy_config = require "configs.lazy"
--
-- -- load plugins
-- require("lazy").setup({
--   {
--     "NvChad/NvChad",
--     lazy = false,
--     branch = "v2.5",
--     import = "nvchad.plugins",
--   },
--
--   { import = "plugins" },
-- }, lazy_config)
--
-- -- load theme
-- dofile(vim.g.base46_cache .. "defaults")
-- dofile(vim.g.base46_cache .. "statusline")
--
-- require "options"
-- require "autocmds"
--
-- vim.schedule(function()
--   require "mappings"
-- end)
vim.g.base46_cache = vim.fn.stdpath 'data' .. '/base46/'
vim.g.mapleader = ' '

-- bootstrap lazy and all plugins
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'

if not vim.uv.fs_stat(lazypath) then
  local repo = 'https://github.com/folke/lazy.nvim.git'
  vim.fn.system { 'git', 'clone', '--filter=blob:none', repo, '--branch=stable', lazypath }
end

vim.opt.rtp:prepend(lazypath)

local lazy_config = require 'configs.lazy'

-- load plugins
require('lazy').setup({
  {
    'NvChad/NvChad',
    lazy = false,
    branch = 'v2.5',
    import = 'nvchad.plugins',
  },
  {
    { 'nvim-treesitter/nvim-treesitter', branch = 'master', lazy = false, build = ':TSUpdate' },
  },
  { import = 'plugins' },
}, lazy_config)

-- load theme
dofile(vim.g.base46_cache .. 'defaults')
dofile(vim.g.base46_cache .. 'statusline')

vim.o.relativenumber = true

require 'options'
require 'autocmds'

vim.schedule(function()
  require 'mappings'
end)

local function setup_lsp()
  local lsp_dir = vim.fn.stdpath 'config' .. '/lua/lsp'
  local lsp_servers = {}
  local capabilities = require('blink.cmp').get_lsp_capabilities()

  if vim.fn.isdirectory(lsp_dir) == 1 then
    for _, file in ipairs(vim.fn.readdir(lsp_dir)) do
      if file:match '%.lua$' and file ~= 'init.lua' then
        local server_name = file:gsub('%.lua$', '')
        table.insert(lsp_servers, server_name)
      end
    end
  end

  for _, server in ipairs(lsp_servers) do
    if vim.lsp.config[server] then
      vim.lsp.config[server] = vim.tbl_deep_extend("force",
        vim.lsp.config[server],
        { capabilities = capabilities }
      )
    end
  end


  vim.lsp.enable(lsp_servers)
end
 vim.api.nvim_command [[autocmd CursorHold   * lua require'utils'.blameVirtText()]]
 vim.api.nvim_command [[autocmd CursorMoved  * lua require'utils'.clearBlameVirtText()]]
 vim.api.nvim_command [[autocmd CursorMovedI * lua require'utils'.clearBlameVirtText()]]
setup_lsp()

