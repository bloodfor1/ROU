--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/TowerDefenseAwardPanel"
--lua requires end

--lua model
module("UI", package.seeall)

--lua model end

--lua fields
local super = UI.UIBaseCtrl
--lua fields end

--lua class define
TowerDefenseAwardCtrl = class("TowerDefenseAwardCtrl", super)
--lua class define end

--lua functions
function TowerDefenseAwardCtrl:ctor()
	
	super.ctor(self, CtrlNames.TowerDefenseAward, UILayer.Function, nil, ActiveType.None)

	self.GroupMaskType = GroupMaskType.Show
	self.MaskColor = BlockColor.Dark
	
end --func end
--next--
function TowerDefenseAwardCtrl:Init()
	
	self.panel = UI.TowerDefenseAwardPanel.Bind(self)
	super.Init(self)

	self._mgr=MgrMgr:GetMgr("TowerDefenseMgr")

	self.panel.ButtonClose:AddClick(function()
		UIMgr:DeActiveUI(UI.CtrlNames.TowerDefenseAward)
	end)

	self._tdAwardTemplatePool = self:NewTemplatePool({
		TemplateClassName="TDAwardTemplate",
		ScrollRect=self.panel.TDAwardScroll.LoopScroll,
		TemplatePrefab=self.panel.TDAwardPrefab.gameObject,
	})

	self.awardIds={}

	local l_TableInfos= TableUtil.GetTdQuestTable().GetTable()

	for i = 1, #l_TableInfos do
		if l_TableInfos[i].Award~=0 then
			table.insert(self.awardIds,l_TableInfos[i].Award)
		end
	end
	
end --func end
--next--
function TowerDefenseAwardCtrl:Uninit()
	
	super.Uninit(self)
	self.panel = nil

	self._mgr=nil
	
end --func end
--next--
function TowerDefenseAwardCtrl:OnActive()

	MgrMgr:GetMgr("AwardPreviewMgr").GetBatchPreviewRewards(self.awardIds,self._mgr.GetTowerDefenseAwardEvent)
	
	
end --func end
--next--
function TowerDefenseAwardCtrl:OnDeActive()
	
	
end --func end
--next--
function TowerDefenseAwardCtrl:Update()
	
	
end --func end
--next--
function TowerDefenseAwardCtrl:BindEvents()
	self:BindEvent(self._mgr.EventDispatcher, self._mgr.ReceiveGetTowerDefenseWeekAwardEvent, function()
		self:_showAward()
	end)

	self:BindEvent(MgrMgr:GetMgr("AwardPreviewMgr").EventDispatcher,self._mgr.GetTowerDefenseAwardEvent,self._onGetAwardInfo)
	
end --func end
--next--
--lua functions end

--lua custom scripts
function TowerDefenseAwardCtrl:_showAward()

	local l_TableInfos= TableUtil.GetTdQuestTable().GetTable()

	local l_getAwardDatas={}
	local l_awardDatas={}
	local l_canGetAwardDatas={}

	for i = 1, #l_TableInfos do

		local l_tableInfo=l_TableInfos[i]
		if l_tableInfo.IsActive then
			if self._mgr.IsGetAwardWithId(l_tableInfo.ID,l_tableInfo.Type) then
				--已领奖，放在已领奖列表里
				table.insert(l_getAwardDatas,l_tableInfo)
			else
				if self:_isAwardNeedShow(l_tableInfo) then
					local l_currentProgress=self._mgr.GetAwardTaskProgressWithType(l_tableInfo.Type)
					if l_currentProgress >= l_tableInfo.Arg then
						table.insert(l_canGetAwardDatas,l_tableInfo)
					else
						table.insert(l_awardDatas,l_tableInfo)
					end
				end
			end
		end
	end

	table.ro_insertRange(l_canGetAwardDatas,l_awardDatas)
	table.ro_insertRange(l_canGetAwardDatas,l_getAwardDatas)

	self._tdAwardTemplatePool:ShowTemplates({
		Datas = l_canGetAwardDatas,
	})

end

function TowerDefenseAwardCtrl:_onGetAwardInfo(awardInfo)

	self._mgr.SetTDAwardDatas(awardInfo)
	self:_showAward()
end

function TowerDefenseAwardCtrl:_isAwardNeedShow(tableInfo)
	if tableInfo.PreQuest ~= 0 then
		--有前置任务
		--判断前置任务是否已领奖
		if self._mgr.IsGetAwardWithId(tableInfo.PreQuest,tableInfo.Type) then
			--前置任务已领奖
			return true
		end
	else
		--没有前置任务
		return true
	end
	return false
end
--lua custom scripts end
return TowerDefenseAwardCtrl