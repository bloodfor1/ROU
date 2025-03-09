--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
RedEnvelopePanel = {}

--lua model end

--lua functions
---@class RedEnvelopePanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field TotalRedEnvelopeNum MoonClient.MLuaUICom
---@field TotalMoneyNum MoonClient.MLuaUICom
---@field SendTitle MoonClient.MLuaUICom
---@field SendPart MoonClient.MLuaUICom
---@field SelfGetRecord MoonClient.MLuaUICom
---@field RecordView MoonClient.MLuaUICom
---@field PwdTip MoonClient.MLuaUICom
---@field PwdInputPart MoonClient.MLuaUICom
---@field PwdInput_Send MoonClient.MLuaUICom
---@field PwdInput_Get MoonClient.MLuaUICom
---@field Placeholder_PwdInputSend MoonClient.MLuaUICom
---@field Placeholder_PwdInputGet MoonClient.MLuaUICom
---@field Placeholder_MsgInput MoonClient.MLuaUICom
---@field MsgText MoonClient.MLuaUICom
---@field MsgInputPart MoonClient.MLuaUICom
---@field MsgInput MoonClient.MLuaUICom
---@field MoneyIcon MoonClient.MLuaUICom
---@field LockPart MoonClient.MLuaUICom
---@field GuildMemberNum MoonClient.MLuaUICom
---@field GetTitle MoonClient.MLuaUICom
---@field GetPart MoonClient.MLuaUICom
---@field FxRTImg MoonClient.MLuaUICom
---@field CostText MoonClient.MLuaUICom
---@field CostPart MoonClient.MLuaUICom
---@field CostIcon MoonClient.MLuaUICom
---@field ControllPart MoonClient.MLuaUICom
---@field BtnVoice_Pwd_Send MoonClient.MLuaUICom
---@field BtnVoice_Pwd_Get MoonClient.MLuaUICom
---@field BtnVoice_Msg_Send MoonClient.MLuaUICom
---@field BtnSend MoonClient.MLuaUICom
---@field BtnReduce MoonClient.MLuaUICom
---@field BtnRandom MoonClient.MLuaUICom
---@field BtnOpenSelectMoney MoonClient.MLuaUICom
---@field BtnOpenPwd MoonClient.MLuaUICom
---@field BtnExpression MoonClient.MLuaUICom
---@field BtnClose MoonClient.MLuaUICom
---@field BtnAdd MoonClient.MLuaUICom
---@field RedEnvelopeRecordItemPrefab MoonClient.MLuaUIGroup
---@field PaymentInstructions MoonClient.MLuaUIGroup

---@return RedEnvelopePanel
---@param ctrl UIBase
function RedEnvelopePanel.Bind(ctrl)
	
	--dont override this function
	---@type MoonClient.MLuaUIPanel
	local panelRef = ctrl.uObj:GetComponent("MLuaUIPanel")
	ctrl:OnBindPanel(panelRef)
	return BindMLuaPanel(panelRef)
	
end --func end
--next--
--lua functions end

--lua custom scripts

--lua custom scripts end
return UI.RedEnvelopePanel