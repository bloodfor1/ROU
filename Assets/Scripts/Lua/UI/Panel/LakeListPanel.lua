--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
LakeListPanel = {}

--lua model end

--lua functions
---@class LakeListPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field TogNearBy MoonClient.MLuaUICom
---@field TogLake MoonClient.MLuaUICom
---@field ToggleGroup MoonClient.MLuaUICom
---@field NoModel MoonClient.MLuaUICom
---@field NoLake MoonClient.MLuaUICom
---@field No_Text MoonClient.MLuaUICom
---@field ModelImage MoonClient.MLuaUICom
---@field Image MoonClient.MLuaUICom[]
---@field FashionNum MoonClient.MLuaUICom
---@field Content MoonClient.MLuaUICom
---@field CloseButton MoonClient.MLuaUICom
---@field BtnRefreshtxt MoonClient.MLuaUICom
---@field BtnRefresh MoonClient.MLuaUICom
---@field LakeTpl MoonClient.MLuaUIGroup

---@return LakeListPanel
---@param ctrl UIBase
function LakeListPanel.Bind(ctrl)
	
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
return UI.LakeListPanel