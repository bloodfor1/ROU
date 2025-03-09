--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
BeiluzCorePanel = {}

--lua model end

--lua functions
---@class BeiluzCorePanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field txtLeftInvalidTip MoonClient.MLuaUICom
---@field TotalWeightContent MoonClient.MLuaUICom
---@field TotalWeight MoonClient.MLuaUICom
---@field tglGroupRoot MoonClient.MLuaUICom
---@field TglCore MoonClient.MLuaUICom[]
---@field TaskLink MoonClient.MLuaUICom
---@field SlotAttr MoonClient.MLuaUICom[]
---@field RawImageBtn MoonClient.MLuaUICom
---@field RawImage MoonClient.MLuaUICom
---@field overLoad MoonClient.MLuaUICom
---@field Main MoonClient.MLuaUICom
---@field LockBtn MoonClient.MLuaUICom[]
---@field EmptyTip MoonClient.MLuaUICom
---@field DropdownRoot MoonClient.MLuaUICom
---@field Dropdown MoonClient.MLuaUICom
---@field DetailSkillName MoonClient.MLuaUICom[]
---@field DetailSkillDesc MoonClient.MLuaUICom[]
---@field DetailItemBG MoonClient.MLuaUICom
---@field CoreListRoot MoonClient.MLuaUICom
---@field CoreList MoonClient.MLuaUICom
---@field CoreItemRoot MoonClient.MLuaUICom[]
---@field ButtonClose MoonClient.MLuaUICom
---@field BtnUnload MoonClient.MLuaUICom
---@field BtnRule MoonClient.MLuaUICom
---@field BtnReset MoonClient.MLuaUICom
---@field BtnModelStateSwitch MoonClient.MLuaUICom
---@field BtnMaintain MoonClient.MLuaUICom
---@field BtnGetWay MoonClient.MLuaUICom
---@field BtnCombine MoonClient.MLuaUICom
---@field AttRoot MoonClient.MLuaUICom
---@field AttrName MoonClient.MLuaUICom
---@field AttrLife MoonClient.MLuaUICom
---@field AttContent MoonClient.MLuaUICom

---@return BeiluzCorePanel
---@param ctrl UIBase
function BeiluzCorePanel.Bind(ctrl)
	
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
return UI.BeiluzCorePanel