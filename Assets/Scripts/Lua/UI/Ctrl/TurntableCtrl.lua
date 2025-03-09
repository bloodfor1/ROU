--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/TurntablePanel"
require "UI/Template/ItemTemplate"
require "Common/Functions"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua class define
local super = UI.UIBaseCtrl
TurntableCtrl = class("TurntableCtrl", super)
--lua class define end

--lua functions
function TurntableCtrl:ctor()

    super.ctor(self, CtrlNames.Turntable, UILayer.Function, UITweenType.UpAlpha, ActiveType.Exclusive)

end --func end
--next--
function TurntableCtrl:Init()

    self.panel = UI.TurntablePanel.Bind(self)
    super.Init(self)

    self.panel.Button:AddClick(function()
        self:CloseUI()
    end)

    self.actioned = nil

    self.hasActioned = nil

    self.panel.FxRoot.UObj:SetActiveEx(false)

    self.itemTemplates = nil

    self.originalTotalCount = nil

    self.raycaster = self.panel.BG10.gameObject:GetComponent("GraphicRaycaster")
    self.raycaster.enabled = true

    self.itemTemplates = {}
    for i = 1, DataMgr:GetData("TurnTableData").QueryTurnTableRewardCount do
        self.itemTemplates[i] = self:NewTemplate("ItemTemplate", {
            TemplateParent = self.panel.Icon[i].transform,
        })
    end
end --func end
--next--
function TurntableCtrl:Uninit()

    self.actioned = nil
    self.hasActioned = nil
    self.itemTemplates = nil
    self.raycaster = nil

    super.Uninit(self)
    self.panel = nil

end --func end
--next--
function TurntableCtrl:OnActive()
    MLuaClientHelper.PlayFxHelper(self.panel.Table.UObj)
    self:TurntablePanelRefresh()
end --func end
--next--
function TurntableCtrl:OnDeActive()


end --func end
--next--
function TurntableCtrl:Update()


end --func end


--next--
function TurntableCtrl:BindEvents()
    --dont override this function
    self:BindEvent(MgrMgr:GetMgr("TurnTableMgr").EventDispatcher, MgrMgr:GetMgr("TurnTableMgr").ON_RANDOM_AWARD_START, self.Action)
end --func end
--next--
--lua functions end

--lua custom scripts

function TurntableCtrl:TurntablePanelRefresh()
    self.data = MgrMgr:GetMgr("TurnTableMgr").GetUICacheData()
    -- 创建转盘
    self:RefreshRewardGroup()
    self:RefreshOthers()
end --func end

function TurntableCtrl:OnClose()

    if self.actioned then
        return
    end

    self:CloseUI()
end

function TurntableCtrl:CloseUI()

    -- 逻辑还未做完就退出
    if self.actioned then
        MgrMgr:GetMgr("TurnTableMgr").ForceQuit()
    end

    UIMgr:DeActiveUI(UI.CtrlNames.Turntable)
end

function TurntableCtrl:OnStart()

    self.panel.BtnStart.gameObject:SetActiveEx(false)
    self.panel.Circle16.gameObject:SetActiveEx(true)

    MgrMgr:GetMgr("TurnTableMgr").RequestQueryRandomAwardStart(self.uiPanelData.itemId, self.uiPanelData.awardId)
end

function TurntableCtrl:RefreshRewardGroup()
    self:ShowQueryReward()
    self.panel.Number.gameObject:SetActiveEx(true)
    if self.originalTotalCount == nil then
        self.originalTotalCount = Data.BagModel:GetCoinOrPropNumById(self.uiPanelData.itemId)
    end

    self.panel.Number.LabText = tostring(Data.BagModel:GetCoinOrPropNumById(self.uiPanelData.itemId)) .. "/" .. tostring(self.originalTotalCount)
end

function TurntableCtrl:ShowQueryReward()
    local l_ret = self:GetRewardList()
    for i, v in ipairs(self.itemTemplates) do
        v:SetData({ ID = l_ret[i], IsShowCount = false })
    end
end

function TurntableCtrl:GetRewardList()
    local l_ret = {}
    local l_rewardConfigs = DataMgr:GetData("TurnTableData").GetTickyRewardsPreview(self.uiPanelData.awardId)
    for i = 1, DataMgr:GetData("TurnTableData").QueryTurnTableRewardCount do
        l_ret[i] = l_rewardConfigs[i][1]
    end

    return l_ret
end

function TurntableCtrl:RefreshOthers()

    -- 还未执行过
    if not self.hasActioned then
        self.panel.BtnStart.gameObject:SetActiveEx(true)
        self.panel.BtnStart:AddClick(function()
            self:OnStart()
        end)
    else
        -- 已经执行过
        self.panel.BtnStart.gameObject:SetActiveEx(false)
    end
end

function TurntableCtrl:FindIndex(itemId, itemCount)

    for i, v in ipairs(self.itemTemplates) do
        if v.propInfo.propId == itemId and v.count then
            return i
        end
    end
end

function TurntableCtrl:Action(itemId, itemCount)

    if self.actioned then
        return
    end

    self.actioned = true
    local l_curveCom = self.panel.Arrow10.UObj:GetComponent("UITurnTableAnimationCurve")
    self.raycaster.enabled = false

    local l_anglePart = 360 / DataMgr:GetData("TurnTableData").QueryTurnTableRewardCount
    local l_index = self:FindIndex(itemId, itemCount)
    local l_angle = l_anglePart * (l_index - 1)

    self.panel.FxRoot.UObj:SetActiveEx(true)
    self.panel.FxRoot.transform.localPosition = Vector3.New(0, 10000, 0)
    MLuaClientHelper.PlayFxHelper(self.panel.halo.UObj)

    MgrMgr:GetMgr("TurnTableMgr").ActionRotate({
        curveCom = l_curveCom,
        targetAngle = l_angle,
        callback = function()
            self:OnRotateFinished(l_index)
        end
    })
end

function TurntableCtrl:OnRotateFinished(index)
    if self.panel == nil then
        return
    end

    local l_com = self.panel.Icon[index]
    self.panel.FxRoot.transform:SetParent(self.panel.BG10.transform)
    self.panel.FxRoot.transform:SetSiblingIndex(1)
    self.panel.FxRoot.transform:SetLocalScale(1.3, 1.3, 1)
    self.panel.FxRoot.transform.localPosition = l_com.transform.localPosition
    self.panel.FxRoot.UObj:SetActiveEx(true)
    self.actioned = false
    self.raycaster.enabled = true
    self.cacheSequence = nil
    if Data.BagModel:GetCoinOrPropNumById(self.data.itemId) > 0 then
        self:TurntablePanelRefresh()
    end
end


--lua custom scripts end
return TurntableCtrl