--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
CardUnsealPanel = {}

--lua model end

--lua functions
---@class CardUnsealPanel.UnsealCardCell
---@field PanelRef MoonClient.MLuaUIPanel
---@field Select MoonClient.MLuaUICom
---@field Name MoonClient.MLuaUICom
---@field ItemIcon MoonClient.MLuaUICom
---@field Equiped MoonClient.MLuaUICom
---@field BackBtn MoonClient.MLuaUICom

---@class CardUnsealPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field UnsealBtn MoonClient.MLuaUICom
---@field RightEmpty MoonClient.MLuaUICom
---@field LeftEmpty MoonClient.MLuaUICom
---@field ItemScrollRect MoonClient.MLuaUICom
---@field Floor MoonClient.MLuaUICom
---@field EquipTog MoonClient.MLuaUICom
---@field Detail MoonClient.MLuaUICom
---@field CloseBtn MoonClient.MLuaUICom
---@field CardScrollRect MoonClient.MLuaUICom
---@field CardNameBg MoonClient.MLuaUICom
---@field CardName MoonClient.MLuaUICom
---@field CardImg MoonClient.MLuaUICom
---@field CardAttrText MoonClient.MLuaUICom
---@field CardAttrBg MoonClient.MLuaUICom
---@field CardAttr MoonClient.MLuaUICom
---@field Card_Bg MoonClient.MLuaUICom
---@field AttrCardNameBg MoonClient.MLuaUICom
---@field AttrCardName MoonClient.MLuaUICom
---@field UnsealCardCell CardUnsealPanel.UnsealCardCell

---@return CardUnsealPanel
---@param ctrl UIBase
function CardUnsealPanel.Bind(ctrl)
	
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
return UI.CardUnsealPanel