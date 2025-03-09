--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
StoryBoardPanel = {}

--lua model end

--lua functions
---@class StoryBoardPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field ShareButton MoonClient.MLuaUICom
---@field ContentRoot MoonClient.MLuaUICom
---@field BG_Single_Image MoonClient.MLuaUICom
---@field BG_Multi_Images MoonClient.MLuaUICom
---@field BG_Image_Right MoonClient.MLuaUICom
---@field BG_Image_Left MoonClient.MLuaUICom
---@field AnimationObj MoonClient.MLuaUICom

---@return StoryBoardPanel
---@param ctrl UIBase
function StoryBoardPanel.Bind(ctrl)
	
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
return UI.StoryBoardPanel