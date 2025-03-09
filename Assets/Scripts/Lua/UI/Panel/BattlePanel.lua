--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
BattlePanel = {}

--lua model end

--lua functions
---@class BattlePanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field WaitPanel MoonClient.MLuaUICom
---@field TxtRightKillNum MoonClient.MLuaUICom
---@field TxtLeftKillNum MoonClient.MLuaUICom
---@field Txt_Time MoonClient.MLuaUICom
---@field Tips MoonClient.MLuaUICom
---@field Time MoonClient.MLuaUICom
---@field RuningTips MoonClient.MLuaUICom
---@field Red4 MoonClient.MLuaUICom
---@field Red3 MoonClient.MLuaUICom
---@field Red2 MoonClient.MLuaUICom
---@field Red1 MoonClient.MLuaUICom
---@field RawImageRight MoonClient.MLuaUICom
---@field RawImageLeft MoonClient.MLuaUICom
---@field pkObject MoonClient.MLuaUICom
---@field ObjHint MoonClient.MLuaUICom
---@field Num2 MoonClient.MLuaUICom
---@field Num1 MoonClient.MLuaUICom
---@field MatchObj MoonClient.MLuaUICom
---@field MatchEffect MoonClient.MLuaUICom
---@field MatchBtnIcon MoonClient.MLuaUICom
---@field MatchBtn MoonClient.MLuaUICom
---@field Image2 MoonClient.MLuaUICom
---@field Image1 MoonClient.MLuaUICom
---@field HintEffect MoonClient.MLuaUICom
---@field HintBtnIcon MoonClient.MLuaUICom
---@field HintBtn MoonClient.MLuaUICom
---@field Fx_RedFire_Fly MoonClient.MLuaUICom
---@field Fx_BlueFire_Fly MoonClient.MLuaUICom
---@field Effect3 MoonClient.MLuaUICom
---@field Effect2 MoonClient.MLuaUICom
---@field Effect1 MoonClient.MLuaUICom
---@field DoorHP2 MoonClient.MLuaUICom
---@field DoorHP1 MoonClient.MLuaUICom
---@field desText MoonClient.MLuaUICom
---@field CrystalHP2 MoonClient.MLuaUICom
---@field CrystalHP1 MoonClient.MLuaUICom
---@field ChargeBar2 MoonClient.MLuaUICom
---@field ChargeBar1 MoonClient.MLuaUICom
---@field Blue4 MoonClient.MLuaUICom
---@field Blue3 MoonClient.MLuaUICom
---@field Blue2 MoonClient.MLuaUICom
---@field Blue1 MoonClient.MLuaUICom
---@field BattlePanel MoonClient.MLuaUICom
---@field Alarm MoonClient.MLuaUICom

---@return BattlePanel
---@param ctrl UIBase
function BattlePanel.Bind(ctrl)
	
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
return UI.BattlePanel