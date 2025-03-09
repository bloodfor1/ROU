--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/MazeDungeonWheelPanel"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua fields
local super = UI.UIBaseCtrl
--next--
--lua fields end

--lua class define
MazeDungeonWheelCtrl = class("MazeDungeonWheelCtrl", super)
--lua class define end

--lua functions
function MazeDungeonWheelCtrl:ctor()
	
	super.ctor(self, CtrlNames.MazeDungeonWheel, UILayer.Top, nil, ActiveType.Standalone)
	
end --func end
--next--
function MazeDungeonWheelCtrl:Init()
	
	self.panel = UI.MazeDungeonWheelPanel.Bind(self)
	super.Init(self)
	
	self.panel.PanelEntry.gameObject:SetActiveEx(false)

	self.wheelHighSpeed = 1000
	self.wheelSlowSpeed = 100
	self.wheelHighSpTime = MGlobalConfig:GetFloat("RouletteWaittingTime1")
	self.wheelSlowSpTime = MGlobalConfig:GetFloat("RouletteWaittingTime2")
	self.wheelCloseTime = MGlobalConfig:GetFloat("RouletteWaittingTime3")
	self.wheelSpeed = self.wheelHighSpeed
	self.wheelAdSpeed = (self.wheelHighSpeed - self.wheelSlowSpeed)/self.wheelSlowSpTime
	
	self.stopWheel = false
	self.stopY = -143
	self.selectIdx = nil
	self.entryGap = 55.05
	self.entryNum = 6
	self.entryDown = -(self.entryNum)*self.entryGap
	self.entryContent = {}
	self.panel.TargetTxt.LabText=Lang("MAZE_WHEEL_TIPS")

	local l_table = MgrMgr:GetMgr("MazeDungeonMgr").GetEntryTable()
	local l_select = MgrMgr:GetMgr("MazeDungeonMgr").GetSelectEntryId()
	self.entrySelect = l_table[l_select]
	for i=1,l_select-1 do
		self.entryContent[i]=l_table[i]
	end
	for i=l_select+1,#l_table do
		self.entryContent[i-1]=l_table[i]
	end

	if self.entryTable == nil then
		self.entryTable={}
		for i=1,self.entryNum do
			self.entryTable[i] = {}
			local l_pos = self.panel.PanelEntry.gameObject.transform.localPosition
			l_pos.y = -self.entryGap*(i-1)
			self.entryTable[i].go=self:CloneObj(self.panel.PanelEntry.gameObject)
			self.entryTable[i].go.transform:SetParent(self.panel.PanelEntry.gameObject.transform.parent)
			self.entryTable[i].go.transform.localScale=self.panel.PanelEntry.gameObject.transform.localScale
			self.entryTable[i].go.transform.localPosition=l_pos
			self.entryTable[i].go:SetActiveEx(true)
			self.entryTable[i].contentIdx = (i - 1) % #self.entryContent + 1 
			self.entryTable[i].txt = MLuaClientHelper.GetOrCreateMLuaUICom(self.entryTable[i].go.transform:Find("Text").gameObject)
			self.entryTable[i].txt.LabText = self.entryContent[self.entryTable[i].contentIdx]
		end
	end

	

end --func end
--next--
function MazeDungeonWheelCtrl:Uninit()
	
	super.Uninit(self)
	self.panel = nil
	self.entryTable = nil
end --func end
--next--
function MazeDungeonWheelCtrl:OnActive()
	
end --func end
--next--
function MazeDungeonWheelCtrl:OnDeActive()
	--MUIManager:ShowBigMap()
	local l_mazeDungeonMgr=MgrMgr:GetMgr("MazeDungeonMgr")
	local l_tip = l_mazeDungeonMgr.GetWheelTipsContent()
	l_mazeDungeonMgr.ShowTips(l_tip)
	l_mazeDungeonMgr.ShowRadar(true)
end --func end
--next--
function MazeDungeonWheelCtrl:Update()
	local l_deltaTime = Time.deltaTime
	if self.wheelHighSpTime > 0 then
		self.wheelHighSpTime=self.wheelHighSpTime-l_deltaTime
	elseif self.wheelSlowSpTime > 0 then
		self.wheelSlowSpTime=self.wheelSlowSpTime-l_deltaTime
		self.wheelSpeed=self.wheelSpeed-self.wheelAdSpeed*l_deltaTime
		if self.wheelSlowSpTime<=0 then
			self.wheelSpeed=self.wheelSlowSpeed
		end
	elseif self.stopWheel == true and self.wheelCloseTime>0 then
		self.wheelCloseTime = self.wheelCloseTime - l_deltaTime
		if self.wheelCloseTime <= 0 then
			UIMgr:DeActiveUI(UI.CtrlNames.MazeDungeonWheel)
		end
	end

	if self.entryTable ~= nil and self.stopWheel==false then
		local l_dY = l_deltaTime*self.wheelSpeed
		if self.selectIdx~=nil then
			local l_pos = self.entryTable[self.selectIdx].go.transform.localPosition
			if l_pos.y - l_dY < self.stopY then
				l_dY = l_pos.y - self.stopY
				self.stopWheel = true
			end
		end
		for i=1,self.entryNum do
			l_pos = self.entryTable[i].go.transform.localPosition
			l_pos.y = l_pos.y-l_dY
			if l_pos.y<self.entryDown then
				local l_cnt = math.floor(math.abs(l_pos.y/self.entryDown))
				local l_t = self.entryTable[i].contentIdx
				self.entryTable[i].contentIdx = (self.entryTable[i].contentIdx -1 - l_cnt*self.entryNum) % #self.entryContent
				self.entryTable[i].contentIdx = (self.entryTable[i].contentIdx + #self.entryContent) % #self.entryContent + 1
				l_pos.y = l_pos.y - l_cnt * self.entryDown
				if self.selectIdx==nil and self.wheelSlowSpTime<=0 and l_pos.y > self.stopY then
					self.selectIdx = i
					self.entryTable[i].txt.LabText = self.entrySelect
				else
					self.entryTable[i].txt.LabText = self.entryContent[self.entryTable[i].contentIdx]
				end
			end
			self.entryTable[i].go.transform.localPosition = l_pos
		end
	end
end --func end





--next--
function MazeDungeonWheelCtrl:BindEvents()
	
	
end --func end

--next--
--lua functions end

--lua custom scripts

--lua custom scripts end
