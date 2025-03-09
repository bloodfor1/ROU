--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
RollbackPanel = {}

--lua model end

--lua functions
---@class RollbackPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field TitleOff MoonClient.MLuaUICom
---@field TextDesc MoonClient.MLuaUICom
---@field Text6 MoonClient.MLuaUICom
---@field Text5 MoonClient.MLuaUICom
---@field Text4 MoonClient.MLuaUICom
---@field Text3 MoonClient.MLuaUICom
---@field Text2 MoonClient.MLuaUICom
---@field Text1 MoonClient.MLuaUICom
---@field Sec MoonClient.MLuaUICom
---@field RawImage MoonClient.MLuaUICom
---@field Min MoonClient.MLuaUICom
---@field Hour MoonClient.MLuaUICom
---@field Btn_Back MoonClient.MLuaUICom
---@field Btn MoonClient.MLuaUICom
---@field Addtion6 MoonClient.MLuaUICom
---@field Addtion5 MoonClient.MLuaUICom
---@field Addtion4 MoonClient.MLuaUICom
---@field Addtion3 MoonClient.MLuaUICom
---@field Addtion2 MoonClient.MLuaUICom
---@field Addtion1 MoonClient.MLuaUICom

---@return RollbackPanel
---@param ctrl UIBase
function RollbackPanel.Bind(ctrl)
	
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
return UI.RollbackPanel