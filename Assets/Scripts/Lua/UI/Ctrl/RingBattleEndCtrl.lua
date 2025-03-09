--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/RingBattleEndPanel"
require "UI/Template/BtnPlayerTemplate"
require "UI/Template/BtnOtherTemplate"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua class define
local super = UI.UIBaseCtrl
RingBattleEndCtrl = class("RingBattleEndCtrl", super)
local mgr = MgrMgr:GetMgr("ArenaMgr")
--lua class define end

--lua functions
function RingBattleEndCtrl:ctor()

    super.ctor(self, CtrlNames.RingBattleEnd, UILayer.Function, nil, ActiveType.Exclusive)
    self.pvpMgr = MgrMgr:GetMgr("PvpMgr")
end --func end
--next--
function RingBattleEndCtrl:Init()

    self.panel = UI.RingBattleEndPanel.Bind(self)
    super.Init(self)
    self.winPlayerPool = self:NewTemplatePool({
        UITemplateClass = UITemplate.BtnPlayerTemplate,
        TemplateParent = self.panel.PlayerContent.transform,
        TemplatePrefab = self.panel.BtnPlayerTemplate.LuaUIGroup.gameObject
    })
    self.otherPlayerPool = self:NewTemplatePool({
        UITemplateClass = UITemplate.BtnOtherTemplate,
        TemplateParent = self.panel.OtherContent.transform,
        TemplatePrefab = self.panel.BtnOtherTemplate.LuaUIGroup.gameObject
    })

    self.hide = false
    self.panel.HideBtn:AddClick(function()
        self.hide = not self.hide
        if self.hide then
            self.panel.BG:SetActiveEx(false)
        else
            self.panel.BG:SetActiveEx(true)
        end
    end)
    self.panel.SaveBtn:AddClick(function()
        self.pvpMgr:Save2Phone()
    end)
    self.panel.MobileBtn:AddClick(function()
        self.pvpMgr.Save2Photo()
    end)

    self.panel.ConfirmBtn:AddClick(function()
        self:Exit()
    end)
end --func end
--next--
function RingBattleEndCtrl:Uninit()
    self.winPlayerPool = nil
    self.otherPlayerPool = nil
    super.Uninit(self)
    self.panel = nil
end --func end
--next--
function RingBattleEndCtrl:OnActive()
    self.result = nil
    if MgrMgr:GetMgr("DungeonMgr").IsInDungeons() then
        if MPlayerInfo.PlayerDungeonsInfo.DungeonType == MgrMgr:GetMgr("DungeonMgr").DungeonType.DungeonGuildMatch then
            self.result = DataMgr:GetData("GuildMatchData").ResultInfo
            self.panel.RingBattlePan.UObj:SetActiveEx(false)
            self.panel.GuildMatchpan.UObj:SetActiveEx(true)

            self.panel.GuildNameBlue.LabText = self.result.guildInfo[1].name or "--"
            self.panel.GuildNameRed.LabText = self.result.guildInfo[2].name or "--"
            local l_iconData = TableUtil.GetGuildIconTable().GetRowByGuildIconID(self.result.guildInfo[1].icon)
            self.panel.GuildIconBlue:SetSprite(l_iconData.GuildIconAltas, l_iconData.GuildIconName)
            l_iconData = TableUtil.GetGuildIconTable().GetRowByGuildIconID(self.result.guildInfo[2].icon)
            self.panel.GuildIconRed:SetSprite(l_iconData.GuildIconAltas, l_iconData.GuildIconName)
        else
            self.result = MgrMgr:GetMgr("ArenaMgr").GetRingResult()
            self.panel.RingBattlePan.UObj:SetActiveEx(true)
            self.panel.GuildMatchpan.UObj:SetActiveEx(false)
        end
    end

    self.exitTimer = self:NewUITimer(handler(self, self.OnExitTimer), 1, -1)
    self.exitTimer:Start()
    self.autoExitTime = MgrMgr:GetMgr("ArenaMgr").ArenaResultCountDown
    self.exitTime = self.autoExitTime
    self.panel.RawImage.RawImg.texture = self.pvpMgr.g_BattleTex
    self.panel.RawImage:SetActiveEx(true)
    self:RefreshHead(self.result)
    self:RefreshPlayers(self.result)
    self:RefreshFooter()
end --func end

function RingBattleEndCtrl:RefreshHead(result)
    if result == nil then
        return
    end
    if result.status == 1 or result.status == 2 then
        local win = result.status == 1
        self.panel.Win.UObj:SetActiveEx(win)
        self.panel.GuildWin.UObj:SetActiveEx(win)
        self.panel.Lose.UObj:SetActiveEx(not win)
        self.panel.GuildLose.UObj:SetActiveEx(not win)
        if not win then
            self.panel.FailLab.LabText = Lang("ARENA_RING_RESULT_FAILTIP")
        end
    else
        self.panel.Win.UObj:SetActiveEx(false)
        self.panel.Lose.UObj:SetActiveEx(true)
        self.panel.GuildWin.UObj:SetActiveEx(false)
        self.panel.GuildLose.UObj:SetActiveEx(true)
        self.panel.FailLab.LabText = Lang("ARENA_RING_RESULT_DRAWTIP")
    end

    if result.score == nil then
        return
    end
    local countLabs = result.status == 1 and self.panel.WinRedCountLab or self.panel.LoseRedCountLab
    for i, v in ipairs(countLabs) do
        v.LabText = result.score[i]
    end
end

function RingBattleEndCtrl:RefreshPlayers(result)
    if result == nil then
        return
    end
    local resultInfo = result
    local players = table.ro_keys(resultInfo.player)
    local others = table.ro_keys(resultInfo.other)
    for i, v in ipairs(others) do
        array.addUnique(players, v)
    end
    MgrMgr:GetMgr("HeadMgr").SetHead(players)
end

function RingBattleEndCtrl:OnSetHead(headInfos, roleIdList)
    if self.result == nil then
        return
    end
    local resultInfo = self.result
    local players = table.ro_keys(resultInfo.player)
    local others = table.ro_keys(resultInfo.other)
    local statistics = resultInfo.statistics
    local datas = {}
    local headInfo
    for i, v in ipairs(players) do
        headInfo = headInfos[tostring(v)]
        if headInfo then
            table.insert(datas, {
                roleId = v,
                attr = headInfo.attr,
                name = headInfo.player.name,
                jobName = DataMgr:GetData("TeamData").GetProfessionNameById(headInfo.player.role_type),
                score = statistics[tostring(v)] or 0,
                isMvp = v == resultInfo.mvpId,
                kill = resultInfo.player[v].kill,
                help = resultInfo.player[v].help,
                score = resultInfo.player[v].score,
                beKill = resultInfo.player[v].beKill,
            })
        else
            logError("get head info fail: ", v)
        end
    end
    self.winPlayerPool:ShowTemplates({ Datas = datas })
    datas = {}
    for i, v in ipairs(others) do
        headInfo = headInfos[tostring(v)]
        if headInfo then
            table.insert(datas, {
                roleId = v,
                attr = headInfo.attr,
                name = headInfo.player.name,
                jobName = DataMgr:GetData("TeamData").GetProfessionNameById(headInfo.player.role_type),
                score = statistics[tostring(v)] or 0,
                isMvp = v == resultInfo.otherMvpId,
                kill = resultInfo.other[v].kill,
                help = resultInfo.other[v].help,
                score = resultInfo.other[v].score,
                beKill = resultInfo.other[v].beKill,
            })
        else
            logError("get head info fail: ", v)
        end
    end
    self.otherPlayerPool:ShowTemplates({ Datas = datas })
end

function RingBattleEndCtrl:RefreshFooter()
    self.panel.CloseTip.LabText = Lang("ARENA_RESULT_CLOSE_TIP", self.exitTime)
end
--next--
function RingBattleEndCtrl:OnDeActive()
    if self.exitTimer then
        self:StopUITimer(self.exitTimer)
        self.exitTimer = nil
    end
    self:ResetRawImage()
    --UIMgr:ShowTipsContainer()
end --func end
--next--
function RingBattleEndCtrl:Update()


end --func end

--next--
function RingBattleEndCtrl:BindEvents()
    self:BindEvent(MgrMgr:GetMgr("HeadMgr").EventDispatcher, EventConst.Names.HEAD_SET_HEDA, self.OnSetHead)
end --func end
--next--
--lua functions end

--lua custom scripts
function RingBattleEndCtrl:Exit()
    UIMgr:DeActiveUI(UI.CtrlNames.RingBattleEnd)
    if not MgrMgr:GetMgr("DungeonMgr").IsInDungeons() then
        return
    end
    local resultInfo = MgrMgr:GetMgr("ArenaMgr").ResultInfo
    if resultInfo.round and resultInfo.round == mgr.ArenaBattleRounds then
        UIMgr:ActiveUI(UI.CtrlNames.ArenaSettlement,resultInfo)
    else
        MgrMgr:GetMgr("DungeonMgr").LeaveDungeon()
    end
end

function RingBattleEndCtrl:OnExitTimer()
    self.exitTime = self.exitTime - 1
    self.panel.CloseTip.LabText = Lang("ARENA_RESULT_CLOSE_TIP", self.exitTime)
    if self.exitTime <= 0 then
        return self:Exit()
    end
end

function RingBattleEndCtrl:ResetRawImage()
    if self.panel then
        self.panel.RawImage.RawImg.texture = nil
    end
end
--lua custom scripts end
return RingBattleEndCtrl