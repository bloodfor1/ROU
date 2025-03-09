--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
MainRoleInfoPanel = {}

--lua model end

--lua functions
---@class MainRoleInfoPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field TxtJobLv MoonClient.MLuaUICom
---@field TxtBaseLv MoonClient.MLuaUICom
---@field Txt_KillNum MoonClient.MLuaUICom
---@field Txt_DeathNum MoonClient.MLuaUICom
---@field Txt_AssistNum MoonClient.MLuaUICom
---@field TargetName MoonClient.MLuaUICom
---@field TargetLv MoonClient.MLuaUICom
---@field TargetIcon MoonClient.MLuaUICom
---@field Target MoonClient.MLuaUICom
---@field SliderMP MoonClient.MLuaUICom
---@field SliderHP MoonClient.MLuaUICom
---@field selfTipPos MoonClient.MLuaUICom
---@field reduceBuffInfo MoonClient.MLuaUICom
---@field reduceBuff MoonClient.MLuaUICom
---@field RedParent MoonClient.MLuaUICom
---@field ProfessionImg MoonClient.MLuaUICom
---@field otherTipPos MoonClient.MLuaUICom
---@field MainScrollView MoonClient.MLuaUICom
---@field Img_Leader MoonClient.MLuaUICom
---@field Image1 MoonClient.MLuaUICom
---@field Image MoonClient.MLuaUICom
---@field icon3 MoonClient.MLuaUICom
---@field icon2 MoonClient.MLuaUICom
---@field icon1 MoonClient.MLuaUICom
---@field icon MoonClient.MLuaUICom
---@field HeadIconImg MoonClient.MLuaUICom
---@field Effect22 MoonClient.MLuaUICom
---@field Effect MoonClient.MLuaUICom
---@field deleteButton2 MoonClient.MLuaUICom
---@field deleteButton1 MoonClient.MLuaUICom
---@field debuffList MoonClient.MLuaUICom
---@field buffTipsBtn MoonClient.MLuaUICom
---@field buffTip MoonClient.MLuaUICom
---@field buffListPanel MoonClient.MLuaUICom
---@field buffList MoonClient.MLuaUICom
---@field buffInfoGrid MoonClient.MLuaUICom
---@field BtnCloseTarget MoonClient.MLuaUICom
---@field Battle MoonClient.MLuaUICom
---@field addBuffInfo MoonClient.MLuaUICom
---@field addBuff MoonClient.MLuaUICom

---@return MainRoleInfoPanel
---@param ctrl UIBase
function MainRoleInfoPanel.Bind(ctrl)
	
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
return UI.MainRoleInfoPanel