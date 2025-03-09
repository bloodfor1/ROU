---@class MoonClient.BetterInputField : UnityEngine.UI.InputField
---@field public onSelect (fun(obj:UnityEngine.EventSystems.BaseEventData):void)
---@field public onDeselect (fun(obj:UnityEngine.EventSystems.BaseEventData):void)

---@type MoonClient.BetterInputField
MoonClient.BetterInputField = { }
---@return MoonClient.BetterInputField
function MoonClient.BetterInputField.New() end
---@param eventData UnityEngine.EventSystems.BaseEventData
function MoonClient.BetterInputField:OnSelect(eventData) end
---@param eventData UnityEngine.EventSystems.BaseEventData
function MoonClient.BetterInputField:OnDeselect(eventData) end
return MoonClient.BetterInputField
