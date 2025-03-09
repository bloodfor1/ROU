--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/BeiluzCorePanel"
require "UI/Template/BeiluzCoreItemTemplate"
--lua requires end

--lua model
module("UI", package.seeall)

--lua model end

--lua fields
local super = UI.UIBaseCtrl
--lua fields end

--lua class define
BeiluzCoreCtrl = class("BeiluzCoreCtrl", super)
--lua class define end

-- 戒指状态
local l_animClip = {
	idle = "Idle",		-- 戒指旋转
	open = "Special",	-- 打开
	close = "FIdle",	-- 关闭
	move = "Move",		-- 齿轮旋转
}

local l_animClipSource = {
	[l_animClip.idle] = "Anims/Collection/Item_Collect_BeiLuZi_Ring/Item_Collect_BeiLuZi_Ring_ZiZhuan_Idle",
	[l_animClip.close] = "Anims/Collection/Item_Collect_BeiLuZi_Ring/Item_Collect_BeiLuZi_Ring_GuanBi",
	[l_animClip.open] = "Anims/Collection/Item_Collect_BeiLuZi_Ring/Item_Collect_BeiLuZi_Ring_DaKai",
	[l_animClip.move] = "Anims/Collection/Item_Collect_BeiLuZi_Ring/Item_Collect_BeiLuZi_Ring_ZhuanDong_Idle",
}

local l_effType = {
	halfCircleEffect1 = "Bone003/halfCircleEffect1",
	idleEffect = "root/idleEffect",
	halfCircleEffect2 = "Bone005/halfCircleEffect2",
	openEffect = "root/openEffect"
}

local l_wheelRoot = {
	[1] = "Bone013",
	[2] = "Bone007",
	[3] = "Bone011"
}

local l_effWheelRoot = {
	[1] = "Bone013/wheelEffectRoot1",
	[2] = "Bone007/wheelEffectRoot2",
	[3] = "Bone011/wheelEffectRoot3"
}

local l_mgr = MgrMgr:GetMgr("BeiluzCoreMgr")
local l_attrMgr = MgrMgr:GetMgr("AttrDescUtil")
local c_totalSeconds = 2.5		-- 齿轮转动、停止时长
local c_acceleration = 0.0166667

--lua functions
function BeiluzCoreCtrl:ctor()
	super.ctor(self, CtrlNames.BeiluzCore, UILayer.Function, nil, ActiveType.Exclusive)
end --func end
--next--
function BeiluzCoreCtrl:Init()
	self.panel = UI.BeiluzCorePanel.Bind(self)
	super.Init(self)

	self:_init()

end --func end
--next--
function BeiluzCoreCtrl:Uninit()
	super.Uninit(self)
	self.panel = nil
	self.wheelRoot = {}
	self.effectRoot = {}
end --func end

--next--
function BeiluzCoreCtrl:OnActive()
	c_acceleration = 1/(c_totalSeconds *30)
	self.curModelState = l_mgr.BEILUZCORE_MODEL_STATE.Close

	self:RefreshData()
	self:RefreshTotalWeight()
	self:RefreshSlotUI()
	self:RefreshRightUI()
	self:RefreshOverloadInfo()
	self:ForceRebuildAllLayout()
	self:GuideIfNeed()
	self:InitModel()
	l_mgr.TipNoLifeWheelUnload()
end --func end
--next--
function BeiluzCoreCtrl:OnDeActive()
	self.l_itemTemplate = {}
	self.curSelectPos = -1
	if self.timer then
		self.timer:Stop()
		self.timer = nil
	end
	self:_clearModel()
end --func end
--next--
function BeiluzCoreCtrl:Update()

end --func end
--next--

function BeiluzCoreCtrl:BindEvents()
	self:BindEvent(MgrProxy:GetGameEventMgr().l_eventDispatcher,MgrProxy:GetGameEventMgr().OnBagUpdate,self.OnItemChangeBroadCast,self)
	self:BindEvent(l_mgr.l_eventDispatcher, l_mgr.SIG_WHEEL_ON_CLICK_ICON,self.OnBtnItemIcon,self)
end --func end
--next--
--lua functions end

--lua custom scripts
function BeiluzCoreCtrl:_init()

	self.tglGroup = self.panel.tglGroupRoot:GetComponent("ToggleGroup")
	self.dropdownIndex = 0

	self.wheelRoot = {}		-- 小齿轮父节点
	self.effectRoot = {}	-- 特效父节点

	self.l_itemTemplate = {}	-- 左侧插槽Item
	for i=1, l_mgr.MAX_SLOT_COUNT do

		self.panel.TglCore[i]:OnToggleChanged(function(value)
			self:OnClickTgl(value,i)
		end)

		self.panel.LockBtn[i]:AddClick(function()
			MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("WHEEL_SLOT_UNLOCK_TIP",l_mgr.GetUnlockLv(i)))
		end)

		self.l_itemTemplate[i] = self:NewTemplate("ItemTemplate", {
			TemplateParent = self.panel.CoreItemRoot[i].transform,
		})

		for j=1, l_mgr.MAX_ATTR_COUNT do
			local index = (i - 1) * l_mgr.MAX_ATTR_COUNT + j
			self.panel.SlotAttr[index]:AddClick(function()
				l_mgr.ShowSkillDesc(l_mgr.g_equippedCoreList[i],j,self.panel.SlotAttr[index].transform.position)
			end)
		end
	end

	self.panel.ButtonClose:AddClickWithLuaSelf(self.OnBtnClose,self)

	self.panel.BtnMaintain:AddClickWithLuaSelf(self.OnBtnMaintenance,self)

	self.panel.BtnUnload:AddClickWithLuaSelf(self.OnBtnUnload,self)

	self.panel.BtnModelStateSwitch:AddClickWithLuaSelf(self._switchModelState,self)

	self.panel.RawImageBtn.Listener.onClick = function(go,eventData)
		if self._inGuild then return end
		self:_switchModelState()
	end

	self.panel.BtnRule.Listener:SetActionClick(self.OnBtnTips,self)

	self.panel.overLoad.Listener:SetActionClick(self.OnBtnOverloadTip,self)

	self.panel.BtnGetWay:AddClickWithLuaSelf(self.OnBtnGetWay,self)

	self.panel.BtnCombine:AddClickWithLuaSelf(self.OnBtnCombine,self)

	self.panel.BtnReset:AddClickWithLuaSelf(self.OnBtnReset,self)

	self.coreBagListPool = self:NewTemplatePool({
		UITemplateClass = UITemplate.BeiluzCoreItemTemplate,
		ScrollRect = self.panel.CoreList.LoopScroll,
		Method = handler(self,self.OnBtnEquip)
	})

	self.curShowItemTemplate = self:NewTemplate("ItemTemplate",{
		TemplateParent = self.panel.DetailItemBG.transform,
	})

	local l_dropdownStrs = {}
	table.insert(l_dropdownStrs,Common.Utils.Lang("AllText"))
	table.insert(l_dropdownStrs,Common.Utils.Lang("WHEEL_TYPE_1"))
	table.insert(l_dropdownStrs,Common.Utils.Lang("WHEEL_TYPE_2"))
	table.insert(l_dropdownStrs,Common.Utils.Lang("WHEEL_TYPE_3"))
	--table.insert(l_dropdownStrs,Common.Utils.Lang("WHEEL_TYPE_4"))
	self.panel.Dropdown.DropDown:ClearOptions()
	self.panel.Dropdown:SetDropdownOptions(l_dropdownStrs)
	local l_onValueChanged = function(index)
		self.dropdownIndex = index
		self:RefreshRightUI(true,self.curSelectPos)
	end
	-- 初始化
	self.panel.Dropdown.DropDown.value = self.dropdownIndex
	self.panel.Dropdown.DropDown.onValueChanged:AddListener(l_onValueChanged)

    local OpenSystemMgr = MgrMgr:GetMgr("OpenSystemMgr")
    self.panel.BtnCombine:SetActiveEx(OpenSystemMgr.IsSystemOpen(OpenSystemMgr.eSystemId.BeiluzCombine))
    self.panel.BtnReset:SetActiveEx(OpenSystemMgr.IsSystemOpen(OpenSystemMgr.eSystemId.BeiluzReset))
end

-- 刷新已镶嵌齿轮和背包齿轮信息
function BeiluzCoreCtrl:RefreshData()
	l_mgr.RefreshEquippedCoreList()
	l_mgr.g_fullEquipped = l_mgr.IsFullEquipped()
end

-- 左上角重量信息
function BeiluzCoreCtrl:RefreshTotalWeight()
	self.panel.TotalWeight.LabText = string.format("%d/%d",l_mgr.g_equippedWeight, l_mgr.maxWeight)
end

-- 左侧槽位
function BeiluzCoreCtrl:RefreshSlotUI()
	local haveMutex	= false		-- 是否有互斥属性
	for i=1, l_mgr.MAX_SLOT_COUNT do
		self.panel.LockBtn[i]:SetActiveEx(not l_mgr.IsSlotUnlock(i))
		local data = l_mgr.g_equippedCoreList[i]
		if data then
			local itemData={
				PropInfo = data,
				IsShowCount = false,
				HideButton = true,
			}
			self.l_itemTemplate[i]:SetData(itemData)
			self.panel.CoreItemRoot[i]:SetActiveEx(true)
			local skillIDs = data:GetAttrsByType(GameEnum.EItemAttrModuleType.BelluzGear)
			for j=1, l_mgr.MAX_ATTR_COUNT do
				local index = (i - 1) * l_mgr.MAX_ATTR_COUNT + j
				if skillIDs[j] then
					if not haveMutex then
						haveMutex = self:CheckAttrInvalid(skillIDs[j],i,j)
					end
					local attr = l_attrMgr.GetAttrStr(skillIDs[j])
					self.panel.SlotAttr[index].LabText = attr.Name
					self.panel.SlotAttr[index]:SetActiveEx(true)
				else
					self.panel.SlotAttr[index]:SetActiveEx(false)
				end
			end
		else
			self.panel.CoreItemRoot[i]:SetActiveEx(false)
		end
	end
	self.panel.txtLeftInvalidTip:SetActiveEx(haveMutex)
end

-- 右侧UI：齿轮列表或当前选中齿轮信息
function BeiluzCoreCtrl:RefreshRightUI(select, pos)
	if select then
		self.curSelectPos = pos
	else
		self.curSelectPos = -1
	end

	local isEquipped = (l_mgr.g_equippedCoreList[pos] ~= nil)
	local curCoreList = self:GetCoreList()
	local bagCoreCount = #curCoreList

	local attrRootActive = select and isEquipped
	local emptyTipActive = not(select and isEquipped) and (bagCoreCount == 0)
	local coreListRootActive = not(select and isEquipped) and bagCoreCount > 0

	self.panel.AttRoot:SetActiveEx(attrRootActive)
	self.panel.EmptyTip:SetActiveEx(emptyTipActive)
	self.panel.CoreListRoot:SetActiveEx(coreListRootActive)
	self.panel.DropdownRoot:SetActiveEx(not attrRootActive)
	if coreListRootActive then
		self.coreBagListPool:ShowTemplates({ Datas = curCoreList})
	end
	if attrRootActive then
		self:RefreshCurAttInfo()
	end
end

function BeiluzCoreCtrl:GetCoreList()
	return l_mgr.GetSortedBagCoreListByTID(l_mgr.BEILUZCORE_TYPE_ITEM_IDS[self.dropdownIndex],l_mgr.SortByEquipPanelRule)
end

-- 右侧详细信息
function BeiluzCoreCtrl:RefreshCurAttInfo()
	local data = l_mgr.g_equippedCoreList[self.curSelectPos]
	if not data then return end
	local itemData={
		PropInfo = data,
		IsShowCount = false,
		HideButton = true,
	}
	self.curShowItemTemplate:SetData(itemData)

	self.panel.AttrName.LabText = l_mgr.GetColorNameByQuality(data.ItemConfig.ItemName,data.ItemConfig.ItemQuality)
	self:RefreshRemainTime()
    self.panel.BtnMaintain:SetActiveEx( MgrMgr:GetMgr("OpenSystemMgr").IsSystemOpen(MgrMgr:GetMgr("OpenSystemMgr").eSystemId.BeiluzMaintain))

	local skillIDs = data:GetAttrsByType(GameEnum.EItemAttrModuleType.BelluzGear)
	for i = 1, l_mgr.MAX_ATTR_COUNT do
		if skillIDs[i] then
			local invalid = self:CheckAttrInvalid(skillIDs[i],self.curSelectPos,i)
			local wheelSkillCfg = TableUtil.GetWheelSkillTable().GetRowById(skillIDs[i].TableID)
			if not wheelSkillCfg then break end
			local quality = wheelSkillCfg.SkillQuality
			local color = l_mgr.C_BEILUZCORE_SKILL_COLOR_MAP[quality]
			local attr = l_attrMgr.GetAttrStr(skillIDs[i], color)
			self.panel.DetailSkillName[i].LabText = attr.Name
			if invalid then
				self.panel.DetailSkillDesc[i].LabText = l_mgr.GetCommonTxt(Common.Utils.Lang("WHEEL_SKILL_TYPE_CONFLIC"))
			else
				-- 描述使用指定颜色，和名字使用统一颜色冲突，所以获取2次
				local attr2 = l_attrMgr.GetAttrStr(skillIDs[i])
				self.panel.DetailSkillDesc[i].LabText = l_mgr.GetCommonTxt(attr2.Desc)
			end
			self.panel.DetailSkillName[i]:SetActiveEx(true)
			self.panel.DetailSkillDesc[i]:SetActiveEx(true)
		else
			self.panel.DetailSkillName[i]:SetActiveEx(false)
			self.panel.DetailSkillDesc[i]:SetActiveEx(false)
		end
	end
	self:ForceRebuildAttrLayout()
end

function BeiluzCoreCtrl:RefreshOverloadInfo()
	self.panel.overLoad:SetSprite("CommonIcon",l_mgr.GetCurOverLoadImageName())
end

function BeiluzCoreCtrl:RefreshRemainTime()
	local data = l_mgr.g_equippedCoreList[self.curSelectPos]
	if not data then return end
	local remainTime = l_mgr.GetCoreRemainTimeInSeconds(data)
	if remainTime >= l_mgr.dayToSeconds then		--大于一天时，不做计时器
		self.panel.AttrLife.LabText = StringEx.Format(Common.Utils.Lang("TIME_DAY"),math.floor(remainTime/ l_mgr.dayToSeconds))
	else
		if self.timer ~= nil then
			self.timer:Stop()
		end
		if remainTime >= l_mgr.hourToMillisecond then		--小于一天，大于一小时，单位为小时,60秒刷新一次
			self:StartRemainTimeTimer(Common.Utils.Lang("TIME_HOUR"),60,remainTime, l_mgr.hourToMillisecond, l_mgr.hourToMillisecond)
		elseif remainTime >=60 then
			self:StartRemainTimeTimer(Common.Utils.Lang("TIME_MINUTE"),1,remainTime,60,60)
		elseif remainTime > 0 then
			self:StartRemainTimeTimer(Common.Utils.Lang("TIMESHOW_S"),1,remainTime,0,1)
		else
			self.panel.AttrLife.LabText = "0"
		end
	end
end

--@param format 单位 （例如%d天）
--@param duration 触发间隔
--@param remainTime 剩余时间
--@param threshold 剩余时间小于多少时进入下一阶段
function BeiluzCoreCtrl:StartRemainTimeTimer(format, duration, remainTime, threshold, unitStep)
	self.panel.AttrLife.LabText = StringEx.Format(format,math.floor(remainTime/unitStep))
	self.timer = Timer.New(function()
		remainTime = remainTime - duration
		if remainTime <= threshold then
			self:RefreshCurAttInfo()
		else
			self.panel.AttrLife.LabText = StringEx.Format(format,math.floor(remainTime/unitStep))
		end
	end,duration,-1,true)
	self.timer:Start()
end

-- 检查技能是否已失效
-- 逻辑：相同互斥ID的技能，只生效ClassLevel最高的那个，ClassLevel相同时，生效第一个
function BeiluzCoreCtrl:CheckAttrInvalid(attr, pos, attrIndex)
	local wheelSkillConfig = TableUtil.GetWheelSkillTable().GetRowById(attr.TableID)
	if not wheelSkillConfig then return false end
	local curLv = wheelSkillConfig.ClassLevel
	local curClassID = wheelSkillConfig.ClassId
	for i=1, l_mgr.MAX_SLOT_COUNT do
		if l_mgr.g_equippedCoreList[i] then
			local skillIDs = l_mgr.g_equippedCoreList[i]:GetAttrsByType(GameEnum.EItemAttrModuleType.BelluzGear)
			for j=1,#skillIDs do
				local tempWheelSkillCfg = TableUtil.GetWheelSkillTable().GetRowById(skillIDs[j].TableID)
				if tempWheelSkillCfg and tempWheelSkillCfg.ClassId == curClassID and tempWheelSkillCfg.ClassLevel >= curLv and not(i==pos and j== attrIndex) then
					return true
				end
			end
		end
	end
	return false
end

function BeiluzCoreCtrl:ForceRebuildAllLayout()
	self:ForceRebuildAttrLayout()
	self:ForceRebuildWeightLayout()
end

function BeiluzCoreCtrl:ForceRebuildAttrLayout()
	UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.panel.AttContent.RectTransform)
end

function BeiluzCoreCtrl:ForceRebuildWeightLayout()
	UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.panel.TotalWeightContent.RectTransform)
end

function BeiluzCoreCtrl:OnClickTgl(value, pos)
	if l_mgr.IsSlotUnlock(pos) then
		self:RefreshRightUI(value,pos)
	else
		if value then
			self.panel.TglCore[pos].Tog.isOn = false
			MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("WHEEL_SLOT_LOCK_TIP"))
		end
	end
end

function BeiluzCoreCtrl:OnBtnClose()
	UIMgr:DeActiveUI(UI.CtrlNames.BeiluzCore)
end

-- 点击“镶嵌”
function BeiluzCoreCtrl:OnBtnEquip(data)

	local remainingTime = l_mgr.GetCoreRemainTimeInSeconds(data)
	if remainingTime <= 0 then
		if MgrMgr:GetMgr("OpenSystemMgr").IsSystemOpen(MgrMgr:GetMgr("OpenSystemMgr").eSystemId.BeiluzMaintain) then
			self:OnBtnMaintenance(data)
		else
			local tipStr = StringEx.Format(Common.Utils.Lang("WHEEL_LIFE_ZERO_INVALID_WARNING"),data.ItemConfig.ItemName)
			MgrMgr:GetMgr("TipsMgr").ShowNormalTips(tipStr)
		end
		return
	end

	if self.curSelectPos <= 0 and l_mgr.g_fullEquipped then
		MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("WHEEL_SLOT_FULL_TIP"))--没有空槽未
		return
	end

	local totalWeight = l_mgr.g_equippedWeight + data.Weight
	if totalWeight > l_mgr.maxWeight then
		local tipStr = StringEx.Format(Common.Utils.Lang("WHEEL_OVERWEIGHT_WARNING"), l_mgr.maxWeight, l_mgr.maxWeight - l_mgr.g_equippedWeight)
		MgrMgr:GetMgr("TipsMgr").ShowNormalTips(tipStr)
		return
	end

	if self.curModelState == l_mgr.BEILUZCORE_MODEL_STATE.Close then
		self:openModel(false,data)
		return
	end

	if self.curSelectPos <= 0 then
		if self.curModelState == l_mgr.BEILUZCORE_MODEL_STATE.Open then
			self.curSelectPos = self:_getNextEmptyPos()
			self:OnClickTgl(true,self.curSelectPos)
		end
	end

	if remainingTime < l_mgr.warningTime * l_mgr.dayToSeconds then
		local tipStr = StringEx.Format(Common.Utils.Lang("WHEEL_LIFE_LOW_WARNING",data.ItemConfig.ItemName, l_mgr.warningTime))
		MgrMgr:GetMgr("TipsMgr").ShowNormalTips(tipStr)
	end

	Data.BagApi:ReqSwapItem(data.UID, GameEnum.EBagContainerType.BeiluzCore, self.curSelectPos - 1, 1)		-- 传服务器的ID下标从0开始，客户端ID下标从1开始
end

function BeiluzCoreCtrl:OnBtnItemIcon(data)
	MgrMgr:GetMgr("ItemTipsMgr").ShowTipsDisplayWithInfo(data)
end

function BeiluzCoreCtrl:OnBtnUnload()
	local data = l_mgr.g_equippedCoreList[self.curSelectPos]
	if data then
		Data.BagApi:ReqSwapItem(data.UID, GameEnum.EBagContainerType.Bag, nil, 1)
	end
end

function BeiluzCoreCtrl:OnBtnMaintenance(data)

    local OpenSystemMgr = MgrMgr:GetMgr("OpenSystemMgr")
    if not OpenSystemMgr.IsSystemOpen(OpenSystemMgr.eSystemId.BeiluzMaintain) then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("SYSTEM_DONT_OPEN"))
        return
    end

	local tempData = data
	if not tempData then
		tempData = l_mgr.g_equippedCoreList[self.curSelectPos]
	end
	if tempData then
		l_mgr.WheelMaintainConfirm(tempData.UID)
	end
end

-- Item更新
function BeiluzCoreCtrl:OnItemChangeBroadCast(itemUpdateInfoList)
	if nil == itemUpdateInfoList then
		logError("[LandingAwardMgr] invalid param")
		return
	end
	local contType = GameEnum.EBagContainerType

	--- 通过新旧容器类型判断是否有镶嵌/卸载操作
	local needUnLoadTip = false
	local itemData = nil
	local needRefreshUI = false
	for i = 1, #itemUpdateInfoList do
		local singleData = itemUpdateInfoList[i]
		if singleData:GetNewOrOldItem().ItemConfig.TypeTab == GameEnum.EItemType.BelluzGear then
			needRefreshUI = true
			if singleData.NewContType == contType.BeiluzCore and singleData.OldContType == contType.Bag then
				local tipStr = StringEx.Format(Common.Utils.Lang("WHEEL_EQUIP_SUCCESS"),singleData.NewItem.ItemConfig.ItemName)
				MgrMgr:GetMgr("TipsMgr").ShowNormalTips(tipStr)
				needUnLoadTip = false
				break
			elseif singleData.NewContType == contType.Bag and singleData.OldContType == contType.BeiluzCore then
				needUnLoadTip = true
				itemData = singleData.NewItem
			end
		end
		if singleData.NewItem and l_mgr.IsEquipRelativeMat(singleData.NewItem.ItemConfig.ItemID) then
			needRefreshUI = true
		end
	end
	if needUnLoadTip and itemData then
		local tipStr = nil
		if l_mgr.GetActiveState(itemData) == l_mgr.E_ACTIVE_STATE.NoLife then
			tipStr = StringEx.Format(Common.Utils.Lang("WHEEL_EQUIP_NOLIFE"))
		else
			tipStr = StringEx.Format(Common.Utils.Lang("WHEEL_UNEQUIP_SUCCESS"),itemData.ItemConfig.ItemName)
		end
		MgrMgr:GetMgr("TipsMgr").ShowNormalTips(tipStr)
	end

	if needRefreshUI then
		self:RefreshData()
		self:RefreshTotalWeight()
		self:RefreshSlotUI()
		self:RefreshRightUI(true,self.curSelectPos)
		self:RefreshOverloadInfo()
		self:RefreshWheelModel()
		self:RefreshAnimation()
		self:RefreshEffect()
		l_mgr.UpdateEquipInfo()
		--l_mgr.l_eventDispatcher:Dispatch(l_mgr.SIG_WHEEL_GREY_STATE_UPDATE)
	end
end

function BeiluzCoreCtrl:_switchModelState(immediately)
	if self.curModelState == l_mgr.BEILUZCORE_MODEL_STATE.Open then
		self:closeModel(immediately)
	elseif self.curModelState == l_mgr.BEILUZCORE_MODEL_STATE.Close then
		self:openModel(immediately)
	end
end

function BeiluzCoreCtrl:openModel(immediately,data)
	if not self.model then return end
	if immediately then
		self.curModelState = l_mgr.BEILUZCORE_MODEL_STATE.Open
		self.model.Ator:Play(l_animClip.move,1)
		self:RefreshAnimation(true)
		self:RefreshEffect()
		self.panel.BtnModelStateSwitch.enabled = true
		self.panel.RawImageBtn:SetActiveEx(false)
	elseif self.aniTimer == nil then		-- 等待其它操作结束
		self.panel.BtnModelStateSwitch.enabled = false
		self.panel.RawImageBtn:SetActiveEx(false)
		MLuaCommonHelper.SetLocalScale(self.model.UObj, 15, 15, 15)
		MLuaCommonHelper.SetLocalPos(self.model.UObj, 0, 0.9, 0)

		self.aniTimer = Timer.New(function()
			if self.model and self.model.Ator then
				if self.model.Ator:InState(l_animClip.idle) then
					self.model.Ator:Play(l_animClip.open)
					self:RefreshEffect()
				elseif self.model.Ator:InState(l_animClip.open) then
					if self.model.Ator:GetCurrentAnimInfo().NormalizedTime >= 1 then
						self.model.Ator:Play(l_animClip.move)
						self.curModelState = l_mgr.BEILUZCORE_MODEL_STATE.Open
						self:RefreshAnimation(true)
						self:RefreshEffect()
						self.aniTimer:Stop()
						self.aniTimer = nil
						self.panel.BtnModelStateSwitch.enabled = true
						if data then
							self:OnBtnEquip(data)
						end
						self:_checkGuild()
					end
				end
			end
		end,0.034,-1,true)
		self.aniTimer:Start()
	end
end

function BeiluzCoreCtrl:closeModel(immediately)
	if not self.model then return end
	if immediately then
		self.model.Ator:Play(l_animClip.idle,1)
		self:RefreshAnimation(true)
		self:RefreshEffect()
		self.panel.BtnModelStateSwitch.enabled = true
		self.panel.RawImageBtn:SetActiveEx(true)
		self.curModelState = l_mgr.BEILUZCORE_MODEL_STATE.Close
	elseif self.aniTimer == nil then
		self.curModelState = l_mgr.BEILUZCORE_MODEL_STATE.Close
		self.panel.BtnModelStateSwitch.enabled = false

		self.aniTimer = Timer.New(function()
			if self.model and self.model.Ator then
				if self.model.Ator:InState(l_animClip.move) then
					self.model.Ator.Speed = 1
					self.model.Ator:Play(l_animClip.close)
				elseif self.model.Ator:InState(l_animClip.close) then
					if self.model.Ator:GetCurrentAnimInfo().NormalizedTime >= 1 then
						self.model.Ator:Play(l_animClip.idle)
						self:RefreshEffect()
					end
				elseif self.model.Ator:InState(l_animClip.idle) then
					self.model.Ator.Speed = 1
					self.aniTimer:Stop()
					self.aniTimer = nil
					self.panel.BtnModelStateSwitch.enabled = true
					self.panel.RawImageBtn:SetActiveEx(true)
				end
			end
		end,0.034,-1,true)
		self.aniTimer:Start()
	end
end

function BeiluzCoreCtrl:OnBtnTips(go, eventData)
	local l_anchor = Vector2.New(0.5, 1)
	local pos = Vector2.New(eventData.position.x, eventData.position.y)
	eventData.position = pos
	MgrMgr:GetMgr("TipsMgr").ShowQuestionTip(Common.Utils.Lang("WHEEL_BAG_RULE_MAIN"), eventData, l_anchor)
end

function BeiluzCoreCtrl:OnBtnOverloadTip(go,eventData)
	local l_anchor = Vector2.New(0.5, 1)
	local pos = Vector2.New(eventData.position.x, eventData.position.y)
	eventData.position = pos
	MgrMgr:GetMgr("TipsMgr").ShowQuestionTip(Common.Utils.Lang("WHEEL_BAG_OVERLOAD_TIPS"..l_mgr.GetCurAppearanceEffectID()), eventData, l_anchor)
end

function BeiluzCoreCtrl:OnBtnGetWay()
	UIMgr:ActiveUI(UI.CtrlNames.ItemAchieveTipsNew, function(l_ui)
		l_ui:InitItemAchievePanelByItemId(l_mgr.BEILUZCORE_GET_WAY_ID)
	end)
end

function BeiluzCoreCtrl:OnBtnCombine()
	l_mgr.OpenOperationPanelByType(l_mgr.EOperationType.Combine)
end

function BeiluzCoreCtrl:OnBtnReset()
	l_mgr.OpenOperationPanelByType(l_mgr.EOperationType.Reset)
end

-- 从背包点击 保养，镶嵌进入齿轮背包时，触发对应事件
function BeiluzCoreCtrl:_handleOpenFunction()
	if self._inGuild then return end	--引导中则不打开贝鲁兹核心
	if self.uiPanelData then
		if self.uiPanelData.Type == l_mgr.BEILUZCORE_OPEN_FUNC.Maintain then
			self:_switchModelState(true)
			self.coreBagListPool:ShowTemplates({ Datas = self:GetCoreList(), StartScrollIndex = self:_getCoreIndexInBag(self.uiPanelData.UID)})
			l_mgr.WheelMaintainConfirm(self.uiPanelData.UID)
		elseif self.uiPanelData.Type == l_mgr.BEILUZCORE_OPEN_FUNC.Equip then
			self:_switchModelState(true)
			self.coreBagListPool:ShowTemplates({ Datas = self:GetCoreList(), StartScrollIndex = self:_getCoreIndexInBag(self.uiPanelData.UID)})
		end
		self.uiPanelData = nil
	else
		self:_switchModelState()
	end
end

-- 引导
function BeiluzCoreCtrl:_checkGuild()
	if #self:GetCoreList() > 0 then
		local l_beginnerGuideChecks = {"WheelGuide3"}
		MgrMgr:GetMgr("BeginnerGuideMgr").CheckShowBeginnerGuide(l_beginnerGuideChecks, self:GetPanelName())
	end
end

-- 没有齿轮且没有完成引导任务时
function BeiluzCoreCtrl:GuideIfNeed()
	self.panel.TaskLink:SetActiveEx(false)
	local needGuide,nextGuideID = l_mgr.NeedGuide()
	if needGuide then
		self.panel.TaskLink:SetActiveEx(true)
		self.panel.TaskLink.LabText = Common.Utils.Lang("WHEEL_ACHIEVE_TASK",Common.CommonUIFunc.GetCommonRichText("WHEEL_ACHIEVE_TASL",RoColor.Tag.Blue,Common.Utils.Lang("WHEEL_GUID_TXT")))
		self.panel.TaskLink:GetRichText().onHrefClick:RemoveAllListeners()
		self.panel.TaskLink:GetRichText().onHrefClick:AddListener(function()
			UIMgr:DeActiveUI(UI.CtrlNames.BeiluzCore)
			UIMgr:DeActiveUI(UI.CtrlNames.Bag)
			MgrMgr:GetMgr("TaskMgr").OnQuickTaskClickWithTaskId(nextGuideID)
		end)
	end
	self._inGuild = needGuide
	self.panel.Main:SetActiveEx(not needGuide)
end

-- 获取齿轮在背包列表里的Index
function BeiluzCoreCtrl:_getCoreIndexInBag(UID)
	local tUID = tostring(UID)
	for i,v in ipairs(self:GetCoreList()) do
		if tostring(v.UID) == tUID then
			return i
		end
	end
	return 1
end

function BeiluzCoreCtrl:_getNextEmptyPos()
	for i=1,l_mgr.MAX_SLOT_COUNT do
		if not l_mgr.g_equippedCoreList[i] then
			return i
		end
	end
	return -1
end

--- 模型，特效，动画相关
-- RawImage展示3D模型
function BeiluzCoreCtrl:InitModel()
	self:_clearModel()
	self.wheelModelCache = {}
	self.wheelEffectCache = {}

	local l_fxData = {}
	l_fxData.rawImage = self.panel.RawImage.RawImg
	l_fxData.prefabPath = "Prefabs/Item_Collect_BeiLuZi_Ring"
	l_fxData.width = 1024
	l_fxData.height = 1024
	l_fxData.enablePostEffect = false
	self.model = self:CreateUIModel(l_fxData)
	self.model:AddLoadModelCallback(function(model)
		MLuaCommonHelper.SetLocalScale(model.UObj, 15, 15, 15)
		MLuaCommonHelper.SetLocalPos(model.UObj, 0, 0.9, 0)

		for i = 1,l_mgr.MAX_SLOT_COUNT do
			self.wheelRoot[i] = model.Trans:Find(l_wheelRoot[i]).gameObject
			self.effectRoot[i] = model.Trans:Find(l_effWheelRoot[i]).gameObject
		end

		for k,v in pairs(l_effType) do
			self.effectRoot[k] = model.Trans:Find(v).gameObject
		end
		for k,v in pairs(l_animClip) do
			self.model.Ator:OverrideAnim(v,l_animClipSource[v])
		end
		self.model.Ator:Play(l_animClip.idle)
		self:RefreshWheelModel()
		self:RefreshEffect()

		self:_handleOpenFunction()
	end)
end

-- 刷新3个齿轮模型
function BeiluzCoreCtrl:RefreshWheelModel()
	for i=1, l_mgr.MAX_SLOT_COUNT do
		local quality = 0
		if l_mgr.g_equippedCoreList[i] then
			quality = l_mgr.g_equippedCoreList[i].ItemConfig.ItemQuality
		end
		self:_createWheel(quality,i)
	end
end

--刷新特效：三个状态需要的特效不同：关闭自转时，打开过程中，打开转动时
function BeiluzCoreCtrl:RefreshEffect()
	local step = 1
	if self.model then
		if self.model.Ator:InState(l_animClip.idle) then
			step = 1
		elseif self.model.Ator:InState(l_animClip.close) then
			step = 3
		elseif self.model.Ator:InState(l_animClip.open) then
			step = 2
		elseif self.model.Ator:InState(l_animClip.move) then
			step = 3
		end
	end

	local idleEffActive = (step == 1)
	local halfCircleEffActive = (step == 2 or (step == 3 and l_mgr.g_fullEquipped))
	local openEffActive = (step == 2 or step == 3)
	local circleEffActive = (step == 3 and l_mgr.g_fullEquipped)
	if self.effectRoot.idleEffect then self.effectRoot.idleEffect:SetActiveEx(idleEffActive) end
	if self.effectRoot.halfCircleEffect1 then self.effectRoot.halfCircleEffect1:SetActiveEx(halfCircleEffActive) end
	if self.effectRoot.halfCircleEffect2 then self.effectRoot.halfCircleEffect2:SetActiveEx(halfCircleEffActive) end
	if self.effectRoot.openEffect then self.effectRoot.openEffect:SetActiveEx(openEffActive) end
	for i = 1,l_mgr.MAX_SLOT_COUNT do
		if self.effectRoot[i] then self.effectRoot[i]:SetActiveEx(circleEffActive) end
	end
	self:_refreshModelRender()
end

-- 控制齿轮转动还是停止
function BeiluzCoreCtrl:RefreshAnimation(immediately)
	if self.model and self.model.Ator:InState(l_animClip.move) then
		if self:_allUnlockAndEquipped() then
			self:_resumeAnimation(immediately)
		else
			self:_pauseAnimation(immediately)
		end
	end
end

-- 所有槽位都解锁且镶嵌了贝鲁兹
function BeiluzCoreCtrl:_allUnlockAndEquipped()
	for i=1,l_mgr.MAX_SLOT_COUNT do
		if not l_mgr.IsSlotUnlock(i) or l_mgr.g_equippedCoreList[i] == nil then
			return false
		end
	end
	return true
end

function BeiluzCoreCtrl:_resumeAnimation(immediately)
	if self.model then
		if self.pauseTimer then
			self.pauseTimer:Stop()
			self.pauseTimer = nil
		end
		if immediately then
			self.model.Ator.Speed = 1
		else
			self.pauseTimer = Timer.New(function()
				if self.model and self.model.Ator.Speed < 1 then
					self.model.Ator.Speed = self.model.Ator.Speed + c_acceleration
				elseif self.pauseTimer then
					self.pauseTimer:Stop()
					self.pauseTimer = nil
				end
			end,0.034,-1,true)
			self.pauseTimer:Start()
		end
	end
end

function BeiluzCoreCtrl:_pauseAnimation(immediately)
	if self.model and self.curModelState == l_mgr.BEILUZCORE_MODEL_STATE.Open then
		if self.pauseTimer then
			self.pauseTimer:Stop()
			self.pauseTimer = nil
		end

		if immediately then
			self.model.Ator.Speed = 0
		else
			self.pauseTimer = Timer.New(function()
				if self.model and self.model.Ator.Speed > 0 then
					self.model.Ator.Speed = self.model.Ator.Speed - c_acceleration
				elseif self.pauseTimer then
					self.pauseTimer:Stop()
					self.pauseTimer = nil
				end
			end,0.034,-1,true)
			self.pauseTimer:Start()
		end
	end
end

function BeiluzCoreCtrl:_createWheel(quality, pos)
	if self.wheelModelCache[pos] then
		if self.wheelModelCache[pos].quality == quality then
			return
		else
			if self.wheelModelCache[pos].obj then
				MResLoader:DestroyObj(self.wheelModelCache[pos].obj)
				self.wheelModelCache[pos] = nil
			end
			if self.wheelEffectCache[pos] then
				MResLoader:DestroyObj(self.wheelEffectCache[pos])
				self.wheelEffectCache[pos] = nil
			end
		end
	end
	self.wheelModelCache[pos] = {}
	self.wheelModelCache[pos].quality = quality
	-- 先加载模型，再加载特效
	MResLoader:CreateObjAsync(string.format("Prefabs/%s", l_mgr.BEILUZCORE_WHEEL_PATH[quality]),function(uobj, sobj, taskId)
		if self.wheelRoot[pos] then
			self.wheelModelCache[pos].obj = uobj
			MLuaCommonHelper.SetParent( uobj, self.wheelRoot[pos])
			MLuaCommonHelper.SetLocalPos(uobj, 0, 0, 0)
			uobj:SetLocalRotEuler(0, 0, 0)
			if quality > 0 then
				MResLoader:CreateObjAsync(string.format("Effects/Prefabs/Creature/Ui/%s", l_mgr.BEILUZCORE_EFFECT_PATH[quality]),function(uobj, sobj, taskId)
					if self.effectRoot[pos] then
						self.wheelEffectCache[pos] = uobj
						MLuaCommonHelper.SetParent( uobj, self.effectRoot[pos])
						MLuaCommonHelper.SetLocalPos(uobj, 0, 0, 0)
						uobj:SetLocalRotEuler(0, 0, 0)
						self:_refreshModelRender()
					else
						MResLoader:DestroyObj(uobj)
					end
				end,self)
			else
				self:_refreshModelRender()
			end
		else
			MResLoader:DestroyObj(uobj)
		end
	end,self)
end

function BeiluzCoreCtrl:_refreshModelRender()
	if self.model then
		MUIModelManagerEx:RefreshModel(self.model)
	end
end

function BeiluzCoreCtrl:_clearModel()

	if self.aniTimer then
		self.aniTimer:Stop()
		self.aniTimer = nil
	end
	if self.pauseTimer then
		self.pauseTimer:Stop()
		self.pauseTimer = nil
	end

	for k,v in pairs(self.wheelModelCache or {}) do
		if v and v.obj then
			MResLoader:DestroyObj(v.obj)
		end
	end
	self.wheelModelCache = nil

	for k,v in pairs(self.wheelEffectCache or {}) do
		if v then
			MResLoader:DestroyObj(v)
		end
	end
	self.wheelEffectCache = nil

	if self.model then
		self:DestroyUIModel(self.model)
	end
	self.model = nil
end
--- 模型，动画，特效相关

--lua custom scripts end
return BeiluzCoreCtrl