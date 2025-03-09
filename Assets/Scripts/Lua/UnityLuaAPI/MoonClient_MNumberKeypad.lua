---@class MoonClient.MNumberKeypad : UnityEngine.MonoBehaviour
---@field public NumberButton UnityEngine.UI.Button[]
---@field public DeleteButton UnityEngine.UI.Button
---@field public DetermineButton UnityEngine.UI.Button
---@field public CloseButton UnityEngine.UI.Button
---@field public OnValueChange (fun(obj:int64):void)
---@field public OnMaxValueMethod (fun():void)
---@field public OnClose (fun():void)
---@field public MaxValue int64
---@field public PreChangeTime number

---@type MoonClient.MNumberKeypad
MoonClient.MNumberKeypad = { }
---@return MoonClient.MNumberKeypad
function MoonClient.MNumberKeypad.New() end
---@param newValue int64
function MoonClient.MNumberKeypad:ChangeValue(newValue) end
function MoonClient.MNumberKeypad:CloseInputNumber() end
return MoonClient.MNumberKeypad
