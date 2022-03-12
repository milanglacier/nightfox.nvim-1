local M = {}

local function to_value(tbl)
  return tbl.base and tbl.base or tbl.to_css()
end

local function get_path(t, path)
  for segment in path:gmatch("[^.]+") do
    if type(t) == "table" then
      t = t[segment]
    end
  end
  return t
end

local function parse_string(str, spec)
  if str:match("^#") then
    return str
  end

  local path = get_path(spec, str)
  return path and path.base and path.base or path or str
end

function M.parse(template, spec)
  local result = {}

  for group, opts in pairs(template) do
    local new = {}
    for key, value in pairs(opts) do
      new[key] = type(value) == "table" and to_value(value) or parse_string(value, spec)
    end

    result[group] = new
  end

  return result
end

return M