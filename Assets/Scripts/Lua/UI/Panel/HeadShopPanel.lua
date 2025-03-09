--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
HeadShopPanel = {}

--lua model end

--lua functions
---@class HeadShopPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field Unlocked MoonClient.MLuaUICom
---@field TextMessage MoonClient.MLuaUICom
---@field RefineName MoonClient.MLuaUICom
---@field PlayerPreview MoonClient.MLuaUICom
---@field Name MoonClient.MLuaUICom
---@field ModelTouchArea MoonClient.MLuaUICom
---@field ModelName MoonClient.MLuaUICom
---@field ModelImage MoonClient.MLuaUICom
---@field LimitStr MoonClient.MLuaUICom
---@field ItemlImage MoonClient.MLuaUICom
---@field Img_decorate MoonClient.MLuaUICom
---@field HeadScrollView MoonClient.MLuaUICom
---@field Go6 MoonClient.MLuaUICom
---@field Go5 MoonClient.MLuaUICom
---@field Go4 MoonClient.MLuaUICom
---@field Go3 MoonClient.MLuaUICom
---@field Go2 MoonClient.MLuaUICom
---@field Go1 MoonClient.MLuaUICom
---@field CostPanel MoonClient.MLuaUICom
---@field CostContent MoonClient.MLuaUICom
---@field Content MoonClient.MLuaUICom
---@field Condition6 MoonClient.MLuaUICom
---@field Condition5 MoonClient.MLuaUICom
---@field Condition4 MoonClient.MLuaUICom
---@field Condition3 MoonClient.MLuaUICom
---@field Condition2 MoonClient.MLuaUICom
---@field Condition1 MoonClient.MLuaUICom
---@field Collider MoonClient.MLuaUICom
---@field CloseButton MoonClient.MLuaUICom
---@field ButtonOverview MoonClient.MLuaUICom
---@field Bubble MoonClient.MLuaUICom
---@field BtOp MoonClient.MLuaUICom
---@field BtClose MoonClient.MLuaUICom
---@field BGbtn MoonClient.MLuaUICom
---@field ArrowRight MoonClient.MLuaUICom
---@field ArrowLeft MoonClient.MLuaUICom
---@field Anchor MoonClient.MLuaUICom
---@field HeadShopItem MoonClient.MLuaUIGroup

---@return HeadShopPanel
function HeadShopPanel.Bind(ctrl)

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
return UI.HeadShopPanel