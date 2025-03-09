--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
WatchWarRecordPanel = {}

--lua model end

--lua functions
---@class WatchWarRecordPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field TitleMostWatched MoonClient.MLuaUICom
---@field TitleMostLiked MoonClient.MLuaUICom
---@field TextTotalWatch MoonClient.MLuaUICom
---@field TextTotalLike MoonClient.MLuaUICom
---@field TextTotalBeWatched MoonClient.MLuaUICom
---@field TextTotalBeLiked MoonClient.MLuaUICom
---@field NoneWatch MoonClient.MLuaUICom
---@field NoneLiked MoonClient.MLuaUICom
---@field MostWatched MoonClient.MLuaUICom
---@field MostLiked MoonClient.MLuaUICom
---@field Content MoonClient.MLuaUICom
---@field Btn_N_B02 MoonClient.MLuaUICom

---@return WatchWarRecordPanel
function WatchWarRecordPanel.Bind(ctrl)
	
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
return UI.WatchWarRecordPanel