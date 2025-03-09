--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseHandler"
require "UI/Panel/BeiluzCoreSynthesisPanel"
require "UI/Template/BeiluzCoreCombineTemplate"
--lua requires end

--lua model
module("UI", package.seeall)

--lua model end

--lua fields
local super = UI.UIBaseHandler
--lua fields end

--lua class define
BeiluzCoreSynthesisHandler = class("BeiluzCoreSynthesisHandler", super)
local l_mgr = MgrMgr:GetMgr("BeiluzCoreMgr")
local l_attrMgr = MgrMgr:GetMgr("AttrDescUtil")
local maxMatCostNum = 2

local resetCountLimit = {
	Junior = 2,
	Senior = 4
}

local CombineRuleTipe = {
	[2] = "WHEEL_COMBINE_RULE_TWO_TIP",
	[4] = "WHEEL_COMBINE_RULE_FOUR_TIP",
}

--lua class define end

--lua functions
function BeiluzCoreSynthesisHandler:ctor()
	
	super.ctor(self, HandlerNames.BeiluzCoreSynthesis, 0)
	
end --func end
--next--
function BeiluzCoreSynthesisHandler:Init()
	
	self.panel = UI.BeiluzCoreSynthesisPanel.Bind(self)
	super.Init(self)

	self:_customInit()
	
end --func end
--next--
function BeiluzCoreSynthesisHandler:Uninit()
	
	super.Uninit(self)
	self.panel = nil
	
end --func end
--next--
function BeiluzCoreSynthesisHandler:OnShow()

	self:ResetData()
	self:RefreshSlotUI()
	self:_refreshResultUI()
	self:_refreshCoreList(l_mgr.BEILUZCORE_TYPE_ITEM_IDS[l_mgr.BEILUZCORE_QUALITY.None])
	self:_handleOpenBehaviour()
	self:_checkGuild()
	
end --func end
--next--
function BeiluzCoreSynthesisHandler:OnDeActive()

	l_mgr.g_combineWheelCost = false
	
end --func end
--next--
function BeiluzCoreSynthesisHandler:Update()
	
	
end --func end
--next--
function BeiluzCoreSynthesisHandler:BindEvents()

	self:BindEvent(MgrProxy:GetGameEventMgr().l_eventDispatcher,MgrProxy:GetGameEventMgr().OnBagUpdate,self._onItemChangeBroadCast,self)
	self:BindEvent(l_mgr.l_eventDispatcher, l_mgr.SIG_COMBINE_REFRESH_SLOTUI,self.OnRefreshSlotUI,self)
	self:BindEvent(l_mgr.l_eventDispatcher, l_mgr.SIG_COMBINE_CLEAR_SHOW_ITEM,self.ClearShowItem,self)
	
end --func end
--next--

function BeiluzCoreSynthesisHandler:OnReconnected(roleData)

	self.curShowItem = nil

	self:RefreshSlotUI()
	self:_refreshResultUI()
	self:_refreshCoreList(l_mgr.BEILUZCORE_TYPE_ITEM_IDS[l_mgr.BEILUZCORE_QUALITY.None])

end --func end

--lua functions end

--lua custom scripts

function BeiluzCoreSynthesisHandler:ResetData()
	l_mgr.g_selectedList = {}
	l_mgr.g_newCoreList = {}		-- "新"生成的核心列表
	l_mgr.g_combineWheelCost = false
	self.curShowItem = nil
end

function BeiluzCoreSynthesisHandler:_customInit()

	self.dropdownIndex = 0
	l_mgr.g_combineSlotCount = l_mgr.ECombineType.Common

	self:_setTip()

	self.panel.BtnCombine:AddClickWithLuaSelf(self._onBtnCombine,self)
	self.panel.TopItemBG:AddClickWithLuaSelf(self._onBtnCurShow,self)
	self.panel.BtnTip.Listener:SetActionClick(self._onBtnTips,self)
	self.panel.BtnGetWay:AddClickWithLuaSelf(self._onBtnGetWay,self)
	self.panel.BtnSkillPreview:AddClickWithLuaSelf(self.OnBtnSkillPreview,self)

	self.panel.ModelSwitch[1]:OnToggleExChanged(function(value)
		self:SwitchModel(l_mgr.ECombineType.Common)
	end)

	self.panel.ModelSwitch[2]:OnToggleExChanged(function(value)
		self:SwitchModel(l_mgr.ECombineType.Double)
	end)

	for i=1,l_mgr.MAX_COMBINE_MAT_SLOT_COUNT do
		self.panel.MatButton[i]:AddClick(function()
			local oldData = l_mgr.g_selectedList[i]
			if oldData then
				l_mgr.g_selectedList[i] = nil
				l_mgr.l_eventDispatcher:Dispatch(l_mgr.SIG_COMBINE_UPDATE_SELECTABLE,l_mgr.GetFirstEquippedSlotIndex())
				l_mgr.l_eventDispatcher:Dispatch(l_mgr.SIG_COMBINE_CANCEL_SELECT_ITEM,oldData.UID)
			end
			self:RefreshSlotUIByIndex(i)
		end)
	end

	for i=1,l_mgr.MAX_COMBINE_MAT_SLOT_COUNT do
		self.panel.ItemSub[i]:AddClick(function()
			local oldData = l_mgr.g_selectedList[i]
			if oldData then
				l_mgr.g_selectedList[i] = nil
				--self.newCoreList[oldData.UID] = nil
				l_mgr.l_eventDispatcher:Dispatch(l_mgr.SIG_COMBINE_UPDATE_SELECTABLE,l_mgr.GetFirstEquippedSlotIndex())
				l_mgr.l_eventDispatcher:Dispatch(l_mgr.SIG_COMBINE_CANCEL_SELECT_ITEM,oldData.UID)
			end
			self:RefreshSlotUIByIndex(i)
		end)
	end

	for i=1,l_mgr.MAX_COMBINE_MAT_SLOT_COUNT do
		for j=1, l_mgr.MAX_ATTR_COUNT do
			local index = (i - 1) * l_mgr.MAX_ATTR_COUNT + j
			self.panel.MatSkillName[index]:AddClick(function()
				l_mgr.ShowSkillDesc(l_mgr.g_selectedList[i],j,self.panel.MatSkillName[index].transform.position)
			end)
		end
	end

	for i=1, l_mgr.MAX_ATTR_COUNT do
		self.panel.TopSkillName[i]:AddClick(function()
			l_mgr.ShowSkillDesc(self.curShowItem,i,self.panel.TopSkillName[i].transform.position)
		end)
	end

	for i=1,maxMatCostNum do
		self.panel.MatIconBtn[i]:AddClick(function()
			self:_onBtnMatIcon(i)
		end)
	end

	self.coreItemTemplatePool = self:NewTemplatePool({
		UITemplateClass = UITemplate.BeiluzCoreCombineTemplate,
		ScrollRect = self.panel.CoreList.LoopScroll,
	})

	self.l_itemTemplate = {}
	for i=1,l_mgr.MAX_COMBINE_MAT_SLOT_COUNT do
		self.l_itemTemplate[i] = self:NewTemplate("ItemTemplate", {
			TemplateParent = self.panel.MatItemRoot[i].gameObject.transform,
		})
	end

	self.TopItemTemplate = self:NewTemplate("ItemTemplate", {
		TemplateParent = self.panel.TopItem.gameObject.transform,
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
		self:_refreshCoreList(l_mgr.BEILUZCORE_TYPE_ITEM_IDS[index])
	end
	-- 初始化
	self.panel.Dropdown.DropDown.value = self.dropdownIndex
	self.panel.Dropdown.DropDown.onValueChanged:AddListener(l_onValueChanged)
end

-- 根据类型刷新右侧列表
function BeiluzCoreSynthesisHandler:_refreshCoreList(TID,offset)
	local tOffset = offset and offset or 0
	local tData = l_mgr.GetSortedBagCoreListByTID(TID,l_mgr.SortByCombinePanelRule)
	if l_mgr.g_combineSlotCount == l_mgr.ECombineType.Double then
		tData = l_mgr.FilterDoubleAttrCore(tData)
	end
	self.panel.EmptyTip:SetActiveEx(#tData == 0)
	local startIndex = self.coreItemTemplatePool:GetCellStartIndex() + tOffset
	if startIndex > #tData then
		startIndex = #tData
	end
	self.coreItemTemplatePool:ShowTemplates({Datas = tData,StartScrollIndex = startIndex})
end

function BeiluzCoreSynthesisHandler:OnRefreshSlotUI(index)
	if index then
		self:RefreshSlotUIByIndex(index)
	else
		self:RefreshSlotUI()
	end
end

function BeiluzCoreSynthesisHandler:RefreshSlotUI()
	for i =1,l_mgr.MAX_COMBINE_MAT_SLOT_COUNT do
		self:RefreshSlotUIByIndex(i)
	end
end

function BeiluzCoreSynthesisHandler:RefreshSlotUIByIndex(index)
	local data = l_mgr.g_selectedList[index]
	if index > l_mgr.g_combineSlotCount then
		self.panel.MatRoot[index]:SetActiveEx(false)
	else
		self.panel.MatRoot[index]:SetActiveEx(true)
	end

	if data == nil then
		self.panel.Mat[index]:SetActiveEx(false)
	else
		self.panel.Mat[index]:SetActiveEx(true)

		local itemData={
			PropInfo = data,
			IsShowCount = false,
			HideButton = true,
		}
		self.l_itemTemplate[index]:SetData(itemData)

		local skillIDs = data:GetAttrsByType(GameEnum.EItemAttrModuleType.BelluzGear)
		for i = 1,l_mgr.MAX_ATTR_COUNT do
			local idx = (index - 1) * l_mgr.MAX_ATTR_COUNT + i
			if skillIDs[i] then
				local wheelSkillCfg = TableUtil.GetWheelSkillTable().GetRowById(skillIDs[i].TableID)
				if not wheelSkillCfg then return end
				local quality = wheelSkillCfg.SkillQuality
				local color = l_mgr.C_BEILUZCORE_SKILL_COLOR_MAP[quality]
				local attr = l_attrMgr.GetAttrStr(skillIDs[i], color)
				self.panel.MatSkillName[idx].LabText = attr.Name
				self.panel.MatSkillName[idx]:SetActiveEx(true)
			else
				self.panel.MatSkillName[idx]:SetActiveEx(false)
			end
		end
	end
	self:_refreshTip()
	self:_refreshMatCost()
	self.panel.BtnSkillPreview:SetActiveEx(not l_mgr.IsCombineSelectListEmpty())
end

-- 左上角合成结果UI
function BeiluzCoreSynthesisHandler:_refreshResultUI()
	if self.curShowItem  then
		self.panel.TopItemRoot:SetActiveEx(true)
		local itemData={
			PropInfo = self.curShowItem,
			IsShowCount = false,
			HideButton = true,
		}
		self.TopItemTemplate:SetData(itemData)
		self.panel.TopName.LabText = self.curShowItem.ItemConfig.ItemName

		local skillIDs = self.curShowItem:GetAttrsByType(GameEnum.EItemAttrModuleType.BelluzGear)
		for i=1, l_mgr.MAX_ATTR_COUNT do
			if skillIDs[i] then
				local wheelSkillCfg = TableUtil.GetWheelSkillTable().GetRowById(skillIDs[i].TableID)
				if not wheelSkillCfg then return end
				local quality = wheelSkillCfg.SkillQuality
				local color = l_mgr.C_BEILUZCORE_SKILL_COLOR_MAP[quality]
				local attr = l_attrMgr.GetAttrStr(skillIDs[i], color)
				self.panel.TopSkillName[i].LabText = attr.Name
				self.panel.TopSkillName[i]:SetActiveEx(true)
			else
				self.panel.TopSkillName[i]:SetActiveEx(false)
			end
		end
	else
		self.panel.TopItemRoot:SetActiveEx(false)
	end
end

-- “合成”按钮上方Tips
function BeiluzCoreSynthesisHandler:_refreshTip()
	local count = 0
	for i=1,l_mgr.MAX_COMBINE_MAT_SLOT_COUNT do
		if l_mgr.g_selectedList[i] then
			count = count + 1
		end
	end
	local tipStr = nil
	if l_mgr.g_combineSlotCount == l_mgr.ECombineType.Common then
		tipStr = Common.Utils.Lang("WHEEL_COMBINE_RULE_TWO_TXT")
	elseif l_mgr.g_combineSlotCount == l_mgr.ECombineType.Double then
		tipStr = Common.Utils.Lang("WHEEL_COMBINE_RULE_FOUR_TXT")
	end
	self:_setTip(tipStr)
end

function BeiluzCoreSynthesisHandler:_setTip(str)
	if str == nil or str == "" then
		self.panel.TxtTip.LabText = Common.Utils.Lang("WHEEL_COMBINE_EMPTY_SELECT_TIP")
	else
		self.panel.TxtTip.LabText = str
	end
	UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.panel.Tip.RectTransform)
end

function BeiluzCoreSynthesisHandler:_refreshMatCost()
	local matData = self:_getMatCostData()
	if #matData == 0 then
		self.panel.MatCostRoot:SetActiveEx(false)
	else
		self.panel.MatCostRoot:SetActiveEx(true)
		for i=1,#matData do
			local data = matData[i]
			self.panel.MatIconBtn[i]:SetActiveEx(true)
			self.panel.MatCostIcon[i]:SetSprite(data.itemCfg.ItemAtlas,data.itemCfg.ItemIcon)
			local ownCount = Data.BagModel:GetCoinOrPropNumById(data.itemCfg.ItemID)
			if ownCount >= data.count then
				self.panel.MatCostNum[i].LabText = data.count
			else
				self.panel.MatCostNum[i].LabText =StringEx.Format("<color=#F16754>{0}</color>",data.count)
			end
		end
		for i = #matData + 1,maxMatCostNum do
			self.panel.MatIconBtn[i]:SetActiveEx(false)
		end
	end
end

function BeiluzCoreSynthesisHandler:_getMatCostData()
	local result = {}
	local curType = 0
	local count = 0
	for i=1,l_mgr.MAX_COMBINE_MAT_SLOT_COUNT do
		if l_mgr.g_selectedList[i] then
			curType = l_mgr.g_selectedList[i].TID
			count = count + 1
		end
	end
	if count == l_mgr.g_combineSlotCount and curType ~= 0 then
		local cfg = TableUtil.GetWheelResetConsume().GetRowByWheelId(curType)
		if not cfg then return {} end
		local itemPairs = nil
		if count == resetCountLimit.Junior then
			itemPairs = cfg.WheelJuniorComposeConsume
		elseif count == resetCountLimit.Senior then
			itemPairs = cfg.WheelSeniorComposeConsume
		end
		for i = 0,itemPairs.Length - 1 do
			local data = {}
			local pair = itemPairs[i]
			local itemCfg = TableUtil.GetItemTable().GetRowByItemID(pair[0])
			if not itemCfg then break end
			local count = pair[1]
			data.itemCfg = itemCfg
			data.count = count
			result[i+1] = data
		end
	end
	return result
end

function BeiluzCoreSynthesisHandler:_handleOpenBehaviour()
	if l_mgr.Cache_CORE_UIDSTR then
		l_mgr.l_eventDispatcher:Dispatch(l_mgr.SIG_COMBINE_SELECT_ITEM, l_mgr.Cache_CORE_UIDSTR)
		l_mgr.Cache_CORE_UIDSTR = nil
	end
	self.ctrlRef:SetTitle(Common.Utils.Lang("WHEEL_TITL_COMBINE"))
end

function BeiluzCoreSynthesisHandler:clearSelect()
	l_mgr.g_selectedList = {}
end

function BeiluzCoreSynthesisHandler:_checkGuild()
	local bagList = l_mgr.GetBagCoreListByTID(0)
	if #bagList > 0 then
		local l_beginnerGuideChecks = {"WheelGuide4"}
		MgrMgr:GetMgr("BeginnerGuideMgr").CheckShowBeginnerGuide(l_beginnerGuideChecks, self.ctrlRef:GetPanelName())
	end
end

-- 隐藏右上角的齿轮
function BeiluzCoreSynthesisHandler:ClearShowItem()
	self.curShowItem = nil
	self:_refreshResultUI()
end

function BeiluzCoreSynthesisHandler:SwitchModel(model)
	l_mgr.g_combineSlotCount = model
	self:ResetData()
	self:RefreshSlotUI()
	self:_refreshResultUI()
	self:_refreshCoreList(l_mgr.BEILUZCORE_TYPE_ITEM_IDS[self.dropdownIndex])
end

-- 打开合成规则面板
function BeiluzCoreSynthesisHandler:_onBtnTips(go, eventData)
	local l_anchor = Vector2.New(1, 1)
	local pos = Vector2.New(eventData.position.x, eventData.position.y)
	eventData.position = pos

	MgrMgr:GetMgr("TipsMgr").ShowQuestionTip(Common.Utils.Lang("WHEEL_COMBINE_RULE_MAIN"), eventData, l_anchor)
end

function BeiluzCoreSynthesisHandler:_onBtnCombine()

	local OpenSystemMgr = MgrMgr:GetMgr("OpenSystemMgr")
	if not OpenSystemMgr.IsSystemOpen(OpenSystemMgr.eSystemId.BeiluzCombine) then
		MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("SYSTEM_DONT_OPEN"))
		return
	end

	local selectCount = 0
	local selectTID = 0
	local lowWeight = {}
	local doubleSkill = {}
	local allDoubleSkill = true
	local UIDList = {}
	local matEnough = true
	local lackMatID = nil
	for i=1,l_mgr.MAX_COMBINE_MAT_SLOT_COUNT do
		local tData = l_mgr.g_selectedList[i]
		if tData then
			selectCount = selectCount + 1
			if selectTID == 0 then
				selectTID = tData.TID
			elseif tData.TID ~= selectTID then
				logError("发生意外情况，选中了两个不同类型的齿轮。请记住操作步骤，联系前端@昱霖")
				return
			end
			table.insert(UIDList,tData.UID)
			if l_mgr.lowWeightConfig[tData.TID][tData.Weight] then
				table.insert(lowWeight,tData)
			end
			local attrs = tData:GetAttrsByType(GameEnum.EItemAttrModuleType.BelluzGear)
			if attrs[1] == nil or attrs[2] == nil then
				allDoubleSkill = false
			else
				table.insert(doubleSkill,tData)
			end
		end
	end

	if selectCount ~= l_mgr.g_combineSlotCount then
		MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang(CombineRuleTipe[l_mgr.g_combineSlotCount]))
		return
	end

	local cfg = TableUtil.GetWheelResetConsume().GetRowByWheelId(selectTID)
	if not cfg then return end
	local itemPairs = nil
	if selectCount == resetCountLimit.Junior then
		itemPairs = cfg.WheelJuniorComposeConsume
	elseif selectCount == resetCountLimit.Senior then
		itemPairs = cfg.WheelSeniorComposeConsume
	end
	for i = 0,itemPairs.Length - 1 do
		local pair = itemPairs[i]
		local count = pair[1]
		local have = Data.BagModel:GetCoinOrPropNumById(pair[0])
		if have < count then
			matEnough = false
			lackMatID = pair[0]
			break
		end
	end

	if not matEnough then
		MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("WHEEL_COMBINE_MAT_NOT_ENOUGH"))
		local itemData = Data.BagModel:CreateItemWithTid(lackMatID)
		MgrMgr:GetMgr("ItemTipsMgr").ShowTipsDisplay(itemData, nil, nil, nil, true)
		return
	end

	if #lowWeight > 0 or #doubleSkill > 0 then
		local l_consumeDatas = {}
		local confirmStr = nil
		local userDataKey = nil
		if #lowWeight > 0 then
			confirmStr = Lang(Common.Utils.Lang("WHEEL_COMBINE_RARE_WEIGHT_CONFIRM"),Common.CommonUIFunc.GetCommonRichText("LOW_WEIGHT_TIP",RoColor.Tag.Yellow,Common.Utils.Lang("RARE_WEIGHT")))
			userDataKey = "BEILUZ_COMBINE_LOW_WEIGHT_WARNING"
			for _,v in ipairs(lowWeight) do
				local datum = {}
				datum.PropInfo = v
				datum.IsShowCount = false
				datum.IsShowRequire = false
				datum.RequireCount = 1
				table.insert(l_consumeDatas,datum)
			end
		elseif #doubleSkill > 0 then
			confirmStr =  Common.Utils.Lang("WHEEL_COMBINE_DOUBLE_SKILL_CONFIRM")
			userDataKey = "BEILUZ_COMBINE_DOUBLE_SKILL_WARNING"
			for _,v in ipairs(doubleSkill) do
				local datum = {}
				datum.PropInfo = v
				datum.IsShowCount = false
				datum.IsShowRequire = false
				datum.RequireCount = 1
				table.insert(l_consumeDatas,datum)
			end
		end
		CommonUI.Dialog.ShowConsumeDlg("", confirmStr,
				function()
					l_mgr.reqCombineCore(UIDList)
				end, nil, l_consumeDatas,2,userDataKey,nil,nil,function(name,eventData)
					local l_anchor = Vector2.New(0.5, 0)
					local pos = Vector2.New(eventData.position.x, eventData.position.y)
					eventData.position = pos
					MgrMgr:GetMgr("TipsMgr").ShowQuestionTip(Common.Utils.Lang("WHEEL_COMBINE_RARE_WEIGHT_TIP"), eventData, l_anchor)
				end)
	else
		l_mgr.reqCombineCore(UIDList)
	end
end

---@param itemUpdateInfoList ItemUpdateData[]
function BeiluzCoreSynthesisHandler:_onItemChangeBroadCast(itemUpdateInfoList)
	if nil == itemUpdateInfoList then
		logError("[LandingAwardMgr] invalid param")
		return
	end
	--- 通过OldItem判断是否是新物品
	for i = 1, #itemUpdateInfoList do
		local singleData = itemUpdateInfoList[i]
		if singleData.OldItem == nil and singleData.NewItem.ItemConfig.TypeTab == Data.BagModel.PropType.Beiluz then
			if l_mgr.g_combineWheelCost then
				l_mgr.g_newCoreList[singleData.NewItem.UID] = true
				self.curShowItem = singleData.NewItem
				strTip = StringEx.Format(Common.Utils.Lang("WHEEL_COMBINE_SUCCESS"),singleData.NewItem.ItemConfig.ItemName)
				MgrMgr:GetMgr("TipsMgr").ShowNormalTips(strTip)
				l_mgr.g_combineWheelCost = false
			end
			self:clearSelect()
			self:_refreshResultUI()
			self:RefreshSlotUI()
			self:_refreshCoreList(l_mgr.BEILUZCORE_TYPE_ITEM_IDS[self.dropdownIndex],2)
		elseif singleData.NewItem == nil and singleData.OldItem.ItemConfig.TypeTab == Data.BagModel.PropType.Beiluz then
			l_mgr.g_combineWheelCost = true
		end
	end
end

-- 点击左上角新合成的齿轮
function BeiluzCoreSynthesisHandler:_onBtnCurShow()
	if self.curShowItem then
		MgrMgr:GetMgr("ItemTipsMgr").ShowTipsDisplayWithInfo(self.curShowItem)
	end
end

function BeiluzCoreSynthesisHandler:_onBtnGetWay()
	UIMgr:ActiveUI(UI.CtrlNames.ItemAchieveTipsNew, function(l_ui)
		l_ui:InitItemAchievePanelByItemId(l_mgr.BEILUZCORE_GET_WAY_ID)
		l_ui:SetRelativePosition(self.panel.achievePos.RectTransform)
	end)
end

function BeiluzCoreSynthesisHandler:_onBtnMatIcon(i)
	local matData =  self:_getMatCostData()
	if matData[i] then
		local itemData = Data.BagModel:CreateItemWithTid(matData[i].itemCfg.ItemID)
		MgrMgr:GetMgr("ItemTipsMgr").ShowTipsDisplay(itemData, nil, nil, nil, true)
	end
end

function BeiluzCoreSynthesisHandler:OnBtnSkillPreview()
	local isEmpty,data = l_mgr.IsCombineSelectListEmpty()
	if not isEmpty then
		UIMgr:ActiveUI(UI.CtrlNames.BeiluzSkillPreview,data)
	end
end

--lua custom scripts end
return BeiluzCoreSynthesisHandler