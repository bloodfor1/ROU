--this file is gen by script
--you can edit this file in custom part

--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/TeamSearchPanel"

--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua class define
local super = UI.UIBaseCtrl
TeamSearchCtrl = class("TeamSearchCtrl", super)
--lua class define end
local m_item = {}
--lua functions
function TeamSearchCtrl:ctor()
    super.ctor(self, CtrlNames.TeamSearch, UILayer.Function, nil, ActiveType.Exclusive)
end --func end
--next--
function TeamSearchCtrl:Init()
    MgrMgr:GetMgr("TeamMgr").QueryAutoPairStatus()
    self.panel = UI.TeamSearchPanel.Bind(self)
    super.Init(self)

    self.LineTem = nil

    MgrMgr:GetMgr("TeamMatchOptionMgr").SetLeaderDefault(true)
    self:InintPanel()

    --用于动画
    self.startPlayAni = false
    self.remainTime = 1
    self.maxPoint = 0
end --func end
--next--
function TeamSearchCtrl:Uninit()
    m_item = {}
    self.isFirstSetNum = 1

    super.Uninit(self)
    self.panel = nil
end --func end
--next--
function TeamSearchCtrl:OnActive()
    --打开界面 清除缓存列表
    DataMgr:GetData("TeamData").ClearTeamList()
    self.panel.BtnAutoTxt.LabText = Common.Utils.Lang("TEAM_AUTO_PAIRING")
end --func end
--next--
function TeamSearchCtrl:OnDeActive()

end --func end
--next--
function TeamSearchCtrl:Update()

    if self.panel == nil then
        return
    end
    if self.startPlayAni then
        self.remainTime = self.remainTime - UnityEngine.Time.deltaTime
        if self.remainTime <= 0 then
            if self.maxPoint < 3 then
                self.maxPoint = self.maxPoint + 1
                self.panel.BtnAutoTxt.LabText = self.panel.BtnAutoTxt.LabText .. "."
            else
                self.panel.BtnAutoTxt.LabText = Common.Utils.Lang("TEAM_AUTO_PAIRING")
                self.maxPoint = 0
            end
            self.remainTime = 1
        end
    end
end --func end

--next--
function TeamSearchCtrl:BindEvents()
    local TeamSearchDataUpdate = function()
        self:SetContentData(DataMgr:GetData("TeamData").TeamList)
    end
    self:BindEvent(MgrMgr:GetMgr("TeamMgr").EventDispatcher, DataMgr:GetData("TeamData").ON_TEAMSEARCH_INFO_UPDATE, TeamSearchDataUpdate)
    local TeamAutoPairState = function()
        self:RefreshPairBtn()
    end
    self:BindEvent(MgrMgr:GetMgr("TeamMgr").EventDispatcher, DataMgr:GetData("TeamData").ON_TEAM_AUTOPAIR_STATUS, TeamAutoPairState)
    --新成员入队 如果TeamSearch打开那么关闭
    local NewMemberFunc = function()
        UIMgr:DeActiveUI(UI.CtrlNames.TeamSearch)
    end
    self:BindEvent(MgrMgr:GetMgr("TeamMgr").EventDispatcher, DataMgr:GetData("TeamData").ON_NEW_TEAM_MEMBER, NewMemberFunc)
end --func end
--next--
--lua functions end

--lua custom scripts
function TeamSearchCtrl:InintPanel()
    self.isFirstSetNum = 1
    self.panel.ButtonClose:AddClick(function()
        UIMgr:DeActiveUI(UI.CtrlNames.TeamSearch)
    end)
    self:GetData()
    self.panel.BtnCreat:AddClick(function()
        UIMgr:DeActiveUI(UI.CtrlNames.TeamSearch)
        MgrMgr:GetMgr("TeamMgr").RequestCreateTeam(self.teamSetting.target)
    end)

    --刷新按钮
    self.panel.BtnRefresh:AddClick(function()
        if self.teamSetting.target then
            MgrMgr:GetMgr("TeamMgr").GetTeamList(self.teamSetting.target)
        end
    end)

    local onAutoMatchClick = function()
        self:_onAutoMatchClick()
    end

    local onValueChange = function(isOn)
        self:_onBecomeLeaderTogChange(isOn)
    end

    self.panel.BtnAuto:AddClick(onAutoMatchClick)
    self.panel.Tog_BeLeader.Tog.onValueChanged:AddListener(onValueChange)

    self.itemTb = {}
    self:CreateTargetInfo()
    self:InintContent()
    self:SetBtnCd()
end

--- 点击自动匹配之后触发的回调
function TeamSearchCtrl:_onAutoMatchClick()
    -- todo 如果目标副本是不需要职业匹配，就不显示，直接匹配
    -- todo 如果是标记了不再提示，也不提示，直接匹配
    -- todo 如果没有标记而且需要匹配职业，这个时候弹出窗口

    self:_startAutoPair()
end

--- 开始自动匹配
function TeamSearchCtrl:_startAutoPair()
    local data = DataMgr:GetData("TeamData").myTeamInfo
    if data then
        local teamSetting = self.teamSetting.target
        data.teamSetting.target = self.teamSetting.target
        if teamSetting == 1000 then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("TEAM_CAN_AUTOPAIR"))
            return
        end

        if teamSetting then
            if DataMgr:GetData("TeamData").isAutoPair then
                MgrMgr:GetMgr("TeamMgr").AutoPairOperate(DataMgr:GetData("TeamData").EAutoPairType.autoTypeEnd, teamSetting)
                return
            end
        end

        local isFreeMatch = TableUtil.GetTeamTargetTable().GetRowByID(teamSetting).IsDuty
        if not isFreeMatch then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("TEAM_MATCH_FREE"))
            MgrMgr:GetMgr("TeamMgr").AutoPairOperate(DataMgr:GetData("TeamData").EAutoPairType.autoTypeStart, teamSetting, {}, MgrMgr:GetMgr("TeamMatchOptionMgr").GetLeaderDefault())
        else
            local config = TableUtil.GetProfessionTable().GetRowById(MPlayerInfo.ProfessionId)
            local matchDuty = Common.Functions.VectorToTable(config.MatchDuty)
            if #matchDuty == 1 and MgrMgr:GetMgr("TeamMatchOptionMgr").AutoPair then
                MgrMgr:GetMgr("TeamMgr").AutoPairOperate(DataMgr:GetData("TeamData").EAutoPairType.autoTypeStart, teamSetting, { [1] = matchDuty[1] }, MgrMgr:GetMgr("TeamMatchOptionMgr").GetLeaderDefault())
                return
            end
            DataMgr:GetData("TeamData").SetAutoPairTarget(teamSetting)
            ---@type TeamMatchParam
            local l_opendata = {
                state = GameEnum.ETeamMatchOption.MatchTeam,
                profession = MPlayerInfo.ProfessionId,
            }
            UIMgr:ActiveUI(UI.CtrlNames.TeamCareerChoice1, l_opendata)
        end
    end

end

function TeamSearchCtrl:SetBtnCd()
    local cdRefresh = self.panel.BtnRefresh.gameObject:GetComponent("MUICdButton")
    local cd = MGlobalConfig:GetFloat("TeamSearchCD", 5)
    cdRefresh:SetCd(cd)
    cdRefresh:SetCdText(self.panel.BtnRefresh.gameObject.transform:GetChild(0):GetComponent("Text"))
    cdRefresh.cdAction = function()
        local leftTime = cdRefresh:GetLeftTime()
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("TEAM_SEARCH_CD", leftTime))
    end
end

function TeamSearchCtrl:RefreshPairBtn()
    local data = DataMgr:GetData("TeamData").myTeamInfo
    if data then
        if not DataMgr:GetData("TeamData").isAutoPair then
            self.panel.BtnAutoTxt.LabText = Common.Utils.Lang("TEAM_AUTO_PAIR")
            self.startPlayAni = false
        else
            self.panel.BtnAutoTxt.LabText = Common.Utils.Lang("TEAM_AUTO_PAIRING")
            self.startPlayAni = true
        end
    end
end

function TeamSearchCtrl:SetContentData(data)
    if data then
        self.ContentData = data
        self.LineTem:ShowTemplates({ Datas = self.ContentData })
        self.panel.NoData.gameObject:SetActiveEx(table.maxn(self.ContentData) <= 0)
    end
end

function TeamSearchCtrl:InintContent()
    if self.LineTem == nil then
        self.LineTem = self:NewTemplatePool({
            TemplateClassName = "TeamSearchLineTem",
            TemplatePrefab = self.panel.TeamSearchLineTem.gameObject,
            TemplateParent = self.panel.TeamContent.Transform,
        })
    end
end

function TeamSearchCtrl:CreateTargetInfo()
    self.teamSetting = DataMgr:GetData("TeamData").GetTempTeamSetting()
    self.teamSetting.target = DataMgr:GetData("TeamData").autoPairTarget
    self.panel.Templent.gameObject:SetActiveEx(true)
    for i = 1, table.ro_size(self.parentSortTable) do
        local id = self.parentSortTable[i]
        self.itemTb[i] = {}
        self.itemTb[i].id = id
        self.itemTb[i].ui = self:CloneObj(self.panel.Templent.gameObject)
        self.itemTb[i].ui.transform:SetParent(self.panel.Templent.transform.parent)
        self.itemTb[i].ui.transform:SetLocalScaleOne()
        self.itemTb[i].childToogle = {}
        self:ExportElement(self.itemTb[i])
        self:CreateChildItem(id, self.itemTb[i])

        local targetName = DataMgr:GetData("TeamData").GetTargetNameByIdInTeamSearchPanel(id)
        self.itemTb[i].parentItemTxtOn.LabText = targetName
        self.itemTb[i].parentItemTxtOff.LabText = targetName
        --如果子节点大小<=0 不显示箭头
        if table.ro_size(self.parentIdTb[id]) <= 0 then
            self.itemTb[i].arrowOn.gameObject:SetActiveEx(false)
            self.itemTb[i].arrowOff.gameObject:SetActiveEx(false)
        end

        self.itemTb[i].parentToogle.onValueChanged:AddListener(function(index)
            DataMgr:GetData("TeamData").ClearTeamList()
            m_item = {}
            self:_setBecomeLeaderTogState(id)

            if index then
                self:ShowChildItemById(id, true)
            else
                self:ShowChildItemById(id, false)
            end
        end)

        --找到目标的父节点
        if self.teamSetting.target - self.teamSetting.target % 1000 == id then
            self.itemTb[i].parentToogle.isOn = true
        else
            self.itemTb[i].parentToogle.isOn = false
        end
    end

    self.panel.Templent.gameObject:SetActiveEx(false)
end

--- 显示玩家是否希望成为队长
function TeamSearchCtrl:_setBecomeLeaderTogState(id)
    self.panel.Tog_BeLeader.gameObject:SetActiveEx(true)
    local teamMatchMgr = MgrMgr:GetMgr("TeamMatchOptionMgr")
    local togOn = teamMatchMgr.GetLeaderDefault()
    self.panel.Tog_BeLeader.Tog.isOn = togOn
end

--- 当玩家对希望成为队长按钮进行操作的时候会触发这个函数
function TeamSearchCtrl:_onBecomeLeaderTogChange(isOn)
    local currentTarget = self.teamSetting.target
    local teamMatchMgr = MgrMgr:GetMgr("TeamMatchOptionMgr")
    teamMatchMgr.SetLeaderDefault(isOn)
    if isOn then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("TEAM_SEARCH_WANT_BE_LEADER"))
    else
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("TEAM_SEARCH_DONT_WANT_BE_LEADER"))
    end
end

function TeamSearchCtrl:SetBtnGray(targetId)
    --log 附近的人 按钮灰
    local btnBg = self.panel.BtnAuto.transform:GetComponent("Image")

    if targetId == 1000 then
        if btnBg then
            btnBg.color = Color.New(0, 0, 0)
        end
        self.panel.BtnAutoTxt:SetOutLineEnable(false)
    else
        if btnBg then
            btnBg.color = Color.New(255, 255, 255, 255)
        end
        self.panel.BtnAutoTxt:SetOutLineEnable(true)
    end
end

function TeamSearchCtrl:CreateChildItem(id, sourceItem)
    if self.parentIdTb[id] then
        sourceItem.childItem.gameObject:SetActiveEx(false)
        for x = 1, table.ro_size(self.parentIdTb[id]) do
            local childId = self.parentIdTb[id][x]
            sourceItem.childToogle[childId] = {}
            sourceItem.childToogle[childId].id = self.parentIdTb[id][x]
            sourceItem.childToogle[childId].ui = self:CloneObj(sourceItem.childItem.gameObject)
            sourceItem.childToogle[childId].ui.transform:SetParent(sourceItem.childItem.parent)
            sourceItem.childToogle[childId].ui.transform:SetLocalScaleOne()
            self:ExportChild(sourceItem.childToogle[childId])
            sourceItem.childToogle[childId].childItemTxtOn.LabText = DataMgr:GetData("TeamData").GetTargetNameById(self.parentIdTb[id][x])
            sourceItem.childToogle[childId].childItemTxtOff.LabText = DataMgr:GetData("TeamData").GetTargetNameById(self.parentIdTb[id][x])
            sourceItem.childToogle[childId].childToogle.IsSetAsLast = false
            sourceItem.childToogle[childId].parentTrans = sourceItem.childItem.parent
            sourceItem.childToogle[childId].childToogle.onValueChanged:AddListener(function(index)
                DataMgr:GetData("TeamData").ClearTeamList()
                m_item = {}
                if index then
                    self.teamSetting.target = childId
                    MgrMgr:GetMgr("TeamMgr").GetTeamList(childId)
                end

                self:_setBecomeLeaderTogState(childId)
            end)
        end
    end
end

function TeamSearchCtrl:ShowChildItemById(id, show)
    m_item = {}
    --父节点的子节点数量等于0 那么请求列表
    if table.ro_size(self.parentIdTb[id]) == 0 then
        if show then
            MgrMgr:GetMgr("TeamMgr").GetTeamList(id)
        end
    end

    if show then
        if self.isFirstSetNum == 1 then
            self.isFirstSetNum = self.isFirstSetNum + 1
        else
            self.teamSetting.target = id
        end
    end

    for i = 1, table.ro_size(self.itemTb) do
        if self.itemTb[i].id == id then
            for x = 1, table.ro_size(self.parentIdTb[id]) do
                local childId = self.parentIdTb[id][x]
                self.itemTb[i].childToogle[childId].ui.gameObject:SetActiveEx(show)
                if show then
                    --如果组队设置是父节点 那么取值第一个 如果有设置自动匹配 则默认选中相应页签
                    local target = self.teamSetting.target % 1000 == 0 and self.parentIdTb[id][1] or self.teamSetting.target
                    if childId == target then
                        self.itemTb[i].childToogle[childId].childToogle.isOn = false
                        self.itemTb[i].childToogle[childId].childToogle.isOn = true
                    else
                        self.itemTb[i].childToogle[childId].childToogle.isOn = false
                    end
                end
            end
        end
    end

    self:SetBtnGray(id)
    local rtTrans = self.panel.Content.transform:GetComponent("RectTransform")
    LayoutRebuilder.ForceRebuildLayoutImmediate(rtTrans)
end

function TeamSearchCtrl:GetData()
    self.parentIdTb = {} --
    self.parentSortTb = {}
    local l_targetData = TableUtil.GetTeamTargetTable().GetTable()
    local l_playerLv = MPlayerInfo.Lv
    if l_targetData then
        for key, v in pairs(l_targetData) do
            local lvLimit = v.LevelLimit
            if l_playerLv >= lvLimit[0] and l_playerLv <= lvLimit[1] then
                if v.ID % 1000 == 0 then
                    --附近的人 特殊判断Id==1000
                    self.parentIdTb[v.ID] = {}
                    table.insert(self.parentSortTb, v.ID)
                else
                    if v.BelongType ~= 0 then
                        if self.parentIdTb[v.BelongType] then
                            table.insert(self.parentIdTb[v.BelongType], v.ID)
                        else
                            self.parentIdTb[v.BelongType] = {}
                            table.insert(self.parentIdTb[v.BelongType], v.ID)
                        end
                    end
                end
            end
        end
    end
    --排序后的父节点
    self.parentSortTable = {}
    for key, value in pairs(self.parentIdTb) do
        table.insert(self.parentSortTable, key)
    end
    table.sort(self.parentSortTable, function(a, b)
        local l_data_a = TableUtil.GetTeamTargetTable().GetRowByID(a)
        local l_data_b = TableUtil.GetTeamTargetTable().GetRowByID(b)
        return l_data_a and l_data_b and l_data_a.Sort < l_data_b.Sort
    end)
end

function TeamSearchCtrl:ExportElement(element)
    element.parentToogle = element.ui.transform:Find("ParentItem/TogL"):GetComponent("MLuaUICom").TogEx
    element.parentItem = element.ui.transform:Find("ParentItem/TogL")
    element.childItem = element.ui.transform:Find("ChildItem/TogS")
    element.parentItemTxtOn = MLuaClientHelper.GetOrCreateMLuaUICom(element.ui.transform:Find("ParentItem/TogL/ON/Text"))
    element.parentItemTxtOff = MLuaClientHelper.GetOrCreateMLuaUICom(element.ui.transform:Find("ParentItem/TogL/Off/Text"))
    element.arrowOn = element.ui.transform:Find("ParentItem/TogL/ON/Img02")
    element.arrowOff = element.ui.transform:Find("ParentItem/TogL/Off/Img02")
end

function TeamSearchCtrl:ExportChild(element)
    element.childToogle = element.ui.transform:GetComponent("MLuaUICom").TogEx
    element.childItemTxtOn = MLuaClientHelper.GetOrCreateMLuaUICom(element.ui.transform:Find("ON/Text"))
    element.childItemTxtOff = MLuaClientHelper.GetOrCreateMLuaUICom(element.ui.transform:Find("Off/Text"))
end

--预设置队伍目标（打开时就展示的类型）
--teamTarget 队伍目标
function TeamSearchCtrl:SetTeamTargetPre(teamTarget, teamTargetID)
    local l_targetItem = nil
    for k, v in pairs(self.itemTb) do
        if v.id == teamTarget then
            l_targetItem = v
            break
        end
    end
    --父选项
    if l_targetItem then
        l_targetItem.parentToogle.isOn = false
        l_targetItem.parentToogle.isOn = true
        --子选项
        if teamTargetID ~= nil and l_targetItem.childToogle[teamTargetID] then
            l_targetItem.childToogle[teamTargetID].childToogle.isOn = false
            l_targetItem.childToogle[teamTargetID].childToogle.isOn = true
        end
    end
end

function TeamSearchCtrl:SetTeamTargetId(teamTargetId)
    local l_teamRow = TableUtil.GetTeamTargetTable().GetRowByID(teamTargetId)
    if l_teamRow then
        if l_teamRow.BelongType == 0 then
            self:SetTeamTargetPre(teamTargetId)
        else
            self:SetTeamTargetPre(l_teamRow.BelongType, teamTargetId)
        end
    end
end

return TeamSearchCtrl
--lua custom scripts end
