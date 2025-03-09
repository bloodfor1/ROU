--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/JobTaskPanel"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua fields
local super = UI.UIBaseCtrl
--next--
--lua fields end

--lua class define
JobTaskCtrl = class("JobTaskCtrl", super)
--lua class define end

--lua functions
function JobTaskCtrl:ctor()

	super.ctor(self, CtrlNames.JobTask, UILayer.Function, nil, ActiveType.Exclusive)
	local l_tmp = MGlobalConfig:GetVectorSequence("ChoiceJob")
	self.jobTaskDataCache = {}
    for i = 0, l_tmp.Length - 1 do
        self.jobTaskDataCache[tonumber(l_tmp[i][1])] = tonumber(l_tmp[i][0])
    end
    self.selectJob = nil
    self.sceneId = 0
    self.npc = 0
    self.parentTaskId = 0

	self.GroupMaskType = GroupMaskType.Show
	self.MaskColor=BlockColor.Dark
	self.ClosePanelNameOnClickMask=UI.CtrlNames.JobTask
end --func end
--next--
function JobTaskCtrl:Init()

	self.panel = UI.JobTaskPanel.Bind(self)
	super.Init(self)
	self.jobTaskUICache = {}

end --func end
--next--
function JobTaskCtrl:Uninit()
	super.Uninit(self)
	self.panel = nil
	self.jobTaskUICache = {}
end --func end
--next--
function JobTaskCtrl:OnActive()
	self.panel.ButtonAcceptJobTask.gameObject:SetActiveEx(false)
	self.panel.SelectJobTips.gameObject:SetActiveEx(true)
	self:ParseJobCell()
	self.panel.ButtonClose:AddClick(function( ... )
        UIMgr:DeActiveUI(UI.CtrlNames.JobTask)
	end)
	--self:SetBlockOpt(BlockColor.Dark, function()
	--    UIMgr:DeActiveUI(UI.CtrlNames.JobTask)
	--end)
	self.panel.ButtonAcceptJobTask:AddClick(function( ... )
		if self.selectJob == nil then
			return
		end
		if self.parentTaskId == 0 then
			return
		end
		self:AcceptTask()
		UIMgr:DeActiveUI(UI.CtrlNames.JobTask)
	end)

end --func end
--next--
function JobTaskCtrl:OnDeActive()
	self.selectJob = nil
	self.parentTaskId = 0
	self.sceneId = 0
	self.npcId = 0
end --func end
--next--
function JobTaskCtrl:Update()


end --func end





--next--
function JobTaskCtrl:BindEvents()


end --func end

--next--
--lua functions end

--lua custom scripts
function JobTaskCtrl:ParseJobCell()
	self.jobTaskUICache = {}
	for k,v in pairs(self.jobTaskDataCache) do
		local l_jobCell = {}
		l_jobCell.jobId = k
		l_jobCell.taskId = v
		l_jobCell.ui = {}
		local l_cellName = StringEx.Format("JobCell_{0}",tostring(k))
		local l_uiCell = self.panel[l_cellName]
		if	l_uiCell == nil then
			logError("job <"..k.."> not exists on JobTaskUI")
		else
			l_jobCell.ui.gameObject = l_uiCell.gameObject
			l_jobCell.ui.background = l_uiCell.gameObject.transform:GetComponent("Image")
			l_jobCell.ui.jobName = l_uiCell.gameObject.transform:Find("JobName"):GetComponent("MLuaUICom")
			l_jobCell.ui.selectMark = l_uiCell.gameObject.transform:Find("SelectMark"):GetComponent("Image")
			l_jobCell.ui.jobImg = l_uiCell.gameObject.transform:Find("JobImage"):GetComponent("MLuaUICom")

			local l_professionData = TableUtil.GetProfessionTable().GetRowById(k)
			if	l_professionData == nil then
				logError("Profession <"..k.."> not exists in ProfessionTable")
			else
				l_jobCell.ui.jobName.LabText =l_professionData.Name
				if MPlayerInfo.IsMale then
					l_jobCell.ui.jobImg:SetSprite("JobTask", "ui_JobTask_Image_"..l_professionData.EnglishName.."_M.png",true)	
				else
					l_jobCell.ui.jobImg:SetSprite("JobTask", "ui_JobTask_Image_"..l_professionData.EnglishName.."_F.png",true)	
				end
			end
			l_jobCell.ui.selectMark.gameObject:SetActiveEx(false)
			l_uiCell:AddClick(function()
				if self.selectJob == l_jobCell then
					return
				end
    			self.selectJob = l_jobCell
    			self:UpdateSelectTask()
    		end)
			table.insert(self.jobTaskUICache,l_jobCell)
		end
	end
end

function JobTaskCtrl:UpdateSelectTask()
	for i=1,#self.jobTaskUICache do
		local l_jobCell = self.jobTaskUICache[i]
		local l_isSelection = self.selectJob == l_jobCell
		l_jobCell.ui.selectMark.gameObject:SetActiveEx(l_isSelection)
		local l_color = "FFFFFFFF"
		if l_isSelection then
			l_color =  "CAF1FFFF"
			MLuaCommonHelper.SetLocalScale(l_jobCell.ui.gameObject, 1.05, 1.05, 1.05)
		else
			MLuaCommonHelper.SetLocalScale(l_jobCell.ui.gameObject, 1, 1, 1)
		end
		l_jobCell.ui.background.color =CommonUI.Color.Hex2Color(l_color)
	end
	local l_selected = self.selectJob ~= nil

	self.panel.ButtonAcceptJobTask.gameObject:SetActiveEx(l_selected)
	self.panel.SelectJobTips.gameObject:SetActiveEx(not l_selected)

	if l_selected then
		local l_professionData = TableUtil.GetProfessionTable().GetRowById(self.selectJob.jobId)
		if	l_professionData == nil then
			logError("Profession <"..self.selectJob.jobId.."> not exists in ProfessionTable")
		else
			self.panel.JobText.LabText = StringEx.Format(Common.Utils.Lang("JOB_TASK_UI_BUTTON_TXT"),l_professionData.Name)
		end
	end
end

function JobTaskCtrl:SetJobSelectData(parentTaskId,sceneId,npcId)
	self.parentTaskId = parentTaskId
	self.sceneId = sceneId
	self.npcId = npcId
end

function JobTaskCtrl:AcceptTask()
	local l_taskId = self.parentTaskId
	local l_taskSubId = self.selectJob.taskId
	local l_sceneId = self.sceneId
	local l_npcId = self.npcId
	local l_talkMgr = MgrMgr:GetMgr("NpcTalkDlgMgr")
	local l_taskMgr = MgrMgr:GetMgr("TaskMgr")
	local l_taskInfo = l_taskMgr.GetTaskTableInfoByTaskId(l_taskSubId)
    local l_commandId = l_taskInfo.talkScript
    local l_commandtag = l_taskInfo.talkAcceptScriptTag
    l_talkMgr.ForceSelect(false)
    l_talkMgr.RunCommandBlock(l_taskSubId, l_commandId, l_commandtag, function()
        l_talkMgr.LockTalkDlg()
        l_taskMgr.RequestTaskAccept(l_taskId, l_taskSubId, nil, function()
            l_talkMgr.TryGetNextTask(l_sceneId,l_npcId,l_taskId)
            l_talkMgr.UnlockDlgWithRetry()
        end)
    end)

end

--lua custom scripts end
