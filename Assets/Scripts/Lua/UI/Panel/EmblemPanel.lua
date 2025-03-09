--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
EmblemPanel = {}

--lua model end

--lua functions
---@class EmblemPanel.EmblemItemTemplate
---@field PanelRef MoonClient.MLuaUIPanel
---@field Name MoonClient.MLuaUICom
---@field ItemIcon MoonClient.MLuaUICom
---@field ItemCount MoonClient.MLuaUICom
---@field InfoTittle MoonClient.MLuaUICom
---@field ClickBtn MoonClient.MLuaUICom
---@field Checkmark MoonClient.MLuaUICom

---@class EmblemPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field TmpTxt MoonClient.MLuaUICom
---@field RewardScroll MoonClient.MLuaUICom
---@field rewardContent MoonClient.MLuaUICom
---@field LuckStarBtn MoonClient.MLuaUICom
---@field LuckBtnTxt MoonClient.MLuaUICom
---@field InfoTittle MoonClient.MLuaUICom
---@field InfoScroll MoonClient.MLuaUICom
---@field InfoMod MoonClient.MLuaUICom
---@field infoGoBtn MoonClient.MLuaUICom
---@field InfoContext MoonClient.MLuaUICom
---@field InfoCondition MoonClient.MLuaUICom
---@field HeraldryContent MoonClient.MLuaUICom
---@field BtnClose MoonClient.MLuaUICom
---@field BtnBg MoonClient.MLuaUICom
---@field BgImg MoonClient.MLuaUICom
---@field AttendLimitTip MoonClient.MLuaUICom
---@field EmblemItemTemplate EmblemPanel.EmblemItemTemplate

---@return EmblemPanel
---@param ctrl UIBase
function EmblemPanel.Bind(ctrl)
	
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
return UI.EmblemPanel