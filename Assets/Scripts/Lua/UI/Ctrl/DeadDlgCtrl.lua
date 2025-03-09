--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/DeadDlgPanel"
--require "Data/Model/DeadDlgModel"

--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua class define
local super = UI.UIBaseCtrl
DeadDlgCtrl = class("DeadDlgCtrl", super)
--lua class define end

--lua functions
function DeadDlgCtrl:ctor()

    super.ctor(self, CtrlNames.DeadDlg, UILayer.Function, UITweenType.Left, ActiveType.Exclusive)

    self.GroupMaskType = GroupMaskType.None
    self.IsGroup = true

end --func end
--next--
function DeadDlgCtrl:Init()

    self.panel = UI.DeadDlgPanel.Bind(self)
    super.Init(self)
    self.CanRevive = true
    self.CantReviveTips = nil
    self.panel.BtnConfirm:AddClick(function()
        self:ApplyRevive(ReviveType.Revive_Self)
    end)
    self.panel.Btn_Resurrection:AddClickWithLuaSelf(self.ReviveInSitu, self)
    self.panel.Btn_Monthcard:AddClick(self.OnClickQuestion)
    self.mgr = MgrMgr:GetMgr("DeadDlgMgr")
    self.data = DataMgr:GetData("DeadDlgData")
    --self:InitDeathGuild()
end --func end
--next--
function DeadDlgCtrl:Uninit()

    super.Uninit(self)
    self.panel = nil

end --func end

--next--
function DeadDlgCtrl:OnActive()

    self.panel.Bubble:SetActiveEx(false)

    --现有版本注释这个Txt的显示 Mx
    --self.panel.TxtKiller.LabText = Data.DeadDlgModel:getTxtKiller()
    self.panel.TxtLoss.LabText = Lang("DEAD_DLG_KILLER_UNKNOWN")--Data.DeadDlgModel:getTxtLoss()
    --log(self.data.GetForbiddenFlag(), self.data.GetCoolDownTime(), self.data.GetCoolDownTime() > 0, self.data.GetForbiddenFlag() and self.data.GetCoolDownTime() > 0)
    self:OnForbiddenRevive(self.data.GetForbiddenFlag())
    self:setCoolDownTime(self.data.GetCoolDownTime())
    self:OnHatorChange(self.data.GetHatorId())

    MLuaUIListener.Get(self.panel.QuestionBtn.gameObject)
    self.panel.QuestionBtn.Listener.onClick = function(go, eventData)
        MgrMgr:GetMgr("TipsMgr").ShowQuestionTip(Lang("REVIVE_IN_DUNGEONS_TIPS"), eventData)
    end
    self.panel.BtnInfo:SetActiveEx(true)
end --func end

--next--
function DeadDlgCtrl:OnDeActive()

    self.panel.Bubble.UObj:SetActiveEx(false)
end --func end
--next--
function DeadDlgCtrl:Update()
    if MEntityMgr.PlayerEntity ~= nil and not MEntityMgr.PlayerEntity.IsDead then
        MgrMgr:GetMgr("DeadDlgMgr").CloseDeadDlg()
    end
end --func end

--next--
function DeadDlgCtrl:BindEvents()
    self:BindEvent(MgrMgr:GetMgr("DeadDlgMgr").EventDispatcher, DataMgr:GetData("DeadDlgData").DEAD_COOL_TIME_CHANGE, self.setCoolDownTime)
    self:BindEvent(MgrMgr:GetMgr("DeadDlgMgr").EventDispatcher, DataMgr:GetData("DeadDlgData").DEAD_HATORID_CHANGE, self.OnHatorChange)
    self:BindEvent(MgrMgr:GetMgr("DeadDlgMgr").EventDispatcher, DataMgr:GetData("DeadDlgData").DEAD_FABIDDEN_REVIVE, self.OnForbiddenRevive)
end --func end
--next--
--lua functions end

--lua custom scripts
function DeadDlgCtrl:setCoolDownTime(time)
    --log("DeadDlgCtrl:setCoolDownTime(time)",time)
    if not self.panel then
        return
    end

    if not self.data.GetForbiddenFlag() then
        self:SetReviveGray(time > 0, self.data.CANT_REVIVE_TIPS.CD)
    end
    local stageEnum = StageMgr:GetCurStageEnum()
    if stageEnum == MStageEnum.Ring then
        self.panel.DeadTip.LabText = Lang("ARENA_DEAD_REVIVE_CD_TIP", time)
        self:SetReviveGray(true, self.data.CANT_REVIVE_TIPS.CD)
    else
        local sceneData = TableUtil.GetSceneTable().GetRowByID(MScene.SceneID)
        if time > 0 then
            if self:IsRecordPoin(sceneData.ReviveType) then
                self.panel.DeadTip.LabText = Lang("DEAD_REVIVE_CD_TIP", time)
            else
                self.panel.DeadTip.LabText = Lang("ARENA_DEAD_REVIVE_CD_TIP", time)
            end
        else
            if self:IsRecordPoin(sceneData.ReviveType) then
                self.panel.DeadTip.LabText = Lang("DEAD_REVIVE_TIP")
            else
                self.panel.DeadTip.LabText = Lang("ARENA_DEAD_REVIVE_TIP")
            end
        end
    end
    ---特判塔防剩余复活数为零置灰
    if MPlayerInfo.PlayerDungeonsInfo.DungeonType == MgrMgr:GetMgr("DungeonMgr").DungeonType.TowerDefenseSingle or
            MPlayerInfo.PlayerDungeonsInfo.DungeonType == MgrMgr:GetMgr("DungeonMgr").DungeonType.TowerDefenseDouble then
        if MgrMgr:GetMgr("TowerDefenseMgr").IsHaveNoneLife() then
            self:SetReviveGray(true, self.data.CANT_REVIVE_TIPS.NO_TIMES)
        end
    end
    self:SetResurrectionBtn()
end

--[[
    @Description: 仇恨变化
    @Date: 2018/7/18
    @Param: [args]
    @Return
--]]
function DeadDlgCtrl:OnHatorChange(hatorId)
    if not self.panel then
        return
    end
    if MPlayerDungeonsInfo.InDungeon then
        local hasHator = hatorId and tonumber(hatorId) > 0 or false
        self.panel.TxtLoss.gameObject:SetActiveEx(true)
        if hasHator then
            self.panel.TxtLoss.LabText = Lang("DEAD_IN_DUNGEONS_WITHHATOR", self.data.GetKillerName())
        else
            self.panel.TxtLoss.LabText = Lang("DEAD_IN_DUNGEONS")
        end
        self.panel.QuestionBtn.gameObject:SetActiveEx(hasHator)
        if not self.data.GetForbiddenFlag() and self.data.GetCoolDownTime() == 0 then
            self:SetReviveGray(hasHator, self.data.CANT_REVIVE_TIPS.HATOR)
        end
    else
        self.panel.QuestionBtn.gameObject:SetActiveEx(false)
        if not self.data.GetForbiddenFlag() then
            self:SetReviveGray(false)
        end
    end
end

--==============================--
--@Description: 禁止复活
--@Date: 2018/9/28
--@Param: [args]
--@Return:
--==============================--
function DeadDlgCtrl:OnForbiddenRevive(flag)
    if not self.panel then
        return
    end
    self:SetReviveGray(flag, self.data.CANT_REVIVE_TIPS.SCENE_LIMIT)
end

function DeadDlgCtrl:OnClickQuestion()
    local l_limitBuyMgr = MgrMgr:GetMgr("LimitBuyMgr")
    local limitData = l_limitBuyMgr.GetLimitDataByKey(l_limitBuyMgr.g_limitType.ReviveInSitu, "1")
    local l_content = StringEx.Format(TableUtil.GetMonthCardTable().GetRowByMonthCardId(1010).MonthCardDes, limitData.limt)
    MgrMgr:GetMgr("TipsMgr").ShowExplainPanelTips({
        content = l_content,
        alignment = UnityEngine.TextAnchor.UpperCenter,
        pos = {
            x = 640,
            y = -76,
        },
        width = 190,
        fontSize = 16,
    })
end

function DeadDlgCtrl:ApplyRevive(type)
    if not self.CanRevive then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang(self.CantReviveTips))
        return
    end
    if type == nil then
        type = ReviveType.Revive_Self
    end
    if MgrMgr:GetMgr("ChatRoomMgr").Room:Has() then
        local l_txt = Lang("ChatRoom_Dead_Hint")--复活后，您将离开聊天室，要继续吗？
        CommonUI.Dialog.ShowYesNoDlg(true, nil, l_txt, function()
            MgrMgr:GetMgr("DeadDlgMgr").RequestRevive(type)
        end, nil, nil, 4)
        return
    end
    MgrMgr:GetMgr("DeadDlgMgr").RequestRevive(type)
end

function DeadDlgCtrl:IsVipScene(type)
    if type == GameEnum.ESceneType.Hall or type == GameEnum.ESceneType.Wild then
        return true
    end
    return false
end

function DeadDlgCtrl:SetReviveGray(value, type)
    --log("SetReviveGray",value,type)
    self.panel.BtnConfirm:SetGray(value)
    self.CanRevive = not value
    self.CantReviveTips = value and type or nil
end

function DeadDlgCtrl:SetResurrectionBtn()
    self.panel.Btn_Resurrection:SetActiveEx(false)
    self.panel.Btn_Monthcard:SetActiveEx(false)
    if stageEnum == MStageEnum.Ring then
        return
    end
    if self.data.GetCoolDownTime() > 0 then
        return
    end
    local sceneData = TableUtil.GetSceneTable().GetRowByID(MScene.SceneID)
    local isVip = MgrMgr:GetMgr("MonthCardMgr").GetIsBuyMonthCard()
    if sceneData.ReviveType == GameEnum.EReviveType.Hunt then
        self.panel.Btn_Monthcard:SetActiveEx(isVip)
        self.panel.Btn_Resurrection:SetActiveEx(true)
        local leftcount = MgrMgr:GetMgr("LimitBuyMgr").GetItemCanBuyCount(MgrMgr:GetMgr("LimitBuyMgr").g_limitType.ReviveInSitu, 1)
        if isVip and leftcount > 0 then
            self.panel.ReviveTimesTxt.LabText = StringEx.Format(Common.Utils.Lang("REVIVE_IN_SITU"), leftcount)
        else
            self.panel.ReviveTimesTxt.LabText = Common.Utils.Lang("REVIVE_IN_SITU_NONE_TIMES")
            self.panel.Btn_Resurrection:SetGray(self.data.ReviveInSituTimesMax())
        end
        return
    end

    if self:IsVipScene(sceneData.SceneType) and isVip then
        self.panel.Btn_Monthcard:SetActiveEx(true)
        self.panel.Btn_Resurrection:SetActiveEx(true)
        local leftcount = MgrMgr:GetMgr("LimitBuyMgr").GetItemCanBuyCount(MgrMgr:GetMgr("LimitBuyMgr").g_limitType.ReviveInSitu, 1)
        self.panel.ReviveTimesTxt.LabText = StringEx.Format(Common.Utils.Lang("REVIVE_IN_SITU"), leftcount)
        self.panel.Btn_Resurrection:SetGray(leftcount <= 0)
        return
    end
end

function DeadDlgCtrl:ReviveInSitu()
    local sceneData = TableUtil.GetSceneTable().GetRowByID(MScene.SceneID)
    local isVip = MgrMgr:GetMgr("MonthCardMgr").GetIsBuyMonthCard()
    if sceneData.ReviveType == GameEnum.EReviveType.Hunt then
        if isVip and MgrMgr:GetMgr("LimitBuyMgr").GetItemCanBuyCount(MgrMgr:GetMgr("LimitBuyMgr").g_limitType.ReviveInSitu, 1) > 0 then
            self:ReviveUseVipTimes()
        else
            if self.data.ReviveInSituTimesMax() then
                MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("REVIVE_IN_SITU_TIMES_LIMIT_MAX"))
                return
            end
            local itemData = Data.BagApi:CreateLocalItemData(MGlobalConfig:GetInt("ReviveInsituItem"))
            ---@type ConsumeDlgItemData
            local consume = {}
            consume.ID = itemData.TID
            consume.IsShowCount = false
            consume.IsShowRequire = true
            consume.RequireCount = self.data.GetReviveItemNum()
            CommonUI.Dialog.ShowConsumeDlg(Lang("REVIVE_IN_SITU_NONE_TIMES"), Lang("REVIVE_IN_SITU_USE_ITEM_TIPS", itemData.ItemConfig.ItemName), function()
                self:ApplyRevive(ReviveType.Revive_VIP)
            end, nil, { consume }, 0)
        end
    elseif isVip and self:IsVipScene(sceneData.SceneType) then
        if MgrMgr:GetMgr("LimitBuyMgr").GetItemCanBuyCount(MgrMgr:GetMgr("LimitBuyMgr").g_limitType.ReviveInSitu, 1) == 0 then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("REVIVE_IN_SITU_NO_TIMES"))
            return
        end
        self:ReviveUseVipTimes()
    end
end

function DeadDlgCtrl:ReviveUseVipTimes()
    local l_txt = Common.Utils.Lang("TIPS_YES_NO_VIP_REVIVE")
    CommonUI.Dialog.ShowYesNoDlg(true, nil, l_txt, function()
        self:ApplyRevive(ReviveType.Revive_VIP)
    end, nil, nil, 4, "VipReviveInSitu")
end

function DeadDlgCtrl:IsRecordPoin(reviveType)
    if reviveType == GameEnum.EReviveType.RecordPoin or reviveType == GameEnum.EReviveType.Hunt then
        return true
    end
    return false
end

--lua custom scripts end


return DeadDlgCtrl
