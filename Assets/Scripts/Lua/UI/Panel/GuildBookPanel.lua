--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
GuildBookPanel = {}

--lua model end

--lua functions
---@class GuildBookPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field Txt_CurrentProgress MoonClient.MLuaUICom
---@field Obj_Prop3 MoonClient.MLuaUICom
---@field Obj_Prop2 MoonClient.MLuaUICom
---@field Obj_Prop1 MoonClient.MLuaUICom
---@field Img_Progress MoonClient.MLuaUICom
---@field Btn_Medal_ShangJiao3 MoonClient.MLuaUICom
---@field Btn_Medal_ShangJiao2 MoonClient.MLuaUICom
---@field Btn_Medal_ShangJiao1 MoonClient.MLuaUICom
---@field Btn_Contribution MoonClient.MLuaUICom
---@field Btn_Close MoonClient.MLuaUICom
---@field Template_Reward MoonClient.MLuaUIGroup

---@return GuildBookPanel
---@param ctrl UIBase
function GuildBookPanel.Bind(ctrl)
	
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
return UI.GuildBookPanel