local util = require("nightfox.util")

local M = {}

-- Return the initial colors of the colorscheme. This is the default defined colors
-- without the color overrides from the configuration.
function M.init()
  -- stylua: ignore
  local colors = {
    meta       = { name = "terafox", light = false },

    none       = "NONE",
    -- bg         = "#0F1816",
    bg         = "#131D1B",
    bg_alt     = "#050C08",

    fg         = "#EEEBE4",
    fg_gutter  = "#ffffff",

    black      = "#555555",
    red        = "#a64f6a",
    green      = "#4FA68B",
    -- green      = "#52B193",
    -- yellow     = "#dbc074",
    yellow     = "#f6c177",
    -- blue       = "#4C74A9",
    blue       = "#5B7CAE",
    magenta    = "#B482AE",
    cyan       = "#7FD6C0",
    white      = "#555555",
    orange     = "#F39635",
    pink       = "#555555",

    black_br   = "#555555",
    red_br     = "#555555",
    green_br   = "#555555",
    yellow_br  = "#555555",
    blue_br    = "#555555",
    magenta_br = "#555555",
    cyan_br    = "#555555",
    white_br   = "#555555",
    orange_br  = "#555555",
    pink_br    = "#555555",

    -- -15 brightness -15 saturation
    black_dm   = "#555555",
    red_dm     = "#555555",
    green_dm   = "#555555",
    yellow_dm  = "#555555",
    blue_dm    = "#555555",
    magenta_dm = "#555555",
    cyan_dm    = "#555555",
    white_dm   = "#555555",
    orange_dm  = "#555555",
    pink_dm    = "#555555",

    comment    = "#555555",

    git = {
      add      = "#70a288",
      change   = "#a58155",
      delete   = "#904a6a",
      conflict = "#c07a6d",
    },

    gitSigns = {
      add    = "#164846",
      change = "#394b70",
      delete = "#823c41",
    },
  }

  util.bg = colors.bg

  colors.bg_alt = util.darken(colors.bg, 0.75, "#000000")
  colors.bg_highlight = util.brighten(colors.bg, 0.10)

  colors.fg_alt = util.darken(colors.fg, 0.85, "#000000")

  colors.diff = {
    add = util.darken(colors.green, 0.15),
    delete = util.darken(colors.red, 0.15),
    change = util.darken(colors.blue, 0.15),
    text = util.darken(colors.blue, 0.4),
  }

  colors.gitSigns = {
    add = util.brighten(colors.gitSigns.add, 0.2),
    change = util.brighten(colors.gitSigns.change, 0.2),
    delete = util.brighten(colors.gitSigns.delete, 0.2),
  }

  colors.git.ignore = colors.black
  colors.border_highlight = colors.blue
  colors.border = colors.black

  -- Popups and statusline always get a dark background
  colors.bg_popup = colors.bg_alt
  colors.bg_statusline = colors.bg_alt

  colors.bg_sidebar = colors.bg_alt
  colors.bg_float = colors.bg_alt

  colors.bg_visual = util.darken(colors.blue, 0.2)
  colors.bg_search = util.darken(colors.cyan, 0.3)
  colors.fg_sidebar = colors.fg_alt

  colors.error = colors.red
  colors.warning = colors.yellow
  colors.info = colors.blue
  colors.hint = colors.cyan

  colors.variable = colors.white

  return colors
end

-- Returns the completed colors with the overrides from the configuration
-- @param config table
function M.load(config)
  config = config or require("nightfox.config").options

  local colors = M.init()
  util.color_overrides(colors, config)

  return colors
end

return M
