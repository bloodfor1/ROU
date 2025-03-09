--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/MonsterRepelPanel"
--lua requires end

--lua model
module("UI", package.seeall)
local l_RepelMonsters = { MGlobalConfig:GetInt("ExpAwardID"), MGlobalConfig:GetInt("JewelryAwardID") }
local l_lastOpenBlessTime = -1
local expelActivityId = 9
local l_taskMgr = MgrMgr:GetMgr("DailyTaskMgr")
--lua model end

--lua class define
local super = UI.UIBaseCtrl
MonsterRepelCtrl = class("MonsterRepelCtrl", super)
--lua class define end

--lua functions
function MonsterRepelCtrl:ctor()

    super.ctor(self, CtrlNames.MonsterRepel, UILayer.Function, UITweenType.UpAlpha, ActiveType.Standalone)

end --func end
--next--
function MonsterRepelCtrl:Init()

    self.panel = UI.MonsterRepelPanel.Bind(self)
    super.Init(self)
    self.openTimeStamp = 0
end --func end
--next--
function MonsterRepelCtrl:Uninit()

    super.Uninit(self)
    self.panel = nil

end --func end
--next--
function MonsterRepelCtrl:OnActive()
    self:ShowExpelMonsterPanel()
end --func end

function MonsterRepelCtrl:SetAutoShowQuestionTip(flag)
    self.isAutoShowTip = flag
end

function MonsterRepelCtrl:ShowExpelMonsterPanel()
    self.panel.RepelBG:AddClick(function ()
        UIMgr:DeActiveUI(UI.CtrlNames.MonsterRepel)
    end)
    self.panel.closeButton:AddClick(function()
        UIMgr:DeActiveUI(UI.CtrlNames.MonsterRepel)
    end)

    local l_severOnceSystemMgr = MgrMgr:GetMgr("ServerOnceSystemMgr")
    self.panel.AutoBackTog.Tog.isOn = l_severOnceSystemMgr.GetServerOnceState(l_severOnceSystemMgr.EServerOnceType.AutoRecallOnBlessOut)
    -- 自动回城设置
    self.panel.AutoBackTog.Tog.onValueChanged:AddListener(function(isOn)
        MgrMgr:GetMgr("BackCityMgr").SetAutoRecallOnBlessOut(isOn)
    end)

    self.panel.BuffInfo:SetActiveEx(false)
    self.panel.BuffUpBtn:AddClick(function()
        self.panel.BuffInfo:SetActiveEx(true)
        if not self.buffTimer then
            self.buffTimer = self:NewUITimer(function()
                self:RefreshBuffInfo()
            end, 1, -1)
            self.buffTimer:Start()
        end
    end)

    self.panel.BuffInfoBackBtn:AddClick(function()
        self.panel.BuffInfo:SetActiveEx(false)
        if self.buffTimer then
            self.buffTimer:Stop()
            self.buffTimer = nil
        end
    end)

    local tableInfo = TableUtil.GetDailyActivitiesTable().GetRowById(expelActivityId)
    if not tableInfo then return logError("can't find activity sdata by ", expelActivityId) end
    self.panel.Tmp_expelTitle.LabText = tableInfo.ActivityName
    self.panel.expelContext.LabText = RoColor.FormatWord1(Lang("EXPEL_MONSTER_CONTENT"))
    self.panel.expelLeftTimeTip.LabText = Lang("EXPEL_MONSTER_LEFT_TIME_TIP")
    self.panel.BgImg:SetRawTexAsync(string.format("%s/%s",tableInfo.ContentPicAtlas, tableInfo.ContentPicName))
    MLuaUIListener.Get(self.panel.questionButton.gameObject)
    self.panel.InfoContext.LabText=tableInfo.AcitiveText
    local l_dailyTaskMgr = MgrMgr:GetMgr("DailyTaskMgr")
    local leftTimeStr = self:getLeftTimeStr(l_dailyTaskMgr.GetLastRecordExpelRemainTime())
    self.panel.expelLeftTime.LabText = leftTimeStr
    self.panel.maxBlessingTimetTxt.LabText = self:getMaxBlessingTimeStr()
    MgrMgr:GetMgr("DailyTaskMgr").GetBlessInfo()

    -- 打宝糖buff
    self:RefreshBuffInfo()
end

--[[
    @Description: 收到驱魔数据刷新界面
    @Date: 2018/8/2
    @Param: [args]
    @Return
--]]
---@param info GetBlessInfoRes
function MonsterRepelCtrl:OnExpelMonsterInfo(info)

    if info.open_timestamp == 0 then
        self.openTimeStamp = 0
    else
        self.openTimeStamp = tonumber(info.open_timestamp + MGlobalConfig:GetInt("BlessOpenCD"))
    end
    
    local leftTimeStr = self:getLeftTimeStr(info.remain_time)

    self.panel.openBlessBtn.gameObject:SetActiveEx(not info.is_blessing)
    self.panel.closeBlessBtn.gameObject:SetActiveEx(info.is_blessing)
    local extra_fight_time = info.extra_fight_time or 0

    self.panel.openBlessBtn:AddClick(function ()
        if self.openTimeStamp~= 0 and Common.TimeMgr.GetNowTimestamp() < self.openTimeStamp then
            return MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("BLESS_CLOSE_CD_PROMT", math.ceil(self.openTimeStamp - Common.TimeMgr.GetNowTimestamp())))
        end
        CommonUI.Dialog.ShowYesNoDlg(
            true, nil,
            Lang("EXPEL_MONSTER_OPEN_DIALOG_TITLE"),
            function ()
                l_lastOpenBlessTime = Common.TimeMgr.GetUtcTimeByTimeTable()
                MgrMgr:GetMgr("DailyTaskMgr").BlessOperate(true)
                self.openTimeStamp = tonumber(Common.TimeMgr.GetNowTimestamp() + MGlobalConfig:GetInt("BlessOpenCD"))
            end
        )
    end)

    self.panel.closeBlessBtn:AddClick(function ()
        if self.openTimeStamp~= 0  and Common.TimeMgr.GetNowTimestamp() < self.openTimeStamp then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(StringEx.Format(Common.Utils.Lang("BLESS_OPEN_CD_PROMT"),math.ceil(self.openTimeStamp - Common.TimeMgr.GetNowTimestamp())))
        else
            self.openTimeStamp = tonumber(Common.TimeMgr.GetNowTimestamp() + MGlobalConfig:GetInt("BlessOpenCD"))
            MgrMgr:GetMgr("DailyTaskMgr").BlessOperate(false)
        end
    end)
    self.panel.questionButton.Listener.onClick = function(go, eventData)
        UIMgr:ActiveUI(CtrlNames.DemonEvictionTips)
    end
    self.panel.expelLeftTime.LabText = leftTimeStr
    if self.isAutoShowTip then
        self:ShowQuestionTip(info)
    end
end
function MonsterRepelCtrl:getLeftTimeStr(leftTime)
    return leftTime <= 0 and Lang("EXPEL_MONSTER_OUT_OF_TIME")
            or Lang("EXPEL_MONSTER_LEFT_TIME", math.floor(leftTime/(60 * 1000)))
end
function MonsterRepelCtrl:getMaxBlessingTimeStr()
    return Lang("EXPEL_MONSTER_MAX_TIME", math.floor(MGlobalConfig:GetFloat("MaxBlessingTime"))/(1000 * 60))
end
function MonsterRepelCtrl:ShowQuestionTip(info)
    if not self.panel then return end
    local extra_fight_time = info.extra_fight_time or 0
    local canvas = self.panel.PanelRef:GetComponent("Canvas")
    local screenPos = canvas.worldCamera:WorldToScreenPoint(self.panel.questionButton.transform.position)
    local point = Vector2(screenPos.x, screenPos.y)
    local ed = PointerEventData.New(EventSystem.current)
    ed.position = point
    MgrMgr:GetMgr("TipsMgr").ShowQuestionTip(Lang("EXPEL_FIGHT_TIME_TIP", math.ceil(extra_fight_time/(60 * 1000))), ed, Vector2(0, 0), nil, nil, MUIManager.UICamera)
end

function MonsterRepelCtrl:GetQuestionTip(info)
    local l_RepelMonsterItemInfos = {}
    local function GetKillCount(monId)
        local num = 0
        for i, info in ipairs(info.monsters) do
            if info.monster_id == monId then
                num = info.kill_num
                break
            end
        end
        return num
    end
    for i, monsId in ipairs(l_RepelMonsters) do
        table.insert(l_RepelMonsterItemInfos, {
            killCount = GetKillCount(monsId),
            monsId = monsId})
    end
    local ret = Lang("EXPEL_QUESTION_TIPS", l_RepelMonsterItemInfos[1].killCount, l_RepelMonsterItemInfos[2].killCount)
    return ret
end

function MonsterRepelCtrl:OnExpelOperate(info)
    self.panel.openBlessBtn.gameObject:SetActiveEx(not info.is_blessing)
    self.panel.closeBlessBtn.gameObject:SetActiveEx(info.is_blessing)
    if info.is_blessing then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("EXPEL_MONSTER_OPEN_SUCC_TIP"))
    else
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("EXPEL_MONSTER_OPEN_FAIL_TIP"))
    end
end

--next--
function MonsterRepelCtrl:OnDeActive()
    self.isAutoShowTip = false

end --func end
--next--
function MonsterRepelCtrl:Update()


end --func end

--next--
function MonsterRepelCtrl:BindEvents()
    self:BindEvent(l_taskMgr.EventDispatcher,l_taskMgr.DAILY_ACTIVITY_EXPEL_INFO, self.OnExpelMonsterInfo)
    self:BindEvent(l_taskMgr.EventDispatcher,l_taskMgr.DAILY_ACTIVITY_EXPEL_OPERATE, self.OnExpelOperate)
end --func end
--next--
--lua functions end

--lua custom scripts

function MonsterRepelCtrl:RefreshBuffInfo()
    local l_daBaoTangBuffId = MgrMgr:GetMgr("AutoFightItemMgr").GetDaBaoTangBuffId()
    self.panel.BuffUpBtn:SetActiveEx(l_daBaoTangBuffId ~= 0)
    if l_daBaoTangBuffId ~= 0 then
        local l_buffRow = TableUtil.GetBuffTable().GetRowById(l_daBaoTangBuffId)
        if l_buffRow then
            self.panel.BuffUpIcon:SetSprite(l_buffRow.IconAtlas,l_buffRow.Icon)
            self.panel.BuffIcon:SetSprite(l_buffRow.IconAtlas,l_buffRow.Icon)
            self.panel.BuffName.LabText = l_buffRow.InGameName
            self.panel.BuffDes.LabText = l_buffRow.Description
        end
    end
    local l_remainTime = MgrMgr:GetMgr("AutoFightItemMgr").GetDaBaoTangBuffLeftTime()
    self.panel.BuffTime.LabText = MgrMgr:GetMgr("BuffMgr").GetBuffTimeDes(l_remainTime)
end


--lua custom scripts end
return MonsterRepelCtrl