--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
CreateCharPanel = {}

--lua model end

--lua functions
---@class CreateCharPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field PanelEditHair MoonClient.MLuaUICom
---@field PanelEditEye MoonClient.MLuaUICom
---@field PanelCreateChar MoonClient.MLuaUICom
---@field Notice2 MoonClient.MLuaUICom
---@field Notice1 MoonClient.MLuaUICom
---@field ImageUp2 MoonClient.MLuaUICom
---@field ImageUp1 MoonClient.MLuaUICom
---@field ImageHairPanel1 MoonClient.MLuaUICom
---@field ImageHairPanel MoonClient.MLuaUICom
---@field ImageEyePanel1 MoonClient.MLuaUICom
---@field ImageEyePanel MoonClient.MLuaUICom
---@field ImageDown2 MoonClient.MLuaUICom
---@field ImageDown1 MoonClient.MLuaUICom
---@field HairTogs MoonClient.MLuaUICom
---@field HairScrolls MoonClient.MLuaUICom
---@field HairColors MoonClient.MLuaUICom
---@field EyeTogs MoonClient.MLuaUICom
---@field EyeScrolls MoonClient.MLuaUICom
---@field EyeColorBar MoonClient.MLuaUICom
---@field Enter MoonClient.MLuaUICom
---@field BtnReturnGender MoonClient.MLuaUICom
---@field BGbtn MoonClient.MLuaUICom
---@field CreateCharTogTemplate MoonClient.MLuaUIGroup
---@field BarberColorTemplate MoonClient.MLuaUIGroup

---@return CreateCharPanel
---@param ctrl UIBase
function CreateCharPanel.Bind(ctrl)
	
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
return UI.CreateCharPanel