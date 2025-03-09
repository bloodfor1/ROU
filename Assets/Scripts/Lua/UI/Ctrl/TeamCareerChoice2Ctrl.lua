--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/TeamCareerChoice2Panel"
--lua requires end

--lua model
module("UI", package.seeall)

--lua model end

--lua fields
local super = UI.UIBaseCtrl
--lua fields end

--lua class define
TeamCareerChoice2Ctrl = class("TeamCareerChoice2Ctrl", super)
--lua class define end

--lua functions
function TeamCareerChoice2Ctrl:ctor()
    super.ctor(self, CtrlNames.TeamCareerChoice2, UILayer.Function, nil, ActiveType.Normal)
end --func end
--next--
function TeamCareerChoice2Ctrl:Init()
    self.panel = UI.TeamCareerChoice2Panel.Bind(self)
    super.Init(self)
    self:_initConfig()
    self:_initWidgets()
end --func end
--next--
function TeamCareerChoice2Ctrl:Uninit()
    self.panel.Btn_MatchBrief.Listener.onClick=nil
    self.panel.Btn_MatchBrief.Listener.onDrag=nil
    super.Uninit(self)

    self.panel = nil
    self.timestamp = -1
    DataMgr:GetData("TeamData").MatchTimeStamp = -1

end --func end
--next--
function TeamCareerChoice2Ctrl:OnActive()
    self:_onActive(self.uiPanelData.type)
    self.timestamp = DataMgr:GetData("TeamData").MatchTimeStamp
    if self.timestamp == -1 or self.timestamp == 0 then
        self.timestamp = Common.TimeMgr.GetNowTimestamp()
    end
end --func end
--next--
function TeamCareerChoice2Ctrl:OnDeActive()
    -- do nothing
end --func end
--next--
function TeamCareerChoice2Ctrl:Update()
    -- do nothing
    if self.timestamp ~= -1 then
        local time = Common.TimeMgr.GetNowTimestamp() - self.timestamp
        local str = ExtensionByQX.TimeHelper.SecondConvertTime(tonumber(time), "mm:ss")
        self.panel.Txt_time.LabText = str
        self.panel.Time.LabText = str
    end
end --func end
--next--
function TeamCareerChoice2Ctrl:BindEvents()
    -- do nothing
    self:BindEvent(MgrMgr:GetMgr("TeamLeaderMatchMgr").EventDispatcher, MgrMgr:GetMgr("TeamLeaderMatchMgr").LEADER_MATCH_SELECT_DUTY, self._refreshTeamMember)
end --func end
--next--
--lua functions end

--lua custom scripts
function TeamCareerChoice2Ctrl:_initConfig()
    self._matchType = GameEnum.ETeamMatchProcessState.None

    self._tagConfig = {
        TemplateClassName = "TeamPlayerDutyTag",
        TemplatePath = "UI/Prefabs/TeamPlayerDutyTag",
        TemplateParent = self.panel.Dummy_SinglePersonMatch.transform
    }

    self._memberDutyConfig = {
        TemplateClassName = "TeamMemberSingle",
        TemplatePath = "UI/Prefabs/TeamMemberSingle",
        TemplateParent = self.panel.Dummy_Member.transform,
        Method = function(showIndex)
            self:_onDutyClick(showIndex)
        end
    }
end

function TeamCareerChoice2Ctrl:_initWidgets()
    self._tags = self:NewTemplatePool(self._tagConfig)
    self._members = self:NewTemplatePool(self._memberDutyConfig)

    local onDetail = function()
        if self.isOnDrag then
            self.isOnDrag = false
            return
        end
        self:_onDetail()
    end

    local onContinue = function()
        self:_onContinue()
    end

    local onCancel = function()
        self:_onCancel()
    end
    self.isOnDrag = false
    self.panel.Btn_MatchBrief.Listener.onClick = onDetail
    self.panel.Btn_Continue:AddClick(onContinue)
    self.panel.Btn_Stop:AddClick(onCancel)
    self.panel.Btn_MatchBrief.Listener.onDrag = function(go, eventData)
        self.isOnDrag = true
        self:_updateBriefBtnPos(go, eventData)
    end
end

--- 开启界面启动的数据
---@param data number
function TeamCareerChoice2Ctrl:_onActive(data)
    self._matchType = data
    self:_showBriefInfo()
    self:_setMatchData(data)
end

--- 开启那个详情窗口
function TeamCareerChoice2Ctrl:_showDetailInfo()
    self:_setDetailMode(true)
end

--- 开启简略窗口
function TeamCareerChoice2Ctrl:_showBriefInfo()
    self:_setDetailMode(false)
end

--- 数据层会保存按钮被修改的位置，关闭重新开启之后按钮会出现在之前设置的位置
function TeamCareerChoice2Ctrl:_setDetailMode(isDetail)
    local target = -1
    if self._matchType == GameEnum.ETeamMatchProcessState.PlayerMatch then
        target = DataMgr:GetData("TeamData").autoPairTarget or -1
    else
        target = DataMgr:GetData("TeamData").myTeamInfo.teamSetting.target or -1
    end
    if target == -1 then
        UIMgr:DeActiveUI(UI.CtrlNames.TeamCareerChoice2)
        return
    end
    local targetName = TableUtil.GetTeamTargetTable().GetRowByID(target).Name
    self.panel.Txt_title.LabText = StringEx.Format(Common.Utils.Lang("TEAM_MATCH_DURING"), targetName)
    self.panel.Dummy_MatchDetail.gameObject:SetActiveEx(isDetail)
    self.panel.Btn_MatchBrief.gameObject:SetActiveEx(not isDetail)
    if isDetail then
        return
    end

    --local matchMgr = MgrMgr:GetMgr("TeamMatchProcessMgr")
    --local pos = matchMgr.GetCurrentPos()
    --self.panel.Btn_MatchBrief.transform:SetLocalPos(pos.x, pos.y, pos.z)
end

--- 更新拖动的位置
function TeamCareerChoice2Ctrl:_updateBriefBtnPos(go, eventData)
    local targetPos = Common.CommonUIFunc.GetScreenDragPos(self.panel.Btn_MatchBrief.RectTransform, eventData.position)
    local l_cgPos = MUIManager.UICamera:ScreenToWorldPoint(targetPos)
    l_cgPos.z = 0
    --self.panel.Btn_MatchBrief.RectTransform:SetLocalPos(l_cgPos.x, l_cgPos.y, l_cgPos.z)
    self.panel.Btn_MatchBrief.RectTransform.position = l_cgPos
    --local localPos = { x = l_cgPos.x, y = l_cgPos.y, z = l_cgPos.z }
    --local matchMgr = MgrMgr:GetMgr("TeamMatchProcessMgr")
    --matchMgr.SetMatchState(localPos)
end

--- 点击继续触发
function TeamCareerChoice2Ctrl:_onContinue()
    self:_setDetailMode(false)
    --local data = {}
    --local teamData = DataMgr:GetData("TeamData")
    --local target = teamData.myTeamInfo.teamSetting.target
    --for i = #teamData.myTeamInfo.memberList + 1, teamData.maxTeamNumber do
    --    table.insert(data, MgrMgr:GetMgr("TeamLeaderMatchMgr").GetSlotDuty(i))
    --end
    --if DataMgr:GetData("TeamData").myTeamInfo.captainId == MPlayerInfo.UID then
    --    MgrMgr:GetMgr("TeamMgr").AutoPairOperate(DataMgr:GetData("TeamData").EAutoPairType.autoTypeStart, target, data)
    --end
end

--- 点击上面的小按钮触发
function TeamCareerChoice2Ctrl:_onDetail()
    self:_setDetailMode(true)
    self:_refreshTeamMember()
end

---@param data number @这里的传参只是一个数字，标记状态
function TeamCareerChoice2Ctrl:_setMatchData(data)
    local EMatchType = GameEnum.ETeamMatchProcessState
    local C_MATCH_FUNC_MAP = {
        [EMatchType.PlayerMatch] = self._setPlayerMatchMode,
        [EMatchType.TeamMatch] = self._setTeamMatchMode,
    }

    local func = C_MATCH_FUNC_MAP[data]
    if nil == func then
        logError("[TeamMatch] invalid type: " .. tostring(data))
        return
    end
    self.type = data
    func(self)
end

function TeamCareerChoice2Ctrl:_updateMatchTime(time)

end

--- 点击取消触发
function TeamCareerChoice2Ctrl:_onCancel()
    UIMgr:DeActiveUI(UI.CtrlNames.TeamCareerChoice2)
    MgrMgr:GetMgr("TeamMgr").AutoPairOperate(DataMgr:GetData("TeamData").EAutoPairType.autoTypeEnd, DataMgr:GetData("TeamData").myTeamInfo.teamSetting.target)
    self.timestamp = -1
    DataMgr:GetData("TeamData").MatchTimeStamp = -1
    -- todo 停止计时
end

function TeamCareerChoice2Ctrl:_setPlayerMatchMode()
    local isFree = TableUtil.GetTeamTargetTable().GetRowByID(DataMgr:GetData("TeamData").myTeamInfo.teamSetting.target).IsDuty
    self.panel.Dummy_SinglePersonMatch.gameObject:SetActiveEx(isFree)
    self.panel.Dummy_FreeMatch.gameObject:SetActiveEx(not isFree)
    self.panel.Txt_MatchNum:SetActiveEx(false)
    self.panel.Dummy_LeaderMatch.gameObject:SetActiveEx(false)

    local matchMgr = MgrMgr:GetMgr("TeamMatchProcessMgr")
    local showTags = matchMgr.GetSelfDutyIDs()
    local paramWrap = { Datas = showTags }
    self._tags:ShowTemplates(paramWrap)
end

function TeamCareerChoice2Ctrl:_setTeamMatchMode()
    self.panel.Dummy_SinglePersonMatch.gameObject:SetActiveEx(false)
    self.panel.Dummy_FreeMatch.gameObject:SetActiveEx(false)
    self.panel.Dummy_LeaderMatch.gameObject:SetActiveEx(false)
    self:_refreshTeamMember()
end

--- 刷新组队界面的显示情况
function TeamCareerChoice2Ctrl:_refreshTeamMember()
    if self.panel == nil then
        return
    end
    if self.type and self.type == GameEnum.ETeamMatchProcessState.PlayerMatch then
        return
    end
    local matchMgr = MgrMgr:GetMgr("TeamMatchProcessMgr")
    local leaderMgr = MgrMgr:GetMgr("TeamLeaderMatchMgr")
    local memberStates, isFree = matchMgr.GetMemberInfoList()
    self.panel.Dummy_FreeMatch.gameObject:SetActiveEx(isFree)
    self.panel.Txt_MatchNum:SetActiveEx(isFree)
    self.panel.Dummy_LeaderMatch.gameObject:SetActiveEx(not isFree)
    if not isFree then
        local TemData = {}
        for i = 1, #memberStates do
            table.insert(TemData, memberStates[i])
        end
        for i = #memberStates + 1, DataMgr:GetData("TeamData").maxTeamNumber do
            table.insert(TemData, { dutyID = leaderMgr.GetSlotDuty(i), isEmptyPos = true, canpick = false })
        end
        local templateParam = { Datas = TemData }
        self._members:ShowTemplates(templateParam)
    else
        self.panel.Txt_MatchNum.LabText = StringEx.Format(Common.Utils.Lang("TEAM_MATCH_FREE_WORD"), #memberStates, DataMgr:GetData("TeamData").maxTeamNumber)
    end
    -- todo 调整文字状态
end

function TeamCareerChoice2Ctrl:_onDutyClick(idx)
    if nil == idx then
        logError("[TeamDuty] invalid param")
        return
    end
    if DataMgr:GetData("TeamData").myTeamInfo.captainId == MPlayerInfo.UID then
        ---@type TeamSingleSlotOption
        local param = {
            showIdx = idx,
        }

        UIMgr:ActiveUI(UI.CtrlNames.TeamMemberDutyChoice, param)
    end
end

--lua custom scripts end
return TeamCareerChoice2Ctrl