local ls = require 'luasnip'

-- Load VS Code style snippets from custom directory
require('luasnip.loaders.from_vscode').lazy_load {
  paths = { '~/.config/nvim/lua/custom/snippets' },
}

-- Optional: Set up keymaps for snippet navigation
vim.keymap.set({ 'i', 's' }, '<C-k>', function()
  if ls.expand_or_jumpable() then
    ls.expand_or_jump()
  end
end, { silent = true })

vim.keymap.set({ 'i', 's' }, '<C-j>', function()
  if ls.jumpable(-1) then
    ls.jump(-1)
  end
end, { silent = true })
