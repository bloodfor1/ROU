--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
LifeProduceResultPanel = {}

--lua model end

--lua functions
---@class LifeProduceResultPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field Txt_RewardProp2 MoonClient.MLuaUICom
---@field Txt_RewardProp1 MoonClient.MLuaUICom
---@field Txt_RewardProp MoonClient.MLuaUICom
---@field Txt_ProduceCount2 MoonClient.MLuaUICom
---@field Txt_ProduceCount1 MoonClient.MLuaUICom
---@field Txt_ProduceCount MoonClient.MLuaUICom
---@field Raw_ProduceResult2 MoonClient.MLuaUICom
---@field Raw_ProduceResult1 MoonClient.MLuaUICom
---@field Raw_ProduceResult MoonClient.MLuaUICom
---@field Img_RewardProp2 MoonClient.MLuaUICom
---@field Img_RewardProp1 MoonClient.MLuaUICom
---@field Img_RewardProp MoonClient.MLuaUICom
---@field Img_Bg MoonClient.MLuaUICom

---@return LifeProduceResultPanel
---@param ctrl UIBase
function LifeProduceResultPanel.Bind(ctrl)
	
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
return UI.LifeProduceResultPanel