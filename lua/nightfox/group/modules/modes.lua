-- https://github.com/mvllow/modes.nvim

local Color = require("nightfox.lib.color")

local M = {}

function M.get(spec, config, opts)
  local bg = Color.from_hex(spec.bg1)
  local copy = bg:blend(Color.from_hex(spec.pallet.green.base), 0.4):to_css()
  local delete = bg:blend(Color.from_hex(spec.pallet.red.base), 0.4):to_css()
  local insert = bg:blend(Color.from_hex(spec.pallet.cyan.base), 0.4):to_css()
  local visual = bg:blend(Color.from_hex(spec.pallet.magenta.base), 0.4):to_css()

  -- stylua: ignore
  return {
    ModesCopy   = { bg = copy },
    ModesDelete = { bg = delete },
    ModesInsert = { bg = insert },
    ModesVisual = { bg = visual },
  }
end

return M
