--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/CapraCardPanel"
--lua requires end

--lua model
module("UI", package.seeall)

--lua model end

--lua fields
local super = UI.UIBaseCtrl
--lua fields end

--lua class define
CapraCardCtrl = class("CapraCardCtrl", super)
--lua class define end

--lua functions
function CapraCardCtrl:ctor()
    super.ctor(self, CtrlNames.CapraCard, UILayer.Tips, nil, ActiveType.Standalone)
end --func end
--next--
function CapraCardCtrl:Init()
    ---@type CapraCardPanel
    self.panel = UI.CapraCardPanel.Bind(self)
    super.Init(self)
    ---@type ModuleMgr.CapraCardMgr
    self.mgr = MgrMgr:GetMgr("CapraCardMgr")
    self:initBaseInfo()

end --func end
--next--
function CapraCardCtrl:Uninit()

    super.Uninit(self)
    self.panel = nil

end --func end
--next--
function CapraCardCtrl:OnActive()
    if self.uiPanelData ~= nil then
        self.itemData = self.uiPanelData.itemData
    end
    self:tryShowPanel()
end --func end
--next--
function CapraCardCtrl:OnDeActive()
    self.itemData = nil
    self:clearRemainTimer()
end --func end
--next--
function CapraCardCtrl:Update()


end --func end
--next--
function CapraCardCtrl:BindEvents()
    local gameEventMgr = MgrMgr:GetMgr("GameEventMgr")
    self:BindEvent(gameEventMgr.l_eventDispatcher, gameEventMgr.OnBagUpdate, function(self, itemUpdateDataList)
        if nil == itemUpdateDataList then
            return
        end

        for i = 1, #itemUpdateDataList do
            local singleUpdateData = itemUpdateDataList[i]
            ---@type ItemData
            local l_newItemData = singleUpdateData.NewItem
            if l_newItemData ~= nil and self.itemData ~= nil then
                if l_newItemData.UID == self.itemData.UID then
                    self.itemData = l_newItemData
                    self:tryShowPanel()
                end
            end
        end
    end)
end --func end
--next--
--lua functions end

--lua custom scripts
function CapraCardCtrl:startRemainTimer()
    self:clearRemainTimer()
    --不需要更新时间是返回
    if not self.needUpdateTime then
        return
    end
    self.remainTimeTimer = Timer.New(function()
        self:refreshRemainTime()
    end, 1, -1, true)
    self.remainTimeTimer:Start()
end
function CapraCardCtrl:refreshRemainTime()
    if not self:IsActive() then
        return
    end

    local l_remainTime = self.deadlineTime - Common.TimeMgr.GetNowTimestamp()
    local l_timeStr = nil
    self.panel.WidgetRemainingTimeNormal:SetActiveEx(self.needUpdateTime)
    self.panel.WidgetRemainTimeVIP:SetActiveEx(self.needUpdateTime)
    if not self.needUpdateTime then
        return
    end

    if l_remainTime <= 0 then
        l_timeStr = Lang("TimeOut")
    else
        l_timeStr = Common.TimeMgr.GetLeftTimeStrEx(l_remainTime)
    end

    self.panel.Txt_VipCardRemainTime.LabText = l_timeStr
    self.panel.Txt_RemainTime.LabText = l_timeStr
end

function CapraCardCtrl:clearRemainTimer()
    if MLuaCommonHelper.IsNull(self.remainTimeTimer) then
        return
    end
    self.remainTimeTimer:Stop()
    self.remainTimeTimer = nil
end
function CapraCardCtrl:initBaseInfo()
    self.deadlineTime = 0
    ---@type ItemData
    self.itemData = nil
    self.isVipCard = false
    self.isCardInBag = true
    self.privilegePool = self:NewTemplatePool({
        ScrollRect = self.panel.LoopScroll_Privilege.LoopScroll,
        TemplateClassName = "PrivilegeTemplate",
        TemplatePrefab = self.panel.Template_Privilege.gameObject,
    })
    self.panel.Btn_BG:AddClick(function()
        self:Close()
    end, true)
    self.panel.Btn_Explain:AddClick(function()
        local l_content = Lang("CAPRA_CARD_HELP")
        MgrMgr:GetMgr("TipsMgr").ShowExplainPanelTips({
            content = l_content,
            alignment = UnityEngine.TextAnchor.UpperLeft,
            pivot = Vector2.New(0, 1),
            anchoreMin = Vector2.New(0.5, 0.5),
            anchoreMax = Vector2.New(0.5, 0.5),
            downwardAdapt = true,
            overideSort = UI.UILayerSort.Tips + 1,
            relativeLeftPos = {
                canOffset = false,
                screenPos = MUIManager.UICamera:WorldToScreenPoint(self.panel.Obj_ExplainPosMark.Transform.position)
            },
            width = 200,
        })
    end, true)
end

function CapraCardCtrl:tryShowPanel()
    if self.itemData == nil then
        self:Close()
        return
    end

    self.isCardInBag = GameEnum.EBagContainerType.Bag == self.itemData.ContainerType
    self.needUpdateTime = self.itemData.CreateTime > 0
    self.itemValidTime = self.itemData:GetRemainingTime()
    self.deadlineTime = self.itemData:GetExpireTime()
    if self.mgr.IsVIPCapraCard(self.itemData.TID) then
        self:showVipCard(self.itemData)
    else
        self:showNormalCard(self.itemData)
    end

    self:refreshRemainTime()
    self:startRemainTimer()
end
---@param itemData  ItemData
function CapraCardCtrl:showNormalCard(itemData)
    if nil == itemData then
        return
    end

    self.panel.Text_Title.LabText = itemData:GetName()
    self.isVipCard = false
    self.panel.Panel_MembershipCard:SetActiveEx(true)
    self.panel.Panel_VIPCard:SetActiveEx(false)
    local l_maxUseCountPerDay = MGlobalConfig:GetInt("HuiyuankaDayTimes")
    l_totalMaxUseCount = MGlobalConfig:GetInt("HuiyuankaTimes")
    local l_validTip
    if self.isCardInBag then
        l_validTip = Lang("AUTO_VALID")
    else
        l_validTip = Lang("GET_IN_BAG_VALID")
    end
    self.panel.Text_Effective.LabText = l_validTip
    self.panel.Txt_touchNum.LabText = StringEx.Format("{0}/{1}", itemData.CardDayUseCount, l_maxUseCountPerDay)
    self.panel.Txt_rewardRemainNum.LabText = l_totalMaxUseCount - itemData.CardTotalUseCount
end

---@param itemData ItemData
function CapraCardCtrl:showVipCard(itemData)
    if nil == itemData then
        return
    end

    self.panel.Text_Title_VIP.LabText = itemData:GetName()
    self.isVipCard = true
    self.panel.Panel_MembershipCard:SetActiveEx(false)
    self.panel.Panel_VIPCard:SetActiveEx(true)
    self.panel.Label_VipCardLabel:SetActiveEx(self.isCardInBag)
    ---@type ItemData[]
    local l_privilegeDatas = {}
    ---@type MonthCardTable[]
    local l_Table = TableUtil.GetMonthCardTable().GetTable()
    for i = 1, #l_Table do
        local l_monthCardItem = l_Table[i]
        if l_monthCardItem.ShowMonthCardTips ~= 0 then
            table.insert(l_privilegeDatas, {
                deadLineTime = self.deadlineTime,
                openFromBag = self.isCardInBag,
                monthCardItem = l_monthCardItem,
            })
        end
    end

    table.sort(l_privilegeDatas, function(a, b)
        return a.monthCardItem.ShowMonthCardTips < b.monthCardItem.ShowMonthCardTips
    end)

    self.privilegePool:ShowTemplates({ Datas = l_privilegeDatas })
end

--lua custom scripts end
return CapraCardCtrl