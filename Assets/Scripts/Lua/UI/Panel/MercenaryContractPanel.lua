--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
MercenaryContractPanel = {}

--lua model end

--lua functions
---@class MercenaryContractPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field TipsText MoonClient.MLuaUICom
---@field TipBtn MoonClient.MLuaUICom
---@field SealEffect MoonClient.MLuaUICom
---@field NameText MoonClient.MLuaUICom
---@field MercenaryImg MoonClient.MLuaUICom
---@field JobText MoonClient.MLuaUICom
---@field Img_ProfessionIcon MoonClient.MLuaUICom
---@field CircleEffect MoonClient.MLuaUICom
---@field BackBtn MoonClient.MLuaUICom

---@return MercenaryContractPanel
---@param ctrl UIBase
function MercenaryContractPanel.Bind(ctrl)
	
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
return UI.MercenaryContractPanel