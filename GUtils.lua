local GUtils
do
  local _class_0
  local _base_0 = { }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function() end,
    __base = _base_0,
    __name = "GUtils"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  local self = _class_0
  self.mapsort = function(self, board)
    local b_len = 0
    for k, v in pairs(board) do
      b_len = b_len + 1
    end
    local a1 = { }
    local a2 = { }
    local i = 0
    for k, v in pairs(board) do
      i = i + 1
      a1[i] = k
      a2[i] = v
    end
    for i = 1, b_len do
      local max = a2[i]
      for j = i + 1, b_len do
        if a2[j] > max then
          local tmp = a2[j]
          a2[j] = max
          a2[i] = tmp
          max = tmp
          local tmp1 = a1[j]
          a1[j] = a1[i]
          a1[i] = tmp1
        end
      end
    end
    local ret = { }
    for k, v in ipairs(a1) do
      ret[k] = {
        a1[k],
        a2[k]
      }
    end
    return ret
  end
  GUtils = _class_0
  return _class_0
end
