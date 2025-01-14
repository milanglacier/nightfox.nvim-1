local config = require("nightfox.config").options
local util = require("nightfox.util")

local fmt = string.format

local header = [[
-- This file is autogenerated by NIGHTFOX.
-- Do not make changes directly to this file.
]]

local clear_block = [[
if vim.g.colors_name then
  vim.cmd("hi clear")
end
]]

local function gen_set_info_block(meta)
  local lines = {}

  local background = meta.light and "light" or "dark"
  table.insert(lines, [[vim.cmd("set termguicolors")]])
  table.insert(lines, fmt([[vim.cmd("set background=%s")]], background))
  table.insert(lines, fmt([[vim.g.colors_name = "%s"]], meta.name))
  table.insert(lines, "")

  return table.concat(lines, "\n")
end

local function gen_terminal_func(spec)
  local c = spec.pallet

  local lines = {}

  -- stylua: ignore
  local colors = {
    fmt([["%s"]], c.black.base),   fmt([["%s"]], c.red.base),
    fmt([["%s"]], c.green.base),   fmt([["%s"]], c.yellow.base),
    fmt([["%s"]], c.blue.base),    fmt([["%s"]], c.magenta.base),
    fmt([["%s"]], c.cyan.base),    fmt([["%s"]], c.white.base),
    fmt([["%s"]], c.black.bright), fmt([["%s"]], c.red.bright),
    fmt([["%s"]], c.green.bright), fmt([["%s"]], c.yellow.bright),
    fmt([["%s"]], c.blue.bright),  fmt([["%s"]], c.magenta.bright),
    fmt([["%s"]], c.cyan.bright),  fmt([["%s"]], c.white.bright),
  }

  table.insert(lines, "local function set_terminal()")
  table.insert(lines, "   -- stylua: ignore")
  table.insert(lines, "  local colors = {")
  table.insert(lines, fmt("    %s,", table.concat(colors, ", ")))
  table.insert(lines, "  }")

  -- stylua: ignore
  table.insert(lines, [[
  for i, c in ipairs(colors) do
    local n = "terminal_color_" .. i - 1
    vim.g[n] = c
  end
  if vim.fn.has("nvim") == 0 then
    vim.g.terminal_ansi_colors = vim.list(colors)
  end
end

set_terminal()
]])

  return table.concat(lines, "\n")
end

local M = {}

function M.compile()
  local output_path = config.compile_path
  local file_suffix = config.compile_file_suffix

  util.ensure_dir(output_path)

  local specs = require("nightfox.spec").load()

  for specname, spec in pairs(specs) do
    local lines = {}
    local hlgroups = {}
    local hllinks = {}

    local groups = require("nightfox.group").load(spec)
    for name, opts in pairs(groups) do
      if opts.link and opts.link ~= "" then
        table.insert(hllinks, string.format("highlight! link %s %s", name, opts.link))
      else
        table.insert(
          hlgroups,
          fmt(
            "highlight %s guifg=%s guibg=%s gui=%s guisp=%s",
            name,
            opts.fg or "NONE",
            opts.bg or "NONE",
            opts.style or "NONE",
            opts.sp or "NONE"
          )
        )
      end
    end

    table.sort(hlgroups)
    table.sort(hllinks)

    table.insert(lines, header)
    table.insert(lines, clear_block)

    table.insert(lines, [[-- Highlight group definitions]])
    table.insert(lines, "vim.cmd([[")
    table.insert(lines, table.concat(hlgroups, " |\n"))
    table.insert(lines, "]])\n")

    table.insert(lines, [[-- Highlight link definitions]])
    table.insert(lines, "vim.cmd([[")
    table.insert(lines, table.concat(hllinks, " |\n"))
    table.insert(lines, "]])\n")

    table.insert(lines, gen_set_info_block(spec.pallet.meta))

    if config.terminal_colors then
      table.insert(lines, gen_terminal_func(spec))
    end

    local output_file = util.join_paths(output_path, specname .. file_suffix .. ".lua")
    local file = io.open(output_file, "w")
    file:write(table.concat(lines, "\n"))
    file:close()
  end
end

function M.clean()
  local foxes = require("nightfox.pallet").foxes

  local output_path = config.compile_path
  local file_suffix = config.compile_file_suffix

  for _, name in ipairs(foxes) do
    local output_file = util.join_paths(output_path, name .. file_suffix .. ".lua")
    os.remove(output_file)
  end
end

function M.status()
  local foxes = require("nightfox.pallet").foxes

  local output_path = config.compile_path
  local file_suffix = config.compile_file_suffix

  for _, name in ipairs(foxes) do
    local file = util.join_paths(output_path, name .. file_suffix .. ".lua")
    local status = util.exists(file) and "✓" or "x"
    print(fmt("[%s]: %-10s %s", status, name, file))
  end
end

return M
