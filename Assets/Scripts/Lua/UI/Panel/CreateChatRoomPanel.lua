--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
CreateChatRoomPanel = {}

--lua model end

--lua functions
---@class CreateChatRoomPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field TypeMenum MoonClient.MLuaUICom
---@field NumMenum MoonClient.MLuaUICom
---@field InputField MoonClient.MLuaUICom
---@field Floor MoonClient.MLuaUICom
---@field CreatBtn MoonClient.MLuaUICom
---@field CodeText MoonClient.MLuaUICom
---@field CodeRandomBtn MoonClient.MLuaUICom
---@field CodeBtn MoonClient.MLuaUICom
---@field CloseBtn MoonClient.MLuaUICom
---@field CancelBtn MoonClient.MLuaUICom

---@return CreateChatRoomPanel
---@param ctrl UIBaseCtrl
function CreateChatRoomPanel.Bind(ctrl)
	
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
return UI.CreateChatRoomPanel