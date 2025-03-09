--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
AddFriendsPanel = {}

--lua model end

--lua functions
---@class AddFriendsPanel.AddFriend
---@field PanelRef MoonClient.MLuaUIPanel
---@field RoleJob MoonClient.MLuaUICom
---@field PlayerIconRoot MoonClient.MLuaUICom
---@field Number MoonClient.MLuaUICom
---@field NamePanel MoonClient.MLuaUICom
---@field Name MoonClient.MLuaUICom
---@field Level MoonClient.MLuaUICom
---@field Item MoonClient.MLuaUICom
---@field Image MoonClient.MLuaUICom
---@field BtnAdd MoonClient.MLuaUICom
---@field AchieveTpl MoonClient.MLuaUICom

---@class AddFriendsPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field SearchInput MoonClient.MLuaUICom
---@field ScrollView MoonClient.MLuaUICom
---@field Placeholder MoonClient.MLuaUICom
---@field InputText MoonClient.MLuaUICom
---@field Emty MoonClient.MLuaUICom
---@field Content MoonClient.MLuaUICom
---@field CloseButton MoonClient.MLuaUICom
---@field BtnSearch MoonClient.MLuaUICom
---@field AddFriend AddFriendsPanel.AddFriend

---@return AddFriendsPanel
---@param ctrl UIBase
function AddFriendsPanel.Bind(ctrl)
	
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
return UI.AddFriendsPanel