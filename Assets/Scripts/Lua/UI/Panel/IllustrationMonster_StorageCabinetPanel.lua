--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
IllustrationMonster_StorageCabinetPanel = {}

--lua model end

--lua functions
---@class IllustrationMonster_StorageCabinetPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field TxtMsg MoonClient.MLuaUICom
---@field LoopElement MoonClient.MLuaUICom
---@field LoopDoll MoonClient.MLuaUICom
---@field GroupElement MoonClient.MLuaUICom
---@field GroupDoll MoonClient.MLuaUICom
---@field ButtonClose MoonClient.MLuaUICom
---@field BtnMiddle_B MoonClient.MLuaUICom
---@field BtnMiddle_A MoonClient.MLuaUICom
---@field Btn_Wenhao MoonClient.MLuaUICom
---@field Btn_Exchange2 MoonClient.MLuaUICom
---@field Btn_Exchange MoonClient.MLuaUICom
---@field BTN_B_on MoonClient.MLuaUICom
---@field BTN_B_off MoonClient.MLuaUICom
---@field BTN_A_on MoonClient.MLuaUICom
---@field BTN_A_off MoonClient.MLuaUICom
---@field IllustrationMonster_StorageCabinet_DollTem MoonClient.MLuaUIGroup
---@field IllustrationMonster_StorageCabinet_ElementTem MoonClient.MLuaUIGroup

---@return IllustrationMonster_StorageCabinetPanel
---@param ctrl UIBase
function IllustrationMonster_StorageCabinetPanel.Bind(ctrl)
	
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
return UI.IllustrationMonster_StorageCabinetPanel