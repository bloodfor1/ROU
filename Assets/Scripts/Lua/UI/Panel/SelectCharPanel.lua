--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
SelectCharPanel = {}

--lua model end

--lua functions
---@class SelectCharPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field ReText MoonClient.MLuaUICom
---@field RePanel MoonClient.MLuaUICom
---@field PanelSelectChar MoonClient.MLuaUICom
---@field PanelEditHair MoonClient.MLuaUICom
---@field PanelEditEye MoonClient.MLuaUICom
---@field PanelCreateChar MoonClient.MLuaUICom
---@field ObjHairButton MoonClient.MLuaUICom
---@field ObjEyeButton MoonClient.MLuaUICom
---@field Notice2 MoonClient.MLuaUICom
---@field Notice1 MoonClient.MLuaUICom
---@field MaleImage3 MoonClient.MLuaUICom
---@field MaleImage2 MoonClient.MLuaUICom
---@field MaleImage1 MoonClient.MLuaUICom
---@field ImageUp2 MoonClient.MLuaUICom
---@field ImageUp1 MoonClient.MLuaUICom
---@field ImageHairPanel1 MoonClient.MLuaUICom
---@field ImageHairPanel MoonClient.MLuaUICom
---@field ImageHair1 MoonClient.MLuaUICom
---@field ImageHair MoonClient.MLuaUICom
---@field ImageEyePanel1 MoonClient.MLuaUICom
---@field ImageEyePanel MoonClient.MLuaUICom
---@field ImageEye1 MoonClient.MLuaUICom
---@field ImageEye MoonClient.MLuaUICom
---@field ImageDown2 MoonClient.MLuaUICom
---@field ImageDown1 MoonClient.MLuaUICom
---@field HairTogs MoonClient.MLuaUICom
---@field HairScrolls MoonClient.MLuaUICom
---@field HairColors MoonClient.MLuaUICom
---@field FemaleImage3 MoonClient.MLuaUICom
---@field FemaleImage2 MoonClient.MLuaUICom
---@field FemaleImage1 MoonClient.MLuaUICom
---@field EyeTogs MoonClient.MLuaUICom
---@field EyeScrolls MoonClient.MLuaUICom
---@field EyeColorBar MoonClient.MLuaUICom
---@field Content MoonClient.MLuaUICom
---@field ButtonRevert MoonClient.MLuaUICom
---@field ButtonMale MoonClient.MLuaUICom
---@field ButtonFemale MoonClient.MLuaUICom
---@field ButtonDelete MoonClient.MLuaUICom
---@field BtnVerifyChar MoonClient.MLuaUICom
---@field BtnStartGame MoonClient.MLuaUICom
---@field BtnReturnLogin MoonClient.MLuaUICom
---@field BtnReturnGender MoonClient.MLuaUICom
---@field BtnHair MoonClient.MLuaUICom
---@field BtnEye MoonClient.MLuaUICom
---@field SelectCharHeadTemplate MoonClient.MLuaUIGroup
---@field CreateCharTogTemplate MoonClient.MLuaUIGroup
---@field BarberColorTemplate MoonClient.MLuaUIGroup

---@return SelectCharPanel
---@param ctrl UIBase
function SelectCharPanel.Bind(ctrl)
	
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
return UI.SelectCharPanel