--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/VehiclesCharacteristicPanel"
require "UI/Template/VehicleCharaItemTemplete"
require "UI/Template/ItemTemplate"
require "Common/Utils"
require "Common/CommonUIFunc"
require "Data/Model/BagModel"
--lua requires end

--lua model
module("UI", package.seeall)

--lua model end

--lua fields
local super = UI.UIBaseCtrl
local nowVehicleTable = 0                --0:所有载具  1:飞行载具  2:陆地载具
local isOwnType = false                     --是否仅显示已拥有
local selectClick = 0                    --玩家选中当前载具ID，为0表示没有符合条件的载具可显示
--lua fields end

--lua class define
---@class VehiclesCharacteristicCtrl : UIBaseCtrl
VehiclesCharacteristicCtrl = class("VehiclesCharacteristicCtrl", super)
--lua class define end

--lua functions
function VehiclesCharacteristicCtrl:ctor()
	
	super.ctor(self, CtrlNames.VehiclesCharacteristic, UILayer.Function, nil, ActiveType.Exclusive)
	self.InsertPanelName = UI.CtrlNames.VehiclesBG
end --func end
--next--
function VehiclesCharacteristicCtrl:Init()
	
	self.panel = UI.VehiclesCharacteristicPanel.Bind(self)
	super.Init(self)

	self.Mgr = MgrMgr:GetMgr("VehicleInfoMgr")
	self.isHaveData = false
	self.vehicleConfig = nil
	self.vehicleDatas = nil
	self.nowSelectID = nil
	self.nowModel = nil
	self.openUseLevel = 0
	--用于标记载具剩余1小时以内显示x分x秒的时候的倒计时使用
	self.NeedRefreshTime = false
	self.nowSelectTimer = -1
	self.updateTimer = nil
	self.currentChooseDyeID = 0

	self.vehiclePool = self:NewTemplatePool({
		UITemplateClass = UITemplate.VehicleCharaItemTemplete,
		ScrollRect = self.panel.HeadScrollView.LoopScroll,
		TemplatePrefab = self.panel.VehicleCharaItem.gameObject
	})
	self.itemPool = self:NewTemplatePool({
		UITemplateClass = UITemplate.ItemTemplate,
		ScrollRect = self.panel.CostPanel.LoopScroll,
	})
	self.dyeCostItemPool = self:NewTemplatePool({
		UITemplateClass = UITemplate.ItemTemplate,
		ScrollRect = self.panel.LoopScroll_CustMadeCost.LoopScroll,
	})
	self.panel.VehicleCharaItem.gameObject:SetActiveEx(false)

    self.panel.Btn_VehicleFeatureTip.Listener:SetActionClick(self.onVehicleFeatureInfoClick,self)

	self.panel.RestBtn:AddClick(function()
		self:OnRest()
	end)
	self.panel.Btn_CustomMade:AddClick(function()
		self.Mgr.SendUseOrnamentDyeMsg(self.nowSelectID,
				VehicleOutlookType.VEHICLE_OUTLOOK_DYE,self.currentChooseDyeID)
	end)
	self.panel.Btn_FetchDye:AddClick(function()
		self:ActiveCurrentVehicleDye()
	end)
	self.panel.Btn_Fetch:AddClick(function()
		self:VehicleBarter()
	end)
	self.panel.EnablingBtn:AddClick(function()
		local l_vehicle = TableUtil.GetVehicleTable().GetRowByID(self.nowSelectID)
		self.Mgr.SendEnableVehicleMsg(l_vehicle.ID, true)
	end)
	self.panel.RestBtn:AddClick(function()
		local l_vehicle = TableUtil.GetVehicleTable().GetRowByID(self.nowSelectID)
		self.Mgr.SendEnableVehicleMsg(l_vehicle.ID, false)
	end)
	self.panel.ToggleEx_ChooseShape:OnToggleExChanged(function(isOn)
		if isOn then
			MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("CHANGE_TO_VEHICLE_UNOPEN"))
			self.panel.ToggleEx_ChooseShape.TogEx.isOn = false
		end
	end,true)

	self.panel.Btn_DyeHelper.Listener.onClick = function(go, ed)
		MgrMgr:GetMgr("TipsMgr").ShowQuestionTip(Lang("VEHICLE_DYE_DESCRIBE"), ed, Vector2(1, 0), false)
	end
	self.panel.ToggleEx_ChooseShape.TogEx.isOn = false
	isOwnType = false
	nowVehicleTable = 0
	self.panel.OnlyWearToggle.Tog.isOn = false
	self.panel.OnlyWearToggle:OnToggleChanged(function(on)
		isOwnType = on
		self.nowSelectID = nil
		self:VehicleRefresh()
	end)
	self:initDyeingPanel()
end --func end
--next--
function VehiclesCharacteristicCtrl:Uninit()

	super.Uninit(self)
	self.Mgr = nil
	self.panel = nil
	self.isHaveData = false
	self.vehicleConfig = nil
	self.vehicleDatas = nil
	self.nowSelectID = nil
	self.openUseLevel = nil
	if self.nowModel then
		self:DestroyUIModel(self.nowModel)
		self.nowModel = nil
	end
	self.vehiclePool = nil
	self.itemPool = nil
	self.dyeCostItemPool = nil
	self.NeedRefreshTime = false
	self.nowSelectTimer = -1
	self:DestoyTimer()
end --func end
--next--
function VehiclesCharacteristicCtrl:OnActive()
	if self.uiPanelData~=nil then
		if self.uiPanelData.defaultChooseVehicleId~=0 then
			self.nowSelectID = self.uiPanelData.defaultChooseVehicleId
		end
	end
	if not self.isHaveData then
		self.isHaveData = true
		self:InitVehicleData()
	end
	self:VehicleRefresh()
end --func end
--next--
function VehiclesCharacteristicCtrl:OnDeActive()
	self:DestoyTimer()
	self.dyeingColorPool = nil
end --func end
--next--
function VehiclesCharacteristicCtrl:Update()
	if self.NeedRefreshTime and self.nowSelectTimer ~= -1 then
		local l_deltaTime = self.nowSelectTimer - Common.TimeMgr.GetNowTimestamp()
		if l_deltaTime > 0 then
			local l_time = Common.TimeMgr.GetCountDownDayTimeTable(l_deltaTime)
			self.panel.SurplusTime.LabText = string.format(
					"%s：%d%s%d%s", Lang("VALIDITY_TIME"), l_time.min, Lang("MINUTE"), l_time.sec, Lang("TIME_SECOND"))
		else
			self.NeedRefreshTime = false
			self.nowSelectTimer = -1
			self.panel.SurplusTime:SetActiveEx(false)
			self:DestoyTimer()
		end
	end
	
end --func end
--next--
function VehiclesCharacteristicCtrl:BindEvents()
	self:BindEvent(self.Mgr.EventDispatcher, self.Mgr.EventType.VehicleUseStateChange, self.OutEventVehicleEnable)
	self:BindEvent(self.Mgr.EventDispatcher, self.Mgr.EventType.ExchangeSpecialVehicle, self.VehicleRefresh)
	self:BindEvent(self.Mgr.EventDispatcher, self.Mgr.EventType.UseOrnamentDyeSuc, self.VehicleRefresh)
	self:BindEvent(self.Mgr.EventDispatcher, self.Mgr.EventType.AddOrnamentDyeSuc, self.onAddOrnamentDyeSuc)
	self:BindEvent(self.Mgr.EventDispatcher, self.Mgr.EventType.UpdateVehiclePanelChooseVehicle, self.updateChooseVehicle)
end --func end
--next--
--lua functions end

--lua custom scripts
function VehiclesCharacteristicCtrl:OnShow()
	self.panel.Obj_StartAnim:PlayDynamicEffect()
end

function VehiclesCharacteristicCtrl:initDyeingPanel()
	self.dyeingColorPool = self:NewTemplatePool({
		TemplateClassName = "ColorChooseTemplate",
		TemplateParent = self.panel.Panel_DyeingColors.Transform,
		TemplatePrefab = self.panel.Template_ColorChoose.gameObject,
		Method = function(dyeId)
			self:changeChooseDyeId(dyeId)
		end,
	})

end
function VehiclesCharacteristicCtrl:changeChooseDyeId(dyeId)
	self.currentChooseDyeID = dyeId
	self:RefreshModel(self.nowSelectID,dyeId)
	self:refreshDyeCostInfo(dyeId)
end

--更新当前颜色信息
function VehiclesCharacteristicCtrl:refreshDyeCostInfo(dyeId)
	local l_hasDyeID = self:hasDyeID(self.nowSelectID,dyeId)
	self.panel.Btn_FetchDye:SetActiveEx(not l_hasDyeID)
	self.panel.Btn_CustomMade:SetActiveEx(l_hasDyeID and (not self:IsUsingDyeID(self.nowSelectID,dyeId)))
	self.panel.Panel_CustomMadeCost:SetActiveEx(not l_hasDyeID)
	if l_hasDyeID then
		return
	end
	local l_colorItem = TableUtil.GetVehicleColorationTable().GetRowByColorationID(dyeId,true)
	if not l_colorItem then
		logError(StringEx.Format("找不到数据@周阳:{0}", dyeId))
		return
	end
	local l_costDatas = {}
	local l_costs = Common.Functions.VectorSequenceToTable(l_colorItem.ItemCost)
	for i, v in ipairs(l_costs) do
		local l_count = Data.BagModel:GetCoinOrPropNumById(v[1])
		table.insert(l_costDatas, { ID = v[1], Count = l_count, IsShowRequire = true,
									RequireCount = v[2], IsShowCount = false, })
	end

	self.dyeCostItemPool:ShowTemplates({ Datas = l_costDatas })
end

--判断当前染色是否已启用
function VehiclesCharacteristicCtrl:IsUsingDyeID(vehicleID, dyeID)
	local l_permentVehicleData = self.Mgr.GetPermentVehicleData(vehicleID)
	if l_permentVehicleData==nil then
		return false
	end
	local l_colorData = l_permentVehicleData.dyeIds
	return l_colorData.cur_equip == dyeID
end
--判断当前染色是否激活
function VehiclesCharacteristicCtrl:hasDyeID(vehicleID, colorID)
	--如果是默认染色
	if colorID == 0 then
		return true
	end
	local l_permanentVehicleData = self.Mgr.GetPermentVehicleData(vehicleID)
	if l_permanentVehicleData==nil then
		return false
	end
	local l_colorData = l_permanentVehicleData.dyeIds
	for i, v in ipairs(l_colorData) do
		if v == colorID then
			return true
		end
	end
	return false
end
function VehiclesCharacteristicCtrl:refreshDyeingChoosePanel(isPermment,colorIds)
	local l_showColorChoosePanel = isPermment and self.dyeingColorPool~=nil and colorIds~=nil and #colorIds>0
	self.panel.Panel_ChooseDyeing:SetActiveEx(l_showColorChoosePanel)
	self.panel.Panel_CustomMadeCost:SetActiveEx(l_showColorChoosePanel)
	if not l_showColorChoosePanel then
		return
	end

	---@type colorChooseData[]
	local l_dyeingColorDatas = {}
	self:insertDyeingColorData(l_dyeingColorDatas,0)
	for _,v in pairs(colorIds) do
		self:insertDyeingColorData(l_dyeingColorDatas,v)
	end
	table.sort(l_dyeingColorDatas,function(a,b)
		if not a.isLock and b.isLock then
			return true
		end
		return false
	end)
	self.dyeingColorPool:ShowTemplates({ Datas = l_dyeingColorDatas })
end
function VehiclesCharacteristicCtrl:insertDyeingColorData(datas,dyeId)
	local l_isLock = not self:hasDyeID(self.nowSelectID,dyeId)
	local l_dyeData = {
		dyeId = dyeId,
		isChoosing = self.currentChooseDyeID == dyeId,
		isLock = l_isLock,
	}
	table.insert(datas,l_dyeData)
end

--判断当前载具是否已经拥有且时限为永久
function VehiclesCharacteristicCtrl:IsOwnPermanentByVehicleID(vehicleID)
	return (self.Mgr.GetProfessionVehicleId() ~= vehicleID and self.Mgr.IsPermentVehicle(vehicleID)) or
			(self.Mgr.GetProfessionVehicleId() == vehicleID and self.Mgr.HasProfessionVehicle())
end

--判断当前载具是否已经拥有
function VehiclesCharacteristicCtrl:hasVehicle(vehicleID)
	return self.Mgr.GetTempVehicleDeadLine(vehicleID) ~= nil
			or self:IsOwnPermanentByVehicleID(vehicleID)
end
--判断当前载具是否在使用
function VehiclesCharacteristicCtrl:IsUse(data)
	return self.Mgr.GetUseingVehicle() == data.ID
end

--玩家选中当前ID载具
function VehiclesCharacteristicCtrl:VehicleSelect(id, index)

	if (selectClick == index) then
		return
	end
	local l_lastSelectItem = self.vehiclePool:GetItem(selectClick)
	if l_lastSelectItem then
		l_lastSelectItem:ShowFrame(false)
	end
	selectClick = index
	self.nowSelectID = id

	local l_permentVehicleData = self.Mgr.GetPermentVehicleData(self.nowSelectID)
	if l_permentVehicleData~= nil then
		self.currentChooseDyeID = l_permentVehicleData.dyeIds.cur_equip
	else
		self.currentChooseDyeID = 0
	end

	l_lastSelectItem = self.vehiclePool:GetItem(selectClick)
	if l_lastSelectItem then
		l_lastSelectItem:ShowFrame(true)
	end
	self:RefreshInfomation(true)
	self:refreshDyeCostInfo(self.currentChooseDyeID)
end

--展示载具
function VehiclesCharacteristicCtrl:VehicleRefresh()

	for i, data in ipairs(self.vehicleDatas) do
		data.isOwnF = self:IsOwnPermanentByVehicleID(data.ID)
		data.isOwnT = self:hasVehicle(data.ID)
		data.isUse = self:IsUse(data)
		data.isSelect = false
	end

	local l_index, l_select = 0, 0
	local l_displayDatas = {}
	for i, data in ipairs(self.vehicleDatas) do
		if ((nowVehicleTable == 0 or data.type == nowVehicleTable) and (not isOwnType or data.isOwnF or data.isOwnT)) then
			l_index = l_index + 1
			if not self.nowSelectID then
				self.nowSelectID = data.ID
				local l_permentVehicleData = self.Mgr.GetPermentVehicleData(self.nowSelectID)
				if l_permentVehicleData~= nil then
					self.currentChooseDyeID = l_permentVehicleData.dyeIds.cur_equip
				else
					self.currentChooseDyeID = 0
				end
			end
			if self.nowSelectID == data.ID then
				l_select = l_index
				data.isSelect = true
			end
			table.insert(l_displayDatas, data)
		end
	end

	selectClick = l_select
	self.vehiclePool:ShowTemplates({ Datas = l_displayDatas,
									 StartScrollIndex = l_select,
									 Method = function(id, index)
										 self:VehicleSelect(id, index)
									 end })
	local l_hasDisplayData = #l_displayDatas>0
	self.panel.Image_VehicleHeadBg:SetActiveEx(l_hasDisplayData)
	self.panel.PanelNoItem:SetActiveEx(not l_hasDisplayData)
	self.panel.Panel_Right:SetActiveEx(l_hasDisplayData)
	self:RefreshInfomation(true)
	self:refreshDyeCostInfo(self.currentChooseDyeID)
end
function VehiclesCharacteristicCtrl:onAddOrnamentDyeSuc()
	self:refreshDyeCostInfo(self.currentChooseDyeID)
	self:RefreshInfomation(true)
end
function VehiclesCharacteristicCtrl:updateChooseVehicle(vehicleId)
	if vehicleId==nil or vehicleId == 0 then
		return
	end
	self.nowSelectID = vehicleId
	self:VehicleRefresh()
end
function VehiclesCharacteristicCtrl:ChooseEquipDyeId()
	local l_permentVehicleData = self.Mgr.GetPermentVehicleData(self.nowSelectID)
	if l_permentVehicleData~= nil then
		self.currentChooseDyeID = l_permentVehicleData.dyeIds.cur_equip
	else
		self.currentChooseDyeID = 0
	end
end
--刷新载具词条
function VehiclesCharacteristicCtrl:VehicleDisplayData(type1, type2, type3, discribe, attrTable)

	self.panel.LandImage:SetActiveEx(type1 == 2)
	self.panel.SkyImage:SetActiveEx(type1 == 1)
	self.panel.SingleImage:SetActiveEx(type2 == 1)
	self.panel.DoubleImage:SetActiveEx(type2 == 2)

    if type3==0 then
        type3 = 120
    end
    self.panel.Txt_Percentage.LabText = string.format("%s%%",type3)

    if not discribe then
		self.panel.DescribeTxt.LabText = ""
	else
		self.panel.DescribeTxt.LabText = discribe
	end
	if not attrTable then
		self.panel.AttrTpl1:SetActiveEx(false)
		self.panel.AttrTpl2:SetActiveEx(false)
		self.panel.AttrTpl3:SetActiveEx(false)
	else
		local l_texts = {}
		for i = 1, #attrTable do
			local l_text = MgrMgr:GetMgr("EquipMgr").GetAttrStrByData(attrTable[i])
			local l_xLoc = string.find(l_text, "+")
			local l_attrName, l_attrVal = string.sub(l_text, 1, l_xLoc - 1), string.sub(l_text, l_xLoc)
			local l_xTable = { attrName = l_attrName, attrVal = l_attrVal }
			table.insert(l_texts, l_xTable)
		end
		if l_texts[1] then
			self.panel.AttrTpl1:SetActiveEx(true)
			self.panel.AttrName1.LabText = l_texts[1].attrName
			self.panel.AttrNum1.LabText = l_texts[1].attrVal
		else
			self.panel.AttrTpl1:SetActiveEx(false)
		end
		if l_texts[2] then
			self.panel.AttrTpl2:SetActiveEx(true)
			self.panel.AttrName2.LabText = l_texts[2].attrName
			self.panel.AttrNum2.LabText = l_texts[2].attrVal
		else
			self.panel.AttrTpl2:SetActiveEx(false)
		end
		if l_texts[3] then
			self.panel.AttrTpl3:SetActiveEx(true)
			self.panel.AttrName3.LabText = l_texts[3].attrName
			self.panel.AttrNum3.LabText = l_texts[3].attrVal
		else
			self.panel.AttrTpl3:SetActiveEx(false)
		end
	end

end

--模型展示
---@param dyeId number 指定染色id则优先使用指定值
function VehiclesCharacteristicCtrl:RefreshModel(vehicleID,dyeId)

	if self.nowModel then
		self:DestroyUIModel(self.nowModel)
		self.nowModel = nil
	end

	local l_access, l_color = self.Mgr.GetEquipOrnamentAndDyeId(vehicleID)
	if dyeId~=nil then
		l_color = dyeId
	end
	self.nowModel = self.Mgr.CreateModel(vehicleID, l_access, l_color,
			self.panel.ModelImage, self.panel.Img_TouchArea,nil,nil,nil,true,true)
	self:SaveModelData(self.nowModel)
end

--刷新展示面板
function VehiclesCharacteristicCtrl:RefreshInfomation(isNeedRefreshModel)
	self:DestoyTimer()
	self.panel.EnablingBtn:SetActiveEx(false)
	self.panel.RestBtn:SetActiveEx(false)
	self.panel.BarterPanel:SetActiveEx(false)
	self.panel.ShopPanel:SetActiveEx(false)
	self.panel.LevelIgnore:SetActiveEx(false)
	if not self.nowSelectID then
		self:VehicleDisplayData(0, 0, 0, nil, nil)
		if self.nowModel then
			self:DestroyUIModel(self.nowModel)
			self.nowModel = nil
		end
		self.panel.VehicleName.LabText = ""
		return
	end

	local l_vehicle = TableUtil.GetVehicleTable().GetRowByID(self.nowSelectID)
	if not l_vehicle then
		logError(StringEx.Format("找不到数据：@周阳", self.nowSelectID))
		return
	end

	local l_colorId = Common.Functions.VectorToTable(l_vehicle.ColourationId)
	self:refreshDyeingChoosePanel(self:IsOwnPermanentByVehicleID(self.nowSelectID),l_colorId)
	local l_speedPercentage = self.Mgr.GetVehicleSpeedPercent(l_vehicle.HorizontalSpeed)
    local l_attrTable = MgrMgr:GetMgr("ItemPropertiesMgr").GetAttrsWithTableData(l_vehicle.ActivationAttr)
	self:VehicleDisplayData(l_vehicle.VehicleType, l_vehicle.Num, l_speedPercentage, l_vehicle.Tips, l_attrTable)
	self.panel.VehicleName.LabText = l_vehicle.Name
	if isNeedRefreshModel then
		self:RefreshModel(l_vehicle.ID,self.currentChooseDyeID)
	end

	local l_isOwn = self:hasVehicle(self.nowSelectID)
	self.panel.Panel_CustomMade:SetActiveEx(l_isOwn)
	self.panel.Panel_DetailInfo:SetActiveEx(not l_isOwn)
	if l_isOwn then
		if self:IsUse(l_vehicle) then
			self.panel.RestBtn:SetActiveEx(true)
		else
			self.panel.EnablingBtn:SetActiveEx(true)
		end
	else
		if not l_vehicle.ItemCost then
			self.panel.ShopPanel:SetActiveEx(true)
		else
			self.panel.BarterPanel:SetActiveEx(true)
			local l_costDatas = {}
			local l_costs = Common.Functions.VectorSequenceToTable(l_vehicle.ItemCost)
			for i, v in ipairs(l_costs) do
				local l_count = Data.BagModel:GetCoinOrPropNumById(v[1])
				table.insert(l_costDatas, { ID = v[1], Count = l_count, IsShowRequire = true,
											RequireCount = v[2], IsShowCount = false })
			end

			self.itemPool:ShowTemplates({ Datas = l_costDatas })
		end
	end

	--时限载具显示剩余期限
	self.panel.SurplusTime:SetActiveEx(false)
	local l_surplus = self.Mgr.GetTempVehicleDeadLine(l_vehicle.ID)
	if l_surplus then
		local l_deltaTime = l_surplus - Common.TimeMgr.GetNowTimestamp()
		local l_time = Common.TimeMgr.GetCountDownDayTimeTable(l_deltaTime)
		if l_time.day == 0 then
			if l_time.hour == 0 then
				self.panel.SurplusTime.LabText = string.format(
						"%s：%d%s%d%s", Lang("VALIDITY_TIME"), l_time.min, Lang("MINUTE"), l_time.sec, Lang("TIME_SECOND"))
				self.NeedRefreshTime = true
				self.nowSelectTimer = l_surplus
				self.updateTimer = self:NewUITimer(function()
					self:Update()
				end, 1, -1, true)
				self.updateTimer:Start()
			else
				self.panel.SurplusTime.LabText = string.format(
						"%s：%d%s", Lang("VALIDITY_TIME"), l_time.hour, Lang("HOURS"))
				self.NeedRefreshTime = false
				self.nowSelectTimer = -1
			end
		else
			self.panel.SurplusTime.LabText = string.format(
					"%s：%d%s", Lang("VALIDITY_TIME"), l_time.day, Lang("DAY"))
			self.NeedRefreshTime = false
			self.nowSelectTimer = -1
		end
		self.panel.SurplusTime:SetActiveEx(true)
	end

	--职业载具等级限制
	local l_curLevel = self.Mgr.GetVehicleLevelAndExp()
	if l_curLevel < self.openUseLevel and self.Mgr.GetProfessionVehicleId() == l_vehicle.ID then
		self.panel.EnablingBtn:SetActiveEx(false)
		self.panel.LevelIgnore:SetActiveEx(true)
		self.panel.BarterPanel:SetActiveEx(false)
		return
	end

end

--载具合成申请
function VehiclesCharacteristicCtrl:VehicleBarter()

	local l_vehicle = TableUtil.GetVehicleTable().GetRowByID(self.nowSelectID)
	if l_vehicle ~= nil then
		local itemId = l_vehicle.ID
		if Common.CommonUIFunc.isItemHaveExport(itemId) then
			UIMgr:ActiveUI(UI.CtrlNames.ItemAchieveTipsNew, function(ui)
				ui:InitItemAchievePanelByItemId(itemId)
			end)
		else
			MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("NONE_EXPORT_PATH"))
		end
	end

end
--激活颜料
function VehiclesCharacteristicCtrl:ActiveCurrentVehicleDye()
	if not self.nowSelectID then
		return
	end

	if self.currentChooseDyeID == 0 then
		return
	end

	--如果材料不足
	local l_needRes, l_needItem = self:IsEnoughResources(self.currentChooseDyeID)
	if not l_needRes then
		local itemData = Data.BagModel:CreateItemWithTid(l_needItem)
		MgrMgr:GetMgr("ItemTipsMgr").ShowTipsDisplay(itemData, self.panel.Btn_FetchDye.Transform, nil, nil, true, { relativePositionY = 28 })
		return
	end

	local l_row = TableUtil.GetVehicleColorationTable().GetRowByColorationID(self.currentChooseDyeID)
	if not l_row then
		logError(StringEx.Format("配饰配置不存在@周阳{0}", self.currentChooseDyeID))
		return
	end

	self.Mgr.SendAddOrnamentDyeMsg(self.nowSelectID,
			VehicleOutlookType.VEHICLE_OUTLOOK_DYE, self.currentChooseDyeID)
end
--判断当前颜料是否拥有足够的材料合成
function VehiclesCharacteristicCtrl:IsEnoughResources(id)
	local l_color = TableUtil.GetVehicleColorationTable().GetRowByColorationID(id)
	if not l_color then
		logError(StringEx.Format("找不到数据@周阳", id))
		return
	end

	local l_costs = Common.Functions.VectorSequenceToTable(l_color.ItemCost)
	for i, v in ipairs(l_costs) do
		local l_count = Data.BagModel:GetCoinOrPropNumById(v[1])
		if l_count < v[2] then
			return false, v[1], v[2] - l_count
		end
	end

	return true
end
--读取载具信息
function VehiclesCharacteristicCtrl:InitVehicleData()

	local l_vehicle = TableUtil.GetVehicleTable().GetTable()
	if #l_vehicle <= 0 then
		logError(StringEx.Format("VehicleTable找不到数据：@周阳"))
		return
	end

	local l_row = TableUtil.GetGlobalTable().GetRowByName("VehicleUseLv")
	if l_row ~= nil then
		self.openUseLevel = tonumber(l_row.Value)
	end

	self.vehicleDatas = {}
	self.vehicleConfig = l_vehicle
	for i, v in ipairs(self.vehicleConfig) do
		local l_vehicleItem = TableUtil.GetItemTable().GetRowByItemID(v.ID)
		if not MLuaCommonHelper.IsNull(l_vehicleItem) then
			if v.Type[0] == 2 and v.TimeId[0] == 1 then
				local l_data = { ID = v.ID, type = v.VehicleType, proType = v.Type[0],quality = l_vehicleItem.ItemQuality }
				table.insert(self.vehicleDatas, l_data)
			end
		end
	end

	table.sort(self.vehicleDatas, function(m, n)
		local l_isOwnVehicleM = self:hasVehicle(m.ID)
		local l_isOwnVehicleN = self:hasVehicle(n.ID)
		if l_isOwnVehicleM and (not l_isOwnVehicleN) then
			return true
		elseif l_isOwnVehicleM  == l_isOwnVehicleN then
			if m.proType < n.proType then
				return true
			end
			if m.proType == n.proType then
				return m.ID < n.ID
			end
			return false
		end
	end)
end

--装备/卸下载具事件
function VehiclesCharacteristicCtrl:OutEventVehicleEnable()

	for i, data in ipairs(self.vehicleDatas) do
		if data.isUse == not self:IsUse(data) then
			data.isUse = self:IsUse(data)
			for k, v in pairs(self.vehiclePool.Items) do
				if v.data.ID == data.ID then
					v.data.isUse = data.isUse
					if data.isUse == true then
						MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("VEHICLE_UP"))
					end
					v:CheckState()
				end
			end
		end
	end
	self:RefreshInfomation(false)

end

function VehiclesCharacteristicCtrl:DestoyTimer()
	if self.updateTimer then
		self:StopUITimer(self.updateTimer)
		self.updateTimer = nil
	end
end

function VehiclesCharacteristicCtrl:onVehicleFeatureInfoClick(go,ed)
    local l_vehicleItem = TableUtil.GetVehicleTable().GetRowByID(self.nowSelectID)
    if MLuaCommonHelper.IsNull(l_vehicleItem) then
        return
    end
    local l_tipPivot = Vector2(0.5,0)
    local l_vehicleTypeStr = nil
    if l_vehicleItem.VehicleType==1 then
        l_vehicleTypeStr = Lang("VEHICLE_FLY")
    else
        l_vehicleTypeStr = Lang("VEHICLE_LAND")
    end
    local l_vehicleNumStr = nil
    if l_vehicleItem.Num==1 then
        l_vehicleNumStr = Lang("SINGLE_PEOPLE")
    else
        l_vehicleNumStr = Lang("MULTI_PEOPLE")
    end
    local l_vehicleSpeedPercent = self.Mgr.GetVehicleSpeedPercent(l_vehicleItem.HorizontalSpeed)
    MgrMgr:GetMgr("TipsMgr").ShowQuestionTip(Lang("VEHICLE_FEATURE_TIPS",l_vehicleTypeStr,l_vehicleNumStr,l_vehicleSpeedPercent),
            ed, l_tipPivot, false)
end
--lua custom scripts end
return VehiclesCharacteristicCtrl