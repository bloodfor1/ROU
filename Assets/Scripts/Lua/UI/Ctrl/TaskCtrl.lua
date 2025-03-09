--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/TaskPanel"

--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua class define
local super = UI.UIBaseCtrl
TaskCtrl = class("TaskCtrl", super)
--lua class define end

--lua functions
function TaskCtrl:ctor()
    super.ctor(self, CtrlNames.Task, UILayer.Function, nil, ActiveType.Exclusive)
end --func end
--next--
function TaskCtrl:Init()

    self.panel = UI.TaskPanel.Bind(self)
    super.Init(self)
    self.showTag = nil
    self:InitTaskPanel()
    self.selectTaskCell = nil
    self._awardItemTemplatePool = self:NewTemplatePool({
        TemplateClassName = "ItemTemplate",
        TemplateParent = self.panel.RewardList.transform
    })


end --func end
--next--
function TaskCtrl:Uninit()
    self:ClearTaskCache()
    self:ClearTaskTag()
    self.showTag = nil
    self._awardItemTemplatePool = nil
    super.Uninit(self)
    self.panel = nil
end --func end

--next--
function TaskCtrl:OnActive()
    self.panel.Btn_GM.gameObject:SetActiveEx(false)
    self:RefreshTaskList()
end --func end
--next--
function TaskCtrl:OnDeActive()
    self.selectTaskCell = nil
end --func end
--next--
function TaskCtrl:Update()


end --func end

--next--
function TaskCtrl:BindEvents()
    self:BindEvent(GlobalEventBus,EventConst.Names.RefreshSelectTaskTag,function()
        self:RefreshTaskList()
    end)
    self:BindEvent(GlobalEventBus,EventConst.Names.UpdateTaskTime,function()
        self:UpdateTaskTime()
    end)
    self:BindEvent(GlobalEventBus,EventConst.Names.UpdateTaskDetail,function()
        self:UpdateSelectTask()
    end)
    self:BindEvent(GlobalEventBus,EventConst.Names.OneTaskRemove,function(self,taskId)
        self:OneTaskRemove(taskId)
    end)
end --func end
--next--
--lua functions end

--lua custom scripts



function TaskCtrl:InitTaskPanel()

    self.taskListCache = {}  --任务缓存列表

    --创建任务分类页签
    self:CreateTaskTag()
    --隐藏动态UI(由逻辑控制是否显示)
    self:HideDynUI()
    --缓存详情界面目标tips
    self:CacheDetailTarget()

    self.panel.Btn_Close:AddClick(function ( ... )
        UIMgr:DeActiveUI(UI.CtrlNames.Task)
    end)

    self.panel.Btn_GM:AddClick(function ( ... )
        if self.selectTaskCell == nil then
            return
        end
        local l_taskData = self.selectTaskCell.taskData
        if l_taskData == nil then
            return
        end
        MgrMgr:GetMgr("GmMgr").SendCommand(StringEx.Format("ctask {0}",tostring(l_taskData.taskId)))
    end)

    self.panel.CanAccpetToggle:OnToggleChanged(function(value)
        self:RefreshTaskList()
    end)
    self.panel.CanAccpetToggle.Tog.isOn = true
end

function TaskCtrl:CreateTaskTag()
    self.taskTagList = {}
    local l_tmpList = {}
    local l_taskMgr = MgrMgr:GetMgr("TaskMgr")
    for k,v in pairs(l_taskMgr.ETaskTag) do
        table.insert(l_tmpList,v)
    end
    table.sort(l_tmpList,function(a,b)
        return a < b
    end)

    for i=1,#l_tmpList do
        local l_tagType = l_tmpList[i]
        local l_taskTag = {}
        l_taskTag.tag = l_tagType
        local l_tagItem = self:CloneObj(self.panel.Templent.gameObject)
        l_tagItem:SetActiveEx(true)
        l_tagItem.transform:SetParent(self.panel.Templent.transform.parent)
        l_tagItem.transform:SetLocalScaleOne()
        l_taskTag.childToogle = {}
        l_taskTag.ui = l_tagItem
        self:ExportElement(l_taskTag)
        l_taskTag.childItem.gameObject:SetActiveEx(false)
        l_taskTag.parentToogle.onValueChanged:AddListener(function(value)
            if value then
                self.panel.CanAccpetToggle.Tog.isOn = true
                if not l_taskMgr.SetSelectTag(l_taskTag.tag) then
                    self:RefreshTaskList()
                end
                self.showTag = l_taskTag.tag
            else
                self:HideSelectTag()
                self.showTag = nil
            end
        end)
        self.taskTagList[l_tagType] = l_taskTag
    end
end

function TaskCtrl:HideSelectTag()
    self.showTag = nil
    self:ClearTaskCache()
    self.selectTaskCell = nil
    self:AcitveEmptyInfo(true,Common.Utils.Lang("TASK_UI_TAG_HIDDEN_TIPS"))
end

function TaskCtrl:ClearTaskTag()
    if self.taskTagList == nil then return end
    for k,v in pairs(self.taskTagList) do
        local l_taskTagUI = v.ui
        v.ui = nil
        v.childToogle = nil
        v.parentToogle.onValueChanged:RemoveAllListeners()
        MResLoader:DestroyObj(l_taskTagUI.gameObject)
    end
    self.taskTagList = nil
end

function TaskCtrl:HideDynUI()
    self.panel.Templent:SetActiveEx(false)
    self.panel.TextTips:SetActiveEx(false)
    self.panel.TaskInfo.gameObject:SetActiveEx(false)
    self.panel.Task_Empty.gameObject:SetActiveEx(false)
    self.panel.RewardItem.gameObject:SetActiveEx(false)
    self.panel.ShowRewardAfterAccpted.gameObject:SetActiveEx(false)
end

function TaskCtrl:CacheDetailTarget()
    self.targetCache = {}
    for i=1,5 do
        local l_taskTipStr = StringEx.Format("Target{0}",i)
        local l_taskTip = self.panel.TargetTips.transform:Find(l_taskTipStr)
        local l_taskTipTxt = MLuaClientHelper.GetOrCreateMLuaUICom(l_taskTip)
        local l_countTip = l_taskTip:Find("Txt"):GetComponent("UIRichText")
        local l_taskTipData =
        {
            taskTip = l_taskTip,
            tipTxt = l_taskTipTxt,
            countTxt = l_countTip
        }
        table.insert(self.targetCache,l_taskTipData)
    end
end

function TaskCtrl:RefreshTaskList()
    for k,v in pairs(self.taskTagList) do
        v.childToogle = {}
    end
    local l_taskMgr = MgrMgr:GetMgr("TaskMgr")
    local l_selectTag = l_taskMgr.GetSelectTaskTag()
    local l_taskTagCell = self.taskTagList[l_selectTag]

    if l_taskTagCell == nil then return end
    l_taskTagCell.parentToogle.isOn = true
    self:CreateChildItem(l_taskTagCell)
end

function TaskCtrl:ClearTaskCache( ... )
    if self.taskListCache == nil then return end
    for i=1,#self.taskListCache do
        local l_taskCell = self.taskListCache[i]
        local l_taskUI = l_taskCell.ui
        l_taskCell.taskData = nil
        l_taskCell.ui = nil
        MResLoader:DestroyObj(l_taskUI.gameObject)
    end
    self.taskListCache = nil
end

function TaskCtrl:ExportElement(element)
    local l_tmpStr = StringEx.Format("TASK_TAG_0{0}",element.tag)
    element.parentToogle = element.ui.transform:Find("TaskParentItem/TogL"):GetComponent("MLuaUICom").TogEx
    element.parentItem = element.ui.transform:Find("TaskParentItem/TogL")
    element.childItem  = element.ui.transform:Find("TaskChildItem/TogS")
    element.ui.transform:Find("TaskParentItem/TogL/ON/Text"):GetComponent("MLuaUICom").LabText = Common.Utils.Lang(l_tmpStr)
    element.ui.transform:Find("TaskParentItem/TogL/Off/Text"):GetComponent("MLuaUICom").LabText = Common.Utils.Lang(l_tmpStr)
    local IconOn = element.parentItem.transform:Find("ON/Icon"):GetComponent("MLuaUICom")
    local IconOff = element.parentItem.transform:Find("Off/Icon"):GetComponent("MLuaUICom")
    local num = 2*tonumber(element.tag)
    local spOn = Lang("TASK_TYPE_ICON",num) 
    local spOff = Lang("TASK_TYPE_ICON",num-1) 
    IconOn:SetSprite("Task", spOn, true)
    IconOff:SetSprite("Task", spOff, true)
end

function TaskCtrl:CreateOneTaskCell(taskData,sourceItem)
    local l_taskCell = {}
    l_taskCell.taskData = taskData
    local l_taskItem = self:CloneObj(sourceItem.childItem.gameObject)
    l_taskItem.gameObject:SetActiveEx(true)
    l_taskItem.transform:SetParent(sourceItem.childItem.parent)
    l_taskItem.transform:SetLocalScaleOne()
    l_taskCell.ui = l_taskItem
    self:ExportChild(l_taskCell)
    return l_taskCell
end

function TaskCtrl:UpdateOneTaskCell(taskCell)
    local l_taskData = taskCell.taskData
    local l_taskUI = taskCell.ui
    if l_taskData == nil then
        l_taskUI.gameObject:SetActiveEx(false)
        return
    end
    local l_taskMgr = MgrMgr:GetMgr("TaskMgr")
    local l_taskStatus = taskCell.taskData.taskStatus
    taskCell.taskNameOn.LabText = l_taskData.tableData.name
    taskCell.taskNameOff.LabText = l_taskData.tableData.name
    taskCell.unlock.gameObject:SetActiveEx(false)
    --taskCell.unlock.gameObject:SetActiveEx(l_taskStatus == l_taskMgr.ETaskStatus.CanTake)
    if l_taskStatus == l_taskMgr.ETaskStatus.CanTake then
        --MLuaClientHelper.PlayFxHelper(taskCell.unlock.gameObject)
    end
    if l_taskMgr.GetSelectTaskID() == l_taskData.taskId then
        self.selectTaskCell = taskCell
    end
    taskCell.lockOn.gameObject:SetActiveEx(l_taskStatus == l_taskMgr.ETaskStatus.NotTake)
    taskCell.lockOff.gameObject:SetActiveEx(l_taskStatus == l_taskMgr.ETaskStatus.NotTake)
    taskCell.doingOn.gameObject:SetActiveEx(l_taskStatus == l_taskMgr.ETaskStatus.Taked)
    taskCell.doingOff.gameObject:SetActiveEx(l_taskStatus == l_taskMgr.ETaskStatus.Taked)
    taskCell.taskTypeName.LabText = l_taskData.tableData.typeTitle
    taskCell.childToogle.onValueChanged:RemoveAllListeners()
    taskCell.childToogle.onValueChanged:AddListener(function(value)
        if value then
            self:SelectTask(taskCell)
        end
    end)
end

function TaskCtrl:SelectTask(taskCell)
    if self.selectTaskCell == taskCell then
        return
    end
    self.selectTaskCell = taskCell
    self:UpdateSelectTask()
end

function TaskCtrl:CreateChildItem(sourceItem)
    self:ClearTaskCache()
    self.selectTaskCell = nil
    self.taskListCache = {}
    local l_taskList = MgrMgr:GetMgr("TaskMgr").ShowTaskFilter(true,self.panel.CanAccpetToggle.Tog.isOn)
    if #l_taskList == 0 then
        self:AcitveEmptyInfo(true)
        return
    end

    for i=1,#l_taskList do
        local l_taskData = l_taskList[i]
        local l_taskCell = self:CreateOneTaskCell(l_taskData,sourceItem)
        table.insert(self.taskListCache,l_taskCell)
        self:UpdateOneTaskCell(l_taskCell)
        table.insert(sourceItem.childToogle,l_taskCell)
    end
    if self.selectTaskCell == nil then
        self.selectTaskCell = self.taskListCache[1]
    end

    self.selectTaskCell.childToogle.isOn = true
    self:UpdateSelectTask()
end

function TaskCtrl:AcitveEmptyInfo(val,tips)
    self.panel.Task_Empty.gameObject:SetActiveEx(val)
    self.panel.TaskInfo.gameObject:SetActiveEx(not val)
    if not val then
        return
    end
    if tips == nil then
        self.panel.Task_Text_talk.LabText = Common.Utils.Lang("TASK_UI_EMPTY_TIPS")
    else
        self.panel.Task_Text_talk.LabText = tips
    end
end


function TaskCtrl:ExportChild(element)
    element.childToogle = element.ui.transform:GetComponent("MLuaUICom").TogEx
    element.taskNameOn = MLuaClientHelper.GetOrCreateMLuaUICom(element.ui.transform:Find("ON/Text"))
    element.taskNameOff = MLuaClientHelper.GetOrCreateMLuaUICom(element.ui.transform:Find("Off/Text"))
    element.lockOn = element.ui.transform:Find("ON/Lock")
    element.lockOff = element.ui.transform:Find("Off/Lock")
    element.doingOn = element.ui.transform:Find("ON/Doing")
    element.doingOff = element.ui.transform:Find("Off/Doing")
    element.unlock = element.ui.transform:Find("Unlock")
    element.taskTypeName = element.ui.transform:Find("TaskType/Text"):GetComponent("MLuaUICom")
end

function TaskCtrl:UpdateTaskTime()
    if self.panel == nil then
        return
    end
    if self.selectTaskCell == nil then
        return
    end
    local l_taskData = self.selectTaskCell.taskData
    if l_taskData.taskStatus == MgrMgr:GetMgr("TaskMgr").ETaskStatus.Taked then
        if  l_taskData.totalTime ~= nil and l_taskData.totalTime > 0 then
            self.panel.TextTips:SetActiveEx(true)
            self.panel.TextTips.LabText = StringEx.Format(Common.Utils.Lang("TASK_LAST_TIME"),Common.Functions.SecondsToTimeStr(l_taskData.lastTime))
        end
    end
end

function TaskCtrl:OneTaskRemove(taskId)

    if self.selectTaskCell == nil then return end
    if self.selectTaskCell.taskData.taskId == taskId then
        self.selectTaskCell = nil
        self:RefreshTaskList()
    end
end

function TaskCtrl:UpdateSelectTask()
    if self.selectTaskCell == nil then
        return
    end
    self:AcitveEmptyInfo(false)
    local l_taskData = self.selectTaskCell.taskData
    self.panel.TaskName.LabText = l_taskData.tableData.name
    self.panel.TaskDesc.LabText = l_taskData.tableData.taskDesc
    self.panel.TaskTypeTxt.LabText = l_taskData.tableData.typeTitle

    --环任务进度
    local l_progressStr = l_taskData:GetTaskProgress()
    if l_progressStr == nil then
        self.panel.TextProgress.gameObject:SetActiveEx(false)
    else
        self.panel.TextProgress.gameObject:SetActiveEx(true)
        self.panel.TextProgress.LabText = l_progressStr
    end

    --描述
    local l_taskDesc = l_taskData:GetTaskDescribe()
    if l_taskDesc == nil then
        self.panel.TargetDesc.gameObject:SetActiveEx(false)
    else
        self.panel.TargetDesc.gameObject:SetActiveEx(true)
        self.panel.TargetDesc.LabText = l_taskDesc
    end

    --限制
    local l_limitStr = l_taskData:GetTaskLimitStrForUI()
    if l_limitStr == nil then
        self.panel.TextTips:SetActiveEx(false)
    else
        self.panel.TextTips:SetActiveEx(true)
        self.panel.TextTips.LabText = l_limitStr
    end

    --按钮
    self:UpdateTaskButton(l_taskData)
    --目标
    self:RefreshTaskTarget(l_taskData)
    --奖励
    self:RefreshTaskReward(l_taskData.tableData)

    local rtTrans = self.panel.TargetTips.transform:GetComponent("RectTransform")
    LayoutRebuilder.ForceRebuildLayoutImmediate(rtTrans)
end

function TaskCtrl:UpdateTaskButton(taskData)
    self.panel.Btn_GM.gameObject:SetActiveEx(false)
    local l_taskStatus = taskData.taskStatus
    local l_taskMgr = MgrMgr:GetMgr("TaskMgr")
    if l_taskStatus == l_taskMgr.ETaskStatus.NotTake then
        self.panel.Btn_Cancel.gameObject:SetActiveEx(false)
        self.panel.TextStart.LabText = Common.Utils.Lang("TASK_NAV_TEXT")
    end

    if l_taskStatus == l_taskMgr.ETaskStatus.CanTake then
        self.panel.Btn_Cancel.gameObject:SetActiveEx(false)
        self.panel.TextStart.LabText = Common.Utils.Lang("TASK_NAV_ACCEPT_TEXT")
    end

    if l_taskStatus == l_taskMgr.ETaskStatus.Failed then
        local l_canDrop = taskData.tableData.isAutoDrop
        self.panel.TextCancel.LabText = Common.Utils.Lang("TASK_GIVEUP_TIP")
        self.panel.Btn_Cancel.gameObject:SetActiveEx(l_canDrop)
        self.panel.Btn_Cancel:AddClick(
            function ()
                UIMgr:DeActiveUI(UI.CtrlNames.Task)
                l_taskMgr.GiveUpTask(taskData.taskId)
            end
        )
        self.panel.Btn_Start.gameObject:SetActiveEx(true)
        self.panel.Btn_Start:AddClick(
            function ()
                UIMgr:DeActiveUI(UI.CtrlNames.Task)
                l_taskMgr.ReAcceptTask(taskData.taskId)
            end
        )
        self.panel.TextStart.LabText = Common.Utils.Lang("TASK_RELOAD_TEXT")
        return
    end

    if l_taskStatus == l_taskMgr.ETaskStatus.Taked then
        local l_canDrop = taskData.tableData.isAutoDrop
        self.panel.TextCancel.LabText = Common.Utils.Lang("TASK_GIVEUP_TIP")
        self.panel.Btn_Cancel.gameObject:SetActiveEx(l_canDrop)
        self.panel.Btn_Cancel:AddClick(
            function ()
                MgrMgr:GetMgr("TaskMgr").GiveUpTask(taskData.taskId)
            end
        )

        self.panel.TextStart.LabText = Common.Utils.Lang("TASK_NAV_TEXT")
        self.panel.Btn_GM.gameObject:SetActiveEx(MGameContext.IsOpenGM)
    end

    if l_taskStatus == l_taskMgr.ETaskStatus.CanFinish then
        local l_canDrop = taskData.tableData.isAutoDrop
        self.panel.TextCancel.LabText = Common.Utils.Lang("TASK_GIVEUP_TIP")
        self.panel.Btn_Cancel.gameObject:SetActiveEx(l_canDrop)
        self.panel.Btn_Cancel:AddClick(
            function ()
                UIMgr:DeActiveUI(UI.CtrlNames.Task)
                MgrMgr:GetMgr("TaskMgr").GiveUpTask(taskData.taskId)
            end
        )

        self.panel.TextStart.LabText = Common.Utils.Lang("TASK_FINISH_TEXT")
    end

    self.panel.Btn_Start.gameObject:SetActiveEx(true)
    self.panel.Btn_Start:AddClick(
        function ()
            if l_taskStatus ~= MgrMgr:GetMgr("TaskMgr").ETaskStatus.NotTake then
                UIMgr:DeActiveUI(UI.CtrlNames.Task)
            end
            taskData:TaskNavigation()
        end
    )
end

function TaskCtrl:RefreshTaskTarget(taskData)
    local l_taskMgr = MgrMgr:GetMgr("TaskMgr")
    local l_targetsList = taskData:GetTaskUITargetDesc()
    for i=1,#self.targetCache do
        local l_targetData = self.targetCache[i]
        if i > #l_targetsList then
            l_targetData.taskTip.gameObject:SetActiveEx(false)
        else
            l_targetData.taskTip.gameObject:SetActiveEx(true)
            local l_color = RoColorTag.Gray
            local l_completed = l_targetsList[i].completed
            local l_desc = l_targetsList[i].desc
            local l_steps = l_targetsList[i].step
            if l_completed then
                l_color = RoColorTag.Green
            end
            --新版本去除颜色
            l_targetData.tipTxt.LabText = l_desc --GetColorText(l_desc, l_color)
            l_targetData.countTxt.gameObject:SetActiveEx(l_steps ~= nil)
            if l_steps ~= nil then
                l_targetData.countTxt.text = GetColorText(l_steps, l_color)
            end
        end
    end
end

function TaskCtrl:RefreshTaskReward(tableData)
    local l_subTaskType = tableData.targetSubTaskChoose
    local l_taskMgr = MgrMgr:GetMgr("TaskMgr")
    if l_subTaskType ~= l_taskMgr.ETaskSubChoose.None then
        self.panel.ShowRewardAfterAccpted.gameObject:SetActiveEx(true)
        self._awardItemTemplatePool:ShowTemplates({Datas = {}})
    else
        self.panel.ShowRewardAfterAccpted.gameObject:SetActiveEx(false)
        local l_awardId = tableData.rewardId
        if tableData.taskType == l_taskMgr.ETaskType.WorldEvent then
            local l_parentTaskId = l_taskMgr.GetParentTaskIdWithSubTaskId(tableData.taskId)
            if l_parentTaskId == nil then return end
            local l_tableData = l_taskMgr.GetTaskTableInfoByTaskId(l_parentTaskId)
            l_awardId = l_tableData.rewardId
        end
        local l_rewardList = self:GetRewardsByAwardId(l_awardId)
        self._awardItemTemplatePool:ShowTemplates({Datas = l_rewardList})
    end
end

function TaskCtrl:GetRewardsByAwardId(awardId)
    local l_rewards = {}
    if awardId == 0 or awardId == nil then
        return l_rewards
    end
    local l_awardData = TableUtil.GetAwardTable().GetRowByAwardId(awardId)
    if l_awardData == nil then
        logError("awardId:<"..tostring(awardId).."> not exists in AwardTable! @策划")
        return l_rewards
    end
    if l_awardData.PreviewType == 2 then
        local l_previewRewards = Common.Functions.VectorSequenceToTable(l_awardData.PreviewItem)
        for i=1,#l_previewRewards do
            --table.insert(l_rewards, {ID = l_previewRewards[i][1], Count = l_previewRewards[i][2] or 1})
            table.insert(l_rewards, {ID = l_previewRewards[i][1], IsShowCount = false})
        end
        return l_rewards
    end
    local l_awardPacks = l_awardData.PackIds
    for i = 0,l_awardPacks.Length-1 do
        local l_packData = TableUtil.GetAwardPackTable().GetRowByPackId(l_awardPacks[i])
        if l_packData ~= nil then
            for j = 0,l_packData.GroupContent.Count-1 do
                local l_rewardData = {}
                l_rewardData.ID = l_packData.GroupContent:get_Item(j, 0)
                --l_rewardData.Count =l_packData.GroupContent:get_Item(j, 1)
                l_rewardData.IsShowCount = false
                table.insert(l_rewards,l_rewardData)
            end
        else
            logError("pickId :<"..tostring(l_awardPacks[i]).."> not exists in AwardPackTable !@策划")
        end
    end
    return l_rewards
end

--lua custom scripts end
return TaskCtrl

