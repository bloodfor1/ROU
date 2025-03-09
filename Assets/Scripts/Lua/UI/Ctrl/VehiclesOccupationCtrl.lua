--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/VehiclesOccupationPanel"
require "UI/Template/QualityExtraAttrTemplate"
--lua requires end

--lua model
module("UI", package.seeall)

--lua model end

--lua fields
local super = UI.UIBaseCtrl
local LEVEL_UP_FX = "Effects/Prefabs/Creature/Ui/Fx_Ui_ZaiJu_ZaiJuShengJi_01"
--lua fields end

--lua class define
---@class VehiclesOccupationCtrl : UIBaseCtrl
VehiclesOccupationCtrl = class("VehiclesOccupationCtrl", super)
--lua class define end

--lua functions
function VehiclesOccupationCtrl:ctor()
	
	super.ctor(self, CtrlNames.VehiclesOccupation, UILayer.Function, nil, ActiveType.Exclusive)
	self.InsertPanelName = UI.CtrlNames.VehiclesBG
end --func end
--next--
function VehiclesOccupationCtrl:Init()
	
	self.panel = UI.VehiclesOccupationPanel.Bind(self)
	super.Init(self)

	self.eventSystem = nil
	self.pointEventData = nil

	self.effect = nil
	self.abilityAttrTemplates = {}
	self.abilityStageUpTemplates = {}
	self.cultureAttTemplates = {}
	self.stageUpItemTemplates = {}
	self.models = {}
	self.initInfoTable = { false, false }
	self.Mgr = MgrMgr:GetMgr("VehicleInfoMgr")
	self.ShowUseVehicleRedHint = false
	self.openUseLevel = 0
	self.superQualityItem = nil
	self.currentChooseProVehicleStage = self.Mgr.GetVehicleStage()
	local l_row = TableUtil.GetGlobalTable().GetRowByName("VehicleUseLv")
	if l_row ~= nil then
		self.openUseLevel = tonumber(l_row.Value)
	end
	self.openSysMgr = MgrMgr:GetMgr("OpenSystemMgr")
	self.panel.BtnHelp.Listener.onClick = function(go, ed)
		MgrMgr:GetMgr("TipsMgr").ShowQuestionTip(Lang("VEHICLE_OCC_DESCRIBE"), ed, Vector2(1, 1), false)
	end
	self.unLockFuncIds = {}
	self.panel.Btn_LastVehicle:AddClick(function()
		self.currentChooseProVehicleStage = self.currentChooseProVehicleStage - 1
		self:RefreshAbilityBaseInfoPanel()
	end, true)
	self.panel.Btn_CloseQualityPropInfo:AddClick(function()
		self.panel.Panel_QualityPropInfo:SetActiveEx(false)
	end,true)
	self.panel.Btn_NextVehicle:AddClick(function()
		if self.currentChooseProVehicleStage>=self.Mgr.GetProVehicleMaxStage() then
			return
		end
		self.currentChooseProVehicleStage = self.currentChooseProVehicleStage + 1
		self:RefreshAbilityBaseInfoPanel()
	end, true)


	--todo 解锁功能移植
	--self:UpdateFuncState(self.panel.Toggle_Quality, self.openSysMgr.eSystemId.VehicleQuality)

	--self.lastShowTogEx = self.panel.Toggle_Ability.TogEx
	--self.panel.Toggle_Ability.TogEx.isOn = true
end --func end
--next--
function VehiclesOccupationCtrl:Uninit()

	super.Uninit(self)
	self.panel = nil

	if self.effect ~= nil then
		self:DestroyUIEffect(self.effect)
		self.effect = nil
	end
	
end --func end
--next--
function VehiclesOccupationCtrl:OnActive()
	local l_showAblityPanel = true
	local l_showVehicleStageUpPanel = false
	if self.uiPanelData~=nil then
		l_showAblityPanel = self.uiPanelData.showAbilityPanel
		l_showVehicleStageUpPanel = self.uiPanelData.showStageUpPanel
	end
	self:onShowPanelInfoChanged(l_showAblityPanel,l_showVehicleStageUpPanel)
end --func end
--next--
function VehiclesOccupationCtrl:OnDeActive()
	self.cultureConsumeItemPool = nil
	self.abilityAttrTemplates = {}
	self.abilityStageUpTemplates = {}
	self.cultureAttTemplates = {}
	self.eventSystem = nil
	self.pointEventData = nil
	self.qualityExtraAddAttrPool = nil
	self.superQualityItem = nil
	self:ClearModel()
	
end --func end
--next--
function VehiclesOccupationCtrl:Update()
	
	
end --func end
--next--
function VehiclesOccupationCtrl:BindEvents()
	self:BindEvent(self.Mgr.EventDispatcher, self.Mgr.EventType.VehicleUseStateChange, self.RefreshAbilityUseState)
	self:BindEvent(self.Mgr.EventDispatcher, self.Mgr.EventType.VehicleUpgrade, self.OnUpgradeVehicleSuc)
	self:BindEvent(self.Mgr.EventDispatcher, self.Mgr.EventType.VehicleUpgradeLimit, self.OnVehicleUpgradeLimitSuc)
	self:BindEvent(self.Mgr.EventDispatcher, self.Mgr.EventType.DevelopVehicleQualitySuc, self.OnDevelopVehicleQuality)
	self:BindEvent(self.Mgr.EventDispatcher, self.Mgr.EventType.ConfirmVehicleQuality, self.OnConfirmVehicleQuality)
	self:BindEvent(self.Mgr.EventDispatcher, self.Mgr.EventType.VEHICLE_LEVEL_UP, self.OnVehicleLevelUp)
	self:BindEvent(GlobalEventBus, EventConst.Names.OnTaskFinishNotify, self.OnTaskStateChanged)
	self:BindEvent(self.Mgr.EventDispatcher, self.Mgr.EventType.ChangeProVehiclePanelInfo, self.onShowPanelInfoChanged)
	self:BindEvent(self.Mgr.EventDispatcher, self.Mgr.EventType.VehicleUpgradeLimit, self.refreshSuperPropUseNum)
	local gameEventMgr = MgrMgr:GetMgr("GameEventMgr")
	self:BindEvent(gameEventMgr.l_eventDispatcher, gameEventMgr.OnBagUpdate, self.refreshSuperPropUseNum,self)
	self:BindEvent(self.Mgr.EventDispatcher, self.Mgr.EventType.ShowVehicleAbilityAttrInfo, self.ShowAttrTips)

end --func end
--next--
--lua functions end

--lua custom scripts
function VehiclesOccupationCtrl:ShowLockTips(funcId)
	local l_isLock = false
	if table.ro_contains(self.unLockFuncIds, funcId) then
		local l_openSysItem = TableUtil.GetOpenSystemTable().GetRowById(funcId)
		if not MLuaCommonHelper.IsNull(l_openSysItem) then
			MgrMgr:GetMgr("TipsMgr").ShowNormalTips(string.format(Lang("FUNC_OPEN_CONDITION"), l_openSysItem.BaseLevel, l_openSysItem.Title))
			if self.lastShowTogEx ~= nil then
				self.lastShowTogEx.isOn = true
			end
			l_isLock = true
		end
	end
	return l_isLock
end

function VehiclesOccupationCtrl:UpdateFuncState(uiCom, funcId)
	if not self.openSysMgr.IsSystemOpen(funcId) then
		if self.Mgr.CanShowVehicleFunc(funcId) then
			table.insert(self.unLockFuncIds, funcId)
			local l_bgImg = uiCom.Transform:Find("OFF/Img_Bg")
			if not MLuaCommonHelper.IsNull(l_bgImg) then
				l_bgImg:GetComponent("MLuaUICom"):SetGray(true)
			end
			local l_lockImg = uiCom.Transform:Find("OFF/Img_Lock")
			if not MLuaCommonHelper.IsNull(l_lockImg) then
				l_lockImg.gameObject:SetActiveEx(true)
			end
			uiCom:SetActiveEx(true)
		end
	else
		uiCom:SetActiveEx(true)
	end
end

function VehiclesOccupationCtrl:OnTaskStateChanged(taskId)
	local l_row = TableUtil.GetGlobalTable().GetRowByName("VehicleTaskId")
	if not MLuaCommonHelper.IsNull(l_row) then
		local l_vehicleTaskId = tonumber(l_row.Value)
		if l_vehicleTaskId == taskId then
			self.Mgr.OnGetProfessionVehicle()
			self:RefreshAbilityUseState()
			self:RefreshAbilityAttrInfoPanel()
		end
	end
end

function VehiclesOccupationCtrl:onShowPanelInfoChanged(showAbilityPanel,showStageUpPanel)
	local l_showAbilityPanel = showAbilityPanel
	--品质面板未解锁则仍显示能力面板
	if not showAbilityPanel then
		if self:ShowLockTips(self.openSysMgr.eSystemId.VehicleQuality) then
			l_showAbilityPanel = true
		end
	end
	if not showAbilityPanel and showStageUpPanel then
		self.panel.Panel_Advancedtips:SetActiveEx(true)
		self:RefreshStageUpPanel()
	end
	if self:checkPanelShowState(showAbilityPanel) then
		return
	end
	self.panel.Panel_Quality:SetActiveEx(not l_showAbilityPanel)
	self.panel.Panel_Ability:SetActiveEx(l_showAbilityPanel)

	if showAbilityPanel then
		self:InitAbilityPanel()
		self.panel.Obj_StartAbilityAnim:PlayDynamicEffect()
	else
		self:InitQualityPanel()
		self.panel.Obj_StartQualityAnim:PlayDynamicEffect()
	end
end

function VehiclesOccupationCtrl:checkPanelShowState(isAbilityPanel)
	if self.currentShowAbilityInfo then
		return self.currentShowAbilityInfo==isAbilityPanel
	end
	return false
end

--region---------------------------------ability panel---------------------------------
function VehiclesOccupationCtrl:UpdateInput(touchItem)
	super:UpdateInput(touchItem)
	self.clickPos = touchItem.Position
end
function VehiclesOccupationCtrl:ShowAttrTips(vehicleQualityId)
	local l_vqrItem = TableUtil.GetVehicleQualityTable().GetRowById(vehicleQualityId)
	if MLuaCommonHelper.IsNull(l_vqrItem) then
		return
	end
	MgrMgr:GetMgr("TipsMgr").ShowQuestionTip(l_vqrItem.AttrTips, self:GetCurrentPointEventData(), Vector2(0.5, 0), false, nil, MUIManager.UICamera, true)
end
function VehiclesOccupationCtrl:GetCurrentPointEventData()
	if self.eventSystem == nil or self.pointEventData == nil then
		self.eventSystem = EventSystem.current
		self.pointEventData = PointerEventData.New(l_eventSystem)
	end
	self.pointEventData.position = self.clickPos
	return self.pointEventData
end
function VehiclesOccupationCtrl:InitAbilityPanel()
	if self.initInfoTable[1] then
		self:RefreshAbilityPanel()
		return
	end
	self.initInfoTable[1] = true
	self.panel.Btn_Rest:AddClick(function()
		local l_professionVehicleId = self.Mgr.GetProfessionVehicleId()
		self.Mgr.SendEnableVehicleMsg(l_professionVehicleId, false)
	end, true)
	self.panel.Btn_Enabling:AddClick(function()
		local l_curLevel, _ = self.Mgr.GetVehicleLevelAndExp()
		if l_curLevel < self.openUseLevel then
			MgrMgr:GetMgr("TipsMgr").ShowNormalTips(string.format(Lang("USE_VEHICLE_CONDITION"), self.openUseLevel))
			return
		end

		if self.ShowUseVehicleRedHint == true then
			local l_key = "firstUseProVehicle"
			UserDataManager.SetDataFromLua(l_key, MPlayerSetting.PLAYER_SETTING_GROUP, "1")
			self:RefreshProVehicleEnableRedHint()
		end

		local l_professionVehicleId = self.Mgr.GetProfessionVehicleId()
		self.Mgr.SendEnableVehicleMsg(l_professionVehicleId, true)
	end, true)

    self.panel.Btn_VehicleInfo.Listener:SetActionClick(self.onVehicleFeatureClick,self)

	self.panel.Btn_Goto:AddClick(function()
		local l_taskMgr = MgrMgr:GetMgr("TaskMgr")
		local l_row = TableUtil.GetGlobalTable().GetRowByName("VehicleTaskId")
		if not MLuaCommonHelper.IsNull(l_row) then
			local l_taskId = tonumber(l_row.Value)
			if l_taskMgr.CheckTaskTaked(l_taskId) then
				l_taskMgr.OnQuickTaskClickWithTaskId(l_taskId)
			else
				l_taskMgr.NavToTaskAcceptNpc(tonumber(l_row.Value))
			end
		end
		UIMgr:DeActiveUI(CtrlNames.VehiclesBG)
	end, true)

	self.panel.Btn_GotoStage:AddClick(function()
		self.Mgr.EventDispatcher:Dispatch(self.Mgr.EventType.ShowVehicleStagePanel)
	end, true)

	self.panel.Btn_LvUp:AddClick(function()
		local l_proLevelLimit, l_nextLimitNeedRoleLevel = self.Mgr.GetProVehicleLvLimit()
		local l_curLevel, _ = self.Mgr.GetVehicleLevelAndExp()
		local l_isCurrentMaxVehicleLv = l_curLevel >= l_proLevelLimit
		if l_isCurrentMaxVehicleLv then
			if l_nextLimitNeedRoleLevel>0 then
				MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("VEHICLE_LVUP_NEED_ROLELEVEL",l_nextLimitNeedRoleLevel))
			else
				MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("MAX_VEHICLE_LEVEL"))
			end
			return
		end
		self:SetPassThroughFunc(true, self.panel.Btn_CloseLvUp.UObj, false, nil, true)
		self.panel.Panel_LvUptips:SetActiveEx(true)
		self:RefreshLvUpPanel()
	end, true)

	self.panel.Btn_Advanced:AddClick(function()
		local l_stageUpLimitLevel = self.Mgr.GetVehicleStageUpLimitLevel()
		if l_stageUpLimitLevel<0 then
			MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("MAX_ VEHICLE_STAGE_TIP"))
			return
		end
		self.panel.Panel_Advancedtips:SetActiveEx(true)
		self:RefreshStageUpPanel()
	end, true)

	self.panel.Btn_StageUp:AddClick(function()
		self.Mgr.SendUpgradeVehicleLimitMsg()
	end, true)

	self.panel.Btn_CloseUpgradeStage:AddClick(function()
		self.panel.Panel_Advancedtips:SetActiveEx(false)
	end, true)

	self.panel.Btn_CloseLvUp:AddClick(function()
		self.panel.Panel_LvUptips:SetActiveEx(false)
		self:SetPassThroughFunc(true, self.panel.Btn_CloseLvUp.UObj, true, 1, true)
	end, true)

	self.panel.Btn_UseQualityProp:AddClick(function()
		local l_propCount = Data.BagModel:GetCoinOrPropNumById(self.superAddQualityPropId)
		if l_propCount<1 then
			MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("ITEM_NOT_ENOUGH"))
			MgrMgr:GetMgr("ItemTipsMgr").ShowTipsDisplayWithId(self.superAddQualityPropId)
			return
		end
		local l_types = {
			GameEnum.EBagContainerType.Bag
		}
		local l_itemFuncUtil = MgrProxy:GetItemDataFuncUtil()
		---@type FiltrateCond
		local condition = {  Cond = l_itemFuncUtil.ItemMatchesTid, Param = self.superAddQualityPropId  }
		local conditions = { condition }
		---@return ItemData[]
		local l_retItemDatas = Data.BagApi:GetItemsByTypesAndConds(l_types, conditions)
		
		for _,v in pairs(l_retItemDatas) do
			if v.ItemCount>0 then
				MgrMgr:GetMgr("PropMgr").RequestUseItem(v.UID, 1, v.TID)
				break
			end
		end
	end, true)

	self:RefreshAbilityPanel()
end

function VehiclesOccupationCtrl:RefreshAbilityPanel()
	self:RefreshAbilityBaseInfoPanel()
	self:RefreshAbilityAttrInfoPanel()
end

function VehiclesOccupationCtrl:RefreshAbilityBaseInfoPanel()
	local l_professionVehicleId = self.Mgr.GetProfessionVehicleId()
	self:RefreshAbilityUseState()

	local l_vehicleItem = TableUtil.GetVehicleTable().GetRowByID(l_professionVehicleId)
	if not MLuaCommonHelper.IsNull(l_vehicleItem) then
		self.panel.Tmp_Title.LabText = l_vehicleItem.Name
		local _, l_currentVehicleDyeId = self.Mgr.GetEquipOrnamentAndDyeId(l_professionVehicleId)
		local l_proVehicleModelName = self.Mgr.GetProVehicleModelName(self.currentChooseProVehicleStage)
		self:ShowVehicleModel(1, self.panel.RawImg_Ablity, l_proVehicleModelName, l_currentVehicleDyeId, self.panel.Img_TouchArea)
		self:refreshAbilityVehicleFeatureInfo(l_vehicleItem)
	end
end

function VehiclesOccupationCtrl:RefreshAbilityUseState()
	if not self:IsShowing() then
		return
	end
	local l_hasProfessionVehicle = self.Mgr.HasProfessionVehicle()
	local l_isUsingProVehicle = self.Mgr.IsUseingProVehicle()
	local l_curLevel, _ = self.Mgr.GetVehicleLevelAndExp()
	local l_canUseProVehicle = l_curLevel >= self.openUseLevel
	local l_currentStage = self.Mgr.GetVehicleStage()
	local l_isShowFetchCondition = not l_hasProfessionVehicle
	local l_isShowUseCondition = (not l_isShowFetchCondition) and (not l_canUseProVehicle)
	local l_currentShowVehicleCanUse = self.currentChooseProVehicleStage<=l_currentStage
	local l_canShowUseProVehicleBtn = not l_isShowFetchCondition and (not l_isShowUseCondition) and l_currentShowVehicleCanUse
	self.panel.Panel_Condition:SetActiveEx(l_isShowFetchCondition)
	self.panel.Btn_Rest:SetActiveEx(l_canShowUseProVehicleBtn and l_isUsingProVehicle)
	self.panel.Btn_Enabling:SetActiveEx(l_canShowUseProVehicleBtn and (not l_isUsingProVehicle))
	self.panel.Panel_Notavailable:SetActiveEx(not l_hasProfessionVehicle)
	self.panel.Panel_AttInfo:SetActiveEx(l_hasProfessionVehicle)
	self.panel.Img_Enable_Mask:SetActiveEx(not l_canUseProVehicle)

	self.panel.Btn_LastVehicle:SetActiveEx(self.currentChooseProVehicleStage > l_currentStage)
	self.panel.Btn_NextVehicle:SetActiveEx(self.currentChooseProVehicleStage < self.Mgr.GetProVehicleMaxStage())

	local l_needShowVehicleUseCondition = false
	local l_vehicleUseCondContent = nil
	if l_hasProfessionVehicle then
		--选择载具阶数大于当前阶，且目标等级大于当前等级显示条件
		if self.currentChooseProVehicleStage > l_currentStage then
			local l_chooseStageNeedLevel = self.Mgr.GetVehicleStageUpLimitLevel(self.currentChooseProVehicleStage)
			l_needShowVehicleUseCondition = true
			l_vehicleUseCondContent =  Lang("ACTIVE_VEHICLE_STAGE_CONDITION",l_chooseStageNeedLevel)
			if l_chooseStageNeedLevel<=l_curLevel then
				self.panel.Txt_VehicleUseCondition.LabColor = CommonUI.Color.Hex2Color(RoBgColor.Green)
			end
			self.panel.Txt_VehicleStageCondition.LabText = Lang("ACTIVE_ON_VEHICLE_STAGEUP")
			self.panel.Btn_LevelConditionFinish:SetActiveEx(l_chooseStageNeedLevel<=l_curLevel)
			self.panel.Panel_StageCondition:SetActiveEx(true)
		else
			--载具还不能启用时也显示载具条件
			if not l_canUseProVehicle then
				l_needShowVehicleUseCondition = true
				l_vehicleUseCondContent =  string.format(Lang("USE_VEHICLE_CONDITION"), self.openUseLevel)
			end
			self.panel.Btn_LevelConditionFinish:SetActiveEx(l_canUseProVehicle)
			self.panel.Panel_StageCondition:SetActiveEx(false)
		end
	end

	self.panel.Img_VehicleUseCondition:SetActiveEx(l_needShowVehicleUseCondition)
	if l_needShowVehicleUseCondition then
		self.panel.Txt_VehicleUseCondition.LabText = l_vehicleUseCondContent
	end

	self:RefreshProVehicleEnableRedHint()
	if l_hasProfessionVehicle then
		self:RefreshAbilityLevelInfoPanel()
	end
	if l_isShowFetchCondition then
		local l_taskMgr = MgrMgr:GetMgr("TaskMgr")
		local l_row = TableUtil.GetGlobalTable().GetRowByName("VehicleTaskId")
		if not MLuaCommonHelper.IsNull(l_row) then
			local l_taskName = l_taskMgr.GetTaskNameByTaskId(tonumber(l_row.Value))
			self.panel.Txt_FetchDesc.LabText = Lang("VEHICLE_TASK_LIMIT",l_taskName )
		end
		self.panel.Btn_Goto:SetActiveEx(not l_hasProfessionVehicle)
		self.panel.Btn_Finish:SetActiveEx(l_hasProfessionVehicle)

		if l_hasProfessionVehicle then
			self.panel.Txt_FetchDesc.LabColor = CommonUI.Color.Hex2Color(RoBgColor.Green)
		end
	end
end

function VehiclesOccupationCtrl:RefreshProVehicleEnableRedHint()
	local l_curLevel, _ = self.Mgr.GetVehicleLevelAndExp()
	self.ShowUseVehicleRedHint = false
	if l_curLevel >= self.openUseLevel then
		local l_key = "firstUseProVehicle"
		local l_value = UserDataManager.GetStringDataOrDef(l_key, MPlayerSetting.PLAYER_SETTING_GROUP, "0")
		if l_value == "0" then
			self.ShowUseVehicleRedHint = true
		end
	end
	self.panel.Img_RedHint:SetActiveEx(self.ShowUseVehicleRedHint)
end

function VehiclesOccupationCtrl:ShowVehicleModel(modelIndex, rawImgObj, actor, dyeId, touchAreaCom)
	if MLuaCommonHelper.IsNull(rawImgObj) or actor == nil or MLuaCommonHelper.IsNull(touchAreaCom) then
		return
	end
	rawImgObj:SetActiveEx(false)
	local l_model = self.models[modelIndex]
	if l_model ~= nil then
		self:DestroyUIModel(l_model)
	end

	local l_data = TableUtil.GetVehicleTable().GetRowByID(self.Mgr.GetProfessionVehicleId())
	if not l_data then
		logError("VehicleTable中不存在对应载具ID：{0}", self.Mgr.GetProfessionVehicleId())
		return
	end
	local pos = { x = l_data.Horizontal, y = l_data.Height, z = l_data.Depth }
	local rotate = { x = 0, y = l_data.Rotate, z = 0 }
	local scale = { x = l_data.Scale, y = l_data.Scale, z = l_data.Scale }

	local l_fxData = {}
	l_fxData.rawImage = rawImgObj.RawImg
	l_fxData.prefabPath = string.format("Prefabs/%s", actor)
	l_fxData.height = 1024
	l_fxData.width = 1024
	l_fxData.enablePostEffect = true
	l_fxData.useShadow = true
	l_fxData.defaultAnim = string.format("Anims/Mount/%s/%s_Idle", l_data.Actor, l_data.Actor)
	l_model = self:CreateUIModel(l_fxData)
	self.models[modelIndex] = l_model
	l_model:AddLoadModelCallback(function(m)
		rawImgObj:SetActiveEx(true)
		l_model.Trans:SetPos(pos.x, pos.y, pos.z)
		l_model.Trans:SetLocalScale(scale.x, scale.y, scale.z)
		l_model.UObj:SetRotEuler(rotate.x, rotate.y, rotate.z)
		if dyeId > 0 then
			local l_colorData = TableUtil.GetVehicleColorationTable().GetRowByColorationID(dyeId)
			if not l_colorData then
				logError("找不到对应的染色数据@周阳")
			else
				l_model:ChangeTexture("Mount/" .. l_colorData.Model)
			end
		end
		local l_listener = touchAreaCom:GetComponent("MLuaUIListener")
		l_listener.onDrag = function(uobj, event)
			if l_model and l_model.Trans then
				l_model.Trans:Rotate(Vector3.New(0, -event.delta.x, 0))
			end
		end
	end)
end

function VehiclesOccupationCtrl:RefreshAbilityLevelInfoPanel()
	if not self:IsShowing() then
		return
	end
	local l_proLevelLimit, l_nextLevelNeedRoleLevel = self.Mgr.GetProVehicleLvLimit()
	local l_curLevel, l_curExp = self.Mgr.GetVehicleLevelAndExp()
	local l_isMaxVehicleLv = l_curLevel >= l_proLevelLimit
	local l_maxExp = 1
	local l_remainNum, l_maxNum = self.Mgr.GetVehicleLvUpItemUseNum()
	local l_expProgress = 1
	self.panel.Img_MaskLvUp:SetActiveEx(l_isMaxVehicleLv)
	self.panel.Txt_Level.LabText = string.format("Lv.%s", l_curLevel)

	if not l_isMaxVehicleLv then
		local l_row = TableUtil.GetVehicleLvTable().GetRowByVehicleLv(l_curLevel + 1)
		if l_row then
			l_maxExp = l_row.Exp
		end
		l_expProgress = l_curExp / l_maxExp
		self.panel.Txt_VehicleProgress.LabText = string.format("%s/%s", l_curExp, l_maxExp)
	else
		self.panel.Txt_VehicleProgress.LabText = string.format("Max")
	end
	self.panel.ProgressSlider.Slider.value = l_expProgress


	if l_isMaxVehicleLv and l_nextLevelNeedRoleLevel == -1 then
		self.panel.Btn_LvUp:SetActiveEx(false)
		self.panel.Txt_Number.LabText = "--/--"
	else
		self.panel.Txt_Number.LabText = string.format("%s/%s", l_remainNum, l_maxNum)
	end
end

function VehiclesOccupationCtrl:RefreshAbilityAttrInfoPanel()
	if not self:IsShowing() or not self.panel.Panel_AttInfo.UObj.activeSelf then
		return
	end
	local l_attrData = self.Mgr.GetAttrInfoData()
	local l_attrInfoTemNum = #self.abilityAttrTemplates
	if l_attrInfoTemNum < 1 then
		for i = 1, #l_attrData do
			local l_attrTem = self:NewTemplate("AttrInfoTemplate", {
				TemplatePrefab = self.panel.Template_AttrInfo.gameObject,
				TemplateParent = self.panel.Obj_abilityAttrParent.Transform,
				Data = l_attrData[i]
			})
			table.insert(self.abilityAttrTemplates, l_attrTem)
		end
	else
		for i = 1, #l_attrData do
			self.abilityAttrTemplates[i]:SetData(l_attrData[i])
		end
	end
end

function VehiclesOccupationCtrl:RefreshLvUpPanel()
	if not self:IsShowing() then
		return
	end

	local l_lvUpPropTable = self.Mgr.GetLevelUpPropData()
	if self.lvItemTemplates == nil then
		self.lvItemTemplates = {}
		local l_propNum = #l_lvUpPropTable
		for i = 1, l_propNum do
			local l_template = self:NewTemplate("VehicleItemTemplate", {
				TemplatePrefab = self.panel.Template_Item.gameObject,
				TemplateParent = self.panel.Obj_LvUpParent.Transform,
				Data = l_lvUpPropTable[i],
			})
			table.insert(self.lvItemTemplates, l_template)
		end
		return
	end

	for i = 1, #l_lvUpPropTable do
		self.lvItemTemplates[i]:Refresh(l_lvUpPropTable[i])
	end
end

function VehiclesOccupationCtrl:refreshAbilityVehicleFeatureInfo(vehicleItem)
	if MLuaCommonHelper.IsNull(vehicleItem) then
		return
	end
	local l_isLandVehicle = self.Mgr.IsLandVehicle(vehicleItem.VehicleType)
	self.panel.Img_Land:SetActiveEx(l_isLandVehicle)
	self.panel.Img_Sky:SetActiveEx(not l_isLandVehicle)

	self.panel.Img_One:SetActiveEx(vehicleItem.Num==1)
	self.panel.Img_Two:SetActiveEx(vehicleItem.Num>1)
	local l_vehicleSpeedPercent = self.Mgr.GetVehicleSpeedPercent(vehicleItem.HorizontalSpeed)
	self.panel.Txt_Percentage.LabText = string.format("%s%%",l_vehicleSpeedPercent)
end

function VehiclesOccupationCtrl:RefreshStageUpPanel()
	if not self:IsShowing() then
		return
	end
	local l_stageUpLimitLevel = self.Mgr.GetVehicleStageUpLimitLevel()
	if l_stageUpLimitLevel<0 then
		self.panel.Panel_Advancedtips:SetActiveEx(false)
		return
	end
	local l_curLevel, _ = self.Mgr.GetVehicleLevelAndExp()
	local l_currentStage = self.Mgr.GetVehicleStage()
	local l_professionVehicleId = self.Mgr.GetProfessionVehicleId()
	local _, l_currentVehicleDyeId = self.Mgr.GetEquipOrnamentAndDyeId(l_professionVehicleId)
	local l_currentStageModelName = self.Mgr.GetProVehicleModelName(l_currentStage)
	local l_nextStageModelName = self.Mgr.GetProVehicleModelName(l_currentStage + 1)
	self:ShowVehicleModel(2, self.panel.RawImg_StageUpL, l_currentStageModelName, l_currentVehicleDyeId, self.panel.Img_TouchAreaLeft)
	self:ShowVehicleModel(3, self.panel.RawImg_StageUpR, l_nextStageModelName, l_currentVehicleDyeId, self.panel.Img_TouchAreaRight)

	local l_attrData = self.Mgr.GetAttrInfoData()
	local l_attrInfoTemNum = #self.abilityStageUpTemplates
	if l_attrInfoTemNum < 1 then
		self.abilityStageUpTemplates = {}
		for i = 1, #l_attrData do
			local l_attrTem = self:NewTemplate("StageupTemplate", {
				TemplatePrefab = self.panel.template_stageup.gameObject,
				TemplateParent = self.panel.Obj_StageUpAttParent.Transform,
				Data = l_attrData[i]
			})
			table.insert(self.abilityStageUpTemplates, l_attrTem)
		end
	else
		for i = 1, #l_attrData do
			self.abilityStageUpTemplates[i]:SetData(l_attrData[i])
		end
	end
	self:RefreshStageUpConditionInfo(l_curLevel, l_stageUpLimitLevel)
end

function VehiclesOccupationCtrl:RefreshStageUpConditionInfo(curLevel, stageUpLimitLevel)
	local l_canStageUp = stageUpLimitLevel~=-1 and curLevel >= stageUpLimitLevel
	self.panel.Txt_Unlocked:SetActiveEx(not l_canStageUp)
	self.panel.Btn_StageUp:SetActiveEx(l_canStageUp)
	self.panel.obj_StageupItemParent:SetActiveEx(l_canStageUp)

	if not l_canStageUp then
		self.panel.Txt_Unlocked.LabText = string.format(Lang("VEHICLE_STAGEUP_CONDITION"), stageUpLimitLevel)
		return
	end
	for i = 1, #self.stageUpItemTemplates do
		self:UninitTemplate(self.stageUpItemTemplates[i])
	end
	self.stageUpItemTemplates = {}
	local l_consumePropEnough = true
	local l_nextStageNeedLv, l_nextStageNeedPropInfo = self.Mgr.GetNextStageInfo()
	if l_nextStageNeedLv ~= nil then
		for i = 0, l_nextStageNeedPropInfo.Count - 1 do
			local l_propInfo = l_nextStageNeedPropInfo[i]
			local l_propId = l_propInfo[0]
			local l_needCount = l_propInfo[1]
			local l_haveCount = Data.BagModel:GetCoinOrPropNumById(l_propId)
			if l_needCount > l_haveCount then
				l_consumePropEnough = false
			end

			local l_itemTemplate = self:NewTemplate("ItemTemplate", {
				TemplateParent = self.panel.obj_StageupItemParent.Transform,
				Data = {
					IsActive = true,
					ID = l_propId,
					IsShowRequire = true,
					RequireCount = l_needCount,
					IsShowCount = not MgrMgr:GetMgr("PropMgr").IsVirtualCoin(l_propId),
					Count = l_haveCount
				},
			})

			table.insert(self.stageUpItemTemplates, l_itemTemplate)
		end
	end
	self.panel.Img_Mask:SetActiveEx(not l_consumePropEnough)
end

function VehiclesOccupationCtrl:OnUpgradeVehicleSuc()
	self:RefreshLvUpPanel()
	self:RefreshAbilityUseState()
	self:RefreshAbilityAttrInfoPanel()
end

function VehiclesOccupationCtrl:OnVehicleUpgradeLimitSuc()
	self.currentChooseProVehicleStage = self.Mgr.GetVehicleStage()
	self:RefreshStageUpPanel()
	self:RefreshAbilityPanel()
	self:RefreshQualityAttrInfoPanel()
	self:RefreshQualityPanel()
end

function VehiclesOccupationCtrl:OnVehicleLevelUp()
	local l_proLevelLimit, l_levelUpNeedRoleLevel = self.Mgr.GetProVehicleLvLimit()
	local l_curLevel, _ = self.Mgr.GetVehicleLevelAndExp()

	if self.effect ~= nil then
		self:DestroyUIEffect(self.effect)
		self.effect = nil
	end

	local l_fxPath = LEVEL_UP_FX
	local l_fxData_effect = {}
	l_fxData_effect.rawImage = self.panel.RawImg_Ablity.RawImg
	l_fxData_effect.loadedCallback = function(go)
		self.panel.RawImg_StageUpL.gameObject:SetActiveEx(true)
		go.transform:SetLocalPos(0, 0.62, 0)
	end
	l_fxData_effect.destroyHandler = function()
		self.effect = nil
	end
	self.effect = self:CreateUIEffect(l_fxPath, l_fxData_effect)

	if l_curLevel >= l_proLevelLimit then
		if l_levelUpNeedRoleLevel == -1 then
			MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("CURRENT_LEVEL_MAX"))
		else
			MgrMgr:GetMgr("TipsMgr").ShowNormalTips(string.format(Lang("VEHICLE_LVUP_NEED_ROLELEVEL"), l_levelUpNeedRoleLevel))
		end
		return
	end
	self:RefreshProVehicleEnableRedHint()
end
--endregion----------------------------------ability panel end-----------------------------

--region----------------------------------quality panel---------------------------------
function VehiclesOccupationCtrl:InitQualityPanel()
	if self.initInfoTable[2] then
		self:RefreshQualityPanel()
		return
	end
	self.initInfoTable[2] = true

	self.panel.Btn_Replace:AddClick(function()
		self.Mgr.SendConfirmVehicleQualityMsg(self.cultureType)
	end, true)

	self.panel.Btn_Culture:AddClick(function()
		self.Mgr.SendDevelopVehicleQualityMsg(self.cultureType)
	end, true)

    self.panel.Btn_VehicleInfo1.Listener:SetActionClick(self.onVehicleFeatureClick,self)

	self.panel.Btn_QualityGoto:AddClick(function()
		local l_taskMgr = MgrMgr:GetMgr("TaskMgr")
		local l_row = TableUtil.GetGlobalTable().GetRowByName("VehicleTaskId")
		if not MLuaCommonHelper.IsNull(l_row) then
			local l_taskId = tonumber(l_row.Value)
			if l_taskMgr.CheckTaskTaked(l_taskId) then
				l_taskMgr.OnQuickTaskClickWithTaskId(l_taskId)
			else
				l_taskMgr.NavToTaskAcceptNpc(tonumber(l_row.Value))
			end
		end
		UIMgr:DeActiveUI(CtrlNames.VehiclesBG)
	end, true)

	self.panel.Toggle_Primary:OnToggleExChanged(function(on)
		if on then
			self.cultureType = self.Mgr.cultureType.primary
			self:RefreshQualityAttrInfoPanel()
			self:RefreshQualityConsumeInfo()
			self:RefreshQualityBaseInfoPanel()
		end
	end)
	self.panel.Toggle_Senior:OnToggleExChanged(function(on)
		if on then
			self.cultureType = self.Mgr.cultureType.senior
			self:RefreshQualityAttrInfoPanel()
			self:RefreshQualityConsumeInfo()
			self:RefreshQualityBaseInfoPanel()
		end
	end)

	self.cultureConsumeItemPool = self:NewTemplatePool({
		TemplateClassName = "ItemTemplate",
		TemplateParent = self.panel.Obj_ConsumeParent.transform,
	})
	self.qualityExtraAddAttrPool = self:NewTemplatePool({
		UITemplateClass = UITemplate.QualityExtraAttrTemplate,
		TemplatePrefab = self.panel.Template_QualityExtraAttr.gameObject,
		TemplateParent = self.panel.Panel_QualityAddAttr.Transform,
	})
	self.panel.Toggle_Primary.TogEx.isOn = true
	self:RefreshQualityPanel()
end

function VehiclesOccupationCtrl:onVehicleFeatureClick(go,ed)
    local l_professionVehicleId = self.Mgr.GetProfessionVehicleId()
    local l_vehicleItem = TableUtil.GetVehicleTable().GetRowByID(l_professionVehicleId)
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
    local l_vehicleSpeedPercent =self.Mgr.GetVehicleSpeedPercent(l_vehicleItem.HorizontalSpeed)

    MgrMgr:GetMgr("TipsMgr").ShowQuestionTip(Lang("VEHICLE_FEATURE_TIPS",l_vehicleTypeStr,l_vehicleNumStr,l_vehicleSpeedPercent),
            ed, l_tipPivot, false)
end

function VehiclesOccupationCtrl:RefreshQualityPanel()
	local l_professionVehicleId = self.Mgr.GetProfessionVehicleId()
	local l_vehicleItem = TableUtil.GetVehicleTable().GetRowByID(l_professionVehicleId)
	if MLuaCommonHelper.IsNull(l_vehicleItem) then
		return
	end

	local l_hasProfessionVehicle = self.Mgr.HasProfessionVehicle()
	self.panel.Panel_QualityRight:SetActiveEx(l_hasProfessionVehicle)
	self.panel.Panel_Notavailable:SetActiveEx(not l_hasProfessionVehicle)
	self.panel.Panel_QualityCondition:SetActiveEx(not l_hasProfessionVehicle)

	if not l_hasProfessionVehicle then
		local l_taskMgr = MgrMgr:GetMgr("TaskMgr")
		local l_row = TableUtil.GetGlobalTable().GetRowByName("VehicleTaskId")
		if not MLuaCommonHelper.IsNull(l_row) then
			self.panel.Txt_QualityFetchDesc.LabText = string.format("%s%s!", Lang("DUNGEONS_TASK_State2"), l_taskMgr.GetTaskNameByTaskId(tonumber(l_row.Value)))
		end
    else
        local l_stageUpLimitLevel = self.Mgr.GetVehicleStageUpLimitLevel()
        local l_curLevel, _ = self.Mgr.GetVehicleLevelAndExp()
        if l_stageUpLimitLevel>=0 and l_curLevel>=l_stageUpLimitLevel then
            self.panel.Effect_Advanced:SetActiveEx(true)
            self.panel.Effect_Advanced:PlayDynamicEffect()
        else
            self.panel.Effect_Advanced:SetActiveEx(false)
        end
	end

	self.panel.Tmp_VehicleTitle.LabText = l_vehicleItem.Name
	local _, l_currentVehicleDyeId = self.Mgr.GetEquipOrnamentAndDyeId(l_professionVehicleId)
	self:ShowVehicleModel(4, self.panel.RawImg_model, self.Mgr.GetCurrentProVehicleModelName(), l_currentVehicleDyeId, self.panel.Img_TouchAreaQuality)
	self.cultureType = self.Mgr.cultureType.primary
	if self.panel.Toggle_Senior.TogEx.isOn then
		self.cultureType = self.Mgr.cultureType.senior
	end
	self:refreshQualityVehicleFeatureInfo(l_vehicleItem)
	self:RefreshQualityBaseInfoPanel()
	self:RefreshQualityAttrInfoPanel()
	self:RefreshQualityConsumeInfo()
end

function VehiclesOccupationCtrl:refreshQualityVehicleFeatureInfo(vehicleItem)
	if MLuaCommonHelper.IsNull(vehicleItem) then
		return
	end
	local l_isLandVehicle = self.Mgr.IsLandVehicle(vehicleItem.VehicleType)
	self.panel.Img_QualityLand:SetActiveEx(l_isLandVehicle)
	self.panel.Img_QualitySky:SetActiveEx(not l_isLandVehicle)

	self.panel.Img_QualityOne:SetActiveEx(vehicleItem.Num==1)
	self.panel.Img_QualityTwo:SetActiveEx(vehicleItem.Num>1)

	local l_vehicleSpeedPercent = self.Mgr.GetVehicleSpeedPercent(vehicleItem.HorizontalSpeed)
	self.panel.Txt_QualityPercentage.LabText = string.format("%s%%",l_vehicleSpeedPercent)
end

function VehiclesOccupationCtrl:RefreshQualityBaseInfoPanel()
	local l_attrInfos = self.Mgr.GetAttrInfoData()
	local l_needShowReplaceBtn = false
	if self.cultureType == self.Mgr.cultureType.primary and l_attrInfos.hasPrimaryCulture then
		l_needShowReplaceBtn = true
	elseif self.cultureType == self.Mgr.cultureType.senior and l_attrInfos.hasSeniorCulture then
		l_needShowReplaceBtn = true
	end
	self.panel.Btn_Replace:SetActiveEx(l_needShowReplaceBtn)
end
function VehiclesOccupationCtrl:RefreshQualityConsumeInfo()
	local l_vqrItem = TableUtil.GetVehicleQualityRandomTable().GetRowById(1)
	if l_vqrItem == nil then
		logError("RefreshQualityConsumeInfo 无法获取表格数据")
		return
	end
	local l_consumePropData = self.cultureType == self.Mgr.cultureType.primary and l_vqrItem.PrimaryConsume or l_vqrItem.AdvancedConsume
	local l_consumeDatas = {}
	for i = 0, l_consumePropData.Count - 1 do
		local l_consumePropInfo = l_consumePropData[i]
		table.insert(l_consumeDatas, {
			IsActive = true,
			ID = l_consumePropInfo[0],
			IsShowRequire = true,
			RequireCount = l_consumePropInfo[1],
			IsShowCount = false,
		})
	end
	self.cultureConsumeItemPool:ShowTemplates({ Datas = l_consumeDatas })
end
function VehiclesOccupationCtrl:onQualityInfoClick(attrData)
	if attrData==nil then
		return
	end
	self.panel.Panel_QualityPropInfo:SetActiveEx(true)
	local l_superPropInfo = self.Mgr.GetSuperPropInfoByQualityID(attrData.Id)
	if l_superPropInfo == nil then
		return
	end

	local l_propId = tonumber(l_superPropInfo[1])
	self.superAddQualityPropId = l_propId
	local l_superPropItem = TableUtil.GetItemTable().GetRowByItemID(l_propId)
	if MLuaCommonHelper.IsNull(l_superPropItem) then
		return
	end
	self.panel.Txt_AddQualityName.LabText = l_superPropItem.ItemName
	self.panel.Txt_PropDesc.LabText = l_superPropItem.ItemDescription


	self.panel.Txt_AddQualityName.LabText = l_superPropItem.ItemName
	self.panel.Txt_PropDesc.LabText = l_superPropItem.ItemDescription
	self:refreshSuperPropUseNum()
end

function VehiclesOccupationCtrl:refreshSuperPropUseNum()
	if self.superAddQualityPropId==nil then
		return
	end
	local l_superQualityPropData = {
		IsActive = true,
		ID = self.superAddQualityPropId,
		IsShowCount = true,
		Count = Data.BagModel:GetCoinOrPropNumById(self.superAddQualityPropId)
	}
	if self.superQualityItem==nil then
		self.superQualityItem = self:NewTemplate("ItemTemplate", {
			TemplateParent = self.panel.Img_QualityProp.Transform,
			Data = l_superQualityPropData,
		})
	else
		self.superQualityItem:SetData(l_superQualityPropData)
	end

	local l_remainSuperPropUseNum,l_maxSuperPropUseNum = self.Mgr.GetSuperQualityPropUseCount()
	self.panel.Txt_UseLimit.LabText = StringEx.Format("{0}/{1}",l_maxSuperPropUseNum-l_remainSuperPropUseNum
	,l_maxSuperPropUseNum)
end
function VehiclesOccupationCtrl:createQualityInfo(attrData,parent)
	if attrData==nil then
		return
	end
	attrData.showQualityType = self.cultureType
	local l_attrTem = self:NewTemplate("QualityInfoTemplate", {
		TemplatePrefab = self.panel.QualityInfoTemplate.gameObject,
		TemplateParent = parent,
		Data ={
			attrData = attrData,
			clickCallback = self.onQualityInfoClick,
			funcSelf = self,
		}
	})
	table.insert(self.cultureAttTemplates, l_attrTem)
end
function VehiclesOccupationCtrl:RefreshQualityAttrInfoPanel()
	if not self:IsShowing() then
		return
	end
	local l_attrData = self.Mgr.GetAttrInfoData()
	if #self.cultureAttTemplates < 1 then
		if #l_attrData>=5 then
			self:createQualityInfo(l_attrData[1],self.panel.Obj_FirstQuality.Transform)
			self:createQualityInfo(l_attrData[1],self.panel.Obj_SecondQuality.Transform)
			self:createQualityInfo(l_attrData[1],self.panel.Obj_ThirdQuality.Transform)
			self:createQualityInfo(l_attrData[1],self.panel.Obj_FourthQuality.Transform)
			self:createQualityInfo(l_attrData[1],self.panel.Obj_FifthQuality.Transform)
		end
		return
	end
	for i = 1, #l_attrData do
		local l_attData = l_attrData[i]
		l_attData.showQualityType = self.cultureType
		local l_qualityData ={
			attrData = l_attData,
			clickCallback = self.onQualityInfoClick,
			funcSelf = self,
		}
		self.cultureAttTemplates[i]:SetData(l_qualityData)
	end
	if self.qualityExtraAddAttrPool then
		self.qualityExtraAddAttrPool:ShowTemplates({ Datas = l_attrData })
	end
end
function VehiclesOccupationCtrl:OnDevelopVehicleQuality()
	self:RefreshQualityBaseInfoPanel()
	self:RefreshQualityAttrInfoPanel()
	self:RefreshQualityConsumeInfo()
end
function VehiclesOccupationCtrl:OnConfirmVehicleQuality()
	self:RefreshQualityBaseInfoPanel()
	self:RefreshQualityAttrInfoPanel()
	self:RefreshAbilityAttrInfoPanel()
end
--endregion---------------------------------quality panel end-----------------------------

function VehiclesOccupationCtrl:ClearModel()
	for i = 1, #self.models do
		local l_model = self.models[i]
		if l_model ~= nil then
			self:DestroyUIModel(l_model)
		end
	end
	self.models = {}
end
--lua custom scripts end
return VehiclesOccupationCtrl