--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
CuisineTipsPanel = {}

--lua model end

--lua functions
---@class CuisineTipsPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field TipsTpl MoonClient.MLuaUICom
---@field TipsPanel MoonClient.MLuaUICom
---@field ImgTipIcon MoonClient.MLuaUICom
---@field ImgStar7 MoonClient.MLuaUICom
---@field ImgStar6 MoonClient.MLuaUICom
---@field ImgStar5 MoonClient.MLuaUICom
---@field ImgStar4 MoonClient.MLuaUICom
---@field ImgStar3 MoonClient.MLuaUICom
---@field ImgStar2 MoonClient.MLuaUICom
---@field ImgStar1 MoonClient.MLuaUICom
---@field Count MoonClient.MLuaUICom
---@field BtnTip3 MoonClient.MLuaUICom
---@field BtnHuoqu MoonClient.MLuaUICom

---@return CuisineTipsPanel
---@param ctrl UIBaseCtrl
function CuisineTipsPanel.Bind(ctrl)
	
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
return UI.CuisineTipsPanel