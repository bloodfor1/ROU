---@class MoonClient.MTogPanel : UnityEngine.MonoBehaviour
---@field public scrollRect UnityEngine.UI.ScrollRect
---@field public template UnityEngine.GameObject
---@field public parentTog MoonClient.UIToggleEx
---@field public panelArrowOn UnityEngine.GameObject
---@field public panelArrowOff UnityEngine.GameObject
---@field public childPanel UnityEngine.GameObject
---@field public childTog MoonClient.UIToggleEx
---@field public OnTogOn (fun(obj:number):void)

---@type MoonClient.MTogPanel
MoonClient.MTogPanel = { }
---@return MoonClient.MTogPanel
function MoonClient.MTogPanel.New() end
---@param indexes System.Int32[]
---@param names System.String[]
function MoonClient.MTogPanel:AddTogGroup(indexes, names) end
---@param index number
---@param isVisible boolean
function MoonClient.MTogPanel:SetIndexVisible(index, isVisible) end
---@return boolean
---@param index number
function MoonClient.MTogPanel:IsIndexVisible(index) end
function MoonClient.MTogPanel:DebugLog() end
---@param index number
function MoonClient.MTogPanel:SetTogOn(index) end
function MoonClient.MTogPanel:Clear() end
---@param index number
function MoonClient.MTogPanel:SetDefaultSelectIndexOnParentToggle(index) end
return MoonClient.MTogPanel
