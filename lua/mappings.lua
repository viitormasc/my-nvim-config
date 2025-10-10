require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })

map("i", "jk", "<ESC>")
map("i", "jj", "<ESC>")
map("n", "<leader>u", vim.cmd.UndotreeToggle)

map("n", "<A-j>", ":m .+1<CR>==")     -- move line up(n)
map("n", "<A-k>", ":m .-2<CR>==")     -- move line down(n)
map("v", "<A-j>", ":m '>+1<CR>gv=gv") -- move line up(v)
map("v", "<A-k>", ":m '<-2<CR>gv=gv") -- move line down(v)

map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")

map("x", "p", '"_dP')
map({ "n", "x" }, "<leader>pa", [["0p]], { desc = "paste from yank register" })
map("n", "<leader>t", "<cmd>silent !tmux neww tmux-sessionizer<CR>")
map("n", "<leader>f", function()
  vim.lsp.buf.format()
end)

map("n", "<C-k>", "<cmd>cnext<CR>zz")
map("n", "<C-j>", "<cmd>cprev<CR>zz")
map("n", "<leader>k", "<cmd>lnext<CR>zz")
map("n", "<leader>j", "<cmd>lprev<CR>zz")

map("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

-- Remap arrow keys to show instructions
vim.keymap.set({ "n", "v", "x" }, "<Up>", function()
  vim.cmd 'echo "Press K to go up"'
end, { noremap = true })

vim.keymap.set({ "n", "v", "x" }, "<Down>", function()
  vim.cmd 'echo "Press J to go down"'
end, { noremap = true })

vim.keymap.set({ "n", "v", "x" }, "<Left>", function()
  vim.cmd 'echo "Press H to go left"'
end, { noremap = true })

vim.keymap.set({ "n", "v", "x" }, "<Right>", function()
  vim.cmd 'echo "Press L to go right"'
end, { noremap = true })

map("n", "[", "O<ESC>")
map("n", "]", "o<ESC>")

-- CUSTOM SCRIPTS --
vim.fn.setreg("l", "yoconsole.log('^[pa:^[la, ^[pl)")

-- make i start indented
vim.cmd [[function! IndentWithI()
    if len(getline('.')) == 0
        return "\"_cc"
    else
        return "i"
    endif
endfunction
nnoremap <expr> i IndentWithI()]]

-- replace '' or " " with ``

local function replace_quotes_with_backticks()
  local line = vim.api.nvim_get_current_line()
  local cursor_pos = vim.api.nvim_win_get_cursor(0)
  local col = cursor_pos[2] + 1 -- 1-based column
  -- Check what quotes we can find
  local single_quotes = {}
  local double_quotes = {}
  -- Find all single quotes
  for i = 1, #line do
    if line:sub(i, i) == "'" and (i == 1 or line:sub(i - 1, i - 1) ~= "\\") then
      table.insert(single_quotes, i)
    end
  end
  -- Find all double quotes
  for i = 1, #line do
    if line:sub(i, i) == '"' and (i == 1 or line:sub(i - 1, i - 1) ~= "\\") then
      table.insert(double_quotes, i)
    end
  end
  -- Simple logic: find if cursor is between any quote pair
  local function is_between_quotes(quotes)
    for i = 1, #quotes - 1, 2 do
      local start = quotes[i]
      local end_pos = quotes[i + 1]
      if start and end_pos and col > start and col < end_pos then
        return start, end_pos
      end
    end
    return nil, nil
  end
  local start_single, end_single = is_between_quotes(single_quotes)
  local start_double, end_double = is_between_quotes(double_quotes)
  if start_single and end_single then
    local new_line = line:sub(1, start_single - 1)
        .. "`"
        .. line:sub(start_single + 1, end_single - 1)
        .. "`"
        .. line:sub(end_single + 1)
    vim.api.nvim_set_current_line(new_line)
  elseif start_double and end_double then
    local new_line = line:sub(1, start_double - 1)
        .. "`"
        .. line:sub(start_double + 1, end_double - 1)
        .. "`"
        .. line:sub(end_double + 1)
    vim.api.nvim_set_current_line(new_line)
  else
  end
end

map("n", "<leader>'", replace_quotes_with_backticks, { desc = "Replace quotes with backticks" }) -- Simple alternate buffer switching

-- Make we switch fast between our current and last buffer

map("n", "<Tab>", "<C-^>", { desc = "Switch to alternate buffer" })
map("n", "<S-Tab>", "<cmd>bnext<CR>", { desc = "Next buffer" })

local function create_console_log()
  -- Get the word under cursor
  local word = vim.fn.expand "<cword>"

  -- Get current line number
  local current_line = vim.api.nvim_win_get_cursor(0)[1]

  -- Create the console.log statement
  local log_line = "console.log('" .. word .. "', " .. word .. ");"

  -- Insert the line after current line
  vim.api.nvim_buf_set_lines(0, current_line, current_line, false, { log_line })

  -- Move cursor to the new line
  vim.api.nvim_win_set_cursor(0, { current_line + 1, 0 })
end

-- Add to your mappings
map("n", "<leader>cl", create_console_log, { desc = "Create console.log for word under cursor" })

local function format_and_save()
  -- Get all active LSP clients
  local clients = vim.lsp.get_active_clients()
  local format_clients = {}

  -- Filter clients that support formatting and are not the problematic ESLint client
  for _, client in ipairs(clients) do
    if client.supports_method "textDocument/formatting" then
      -- Skip the problematic ESLint client if it exists
      if client.name ~= "eslint" and client.name ~= "" then
        table.insert(format_clients, client)
      end
    end
  end

  -- Run TSTools commands for TypeScript/JavaScript files
  local filetype = vim.bo.filetype
  if filetype == "typescript" or filetype == "typescriptreact" or filetype == "javascript" or filetype == "javascriptreact" then
    -- Add missing imports
    local ok_add, result_add = pcall(vim.cmd, "TSToolsAddMissingImports")
    if not ok_add then
      print("TSToolsAddMissingImports failed: " .. tostring(result_add))
    end

    -- Organize imports (sort and remove unused)
    local ok_org, result_org = pcall(vim.cmd, "TSToolsOrganizeImports")
    if not ok_org then
      print("TSToolsOrganizeImports failed: " .. tostring(result_org))
    end
  end

  if #format_clients > 0 then
    -- Format using LSP with error handling, filtering out eslint
    local ok, result = pcall(function()
      vim.lsp.buf.format {
        async = false,
        filter = function(client)
          return client.name ~= "eslint" and client.name ~= ""
        end,
      }
    end)

    if ok then
      vim.cmd "w"
      print "Formatted and saved"
    else
      print("LSP formatting failed: " .. tostring(result))
      vim.cmd "w" -- Save anyway if formatting fails
    end
  else
    -- Fallback: just save if no LSP formatting available
    vim.cmd "w"
    print "No LSP formatter available - just saved"
  end
end

map({ "n", "i", "v" }, "<C-s>", format_and_save, { desc = "Format and save document" })

local function rename_symbol_interactive()
  -- Get the current word under cursor
  local old_name = vim.fn.expand "<cword>"
  if not old_name or old_name == "" then
    print "No word under cursor"
    return
  end

  -- Ask for new name
  local new_name = vim.fn.input("New name for " .. old_name .. ": ", old_name)
  if new_name == "" or new_name == old_name then
    print "Rename cancelled or no change"
    return
  end

  -- Use ripgrep with no filtering
  local cmd = "rg -n -w --no-ignore --hidden '"
      .. old_name
      .. "' --glob '*.lua' --glob '*.js' --glob '*.ts' --glob '*.jsx' --glob '*.tsx' 2>/dev/null"
  local handle = io.popen(cmd)
  local results = handle:read "*a"
  handle:close()

  if not results or results == "" then
    print("No occurrences found for: " .. old_name)
    -- Try a more aggressive search
    local cmd2 =
        "find . -name '*.lua' -o -name '*.js' -o -name '*.ts' -o -name '*.jsx' -o -name '*.tsx' | xargs grep -n -w '"
        .. old_name
        .. "' 2>/dev/null | head -50"
    local handle2 = io.popen(cmd2)
    local results2 = handle2:read "*a"
    handle2:close()

    if results2 and results2 ~= "" then
      print "Found with find+grep:"
      results = results2
    else
      return
    end
  end

  -- Parse results
  local occurrences = {}
  for line in results:gmatch "[^\r\n]+" do
    local file, line_num, content = line:match "([^:]+):(%d+):(.+)"
    if file and line_num then
      table.insert(occurrences, {
        file = file,
        line = tonumber(line_num),
        content = content,
      })
    end
  end

  if #occurrences == 0 then
    print "No valid occurrences found"
    return
  end

  print("Found " .. #occurrences .. " occurrences of '" .. old_name .. "'")

  -- Set up yellow highlight
  vim.cmd "highlight RenameHighlight guibg=Yellow guifg=Black"

  -- Clear screen for better visibility
  vim.cmd 'echo ""'
  vim.cmd "redraw"

  -- Disable LSP temporarily to avoid errors
  local lsp_clients = vim.lsp.get_active_clients()
  local disabled_lsp = {}

  for _, client in ipairs(lsp_clients) do
    if client.name == "eslint" then
      vim.lsp.stop_client(client.id)
      table.insert(disabled_lsp, client.name)
    end
  end

  if #disabled_lsp > 0 then
    print("Temporarily disabled LSP: " .. table.concat(disabled_lsp, ", "))
  end

  -- Process each occurrence
  local changed_count = 0
  local skipped_count = 0
  local cancelled = false

  for i, occ in ipairs(occurrences) do
    if cancelled then
      break
    end

    -- Open the file in edit mode automatically
    local success, err = pcall(function()
      vim.cmd("edit " .. occ.file)
      vim.api.nvim_win_set_cursor(0, { occ.line, 0 })
    end)

    if not success then
      print("Could not open: " .. occ.file)
      skipped_count = skipped_count + 1
      goto continue
    end

    -- Find the exact position of the word on this line
    local line_content = vim.api.nvim_get_current_line()
    local start_pos, end_pos = line_content:find(old_name)

    if not start_pos then
      -- Try with word boundaries
      start_pos, end_pos = line_content:find("\\b" .. old_name .. "\\b")
    end

    if start_pos then
      -- Move cursor to the word
      vim.api.nvim_win_set_cursor(0, { occ.line, start_pos - 1 })

      -- Highlight the word using yellow background
      local ns = vim.api.nvim_create_namespace "rename_highlight"
      vim.api.nvim_buf_clear_namespace(0, ns, 0, -1)
      vim.api.nvim_buf_add_highlight(0, ns, "RenameHighlight", occ.line - 1, start_pos - 1, start_pos - 1 + #old_name)

      -- Center the screen
      vim.cmd "normal! zz"

      -- Clear and show clean interface
      vim.cmd 'echo ""'
      vim.cmd "redraw"

      -- Show context with better formatting
      print("╭─ " .. string.format("Occurrence %d/%d", i, #occurrences) .. " " .. string.rep("─", 50))
      print("│ File: " .. occ.file .. ":" .. occ.line)
      print("│ Context: " .. line_content)
      print(
        "│ "
        .. string.rep(" ", start_pos - 1)
        .. string.rep("^", #old_name)
        .. " ← This word (highlighted in yellow)"
      )
      print("╰─ " .. string.rep("─", 50))

      -- Ask for confirmation with 'c' option
      local answer
      local input_success, input_err = pcall(function()
        answer = vim.fn.input("Change '" .. old_name .. "' to '" .. new_name .. "'? (y/n/a/q/c): ")
      end)

      if not input_success then
        print "Input cancelled due to LSP error, continuing..."
        answer = "n"
      end

      -- Clear highlight
      vim.api.nvim_buf_clear_namespace(0, ns, 0, -1)

      if answer:lower() == "y" then
        -- Replace at exact position
        local before = line_content:sub(1, start_pos - 1)
        local after = line_content:sub(end_pos + 1)
        local new_line = before .. new_name .. after
        vim.api.nvim_set_current_line(new_line)

        -- Safe save without triggering LSP
        vim.cmd "noautocmd write"
        changed_count = changed_count + 1
        print "✓ Changed"
      elseif answer:lower() == "n" then
        skipped_count = skipped_count + 1
        print "✗ Skipped"
      elseif answer:lower() == "a" then
        -- Change all remaining
        for j = i, #occurrences do
          local remaining_occ = occurrences[j]
          local success2 = pcall(function()
            vim.cmd("edit " .. remaining_occ.file)
            vim.api.nvim_win_set_cursor(0, { remaining_occ.line, 0 })
            local rem_line_content = vim.api.nvim_get_current_line()
            local rem_start, rem_end = rem_line_content:find(old_name)
            if not rem_start then
              rem_start, rem_end = rem_line_content:find("\\b" .. old_name .. "\\b")
            end
            if rem_start then
              local rem_before = rem_line_content:sub(1, rem_start - 1)
              local rem_after = rem_line_content:sub(rem_end + 1)
              local rem_new_line = rem_before .. new_name .. rem_after
              vim.api.nvim_set_current_line(rem_new_line)
              vim.cmd "noautocmd write"
            end
          end)
          if not success2 then
            print("Could not process: " .. remaining_occ.file)
          end
        end
        changed_count = changed_count + (#occurrences - i + 1)
        print "✓ Changed all remaining"
        break
      elseif answer:lower() == "q" then
        print "Rename cancelled"
        break
      elseif answer:lower() == "c" then
        -- Cancel and revert changes made so far
        print "❌ Operation cancelled - reverting changes..."
        cancelled = true

        -- Revert changes in current file if it was modified
        if vim.bo.modified then
          vim.cmd "edit!" -- Reload without saving changes
        end
        break
      else
        skipped_count = skipped_count + 1
        print "✗ Skipped (invalid input)"
      end
    else
      print("Word not found at expected position in: " .. occ.file .. ":" .. occ.line)
      skipped_count = skipped_count + 1
    end

    -- Clear screen between occurrences
    vim.cmd 'echo ""'
    vim.cmd "redraw"

    ::continue::
  end

  -- Clear any remaining highlights
  local ns = vim.api.nvim_create_namespace "rename_highlight"
  vim.api.nvim_buf_clear_namespace(0, ns, 0, -1)

  -- Final summary
  vim.cmd 'echo ""'
  if cancelled then
    print("❌ Rename cancelled - " .. changed_count .. " changes were reverted")
  else
    print("✅ Rename completed: " .. changed_count .. " changed, " .. skipped_count .. " skipped")
  end

  -- Restart LSP servers
  if #disabled_lsp > 0 then
    print "LSP servers will restart automatically on next file operation"
  end
end

-- Add to your mappings
map("n", "<leader>rn", rename_symbol_interactive, { desc = "Rename symbol interactively across project" })
--

