--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/BaseUITemplate"
--lua requires end

--lua model
module("UITemplate", package.seeall)

--lua model end

--lua fields
local super = UITemplate.BaseUITemplate
--lua fields end

--lua class define
---@class BeiluzCoreCombineTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field Selected MoonClient.MLuaUICom
---@field New MoonClient.MLuaUICom
---@field ItemIcon MoonClient.MLuaUICom
---@field ItemButton MoonClient.MLuaUICom

---@class BeiluzCoreCombineTemplate : BaseUITemplate
---@field Parameter BeiluzCoreCombineTemplateParameter

BeiluzCoreCombineTemplate = class("BeiluzCoreCombineTemplate", super)
local l_mgr = MgrMgr:GetMgr("BeiluzCoreMgr")
--lua class define end

--lua functions
function BeiluzCoreCombineTemplate:Init()
	
	super.Init(self)

	self.Parameter.ItemButton.LongBtn.onClick = function()
		self:_onClickIcon()
	end

	self.Parameter.ItemButton.LongBtn.onLongClick = function ()
		self:_onLongPress()
	end

	--[[for i = 1,l_mgr.MAX_ATTR_COUNT do
		self.Parameter.SkillName[i]:AddClick(function()
			l_mgr.ShowSkillDesc(self.data,i,self.Parameter.SkillName[i].transform.position)
		end)
	end]]

	self.l_itemTemplate = self:NewTemplate("ItemTemplate", {
		TemplateParent = self.Parameter.ItemRoot.gameObject.transform,
	})
	
end --func end
--next--
function BeiluzCoreCombineTemplate:BindEvents()

	self:BindEvent(l_mgr.l_eventDispatcher, l_mgr.SIG_COMBINE_CANCEL_SELECT_ITEM,self._onCancelSelectItem,self)
	self:BindEvent(l_mgr.l_eventDispatcher, l_mgr.SIG_COMBINE_UPDATE_SELECTABLE,self._onSelectableUpdate,self)
	self:BindEvent(l_mgr.l_eventDispatcher, l_mgr.SIG_COMBINE_SELECT_ITEM,self._onSelectItem,self)
	
end --func end
--next--
function BeiluzCoreCombineTemplate:OnDestroy()
	
	
end --func end
--next--
function BeiluzCoreCombineTemplate:OnDeActive()
	
	
end --func end
--next--
function BeiluzCoreCombineTemplate:OnSetData(data)
	self.data = data
	if data then
		self.selectable = self:_isSelectable()
		self:_setItem()
		self.Parameter.Selected:SetActiveEx(self:_isSelected())
		self.Parameter.New:SetActiveEx(l_mgr.g_newCoreList[data.UID])

		local skillIDs = data:GetAttrsByType(GameEnum.EItemAttrModuleType.BelluzGear)
		for i=1,l_mgr.MAX_ATTR_COUNT do
			if skillIDs[i] then
				local wheelSkillCfg = TableUtil.GetWheelSkillTable().GetRowById(skillIDs[i].TableID)
				if not wheelSkillCfg then return end
				local quality = wheelSkillCfg.SkillQuality
				local color = l_mgr.C_BEILUZCORE_SKILL_COLOR_MAP[quality]
				local attr =  MgrMgr:GetMgr("AttrDescUtil").GetAttrStr(skillIDs[i], color)
				self.Parameter.SkillName[i].LabText = attr.Name
				self.Parameter.SkillName[i]:SetActiveEx(true)
			else
				self.Parameter.SkillName[i]:SetActiveEx(false)
			end
		end
	end
end --func end
--next--
--lua functions end

--lua custom scripts
BeiluzCoreCombineTemplate.TemplatePath = "UI/Prefabs/BeiluzCoreCombineItem"

function BeiluzCoreCombineTemplate:_onClickIcon()
	if self.data then
		if self.selectable then
			l_mgr.g_newCoreList[self.data.UID] = nil
			self.Parameter.New:SetActiveEx(false)

			local nextEmptySlot = -1			--下一个空的槽位
			local isRemove = false				-- 当前操作是 移除/镶嵌
			local curIndex = -1

			for i= l_mgr.g_combineSlotCount,1,-1 do
				if l_mgr.g_selectedList[i] then
					if tostring(l_mgr.g_selectedList[i].UID) == tostring(self.data.UID) then
						isRemove = true
						curIndex = i
						break
					end
				else
					nextEmptySlot = i
				end
			end

			if isRemove then
				local curFirstEquippedSlotIndex = l_mgr.GetFirstEquippedSlotIndex()
				l_mgr.g_selectedList[curIndex] = nil
				self.Parameter.Selected:SetActiveEx(false)
				l_mgr.l_eventDispatcher:Dispatch(l_mgr.SIG_COMBINE_REFRESH_SLOTUI,curIndex)
				if curIndex == curFirstEquippedSlotIndex then
					l_mgr.l_eventDispatcher:Dispatch(l_mgr.SIG_COMBINE_UPDATE_SELECTABLE,l_mgr.GetFirstEquippedSlotIndex())
				end
			elseif nextEmptySlot ~= -1 then
				-- 有空槽位
				l_mgr.g_selectedList[nextEmptySlot] = self.data
				local curFirstEquippedSlotIndex = l_mgr.GetFirstEquippedSlotIndex()
				self.Parameter.Selected:SetActiveEx(true)
				l_mgr.l_eventDispatcher:Dispatch(l_mgr.SIG_COMBINE_REFRESH_SLOTUI,nextEmptySlot)
				l_mgr.l_eventDispatcher:Dispatch(l_mgr.SIG_COMBINE_CLEAR_SHOW_ITEM)
				if l_mgr.g_newCoreList[self.data.UID] then
					l_mgr.g_newCoreList[self.data.UID] = nil
					self.Parameter.New:SetActiveEx(false)
				end
				if nextEmptySlot == curFirstEquippedSlotIndex then		-- 装备第一个槽位后刷新右侧CoreList状态
					l_mgr.l_eventDispatcher:Dispatch(l_mgr.SIG_COMBINE_UPDATE_SELECTABLE,curFirstEquippedSlotIndex)
				end
			end
		else
			local tipStr = Common.Utils.Lang("WHEEL_COMBINE_SAMENAME_WARNING")
			MgrMgr:GetMgr("TipsMgr").ShowNormalTips(tipStr)
		end
	end
end

function BeiluzCoreCombineTemplate:_onLongPress()
	if self.data then
		-- 去掉新字
		l_mgr.g_newCoreList[self.data.UID] = nil
		for i=4,1,-1 do
			if l_mgr.g_selectedList[i] and tostring(l_mgr.g_selectedList[i].UID) == tostring(self.data.UID) then
				l_mgr.l_eventDispatcher:Dispatch(l_mgr.SIG_COMBINE_REFRESH_SLOTUI,i)
			end
		end
		l_mgr.l_eventDispatcher:Dispatch(l_mgr.SIG_COMBINE_REFRESH_SLOTUI)
		MgrMgr:GetMgr("ItemTipsMgr").ShowTipsDisplayWithInfo(self.data)
	end
end

function BeiluzCoreCombineTemplate:_onCancelSelectItem(UID)
	if self.data and tostring(self.data.UID) == tostring(UID) then
		self.Parameter.Selected:SetActiveEx(false)
	end
end

function BeiluzCoreCombineTemplate:_onSelectableUpdate(firstSlotIndex)
	if firstSlotIndex > 0 then
		self.selectable = self:_isSelectable()
	else
		self.selectable = true
	end
	self:_setItem()
end

function BeiluzCoreCombineTemplate:_onSelectItem(UID)
	if self.data and tostring(self.data.UID) == UID then
		self:_onClickIcon()
	end
end

function BeiluzCoreCombineTemplate:_setItem()
	if self.data then
		local itemData={
			PropInfo = self.data,
			IsShowCount = false,
			--HideButton = true,
			IsGray = not self.selectable,
			IsShowCloseButton = true,
		}
		self.l_itemTemplate:SetData(itemData)
	end
end

function BeiluzCoreCombineTemplate:_isSelectable()
	if self.data then
		local firstEquippedSlotIndex = l_mgr.GetFirstEquippedSlotIndex()
		if firstEquippedSlotIndex > 0 then
			local eData = l_mgr.g_selectedList[firstEquippedSlotIndex]
			return eData.TID == self.data.TID
		else
			return true
		end
	end
	return false
end

function BeiluzCoreCombineTemplate:_isSelected()
	local selectedList = l_mgr.g_selectedList
	local selectedList = l_mgr.g_selectedList
	local selected = false
	for i = 1,4 do
		if selectedList[i] and tostring(selectedList[i].UID) == tostring(self.data.UID) then
			selected = true
			break
		end
	end
	return selected
end

--lua custom scripts end
return BeiluzCoreCombineTemplate