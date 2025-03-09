--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseHandler"
require "UI/Panel/QuickTeamPanelPanel"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua fields
local super = UI.UIBaseHandler
--next--
--lua fields end

--lua class define
QuickTeamPanelHandler = class("QuickTeamPanelHandler", super)
--lua class define end

--lua functions
function QuickTeamPanelHandler:ctor()

    super.ctor(self, HandlerNames.QuickTeamPanel, 0)

end --func end
--next--
function QuickTeamPanelHandler:Init()

    self.panel = UI.QuickTeamPanelPanel.Bind(self)
    super.Init(self)
    --init team
    self.panel.TeamCreate:AddClick(function()
        MgrMgr:GetMgr("TeamMgr").RequestCreateTeam()
    end)
    self.panel.TeamSearch:AddClick(function()
        UIMgr:ActiveUI(UI.CtrlNames.TeamSearch)
    end)

    self.teamMiniUI = {}
    self.mercenaryMiniUI = {}
    for i = 1, 5 do
        self.teamMiniUI[i] = {}
        self.teamMiniUI[i].ui = self:CloneObj(self.panel.TeamMemberTpl.gameObject)
        self.teamMiniUI[i].ui.transform:SetParent(self.panel.TeamMemberTpl.transform.parent)
        self.teamMiniUI[i].ui.transform:SetLocalScaleOne()
        self:ExportTeamElement(self.teamMiniUI[i])
    end
    for i = 1, 2 do
        self.mercenaryMiniUI[i] = {}
        self.mercenaryMiniUI[i].ui = self:CloneObj(self.panel.TeamMemberTpl.gameObject)
        self.mercenaryMiniUI[i].ui.transform:SetParent(self.panel.NotInTeamPanel.gameObject.transform)
        self.mercenaryMiniUI[i].ui.transform:SetLocalScaleOne()
        self:ExportTeamElement(self.mercenaryMiniUI[i])
    end
    for i = 2, 1, -1 do
        self.mercenaryMiniUI[i].ui.transform:SetAsFirstSibling()
    end
    self.panel.TeamMemberTpl.gameObject:SetActiveEx(false)
    self.panel.TeamAddTpl.transform:SetAsLastSibling()
    --self.panel.Teamaggregate.transform:SetAsLastSibling()

    self.panel.BtnChangePanel.gameObject:SetActiveEx(false)
    self.panel.BtnChangePanel:AddClick(function()
        self.panel.InTeamPanel.gameObject:SetActiveEx(not self.panel.InTeamPanel.gameObject.activeSelf)
        self.panel.NotInTeamPanel.gameObject:SetActiveEx(not self.panel.NotInTeamPanel.gameObject.activeSelf)
        self.panel.ChangePanelOne.gameObject:SetActiveEx(self.panel.InTeamPanel.gameObject.activeSelf)
        self.panel.ChangePanelTeam.gameObject:SetActiveEx(self.panel.NotInTeamPanel.gameObject.activeSelf)
    end)

    -- 佣兵协同
    self.panel.TeamCoordination:AddClick(function()
        MgrMgr:GetMgr("MercenaryMgr").ChangeMercenaryFightStatus(2)
    end)
    -- 佣兵被动
    self.panel.TeamPassive:AddClick(function()
        MgrMgr:GetMgr("MercenaryMgr").ChangeMercenaryFightStatus(1)
    end)
end --func end
--next--
function QuickTeamPanelHandler:Uninit()
    self:OnCloneObjUninit()
    self:OnBuffUninit()
    super.Uninit(self)
    self.panel = nil

end --func end
--next--
function QuickTeamPanelHandler:OnActive()
    --self:RefreshTeamPanel()
    --self:RefreshMyMercenaryInfo()
    --self:ShowChangePanelBtn()
end --func end
--next--
function QuickTeamPanelHandler:OnDeActive()


end --func end
--next--
function QuickTeamPanelHandler:Update()
    self:UpdateTempTeam()
    self:UpdateReviveTime()
    --self:UpdateBuff()
end --func end
--next--
function QuickTeamPanelHandler:Refresh()


end --func end
--next--
function QuickTeamPanelHandler:OnLogout()


end --func end
--next--
function QuickTeamPanelHandler:OnShow()
    self:RefreshTeamPanel()
    self:RefreshMyMercenaryInfo()
    self:ShowChangePanelBtn()
    super.OnShow(self)
end --func end
--next--
function QuickTeamPanelHandler:OnHide()
    super.OnHide(self)
end --func end
--next--
function QuickTeamPanelHandler:BindEvents()

    local TeamInfoUpdate = function()
        self:RefreshTeamPanel()
    end
    local MercenaryInfoUpdate = function()
        self:RefreshMyMercenaryInfo()
    end
    --MgrMgr:GetMgr("BuffMgr").EventDispatcher:Add(MgrMgr:GetMgr("BuffMgr").TEAM_BUFF_INFO_UPDATE, function(a, l_roIDList)
    --    self:RefreshBuffPanel(l_roIDList)
    --end, self)
    local PlayerInSoloDungeons = function()
        self:ShowChangePanelBtn()
    end
    local TeamMercenaryInfoUpdate = function()
        self:RefreshTeamMercenaryInfo()
    end
    self:BindEvent(MgrMgr:GetMgr("TeamMgr").EventDispatcher, DataMgr:GetData("TeamData").ON_REFRESH_TEAM_TARGET, self.SetTeamTargetState)
    self:BindEvent(MgrMgr:GetMgr("TeamMgr").EventDispatcher, DataMgr:GetData("TeamData").ON_TEAM_INFO_UPDATE, self.RefreshTeamPanel)
    self:BindEvent(MgrMgr:GetMgr("TeamMgr").EventDispatcher, DataMgr:GetData("TeamData").ON_TEAM_BASIC_INFO_UPDATE, TeamInfoUpdate)
    self:BindEvent(MgrMgr:GetMgr("TeamMgr").EventDispatcher, DataMgr:GetData("TeamData").ON_TEAM_FOLLOW_STATE_CHANGE, TeamInfoUpdate)
    self:BindEvent(MgrMgr:GetMgr("TeamMgr").EventDispatcher, DataMgr:GetData("TeamData").ON_MERCENARY_RIVIVE_UPDATE, TeamMercenaryInfoUpdate)
    self:BindEvent(MgrMgr:GetMgr("TeamMgr").EventDispatcher, DataMgr:GetData("TeamData").ON_SOLODUNGEONS_UPDATE, PlayerInSoloDungeons)
    self:BindEvent(MgrMgr:GetMgr("DungeonMgr").EventDispatcher, MgrMgr:GetMgr("DungeonMgr").CONFIRM_THREE_TO_THREE, TeamInfoUpdate)
    self:BindEvent(MgrMgr:GetMgr("DungeonMgr").EventDispatcher, MgrMgr:GetMgr("DungeonMgr").CANCLE_THREE_TO_THREE, TeamInfoUpdate)
    self:BindEvent(MgrMgr:GetMgr("MercenaryMgr").EventDispatcher, MgrMgr:GetMgr("MercenaryMgr").ON_MERCENARY_DEATH, MercenaryInfoUpdate)
    self:BindEvent(MgrMgr:GetMgr("MercenaryMgr").EventDispatcher, MgrMgr:GetMgr("MercenaryMgr").ON_MERCENARY_FIGHT, MercenaryInfoUpdate)
    self:BindEvent(MgrMgr:GetMgr("MercenaryMgr").EventDispatcher, MgrMgr:GetMgr("MercenaryMgr").ON_MERCENARY_STATUS_CHANGE, MercenaryInfoUpdate)
    self:BindEvent(MgrMgr:GetMgr("MercenaryMgr").EventDispatcher, MgrMgr:GetMgr("MercenaryMgr").ON_MERCENARY_FIGHT_UPDATE, self.RefreshTeamPanel)
    self:BindEvent(MgrMgr:GetMgr("WatchWarMgr").EventDispatcher, MgrMgr:GetMgr("WatchWarMgr").ON_TEAM_WATCH_STATUS_CHANGE, self.RefreshTeamPanel)

    --dont override this function
    local l_mgr = MgrMgr:GetMgr("BuffMgr")

    --self:BindEvent(l_mgr.EventDispatcher, l_mgr.TEAM_BUFF_INFO_UPDATE, function(a, l_roIDList)
    --    self:RefreshBuffPanel(l_roIDList)
    --end)

end --func end

--next--
--lua functions end

--lua custom scripts

function QuickTeamPanelHandler:RefreshBuffPanel(roIDList)
    if self.panel == nil or nil == self.TeamData then
        return
    end
    self.startTime = nil
    local data = self.TeamData
    local myUid = self.UID
    if data.isInTeam then
        local teamMemberNum = table.maxn(data.memberList)
        local l_allBuffInfo = MgrMgr:GetMgr("BuffMgr").TeamBuffInfo
        self.curBuff = {}
        if not self.preBuff then
            self.preBuff = {}
        end
        for i = 1, teamMemberNum do
            local l_roleID = tostring(data.memberList[i].roleId)
            if l_roleID ~= myUid and table.ro_contains(roIDList, l_roleID) then
                local l_teamBuff = self.teamMiniUI[i].buff
                local l_buffList = self.teamMiniUI[i].buffList
                if #l_buffList > 0 then
                    for index_x = 1, #l_buffList do
                        l_buffList[index_x].go:SetActiveEx(false)
                    end
                end
                if not self.timeLab then
                    self.timeLab = {}
                end
                if not self.curBuff[l_roleID] then
                    self.curBuff[l_roleID] = {}
                end
                local l_targetBuffInfo = l_allBuffInfo[l_roleID]
                if l_targetBuffInfo then
                    self.typeInfo = {}
                    local BuffIndex = 1
                    if #l_targetBuffInfo > 0 then
                        self.timeLab[l_roleID] = {}
                        for index_buffInfo = 1, #l_targetBuffInfo do
                            if BuffIndex > 3 then
                                break
                            end
                            local l_info = l_targetBuffInfo[index_buffInfo]
                            if not table.ro_contains(self.typeInfo, l_info.name) then
                                if not l_buffList[BuffIndex] then
                                    l_buffList[BuffIndex] = self:CreateBuff(l_teamBuff.tp, l_teamBuff.list)
                                end
                                local l_targetBuff = l_buffList[BuffIndex]
                                local l_id = l_info.tableInfo.Id
                                l_targetBuff.icon:SetSprite(l_info.tableInfo.IconAtlas, l_info.tableInfo.Icon)
                                local l_remain = math.floor(l_info.remain + 0.5)
                                if l_remain > 0 then
                                    l_targetBuff.go:SetActiveEx(true)
                                end
                                local l_all = l_info.alltime
                                l_targetBuff.timeLab.LabText = tostring(l_remain)
                                l_targetBuff.bg.fillAmount = 1 - l_remain / l_all

                                self.timeLab[l_roleID][BuffIndex] = {}
                                self.timeLab[l_roleID][BuffIndex].go = l_targetBuff.go
                                self.timeLab[l_roleID][BuffIndex].Lab = l_targetBuff.timeLab
                                self.timeLab[l_roleID][BuffIndex].Bg = l_targetBuff.bg
                                self.timeLab[l_roleID][BuffIndex].remain = l_remain
                                self.timeLab[l_roleID][BuffIndex].all = l_all

                                if l_targetBuff.fx ~= nil then
                                    self:DestroyUIEffect(l_targetBuff.fx)
                                    l_targetBuff.fx = nil
                                end

                                if not self.preBuff or not self.preBuff[l_roleID] or not table.ro_contains(self.preBuff[l_roleID], l_id) then
                                    local l_anim = l_targetBuff.go:GetComponent("DOTweenAnimation")
                                    if l_anim then
                                        l_anim:DORestart()
                                        l_anim:DOPlayForward()
                                    end
                                    local l_fxData = {}
                                    l_fxData.rawImage = l_targetBuff.effectImg.RawImg
                                    l_targetBuff.fx = self:CreateUIEffect(MgrMgr:GetMgr("BuffMgr").ReduceStatrEffect, l_fxData)

                                end
                                table.insert(self.curBuff[l_roleID], l_id)
                                table.insert(self.typeInfo, l_info.name)
                                BuffIndex = BuffIndex + 1
                            end
                        end
                    end
                end
            end
        end
        for k, v in pairs(self.curBuff) do
            self.preBuff[k] = {}
            for kk, vv in pairs(v) do
                self.preBuff[k][kk] = vv
            end
        end

        self.curBuff = {}
        self.startTime = Time.realtimeSinceStartup
    end
end

function QuickTeamPanelHandler:GetMercenaryAwayStatus(data)
    if not data then
        return ""
    end
    if tostring(MPlayerInfo.UID) ~= tostring(data.roleId) then
        if data.sceneId ~= MScene.SceneID then
            return MemberStatus.MEMBER_AWAYFROM
        else
            if DataMgr:GetData("TeamData").GetSelfLineNumber() ~= data.roleLineId then
                return MemberStatus.MEMBER_AWAYFROM
            end
            local dungeonID = MPlayerInfo.PlayerDungeonsInfo.DungeonID
            if dungeonID == 0 then
                return ""
            end
            local l_row = TableUtil.GetDungeonsTable().GetRowByDungeonsID(dungeonID)
            local l_numlimit = Common.Functions.SequenceToTable(l_row.NumbersLimit)
            if l_numlimit[1] == 1 and l_numlimit[2] == 1 then
                return MemberStatus.MEMBER_AWAYFROM
            end
        end
    end
    return ""
end

function QuickTeamPanelHandler:CreateBuff(tp, parent)
    local l_tp = tp
    local l_go = self:CloneObj(l_tp)
    l_go.transform:SetParent(parent.gameObject.transform)
    l_go:SetLocalScaleToOther(l_tp)
    l_go:SetActiveEx(false)
    local l_buff = {}
    l_buff.go = l_go
    l_buff.icon = l_go.transform:Find("icon"):GetComponent("MLuaUICom")
    l_buff.bg = l_go.transform:Find("Image"):GetComponent("Image")
    l_buff.timeLab = l_go.transform:Find("timeLab"):GetComponent("MLuaUICom")
    l_buff.effectImg = l_go.transform:Find("Effect"):GetComponent("MLuaUICom")
    l_buff.fx = nil
    return l_buff
end

function QuickTeamPanelHandler:GetMemberStatusByNum(data)
    if data == nil then
        return ""
    end
    if data.state == MemberStatus.MEMBER_OFFLINE then
        return MemberStatus.MEMBER_OFFLINE
    end
    if MgrMgr:GetMgr("BattleMgr").CanInBattlePre(data.sceneId) then
        return MemberStatus.MEMBER_WAITING
    end
    if data.state == MemberStatus.MEMBER_AFK then
        return MemberStatus.MEMBER_AFK
    end
    --不是玩家自己判断远离状态 同场景 不同线 远离
    if tostring(MPlayerInfo.UID) ~= tostring(data.roleId) then
        if data.state == MemberStatus.MEMBER_NORMAL then
            if MgrMgr:GetMgr("WatchWarMgr").HasMemberWatchRecord(data.roleId) then
                return MemberStatus.MEMBER_AWAYFROM
            end
            if data.sceneId ~= MScene.SceneID then
                return MemberStatus.MEMBER_AWAYFROM
            else
                if DataMgr:GetData("TeamData").GetSelfLineNumber() ~= data.roleLineId then
                    return MemberStatus.MEMBER_AWAYFROM
                end
                local dungeonID = MPlayerInfo.PlayerDungeonsInfo.DungeonID
                if dungeonID == 0 then
                    return ""
                end
                local l_row = TableUtil.GetDungeonsTable().GetRowByDungeonsID(dungeonID)
                local l_numlimit = Common.Functions.SequenceToTable(l_row.NumbersLimit)
                if l_numlimit[1] == 1 and l_numlimit[2] == 1 then
                    return MemberStatus.MEMBER_AWAYFROM
                end
            end
        end
    end
    return ""
end

function QuickTeamPanelHandler:OnCloneObjUninit()
    for i = 1, table.maxn(self.teamMiniUI) do
        MResLoader:DestroyObj(self.teamMiniUI[i].ui)
    end
    for i = 1, table.maxn(self.mercenaryMiniUI) do
        MResLoader:DestroyObj(self.mercenaryMiniUI[i].ui)
    end
end

function QuickTeamPanelHandler:OnBuffUninit()
    if self.teamMiniUI and table.ro_size(self.teamMiniUI) > 0 then
        for k, v in pairs(self.teamMiniUI) do
            local l_buffCount = #v.buffList
            if l_buffCount > 0 then
                for i = 1, l_buffCount do
                    local l_targetBuff = v.buffList[i]
                    if l_targetBuff.fx ~= nil then
                        self:DestroyUIEffect(l_targetBuff.fx)
                        l_targetBuff.fx = nil
                    end
                end
            end
        end
    end
end

function QuickTeamPanelHandler:UpdateReviveTime()
    local l_curTime = Common.TimeMgr.GetNowTimestamp()
    for i = 1, 5 do
        if self.teamMiniUI[i].isDeath then
            if tonumber(self.teamMiniUI[i].revivetimeNum) ~= 0 then
                self.teamMiniUI[i].revive.gameObject:SetActiveEx(true)
                if tonumber(self.teamMiniUI[i].revivetimeNum) <= l_curTime then
                    self.teamMiniUI[i].reviveText.LabText = 0 .. Common.Utils.Lang("Resurrection_Time_Text")
                else
                    self.teamMiniUI[i].reviveText.LabText = tostring(math.ceil(self.teamMiniUI[i].revivetimeNum - l_curTime)) .. Common.Utils.Lang("Resurrection_Time_Text")
                end
                if self.teamMiniUI[i].sliderHp.value > 0 then
                    self.teamMiniUI[i].isDeath = false
                    self.teamMiniUI[i].revive.gameObject:SetActiveEx(false)
                    self.teamMiniUI[i].revivetimeNum = 0
                    DataMgr:GetData("TeamData").ResetMercenaryRevive(self.teamMiniUI[i].roleID)
                end
            else
                self.teamMiniUI[i].revive.gameObject:SetActiveEx(false)
            end
        else
            self.teamMiniUI[i].revive.gameObject:SetActiveEx(false)
        end
    end
    for i = 1, 2 do
        if self.mercenaryMiniUI[i].isDeath then
            if tonumber(self.mercenaryMiniUI[i].revivetimeNum) <= l_curTime then
                self.mercenaryMiniUI[i].reviveText.LabText = 0 .. Common.Utils.Lang("Resurrection_Time_Text")
            else
                self.mercenaryMiniUI[i].reviveText.LabText = tostring(math.ceil(self.mercenaryMiniUI[i].revivetimeNum - l_curTime)) .. Common.Utils.Lang("Resurrection_Time_Text")
            end
            if self.mercenaryMiniUI[i].sliderHp.value > 0 then
                self.mercenaryMiniUI[i].revive.gameObject:SetActiveEx(false)
                self.mercenaryMiniUI[i].isDeath = false
            end
        else
            self.mercenaryMiniUI[i].revive.gameObject:SetActiveEx(false)
        end
    end
end

local UPDTAE_TEMP_TEAM_DURATION = 30
function QuickTeamPanelHandler:UpdateTempTeam()
    if not MgrMgr:GetMgr("DungeonMgr").IsTempTeamMode then
        return
    end
    if not self.UpdateTempTeamNum then
        self.UpdateTempTeamNum = 0
    end
    self.UpdateTempTeamNum = self.UpdateTempTeamNum + 1
    if self.UpdateTempTeamNum <= UPDTAE_TEMP_TEAM_DURATION then
        return
    end
    self.UpdateTempTeamNum = nil
    self:SetTempTeamPanel()
end

function QuickTeamPanelHandler:RefreshTeamPanel()
    if self.panel == nil then
        return
    end
    if MgrMgr:GetMgr("DungeonMgr").IsTempTeamMode then
        self:SetTempTeamPanel()
        return
    end

    local myIsCaptain = tostring(DataMgr:GetData("TeamData").myTeamInfo.captainId) == MPlayerInfo.UID:tostring()
    self.panel.TeamAddTpl:AddClick(function()
        MgrMgr:GetMgr("TeamMgr").GetInvitationIdListByType()
    end)


    --暂时从组队拿数据来刷，回头整个代码提出去
    local data = DataMgr:GetData("TeamData").myTeamInfo
    local myUid = MPlayerInfo.UID:tostring()
    if not self.panel.BtnChangePanel.gameObject.activeSelf then
        self.panel.NotInTeamPanel.gameObject:SetActiveEx(not data.isInTeam)
        self.panel.InTeamPanel.gameObject:SetActiveEx(data.isInTeam)
    end

    if myIsCaptain then
        if DataMgr:GetData("TeamData").Isfollowing then
            self:SetToEndFollowBtn()
        else
            self:SetOneKeyFollow()
        end
    else
        if DataMgr:GetData("TeamData").Isfollowing then
            self:SetToEndFollowBtn()
        else
            self:SetToFollowBtn()
        end
    end

    if table.maxn(data.memberList) < 5 then
        self.panel.TeamSearch.gameObject:SetActiveEx(true)
    else
        self.panel.TeamSearch.gameObject:SetActiveEx(false)
    end
    --队伍人数为1 不显示一键召集
    if table.maxn(data.memberList) <= 1 then
        self.panel.Teamaggregate.gameObject:SetActiveEx(false)
    else
        self.panel.Teamaggregate.gameObject:SetActiveEx(true)
    end

    -- 佣兵协同逻辑处理
    local l_hasMecenaryInFight = (data.isInTeam and DataMgr:GetData("TeamData").GetCurMercenaryNum() > 0)
            or (not data.isInTeam and MgrMgr:GetMgr("MercenaryMgr").FindFightMercenaryCount() > 0)
    local l_mercenaryFightStatus = MgrMgr:GetMgr("MercenaryMgr").mMercenaryFightStatus
    -- 佣兵协同
    self.panel.TeamCoordination:SetActiveEx(l_hasMecenaryInFight and l_mercenaryFightStatus == 1)
    -- 佣兵被动
    self.panel.TeamPassive:SetActiveEx(l_hasMecenaryInFight and l_mercenaryFightStatus == 2)
    -- 副本内隐藏
    self.panel.TeamMercenary:SetActiveEx(l_hasMecenaryInFight and not MPlayerDungeonsInfo.InDungeon)

    if data.isInTeam then
        local l_captainIndex = 0;
        self.panel.TeamCreate.gameObject:SetActiveEx(false)
        self.panel.TeamSearch.gameObject:SetActiveEx(false)
        local l_roIDList = {}
        local teamMemberNum = table.maxn(data.memberList)
        for i = 1, teamMemberNum do
            local l_roleID = tostring(data.memberList[i].roleId)
            if tostring(data.memberList[i].roleId) == tostring(data.captainId) then
                l_captainIndex = i
            end
            if l_roleID ~= myUid then
                table.insert(l_roIDList, l_roleID)
                self.teamMiniUI[i].roleID = l_roleID
                self.teamMiniUI[i].UId = l_roleID
                self.teamMiniUI[i].btnMore.gameObject:SetActiveEx(true)
                self.teamMiniUI[i].btnMore:AddClick(function()
                    if myUid ~= data.memberList[i].roleId then
                        MgrMgr:GetMgr("TeamMgr").ShowTeamFuncView(tostring(data.memberList[i].roleId), Vector2.New(278, -265), nil, Vector2.New(0, 1), Vector2.New(0, 1))
                    end
                end)

                self.teamMiniUI[i].uiCom:AddClick(function()
                    self:CloseAllMarkUI()
                    self.teamMiniUI[i].mark.gameObject:SetActiveEx(true)
                    if myUid ~= data.memberList[i].roleId then
                        MgrMgr:GetMgr("PlayerInfoMgr").SetMainTarget(data.memberList[i].roleId, data.memberList[i].roleName, data.memberList[i].roleLevel, true, false, false, false, false)
                        local entity = MEntityMgr:GetEntity(data.memberList[i].roleId)
                        if entity then
                            MEntityMgr.PlayerEntity.Target = entity
                        end
                    end
                end)

                self.teamMiniUI[i].ui.gameObject:SetActiveEx(true)
                self.teamMiniUI[i].name.LabText = data.memberList[i].roleName
                self.teamMiniUI[i].level.LabText = "Lv " .. data.memberList[i].roleLevel
                self.teamMiniUI[i].objOffLine.gameObject:SetActiveEx(self:GetMemberStatusByNum(data.memberList[i]) == MemberStatus.MEMBER_OFFLINE)
                self.teamMiniUI[i].objOnceOffLine.gameObject:SetActiveEx(self:GetMemberStatusByNum(data.memberList[i]) == MemberStatus.MEMBER_AFK)
                self.teamMiniUI[i].objawayfrom.gameObject:SetActiveEx(self:GetMemberStatusByNum(data.memberList[i]) == MemberStatus.MEMBER_AWAYFROM)
                self.teamMiniUI[i].objWaiting.gameObject:SetActiveEx(self:GetMemberStatusByNum(data.memberList[i]) == MemberStatus.MEMBER_WAITING)
                local imageName = DataMgr:GetData("TeamData").GetProfessionImageById(data.memberList[i].roleType)
                if imageName then
                    self.teamMiniUI[i].professionImage:SetSpriteAsync("Common", imageName)
                end
                if data.memberList[i].cur_hp and data.memberList[i].total_hp then
                    local curHp = data.memberList[i].cur_hp
                    local totalHp = math.max(data.memberList[i].total_hp, 1)
                    self.teamMiniUI[i].sliderHp.value = curHp / totalHp
                    --此处有Bug 服务器在玩家死后没有清零玩家血量
                end
                if data.memberList[i].cur_sp and data.memberList[i].total_sp then
                    local curSp = data.memberList[i].cur_sp
                    local totalSp = math.max(data.memberList[i].total_sp, 1)
                    self.teamMiniUI[i].sliderMp.value = curSp / totalSp
                end
                self.teamMiniUI[i].captainImage.gameObject:SetActiveEx(data.memberList[i].roleId == data.captainId)
                self.teamMiniUI[i].followImage.gameObject:SetActiveEx(MPlayerInfo.FollowerUid:tostring() == tostring(data.memberList[i].roleId))
                self.teamMiniUI[i].mercenaryImage.gameObject:SetActiveEx(false)
                self.teamMiniUI[i].revive.gameObject:SetActiveEx(false)
            else
                self.teamMiniUI[i].ui.gameObject:SetActiveEx(false)
            end
        end
        local l_mercenaryNum = 0
        if data.mercenaryList then
            l_mercenaryNum = table.maxn(data.mercenaryList)
            self:RefreshTeamMercenaryInfo()
        end
        teamMemberNum = teamMemberNum + l_mercenaryNum
        for i = teamMemberNum + 1, DataMgr:GetData("TeamData").maxTeamNumber do
            self.teamMiniUI[i].ui.gameObject:SetActiveEx(false)
            --local l_buffCount = #self.teamMiniUI[i].buffList
            --if l_buffCount > 0 then
            --    for index_buff = 1, l_buffCount do
            --        local l_targetBuff = self.teamMiniUI[i].buffList[index_buff]
            --        l_targetBuff.go:SetActiveEx(false)
            --        if l_targetBuff.fx ~= nil then
            --            self:DestroyUIEffect(l_targetBuff.fx)
            --            l_targetBuff.fx = nil
            --        end
            --    end
            --end
        end
        local l_indexNum = table.maxn(data.memberList)
        self.panel.TeamAddTpl.gameObject:SetActiveEx(l_indexNum ~= DataMgr:GetData("TeamData").maxTeamNumber)
        self.startTime = nil
        self.TeamData = DataMgr:GetData("TeamData").myTeamInfo
        self.UID = MPlayerInfo.UID:tostring()
        --self:RefreshBuffPanel(l_roIDList)
    else
        self.startTime = nil
        self.panel.BtnChangePanel.gameObject:SetActiveEx(false)
        self.panel.TeamCreate.gameObject:SetActiveEx(true)
        self.panel.TeamSearch.gameObject:SetActiveEx(true)
        self.panel.NotInTeamPanel.gameObject:SetActiveEx(true)
        self.panel.InTeamPanel.gameObject:SetActiveEx(false)
    end

end

function QuickTeamPanelHandler:RefreshTeamMercenaryInfo()
    local data = DataMgr:GetData("TeamData").myTeamInfo
    local l_indexNum = table.maxn(data.memberList)
    if data.mercenaryList then
        for i = 1, table.maxn(data.mercenaryList) do
            if i + l_indexNum > DataMgr:GetData("TeamData").maxTeamNumber then
                return -- 临时处理，疑似masterServer崩溃引起发过来大于5条的成员数据
            end
            local mercenary_id = data.mercenaryList[i].Id
            self.teamMiniUI[i + l_indexNum].roleID = mercenary_id
            self.teamMiniUI[i + l_indexNum].UId = data.mercenaryList[i].UId
            self.teamMiniUI[i + l_indexNum].ownerId = data.mercenaryList[i].ownerId
            self.teamMiniUI[i + l_indexNum].ui.gameObject:SetActiveEx(true)
            local l_mercenaryRow = TableUtil.GetMercenaryTable().GetRowById(mercenary_id)
            self.teamMiniUI[i + l_indexNum].name.LabText = l_mercenaryRow.Name
            self.teamMiniUI[i + l_indexNum].level.LabText = "Lv " .. data.mercenaryList[i].lvl
            self.teamMiniUI[i + l_indexNum].objOffLine.gameObject:SetActiveEx(false)
            self.teamMiniUI[i + l_indexNum].objOnceOffLine.gameObject:SetActiveEx(false)
            if l_captainIndex ~= 0 then
                self.teamMiniUI[i + l_indexNum].objawayfrom.gameObject:SetActiveEx(self:GetMercenaryAwayStatus(data.memberList[l_captainIndex]) == MemberStatus.MEMBER_AWAYFROM) --远离暂定根据拥有者位置判定
            end
            if data.mercenaryList[i].ownerId == MPlayerInfo.UID then
                self.teamMiniUI[i + l_indexNum].objawayfrom.gameObject:SetActiveEx(false)
            end
            self.teamMiniUI[i + l_indexNum].objWaiting.gameObject:SetActiveEx(false)
            local imageName = DataMgr:GetData("TeamData").GetProfessionImageById(l_mercenaryRow.Profession)
            if imageName then
                self.teamMiniUI[i + l_indexNum].professionImage:SetSpriteAsync("Common", imageName)
            end
            self.teamMiniUI[i + l_indexNum].sliderHp.value = data.mercenaryList[i].hp / 100
            self.teamMiniUI[i + l_indexNum].sliderMp.value = data.mercenaryList[i].sp / 100
            if tostring(data.mercenaryList[i].ownerId) == tostring(MPlayerInfo.UID) then
                MgrMgr:GetMgr("MercenaryMgr").SetHpSPInfoByTeamInfo(data.mercenaryList[i].Id, data.mercenaryList[i].hp / 100, data.mercenaryList[i].sp / 100)
            end

            self.teamMiniUI[i + l_indexNum].captainImage.gameObject:SetActiveEx(false)
            self.teamMiniUI[i + l_indexNum].followImage.gameObject:SetActiveEx(false)
            self.teamMiniUI[i + l_indexNum].mercenaryImage.gameObject:SetActiveEx(true)
            self.teamMiniUI[i + l_indexNum].isDeath = data.mercenaryList[i].isDeath
            self.teamMiniUI[i + l_indexNum].revive.gameObject:SetActiveEx(data.mercenaryList[i].isDeath)
            if data.mercenaryList[i].isDeath then
                self.teamMiniUI[i + l_indexNum].revivetimeNum = data.mercenaryList[i].reviveTime
            else
                self.teamMiniUI[i + l_indexNum].revivetimeNum = 0
            end
            self.teamMiniUI[i + l_indexNum].btnMore.gameObject:SetActiveEx(true)
            self.teamMiniUI[i + l_indexNum].btnMore:AddClick(function()
                local l_callBack = function()
                    if data.mercenaryList[i] and MPlayerInfo.UID:tostring() == data.mercenaryList[i].ownerId then
                        MgrMgr:GetMgr("MercenaryMgr").OpenMercenary(mercenary_id)
                    else
                        MgrMgr:GetMgr("MercenaryMgr").OpenMercenary()
                    end
                end
                local openData = {
                    openType = DataMgr:GetData("TeamData").ETeamOpenType.SetQuickPanelByNameAndFunc,
                    nameTb = { Common.Utils.Lang("MERCENARY_SET") },
                    callbackTb = { l_callBack },
                    dataopenPos = Vector2.New(320, -220 - (i + l_indexNum - 2) * 50),
                    dataAnchorMaxPos = Vector2.New(0, 1),
                    dataAnchorMinPos = Vector2.New(0, 1)
                }
                UIMgr:ActiveUI(UI.CtrlNames.TeamQuickFunc, openData)


                --UIMgr:ActiveUI(UI.CtrlNames.TeamQuickFunc, function()
                --    local l_ui = UIMgr:GetUI(UI.CtrlNames.TeamQuickFunc)
                --    local l_CallBack_MercenarySetting = function()
                --        if MPlayerInfo.UID:tostring() == data.mercenaryList[i].ownerId then
                --            MgrMgr:GetMgr("MercenaryMgr").OpenMercenary(mercenary_id)
                --        else
                --            MgrMgr:GetMgr("MercenaryMgr").OpenMercenary()
                --        end
                --    end
                --    local l_callBackTb = { l_CallBack_MercenarySetting }
                --    local l_nameTb = { Common.Utils.Lang("MERCENARY_SET") }
                --    if l_ui then
                --        l_ui:SetQuickPanelByNameAndFunc(l_nameTb, l_callBackTb, Vector2.New(320, -220 - (i + l_indexNum - 2) * 50), Vector2.New(0, 1), Vector2.New(0, 1))
                --    end
                --end)


            end)
            self.teamMiniUI[i + l_indexNum].uiCom:AddClick(function()
                self:CloseAllMarkUI()
                self.teamMiniUI[i + l_indexNum].mark.gameObject:SetActiveEx(true)
                if myUid ~= data.mercenaryList[i].UId then
                    MgrMgr:GetMgr("PlayerInfoMgr").SetMainTarget(data.mercenaryList[i].UId, l_mercenaryRow.Name, data.mercenaryList[i].lvl, false, false, false, false, true)
                    local entity = MEntityMgr:GetEntity(data.mercenaryList[i].UId)
                    if entity then
                        MEntityMgr.PlayerEntity.Target = entity
                    end
                end
            end)
        end
    end

end

function QuickTeamPanelHandler:RefreshMyMercenaryInfo()
    if TableUtil.GetSceneTable().GetRowByID(MScene.SceneID).MerceneryNotAllow ~= nil and TableUtil.GetSceneTable().GetRowByID(MScene.SceneID).MerceneryNotAllow == 1 then
        for i = 1, 2 do
            self.mercenaryMiniUI[i].ui.gameObject:SetActiveEx(false)
        end
        return
    end
    local l_fightMercenarys = MgrMgr:GetMgr("MercenaryMgr"):FindFightMercenary()
    if #l_fightMercenarys > 0 and #self.mercenaryMiniUI >= #l_fightMercenarys then
        for i = 1, table.maxn(l_fightMercenarys) do
            local l_tableinfo = l_fightMercenarys[i].tableInfo
            self.mercenaryMiniUI[i].roleID = l_tableinfo.Id
            self.mercenaryMiniUI[i].ui.gameObject:SetActiveEx(true)
            self.mercenaryMiniUI[i].name.LabText = l_tableinfo.Name
            self.mercenaryMiniUI[i].level.LabText = l_fightMercenarys[i].level
            self.mercenaryMiniUI[i].objOffLine.gameObject:SetActiveEx(false)
            self.mercenaryMiniUI[i].objOnceOffLine.gameObject:SetActiveEx(false)
            self.mercenaryMiniUI[i].objawayfrom.gameObject:SetActiveEx(false)
            self.mercenaryMiniUI[i].objWaiting.gameObject:SetActiveEx(false)
            local imageName = DataMgr:GetData("TeamData").GetProfessionImageById(l_tableinfo.Profession)
            if imageName then
                self.mercenaryMiniUI[i].professionImage:SetSpriteAsync("Common", imageName)
            end
            self.mercenaryMiniUI[i].sliderHp.value = l_fightMercenarys[i].curHp / l_fightMercenarys[i].maxHp
            self.mercenaryMiniUI[i].sliderMp.value = l_fightMercenarys[i].curSp / l_fightMercenarys[i].maxSp
            self.mercenaryMiniUI[i].captainImage.gameObject:SetActiveEx(false)
            self.mercenaryMiniUI[i].followImage.gameObject:SetActiveEx(false)
            self.mercenaryMiniUI[i].mercenaryImage.gameObject:SetActiveEx(true)
            self.mercenaryMiniUI[i].revive.gameObject:SetActiveEx(l_fightMercenarys[i].reviveTime ~= 0 and self.mercenaryMiniUI[i].sliderHp.value <= 0)
            self.mercenaryMiniUI[i].isDeath = l_fightMercenarys[i].reviveTime ~= 0 and self.mercenaryMiniUI[i].sliderHp.value <= 0
            self.mercenaryMiniUI[i].revivetimeNum = l_fightMercenarys[i].reviveTime
            self.mercenaryMiniUI[i].UId = l_fightMercenarys[i].UId

            self.mercenaryMiniUI[i].uiCom:AddClick(function()
                self:CloseAllMarkUI()
                self.mercenaryMiniUI[i].mark.gameObject:SetActiveEx(true)
                if myUid ~= l_fightMercenarys[i].UId then
                    MgrMgr:GetMgr("PlayerInfoMgr").SetMainTarget(l_fightMercenarys[i].UId, l_tableinfo.Name, l_fightMercenarys[i].level, false, false, false, false, true)
                    local entity = MEntityMgr:GetEntity(l_fightMercenarys[i].UId)
                    if entity then
                        MEntityMgr.PlayerEntity.Target = entity
                    end
                end
            end)
            self.mercenaryMiniUI[i].btnMore.gameObject:SetActiveEx(true)
            self.mercenaryMiniUI[i].btnMore:AddClick(function()
                local l_CallBack_MercenarySetting = function()
                    MgrMgr:GetMgr("MercenaryMgr").OpenMercenary(l_tableinfo.Id)
                    --MgrMgr:GetMgr("CapraFAQMgr").GetHttpRequest(1, DataMgr:GetData("TeamData").lll_str)
                    --UIMgr:ActiveUI(UI.CtrlNames.RoleNurturance)
                end

                local openData = {
                    openType = DataMgr:GetData("TeamData").ETeamOpenType.SetQuickPanelByNameAndFunc,
                    nameTb = { Common.Utils.Lang("MERCENARY_SET") },
                    callbackTb = { l_CallBack_MercenarySetting },
                    dataopenPos = Vector2.New(320, -210 - (i - 1) * 50),
                    dataAnchorMaxPos = Vector2.New(0, 1),
                    dataAnchorMinPos = Vector2.New(0, 1)
                }
                UIMgr:ActiveUI(UI.CtrlNames.TeamQuickFunc, openData)


                --UIMgr:ActiveUI(UI.CtrlNames.TeamQuickFunc, function()
                --    local l_ui = UIMgr:GetUI(UI.CtrlNames.TeamQuickFunc)
                --    local l_CallBack_MercenarySetting = function()
                --        MgrMgr:GetMgr("MercenaryMgr").OpenMercenary(l_tableinfo.Id)
                --    end
                --    local l_callBackTb = { l_CallBack_MercenarySetting }
                --    local l_nameTb = { Common.Utils.Lang("MERCENARY_SET") }
                --    if l_ui then
                --        l_ui:SetQuickPanelByNameAndFunc(l_nameTb, l_callBackTb, Vector2.New(320, -210 - (i - 1) * 50), Vector2.New(0, 1), Vector2.New(0, 1))
                --    end
                --end)


            end)

        end
    end
    for i = #l_fightMercenarys + 1, 2 do
        self.mercenaryMiniUI[i].ui.gameObject:SetActiveEx(false)
    end

end

function QuickTeamPanelHandler:ShowChangePanelBtn()
    ---@type ModuleData.TeamData
    local data = DataMgr:GetData("TeamData")
    if not data.myTeamInfo.isInTeam then
        return
    end
    local showChangePanelBtn = data.isInSoloDungeon and data.myTeamInfo.isInTeam and MgrMgr:GetMgr("MercenaryMgr"):FindFightMercenaryCount() > 0 and table.maxn(data.myTeamInfo.memberList) > 1
    if not self.panel.BtnChangePanel.gameObject.activeSelf and showChangePanelBtn then
        self.panel.InTeamPanel.gameObject:SetActiveEx(false)
        self.panel.NotInTeamPanel.gameObject:SetActiveEx(true)
        self.panel.ChangePanelOne.gameObject:SetActiveEx(false)
        self.panel.ChangePanelTeam.gameObject:SetActiveEx(true)
    elseif not showChangePanelBtn then
        self.panel.InTeamPanel.gameObject:SetActiveEx(true)
        self.panel.NotInTeamPanel.gameObject:SetActiveEx(false)
        self.panel.ChangePanelOne.gameObject:SetActiveEx(false)
        self.panel.ChangePanelTeam.gameObject:SetActiveEx(true)
    end
    self.panel.BtnChangePanel.gameObject:SetActiveEx(showChangePanelBtn)
end

local UPDTAE_DURATION = 3
function QuickTeamPanelHandler:UpdateBuff()
    if not self.startTime or not self.timeLab or table.ro_size(self.timeLab) == 0 then
        return
    end
    if not self.updateNum then
        self.updateNum = 0
    end
    self.updateNum = self.updateNum + 1
    if self.updateNum <= UPDTAE_DURATION then
        return
    end
    self.updateNum = nil
    local data = self.TeamData
    local myUid = self.UID
    local l_pass = Time.realtimeSinceStartup - self.startTime

    if data.isInTeam then
        local teamMemberNum = table.maxn(data.memberList)
        for i = 1, teamMemberNum do
            local l_roleID = tostring(data.memberList[i].roleId)
            if l_roleID ~= myUid and self.timeLab[l_roleID] then
                if #self.timeLab[l_roleID] > 0 then
                    for index_time = 1, #self.timeLab[l_roleID] do
                        if self.timeLab[l_roleID][index_time] then
                            local l_time = self.timeLab[l_roleID][index_time].remain - l_pass
                            local l_remain = math.floor(l_time + 0.5)
                            if l_remain > 0 then
                                self.timeLab[l_roleID][index_time].LabText = tostring(l_remain)
                                self.timeLab[l_roleID][index_time].Bg.fillAmount = 1 - l_time / self.timeLab[l_roleID][index_time].all
                            else
                                self.timeLab[l_roleID][index_time].go:SetActiveEx(false)
                                self.timeLab[l_roleID][index_time] = nil
                            end
                        end
                    end
                end
            end
        end
    end
end

--设置->停止跟随
function QuickTeamPanelHandler:SetToEndFollowBtn()
    self.panel.TeamaggregateText.LabText = Common.Utils.Lang("STOP_FOLLOW")
    self.panel.Teamaggregate:AddClick(function()
        MgrMgr:GetMgr("TeamMgr").SetEndAutoFollow()
    end)
end

--设置->跟随队长
function QuickTeamPanelHandler:SetToFollowBtn()
    self.panel.TeamaggregateText.LabText = Common.Utils.Lang("FOLLOW_CAPTAIN")
    self.panel.Teamaggregate:AddClick(function()
        if MgrMgr:GetMgr("ChatRoomMgr").Room:Has() then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("ChatRoom_TeamHint")) --当前状态不能进行组队跟随
            return
        end
        MgrMgr:GetMgr("TeamMgr").FollowOtherPeople(DataMgr:GetData("TeamData").myTeamInfo.captainId)
    end)
end

--设置->一键召集
function QuickTeamPanelHandler:SetOneKeyFollow()
    self.panel.TeamaggregateText.LabText = Common.Utils.Lang("ONE_KEY_FOLLOW")
    self.panel.Teamaggregate:AddClick(function()
        MgrMgr:GetMgr("TeamMgr").ToBeFollowedAll()
    end)
end

function QuickTeamPanelHandler:SetTeamTargetState(state, uid)
    if not state then
        self:CloseAllMarkUI()
    else
        self:SetTeamTargetSelectState(uid)
    end
end

--根据目标的UID设置目标的选中状态
function QuickTeamPanelHandler:SetTeamTargetSelectState(uid)
    if self.teamMiniUI == nil or #self.teamMiniUI == 0 then
        return
    end
    for i = 1, 5 do
        if self.teamMiniUI[i] and self.teamMiniUI[i].mark and (self.teamMiniUI[i].roleId or self.teamMiniUI[i].UId) then
            -- if self.teamMiniUI[i].roleId then
            --     self.teamMiniUI[i].mark.gameObject:SetActiveEx(tostring(self.teamMiniUI[i].roleId) == tostring(uid))
            -- end
            if self.teamMiniUI[i].UId then
                self.teamMiniUI[i].mark.gameObject:SetActiveEx(tostring(self.teamMiniUI[i].UId) == tostring(uid))
            end
        end
    end
    if self.mercenaryMiniUI == nil or #self.mercenaryMiniUI == 0 then
        return
    end
    for i = 1, 2 do
        if self.mercenaryMiniUI[i] and self.mercenaryMiniUI[i].mark and self.mercenaryMiniUI[i].UId then
            self.mercenaryMiniUI[i].mark.gameObject:SetActiveEx(tostring(self.mercenaryMiniUI[i].UId) == tostring(uid))
        end
    end
end

function QuickTeamPanelHandler:CloseAllMarkUI()
    if self.teamMiniUI == nil or #self.teamMiniUI == 0 then
        return
    end
    for i = 1, 5 do
        if self.teamMiniUI[i] then
            self.teamMiniUI[i].mark.gameObject:SetActiveEx(false)
        end
    end
    if self.mercenaryMiniUI == nil or #self.mercenaryMiniUI == 0 then
        return
    end
    for i = 1, 2 do
        if self.mercenaryMiniUI[i] then
            self.mercenaryMiniUI[i].mark.gameObject:SetActiveEx(false)
        end
    end
end

function QuickTeamPanelHandler:SetTempTeamPanel()
    local tempTeamEntityTb = DataMgr:GetData("TeamData").GetTempEntityTb()
    if tempTeamEntityTb == nil then
        return
    end
    self.panel.TeamAddTpl:AddClick(function()
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("CAN_NOT_DO_THIS"))
    end)
    self.panel.NotInTeamPanel.gameObject:SetActiveEx(false)
    self.panel.InTeamPanel.gameObject:SetActiveEx(true)
    self.panel.Teamaggregate.gameObject:SetActiveEx(false)
    local myUid = MPlayerInfo.UID:tostring()
    for i = 1, DataMgr:GetData("TeamData").maxTeamNumber do
        self.teamMiniUI[i].ui.gameObject:SetActiveEx(false)
    end
    local index = table.maxn(tempTeamEntityTb)
    if index > 5 then
        index = 5
    end
    for i = 1, index do
        local l_roleID = tostring(tempTeamEntityTb[i].UID)
        self.teamMiniUI[i].btnMore.gameObject:SetActiveEx(false)
        self.teamMiniUI[i].uiCom:AddClick(function()
            self:CloseAllMarkUI()
            self.teamMiniUI[i].mark.gameObject:SetActiveEx(true)
            local entity = MEntityMgr:GetEntity(tempTeamEntityTb[i].UID)
            if entity then
                MEntityMgr.PlayerEntity.Target = entity
            end
        end)
        self.teamMiniUI[i].ui.gameObject:SetActiveEx(true)
        self.teamMiniUI[i].name.LabText = tempTeamEntityTb[i].Name
        self.teamMiniUI[i].level.LabText = "Lv " .. tempTeamEntityTb[i].Level
        self.teamMiniUI[i].objOffLine.gameObject:SetActiveEx(false)
        self.teamMiniUI[i].objOnceOffLine.gameObject:SetActiveEx(false)
        self.teamMiniUI[i].objawayfrom.gameObject:SetActiveEx(false)
        self.teamMiniUI[i].objWaiting.gameObject:SetActiveEx(false)
        self.teamMiniUI[i].captainImage.gameObject:SetActiveEx(false)
        self.teamMiniUI[i].followImage.gameObject:SetActiveEx(false)
        self.teamMiniUI[i].sliderHp.value = tempTeamEntityTb[i].HPPercent
        self.teamMiniUI[i].sliderMp.value = 1
        --[[
        local imageName = DataMgr:GetData("TeamData").GetProfessionImageById(data.memberList[i].roleType)
        if imageName then
            self.teamMiniUI[i].professionImage:SetSpriteAsync("Common", imageName)
        end
        ]]--
    end
end

function QuickTeamPanelHandler:ExportTeamElement(element)
    element.uiCom = element.ui.transform:GetComponent("MLuaUICom")
    element.mark = element.ui.transform:Find("Mark")
    element.name = MLuaClientHelper.GetOrCreateMLuaUICom(element.ui.transform:Find("Name"))
    element.level = MLuaClientHelper.GetOrCreateMLuaUICom(element.ui.transform:Find("Level"))
    element.captainImage = element.ui.transform:Find("ImageCaptain")
    element.followImage = element.ui.transform:Find("ImageFollow")
    element.mercenaryImage = element.ui.transform:Find("ImageMercenary")
    element.professionImage = element.ui.transform:Find("ProfessionImage"):GetComponent("MLuaUICom")
    element.sliderHp = element.ui.transform:Find("SliderHP"):GetComponent("Slider")
    element.sliderMp = element.ui.transform:Find("SliderMP"):GetComponent("Slider")
    element.btnMore = element.ui.transform:Find("BtnArrow"):GetComponent("MLuaUICom")
    element.objOffLine = element.ui.transform:Find("Image_offline")
    element.objawayfrom = element.ui.transform:Find("Image_awayfrom")
    element.objOnceOffLine = element.ui.transform:Find("Image_onceoffline")
    element.objWaiting = element.ui.transform:Find("Image_waiting")
    element.buff = {}
    element.buff.go = element.ui.transform:Find("Buff").gameObject
    element.buff.tp = element.buff.go.transform:Find("reduce").gameObject
    element.buff.list = element.buff.go.transform:Find("buffList").gameObject
    element.buffList = {}
    element.revive = element.ui.transform:Find("MercenaryRevive")
    element.reviveText = MLuaClientHelper.GetOrCreateMLuaUICom(element.ui.transform:Find("MercenaryRevive/MercenaryText"))
end

--lua custom scripts end
return QuickTeamPanelHandler