-- https://github.com/lambdalisue/fern.vim

local M = {}

function M.get(spec, config, opts)
  -- stylua: ignore
  return {
    FernBranchText = { fg = spec.pallet.blue.base },
  }
end

return M
