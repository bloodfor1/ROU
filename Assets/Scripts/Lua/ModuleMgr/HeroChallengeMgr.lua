---
--- Created by chauncyhu.
--- DateTime: 2018/10/11 15:58
---

module("ModuleMgr.HeroChallengeMgr", package.seeall)

g_challengeInfo = {}

g_curIndex = nil
g_curDegree = nil

g_hasBegainTime = nil

g_lastSelectedIndex = 0

local l_lastDungeonInfo = nil

function OnEnterScene(sceneId)
    local l_ui = UIMgr:GetUI(UI.CtrlNames.DungeonTimer)
    if l_ui then
        g_hasBegainTime = true
        l_ui:UpdateTimeLab()
    else
        g_hasBegainTime = false
    end

    local l_stage = StageMgr:GetCurStageEnum()
    if  l_stage == MStageEnum.Null or l_stage == MStageEnum.Login or l_stage == MStageEnum.SelectChar then
        l_lastDungeonInfo = nil
        return
    end
    if MgrMgr:GetMgr("WatchWarMgr").IsInSpectator() then
        l_lastDungeonInfo = nil
        return
    end
    local l_type = MPlayerInfo.PlayerDungeonsInfo.DungeonType
    if tostring(l_type) == tostring(MgrMgr:GetMgr("DungeonMgr").DungeonType.DungeonHero) then
        l_lastDungeonInfo = MPlayerInfo.PlayerDungeonsInfo
    else
        if l_lastDungeonInfo then
            if MgrMgr:GetMgr("DailyTaskMgr").IsActivityOpend(MgrMgr:GetMgr("DailyTaskMgr").g_ActivityType.activity_HeroChallenge) then
                UIMgr:ActiveUI(UI.CtrlNames.HeroChallenge, function(ctrl)
                    ctrl:SelectIndex(g_lastSelectedIndex)
                end)
            end
            l_lastDungeonInfo = nil
        end
    end
end

function InitMgr()
    g_challengeInfo = {}
    local l_rows =  TableUtil.GetHeroChallengeTable().GetTable()
    local l_rowCount = #l_rows
    for i=1,l_rowCount do
        local l_row = l_rows[i]
        local l_index = #g_challengeInfo+1
        g_challengeInfo[l_index] = {}
        g_challengeInfo[l_index].table = l_row
        g_challengeInfo[l_index].dungeon = {}
        g_challengeInfo[l_index].pass = false
        g_challengeInfo[l_index].grade = 0
        g_challengeInfo[l_index].passTime = 0

        local j = 1
        while j <= l_row.DungeonID.Length do
            local l_dungeonID = l_row.DungeonID[j - 1]
            local l_numIndex = #(g_challengeInfo[l_index].dungeon)+1
            g_challengeInfo[l_index].dungeon[l_numIndex] = {}
            g_challengeInfo[l_index].dungeon[l_numIndex].dungeonID = l_dungeonID
            j = j + 1
        end
    end
end

function OnSelectRoleNtf(info)
    InitMgr()
    local l_records = info.dungeons.hero_challenge.records
    if #l_records>0 then
        for i = 1, #l_records do
            local l_target = l_records[i]
            local l_id = l_target.id
            local l_grade = l_target.best_grade
            local l_pass = l_target.is_pass
            local l_passTime = l_target.pass_time
            if #g_challengeInfo>0 then
                for i = 1, #g_challengeInfo do
                    local l_tableInfo = g_challengeInfo[i].table
                    local l_ID = l_tableInfo.ID
                    if l_ID == l_id then
                        g_challengeInfo[i].grade = l_grade
                        g_challengeInfo[i].pass = l_pass
                        g_challengeInfo[i].passTime = l_passTime
                        break
                    end
                end
            end
        end
    end
end

function RefreshInfo()
    if #g_challengeInfo>0 then
        for i = 1, #g_challengeInfo do
            g_challengeInfo[i].grade = 0
            g_challengeInfo[i].pass = false
            g_challengeInfo[i].passTime = 0
        end
    end
end

function OnDungeonsResult(msg)
    ---@type DungeonsResultData
    local l_info = ParseProtoBufToTable("DungeonsResultData", msg)
    local l_id  = l_info.dungeons_id
    local l_newGrade = l_info.grade

    local l_targetInfo = nil
    local l_state = false
    if #g_challengeInfo>0 then
        for i = 1, #g_challengeInfo do
            local l_dungeonInfo = g_challengeInfo[i].dungeon
            if #l_dungeonInfo>0 then
                for j = 1, #l_dungeonInfo do
                    local l_dungeonID = l_dungeonInfo[j].dungeonID
                    if l_dungeonID == l_id then
                        l_targetInfo = g_challengeInfo[i]
                        l_state = true
                        break
                    end
                end
            end
            if l_state then
                break
            end
        end
    end
    if l_targetInfo then
        UIMgr:DeActiveUI(UI.CtrlNames.DungeonTimer)
        l_newGrade = l_newGrade or 0
        local l_pass = l_info.status == DungeonsResultStatus.kResultVictory or l_info.status == DungeonsResultStatus.kResultAssistSuccess --not (l_newGrade ==nil or l_newGrade ==0)
        if l_pass then
            local l_nowGrade = l_targetInfo.grade
            l_targetInfo.grade = l_newGrade>l_nowGrade and l_newGrade or l_nowGrade
            l_targetInfo.pass = l_info.status == DungeonsResultStatus.kResultVictory
            local l_new = l_newGrade>l_nowGrade
            local l_time = l_info.pass_time
            local l_degree = l_info.degree
            if l_new then
                l_targetInfo.passTime = l_time
            end
            --local l_degreeDes = " "
            --l_degreeDes = l_degree == 1 and Common.Utils.Lang("HERO_CHALLENGE_DIFFICULTY_1") or l_degreeDes
            --l_degreeDes = l_degree == 2 and Common.Utils.Lang("HERO_CHALLENGE_DIFFICULTY_2") or l_degreeDes
            --l_degreeDes = l_degree == 3 and Common.Utils.Lang("HERO_CHALLENGE_DIFFICULTY_3") or l_degreeDes
            UIMgr:ActiveUI(UI.CtrlNames.HeroChallengeResult,function ()
                local l_ui = UIMgr:GetUI(UI.CtrlNames.HeroChallengeResult)
                if l_ui then
                    l_ui:ShowWinTween({
                        Difficulty=l_degree,
                        PassTime=l_time,
                        IsNewScore=l_new,
                        Title3=Lang("HeroChallengeResult_ScoreText"),
                        TitleDescription3=l_newGrade,
                    })
                end
            end)
        else
            UIMgr:ActiveUI(UI.CtrlNames.HeroChallengeResult,function ()
                local l_ui = UIMgr:GetUI(UI.CtrlNames.HeroChallengeResult)
                if l_ui then
                    l_ui:ShowLoseTween()
                end
            end)
        end
    end
end

function EnterDungeons(dungeonId,degree)
    MgrMgr:GetMgr("DungeonMgr").EnterDungeons(dungeonId,0,degree)
end

return HeroChallengeMgr