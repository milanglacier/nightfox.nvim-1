local M = {}

local function parse_string(str, spec)
  local function get_path(t, path)
    for segment in string.gmatch(path, "[^.]+") do
      if type(t) == "table" then
        t = t[segment]
      end
    end
    return t
  end
  return (
      str:gsub("($%b{})", function(w)
        local path = w:sub(3, -2)
        local r = get_path(spec, path)
        return r and r.base and r.base:to_css() or r["to_css"] and r:to_css() or w
      end)
    )
end

function M.parse(template, spec)
  local result = {}

  for group, opts in pairs(template) do
    local new = {}
    for key, value in pairs(opts) do
      new[key] = type(value) == "table" and value:to_css() or parse_string(value, spec)
    end

    result[group] = new
  end

  return result
end

return M
