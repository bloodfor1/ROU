--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseHandler"
require "UI/Panel/QuickBattleLogPanelPanel"
require "UI/Template/ItemTemplate"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua fields
local super = UI.UIBaseHandler
--next--
--lua fields end

--lua class define
QuickBattleLogPanelHandler = class("QuickBattleLogPanelHandler", super)
--lua class define end

--lua functions
function QuickBattleLogPanelHandler:ctor()
	
	super.ctor(self, HandlerNames.QuickBattleLogPanel, 0)
	
end --func end
--next--
function QuickBattleLogPanelHandler:Init()
	
	self.panel = UI.QuickBattleLogPanelPanel.Bind(self)
	super.Init(self)
    self.panel.BtnOpenBattleDetail:AddClick(function()
        UIMgr:ActiveUI(UI.CtrlNames.BattleStatistics)
    end)
    self.BattleStatisticsItemPool = self:NewTemplatePool({
        UITemplateClass = UITemplate.ItemTemplate,
    })
end --func end
--next--
function QuickBattleLogPanelHandler:Uninit()
	
	super.Uninit(self)
	self.panel = nil
end --func end
--next--
function QuickBattleLogPanelHandler:OnActive()

    MgrMgr:GetMgr("BattleStatisticsMgr").BattleRevenueReq()
    if self.updateBattleInfoTimer ~= nil then
        self:StopUITimer(self.updateBattleInfoTimer)
        self.updateBattleInfoTimer = nil
    end
    self.updateBattleInfoTimer = self:NewUITimer(function()
        if self.panel.BattleLogPanel.gameObject.activeSelf then
            MgrMgr:GetMgr("BattleStatisticsMgr").BattleRevenueReq()
        end
    end, 60, -1)
    self.updateBattleInfoTimer:Start()
end --func end
--next--
function QuickBattleLogPanelHandler:OnDeActive()

    if self.updateBattleInfoTimer ~= nil then
        self:StopUITimer(self.updateBattleInfoTimer)
        self.updateBattleInfoTimer = nil
    end
end --func end
--next--
function QuickBattleLogPanelHandler:Update()
	

end --func end
--next--
function QuickBattleLogPanelHandler:Refresh()
	
	
end --func end
--next--
function QuickBattleLogPanelHandler:OnLogout()
	
	
end --func end
--next--
function QuickBattleLogPanelHandler:Show()
	
	if not super.Show(self) then return end
	
end --func end
--next--
function QuickBattleLogPanelHandler:Hide()
	
	if not super.Hide(self) then return end
	
end --func end
--next--
function QuickBattleLogPanelHandler:BindEvents()
    local l_battleStatisticsMgr = MgrMgr:GetMgr("BattleStatisticsMgr")
    self:BindEvent(l_battleStatisticsMgr.EventDispatcher,l_battleStatisticsMgr.OnRefreshSimpleBattleRevenue, function(_, data)
        self:RefreshBattleLog(data)
    end)

end --func end

--next--
--lua functions end

--lua custom scripts
function QuickBattleLogPanelHandler:RefreshBattleLog(info)

    self.panel.TxtBattleTime.LabText = StringEx.Format("{0:F0}", TimeSpan.FromMilliseconds(info.FightTime).TotalMinutes) .. Lang("MINUTE")
    self.panel.TxtBaseExp.LabText = tostring(info.BaseExp)
    self.panel.TxtJobExp.LabText = tostring(info.JobExp)
    --将魔物硬币置于最前
    local l_Items = {}
    for _, v in pairs(info.Items) do
        if v.ID == MgrMgr:GetMgr("PropMgr").l_virProp.MonsterCoin then
            table.insert(l_Items, v)
            break
        end
    end
    for _, v in pairs(info.Items) do
        if v.ID ~= MgrMgr:GetMgr("PropMgr").l_virProp.MonsterCoin then
            table.insert(l_Items, v)
        end
    end

    self.BattleStatisticsItemPool:ShowTemplates({
        Datas = l_Items,
        Parent = self.panel.ItemContent.transform
    })
end
--lua custom scripts end
return QuickBattleLogPanelHandler