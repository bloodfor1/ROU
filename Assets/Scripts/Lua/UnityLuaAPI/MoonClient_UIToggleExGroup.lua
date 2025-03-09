---@class MoonClient.UIToggleExGroup : UnityEngine.MonoBehaviour
---@field public autoSorting boolean
---@field public startPos UnityEngine.Vector2
---@field public spacing UnityEngine.Vector2
---@field public allowSwitchOff boolean

---@type MoonClient.UIToggleExGroup
MoonClient.UIToggleExGroup = { }
---@param toggle MoonClient.UIToggleEx
function MoonClient.UIToggleExGroup:NotifyToggleOn(toggle) end
---@param toggle MoonClient.UIToggleEx
function MoonClient.UIToggleExGroup:UnregisterToggle(toggle) end
---@param toggle MoonClient.UIToggleEx
function MoonClient.UIToggleExGroup:RegisterToggle(toggle) end
---@return boolean
function MoonClient.UIToggleExGroup:AnyTogglesOn() end
function MoonClient.UIToggleExGroup:RefreshTogglePosition() end
function MoonClient.UIToggleExGroup:TestUIToggleExGroup() end
return MoonClient.UIToggleExGroup
