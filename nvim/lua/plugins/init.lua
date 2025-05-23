-- fold
vim.opt.foldenable = false
vim.opt.foldmethod = 'manual'

-- tabbing
vim.opt.expandtab = true -- Use spaces instead of tabs
vim.opt.shiftwidth = 2 -- Number of spaces for each indentation level
vim.opt.tabstop = 2 -- Number of spaces per tab
vim.opt.softtabstop = 2 -- Makes backspace delete like a tab

-- visuals
vim.opt.wrap = true
vim.opt.linebreak = true
vim.opt.swapfile = false
vim.opt.scrolloff = 12
vim.opt.cursorline = true
vim.opt.relativenumber = true
vim.opt.number = true
vim.opt.laststatus = 0
vim.opt.fillchars = 'eob: '

vim.keymap.set('n', '<leader>rl', function()
  local ok, err = pcall(dofile, vim.fn.expand '%')
  if not ok then
    vim.notify('Lua Error:\n' .. err, vim.log.levels.ERROR)
  else
    vim.notify('Lua file executed successfully', vim.log.levels.INFO)
  end
end, { desc = 'Run current Lua file with error reporting' })

vim.api.nvim_create_autocmd('VimResized', {
  desc = 'resize splits',
  callback = function()
    vim.cmd 'wincmd ='
  end,
})

vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
  pattern = {
    '*.json',
  },
  callback = function()
    vim.bo.filetype = 'jsonc'
  end,
})

-- Ctrl+S to save the file
vim.keymap.set('n', '<C-s>', ':w<CR>', { noremap = true, silent = true })
vim.keymap.set('i', '<C-s>', function()
  vim.cmd 'w'
end, { noremap = true, silent = true })

vim.keymap.set('v', '<leader>r', function()
  -- Get the selected text
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Esc>', true, false, true), 'x', false)

  local start_pos = vim.fn.getpos "'<"
  local end_pos = vim.fn.getpos "'>"
  local lines = vim.fn.getline(start_pos[2], end_pos[2])

  -- Extract the selected text
  local selected_text
  if #lines == 1 then
    -- Single-line selection
    selected_text = string.sub(lines[1], start_pos[3], end_pos[3])
  else
    -- Multi-line selection
    lines[1] = string.sub(lines[1], start_pos[3])
    lines[#lines] = string.sub(lines[#lines], 1, end_pos[3])
    selected_text = table.concat(lines, '\n')
  end

  -- Print or process the selected text
  print(selected_text)

  -- Prompt for replacement text
  local replacement = vim.fn.input('Replace"' .. selected_text .. '" with? ')
  if replacement ~= '' then
    -- Execute the substitution
    vim.cmd('%s/\\V' .. vim.fn.escape(selected_text, '\\') .. '/' .. vim.fn.escape(replacement, '\\') .. '/g')
  end
end, {
  desc = '[R]eplace visual selection',
})

return {}
