--this file is gen by script
--you can edit this file in custom part


--lua model
module("UI", package.seeall)
LifeProfessionProducePanel = {}

--lua model end

--lua functions
---@class LifeProfessionProducePanel
---@field PanelRef MoonClient.MLuaUIPanel
---@field Txt_SucRate MoonClient.MLuaUICom
---@field Txt_SkillProgress MoonClient.MLuaUICom
---@field Txt_produceProductName MoonClient.MLuaUICom
---@field Txt_ProduceNum MoonClient.MLuaUICom
---@field Txt_MustSuc MoonClient.MLuaUICom
---@field Txt_LvLabel MoonClient.MLuaUICom
---@field Txt_Lv MoonClient.MLuaUICom
---@field Txt_FuncName MoonClient.MLuaUICom
---@field Txt_FuncDesc MoonClient.MLuaUICom
---@field Txt_BigSucRewardRate MoonClient.MLuaUICom
---@field Txt_BigSucRate MoonClient.MLuaUICom
---@field TogEx_Weapon MoonClient.MLuaUICom
---@field TogEx_Star3 MoonClient.MLuaUICom
---@field TogEx_Star2 MoonClient.MLuaUICom
---@field TogEx_Star1 MoonClient.MLuaUICom
---@field TogEx_Armor MoonClient.MLuaUICom
---@field Slider_Exp MoonClient.MLuaUICom
---@field Scroll_productList MoonClient.MLuaUICom
---@field Scroll_ProduceCost MoonClient.MLuaUICom
---@field Scroll_multiProfessionProducts MoonClient.MLuaUICom
---@field Panel_singleProfession MoonClient.MLuaUICom
---@field Panel_multiProfession MoonClient.MLuaUICom
---@field Panel_ChanceInfo MoonClient.MLuaUICom
---@field Obj_StarTog MoonClient.MLuaUICom
---@field Obj_ChengGongLv MoonClient.MLuaUICom
---@field Img_SlideFill MoonClient.MLuaUICom
---@field Img_producePropIcon MoonClient.MLuaUICom
---@field Img_produceProp MoonClient.MLuaUICom
---@field Img_LifeProfessionBg MoonClient.MLuaUICom
---@field ConBtn_Reduce MoonClient.MLuaUICom
---@field ConBtn_Add MoonClient.MLuaUICom
---@field BtnMiddle_B MoonClient.MLuaUICom
---@field BtnMiddle_A MoonClient.MLuaUICom
---@field Btn_Produce MoonClient.MLuaUICom
---@field Btn_Goto MoonClient.MLuaUICom
---@field Btn_Close MoonClient.MLuaUICom
---@field Template_LifeProfessionProduct MoonClient.MLuaUIGroup

---@return LifeProfessionProducePanel
---@param ctrl UIBase
function LifeProfessionProducePanel.Bind(ctrl)
	
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
return UI.LifeProfessionProducePanel