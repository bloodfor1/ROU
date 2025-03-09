--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/BeiLuZiDialogPanel"
require "UI/Template/ItemTemplate"
--lua requires end

--lua model
module("UI", package.seeall)

--lua model end

--lua fields
local super = UI.UIBaseCtrl
--lua fields end

--lua class define
---@class BeiLuZiDialogCtrl : UIBaseCtrl
BeiLuZiDialogCtrl = class("BeiLuZiDialogCtrl", super)
--lua class define end

--lua functions
function BeiLuZiDialogCtrl:ctor()
	
	super.ctor(self, CtrlNames.BeiLuZiDialog, UILayer.Function, nil, ActiveType.Standalone)
	
end --func end
--next--
function BeiLuZiDialogCtrl:Init()
	
	self.panel = UI.BeiLuZiDialogPanel.Bind(self)
	super.Init(self)

	self.panel.TxtMsg.LabText = Common.Utils.Lang("WHEEL_ADD_LIFE_TITLE")

	self.mgr = MgrMgr:GetMgr("BeiluzCoreMgr")

	self.panel.BtnClose:AddClickWithLuaSelf(self.OnBtnClose,self)

	self.panel.BtnYes:AddClickWithLuaSelf(self.OnBtnConfirm,self)

	self.panel.BtnNo:AddClickWithLuaSelf(self.OnBtnClose,self)

	for i = 1,self.mgr.MAX_ATTR_COUNT do
		self.panel.SkillName[i]:AddClick(function()
			self.mgr.ShowSkillDesc(self.itemData,i,self.panel.SkillName[i].transform.position)
		end)
	end

	self.consumeItemPool = self:NewTemplatePool({
		UITemplateClass = UITemplate.ItemTemplate,
	})

	self.wheelTemplate = self:NewTemplate("ItemTemplate", {
		TemplateParent = self.panel.ItemRoot.transform,
	})
	
end --func end
--next--
function BeiLuZiDialogCtrl:Uninit()

	self.consumeItemPool = nil
	self.onConfirm = nil
	self.consume = nil
	self.extraData = nil

	super.Uninit(self)
	self.panel = nil
	
end --func end
--next--
function BeiLuZiDialogCtrl:OnActive()

	self.itemData = self.uiPanelData

	self:RefreshWheelInfo()
	self:RefreshContent()
	self:RefreshConsume()
	self:RefreshLifeInfo()
	
end --func end
--next--
function BeiLuZiDialogCtrl:OnDeActive()
	
	
end --func end
--next--
function BeiLuZiDialogCtrl:Update()
	
	
end --func end
--next--
function BeiLuZiDialogCtrl:BindEvents()

	self:BindEvent(MgrProxy:GetGameEventMgr().l_eventDispatcher,MgrProxy:GetGameEventMgr().OnBagUpdate,self.OnItemChangeBroadCast,self)
	self:BindEvent(self.mgr.l_eventDispatcher, self.mgr.SIG_WHEEL_MAINTAIN_RES,self.OnMaintainRes,self)
	
end --func end
--next--
--lua functions end

--lua custom scripts

function BeiLuZiDialogCtrl:RefreshWheelInfo()

	local itemData={
		PropInfo = self.itemData,
		IsShowCount = false,
	}
	self.wheelTemplate:SetData(itemData)
	self.panel.BeiluzName.LabText = self.mgr.GetColorNameByQuality(self.itemData.ItemConfig.ItemName,self.itemData.ItemConfig.ItemQuality)

	local skillIDs = self.itemData:GetAttrsByType(GameEnum.EItemAttrModuleType.BelluzGear)
	for i=1, self.mgr.MAX_ATTR_COUNT do
		if skillIDs[i] then
			local wheelSkillCfg = TableUtil.GetWheelSkillTable().GetRowById(skillIDs[i].TableID)
			if not wheelSkillCfg then return end
			local quality = wheelSkillCfg.SkillQuality
			local color = self.mgr.C_BEILUZCORE_SKILL_COLOR_MAP[quality]
			local attr = MgrMgr:GetMgr("AttrDescUtil").GetAttrStr(skillIDs[i], color)
			self.panel.SkillName[i].LabText = attr.Name
			self.panel.SkillName[i]:SetActiveEx(true)
		else
			self.panel.SkillName[i]:SetActiveEx(false)
		end
	end

end

function BeiLuZiDialogCtrl:RefreshContent()

	self.panel.Content.LabText = StringEx.Format(Common.Utils.Lang("WHEEL_LIFE_ADD_CONFIRM"),self.itemData.ItemConfig.ItemName)

end

function BeiLuZiDialogCtrl:RefreshConsume()

	-- 消耗材料
	local Lubricant = self.mgr.GetLubricantID(self.itemData.TID)
	local l_consumeDatas = {}
	local l_data = {}
	l_data.ID = Lubricant.id
	l_data.IsShowCount = false
	l_data.IsShowRequire = true
	l_data.RequireCount = Lubricant.count
	table.insert(l_consumeDatas, l_data)

	self.materialIsEnough = true
	for i = 1, #l_consumeDatas do
		--在初始化消耗品的同时判断材料是否足够
		self:MaterialIsEnough(l_consumeDatas[i])
	end
	self.consumeItemPool:ShowTemplates({ Datas = l_consumeDatas, Parent = self.panel.ItemParent.transform })

end

--判断材料是否足够
---@param data ItemTemplateParam
function BeiLuZiDialogCtrl:MaterialIsEnough(data)
	local l_currentCount = 0
	local l_requireCount = 0
	if self.materialIsEnough then
		local l_itemId = data.ID or data.PropInfo.TID
		if l_itemId == nil then
			return
		end
		l_currentCount = Data.BagModel:GetCoinOrPropNumById(tonumber(l_itemId))
		l_requireCount = data.RequireCount or 0
		--货币不判 走快捷兑换
		if l_currentCount < l_requireCount and data.ID ~= GameEnum.l_virProp.Coin101  then
			self.materialIsEnough = false
			self.notEnoughId = data.ID
		end
	end
end

function BeiLuZiDialogCtrl:RefreshLifeInfo()

	local maxLife = self.mgr.GetMaxLifeInSeconds(self.itemData.ItemConfig.ItemID)
	local addLife = self.mgr.GetAddLifeOnceInSeconds(self.itemData)
	local remainLife = self.mgr.GetCoreRemainTimeInSeconds(self.itemData)

	local afterAddLife = remainLife + addLife
	if afterAddLife > maxLife then
		afterAddLife = maxLife
	end
	local oldLife = StringEx.Format(Common.Utils.Lang("WHEEL_LIFE_IN_DAY"),math.floor(remainLife / self.mgr.dayToSeconds))
	local newLife = nil
	if afterAddLife >= maxLife then
		newLife = Common.Utils.Lang("WHEEL_ADD_LIFE_RESULT_MAX_IN_DAY")
	else
		newLife = Common.Utils.Lang("TIME_DAY")
	end
	newLife = StringEx.Format(newLife,math.floor(afterAddLife / self.mgr.dayToSeconds))

	self.panel.AttrChangeTxt1.LabText = oldLife
	self.panel.AttrChangeTxt2.LabText = newLife
end

--- Event
function BeiLuZiDialogCtrl:OnBtnConfirm()
	if not self.materialIsEnough then
		MgrMgr:GetMgr("ItemTipsMgr").ShowTipsDisplayWithId(self.notEnoughId, nil, nil, nil, true)
		MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("ITEM_NOT_ENOUGH"))
		return
	end

	local maxLife = self.mgr.GetMaxLifeInSeconds(self.itemData.ItemConfig.ItemID)
	local addLife = self.mgr.GetAddLifeOnceInSeconds(self.itemData)
	local remainLife = self.mgr.GetCoreRemainTimeInSeconds(self.itemData)

	if (remainLife + addLife > maxLife ) then
		MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("WHEEL_LIFE_ENOUGH_TIP"))
	else
		self.mgr.reqMaintainCore(self.itemData.UID)
	end

end

function BeiLuZiDialogCtrl:OnBtnClose()
	UIMgr:DeActiveUI(UI.CtrlNames.BeiLuZiDialog)
end

function BeiLuZiDialogCtrl:OnItemChangeBroadCast(itemUpdateInfoList)
	if nil == itemUpdateInfoList then
		logError("[LandingAwardMgr] invalid param")
		return
	end

	self:RefreshConsume()
	self:RefreshLifeInfo()
end

-- 保养回调
function BeiLuZiDialogCtrl:OnMaintainRes()
	local addLife = self.mgr.GetAddLifeOnceInDay(self.itemData)
	local tipStr = StringEx.Format(Common.Utils.Lang("WHEEL_LIFE_ADD_SUCCESS"),self.itemData.ItemConfig.ItemName,addLife)
	MgrMgr:GetMgr("TipsMgr").ShowNormalTips(tipStr)
end
--- End Event

--lua custom scripts end
return BeiLuZiDialogCtrl