---@class MoonClient.GradualChange : UnityEngine.MonoBehaviour

---@type MoonClient.GradualChange
MoonClient.GradualChange = { }
---@return MoonClient.GradualChange
function MoonClient.GradualChange.New() end
---@return boolean
function MoonClient.GradualChange:IsPlaying() end
function MoonClient.GradualChange:Play() end
function MoonClient.GradualChange:Replay() end
function MoonClient.GradualChange:Stop() end
---@overload fun(startValue:number): void
---@overload fun(startValue:number, isReplay:boolean): void
---@param data MoonSerializable.GradualChangeData
---@param isReplay boolean
function MoonClient.GradualChange:SetData(data, isReplay) end
---@param valueChangeMethod (fun(obj:number):void)
---@param endMethod (fun():void)
function MoonClient.GradualChange:SetMethod(valueChangeMethod, endMethod) end
---@param valueChangeMethod (fun(obj:number):void)
function MoonClient.GradualChange:SetValueChangeMethod(valueChangeMethod) end
---@param endMethod (fun():void)
function MoonClient.GradualChange:SetEndMethod(endMethod) end
---@param data MoonSerializable.GradualChangeData
function MoonClient.GradualChange:SetDataExceptMethod(data) end
function MoonClient.GradualChange:Release() end
---@return System.Collections.Generic.List_MoonClient.BaseGradualChangeShow
function MoonClient.GradualChange:GetAllGradualChangeShows() end
---@param totalValue number
function MoonClient.GradualChange:SetTotalValue(totalValue) end
---@return MoonClient.GradualChangeTextShow
function MoonClient.GradualChange:GetGradualChangeTextShow() end
---@return MoonClient.GradualChangeTextShow
function MoonClient.GradualChange:CreateTextShow() end
---@return MoonClient.GradualChangeImageShow
function MoonClient.GradualChange:CreateImageShow() end
return MoonClient.GradualChange
