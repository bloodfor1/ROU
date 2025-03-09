--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
VehiclesCharacteristicPanel = {}

--lua model end

--lua functions
---@class VehiclesCharacteristicPanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field VehicleName MoonClient.MLuaUICom
---@field TxtNoItem MoonClient.MLuaUICom
---@field Txt_Percentage MoonClient.MLuaUICom
---@field ToggleEx_ChooseShape MoonClient.MLuaUICom
---@field SurplusTime MoonClient.MLuaUICom
---@field SpeedImage MoonClient.MLuaUICom
---@field SkyImage MoonClient.MLuaUICom
---@field SingleImage MoonClient.MLuaUICom
---@field ShopPanel MoonClient.MLuaUICom
---@field ShopBtn MoonClient.MLuaUICom
---@field RestBtn MoonClient.MLuaUICom
---@field ProgressText MoonClient.MLuaUICom
---@field PanelNoItem MoonClient.MLuaUICom
---@field Panel_Right MoonClient.MLuaUICom
---@field Panel_DyeingColors MoonClient.MLuaUICom
---@field Panel_DetailInfo MoonClient.MLuaUICom
---@field Panel_CustomMadeCost MoonClient.MLuaUICom
---@field Panel_CustomMadeContent MoonClient.MLuaUICom
---@field Panel_CustomMade MoonClient.MLuaUICom
---@field Panel_ChooseDyeing MoonClient.MLuaUICom
---@field OtherPanel MoonClient.MLuaUICom
---@field OnlyWearToggle MoonClient.MLuaUICom
---@field Obj_StartAnim MoonClient.MLuaUICom
---@field ModelImage MoonClient.MLuaUICom
---@field LoopScroll_CustMadeCost MoonClient.MLuaUICom
---@field LevelIgnore MoonClient.MLuaUICom
---@field LandImage MoonClient.MLuaUICom
---@field Img_TouchArea MoonClient.MLuaUICom
---@field Image_VehicleHeadBg MoonClient.MLuaUICom
---@field HeadScrollView MoonClient.MLuaUICom
---@field GotoButton MoonClient.MLuaUICom
---@field EnablingBtn MoonClient.MLuaUICom
---@field DoubleImage MoonClient.MLuaUICom
---@field DescribeTxt MoonClient.MLuaUICom
---@field CostPanel MoonClient.MLuaUICom
---@field CostContent MoonClient.MLuaUICom
---@field ColourContent MoonClient.MLuaUICom
---@field Btn_VehicleFeatureTip MoonClient.MLuaUICom
---@field Btn_FetchDye MoonClient.MLuaUICom
---@field Btn_Fetch MoonClient.MLuaUICom
---@field Btn_DyeHelper MoonClient.MLuaUICom
---@field Btn_CustomMade MoonClient.MLuaUICom
---@field BarterPanel MoonClient.MLuaUICom
---@field AttrTpl3 MoonClient.MLuaUICom
---@field AttrTpl2 MoonClient.MLuaUICom
---@field AttrTpl1 MoonClient.MLuaUICom
---@field AttrNum3 MoonClient.MLuaUICom
---@field AttrNum2 MoonClient.MLuaUICom
---@field AttrNum1 MoonClient.MLuaUICom
---@field AttrName3 MoonClient.MLuaUICom
---@field AttrName2 MoonClient.MLuaUICom
---@field AttrName1 MoonClient.MLuaUICom
---@field VehicleCharaItem MoonClient.MLuaUIGroup
---@field Template_ColorChoose MoonClient.MLuaUIGroup

---@return VehiclesCharacteristicPanel
---@param ctrl UIBase
function VehiclesCharacteristicPanel.Bind(ctrl)
	
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
return UI.VehiclesCharacteristicPanel