---@class MoonClient.MUICdButton : UnityEngine.UI.Button
---@field public cdAction (fun():void)
---@field public finishAction (fun():void)

---@type MoonClient.MUICdButton
MoonClient.MUICdButton = { }
---@return MoonClient.MUICdButton
function MoonClient.MUICdButton.New() end
function MoonClient.MUICdButton:TestCdButton() end
---@return number
function MoonClient.MUICdButton:GetLeftTime() end
---@param state boolean
function MoonClient.MUICdButton:SetCdState(state) end
---@param cdNum number
function MoonClient.MUICdButton:SetCd(cdNum) end
---@param cdText UnityEngine.UI.Text
function MoonClient.MUICdButton:SetCdText(cdText) end
---@param eventData UnityEngine.EventSystems.PointerEventData
function MoonClient.MUICdButton:OnPointerClick(eventData) end
function MoonClient.MUICdButton:ResetCdButton() end
return MoonClient.MUICdButton
