--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseHandler"
require "UI/Panel/QuickTaskPanelPanel"
--lua requires end

--lua model
module("UI", package.seeall)

--lua model end

--lua fields
local super = UI.UIBaseHandler
--next--
--lua fields end

--lua class define
---@class QuickTaskPanelHandler:UIBaseHandler
QuickTaskPanelHandler = class("QuickTaskPanelHandler", super)

---@class QuickTaskPanelCell 任务页签单元
---@field ui UnityEngine.GameObject
---@field offsetPositionTop number 单元距页签顶部偏移
---@field offsetPositionBottom number 单元距页签底部偏移
---@field btnSearch MoonClient.MLuaUICom
---@field titleImage MoonClient.MLuaUICom
---@field selectImage UnityEngine.UI.Image
---@field desText MoonClient.MLuaUICom
---@field limitItem UnityEngine.Transform
---@field limitText MoonClient.MLuaUICom
---@field btnGiveUp MoonClient.MLuaUICom
---@field rect UnityEngine.RectTransform
---@field targets UnityEngine.Transform
---@field target MoonClient.MLuaUICom[]
---@field progressBar MoonClient.MLuaUICom
---@field debugId MoonClient.MLuaUICom
---@field taskData TaskBase 页签显示的任务数据
--lua class define end

--lua functions
function QuickTaskPanelHandler:ctor()

    super.ctor(self, HandlerNames.QuickTaskPanel, 0)

end --func end
--next--
function QuickTaskPanelHandler:Init()

    self.panel = UI.QuickTaskPanelPanel.Bind(self)
    super.Init(self)

    self.viewHeight = self.panel.TaskPanel.transform:Find("TaskList").gameObject:GetComponent("RectTransform").rect.height
    self.content = self.panel.TaskPanel.transform:Find("TaskList/Viewport/TaskScrollView/Content").gameObject:GetComponent("RectTransform")
    
    self.taskMgr = MgrMgr:GetMgr("TaskMgr")

    --初始化任务页签Toggle
    self:InitTaskPageToggle()  --toggle组设置
    self.currentTag = self.taskMgr.GetSelectTaskTag()  --设置当前页签

    ---@type QuickTaskPanelCell[]
    self.taskUI = {}

    --任务内容项初始化，依据配置的快捷面板最大显示数量 创建对应数量的预设克隆
    for i = 1, self.taskMgr.MAX_PRE_SHOW_NUM do
        self.taskUI[i] = {}
        self.taskUI[i].ui = self:CloneObj(self.panel.TaskTpl.gameObject)
        self.taskUI[i].ui.transform:SetParent(self.panel.TaskTpl.transform.parent)
        self.taskUI[i].ui.transform:SetLocalScaleOne()
        self.taskUI[i].offsetPositionTop = 0
        self.taskUI[i].offsetPositionBottom = 0
        self:ExportTaskElement(self.taskUI[i])
        self.taskUI[i].btnSearch:AddClick(function()
            --判空
            if self.taskUI[i].taskData == nil then
                return
            end
            --如果有对话正在执行先尝试跳过对话，否则寻路
            if not CommandBlockManager.SkipTaskBlock(self.taskUI[i].taskData.taskId) then
                self.taskUI[i].taskData:TaskNavigation()
            end
        end)
    end
    self.panel.TaskTpl.gameObject:SetActiveEx(false)  --隐藏原型
    
end --func end
--next--
function QuickTaskPanelHandler:Uninit()

    self.currentTag = nil

    for i=1,table.maxn(self.taskUI) do
        MResLoader:DestroyObj(self.taskUI[i].ui)
    end

    self.taskMgr = nil

    super.Uninit(self)
    self.panel = nil

end --func end
--next--
function QuickTaskPanelHandler:OnActive()

    self:RefreshTaskPanel()
    
end --func end
--next--
function QuickTaskPanelHandler:OnDeActive()


end --func end
--next--
function QuickTaskPanelHandler:Update()


end --func end
--next--
function QuickTaskPanelHandler:Refresh()


end --func end
--next--
function QuickTaskPanelHandler:OnLogout()


end --func end
--next--
function QuickTaskPanelHandler:Show()

    if not super.Show(self) then return end

end --func end
--next--
function QuickTaskPanelHandler:Hide()

    if not super.Hide(self) then return end

end --func end
--next--
function QuickTaskPanelHandler:BindEvents()

    self:BindEvent(GlobalEventBus,EventConst.Names.RefreshQuickTaskPanel,
            function(self, isClick)
                self:RefreshTaskPanel(isClick)
            end)
    self:BindEvent(GlobalEventBus,EventConst.Names.UpdateTaskTime,
            function()
                self:UpdateTaskTime()
            end)
    self:BindEvent(GlobalEventBus,EventConst.Names.RefreshQuickOneTask,
            function(self, taskId)
                self:UpdateOneTaskUI(taskId)
            end)
    self:BindEvent(GlobalEventBus,EventConst.Names.RefreshTaskNavState,
            function()
                self:UpdateSelectedTask()
            end)
    self:BindEvent(GlobalEventBus,EventConst.Names.OneTaskRemove,function(self,taskId)
        self:OneTaskRemove(taskId)
    end)
    self:BindEvent(GlobalEventBus,EventConst.Names.UpdateTaskUIFx,
            function(self,taskId)
                self:UpdateOneTaskUI(taskId)
                self:UpdateFx(taskId)
            end)

    self:BindEvent(MgrMgr:GetMgr("BeginnerGuideMgr").EventDispatcher, MgrMgr:GetMgr("BeginnerGuideMgr").QUICK_TASK_GUIDE_EVENT,
            function(self, guideStepInfo)
                --延时一帧执行 防止父界面在别的界面刷新回来删掉对应指引
                local l_timer = self:NewUITimer(function()
                        self:ShowBeginnerGuide(guideStepInfo)
                end, 0)
                l_timer:Start()
            end)
end --func end
--next--
--lua functions end

--lua custom scripts

function QuickTaskPanelHandler:UpdateFx(taskId)
    if taskId ~= MgrMgr:GetMgr("TaskMgr").GetSelectTaskID() or MgrMgr:GetMgr("TaskMgr").GetSelectTaskID() == 0 then
        return
    end
    for i=1,#self.taskUI do
        if self.taskUI[i].taskData ~= nil and self.taskUI[i].taskData.taskId == taskId then
            local l_fxObj = self.panel.FxGameObject
            local l_uiObj = self.taskUI[i].ui
            l_fxObj:SetActiveEx(false)
            l_fxObj.transform:SetParent(l_uiObj.transform)
            l_fxObj:SetActiveEx(true)
            l_fxObj.gameObject:GetComponent("RectTransform").sizeDelta = l_uiObj.gameObject:GetComponent("RectTransform").sizeDelta - Vector2.New(0,4)
            l_fxObj.gameObject.transform:SetLocalPosZero()
        end
    end
end

function QuickTaskPanelHandler:RefreshTaskPanel(isClick)
    --判空
    if not self.panel or not self.taskMgr then
        return
    end
    --页签更新
    local l_selectTag = self.taskMgr.GetSelectTaskTag()
    local l_taskTag = self.panel[StringEx.Format("Type_{0}", l_selectTag)]
    if l_taskTag ~= nil then
        l_taskTag.TogEx.isOn = true
    end
    if self.currentTag ~= l_selectTag then
        self.panel.FxGameObject:SetActiveEx(false)
        self.currentTag = l_selectTag
    end
    --页签上新任务提示标记设置
    local l_newTaskCache = self.taskMgr.GetNewTaskTagCache()
    l_newTaskCache[l_selectTag] = false  --当前选中的页签就算有新任务标记也去除
    for k, v in pairs(l_newTaskCache) do
        self.newTags[k].gameObject:SetActiveEx(v)
    end
    --获取展示的任务列表
    local l_taskData = self.taskMgr.ShowTaskFilter()
    local l_taskCount = #l_taskData
    --如果是主动点击切换页签更新 并且 当前页签没有任务则弹出提示
    if isClick and l_taskCount == 0 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("TASK_TAG_NONE_TIPS"))
    end
    local l_currentOffset = self.content.anchoredPosition.y
    local l_offset = 0
    local l_selectTaskId = self.taskMgr.GetSelectTaskID()
    self.content.anchoredPosition = Vector2.New(self.content.anchoredPosition.x, l_offset)

    for i = 1, self.taskMgr.MAX_PRE_SHOW_NUM do
        local l_oneTaskUI = self.taskUI[i]
        if i > l_taskCount then
            l_oneTaskUI.ui.gameObject:SetActiveEx(false)
            l_oneTaskUI.taskData = nil
        else
            local l_oneTaskData = l_taskData[i]
            self:RefreshOneTaskUI(l_oneTaskUI, l_oneTaskData)
            local l_height = l_oneTaskUI.rect.rect.height

            l_oneTaskUI.offsetPositionTop = l_offset
            l_oneTaskUI.offsetPositionBottom = l_oneTaskUI.offsetPositionTop - (self.viewHeight - l_height)
            if i == l_taskCount and i ~= 1 then
                if l_height < self.viewHeight then
                    l_offset = self.viewHeight - l_height
                    l_oneTaskUI.offsetPositionTop = l_oneTaskUI.offsetPositionTop - l_offset
                end
            end
            if i < l_taskCount then
                local l_height = l_oneTaskUI.rect.rect.height
                l_offset = l_offset + l_height
            end
            if l_oneTaskUI.offsetPositionTop < 0 then
                l_oneTaskUI.offsetPositionTop = 0
            end
            if l_selectTaskId == l_oneTaskUI.taskData.taskId then
                if l_currentOffset > l_oneTaskUI.offsetPositionTop then
                    l_currentOffset = l_oneTaskUI.offsetPositionTop
                else
                    if l_currentOffset < l_oneTaskUI.offsetPositionBottom then
                        l_currentOffset = l_oneTaskUI.offsetPositionBottom
                    end
                end
            end
        end
    end

    --布局重算
    LayoutRebuilder.ForceRebuildLayoutImmediate(self.content)
    --超界容错
    local l_maxOffset = self.content.rect.height - self.viewHeight
    if l_maxOffset <= 0 then
        l_currentOffset = 0
    elseif l_currentOffset > l_maxOffset then
        l_currentOffset = l_maxOffset - 5  
    end
    --偏移赋值
    self.content.anchoredPosition = Vector2.New(self.content.anchoredPosition.x, l_currentOffset)

    --任务状态改变刷新界面时 新手指引去除
    if self.guideArrow then
        MgrMgr:GetMgr("BeginnerGuideMgr").LuaBtnGuideClickEvent(self)
    end
end

function QuickTaskPanelHandler:HideAllTask()

    for i = 1, self.taskMgr.MAX_PRE_SHOW_NUM do
        self.taskUI[i].ui.gameObject:SetActiveEx(false)
    end
end

function QuickTaskPanelHandler:AdjustOffsetByTaskId(taskId)
    local l_cnt = #self.taskUI
    for i = 1, l_cnt do
        local l_oneTaskUI = self.taskUI[i]
        local l_oneTaskData = l_oneTaskUI.taskData
        if l_oneTaskData == nil then
            break
        else
            if taskId == l_oneTaskData.taskId then
                local l_currentOffset = self.content.anchoredPosition.y
                if l_currentOffset > l_oneTaskUI.offsetPositionTop then
                    l_currentOffset = l_oneTaskUI.offsetPositionTop
                else
                    if l_currentOffset < l_oneTaskUI.offsetPositionBottom then
                        l_currentOffset = l_oneTaskUI.offsetPositionBottom
                    end
                end
                self.content.anchoredPosition = Vector2.New(self.content.anchoredPosition.x, l_currentOffset)
            end
        end
    end
end

function QuickTaskPanelHandler:UpdateOneTaskUI(taskId)
    local l_cnt = #self.taskUI
    for i = 1, l_cnt do
        local l_oneTaskUI = self.taskUI[i]
        local l_oneTaskData = l_oneTaskUI.taskData
        if l_oneTaskData ~= nil and l_oneTaskUI.taskData.taskId == taskId then
            self:RefreshOneTaskUI(l_oneTaskUI, l_oneTaskUI.taskData)
        end
        -- if l_oneTaskData == nil then
        --     self:RefreshTaskPanel()
        --     return
        -- else
        --     if l_oneTaskUI.taskData.taskId == taskId then
        --         self:RefreshOneTaskUI(l_oneTaskUI, l_oneTaskUI.taskData)
        --     end
        -- end
    end
end

---@param taskUI QuickTaskPanelCell
---@param taskData TaskBase
function QuickTaskPanelHandler:RefreshOneTaskUI(taskUI, taskData)
    taskUI.ui.gameObject:SetActiveEx(true)
    taskUI.taskData = taskData
    --当前选中状态
    local l_isSelected = self.taskMgr.GetSelectTaskID() == taskData.taskId
    taskUI.selectImage.gameObject:SetActiveEx(l_isSelected)
    --Debug模式下 显示任务ID
    taskUI.debugId.gameObject:SetActiveEx(MGameContext.IsOpenGM)
    if MGameContext.IsOpenGM then
        taskUI.debugId.LabText = StringEx.Format("TaskID={0}", taskData.taskId)
    end
    -----------------------标题栏----------------------------------
    --任务标签
    local l_taskTag = taskData.tableData.typeTitle
    --任务名
    local l_taskNameStr = GetColorText(taskData.tableData.name, RoColorTag.None)
    --环任务进度
    local l_progressStr = GetColorText(taskData:GetTaskProgress() or "", RoColorTag.Yellow)
    --标题汇总
    local l_taskTitle = l_taskTag..l_taskNameStr..l_progressStr
    taskUI.titleText.LabText = l_taskTitle
    --快速放弃按钮
    if taskData:QuickGiveUp() then
        taskUI.btnGiveUp.gameObject:SetActiveEx(true)
        taskUI.btnGiveUp:AddClick(function(...)
            taskData:CancelTrack()
        end)
    else
        taskUI.btnGiveUp.gameObject:SetActiveEx(false)
        taskUI.btnGiveUp:AddClick(nil)
    end
    ----------------------END 标题栏-----------------------------------------

    --目标
    --未接及可完成不显示目标
    if not taskData:NeewShowTargets() then
        taskUI.targets.gameObject:SetActiveEx(false)
    else
        local l_targetsList = taskData:GetTaskTrackTargetDesc()
        local l_targetCnt = #l_targetsList
        taskUI.targets.gameObject:SetActiveEx(l_targetCnt > 0)
        for i = 1, 5 do
            if i > l_targetCnt then
                taskUI.target[i].gameObject:SetActiveEx(false)
            else
                taskUI.target[i].gameObject:SetActiveEx(true)
                taskUI.target[i].LabText = l_targetsList[i]
            end
        end
    end

    --描述
    local l_taskDesc = taskData:GetTaskDescribe()
    if l_taskDesc == nil then
        taskUI.desText.gameObject:SetActiveEx(false)
    else
        taskUI.desText.gameObject:SetActiveEx(true)
        taskUI.desText.LabText = l_taskDesc
    end

    --限制
    taskUI.limitItem.gameObject:SetActiveEx(false)
    local l_limitStr = taskData:GetTaskLimitStrForUI()
    if l_limitStr ~= nil then
        taskUI.limitItem.gameObject:SetActiveEx(true)
        taskUI.limitText.LabText = l_limitStr
    end
    local rtTrans = taskUI.ui.transform:GetComponent("RectTransform")
    LayoutRebuilder.ForceRebuildLayoutImmediate(rtTrans)

    --奖励预览 如果当前ui记录的展示内容ID 与 表数据不一致则刷新创建
    if taskUI.awardExhibition ~= taskData.tableData.AwardExhibition then
        --清理旧的
        if taskUI.awardItem then
            self:UninitTemplate(taskUI.awardItem)
            taskUI.awardItem  = nil
        end
        --记录预览的奖励ID
        taskUI.awardExhibition = taskData.tableData.AwardExhibition  
        --判断是否需要创建新的
        if taskUI.awardExhibition ~= 0 then
            taskUI.awardItem = self:NewTemplate("ItemTemplate", {
                TemplateParent = taskUI.awardItemBox.transform, 
                Data = {
                    ID = taskUI.awardExhibition,
                    IsShowCount = false,
            }})
        end
    end
    taskUI.awardItemBox.gameObject:SetActiveEx(l_isSelected and taskUI.awardExhibition ~= 0)
end

function QuickTaskPanelHandler:UpdateSelectedTask(...)
    local l_cnt = #self.taskUI
    local l_selectTaskId = self.taskMgr.GetSelectTaskID()
    local l_hasTask = false
    for i = 1, l_cnt do
        local l_oneTaskUI = self.taskUI[i]
        local l_oneTaskData = l_oneTaskUI.taskData
        if l_oneTaskData == nil then
            break
        else
            if l_selectTaskId == l_oneTaskData.taskId then
                l_hasTask = true
                local l_currentOffset = self.content.anchoredPosition.y
                if l_currentOffset > l_oneTaskUI.offsetPositionTop then
                    l_currentOffset = l_oneTaskUI.offsetPositionTop
                else
                    if l_currentOffset < l_oneTaskUI.offsetPositionBottom then
                        l_currentOffset = l_oneTaskUI.offsetPositionBottom
                    end
                end
                self.content.anchoredPosition = Vector2.New(self.content.anchoredPosition.x, l_currentOffset)
            end
            l_oneTaskUI.selectImage.gameObject:SetActiveEx(l_selectTaskId == l_oneTaskData.taskId)
            l_oneTaskUI.awardItemBox.gameObject:SetActiveEx(l_selectTaskId == l_oneTaskData.taskId and l_oneTaskUI.awardExhibition ~= 0)
        end
    end
    if not l_hasTask and l_selectTaskId ~= -1 then
        self:RefreshTaskPanel()
    end
end
function QuickTaskPanelHandler:UpdateTaskTime(...)
    if self.panel == nil then
        return
    end

    local len = table.maxn(self.taskUI)
    for i = 1, len do
        local l_taskData = self.taskUI[i].taskData
        if l_taskData ~= nil then
            if l_taskData.taskStatus == self.taskMgr.ETaskStatus.Taked then
                if l_taskData.totalTime ~= nil and l_taskData.totalTime > 0 then
                    self.taskUI[i].limitItem.gameObject:SetActiveEx(true)
                    self.taskUI[i].limitText.LabText = Common.Functions.SecondsToTimeStr(l_taskData.lastTime)
                    self.taskUI[i].progressBar.gameObject:SetActiveEx(true)
                    local l_percent = l_taskData.lastTime / l_taskData.totalTime
                    if l_percent > 1 then
                        l_percent = 1
                    end
                    self.taskUI[i].progressBar.Slider.value = l_percent
                else
                    local l_targetTime = l_taskData:TryGetTargetTime()
                    if l_targetTime == nil then
                        self.taskUI[i].progressBar.gameObject:SetActiveEx(false)
                    else
                        local l_percent = l_targetTime.lastTime / l_targetTime.totalTime
                        self.taskUI[i].progressBar.gameObject:SetActiveEx(true)
                        if l_percent > 1 then
                            l_percent = 1
                        end
                        self.taskUI[i].progressBar.Slider.value = l_percent
                    end
                end
            else
                self.taskUI[i].progressBar.gameObject:SetActiveEx(false)
            end
        end
    end
end

function QuickTaskPanelHandler:OneTaskRemove(taskId)
    local l_cnt = #self.taskUI
    local l_removeIndex = 0
    for i = 1, l_cnt do
        local l_oneTaskUI = self.taskUI[i]
        local l_oneTaskData = l_oneTaskUI.taskData
        if l_oneTaskData ~= nil and l_oneTaskUI.taskData.taskId == taskId then
            l_oneTaskUI.taskData = nil
            l_oneTaskUI.ui.gameObject:SetActiveEx(false)
            break
        end
    end
end

--初始化任务页签Toggle
function QuickTaskPanelHandler:InitTaskPageToggle()
    --- 任务页签三个分栏上方的“NEW”图标
    self.newTags = {}
    for i = 1, 3 do
        local l_tag = self.panel["Type_" .. i]
        if l_tag ~= nil then
            local l_newTag = l_tag.transform:Find("New")
            self.newTags[i] = l_newTag
            l_newTag.gameObject:SetActiveEx(false)
        end
    end
    --Toggle组设置
    local l_togExGrp = self.panel.TypeGrp.TogExGroup
    self.panel.Type_1.TogEx.group = l_togExGrp
    self.panel.Type_2.TogEx.group = l_togExGrp
    self.panel.Type_3.TogEx.group = l_togExGrp
    --Toggle点击事件
    local l_taskMgr = MgrMgr:GetMgr("TaskMgr")  --匿名函数保证闭包稳定性 单独获取
    self.panel.Type_1.TogEx.onValueChanged:AddListener(function(value)
        if value then
            if l_taskMgr.GetSelectTaskTag() == l_taskMgr.ETaskTag.Adventure then
                return
            end
            l_taskMgr.OnQuickTaskTagClick(l_taskMgr.ETaskTag.Adventure)
        end
    end)
    self.panel.Type_2.TogEx.onValueChanged:AddListener(function(value)
        if value then
            if l_taskMgr.GetSelectTaskTag() == l_taskMgr.ETaskTag.Story then
                return
            end
            l_taskMgr.OnQuickTaskTagClick(l_taskMgr.ETaskTag.Story)
        end
    end)
    self.panel.Type_3.TogEx.onValueChanged:AddListener(function(value)
        if value then
            if l_taskMgr.GetSelectTaskTag() == l_taskMgr.ETaskTag.Other then
                return
            end
            l_taskMgr.OnQuickTaskTagClick(l_taskMgr.ETaskTag.Other)
        end
    end)

end

---通过查找组件和对象获取内容来构造任务页签单元
---@param element QuickTaskPanelCell
function QuickTaskPanelHandler:ExportTaskElement(element)
    element.btnSearch = element.ui.transform:GetComponent("MLuaUICom")
    element.titleImage = element.ui.transform:Find("Title/TitleImage"):GetComponent("MLuaUICom")
    element.titleText = MLuaClientHelper.GetOrCreateMLuaUICom(element.ui.transform:Find("Title/TitleText"))
    element.selectImage = element.ui.transform:Find("SelectTaskImg"):GetComponent("Image")
    element.desText = MLuaClientHelper.GetOrCreateMLuaUICom(element.ui.transform:Find("Des/DesText"))
    element.limitItem = element.ui.transform:Find("Limit")
    element.limitText = MLuaClientHelper.GetOrCreateMLuaUICom(element.ui.transform:Find("Limit/LimitText"))
    element.btnGiveUp = element.ui.transform:Find("Title/GiveUpBtn"):GetComponent("MLuaUICom")
    element.rect = element.ui.transform:GetComponent("MLuaUICom").RectTransform
    element.targets = element.ui.transform:Find("Target")
    element.target = {}
    for i = 1, 5 do
        element.target[i] = MLuaClientHelper.GetOrCreateMLuaUICom(element.ui.transform:Find("Target/TargetText" .. i))
    end
    element.progressBar = element.ui.transform:Find("Progress"):GetComponent("MLuaUICom")
    element.debugId = MLuaClientHelper.GetOrCreateMLuaUICom(element.ui.transform:Find("DebugTaskId"))
    --奖励预览相关
    element.awardItemBox = element.ui.transform:Find("AwardItemBox"):GetComponent("MLuaUICom")  --容器
    element.awardItem = nil  
    element.awardExhibition = 0  --记录当前展示的预览ID
end


--展示快捷任务面板的新手指引
function QuickTaskPanelHandler:ShowBeginnerGuide(guideStepInfo)
    --如果目前是任务页签不是冒险则切换
    if self.taskMgr.GetSelectTaskTag() ~= self.taskMgr.ETaskTag.Adventure then
        self.taskMgr.OnQuickTaskTagClick(self.taskMgr.ETaskTag.Adventure)
    end
    --查找对应任务ID的UI
    if self.taskUI and #self.taskUI > 0 then
        for i = 1, #self.taskUI do
            local l_taskUI = self.taskUI[i]
            if l_taskUI.taskData ~= nil and l_taskUI.taskData.taskId == guideStepInfo.ValueId then
                --引导的箭头显示
                local l_aimWorldPos = l_taskUI.ui.transform.position
                MgrMgr:GetMgr("BeginnerGuideMgr").SetGuideArrowForLuaBtn(self, l_aimWorldPos,
                        l_taskUI.ui.transform, guideStepInfo)
                --引导相关的点击事件绑定
                l_taskUI.btnSearch:AddClick(function()
                    MgrMgr:GetMgr("BeginnerGuideMgr").LuaBtnGuideClickEvent(self)
                end, false)
                --滑动到目标任务
                self:AdjustOffsetByTaskId(guideStepInfo.ValueId)
            end
        end
    end
end
--lua custom scripts end
return QuickTaskPanelHandler