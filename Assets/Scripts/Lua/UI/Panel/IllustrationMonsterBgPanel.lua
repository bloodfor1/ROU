--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
IllustrationMonsterBgPanel = {}

--lua model end

--lua functions
---@class IllustrationMonsterBgPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field TypeContent MoonClient.MLuaUICom
---@field Toggle_Normal_List_1 MoonClient.MLuaUICom
---@field Text_Num MoonClient.MLuaUICom
---@field TemParent MoonClient.MLuaUICom
---@field Slider MoonClient.MLuaUICom
---@field Shop MoonClient.MLuaUICom
---@field Rank MoonClient.MLuaUICom
---@field Num MoonClient.MLuaUICom
---@field LvlRW MoonClient.MLuaUICom
---@field Content MoonClient.MLuaUICom
---@field CollectRW MoonClient.MLuaUICom
---@field Btn_MainReward MoonClient.MLuaUICom
---@field Btn_Collection MoonClient.MLuaUICom
---@field Btn_Back MoonClient.MLuaUICom
---@field IllustrationMonsterBg_Tog_Tem MoonClient.MLuaUIGroup
---@field IllustrationMonsterTypeTogTem MoonClient.MLuaUIGroup

---@return IllustrationMonsterBgPanel
---@param ctrl UIBase
function IllustrationMonsterBgPanel.Bind(ctrl)
	
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
return UI.IllustrationMonsterBgPanel