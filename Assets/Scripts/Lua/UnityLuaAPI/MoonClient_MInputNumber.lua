---@class MoonClient.MInputNumber : UnityEngine.MonoBehaviour
---@field public ClickButton UnityEngine.UI.Button
---@field public AddButton UnityEngine.UI.Button
---@field public SubtractButton UnityEngine.UI.Button
---@field public MaxButton UnityEngine.UI.Button
---@field public NumberText UnityEngine.UI.Text
---@field public NumberKeypadParent UnityEngine.Transform
---@field public ChangeInterval int64
---@field public MaxValue int64
---@field public MinValue int64
---@field public OnValueChange (fun(obj:int64):void)
---@field public isCanChange boolean
---@field public CantChangeMethod (fun():void)
---@field public OnMaxValueMethod (fun():void)
---@field public OnAddButtonClick (fun():void)
---@field public OnSubtractButtonClick (fun():void)

---@type MoonClient.MInputNumber
MoonClient.MInputNumber = { }
---@return MoonClient.MInputNumber
function MoonClient.MInputNumber.New() end
---@return int64
function MoonClient.MInputNumber:GetValue() end
---@param _value int64
function MoonClient.MInputNumber:SetValue(_value) end
---@param eventData UnityEngine.EventSystems.BaseEventData
function MoonClient.MInputNumber:OnUpdateSelected(eventData) end
function MoonClient.MInputNumber:CloseInputNumber() end
---@param visible boolean
function MoonClient.MInputNumber:SetMaxButtonDisplay(visible) end
return MoonClient.MInputNumber
