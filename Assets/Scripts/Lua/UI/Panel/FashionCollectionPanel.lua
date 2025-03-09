--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
FashionCollectionPanel = {}

--lua model end

--lua functions
---@class FashionCollectionPanel.PanelInv
---@field PanelRef MoonClient.MLuaUIPanel
---@field Title MoonClient.MLuaUICom
---@field Time MoonClient.MLuaUICom
---@field Group MoonClient.MLuaUICom
---@field Describe MoonClient.MLuaUICom
---@field BtnOpen MoonClient.MLuaUICom

---@class FashionCollectionPanel.PanelBefore
---@field PanelRef MoonClient.MLuaUIPanel
---@field Time MoonClient.MLuaUICom
---@field Group MoonClient.MLuaUICom
---@field Describe MoonClient.MLuaUICom
---@field BtnQuestion MoonClient.MLuaUICom
---@field BtnGo MoonClient.MLuaUICom
---@field BtnAward MoonClient.MLuaUICom

---@class FashionCollectionPanel.PanelAfter
---@field PanelRef MoonClient.MLuaUIPanel
---@field Time MoonClient.MLuaUICom
---@field Model MoonClient.MLuaUICom
---@field Group MoonClient.MLuaUICom
---@field Describe MoonClient.MLuaUICom
---@field BtnShare MoonClient.MLuaUICom
---@field BtnQuestion MoonClient.MLuaUICom
---@field BtnGo MoonClient.MLuaUICom
---@field BtnAward MoonClient.MLuaUICom

---@class FashionCollectionPanel.PanelRank
---@field PanelRef MoonClient.MLuaUIPanel
---@field ScrollView MoonClient.MLuaUICom
---@field None MoonClient.MLuaUICom
---@field MyScore MoonClient.MLuaUICom
---@field MyRank MoonClient.MLuaUICom
---@field MyName MoonClient.MLuaUICom
---@field Model MoonClient.MLuaUICom
---@field Group MoonClient.MLuaUICom
---@field FashionRankDescribe MoonClient.MLuaUICom
---@field Content MoonClient.MLuaUICom
---@field Choose MoonClient.MLuaUICom
---@field BtnScreen MoonClient.MLuaUICom
---@field BtnQuestion MoonClient.MLuaUICom
---@field Bg MoonClient.MLuaUICom
---@field FashionRank MoonClient.MLuaUIGroup

---@class FashionCollectionPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field TogRank MoonClient.MLuaUICom
---@field TogFashion MoonClient.MLuaUICom
---@field BtnTab MoonClient.MLuaUICom
---@field BtnClose MoonClient.MLuaUICom
---@field PanelInv FashionCollectionPanel.PanelInv
---@field PanelBefore FashionCollectionPanel.PanelBefore
---@field PanelAfter FashionCollectionPanel.PanelAfter
---@field PanelRank FashionCollectionPanel.PanelRank

---@return FashionCollectionPanel
---@param ctrl UIBase
function FashionCollectionPanel.Bind(ctrl)
	
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
return UI.FashionCollectionPanel