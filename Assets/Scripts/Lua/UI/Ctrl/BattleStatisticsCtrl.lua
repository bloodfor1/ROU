--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/BattleStatisticsPanel"
require "UI/Template/ItemTemplate"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua fields
local super = UI.UIBaseCtrl
local l_roleInfoMgr = MgrMgr:GetMgr("RoleInfoMgr")
--next--
--lua fields end

--lua class define
BattleStatisticsCtrl = class("BattleStatisticsCtrl", super)
--lua class define end

--lua functions
function BattleStatisticsCtrl:ctor()

    super.ctor(self, CtrlNames.BattleStatistics, UILayer.Function, nil, ActiveType.Normal)

end --func end
--next--
function BattleStatisticsCtrl:Init()

    self.panel = UI.BattleStatisticsPanel.Bind(self)
    super.Init(self)

    self.BattleStatisticsBlessItemPool = self:NewTemplatePool({
        UITemplateClass = UITemplate.ItemTemplate,
    })
    self.BattleStatisticsNormalItemPool = self:NewTemplatePool({
        UITemplateClass = UITemplate.ItemTemplate,
    })

    self.panel.BlessStatePanel.BtnCheckLeftBlessTime.Listener.onClick = function(go, eventData)
        --MgrMgr:GetMgr("TipsMgr").ShowQuestionTip(Lang("BATTLESTATISTICS_BLESS_LEFT_TIME_TIPS"), eventData, Vector2(0, 1))
        UIMgr:ActiveUI(UI.CtrlNames.MonsterRepel)
    end

    self.panel.NormalStatePanel.BtnCheckBattleState.Listener.onClick = function(go, eventData)
        MgrMgr:GetMgr("TipsMgr").ShowQuestionTip(Lang("BATTLESTATISTICS_BATTLE_STATE_TIPS"), eventData, Vector2(0, 0.5))
    end

    self.panel.NormalStatePanel.BtnUp:AddClick(function()
        self.panel.Obj_SeverLevel.gameObject:SetActiveEx(true)
    end)

    self.panel.NormalStatePanel.BtnDown:AddClick(function()
        self.panel.Obj_SeverLevel.gameObject:SetActiveEx(true)
    end)

    self.panel.BlessStatePanel.BtnUp_1:AddClick(function()
        self.panel.Obj_SeverLevel.gameObject:SetActiveEx(true)
    end)

    self.panel.BlessStatePanel.BtnDown_1:AddClick(function()
        self.panel.Obj_SeverLevel.gameObject:SetActiveEx(true)
    end)

    self.panel.Obj_SeverLevel:AddClick(function()
        self.panel.Obj_SeverLevel.gameObject:SetActiveEx(false)
    end)

end --func end
--next--
function BattleStatisticsCtrl:Uninit()

    super.Uninit(self)
    self.panel = nil

end --func end
--next--
function BattleStatisticsCtrl:OnActive()

    self.panel.BtnClose:AddClick(function()
        UIMgr:DeActiveUI(UI.CtrlNames.BattleStatistics)
    end)

    self.panel.TogBlessState:OnToggleExChanged(function(value)
        if not value then
            return
        end
        self.panel.BlessStatePanel.LuaUIGroup.gameObject:SetActiveEx(true)
        self.panel.NormalStatePanel.LuaUIGroup.gameObject:SetActiveEx(false)
        MgrMgr:GetMgr("BattleStatisticsMgr").BattleRevenueReq()
    end)

    self.panel.TogNormalState:OnToggleExChanged(function(value)
        if not value then
            return
        end
        self.panel.BlessStatePanel.LuaUIGroup.gameObject:SetActiveEx(false)
        self.panel.NormalStatePanel.LuaUIGroup.gameObject:SetActiveEx(true)
        MgrMgr:GetMgr("BattleStatisticsMgr").BattleRevenueReq()
    end)

    --祝福buff
    --if MEntityMgr.PlayerEntity:HasBuff(916201) then
    if MgrMgr:GetMgr("DailyTaskMgr").HasBless() then
        self.panel.TogBlessState.TogEx.isOn = true
        MgrMgr:GetMgr("BattleStatisticsMgr").BattleRevenueReq()
        self.panel.BlessStatePanel.LuaUIGroup.gameObject:SetActiveEx(true)
        self.panel.NormalStatePanel.LuaUIGroup.gameObject:SetActiveEx(false)
    else
        self.panel.TogNormalState.TogEx.isOn = true
        MgrMgr:GetMgr("BattleStatisticsMgr").BattleRevenueReq()
        self.panel.BlessStatePanel.LuaUIGroup.gameObject:SetActiveEx(false)
        self.panel.NormalStatePanel.LuaUIGroup.gameObject:SetActiveEx(true)
    end

    self.panel.NormalStatePanel.MonsterCoinTips.LabText = Common.CommonUIFunc.GetRichText(Common.Utils.Lang("BATTLESTATISTICS_MONSTERCOIN_TIPS"), "MonsterCoinUse", "Blue", Common.Utils.Lang("VIEW_Exchange"))
    local l_richText = self.panel.NormalStatePanel.MonsterCoinTips:GetRichText()
    l_richText.raycastTarget = true
    l_richText.onHrefClick:RemoveAllListeners()
    l_richText.onHrefClick:AddListener(function(hrefName)
        if hrefName == "MonsterCoinUse" then

            if MgrMgr:GetMgr("OpenSystemMgr").IsSystemOpen(MgrMgr:GetMgr("OpenSystemMgr").eSystemId.MonsterShop) then
                --寻路成功才关闭对应界面
                local l_result = Common.CommonUIFunc.InvokeFunctionByFuncId(MgrMgr:GetMgr("OpenSystemMgr").eSystemId.MonsterShop)
                if l_result then
                    game:ShowMainPanel()
                end
            else
                MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("THEME_DUNGEONS_NOT_OPEN"))
            end
        end
    end)
    l_roleInfoMgr.GetServerLevelBonusInfo()
end --func end
--next--
function BattleStatisticsCtrl:OnDeActive()


end --func end
--next--
function BattleStatisticsCtrl:Update()
    -- do nothing
end --func end

--next--
function BattleStatisticsCtrl:BindEvents()
    local l_battleStatisticsMgr = MgrMgr:GetMgr("BattleStatisticsMgr")
    self:BindEvent(l_battleStatisticsMgr.EventDispatcher, l_battleStatisticsMgr.OnRefreshBattleRevenue, self.RefreshBattleStatistics)
    self:BindEvent(l_roleInfoMgr.EventDispatcher, l_roleInfoMgr.ON_SERVER_LEVEL_UPDATE, self.SetServerLevel)
end --func end
--next--
--lua functions end

--lua custom scripts
function BattleStatisticsCtrl:RefreshBattleStatistics(data)
    if self.panel == nil then
        return
    end

    local l_blessPanel = self.panel.BlessStatePanel
    l_blessPanel.TxtBattleTime.LabText = StringEx.Format("{0:F0}", TimeSpan.FromMilliseconds(data.Bless.FightTime).TotalMinutes) .. Lang("MINUTE")
    if not data.Bless.IsBless then
        l_blessPanel.TxtIsOpen.LabText = Lang("NOT_OPEN")
    else
        l_blessPanel.TxtIsOpen.LabText = Lang("HAS_OPEN")
    end

    l_blessPanel.TxtLeftBlessTime.LabText = StringEx.Format("<color=$$Green$$>{0:F0}" .. Lang("MINUTE") .. "</color>", TimeSpan.FromMilliseconds(data.Bless.RemainBlessTime).TotalMinutes)
    l_blessPanel.TxtBaseExp.LabText = tostring(data.Bless.BaseExp)
    l_blessPanel.TxtJobExp.LabText = tostring(data.Bless.JobExp)
    self.BattleStatisticsBlessItemPool:ShowTemplates({
        Datas = data.Bless.Items,
        Parent = l_blessPanel.GetItemContent.transform
    })

    local l_normalPanel = self.panel.NormalStatePanel
    l_normalPanel.TxtBattleTime.LabText = StringEx.Format("{0:F0}", TimeSpan.FromMilliseconds(data.Normal.FightTime).TotalMinutes) .. Lang("MINUTE")
    local l_time = TimeSpan.FromMilliseconds(data.Normal.FightTime).TotalMinutes

    local l_state, l_stateText = MgrMgr:GetMgr("BattleStatisticsMgr").GetBattleStateByTime(l_time)
    self.panel.NormalStatePanel.MonsterCoinTips.gameObject:SetActiveEx(l_state == GameEnum.EBattleHealthy.Tried or l_state == GameEnum.EBattleHealthy.VeryTried)
    l_normalPanel.TxtIsOpen.LabText = l_stateText

    --策划需求暂时关闭疲劳提示文本
    self.panel.NormalStatePanel.MonsterCoinTips.gameObject:SetActiveEx(false)
    --

    l_normalPanel.TxtBaseExp.LabText = tostring(data.Normal.BaseExp)
    l_normalPanel.TxtJobExp.LabText = tostring(data.Normal.JobExp)

    --将魔物硬币置于最前
    local l_Items = {}
    for _, v in pairs(data.Normal.Items) do
        if v.ID == MgrMgr:GetMgr("PropMgr").l_virProp.MonsterCoin then
            table.insert(l_Items, v)
            break
        end
    end
    for _, v in pairs(data.Normal.Items) do
        if v.ID ~= MgrMgr:GetMgr("PropMgr").l_virProp.MonsterCoin then
            table.insert(l_Items, v)
        end
    end

    self.BattleStatisticsNormalItemPool:ShowTemplates({
        Datas = l_Items,
        Parent = l_normalPanel.GetItemContent.transform
    })

end

function BattleStatisticsCtrl:SetServerLevel(...)
    local l_data = l_roleInfoMgr.SeverLevelData
    if l_data.serverlevel ~= nil then
        --七日版本 关闭Job经验显示
        self.panel.Text_03.Transform.parent.gameObject:SetActiveEx(false)
        local serverBaseLimit = 0
        local l_rows = TableUtil.GetServerLevelTable().GetTable()
        local l_rowCount = #l_rows
        for i = 1, l_rowCount do
            local l_row = l_rows[i]
            if l_row.ServeLevel == l_data.serverlevel then
                serverBaseLimit = l_row.BaseLevelUpperLimit
            end
        end

        local data_1 = TableUtil.GetGlobalTable().GetRowByName("ExpFixServerLevelLimit").Value
        local data_2 = TableUtil.GetGlobalTable().GetRowByName("ExpFixBaseLevelLimit").Value
        if l_data.basebonus > 0 then
            self.panel.NormalStatePanel.BtnUp.gameObject:SetActiveEx(true)
            self.panel.NormalStatePanel.BtnDown.gameObject:SetActiveEx(false)
            self.panel.BlessStatePanel.BtnUp_1.gameObject:SetActiveEx(true)
            self.panel.BlessStatePanel.BtnDown_1.gameObject:SetActiveEx(false)
            self.panel.Text_02.Transform.parent.gameObject:SetActiveEx(true)
            self.panel.Text_03.Transform.parent.gameObject:SetActiveEx(false)
            self.panel.OtherTips.gameObject:SetActiveEx(true)
            self.panel.OtherTips.LabText = Common.Utils.Lang("SEVER_OTHERTIPS1", data_1, data_2)
        elseif l_data.basebonus == 0 then
            self.panel.NormalStatePanel.BtnUp.gameObject:SetActiveEx(false)
            self.panel.NormalStatePanel.BtnDown.gameObject:SetActiveEx(false)
            self.panel.BlessStatePanel.BtnUp_1.gameObject:SetActiveEx(false)
            self.panel.BlessStatePanel.BtnDown_1.gameObject:SetActiveEx(false)
            self.panel.Text_02.Transform.parent.gameObject:SetActiveEx(false)
            self.panel.Text_03.Transform.parent.gameObject:SetActiveEx(false)
            self.panel.OtherTips.gameObject:SetActiveEx(false)
        else
            self.panel.NormalStatePanel.BtnDown.gameObject:SetActiveEx(true)
            self.panel.NormalStatePanel.BtnUp.gameObject:SetActiveEx(false)
            self.panel.BlessStatePanel.BtnUp_1.gameObject:SetActiveEx(false)
            self.panel.BlessStatePanel.BtnDown_1.gameObject:SetActiveEx(true)
            self.panel.Text_02.Transform.parent.gameObject:SetActiveEx(false)
            self.panel.Text_03.Transform.parent.gameObject:SetActiveEx(false)
            self.panel.OtherTips.gameObject:SetActiveEx(true)
            self.panel.OtherTips.LabText = Common.Utils.Lang("SEVER_OTHERTIPS2", data_1, data_2)
        end

        if tonumber(l_data.nextrefreshtime) <= 0 then
            self.panel.Text_04.gameObject:SetActiveEx(false)
        end

        --玩家等级达到配置的上限 显示
        self.panel.Text_05.gameObject:SetActiveEx(MPlayerInfo.Lv >= serverBaseLimit)
        --玩家Base等级达到上限后 显示服务器真实等级
        self.panel.Text_06.Transform.parent.gameObject:SetActiveEx(MPlayerInfo.Lv >= serverBaseLimit)

        self.panel.Text_01.LabText = l_data.serverlevel
        self.panel.Text_02.LabText = (l_data.basebonus / 100) .. "%"
        self.panel.Text_03.LabText = (l_data.jobbonus / 100) .. "%"
        self.panel.Text_04.LabText = Common.Utils.Lang("SEVER_OPEN_TIME_TEXT", Common.TimeMgr.GetChatTimeFormatStr(l_data.nextrefreshtime))--服务器开放时间设置
        self.panel.Text_05.LabText = Common.Utils.Lang("FULL_LEVEL_TIPS")  --满级Tips提示
        self.panel.Text_06.LabText = l_data.hiddenbaselevel                --服务器真实等级
    end
    LayoutRebuilder.ForceRebuildLayoutImmediate(self.panel.Obj_SeverLevel.transform)
    --self.panel.Obj_SeverLevel.gameObject:SetActiveEx(true)
end

--lua custom scripts end
return BattleStatisticsCtrl