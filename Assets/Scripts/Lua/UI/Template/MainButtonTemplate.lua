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
---@class MainButtonTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field SystemName MoonClient.MLuaUICom
---@field SystemIcon MoonClient.MLuaUICom
---@field SystemButton MoonClient.MLuaUICom
---@field RedPromptParent MoonClient.MLuaUICom
---@field NoticeText MoonClient.MLuaUICom
---@field NoticeImg MoonClient.MLuaUICom
---@field NoticeCloseBtn MoonClient.MLuaUICom
---@field NoticeBtn MoonClient.MLuaUICom
---@field Effect MoonClient.MLuaUICom
---@field ButtonNotice MoonClient.MLuaUICom

---@class MainButtonTemplate : BaseUITemplate
---@field Parameter MainButtonTemplateParameter

MainButtonTemplate = class("MainButtonTemplate", super)
--lua class define end

--lua functions
function MainButtonTemplate:Init()

    super.Init(self)
    self.activityId = 0
    self.RedSignProcessorList = nil
    self:CloseNotice(false)
    self.Parameter.NoticeBtn:AddClick(function()
        if self.activityId ~= 0 then
            UIMgr:ActiveUI(UI.CtrlNames.DailyTask, { distinationActivityId = self.activityId })
        end
        self:CloseNotice(true)
    end)
    self.Parameter.NoticeCloseBtn:AddClick(function()
        if self.mainButtonNoticeTimer then
            self:StopUITimer(self.mainButtonNoticeTimer)
            self.mainButtonNoticeTimer = nil
        end
        self:CloseNotice(true)
    end)

end --func end
--next--
function MainButtonTemplate:OnDestroy()

    self.openSystemId = -1
    self.SystemPlace = -1
    self.SortIndex = 1
    self.updateTimer = nil
    self.lastState1 = nil
    self.lastState2 = nil
    if self.mainButtonNoticeTimer then
        self:StopUITimer(self.mainButtonNoticeTimer)
        self.mainButtonNoticeTimer = nil
    end
    self:ClearUpdateTimer()
    self.RedSignProcessorList = nil

end --func end
--next--
function MainButtonTemplate:OnSetData(data)

    self:showButton(data)

end --func end
--next--
function MainButtonTemplate:OnDeActive()


end --func end
--next--
function MainButtonTemplate:BindEvents()


end --func end
--next--
--lua functions end

--lua custom scripts
local eShowRedSignKey = {
    [MgrMgr:GetMgr("OpenSystemMgr").eSystemId.LandingAward] = { eRedSignKey.LandingAward },
    [MgrMgr:GetMgr("OpenSystemMgr").eSystemId.Skill] = { eRedSignKey.MainSkill },
    [MgrMgr:GetMgr("OpenSystemMgr").eSystemId.Festival] = { eRedSignKey.TimeActivityPoint },
    [MgrMgr:GetMgr("OpenSystemMgr").eSystemId.Risk] = { eRedSignKey.Activity },
    [MgrMgr:GetMgr("OpenSystemMgr").eSystemId.Sweater] = { eRedSignKey.Stall },
    [MgrMgr:GetMgr("OpenSystemMgr").eSystemId.Garderobe] = { eRedSignKey.Garderobe },
    [MgrMgr:GetMgr("OpenSystemMgr").eSystemId.LifeProfession] = { eRedSignKey.LifeProfession },
    [MgrMgr:GetMgr("OpenSystemMgr").eSystemId.Welfare] = { eRedSignKey.Welfare },
    [MgrMgr:GetMgr("OpenSystemMgr").eSystemId.Achievement] = { eRedSignKey.Achievement },
    [MgrMgr:GetMgr("OpenSystemMgr").eSystemId.BeginnerBook] = { eRedSignKey.BeginnerBook },
    [MgrMgr:GetMgr("OpenSystemMgr").eSystemId.Delegate] = { eRedSignKey.DelegateButtonEx },
    [MgrMgr:GetMgr("OpenSystemMgr").eSystemId.Guild] = { eRedSignKey.Guild },
    [MgrMgr:GetMgr("OpenSystemMgr").eSystemId.TimeLimitPay] = { eRedSignKey.TimeLimitPay },
    [MgrMgr:GetMgr("OpenSystemMgr").eSystemId.Illustrator] = { eRedSignKey.BeginnerBook },
    [MgrMgr:GetMgr("OpenSystemMgr").eSystemId.Mercenary] = { eRedSignKey.Mercenary },
    [MgrMgr:GetMgr("OpenSystemMgr").eSystemId.Mall] = { eRedSignKey.Shop, eRedSignKey.FatherShop },
    [MgrMgr:GetMgr("OpenSystemMgr").eSystemId.FirstRecharge] = { eRedSignKey.FirstRechargeButtonEffect, eRedSignKey.FirstRechargeOuter },
}

local defaultSoundName = "event:/UI/UI_Common"

local EButtonSoundNames = {
    [MgrMgr:GetMgr("OpenSystemMgr").eSystemId.Trade] = "event:/UI/UI_Trade",
    [MgrMgr:GetMgr("OpenSystemMgr").eSystemId.Delegate] = "event:/UI/UI_Request",
    [MgrMgr:GetMgr("OpenSystemMgr").eSystemId.Welfare] = "event:/UI/UI_PrizePanel",
    [MgrMgr:GetMgr("OpenSystemMgr").eSystemId.Skill] = "event:/UI/UI_SkillPanel",
}

local l_buttonUpdateFuncConfig = {
    [MgrMgr:GetMgr("OpenSystemMgr").eSystemId.Welfare] = "UpdateWelfareMainButton",
}

function MainButtonTemplate:showButton(data)
    self.openSystemId = data.OpenSystemId
    local openTable = TableUtil.GetOpenSystemTable().GetRowById(self.openSystemId)
    self.SystemPlace = openTable.SystemPlace
    if openTable and openTable.SystemIcon and not string.ro_isEmpty(openTable.SystemIcon) then
        local l_atlas, l_atlasIcon = Common.CommonUIFunc.GetMainPanelAtlasAndIconByFuncId(self.openSystemId)
        self.Parameter.SystemIcon:SetSpriteAsync(l_atlas, l_atlasIcon)
    end
    self.Parameter.SystemName.LabText = openTable.Title
    self.Parameter.SystemButton:AddClick(function()
        if data.OpenSystemId == MgrMgr:GetMgr("OpenSystemMgr").eSystemId.Skill then

            MgrMgr:GetMgr("SkillLearningMgr").HideSkillMultiTalentRedSign()
        end
        local buttonMethod = MgrMgr:GetMgr("SystemFunctionEventMgr").GetSystemFunctionEvent(data.OpenSystemId)
        if buttonMethod then
            buttonMethod()
        end

        local l_soundName = EButtonSoundNames[data.OpenSystemId]
        if l_soundName == nil then
            l_soundName = defaultSoundName
        end

        MAudioMgr:Play(l_soundName)

        self:MethodCallback(data.OpenSystemId)
    end)
    self:transform().name = openTable.Id
    self.SortIndex = openTable.SortID
    self.originalTitle = openTable.Title
    self.effectId = nil
    self:_createRedSign(data.OpenSystemId)

    self:SetupUpdateTimer()
end

function MainButtonTemplate:_createRedSign(openSystemId)
    local redSignKeyList = eShowRedSignKey[openSystemId]
    if redSignKeyList == nil then
        return
    end
    if self.RedSignProcessorList then
        for i = 1, #self.RedSignProcessorList do
            self:UninitRedSign(self.RedSignProcessorList[i])
        end
    end
    self.RedSignProcessorList = {}
    for i = 1, #redSignKeyList do
        local redSign = self:NewRedSign({
            Key = redSignKeyList[i],
            ClickButton = self.Parameter.SystemButton,
            RedSignParent = self.Parameter.RedPromptParent.Transform
        })
        table.insert(self.RedSignProcessorList, redSign)
    end
end

function MainButtonTemplate:ShowButton(isShow)
    if isShow then
        local l_MainUiTableData = MgrMgr:GetMgr("SceneEnterMgr").CurrentMainUiTableData
        local l_h1 = l_MainUiTableData.MainIcon
        local l_MainIcons = Common.Functions.VectorToTable(l_h1)
        if table.ro_contains(l_MainIcons, self.openSystemId) then
            self:SetGameObjectActive(true)
        else
            self:SetGameObjectActive(false)
        end
    else
        self:SetGameObjectActive(false)
        self:CloseNotice(false)
    end
end

--主界面按钮上显示通知
function MainButtonTemplate:ShowMainButtonNotice(pushId, args)
    args = args or {}
    self.activityId = args.activityId or 0
    self.startTimeStamp = args.startTimeStamp
    self.pushId = pushId

    local l_pushRow = TableUtil.GetDailyActivitiesPushTable().GetRowByPushMesId(pushId)
    if l_pushRow then
        if self.mainButtonNoticeTimer then
            self:StopUITimer(self.mainButtonNoticeTimer)
            self.mainButtonNoticeTimer = nil
        end
        self.Parameter.ButtonNotice:SetActiveEx(true)
        local l_msg = l_pushRow.MessageText
        self.Parameter.NoticeText.LabText = StringEx.Format(l_msg, unpack(args.params or {}))
        if self.activityId ~= 0 then
            local l_activityRow = TableUtil.GetDailyActivitiesTable().GetRowById(self.activityId)
            if l_activityRow then
                self.Parameter.NoticeImg:SetSpriteAsync(l_activityRow.AtlasName, l_activityRow.IconName)
            end
        end
        self.mainButtonNoticeTimer = self:NewUITimer(function()
            self:CloseNotice(false)
        end, l_pushRow.PushLastTime)
        self.mainButtonNoticeTimer:Start()
    end
end

function MainButtonTemplate:CloseNotice(isSaveState)
    self.Parameter.ButtonNotice:SetActiveEx(false)
    if isSaveState then
        MgrMgr:GetMgr("DailyTaskMgr").SetActivityProcessed(self.pushId, self.activityId, self.startTimeStamp)
    end
end

function MainButtonTemplate:ClearUpdateTimer()

    self.lastState1 = nil
    self.lastState2 = nil

    if self.updateTimer then
        self:StopUITimer(self.updateTimer)
        self.updateTimer = nil
    end
end

function MainButtonTemplate:SetupUpdateTimer()

    self:ClearUpdateTimer()

    local l_updateFunc = self:GetMainButtonUpdateFuncBySystemId(self.openSystemId)
    if not l_updateFunc then
        return
    end

    l_updateFunc(self)

    self.updateTimer = self:NewUITimer(function()
        l_updateFunc(self)
    end, 0.2, -1, true)
    self.updateTimer:Start()
end

function MainButtonTemplate:GetMainButtonUpdateFuncBySystemId(systemId)

    if not l_buttonUpdateFuncConfig[systemId] then
        return
    end

    local l_func = self[l_buttonUpdateFuncConfig[systemId]]
    if not l_func then
        logError("MainButtonTemplate:GetMainButtonUpdateFuncBySystemId config error, 配置的FuncName错误", l_buttonUpdateFuncConfig[systemId])
        return
    end

    return l_func
end

function MainButtonTemplate:UpdateWelfareMainButton()

    local l_activityState = DataMgr:GetData("TimeLimitPayData").ActivityState
    if MgrMgr:GetMgr("TimeLimitPayMgr").Visible and l_activityState == LimitedOfferStatusType.LIMITED_OFFER_START then
        local l_idleState = DataMgr:GetData("TimeLimitPayData").CurIdleState
        if l_idleState == RoleActivityStatusType.ROLE_ACTIVITY_STATUS_ACTIVE then
            local l_remainningTime = DataMgr:GetData("TimeLimitPayData").FinishTime - Time.realtimeSinceStartup
            l_remainningTime = (l_remainningTime > 0) and l_remainningTime or 0
            local l_timeRet = Common.TimeMgr.GetDayTimeTable(math.floor(l_remainningTime))
            if l_timeRet.hour > 0 then
                self.Parameter.SystemName.LabText = Lang("TIME_LIMIT_PAY_ACTIVITY_FORMAT1", l_timeRet.hour, l_timeRet.min)
            else
                self.Parameter.SystemName.LabText = Lang("TIME_LIMIT_PAY_ACTIVITY_FORMAT1", l_timeRet.min, l_timeRet.sec)
            end
            if self.lastState1 then
                self.lastState1 = false
            end
            if self.lastState2 then
                self.lastState2 = false
            end
        else
            if not self.lastState1 then
                self.Parameter.SystemName.LabText = Lang("TIME_LIMIT_PAY_ACTIVITY")
                self.lastState1 = true
            end
        end
        if self.effectId == nil then
            self.Parameter.Effect.gameObject:SetActiveEx(false)
            self.effectId = 1
            local l_openId = MgrMgr:GetMgr("OpenSystemMgr").eSystemId.TimeLimitPay
            local l_openTable = TableUtil.GetOpenSystemTable().GetRowById(l_openId)
            if l_openTable and l_openTable.SystemIcon and not string.ro_isEmpty(l_openTable.SystemIcon) then
                local l_atlas, l_atlasIcon = Common.CommonUIFunc.GetFuncAtlasAndIconByFuncId(l_openId)
                self.Parameter.SystemIcon:SetSpriteAsync(l_atlas, l_atlasIcon)
            end
        end
    else
        if not self.lastState2 then
            self.Parameter.SystemName.LabText = self.originalTitle
            self.lastState2 = true

            local l_openTable = TableUtil.GetOpenSystemTable().GetRowById(self.openSystemId)
            if l_openTable and l_openTable.SystemIcon and not string.ro_isEmpty(l_openTable.SystemIcon) then
                local l_atlas, l_atlasIcon = Common.CommonUIFunc.GetMainPanelAtlasAndIconByFuncId(self.openSystemId)
                self.Parameter.SystemIcon:SetSpriteAsync(l_atlas, l_atlasIcon)
            end
        end
        if self.effectId then
            self.effectId = nil
        end
    end
end

function MainButtonTemplate:OnDeActive()

    self:ClearUpdateTimer()

    self.Parameter.Effect.gameObject:SetActiveEx(false)
    self.effectId = nil
end
--lua custom scripts end
return MainButtonTemplate