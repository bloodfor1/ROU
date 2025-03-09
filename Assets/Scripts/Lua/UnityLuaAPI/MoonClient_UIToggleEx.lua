---@class MoonClient.UIToggleEx : UnityEngine.MonoBehaviour
---@field public buttonOn UnityEngine.UI.Button
---@field public buttonOff UnityEngine.UI.Button
---@field public imgOn UnityEngine.UI.Image
---@field public imgOff UnityEngine.UI.Image
---@field public imgSetterOn MoonClient.MImageSetter
---@field public imgSetterOff MoonClient.MImageSetter
---@field public canOnlyOn boolean
---@field public onValueChanged MoonClient.UIToggleEx.ToggleEvent
---@field public action (fun():void)
---@field public group MoonClient.UIToggleExGroup
---@field public isOn boolean
---@field public IsSetAsLast boolean

---@type MoonClient.UIToggleEx
MoonClient.UIToggleEx = { }
---@param gray boolean
function MoonClient.UIToggleEx:SetGray(gray) end
---@param checkMethod (fun():void)
function MoonClient.UIToggleEx:SetCheckMethodOnBtnOn(checkMethod) end
---@param checkMethod (fun():void)
function MoonClient.UIToggleEx:SetCheckMethodOnBtnOff(checkMethod) end
return MoonClient.UIToggleEx
