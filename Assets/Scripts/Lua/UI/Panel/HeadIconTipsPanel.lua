--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
HeadIconTipsPanel = {}

--lua model end

--lua functions
---@class HeadIconTipsPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field txtTipType MoonClient.MLuaUICom
---@field txtTipName MoonClient.MLuaUICom
---@field txtTipLevel MoonClient.MLuaUICom
---@field txtTipId MoonClient.MLuaUICom
---@field txtDes MoonClient.MLuaUICom
---@field ShowIllustrated MoonClient.MLuaUICom
---@field ItemImg MoonClient.MLuaUICom
---@field ImgTipIconBg MoonClient.MLuaUICom
---@field imgFengexian MoonClient.MLuaUICom
---@field imageEquipFlag MoonClient.MLuaUICom
---@field detailTrans MoonClient.MLuaUICom
---@field DetailInfoScroll MoonClient.MLuaUICom
---@field DetailInfo MoonClient.MLuaUICom
---@field btnHuoqu MoonClient.MLuaUICom
---@field btnGM MoonClient.MLuaUICom
---@field BtnClose MoonClient.MLuaUICom

---@return HeadIconTipsPanel
function HeadIconTipsPanel.Bind(ctrl)

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
return UI.HeadIconTipsPanel