--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
SignInPanel = {}

--lua model end

--lua functions
---@class SignInPanel.PointFloor
---@field PanelRef MoonClient.MLuaUIPanel
---@field StartImg MoonClient.MLuaUICom
---@field Floor MoonClient.MLuaUICom
---@field EndImg MoonClient.MLuaUICom

---@class SignInPanel.PointModel
---@field PanelRef MoonClient.MLuaUIPanel
---@field Up MoonClient.MLuaUICom
---@field Tag MoonClient.MLuaUICom
---@field ItemCount MoonClient.MLuaUICom
---@field Item MoonClient.MLuaUICom
---@field Desc MoonClient.MLuaUICom
---@field Btn MoonClient.MLuaUICom

---@class SignInPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field PointGroup MoonClient.MLuaUICom
---@field MatchEffect MoonClient.MLuaUICom
---@field FloorGroup MoonClient.MLuaUICom
---@field CurPointObj MoonClient.MLuaUICom
---@field BtnClose MoonClient.MLuaUICom
---@field PointFloor SignInPanel.PointFloor
---@field PointModel SignInPanel.PointModel

---@return SignInPanel
function SignInPanel.Bind(ctrl)

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
return UI.SignInPanel