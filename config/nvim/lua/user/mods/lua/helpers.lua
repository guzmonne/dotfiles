local M = {}

---@return string # returns unique uuid
M.uuid = function()
  local random = math.random
  local template = "xxxxxxxx_xxxx_4xxx_yxxx_xxxxxxxxxxxx"
  local result = string.gsub(template, "[xy]", function(c)
    local v = (c == "x") and random(0, 0xf) or random(8, 0xb)
    return string.format("%x", v)
  end)
  return result
end

return M
