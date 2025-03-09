--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseHandler"
require "UI/Panel/BeiluzCoreResetPanel"
require "UI/Template/BeiluzCoreResetItemTemplate"
require "UI/Template/ItemTemplate"
--lua requires end

--lua model
module("UI", package.seeall)

--lua model end

--lua fields
local super = UI.UIBaseHandler
--lua fields end

--lua class define
BeiluzCoreResetHandler = class("BeiluzCoreResetHandler", super)
local l_mgr = MgrMgr:GetMgr("BeiluzCoreMgr")
local attrMgr = MgrMgr:GetMgr("AttrDescUtil")
--lua class define end

--lua functions
function BeiluzCoreResetHandler:ctor()
	
	super.ctor(self, HandlerNames.BeiluzCoreReset, 0)
	
end --func end
--next--
function BeiluzCoreResetHandler:Init()
	
	self.panel = UI.BeiluzCoreResetPanel.Bind(self)
	super.Init(self)
	self:_init()
	
end --func end
--next--
function BeiluzCoreResetHandler:Uninit()
	
	super.Uninit(self)
	self.panel = nil
	
end --func end
--next--
function BeiluzCoreResetHandler:OnShow()
	self.showEquippedOnly = false
	self.dropdownIndex = 0
	self.panel.EquippedTgl.Tog.isOn = false
	self.coreItemTemplatePool:CancelSelectTemplate()
	self:_setDefaultData()
	self:_refreshCoreList(l_mgr.BEILUZCORE_TYPE_ITEM_IDS[l_mgr.BEILUZCORE_QUALITY.None])
	self:_refreshRightUI()
end --func end
--next--
function BeiluzCoreResetHandler:OnDeActive()
	
	
end --func end
--next--
function BeiluzCoreResetHandler:Update()
	
	
end --func end
--next--
function BeiluzCoreResetHandler:BindEvents()

	self:BindEvent(MgrProxy:GetGameEventMgr().l_eventDispatcher,MgrProxy:GetGameEventMgr().OnBagUpdate,self._onItemChangeBroadCast,self)
	self:BindEvent(l_mgr.l_eventDispatcher, l_mgr.SIG_RESET_RESET_SUCCESS,self._onResetSuccess,self)
	self:BindEvent(l_mgr.l_eventDispatcher, l_mgr.SIG_RESET_CHOOSE_SUCCESS,self._onChooseSuccess,self)

end --func end
--next--

function BeiluzCoreResetHandler:OnReconnected(roleData)

	self.showEquippedOnly = false
	self.dropdownIndex = 0
	self.panel.EquippedTgl.Tog.isOn = false
	self:_setDefaultData()
	self:_refreshCoreList(l_mgr.BEILUZCORE_TYPE_ITEM_IDS[l_mgr.BEILUZCORE_QUALITY.None])
	self:_refreshRightUI()

end --func end

--lua functions end

--lua custom scripts

function BeiluzCoreResetHandler:_init()

	self.panel.ReplaceButton:AddClickWithLuaSelf(self._onBtnReplace,self)

	self.panel.ResetButton:AddClickWithLuaSelf(self._onBtnReset,self)

	self.panel.BtnSkillTip:AddClickWithLuaSelf(self._onBtnSkillPreview,self)

	for i = 1,l_mgr.MAX_ATTR_COUNT do
		self.panel.LeftSkill[i]:AddClick(function()
			self:_onBtnSkill(self.panel.LeftSkill[i].transform.position,true,i)
		end)

		self.panel.RightSkill[i]:AddClick(function()
			self:_onBtnSkill(self.panel.RightSkill[i].transform.position,false,i)
		end)

		self.panel.MiddleSkill[i]:AddClick(function()
			self:_onBtnSkill(self.panel.MiddleSkill[i].transform.position,true,i)
		end)
	end

	self.panel.TipsButton.Listener:SetActionClick(self._onBtnTips,self)

	self.panel.EquippedTgl:OnToggleChanged(function(value)
		self:_onTglShowEquipped(value)
	end)

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
		self.coreItemTemplatePool:CancelSelectTemplate()
		self.curSelectedData = nil
		self:_refreshCoreList(l_mgr.BEILUZCORE_TYPE_ITEM_IDS[index])
		self:_refreshRightUI()
	end
	-- 初始化
	self.dropdownIndex = 0
	self.panel.Dropdown.DropDown.value = self.dropdownIndex
	self.panel.Dropdown.DropDown.onValueChanged:AddListener(l_onValueChanged)

	self.coreItemTemplatePool = self:NewTemplatePool({
		UITemplateClass = UITemplate.BeiluzCoreResetItemTemplate,
		ScrollRect = self.panel.CoreList.LoopScroll,
		Method = handler(self,self._onBtnSelectItem)
	})

	self.matItemTemplatePool = self:NewTemplatePool({
		UITemplateClass = UITemplate.ItemTemplate,
		TemplateParent = self.panel.ForgeMaterialParent.transform,
	})

	self.TopItemTemplate = self:NewTemplate("ItemTemplate",{
		TemplateParent = self.panel.TopItem.transform,
	})
end

-- 选择默认的齿轮，如果打开时传入齿轮UID，则选中这个齿轮，否则不选中任何齿轮
function BeiluzCoreResetHandler:_setDefaultData()
	self.curSelectedData = nil
	if l_mgr.Cache_CORE_UIDSTR then
		local coreList = l_mgr.GetAllCoreByTID(l_mgr.BEILUZCORE_TYPE_ITEM_IDS[l_mgr.BEILUZCORE_QUALITY.None])
		for _,v in ipairs(coreList) do
			if tostring(v.UID) == l_mgr.Cache_CORE_UIDSTR then
				self.curSelectedData = v
				break
			end
		end
		l_mgr.Cache_CORE_UIDSTR = nil
	end
	self.ctrlRef:SetTitle(Common.Utils.Lang("WHEEL_TITL_RESET"))
end

function BeiluzCoreResetHandler:_refreshCoreList(TID)
	local data = nil
	if self.showEquippedOnly then
		data = l_mgr.GetSortedEquippedCoreByTID(TID,l_mgr.SortByResetOrBagPanelRule)
	else
		data = l_mgr.GetSortedAllCoreByTID(TID,l_mgr.SortByResetOrBagPanelRule)
	end
	self.panel.EmptyTip2.gameObject:SetActiveEx((#data == 0))
	local index = 1
	if self.curSelectedData then
		local selectUID = tostring(self.curSelectedData.UID)
		for _,v in ipairs(data) do
			if tostring(v.UID) == selectUID then
				break
			end
			index = index + 1
		end
	end
	self.coreItemTemplatePool:ShowTemplates({Datas = data,StartScrollIndex = index})
	if self.curSelectedData then
		self.coreItemTemplatePool:SelectTemplate(index)
	end
end

function BeiluzCoreResetHandler:_refreshRightUI()
	self:_refreshTopUI()
	self:_refreshSkillUI()
	self:_refreshConsumeMatUI()
end

function BeiluzCoreResetHandler:_refreshTopUI()
	if self.curSelectedData then
		self.panel.TopNameRoot.gameObject:SetActiveEx(true)
		self.panel.TopItem.gameObject:SetActiveEx((true))
		local itemCfg = self.curSelectedData.ItemConfig
		self.panel.TopItemName.LabText = itemCfg.ItemName
		local itemData={
			PropInfo = self.curSelectedData,
			IsShowCount = false,
			HideButton = true,
		}
		self.TopItemTemplate:SetData(itemData)
	else
		self.panel.TopNameRoot.gameObject:SetActiveEx(false)
		self.panel.TopItem.gameObject:SetActiveEx((false))
	end
end

function BeiluzCoreResetHandler:_refreshSkillUI()
	local curSelectData = self.curSelectedData~=nil
	local hasNewSkills = false

	if curSelectData then
		local oldSkills = self.curSelectedData:GetAttrsByType(GameEnum.EItemAttrModuleType.BelluzGear)
		local newSkills = self.curSelectedData:GetAttrsByType(GameEnum.EItemAttrModuleType.BelluzGearCache)

		if #newSkills > 0 then
			for i=1, l_mgr.MAX_ATTR_COUNT do
				if oldSkills[i] then
					local wheelSkillCfg = TableUtil.GetWheelSkillTable().GetRowById(oldSkills[i].TableID)
					if not wheelSkillCfg then return end
					local quality = wheelSkillCfg.SkillQuality
					local color = l_mgr.C_BEILUZCORE_SKILL_COLOR_MAP[quality]
					local attr = attrMgr.GetAttrStr(oldSkills[i], color)
					self.panel.LeftSkillColor[i].Img.color = RoColor.Hex2Color(l_mgr.C_BEILUZCORE_SKILL_BG_COLOR_MAP[quality])
					self.panel.LeftSkill[i].LabText = attr.Name
					self.panel.LeftSkill[i].gameObject:SetActiveEx(true)
				else
					self.panel.LeftSkill[i].gameObject:SetActiveEx(false)
				end

				if newSkills[i] then

					local wheelSkillCfg = TableUtil.GetWheelSkillTable().GetRowById(newSkills[i].TableID)
					if not wheelSkillCfg then return end
					local quality = wheelSkillCfg.SkillQuality
					local color = l_mgr.C_BEILUZCORE_SKILL_COLOR_MAP[quality]
					local attr = attrMgr.GetAttrStr(newSkills[i], color)
					self.panel.RightSkillColor[i].Img.color = RoColor.Hex2Color(l_mgr.C_BEILUZCORE_SKILL_BG_COLOR_MAP[quality])
					self.panel.RightSkill[i].LabText = attr.Name
					self.panel.RightSkill[i].gameObject:SetActiveEx(true)
				else
					self.panel.RightSkill[i].gameObject:SetActiveEx(false)
				end
			end
		else
			for i=1, l_mgr.MAX_ATTR_COUNT do
				if oldSkills[i] then
					local wheelSkillCfg = TableUtil.GetWheelSkillTable().GetRowById(oldSkills[i].TableID)
					if not wheelSkillCfg then return end
					local quality = wheelSkillCfg.SkillQuality
					local color = l_mgr.C_BEILUZCORE_SKILL_COLOR_MAP[quality]
					local attr = attrMgr.GetAttrStr(oldSkills[i], color)
					self.panel.MiddleSkillColor[i].Img.color = RoColor.Hex2Color(l_mgr.C_BEILUZCORE_SKILL_BG_COLOR_MAP[quality])
					self.panel.MiddleSkill[i].LabText = attr.Name
					self.panel.MiddleSkill[i].gameObject:SetActiveEx(true)
				else
					self.panel.MiddleSkill[i].gameObject:SetActiveEx(false)
				end
			end
		end
		hasNewSkills = #newSkills > 0
	end
	self.panel.State2.gameObject:SetActiveEx(curSelectData and hasNewSkills)
	self.panel.State1.gameObject:SetActiveEx(curSelectData and not hasNewSkills)
	self.panel.ReplaceButton.gameObject:SetActiveEx(curSelectData and hasNewSkills)

	self.panel.EmptyTip.gameObject:SetActiveEx(not curSelectData)
	self.panel.ResetButton.gameObject:SetActiveEx(curSelectData)
	self.panel.BtnSkillTip.gameObject:SetActiveEx(curSelectData)

end

function BeiluzCoreResetHandler:_refreshConsumeMatUI()
	if self.curSelectedData then
		local wheelConsumCfg = TableUtil.GetWheelResetConsume().GetRowByWheelId(self.curSelectedData.TID)
		if not wheelConsumCfg then return end
		local config = wheelConsumCfg.ItemCost
		local l_itemDatas = {}
		for i=0,config.Count-1 do
			local l_data = {
				ID = config[i][0],
				IsShowCount = false,
				IsShowRequire = true,
				RequireCount = config[i][1],
			}
			table.insert(l_itemDatas, l_data)
		end
		self.matItemTemplatePool:ShowTemplates({ Datas = l_itemDatas })
	else
		self.matItemTemplatePool:ShowTemplates({ Datas = {} })
	end
end

function BeiluzCoreResetHandler:_checkMatEnough()
	if self.curSelectedData then

		local wheelConsumCfg = TableUtil.GetWheelResetConsume().GetRowByWheelId(self.curSelectedData.TID)
		if not wheelConsumCfg then return end
		local config = wheelConsumCfg.ItemCost
		for i=0,config.Count-1 do
			local id = config[i][0]
			local needCount = config[i][1]
			local ownCount = Data.BagModel:GetCoinOrPropNumById(id)
			if ownCount < needCount then
				local itemData = Data.BagModel:CreateItemWithTid(id)
				MgrMgr:GetMgr("ItemTipsMgr").ShowTipsDisplay(itemData, nil, nil, nil, true)
				return false
			end
		end
		return true
	end
	return false
end

function BeiluzCoreResetHandler:_getAttrData(attr)
	local wheelSkillCfg = TableUtil.GetWheelSkillTable().GetRowById(attr.TableID)
	if not wheelSkillCfg then return nil end
	local quality = wheelSkillCfg.SkillQuality
	local color = l_mgr.C_BEILUZCORE_SKILL_COLOR_MAP[quality]
	return attrMgr.GetAttrStr(attr, color)
end

-- 是否稀有：技能个数为2，品质大于等于2，高级技能
function BeiluzCoreResetHandler:_isCurSelectDataRare(oldOrNew)
	local needTip = false
	if self.curSelectedData then
		local newSkills = self.curSelectedData:GetAttrsByType(oldOrNew)
		local skillCount = #newSkills
		if skillCount >= 2 then
			needTip = true
			for i=1,skillCount do
				local wheelSkillCfg = TableUtil.GetWheelSkillTable().GetRowById(newSkills[i].TableID)
				if not wheelSkillCfg then return false end
				local quality = wheelSkillCfg.SkillQuality
				if quality < 2 then
					needTip = false
					break
				end
			end
		end
	end
	return needTip
end

function BeiluzCoreResetHandler:_onBtnSkill(position, isOld, index)
	if self.curSelectedData then
		local skillAttrs = self.curSelectedData:GetAttrsByType(isOld and GameEnum.EItemAttrModuleType.BelluzGear or GameEnum.EItemAttrModuleType.BelluzGearCache)
		if skillAttrs[index] then
			local skillData = {}
			skillData.type = 3
			skillData.id = skillAttrs[index].AttrID
			local l_skillData = {
				openType = DataMgr:GetData("SkillData").OpenType.ShowSkillInfo,
				position = position,
				data = skillData,
				pivot = Vector2.New(0.5,1)
			}
			UIMgr:ActiveUI(UI.CtrlNames.SkillAttr, l_skillData)
		end
	end
end

function BeiluzCoreResetHandler:_onBtnSelectItem(data, index)
	self:_onSwitchOrClose(data,index,function(data, index)
		self.coreItemTemplatePool:SelectTemplate(index)
		self.curSelectedData = data
		self:_refreshRightUI()
	end)
end

function BeiluzCoreResetHandler:_onBtnTips(go, eventData)
	local l_anchor = Vector2.New(1, 1)
	local pos = Vector2.New(eventData.position.x, eventData.position.y)
	eventData.position = pos

	MgrMgr:GetMgr("TipsMgr").ShowQuestionTip(Common.Utils.Lang("WHEEL_RESET_RULE_MAIN"), eventData, l_anchor)
end

function BeiluzCoreResetHandler:_onBtnReplace()
	-- 旧属性是否为稀有
	if self:_isCurSelectDataRare(GameEnum.EItemAttrModuleType.BelluzGear) then
		CommonUI.Dialog.ShowYesNoDlg(
				true, nil,
				Common.Utils.Lang("WHEEL_RESET_CHOOSE_RARE_WARNING"),
				function()
					UnityEngine.PlayerPrefs.SetInt(l_mgr.KEY_WHEEL_REPLACE_WARNING, 1)
					l_mgr.reqWheelChooseReset(self.curSelectedData.UID)
				end
		,nil, nil, 2, "BEILUZ_RESET_OLD_RARE_WARNING")
	else
		local cache = UnityEngine.PlayerPrefs.GetInt(l_mgr.KEY_WHEEL_REPLACE_WARNING)
		if cache ~= 1 then
			CommonUI.Dialog.ShowYesNoDlg(
					true, nil,
					Common.Utils.Lang("WHEEL_RESET_CHOOSE_COVER_WARNING"),
					function()
						UnityEngine.PlayerPrefs.SetInt(l_mgr.KEY_WHEEL_REPLACE_WARNING, 1)
						l_mgr.reqWheelChooseReset(self.curSelectedData.UID)
					end)
		else
			l_mgr.reqWheelChooseReset(self.curSelectedData.UID)
		end
	end
end

function BeiluzCoreResetHandler:_onBtnReset()

    local OpenSystemMgr = MgrMgr:GetMgr("OpenSystemMgr")
    if not OpenSystemMgr.IsSystemOpen(OpenSystemMgr.eSystemId.BeiluzReset) then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("SYSTEM_DONT_OPEN"))
        return
    end

	if not self:_checkMatEnough() then
		return
	end

	-- 新属性是否为稀有
	if self:_isCurSelectDataRare(GameEnum.EItemAttrModuleType.BelluzGearCache) then
		CommonUI.Dialog.ShowYesNoDlg(
				true, nil,
				Common.Utils.Lang("WHEEL_RESET_RESET_RARE_WARNING"),
				function()
					UnityEngine.PlayerPrefs.SetInt(l_mgr.KEY_WHEEL_RESET_WARNING, 1)
					l_mgr.reqResetCore(self.curSelectedData.UID)
				end
		,nil, nil, 2, "BEILUZ_RESET_NEW_RARE_WARNING")
	else
		local cache = UnityEngine.PlayerPrefs.GetInt(l_mgr.KEY_WHEEL_RESET_WARNING)
		local newAttr = self.curSelectedData:GetAttrsByType(GameEnum.EItemAttrModuleType.BelluzGearCache)
		if cache ~= 1 and #newAttr>0 then
			CommonUI.Dialog.ShowYesNoDlg(
					true, nil,
					Common.Utils.Lang("WHEEL_RESET_RESET_COVER_WARNING"),
					function()
						UnityEngine.PlayerPrefs.SetInt(l_mgr.KEY_WHEEL_RESET_WARNING, 1)
						l_mgr.reqResetCore(self.curSelectedData.UID)
					end)
		else
			l_mgr.reqResetCore(self.curSelectedData.UID)
		end
	end
end

-- 切换齿轮或关闭齿轮时,弹出确认框
function BeiluzCoreResetHandler:_onSwitchOrClose(data, index, action)
	-- 新属性是否为稀有
	if self:_isCurSelectDataRare(GameEnum.EItemAttrModuleType.BelluzGearCache) then
		CommonUI.Dialog.ShowYesNoDlg(true, nil,
				Common.Utils.Lang("WHEEL_RESET_SWITCH_RARE_NOT_SAVE_WARNING"),
				function()
					UnityEngine.PlayerPrefs.SetInt(l_mgr.KEY_WHEEL_RESET_SWITCH_WARING, 1)
					action(data,index)
				end,nil, nil, 2, "BEILUZ_RESET_SWITCH_NEW_RARE_WARNING")
	elseif self.curSelectedData then
		local cache = UnityEngine.PlayerPrefs.GetInt(l_mgr.KEY_WHEEL_RESET_SWITCH_WARING)
		local newAttr = self.curSelectedData:GetAttrsByType(GameEnum.EItemAttrModuleType.BelluzGearCache)
		if cache ~= 1 and #newAttr>0 then
			CommonUI.Dialog.ShowYesNoDlg(true, nil,
					Common.Utils.Lang("WHEEL_RESET_SWITCH_NOT_SAVE_WARNING"),
					function()
						UnityEngine.PlayerPrefs.SetInt(l_mgr.KEY_WHEEL_RESET_SWITCH_WARING, 1)
						action(data,index)
					end)
		else
			action(data,index)
		end
	else
		action(data,index)
	end
end

function BeiluzCoreResetHandler:_onItemChangeBroadCast(itemUpdateInfoList)
	if nil == itemUpdateInfoList then
		logError("[LandingAwardMgr] invalid param")
		return
	end
	for i = 1, #itemUpdateInfoList do
		local singleData = itemUpdateInfoList[i]
		local oldOrNewItem = singleData:GetNewOrOldItem()
		if oldOrNewItem.ItemConfig.TypeTab == GameEnum.EItemType.BelluzGear then
			l_mgr.l_eventDispatcher:Dispatch(l_mgr.SIG_RESET_ATTR_CHANGE,oldOrNewItem)
			self:_refreshTopUI()
			self:_refreshSkillUI()
		end
	end
	self:_refreshConsumeMatUI()
end

function BeiluzCoreResetHandler:_onBtnSkillPreview()
	if self.curSelectedData then
		UIMgr:ActiveUI(UI.CtrlNames.BeiluzSkillPreview,self.curSelectedData)
	end
end

function BeiluzCoreResetHandler:_onResetSuccess()
	local tipStr = Common.Utils.Lang("WHEEL_RESET_SUCCESS")
	MgrMgr:GetMgr("TipsMgr").ShowNormalTips(tipStr)
end

function BeiluzCoreResetHandler:_onChooseSuccess()
	local tipStr = Common.Utils.Lang("WHEEL_RESET_CHOOSE_SUCCESS")
	MgrMgr:GetMgr("TipsMgr").ShowNormalTips(tipStr)
end

function BeiluzCoreResetHandler:_onTglShowEquipped(value)
	self.showEquippedOnly = value
	self.curSelectedData = nil
	self.coreItemTemplatePool:CancelSelectTemplate()
	self:_refreshCoreList(l_mgr.BEILUZCORE_TYPE_ITEM_IDS[self.dropdownIndex])
	self:_refreshRightUI()
end

--lua custom scripts end
return BeiluzCoreResetHandler