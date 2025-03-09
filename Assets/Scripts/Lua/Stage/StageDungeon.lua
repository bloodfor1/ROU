module("Stage", package.seeall)
require "Stage/StageBase"

local super = Stage.StageBase
StageDungeon = class("StageDungeon", super)

function StageDungeon:ctor()
    super.ctor(self, MStageEnum.Dungeon)
end

function StageDungeon:OnEnterStage(toSceneId, fromStage)
    super.OnEnterStage(self, toSceneId, fromStage)
end

function StageDungeon:OnLeaveStage()
    super.OnLeaveStage(self)
    --退出副本的时候强制解锁一次主界面切换按钮
    MgrMgr:GetMgr("MainUIMgr").IsSwitchUILock = false
    --副本退出时 清空奖励缓存池
    DataMgr:GetData("ThemeDungeonData").DungeonRewardItem = {}
    --副本退出时 检查一下 点击副本退出按钮产生的对话框是否存在 存在则关闭
    CommonUI.Dialog.CloseDlgByTopic(CommonUI.Dialog.DialogTopic.DUNGEON_QUIT)
    --退出副本关闭跑马灯
    MgrMgr:GetMgr("TipsMgr").ClearImportantNotice()
    --关闭倒计时
    UIMgr:DeActiveUI(UI.CtrlNames.CountDown)
    --关闭半身像提示
    CommonUI.ModelAlarm.HideAlarm()
end

function StageDungeon:OnEnterScene(sceneId)
    super.OnEnterScene(self, sceneId)

    if MPlayerInfo.PlayerDungeonsInfo.DungeonID > 0 then

        --UIMgr:ActiveUI(UI.CtrlNames.DungeonTarget)
        local l_dungeonRow = TableUtil.GetDungeonsTable().GetRowByDungeonsID(MPlayerInfo.PlayerDungeonsInfo.DungeonID)
        --MgrMgr:GetMgr("SceneEnterMgr").AppendMainPanels(UI.CtrlNames.DungeonTarget)
        local l_dungeonMgr = MgrMgr:GetMgr("DungeonMgr")
        local dungeonType = MPlayerInfo.PlayerDungeonsInfo.DungeonType
        if dungeonType == l_dungeonMgr.DungeonType.DungeonHymn then
            UIMgr:ActiveUI(UI.CtrlNames.HymnTrialInfo)  --圣歌试炼需要进入副本场景是显示信息面板
            MgrMgr:GetMgr("HymnTrialMgr").InitLog()  --进入清理日志
        elseif dungeonType == l_dungeonMgr.DungeonType.DungeonBeach then
            MgrMgr:GetMgr("BeachMgr").StartBeach()
        elseif dungeonType == l_dungeonMgr.DungeonType.DungeonAvoid then
            local l_DBQTotalTime = MGlobalConfig:GetInt("DBQTotalTime")
            local l_DBQPlayerHp = MGlobalConfig:GetInt("DBQPlayerHp")
            local l_DBQRageTime = MGlobalConfig:GetVectorSequence("DBQRageTime")
            local l_DBQWaitTime = l_dungeonRow and tonumber(l_dungeonRow.StartCountDown) or 0
            UIMgr:ActiveUI(UI.CtrlNames.AvoidPanel, function (ctrl)
                ctrl:SetData(l_DBQTotalTime, l_DBQPlayerHp,
                    Common.Functions.VectorSequenceToTable(l_DBQRageTime), l_DBQWaitTime)
            end)
            UIMgr:DeActiveUI(UI.CtrlNames.MainArrows)
        elseif dungeonType == l_dungeonMgr.DungeonType.DungeonPvp then
            MgrMgr:GetMgr("PvpArenaMgr").ClearInfo()
        elseif dungeonType == l_dungeonMgr.DungeonType.DungeonTask then
            --任務副本 且 是英灵殿进入副本添加引导
            if MPlayerInfo.PlayerDungeonsInfo.DungeonID == MGlobalConfig:GetInt("YLDGuideDungeonID") then
                MgrMgr:GetMgr("BeginnerGuideMgr").CheckShowBeginnerGuide({"YLDGuide"})
            end
        end
        --副本开始倒计时
        if l_dungeonRow and tonumber(l_dungeonRow.StartCountDown) > 0 then
            UIMgr:ActiveUI(UI.CtrlNames.DungeonCountDown, function(ctrl)
                ctrl:Play(l_dungeonMgr.DungeonStartTime, tonumber(l_dungeonRow.StartCountDown), Lang("DUNGEON_START_BATTLE"))
            end)
        end
    end
end

