--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/ActivityNewKingPanel"
--lua requires end

--lua model
module("UI", package.seeall)

--lua model end

--lua fields
local super = UI.UIBaseCtrl
--lua fields end

--lua class define
---@class ActivityNewKingCtrl : UIBaseCtrl
ActivityNewKingCtrl = class("ActivityNewKingCtrl", super)
--lua class define end

local lastTaskID1 = 25000151
local lastTaskID2 = 25000152

--lua functions
function ActivityNewKingCtrl:ctor()
	
	super.ctor(self, CtrlNames.ActivityNewKing, UILayer.Function, nil, ActiveType.Exclusive)
	
end --func end
--next--
function ActivityNewKingCtrl:Init()
	
	self.panel = UI.ActivityNewKingPanel.Bind(self)
	super.Init(self)

	self.mgr = MgrMgr:GetMgr("ActivityNewKingMgr")

	for i=1,self.mgr.G_TOTAL_REWARD do
		self.panel.Receive[i]:AddClick(function()
			self:OnBtnItem(i)
		end)
	end

	self.panel.BtnGOTO:AddClickWithLuaSelf(self.OnBtnGOTO,self)

	self.panel.BtnBack:AddClickWithLuaSelf(self.OnBtnClose,self)

	self.panel.Rule.Listener:SetActionClick(self.OnBtnTips,self)

end --func end
--next--
function ActivityNewKingCtrl:Uninit()
	
	super.Uninit(self)
	self.panel = nil

end --func end
--next--
function ActivityNewKingCtrl:OnActive()

	MgrMgr:GetMgr("FestivalMgr").ReqActData(GameEnum.EActType.NewKing)
	
end --func end
--next--
function ActivityNewKingCtrl:OnDeActive()
	
	
end --func end
--next--
function ActivityNewKingCtrl:Update()
	
	
end --func end
--next--
function ActivityNewKingCtrl:BindEvents()

	self:BindEvent(self.mgr.l_eventDispatcher, self.mgr.SIG_ACTIVITY_NEW_KING_ON_GET_INFO,self.RefreshUI,self)
	self:BindEvent(self.mgr.l_eventDispatcher, self.mgr.SIG_ACTIVITY_NEW_KING_AWARD_CHANGE,self.RefreshUI,self)
	
end --func end
--next--
--lua functions end

--lua custom scripts

function ActivityNewKingCtrl:RefreshUI()

	local totalCount = self.mgr.GetCurrentCount()
	self.panel.TotalCount.LabText = totalCount

	for i=1,self.mgr.G_TOTAL_REWARD do
		local awardStatue = self.mgr.GetAwardStatue(i)
		local needCount = TableUtil.GetNewKingActivity().GetRowByID(i).TotalScore
		self.panel.TargetCount[i].LabText = needCount
		self.panel.red[i]:SetActiveEx(awardStatue == self.mgr.E_REWARD_STATE.Locked and totalCount >= needCount)
		self.panel.RewardMask[i]:SetActiveEx(awardStatue == self.mgr.E_REWARD_STATE.Received)
		self.panel.RewardReceived[i]:SetActiveEx(awardStatue == self.mgr.E_REWARD_STATE.Received)
	end

	local festivalMgr = MgrMgr:GetMgr("FestivalMgr")
	local actData = festivalMgr.GetDataByType(GameEnum.EActType.NewKing)
	if not actData then
		logError("获取不到活动数据")
		return
	end

	local startTime = Common.TimeMgr.GetChatTimeFormatStr(actData.startTimeStamp)
	local endTime = Common.TimeMgr.GetChatTimeFormatStr(actData.endTimeStamp)
	local delayEndTime = Common.TimeMgr.GetChatTimeFormatStr(actData.endTimeStamp + actData.delayTime)
	self.panel.ActivityTime.LabText = Common.Utils.Lang("ACTIVITY_TIME",startTime,endTime)
	self.panel.ActivityShowTime.LabText = Common.Utils.Lang("AWARD_GET_TIME",startTime,delayEndTime)

end

function ActivityNewKingCtrl:OnBtnClose()
	UIMgr:DeActiveUI(UI.CtrlNames.ActivityNewKing)
end

function ActivityNewKingCtrl:OnBtnGOTO()
	local taskMgr = MgrMgr:GetMgr("TaskMgr")
	local state1 = taskMgr.CheckTaskFinished(lastTaskID1)		-- 每个角色只会接到其中的一个
	local state2 = taskMgr.CheckTaskFinished(lastTaskID2)
	if state1 or state2 then	--已经完成
		MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("ACTIVITY_NEK_KING_TASK_FINISH"))
		return
	end

	UIMgr:DeActiveUI(UI.CtrlNames.ActivityNewKing)
	local cfg = MGlobalConfig:GetSequenceOrVectorInt("WarriorRecruitCampNpc")
	MTransferMgr:GotoNpc(cfg[1], cfg[0],function()
		MgrMgr:GetMgr("NpcMgr").TalkWithNpc(cfg[1], cfg[0])
	end)
end

function ActivityNewKingCtrl:OnBtnItem(index)
	local totalCount = self.mgr.GetCurrentCount()
	local awardStatue = self.mgr.GetAwardStatue(index)
	local needCount = TableUtil.GetNewKingActivity().GetRowByID(index).TotalScore
	if awardStatue == self.mgr.E_REWARD_STATE.Locked and totalCount >= needCount then
		self.mgr.ReqGetReward(index)
	else
		local cfg = TableUtil.GetNewKingActivity().GetRowByID(index)
		local awardCfg = TableUtil.GetAwardTable().GetRowByAwardId(cfg.AwardID)
		local awardPackageCfg = TableUtil.GetAwardPackTable().GetRowByPackId(awardCfg.PackIds[0])
		local itemID = awardPackageCfg.GroupContent[0][0]
		MgrMgr:GetMgr("ItemTipsMgr").ShowTipsDisplayWithId(itemID)
	end
end

function ActivityNewKingCtrl:OnBtnTips(go, eventData)
	local l_anchor = Vector2.New(0.5, 0)
	local pos = Vector2.New(eventData.position.x, eventData.position.y)
	eventData.position = pos
	MgrMgr:GetMgr("TipsMgr").ShowQuestionTip(Common.Utils.Lang("ACTIVITY_NEW_KING_RULE"), eventData, l_anchor)
end

--lua custom scripts end
return ActivityNewKingCtrl