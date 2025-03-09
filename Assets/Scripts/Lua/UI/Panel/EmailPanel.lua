--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
EmailPanel = {}

--lua model end

--lua functions
---@class EmailPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field ItemViewport MoonClient.MLuaUICom
---@field GetItemGroup MoonClient.MLuaUICom
---@field GetBtn MoonClient.MLuaUICom
---@field GetAllBtn MoonClient.MLuaUICom
---@field EmailItemScroll MoonClient.MLuaUICom
---@field EmailItemParent MoonClient.MLuaUICom
---@field EMailBg MoonClient.MLuaUICom
---@field Email_Title MoonClient.MLuaUICom
---@field Email_TimeResidue MoonClient.MLuaUICom
---@field Email_Time MoonClient.MLuaUICom
---@field Email_TextEmpty MoonClient.MLuaUICom
---@field Email_PlayerIcon MoonClient.MLuaUICom
---@field Email_Name MoonClient.MLuaUICom
---@field Email_ItemMask MoonClient.MLuaUICom
---@field Email_ItemArea MoonClient.MLuaUICom
---@field Email_GetTag MoonClient.MLuaUICom
---@field Email_Emty MoonClient.MLuaUICom
---@field Email_Content MoonClient.MLuaUICom
---@field DelBtn MoonClient.MLuaUICom
---@field DelAllBtn MoonClient.MLuaUICom
---@field DatailObj MoonClient.MLuaUICom
---@field ContentRect MoonClient.MLuaUICom
---@field EmailItemPrefab MoonClient.MLuaUIGroup

---@return EmailPanel
---@param ctrl UIBase
function EmailPanel.Bind(ctrl)
	
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
return UI.EmailPanel