--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
DungeonExtendPanel = {}

--lua model end

--lua functions
---@class DungeonExtendPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field Value MoonClient.MLuaUICom[]
---@field TransferProfession MoonClient.MLuaUICom
---@field Text MoonClient.MLuaUICom[]
---@field TailLineSlider MoonClient.MLuaUICom
---@field TailLine MoonClient.MLuaUICom
---@field SliderGuard MoonClient.MLuaUICom
---@field PreyDungeon MoonClient.MLuaUICom
---@field NameText MoonClient.MLuaUICom
---@field Name MoonClient.MLuaUICom
---@field IconBtnBeckonMonsterElite MoonClient.MLuaUICom
---@field IconBtnBeckonMonster MoonClient.MLuaUICom
---@field Effect MoonClient.MLuaUICom[]
---@field BtnBeckonQuit MoonClient.MLuaUICom
---@field BtnBeckonMonsterElite MoonClient.MLuaUICom
---@field BtnBeckonMonster MoonClient.MLuaUICom
---@field bg MoonClient.MLuaUICom[]
---@field AttrList MoonClient.MLuaUICom
---@field Attributes_6 MoonClient.MLuaUICom
---@field Attributes_5 MoonClient.MLuaUICom
---@field Attributes_4 MoonClient.MLuaUICom
---@field Attributes_3 MoonClient.MLuaUICom
---@field Attributes_2 MoonClient.MLuaUICom
---@field Attributes_1 MoonClient.MLuaUICom
---@field AddPointDungeon MoonClient.MLuaUICom

---@return DungeonExtendPanel
---@param ctrl UIBaseCtrl
function DungeonExtendPanel.Bind(ctrl)
	
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
return UI.DungeonExtendPanel