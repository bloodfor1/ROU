---@class MoonClient.MapObj : System.ValueType
---@field public type number
---@field public id uint64

---@type MoonClient.MapObj
MoonClient.MapObj = { }
---@return MoonClient.MapObj
---@param t number
---@param id uint64
function MoonClient.MapObj.New(t, id) end
---@overload fun(other:MoonClient.MapObj): boolean
---@return boolean
---@param obj System.Object
function MoonClient.MapObj:Equals(obj) end
---@return number
function MoonClient.MapObj:GetHashCode() end
return MoonClient.MapObj
