local util = require("nightfox.util")

local M = {}

-- Return the initial colors of the colorscheme. This is the default defined colors
-- without the color overrides from the configuration.
function M.init()
  -- stylua: ignore
  local colors = {
    meta       = { name = "frostfox", light = false },
    none       = "NONE",

    bg = "#282e44",
    bg_alt = "#1b1e2b",
    bg_gutter = "#292c3e",

    fg = "#fffadf",
    fg_gutter  = "#6e729a",

    -- https://coolors.co/ff8089-56e2c4-fff38d-75beff-c2acff-79e0ff-f1f1f1-ffa500-f5acff
    black      = "#393552",
    red        = "#ff8089",
    -- green      = "#54ffa7",
    -- green      = "#56b6c2",
    green      = "#56E2C4",
    yellow     = "#fff38d",
    blue       = "#75beff",
    magenta    = "#c2acff",
    cyan       = "#79e0ff",
    white      = "#f1f1f1",
    orange     = "#ffa500",
    pink       = "#f5acff",

    -- +15 brightness, +15 saturation
    black_br   = "#47407d",
    red_br     = "#FF939A",
    green_br   = "#6BEACE",
    yellow_br  = "#FFF5A0",
    blue_br    = "#8AC8FF",
    magenta_br = "#CCBAFF",
    cyan_br    = "#8EE5FF",
    white_br   = "#F6F3F3",
    orange_br  = "#FFB326",
    pink_br    = "#F7BAFF",

    -- -10 brightness, -10 saturation
    black_dm   = "#322e42",
    red_dm     = "#F8616B",
    green_dm   = "#42D6B6",
    yellow_dm  = "#F7E96F",
    blue_dm    = "#59ADF6",
    magenta_dm = "#A789F9",
    cyan_dm    = "#5ED2F6",
    white_dm   = "#DADADA",
    orange_dm  = "#DA920B",
    pink_dm    = "#EC89F9",

    comment    = "#7f848e",

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

    error    = "#f48771",
    warning  = "#cca700",
    info     = "#75beff",
    hint     = "#79e0ff",
  }

  util.bg = colors.bg

  colors.bg_highlight = util.brighten(colors.bg, 0.10)

  colors.fg_gutter = util.lighten(colors.fg_gutter, 0.9)
  P(colors.fg_gutter)

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

  colors.bg_visual = util.darken(colors.magenta, 0.2)
  colors.bg_search = util.darken(colors.green, 0.3)
  colors.fg_sidebar = colors.fg_alt

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
