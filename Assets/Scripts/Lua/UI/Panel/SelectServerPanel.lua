--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
SelectServerPanel = {}

--lua model end

--lua functions
---@class SelectServerPanel.ServerItemTemplate
---@field PanelRef MoonClient.MLuaUIPanel
---@field Text MoonClient.MLuaUICom
---@field ServerItem MoonClient.MLuaUICom
---@field Img_Recommend MoonClient.MLuaUICom
---@field Img_New MoonClient.MLuaUICom
---@field Img MoonClient.MLuaUICom

---@class SelectServerPanel.ServerBtnTemplate
---@field PanelRef MoonClient.MLuaUIPanel
---@field TextSelect MoonClient.MLuaUICom
---@field Text MoonClient.MLuaUICom
---@field Checkmark MoonClient.MLuaUICom
---@field Background MoonClient.MLuaUICom

---@class SelectServerPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field SvrScroll MoonClient.MLuaUICom
---@field SvrList MoonClient.MLuaUICom
---@field ServerStateImages MoonClient.MLuaUICom[]
---@field BtnScroll MoonClient.MLuaUICom
---@field BtnContent MoonClient.MLuaUICom
---@field Btn_closeSelect MoonClient.MLuaUICom
---@field ServerItemTemplate SelectServerPanel.ServerItemTemplate
---@field ServerBtnTemplate SelectServerPanel.ServerBtnTemplate

---@return SelectServerPanel
---@param ctrl UIBase
function SelectServerPanel.Bind(ctrl)
	
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
return UI.SelectServerPanel