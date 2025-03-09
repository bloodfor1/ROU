--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
VehicleShopPanel = {}

--lua model end

--lua functions
---@class VehicleShopPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field RefineName MoonClient.MLuaUICom
---@field PlayerPreview MoonClient.MLuaUICom
---@field ModelTouchArea MoonClient.MLuaUICom
---@field ModelName MoonClient.MLuaUICom
---@field ModelImage MoonClient.MLuaUICom
---@field LimitStr MoonClient.MLuaUICom
---@field ItemlImage MoonClient.MLuaUICom
---@field ImgName MoonClient.MLuaUICom
---@field Img_TouchArea MoonClient.MLuaUICom
---@field HeadScrollView MoonClient.MLuaUICom
---@field CostPanel MoonClient.MLuaUICom
---@field CostContent MoonClient.MLuaUICom
---@field Content MoonClient.MLuaUICom
---@field Collider MoonClient.MLuaUICom
---@field CloseButton MoonClient.MLuaUICom
---@field BtOp MoonClient.MLuaUICom
---@field BtClose MoonClient.MLuaUICom
---@field BGbtn MoonClient.MLuaUICom
---@field Anchor MoonClient.MLuaUICom
---@field VehicleShopItem MoonClient.MLuaUIGroup

---@return VehicleShopPanel
function VehicleShopPanel.Bind(ctrl)
	
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
return UI.VehicleShopPanel