local M = {}

if 1 ~= vim.fn.has "nvim-0.9.0" then
  vim.notify("rr.nvim requires at least nvim-0.9.0.", vim.log.levels.WARN)
  return
end

local function rr_on_system()
  return vim.fn.executable("rr")
end

local function reload_buffer(path)
  -- Procura o buffer que corresponde ao arquivo
  local buf = vim.fn.bufnr(path)
  if buf ~= -1 then
    -- Recarrega o buffer sem perder modificações externas
    vim.api.nvim_buf_call(buf, function()
      vim.cmd("e!")
    end)
    vim.notify("Arquivo recarregado: " .. path, vim.log.levels.INFO)
  end
end

local function get_selection()
  local s_pos = vim.fn.getpos("'<")
  local e_pos = vim.fn.getpos("'>")

  local start_line, start_col = s_pos[2], s_pos[3] - 1
  local end_line, end_col = e_pos[2], e_pos[3]

  local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)
  if #lines == 0 then return "" end

  lines[1] = string.sub(lines[1], start_col + 1)
  lines[#lines] = string.sub(lines[#lines], 1, end_col)

  return table.concat(lines, "\n")
end

local function on_enter(buf, win, callback)
  vim.api.nvim_buf_set_keymap(buf, 'i', '<CR>', '', {
    noremap=true,
    silent=true,
    callback = function()
      local content = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
      vim.api.nvim_win_close(win, true)
      callback(table.concat(content, "\n"))
    end
  })
end


local function call_rr_replace(old_word, new_word, context)
  local exe = "rr"

  if vim.fn.executable(exe) == 0 then
    vim.notify("rr.nvim: executable not found.", vim.log.levels.ERROR)
    return
  end

  local args = {old_word, new_word, context, "-r", "-v"}

  local output = vim.fn.system(vim.list_extend({exe}, args))

  for line in output:gmatch("[^\r\n]+") do
    vim.notify(line, vim.log.levels.INFO)
  end
  reload_buffer(context)
end

function M.popup()
  local old_word = get_selection()
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, {""})

  local width, height = 35, 1
  local win = vim.api.nvim_open_win(buf, true, {
    relative = "cursor",
    width = width,
    height = height,
    row = 5,
    col = 10,
    style = "minimal",
    focusable = true,
    border = "rounded",
    title = "rr.nvim: word to override " .. old_word,
    title_pos = "center"
  })

  vim.api.nvim_buf_set_keymap(buf, 'i', '<ESC>', [[<Esc>:lua vim.api.nvim_win_close(0, true)<CR>]], {noremap=true, silent=true})

  on_enter(buf, win, function(new_word)
    local context = vim.fn.input("context: ")
    if context == "this" or context == "" then
      context = vim.api.nvim_buf_get_name(0)
    end
    call_rr_replace(old_word, new_word, context)
  end)

vim.cmd("startinsert")
  vim.cmd("startinsert")
end



function M.setup()
  if rr_on_system() == 0 then
    vim.schedule(function()
      vim.notify("rrnvim: the rr executable is not on system!", vim.log.levels.ERROR)
    end)
  end
  vim.api.nvim_set_keymap('x', '<C-r>', [[:lua require("rrnvim").popup()<CR>]], { noremap = true, silent = true })
end

return M

