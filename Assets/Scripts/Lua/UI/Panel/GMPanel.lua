--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
GMPanel = {}

--lua model end

--lua functions
---@class GMPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field UIAutoTest MoonClient.MLuaUICom
---@field UIAutoRandomTest MoonClient.MLuaUICom
---@field TextListener MoonClient.MLuaUICom
---@field TextCommandBtn MoonClient.MLuaUICom
---@field Text1 MoonClient.MLuaUICom
---@field Text MoonClient.MLuaUICom
---@field TestLua MoonClient.MLuaUICom
---@field TempTestBg MoonClient.MLuaUICom
---@field SetObjActiveBtn MoonClient.MLuaUICom
---@field ServerTimeTxt MoonClient.MLuaUICom
---@field serverTimeSettingBtn MoonClient.MLuaUICom
---@field serverTimeBtn MoonClient.MLuaUICom
---@field SchoolDrop MoonClient.MLuaUICom
---@field RoleLvInput MoonClient.MLuaUICom
---@field QualitySettingPanelBtn MoonClient.MLuaUICom
---@field OpenMainButtonBtn MoonClient.MLuaUICom
---@field MsgShowScroll MoonClient.MLuaUICom
---@field ModelDrop MoonClient.MLuaUICom
---@field InputTextCommand MoonClient.MLuaUICom
---@field InputTestLua MoonClient.MLuaUICom
---@field InputJobLv MoonClient.MLuaUICom
---@field InputJobExp MoonClient.MLuaUICom
---@field InputInfo MoonClient.MLuaUICom
---@field InputBaseLv MoonClient.MLuaUICom
---@field InputBaseExp MoonClient.MLuaUICom
---@field Input_TotalMsg MoonClient.MLuaUICom
---@field Input_NewMsg MoonClient.MLuaUICom
---@field FastCreateBtn MoonClient.MLuaUICom
---@field EnvironWeatherGMPanelBtn MoonClient.MLuaUICom
---@field DropdownHistory MoonClient.MLuaUICom
---@field DoShowReporterGuiBtn MoonClient.MLuaUICom
---@field DoDumpLogCatBtn MoonClient.MLuaUICom
---@field ButtonPrefab MoonClient.MLuaUICom
---@field ButtonParent MoonClient.MLuaUICom
---@field ButtonOpenHttp MoonClient.MLuaUICom
---@field ButtonCloseHttp MoonClient.MLuaUICom
---@field ButtonClearListen MoonClient.MLuaUICom
---@field ButtonAddListen MoonClient.MLuaUICom
---@field BtnUIExam MoonClient.MLuaUICom
---@field BtnTestLua MoonClient.MLuaUICom
---@field BtnRPCExam MoonClient.MLuaUICom
---@field BtnPtcExam MoonClient.MLuaUICom
---@field BtnPayTest MoonClient.MLuaUICom
---@field BtnJobLv MoonClient.MLuaUICom
---@field BtnJobExp MoonClient.MLuaUICom
---@field BtnExcuteLua MoonClient.MLuaUICom
---@field BtnDps MoonClient.MLuaUICom
---@field BtnCookingTest MoonClient.MLuaUICom
---@field BtnCloseTestLua MoonClient.MLuaUICom
---@field BtnClose MoonClient.MLuaUICom
---@field BtnBaseLv MoonClient.MLuaUICom
---@field BtnBaseExp MoonClient.MLuaUICom
---@field Btn_Profession MoonClient.MLuaUICom
---@field Btn_luahotreload MoonClient.MLuaUICom
---@field Btn_Close MoonClient.MLuaUICom
---@field Btn_ClearTotalInfo MoonClient.MLuaUICom
---@field BG MoonClient.MLuaUICom
---@field AlphaSlider MoonClient.MLuaUICom
---@field Btn_TestFuncTemplate MoonClient.MLuaUIGroup

---@return GMPanel
function GMPanel.Bind(ctrl)

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
return UI.GMPanel