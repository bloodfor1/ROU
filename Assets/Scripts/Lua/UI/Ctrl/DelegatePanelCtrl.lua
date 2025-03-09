--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/DelegatePanelPanel"
require "UI/Template/DailyItemTemplate"
require "UI/Template/ItemTemplate"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua fields
local super = UI.UIBaseCtrl
local PanelType = {
    Delegate = 1,
    Reward = 2,
    Emblem = 3,

}
--next--
--lua fields end

--lua class define
DelegatePanelCtrl = class("DelegatePanelCtrl", super)
--lua class define end

--lua functions
function DelegatePanelCtrl:ctor()

    super.ctor(self, CtrlNames.DelegatePanel, UILayer.Function, nil, ActiveType.Exclusive)
    self.isFullScreen = true
    self.mgr = MgrMgr:GetMgr("DelegateModuleMgr")
    self.awardMgr = MgrMgr:GetMgr("AwardPreviewMgr")
    self.objTweenId = 0
    self.curPanel = PanelType.Delegate
end --func end
--next--
function DelegatePanelCtrl:Init()
    ---@type DelegatePanelPanel
    self.panel = UI.DelegatePanelPanel.Bind(self)
    super.Init(self)
    self.delegateCanvase = self.panel.Delegate.gameObject:GetComponent("Canvas")
    self.dailyItemPool = self:NewTemplatePool({
        UITemplateClass = UITemplate.DailyItemTemplate,
        ScrollRect = self.panel.Content.transform.parent:GetComponent("LoopScrollRect"),
        TemplatePrefab = self.panel.DailyItemTemplate.gameObject,
        SetCountPerFrame = 4,
        CreateObjPerFrame = 4,
        Method = function(index, data, item)
            self:onSelectOne(index, data, item)
        end
    })
    self.awardItemPool = self:NewTemplatePool({
        UITemplateClass = UITemplate.ItemTemplate,
        ScrollRect = self.panel.rewardContent.transform.parent:GetComponent("LoopScrollRect"),
        TemplatePath = "UI/Prefabs/ItemPrefab",
    })
    self.panel.BtnExit:AddClick(function()
        UIMgr:DeActiveUI(UI.CtrlNames.DelegatePanel)
    end)

    
    self.curPanel = PanelType.Delegate
    -- 委托
    self.panel.BtnList.TogEx.onValueChanged:AddListener(function(b)
        if self.panel.BtnList.TogEx.isOn then
            if self.curPanel == PanelType.Delegate then
                return
            end
            self.curPanel = PanelType.Delegate
            self:DoTween(false)
            self.panel.Delegate.gameObject:SetActiveEx(true)
            UIMgr:DeActiveUI(UI.CtrlNames.Emblem)
            UIMgr:DeActiveUI(UI.CtrlNames.DelegateWheel)
            --切换回委托列表刷新界面
            self:RefreshDelegates()
        end
    end)

    -- 奖励

    local l_openSystem = MgrMgr:GetMgr("OpenSystemMgr")
    self.panel.BtnBox.gameObject:SetActiveEx(l_openSystem.IsSystemOpen(l_openSystem.eSystemId.DelegateReward))

    self.panel.BtnBox.TogEx.onValueChanged:AddListener(function(b)
        local ui = UIMgr:GetUI(UI.CtrlNames.DelegateWheel)
        if self.panel.BtnBox.TogEx.isOn and (not ui or not ui:IsShowing()) then
            self.curPanel = PanelType.Reward
            self:DoTween(true)
            self.panel.Delegate.gameObject:SetActiveEx(false)
            UIMgr:DeActiveUI(UI.CtrlNames.Emblem)
            UIMgr:ActiveUI(UI.CtrlNames.DelegateWheel)
            self.panel.DelegateTips.gameObject:SetActiveEx(false)
        end
    end)

    self.panel.DelegateTips:AddClick(function(...)
        self.panel.DelegateTips.gameObject:SetActiveEx(false)
    end)
    -- 纹章
    self.panel.BtnEmblem.TogEx.onValueChanged:AddListener(function(b)
        local ui = UIMgr:GetUI(UI.CtrlNames.Emblem)
        if self.panel.BtnEmblem.TogEx.isOn and (not ui or not ui:IsShowing()) then
            self.curPanel = PanelType.Emblem
            self:DoTween(true)
            self.panel.Delegate.gameObject:SetActiveEx(false)
            UIMgr:DeActiveUI(UI.CtrlNames.DelegateWheel)
            UIMgr:ActiveUI(UI.CtrlNames.Emblem)
            self.panel.DelegateTips.gameObject:SetActiveEx(false)
        end
    end)

    MLuaUIListener.Get(self.panel.BtnIcon.UObj)
    self.panel.BtnIcon.Listener.onClick = function(go, ed)
        self:OnBtnIcon(go, ed)
    end
    MLuaUIListener.Get(self.panel.BtnInfo.gameObject)
    self.panel.BtnInfo.Listener.onClick = function(go, eventData)
        UIMgr:ActiveUI(UI.CtrlNames.Howtoplay, function(ctrl)
            ctrl:ShowPanel(MGlobalConfig:GetInt("EntrustGameTips"))
        end)
    end
    self.panel.tipBtn:SetActiveEx(false)
    self:RefreshBoxSlider()
    self:RefreshEmblemSlider()

    self.rewardProcessor = self:NewRedSign({
        Key = eRedSignKey.DelegateAward,
        ClickButton = self.panel.BtnBox
    })

    --月卡标记点击事件
    self.panel.MonthCardFlag:AddClick(function ()
        self.panel.TipsPart.UObj:SetActiveEx(true)
        self.panel.TipText.LabText = Lang("MONTHCARD_TIPS")

        local l_worldPos = self.panel.MonthCardFlag.Transform.position
        local l_localPos = CoordinateHelper.WorldPositionToLocalPosition(l_worldPos, self.panel.TipsPart.Transform)
        self.panel.TipPanel.RectTransform.anchoredPosition = Vector2.New(l_localPos.x + 5, l_localPos.y + 35)
    end)
    --月卡提示关闭点击事件
    self.panel.BtnCloseTip:AddClick(function ()
        self.panel.TipsPart.UObj:SetActiveEx(false)
    end)
end --func end
--next--
function DelegatePanelCtrl:Uninit()
    if self.rewardProcessor then
        self:UninitRedSign(self.rewardProcessor)
        self.rewardProcessor = nil
    end
    UIMgr:DeActiveUI(UI.CtrlNames.Emblem)
    UIMgr:DeActiveUI(UI.CtrlNames.DelegateWheel)
    self.dailyItemPool = nil
    self.awardItemPool = nil
    super.Uninit(self)

end --func end
--next--
function DelegatePanelCtrl:OnActive()

    if self.uiPanelData ~= nil then
        if self.uiPanelData.Tab == 1 then
            --默认方式开启委托
            self.panel.BtnList.TogEx.isOn = true
        elseif self.uiPanelData.Tab == 2 then
            --直接打开转盘界面
            self.panel.BtnBox.TogEx.isOn = true
        elseif self.uiPanelData.Tab == 3 then
            --直接打开纹章界面
            self.panel.BtnEmblem.TogEx.isOn = true
        end
    end

    self.tipsIconCache = {}

    self.panel.DelegateTips.gameObject:SetActiveEx(false)
    --self:RefreshBox()
    self:RefreshDelegates()
    --新手指引相关
    local l_beginnerGuideChecks = { "Entrust2", "Entrust3", "Entrust4" }
    MgrMgr:GetMgr("BeginnerGuideMgr").CheckShowBeginnerGuide(l_beginnerGuideChecks, self:GetPanelName())
end --func end
--next--
function DelegatePanelCtrl:OnDeActive()
    if self.tipsIconCache ~= nil then
        for i = 1, #self.tipsIconCache do
            local l_tip = self.tipsIconCache[i]
            if l_tip ~= nil then
                MResLoader:DestroyObj(l_tip)
            end
        end
    end

    if self.objTweenId > 0 then
        MUITweenHelper.KillTween(self.objTweenId)
        self.objTweenId = 0
    end
    UIMgr:DeActiveUI(UI.CtrlNames.Howtoplay)
end --func end
--next--
function DelegatePanelCtrl:Update()
    self.dailyItemPool:OnUpdate()
end --func end

--next--
function DelegatePanelCtrl:BindEvents()
    self:BindEvent(self.awardMgr.EventDispatcher, self.awardMgr.AWARD_PREWARD_MSG, self.OnGetReward)
    self:BindEvent(Data.PlayerInfoModel.COINCHANGE, Data.onDataChange, self.OnCoinChange)
    self:BindEvent(self.mgr.EventDispatcher, self.mgr.DELEGATE_UPDATE, function()
        self:RefreshBoxSlider()
        self:RefreshDelegates()
    end)
    self:BindEvent(Data.PlayerInfoModel.BASELV, Data.onDataChange, function()
        self:RefreshBoxSlider()
    end)
end --func end
--next--
--lua functions end

--lua custom scripts

function DelegatePanelCtrl:onSelectOne(index, data)
    self.dailyItemPool:SelectTemplate(index)
    self:OnClickItem(data)
end

function DelegatePanelCtrl:OpenWheel()
    self.panel.BtnBox.TogEx.isOn = true
end

function DelegatePanelCtrl:OpenDelegate()
    self.panel.BtnList.TogEx.isOn = true
end

function DelegatePanelCtrl:RefreshDelegates()
    if self.curPanel ~= PanelType.Delegate then return end
    
    self.panel.DailyItemTemplate.gameObject:SetActiveEx(false)
    local coinCount, maxCount = self.mgr:GetCertifatesInfo()
    self.panel.delegateTxt.LabText = StringEx.Format("{0}/{1}", tostring(coinCount), tostring(maxCount))
    local datas = self.mgr.GetDelegateDatas()
    self.dailyItemPool:ShowTemplates({ Datas = datas })
    if #datas > 0 then
        self:onSelectOne(1, datas[1])
    end
end

function DelegatePanelCtrl:OnBtnIcon(go, ed)
    local content = Lang("DELEGATE_ICON_TIP", self.mgr:GetMaxCertificates())
    content = MgrMgr:GetMgr("RichTextFormatMgr").FormatRichTextContent(content)
    self.panel.DelegateTips.gameObject:SetActiveEx(true)
    self.panel.DelegateTipsInfo.LabText = content

    for i = 1, #self.tipsIconCache do
        local l_tip = self.tipsIconCache[i]
        if l_tip ~= nil then
            MResLoader:DestroyObj(l_tip)
        end
    end
    self.tipsIconCache = {}
    local l_entrustLevelTable = TableUtil.GetEntrustLevelTable().GetTable()
    for i = 1, #l_entrustLevelTable do
        local l_data = l_entrustLevelTable[i]
        if l_data.BaseLevel > 16 then
            local l_tip = self:CloneObj(self.panel.IconTpl.gameObject)
            l_tip.transform:SetParent(self.panel.IconList.transform)
            l_tip.transform:SetLocalScaleOne()
            l_tip.gameObject:SetActiveEx(true)
            l_tip:GetComponent("MLuaUICom").LabText = StringEx.Format(Lang("Level"), tostring(l_data.BaseLevel))
            l_tip.transform:Find("TipsCount"):GetComponent("MLuaUICom").LabText = tostring(l_data.EntrustUpperLimit)
            table.insert(self.tipsIconCache, l_tip)
        end
    end
end

function DelegatePanelCtrl:OnClickItem(data)
    if data then
        local sdata = TableUtil.GetEntrustActivitiesTable().GetRowByMajorID(data.id)
        if not sdata then
            logError("find entrust activity sdata fail @戴瑞轩", data.id)
            return
        end
        local curCertificates, _ = MgrMgr:GetMgr("DelegateModuleMgr").GetCertifatesInfo()
        self.panel.SystemIcon:SetRawTex("Delegate/" .. sdata.SystemIcon)
        self.panel.InfoTitle.LabText = sdata.ActivityName

        self.panel.InfoContext.LabText = Lang(sdata.Text)
        local l_extraStr = sdata.ExtraText
        if Common.Utils.IsNilOrEmpty(l_extraStr) then
            self.panel.InfoExtra:SetActiveEx(false)
        else
            self.panel.InfoExtra:SetActiveEx(true)
            self.panel.InfoExtraText.LabText = l_extraStr
        end
        local baseLv = self.mgr.GetDelegateJoinBaseLv(data)
        local cost = 0
        local l_costs = Common.Functions.VectorSequenceToTable(sdata.Cost)
        if #l_costs > 0 then
            cost = l_costs[1][2]
        end
        self.panel.InfoMod.LabText = CommonUI.Color.FormatWord(sdata.Mode)
        if curCertificates < cost then
            self.panel.InfoCondition.LabText = RoColor.FormatWord(GetColorText(Lang("DELEGATE_DAILY_TIME_TEXT", cost), RoColorTag.Red))
        else
            self.panel.InfoCondition.LabText = Lang("DELEGATE_DAILY_TIME_TEXT", cost)
        end
        --条件（花费）
        self.panel.ConditionNode:SetActiveEx(cost > 0)
        --次数
        if IsEmptyOrNil(sdata.ActivityTime) then
            self.panel.InfoNum.LabText = Lang("DAILY_NOT_LIMIT")
        else
            local infoTxt = StringEx.Format("{0}/{1}", data.finish_times, data.max_times)
            self.panel.InfoNum.LabText = infoTxt
        end
        --月卡标志
        self.panel.MonthCardFlag:SetActiveEx(data.monthCardFlag or false)  
        --奖励预览
        self.awardMgr.GetPreviewRewards(sdata.RewardID)
        self.panel.infoGoBtn:SetGray(MPlayerInfo.Lv < baseLv)
        self.panel.infoGoBtn:AddClick(function()
            if MPlayerInfo.Lv < baseLv then
                return
            end
            if curCertificates < cost then
                CommonUI.Dialog.ShowYesNoDlg(true, nil, Lang("CERTIFICATION_BOOK_NOT_ENOUGH"), function()
                    self:OnClickGo(data)
                end, nil, nil, 3, "CERTIFICATION_BOOK_NOT_ENOUGH")
            else
                self:OnClickGo(data)
            end
        end)
        self.panel.tipBtn:SetActiveEx(sdata.GameTipsKey > 0)
        self.panel.tipBtn:AddClick(function()
            UIMgr:ActiveUI(UI.CtrlNames.Howtoplay, function(ctrl)
                ctrl:ShowPanel(sdata.GameTipsKey)
            end)
        end)
    end
end

function DelegatePanelCtrl:GetTaskIdBySystemId(systemId)
    local ret = 0
    local openSdata = TableUtil.GetOpenSystemTable().GetRowById(systemId)
    if openSdata then
        for i = 0, openSdata.TaskId.Count - 1 do
            if openSdata.TaskId[i] > 0 then
                ret = openSdata.TaskId[i]
                break
            end
        end
    end
    return ret
end

-- 委托任务的前置任务
function DelegatePanelCtrl:GetFrontTaskId(sdata)
    local ret = 0
    local sysId = 0
    local openSystemMgr = MgrMgr:GetMgr("OpenSystemMgr")
    if not openSystemMgr.IsSystemOpen(sdata.SystemID) then
        ret = self:GetTaskIdBySystemId(sdata.SystemID)
        sysId = sdata.SystemID
    end
    if ret == 0 then
        for i = 0, sdata.DependentSystemID.Count - 1 do
            local systemId = sdata.DependentSystemID[i]
            if not openSystemMgr.IsSystemOpen(systemId) then
                ret = self:GetTaskIdBySystemId(systemId)
                sysId = systemId
                if ret > 0 then
                    break
                end
            end
        end
    end
    return ret, sysId
end

function DelegatePanelCtrl:OnClickGo(data)
    -- 判断依赖
    local sdata = data.sdata
    local taskMgr = MgrMgr:GetMgr("TaskMgr")
    local frontTaskId, sysId = self:GetFrontTaskId(sdata)
    if frontTaskId > 0 then
        local openSystemSdata = TableUtil.GetOpenSystemTable().GetRowById(sysId)
        local sysName = openSystemSdata and openSystemSdata.Title or ""
        CommonUI.Dialog.ShowYesNoDlg(true, nil, Lang("DELEGATE_GUIDE_TEXT", sysName), function()
            taskMgr.OnQuickTaskClickWithTaskId(frontTaskId)
            self:Close()
        end)
        return
    end
    local l_sceneInfo = sdata.Position
    local method = MgrMgr:GetMgr("SystemFunctionEventMgr").GetSystemFunctionEvent(sdata.SystemID)
    local delegateType = sdata.ActivityType
    if delegateType == GameEnum.DelegateType.Task then
        local taskId = data.taskId
        if taskId ~= 0 then
            local status = taskMgr.GetPreShowTaskStatusWithTaskId(taskId)
            if status == ModuleMgr.TaskMgr.ETaskStatus.Taked
                    or status == ModuleMgr.TaskMgr.ETaskStatus.CanFinish then
                taskMgr.OnQuickTaskClickWithTaskId(taskId)
            else
                taskMgr.NavToTaskAcceptNpc(taskId)
            end
            self:Close()
        else
            logError("委托任务没有配置taskId @戴瑞轩 委托id = {0}", sdata.MajorID)
        end
    elseif delegateType == GameEnum.DelegateType.DanceTask then
        local taskId = data.taskId
        if taskId ~= 0 then
            local status = taskMgr.GetPreShowTaskStatusWithTaskId(taskId)
            if status == taskMgr.ETaskStatus.Taked then
                local l_subTasks = MgrMgr:GetMgr("DelegateModuleMgr").GetSubTasksByTaskId(taskId)
                if l_subTasks ~= nil then
                    for i = 1, #l_subTasks do
                        local l_subTaskStatus = taskMgr.GetPreShowTaskStatusWithTaskId(l_subTasks[i])
                        if l_subTaskStatus == taskMgr.ETaskStatus.Taked or l_subTaskStatus == taskMgr.ETaskStatus.CanFinish then
                            taskMgr.OnQuickTaskClickWithTaskId(l_subTasks[i])
                            break
                        end
                    end
                end
            else
                taskMgr.NavToTaskAcceptNpc(taskId)
            end
            self:Close()
        else
            logError("委托任务没有配置taskId @戴瑞轩 委托id = {0}", sdata.MajorID)
        end
    elseif delegateType == GameEnum.DelegateType.WorldPve then
        self:Close()
        UIMgr:ActiveUI(UI.CtrlNames.WorldMap)
    else
        local l_npcID = sdata.NpcID
        if l_npcID and l_npcID > 0 then
            local l_sceneId = 0
            l_sceneInfo = l_sceneInfo[0]
            l_sceneId = l_sceneInfo[0]
            if l_sceneId > 0 then
                self:Close()
                MTransferMgr:GotoNpc(l_sceneId, l_npcID, function()
                    MgrMgr:GetMgr("NpcMgr").TalkWithNpc(l_sceneId, l_npcID)
                end)
                return
            end
        end
        if l_sceneInfo.Length == 1 then
            l_sceneInfo = l_sceneInfo[0]
            local l_sceneId = l_sceneInfo[0]
            local l_scenePos = Vector3.New(l_sceneInfo[1], l_sceneInfo[2], l_sceneInfo[3])
            if l_sceneId and l_sceneId > 0 then
                MTransferMgr:GotoPosition(MLuaCommonHelper.Int(l_sceneId), l_scenePos, method)
                self:Close()
                return
            end
        end
        if l_sceneInfo.Length > 1 then
            local sceneTb = {}
            local posTb = {}
            local j = 1
            while j <= l_sceneInfo.Length do
                local l_targetPosInfo = l_sceneInfo[j - 1]
                sceneTb[j] = l_targetPosInfo[0]
                posTb[j] = Vector3.New(l_targetPosInfo[1], l_targetPosInfo[2], l_targetPosInfo[3])
                j = j + 1
            end

            MgrMgr:GetMgr("DelegateModuleMgr").ShowItemAchievePlacePanel(sdata.MajorID, function()
                method()
                self:Close()
            end)
        end
    end
end

function DelegatePanelCtrl:Close()
    UIMgr:DeActiveUI(UI.CtrlNames.DelegatePanel)
end

function DelegatePanelCtrl:OnGetReward(awardPreviewRes)
    local datas = MgrMgr:GetMgr("AwardPreviewMgr").HandleAwardRes(awardPreviewRes)
    self.awardItemPool:ShowTemplates({ Datas = datas })
end

function DelegatePanelCtrl:OnCoinChange()
    local currentCount, maxCount = self.mgr.GetCertifatesInfo()
    self.panel.delegateTxt.LabText = StringEx.Format("{0}/{1}", tostring(currentCount), tostring(maxCount))
end

function DelegatePanelCtrl:RefreshBoxSlider()
    local l_rows = TableUtil.GetEntrustLevelTable().GetTable()
    local l_rowCount = #l_rows
    local l_target = nil
    for i = 1, l_rowCount do
        local l_row = l_rows[i]
        if not l_target then
            l_target = l_row
        end
        if tonumber(MPlayerInfo.Lv) < l_row.BaseLevel then
            break
        end
        l_target = l_row
    end
    local l_value = 0
    if l_target then
        l_value = tonumber(self.mgr.GetCertificatesCost()) / tonumber(l_target.RewardBoxLimit)
    end
    self.panel.boxSlider.Slider.value = l_value
    return l_value
end

function DelegatePanelCtrl:RefreshEmblemSlider()
    local l_emblemIds = self.mgr.GetEmblemIds()
    local l_data = {}
    for i, v in ipairs(l_emblemIds) do
        local l_count = Data.BagModel:GetCoinOrPropNumById(v)
        if l_count > 0 then
            table.insert(l_data, { id = v, count = l_count })
        end
    end

    local l_value = table.ro_size(l_data) / table.ro_size(l_emblemIds)
    self.panel.emblemSlider.Slider.value = l_value
    return l_value
end

function DelegatePanelCtrl:DoTween(fadeOut)
    local tweenType = UITweenType.UpAlpha
    local tweenDelta = 32
    local tweenTime = 0.3
    if self.objTweenId > 0 then
        MUITweenHelper.KillTween(self.objTweenId)
        self.objTweenId = 0
    end
    self.objTweenId = Common.CommonUIFunc.TweenUI(self.delegateCanvase.gameObject, tweenType, tweenDelta, tweenTime, fadeOut, function()
        self.objTweenId = 0
        if self.uObj ~= nil then
            --self.delegateCanvase.enabled = not fadeOut
            MLuaCommonHelper.SetLocalPos(self.delegateCanvase.gameObject, 0, 0, 0)
            MLuaCommonHelper.SetRectTransformOffset(self.delegateCanvase.gameObject, 0, 0, 0, 0)
        end
    end)

end
--lua custom scripts end

return DelegatePanelCtrl
