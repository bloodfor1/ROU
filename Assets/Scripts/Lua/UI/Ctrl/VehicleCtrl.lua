--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/VehiclePanel"

--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua class define
local super = UI.UIBaseCtrl
VehicleCtrl = class("VehicleCtrl", super)
--lua class define end

local Mgr = MgrMgr:GetMgr("VehicleMgr")

--lua functions
function VehicleCtrl:ctor()
    super.ctor(self, CtrlNames.Vehicle, UILayer.Normal)
    self.cacheGrade = EUICacheLv.VeryLow
    self.speedUpCd = 0
    self.isFlyGray = false
end --func end

--next--
function VehicleCtrl:Init()
    self.fadeAction = nil
    self.panel = UI.VehiclePanel.Bind(self)
    super.Init(self)

    self.panel.ImSpeedUpCD.Img.fillAmount = 0
    self.panel.TxSpeedUpCD.LabText = ""

    self.panel.BtRide:AddClick(function()
        self:OnClickRideVehicle()
    end)
    self.panel.BtBattleRide:AddClick(function()
        self:OnClickRideBattleVehicle()
    end)

    local BtFlyUpListener = self.panel.BtFlyUp.gameObject:GetComponent("MLuaUICom").Listener
    BtFlyUpListener.onDown = function()
        if self.isFlyGray then
            return
        end
        local player = MEntityMgr.PlayerEntity
        if player.IsFly then
            player.VehicleCtrlComp:Fly(1)
        end
    end
    BtFlyUpListener.onUp = function()
        if self.isFlyGray then
            return
        end
        local player = MEntityMgr.PlayerEntity
        if player.IsFly then
            player.VehicleCtrlComp:Fly(0)
        end
    end

    local BtFlyDownListener = self.panel.BtFlyDown.gameObject:GetComponent("MLuaUICom").Listener
    BtFlyDownListener.onDown = function()
        if self.isFlyGray then
            return
        end
        local player = MEntityMgr.PlayerEntity
        if player.IsFly then
            player.VehicleCtrlComp:Fly(-1)
        end
    end
    BtFlyDownListener.onUp = function()
        if self.isFlyGray then
            return
        end
        local player = MEntityMgr.PlayerEntity
        if player.IsFly then
            player.VehicleCtrlComp:Fly(0)
        end
    end

    self.panel.BtSpeedUp:AddClick(function()
        if self.isFlyGray or self.speedUpCd > 0 then
            return
        end
        local player = MEntityMgr.PlayerEntity
        if not MLuaCommonHelper.IsNull(player) and player.IsFly then
            Mgr:RequestAccelerateVehicle()
        end
    end)

    self.init_x = self.panel.OperatePanel.RectTransform.anchoredPosition.x or -120
end --func end

function VehicleCtrl:OnClickRideBattleVehicle( ... )
    if not self:CheckEquipVehicle(true) then return end
    Mgr.RequestTakeVehicle(not MEntityMgr.PlayerEntity.IsRideBattleVehicle,true)
    --红点处理
    if not MEntityMgr.PlayerEntity.IsRideBattleVehicle then 
        PlayerPrefs.SetInt(Common.Functions.GetPlayerPrefsKey(MgrMgr:GetMgr("VehicleMgr").IsGetOnBattleVehicle),1)
        MgrMgr:GetMgr("WeakGuideMgr").ShowRedSign(MgrMgr:GetMgr("WeakGuideMgr").eSignEventName.BattleVehicle,false)
    end
end

function VehicleCtrl:OnClickRideVehicle( ... )
    if MEntityMgr.PlayerEntity.IsRideVehicle then
        Mgr.RequestTakeVehicle(false,false)
        return
    end
    local confirmFunc = function ()
        if not self:CheckEquipVehicle(false) then return end
        Mgr.RequestTakeVehicle(true,false)

        if not MEntityMgr.PlayerEntity.IsRideVehicle then
            PlayerPrefs.SetInt(Common.Functions.GetPlayerPrefsKey(MgrMgr:GetMgr("VehicleMgr").IsGetOnVehicle),1)
            MgrMgr:GetMgr("WeakGuideMgr").ShowRedSign(MgrMgr:GetMgr("WeakGuideMgr").eSignEventName.Vehicle,false)
        end
    end
    if MEntityMgr.PlayerEntity.IsRideBattleVehicle then
        CommonUI.Dialog.ShowOKDlg(true, nil,Lang("REMOVE_BATTLE_BIRD"),confirmFunc,nil,4,"BattleVehicle")
    else
        confirmFunc()
    end
end

function VehicleCtrl:CheckEquipVehicle(isBattleVehicle)
    local l_openSystemMgr=MgrMgr:GetMgr("OpenSystemMgr")
    if not l_openSystemMgr.IsSystemOpen(l_openSystemMgr.eSystemId.Vehicle) then
        local l_tableInfo= TableUtil.GetOpenSystemTable().GetRowById(l_openSystemMgr.eSystemId.Vehicle)
        if l_tableInfo~=nil then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(StringEx.Format(Lang("LEVEL_NOTENOUGH"),l_tableInfo.BaseLevel))
        end
        return false
    end

    if MEntityMgr.PlayerEntity == nil then
        return false
    end

    if not isBattleVehicle then
        if MgrMgr:GetMgr("VehicleInfoMgr").GetUseingVehicle()==0 then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("NO_EXIST_CANUSE_VEHICLE"))
            return false
        end
    end
    return true
end

--next--
function VehicleCtrl:Uninit()
    self:ClearFadeAction()
    self.speedUpCd = 0
    self.isFlyGray = false

    super.Uninit(self)
    self.panel = nil
end --func end

--next--
function VehicleCtrl:OnActive()
    self:RefreshVehicle()
    self:VehiclePanelRefresh()
    MgrMgr:GetMgr("WeakGuideMgr").AddRedSignEvent(MgrMgr:GetMgr("WeakGuideMgr").eSignEventName.Vehicle,function (selfa,isShow)
        self.panel.VehiclePrompt.gameObject:SetActiveEx(isShow)
    end,self)
    MgrMgr:GetMgr("WeakGuideMgr").AddRedSignEvent(MgrMgr:GetMgr("WeakGuideMgr").eSignEventName.BattleVehicle,function (selfa,isShow)
        self.panel.BattleVehiclePrompt.gameObject:SetActiveEx(isShow)
    end,self)
end --func end

--next--
function VehicleCtrl:OnDeActive()
    self:FadeAction(true, MgrMgr:GetMgr("MainUIMgr").ANI_TIME)
    self.panel.OperatePanel.gameObject:SetActiveEx(false)
    MgrMgr:GetMgr("WeakGuideMgr").RemoveEvent(MgrMgr:GetMgr("WeakGuideMgr").eSignEventName.Vehicle, self)
    MgrMgr:GetMgr("WeakGuideMgr").RemoveEvent(MgrMgr:GetMgr("WeakGuideMgr").eSignEventName.BattleVehicle, self)
end --func end

--next--
function VehicleCtrl:Update()
    if self.speedUpCd > 0 then
        self.speedUpCd = self.speedUpCd - UnityEngine.Time.deltaTime
        if self.speedUpCd <= 0 then
            self.speedUpCd = 0
            self.panel.ImSpeedUpCD.Img.fillAmount = 0
            self.panel.TxSpeedUpCD.LabText = ""
            return
        end
        self.panel.ImSpeedUpCD.Img.fillAmount = self.speedUpCd / self.speedUpCdOrigin
        self.panel.TxSpeedUpCD.LabText = tostring(math.ceil(self.speedUpCd))
    end
end --func end
function VehicleCtrl:RefreshBtRide()
    local l_openSystemMgr=MgrMgr:GetMgr("OpenSystemMgr")
    if l_openSystemMgr.IsSystemOpen(l_openSystemMgr.eSystemId.VehicleAbility) then
        self.panel.BtRide:SetActiveEx(true)
    else
        self.panel.BtRide:SetActiveEx(false)
    end

    if MPlayerInfo.ProfessionId <= 0 then
        return false
    end

    --如果该职业让使用战斗坐骑 显示
    local l_professionTableInfo=TableUtil.GetProfessionTable().GetRowById(MPlayerInfo.ProfessionId)
    if l_professionTableInfo==nil then
        logError("ProfessionTable表没有配，id："..tostring(MPlayerInfo.ProfessionId))
        return false
    end

    local showSkillSlots = string.ro_split(l_professionTableInfo.BagShowSkillSlot, "|")
    local isShow = false
    for i = 1, table.maxn(showSkillSlots) do
        if tonumber(showSkillSlots[i]) == Data.BagModel.WeapType.BattleHorse then
            isShow = true
        end
    end
    local l_battleVehicleInfo = Data.BagApi:GetItemByTypeSlot(GameEnum.EBagContainerType.Equip, EquipPos.BATTLE_HORSE + 1)
    local l_hasBattleVehicle = l_battleVehicleInfo~=nil
    if l_openSystemMgr.IsSystemOpen(l_openSystemMgr.eSystemId.Vehicle) and isShow and l_hasBattleVehicle then
        self.panel.BtBattleRide:SetActiveEx(true)
    else
        self.panel.BtBattleRide:SetActiveEx(false)
    end
end

--next--
function VehicleCtrl:BindEvents()
    self:BindEvent(Data.PlayerInfoModel.BASELV,Data.onDataChange, function ()
        self:VehiclePanelRefresh()
    end)
    local l_openSysMgr=MgrMgr:GetMgr("OpenSystemMgr")
    self:BindEvent(l_openSysMgr.EventDispatcher,l_openSysMgr.OpenSystemUpdate, function(self)
        self:VehiclePanelRefresh()
    end)

    local l_mainUIMgr = MgrMgr:GetMgr("MainUIMgr")

    self:BindEvent(l_mainUIMgr.EventDispatcher, l_mainUIMgr.FadeVehicleEvent, function(self,isOut,time)
        self:FadeAction(isOut,time)
    end)
    local l_refitTrolleyMgr = MgrMgr:GetMgr("RefitTrolleyMgr")
    self:BindEvent(l_refitTrolleyMgr.EventDispatcher, l_refitTrolleyMgr.ON_USE_TROLLEY, function(self,isOut,time)
        self:RefreshBtRide()
    end)
    local l_vehicleInfoMgr = MgrMgr:GetMgr("VehicleInfoMgr")
    self:BindEvent(l_vehicleInfoMgr.EventDispatcher, l_vehicleInfoMgr.EventType.OnVehicleUseStateChanged, function()
        self:RefreshBtRide()
    end)

end --func end
--next--
--lua functions end

--lua custom scripts
function VehicleCtrl:VehiclePanelRefresh()
    self:RefreshBtRide()
end

function VehicleCtrl:RefreshVehicle()
    if self.panel == nil or MEntityMgr.PlayerEntity == nil then
        return
    end
    local isRideVehicle = (Mgr.RideVehicleItemId ~= 0)
    local isFlyVehicle = (isRideVehicle and Mgr.RideVehicleRow.VehicleType == 1)
    self:FadeAction(not isFlyVehicle, MgrMgr:GetMgr("MainUIMgr").ANI_TIME)
    self.panel.OperatePanel.gameObject:SetActiveEx(isFlyVehicle)
    if isFlyVehicle then  --如果切换时时功能按钮界面 则做一次切换
        MgrMgr:GetMgr("MainUIMgr").SwitchUIToSpecial()
    end
    -- 副驾或气球，按钮置灰
    local isGray = isFlyVehicle and (MEntityMgr.PlayerEntity.IsPassenger or Mgr.RideVehicleRow.Auto)
    self.isFlyGray = isGray
    self.panel.BtFlyUp:SetGray(isGray)
    self.panel.BtFlyDown:SetGray(isGray)
    self.panel.BtSpeedUp:SetGray(isGray)
end

function VehicleCtrl:OnAccelerateVehicle()
    self.speedUpCdOrigin = Mgr.RideVehicleRow.Cd
    self.speedUpCd = self.speedUpCdOrigin
    self.panel.ImSpeedUpCD.Img.fillAmount = 1
    self.panel.TxSpeedUpCD.LabText = tostring(self.speedUpCd)
end

--淡入淡出动画
function VehicleCtrl:FadeAction(isOut,time)

    self.panel.OperatePanel.gameObject:SetActiveEx(true)

    self:ClearFadeAction()
    self.fadeAction = DOTween.Sequence()

    local lOffseX = self.init_x
    local lAlpha = 1
    if isOut then
        lOffseX = self.init_x + 100
        lAlpha = 0
    end
    self.panel.OperatePanel.gameObject:GetComponent("CanvasGroup").blocksRaycasts = not isOut
    local l_act_move = self.panel.OperatePanel.RectTransform:DOAnchorPosX(lOffseX,time)
    local l_act_fade = self.panel.OperatePanel.gameObject:GetComponent("CanvasGroup"):DOFade(lAlpha,0.1)
end
--淡入淡出动画清理
function VehicleCtrl:ClearFadeAction()
    if self.fadeAction ~= nil then
        self.fadeAction:Kill(true)
        self.fadeAction = nil
    end
end
return VehicleCtrl
--lua custom scripts end
