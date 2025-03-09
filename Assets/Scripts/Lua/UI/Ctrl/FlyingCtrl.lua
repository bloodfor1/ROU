--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/FlyingPanel"


--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua class define
local super = UI.UIBaseCtrl
FlyingCtrl = class("FlyingCtrl", super)
--lua class define end

--lua functions
function FlyingCtrl:ctor()

	super.ctor(self, CtrlNames.Flying, UILayer.Function, nil, ActiveType.Standalone)

end --func end
--next--
function FlyingCtrl:Init()

	self.panel = UI.FlyingPanel.Bind(self)
	super.Init(self)
	self.taskId = nil
end --func end
--next--
function FlyingCtrl:Uninit()

	super.Uninit(self)
	self.panel = nil

end --func end
--next--
function FlyingCtrl:OnActive()

end --func end
--next--
function FlyingCtrl:OnDeActive()
	self.taskId = nil

end --func end
--next--
function FlyingCtrl:Update()


end --func end



--next--
function FlyingCtrl:BindEvents()

	--dont override this function

end --func end

--next--
--lua functions end

--lua custom scripts

function FlyingCtrl:CloseMail( ... )
	-- body
    UIMgr:DeActiveUI(UI.CtrlNames.Flying)
end

function FlyingCtrl:ShowDetail(taskId)
	logRed("taskId:"..taskId)
	self.taskId = taskId
	if	self.taskId == nil then
		self:CloseMail()
		return
	end

	local l_taskMailInfo = TableUtil.GetTaskFlyAcceptTable().GetRowByTaskId(self.taskId)
	if l_taskMailInfo == nil then
        local l_debugInfo = MgrMgr:GetMgr("TaskMgr").DEBUT_TASK_NAMES[self.taskData.tableData.taskType]
		logError("<"..l_debugInfo[2]..">中task <"..self.taskId.."> not exists in TaskFlyAcceptTable @"..l_debugInfo[1])
		return
	end

	local l_taskTableInfo = MgrMgr:GetMgr("TaskMgr").GetTaskTableInfoByTaskId(self.taskId)
		if l_taskTableInfo == nil then
		logError("task <"..self.taskId.."> not exists in TaskTable @天考")
		return
	end
	local l_mailImgPath = l_taskMailInfo.PostcardName
	if string.ro_isEmpty(l_mailImgPath) then
		self.panel.Flying_xin.UObj:SetActiveEx(true)
		self.panel.Flying_ka.UObj:SetActiveEx(false)
		self.panel.TextName.LabText = MEntityMgr.PlayerEntity.Name
		self.panel.TextContent.LabText = StringEx.Format("    {0}",l_taskMailInfo.Text)
		local l_npcId = MgrMgr:GetMgr("TaskMgr").GetTaskAcceptNpc(self.taskId)
		if l_npcId ~= 0 then
			self.panel.TextNpc.LabText = MgrMgr:GetMgr("TaskMgr").GetNpcNameById(l_npcId)
		else
			logError("task:<"..taskId.."> 飞鸽接取任务的NpcId为0,请检查配置")
			self.panel.TextNpc.LabText = StringEx.Format("NpcId=0")
		end
		MLuaClientHelper.PlayFxHelper(self.panel.Flying_xin.UObj)
		self.panel.BtnMailAccept:AddClick(function( ... )
			MgrMgr:GetMgr("TaskMgr").RequestTaskAccept(self.taskId)
			self:CloseMail()
		end)

	else
		self.panel.Flying_xin.UObj:SetActiveEx(false)
		self.panel.Flying_ka.UObj:SetActiveEx(true)
		self.panel.CardImg:SetSprite("Flying",l_mailImgPath)
		MLuaClientHelper.PlayFxHelper(self.panel.Flying_ka.UObj)
		self.panel.BtnCardAccept:AddClick(function( ... )
			MgrMgr:GetMgr("TaskMgr").RequestTaskAccept(self.taskId)
			self:CloseMail()
		end)
	end
	self.panel.BgMaskButton:AddClick(function()
		MgrMgr:GetMgr("TaskMgr").RequestTaskAccept(self.taskId)
		self:CloseMail()
	end)

end

--lua custom scripts end
