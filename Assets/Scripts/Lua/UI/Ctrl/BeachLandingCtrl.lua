--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/BeachLandingPanel"
require "Data.Model.PlayerInfoModel"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua fields
local super = UI.UIBaseCtrl
local dis = 5
local AIM_STATE = { normal = 0, aim = 1, idle = 2 }
local dt = 0.02
--next--
--lua fields end

--lua class define
BeachLandingCtrl = class("BeachLandingCtrl", super)
--lua class define end

--lua functions
function BeachLandingCtrl:ctor()

    super.ctor(self, CtrlNames.BeachLanding, UILayer.Normal, nil, ActiveType.Exclusive)
    self.ForceHidePanelNames = { UI.CtrlNames.MainTargetInfo }
    self.IsIgnoreHideMainGroup=true

    self.overrideSortLayer = UILayerSort.Normal - 6
    self.mgr = MgrMgr:GetMgr("BeachMgr")
    self.dungeonMgr = MgrMgr:GetMgr("DungeonMgr")
    self.skillLearnMgr = MgrMgr:GetMgr("SkillLearningMgr")
end --func end
--next--
function BeachLandingCtrl:Init()

    self.panel = UI.BeachLandingPanel.Bind(self)
    super.Init(self)

    self.startPosition = Vector3.zero
    self.startRotation = Quaternion.identity
    self.xAngle = self.mgr.g_beachStartRotateX
    self.yAngle = 0
    self.beachCameraDelta = self.mgr.g_beachCameraDelta
    self.fov = self.mgr.g_beachFov
    self.horizontalMax = self.mgr.g_horizontalMax
    self.verticalMax = self.mgr.g_verticalMax
    self.screenSize = MUIManager:GetUIScreenSize()

    self.bloods = {}
    self.aimState = AIM_STATE.normal
    self.leftTrans = self.panel.left.RectTransform
    self.rightTrans = self.panel.right.RectTransform
    self.leftOriginPos = self.leftTrans.anchoredPosition
    self.rightOriginPos = self.rightTrans.anchoredPosition
    self.nearClipPlane = MScene.GameCamera.UCam and MScene.GameCamera.UCam.nearClipPlane or 0.3

    MLuaUIListener.Get(self.panel.Control.UObj)
    self.panel.Control.Listener.beginDrag = function(go, ed)
        self:OnBeginDrag(go, ed)
    end
    self.panel.Control.Listener.onDrag = function(go, ed)
        self:OnDraging(go, ed)
    end
    self.panel.Control.Listener.endDrag = function(go, ed)
        self:OnEndDrag(go, ed)
    end
    self:StartBeach()
    self:InitBlood()
end --func end
--next--
function BeachLandingCtrl:Uninit()
    self.bloods = {}
    self.leftTrans = nil
    self.rightTrans = nil
    self.leftOriginPos = nil
    self.rightOriginPos = nil
    super.Uninit(self)
    self.panel = nil

end --func end
--next--
function BeachLandingCtrl:OnActive()
    local ui = MgrMgr:GetMgr("SkillControllerMgr").GetSkillController()
    if ui and ui.IsShowing and ui.MObj then
        ui.MObj.Trans:SetAsLastSibling()
    end
    local mainui = UIMgr:GetUI(UI.CtrlNames.Main)
    if mainui then
        mainui.uObj.transform:SetAsLastSibling()
    end
    MgrMgr:GetMgr("SkillControllerMgr").ShowSkillController()
    UIMgr:ShowUI(UI.CtrlNames.Main)

    local skillCount = DataMgr:GetData("SkillData").GetSlotSkillCount()
    local transList = MListPoolRectTransformList.Get()
    local j = 0
    for i, v in ipairs(self.panel.slotBtn) do
        if v.gameObject.activeSelf and j < skillCount then
            transList:Add(v.RectTransform)
            j = j + 1
        end
    end
    local slotShowInfo = SlotShowInfo.New()
    slotShowInfo.Count = transList.Count
    slotShowInfo.ShowSwap = false
    slotShowInfo.ShowAnim = false
    slotShowInfo.slotTrans = transList
    MEventMgr:LuaFireGlobalEvent(MEventType.MGlobalEvent_SetSlotShowInfo, slotShowInfo)
    self.xAngle = self.mgr.g_beachStartRotateX
    self.yAngle = 0
    self.panel.blood:SetActiveEx(false)
    self.panel.SkillBtns:SetActiveEx(false)
    self:RefreshMonsterPrompt()
end --func end
--next--
function BeachLandingCtrl:OnDeActive()
    self.xAngle = self.mgr.g_beachStartRotateX
    self.yAngle = 0
    self.aimState = AIM_STATE.normal
    local camera = MScene.GameCamera.UCam
    if camera then
        camera.nearClipPlane = self.nearClipPlane
    end
end --func end
--next--
function BeachLandingCtrl:Update()
    if not self.panel or IsNil(self.leftTrans) or IsNil(self.rightTrans) then return end
    if not self.aimState then return end

    if self.aimState == AIM_STATE.aim then
        local leftPos = self.leftTrans.anchoredPosition
        local rightPos = self.rightTrans.anchoredPosition
        self.leftTrans.anchoredPosition = Mathf.Lerp(leftPos, Vector2(0, leftPos.y), dt)
        self.rightTrans.anchoredPosition = Mathf.Lerp(rightPos, Vector2(0, rightPos.y), dt)
    elseif self.aimState == AIM_STATE.normal then
        self.leftTrans.anchoredPosition = self.leftOriginPos
        self.rightTrans.anchoredPosition = self.rightOriginPos
        self.aimState = AIM_STATE.idle
    end
end --func end

--next--
function BeachLandingCtrl:BindEvents()
    self:BindEvent(Data.PlayerInfoModel.HPPERCENT,Data.onDataChange, self.OnHpChange)
    self:BindEvent(self.mgr.EventDispatcher,self.mgr.BEACH_START_AIM, self.OnStartAim)
    self:BindEvent(self.mgr.EventDispatcher,self.mgr.BEACH_END_AIM, self.OnEndAim)
    self:BindEvent(self.mgr.EventDispatcher,self.mgr.TRY_SET_CASTING_OFFSET, self.OnTryFixCastingOffset)
end --func end
--next--
--lua functions end

--lua custom scripts
function BeachLandingCtrl:StartBeach()
    local camera = MScene.GameCamera.UCam
    local player = MEntityMgr.PlayerEntity
    if not player or not camera then return end

    local delta = player.Model.Forward * self.beachCameraDelta.x +
            Vector3(0, self.beachCameraDelta.y, 0)
            + player.Model.Rotation * Vector3.right * self.beachCameraDelta.z
    local position = player.Position + delta
    local rotation = Quaternion.Euler(-self.xAngle, player.Rotation.eulerAngles.y, 0)
    self.startPosition = position
    self.startRotation = Quaternion.Euler(0, player.Rotation.eulerAngles.y, 0)
    self.delta = delta
    MEventMgr:LuaFireEvent(MEventType.MEvent_CamChangeState, MScene.GameCamera, MoonClient.MCameraState.FixedAngle)
    MEventMgr:LuaFireEvent(MEventType.MEvent_CamFixedAngle, MScene.GameCamera, position, rotation, self.fov, dis)
    self:SetShootAngle(self.xAngle)
    camera.nearClipPlane = 0.01
end

-- 设置手臂角度
function BeachLandingCtrl:SetShootAngle(angle)
    local player = MEntityMgr.PlayerEntity
    local shootAngleValue = (angle + self.verticalMax)/(2 * self.verticalMax)
    MEventMgr:LuaFireEvent(MEventType.MEvent_InShootAngleChange, player, shootAngleValue)
end

function BeachLandingCtrl:OnBeginDrag(go, ed)
end

function BeachLandingCtrl:OnDraging(go, ed)
    if self.dungeonMgr:GetDungeonResult() then return end
    local delta = ed.delta
    local xAngle = delta.y * self.mgr.g_beachRotateSpeedX * self.verticalMax/(self.screenSize.y * 0.5)
    local yAngle = delta.x * self.mgr.g_beachRotateSpeedY * self.horizontalMax/(self.screenSize.x * 0.5)
    self.xAngle = Mathf.Clamp(self.xAngle + xAngle, -self.verticalMax, self.verticalMax)
    self.yAngle = Mathf.Clamp(self.yAngle + yAngle, -self.horizontalMax, self.horizontalMax)
    local player = MEntityMgr.PlayerEntity
    if player then
        player.Rotation = self.startRotation * Quaternion.Euler(0, self.yAngle, 0)
        self:SetCameraRot(player, self.xAngle, self.yAngle)
    end
    self:RefreshMonsterPrompt()
    self:SetShootAngle(self.xAngle)
end

function BeachLandingCtrl:OnEndDrag(go, ed)
end

function BeachLandingCtrl:RefreshMonsterPrompt()
    local camera = MScene.GameCamera.UCam
    if not camera then return end

    local rect = Screen.safeArea
    local leftPrompt = false
    local rightPrompt = false
    local allEntity = MEntityMgr:GetEnemyMEntities()
    for i = 0, allEntity.Count - 1 do
        local v = allEntity[i]
        local pos = camera:WorldToScreenPoint(v.Position)
        if not leftPrompt and pos.x < rect.xMin then
            leftPrompt = true
        elseif not rightPrompt and pos.x > rect.xMax then
            rightPrompt = true
        end
    end
    self.panel.leftPrompt:SetActiveEx(leftPrompt)
    self.panel.rightPrompt:SetActiveEx(rightPrompt)

end

function BeachLandingCtrl:SetCameraRot(player, xAngle, yAngle)
    local rotation = self.startRotation * Quaternion.Euler(-xAngle, yAngle, 0)
    local position = player.Position + self.delta * Quaternion.Euler(0, yAngle, 0)
    MEventMgr:LuaFireEvent(MEventType.MEvent_CamFixedAngle, MScene.GameCamera, position, rotation, self.fov, dis)
end

function BeachLandingCtrl:InitBlood()
    for i = 1, self.mgr.g_maxBlood do
        local bloodObj = self:CloneObj(self.panel.blood.UObj)
        bloodObj.transform:SetParent(self.panel.blood.transform.parent, false)
        bloodObj:SetActiveEx(true)

        local uiCom = bloodObj.transform:Find("xin"):GetComponent("MLuaUICom")
        uiCom.Img.fillAmount = 1
        table.insert(self.bloods, uiCom)
    end
    self.mgr.g_blood = self.mgr.g_maxBlood
    self:SetBlood(self.mgr.g_blood)
end

function BeachLandingCtrl:SetBlood(blood)
    blood = blood or self.mgr.g_blood
    for i = 1, math.floor(blood) do
        if self.bloods[i] then
            self.bloods[i].Img.fillAmount = 1
        end
    end
    local start = math.floor(blood) + 1
    for i = start, self.mgr.g_maxBlood do
        if i == start then
            if self.bloods[i] then
                self.bloods[i].Img.fillAmount = blood - math.floor(blood)
            end
        else
            if self.bloods[i] then
                self.bloods[i].Img.fillAmount = 0
            end
        end
    end
end

function BeachLandingCtrl:OnStartAim()
    self.aimState = AIM_STATE.aim
end

function BeachLandingCtrl:OnEndAim()
    self.aimState = AIM_STATE.normal
    self.leftOriginWorldPos = self.leftTrans.position
    self.rightOriginWorldPos = self.rightTrans.position
end

function BeachLandingCtrl:OnHpChange(percent)
    local blood = percent * self.mgr.g_maxBlood
    self.mgr.g_blood = blood
    self:SetBlood(blood)
end

function BeachLandingCtrl:OnTryFixCastingOffset()
    local camera = MScene.GameCamera.UCam
    if not camera then return end

    local player = MEntityMgr.PlayerEntity
    if not player then return end

    local hitPos
    local uiCamera = MUIManager.UICamera
    if uiCamera then
        local leftPoint = uiCamera:WorldToScreenPoint(self.leftTrans.position)
        local rightPoint = uiCamera:WorldToScreenPoint(self.rightTrans.position)
        self.aimPoint = Vector3(math.random(leftPoint.x, rightPoint.x), leftPoint.y, leftPoint.z)
    end
    if not self.aimPoint then
        self.aimPoint = MUIManager.UICamera:WorldToScreenPoint(self.panel.center.transform.position)
    end
    local pos = self.aimPoint
    local ray = camera:ScreenPointToRay(Vector3(pos.x, pos.y, 0))
    local hits = Physics.RaycastAll(ray, 1000, MLayer.MASK_MONSTER)
    if hits.Length > 0 then
        hitPos = hits[0].point
    else
        local hit, pos = MNavigationMgr:TryRaycastTerrain(ray.origin, ray.origin + ray.direction * 1000, Vector3.zero)
        if hit then
            hitPos = pos
        else
            hitPos = ray.origin + Vector3(ray.direction.x, 0, ray.direction.z) * 10
        end
    end
    hitPos.y = player.Position.y
    if hitPos then
        local skillui = MgrMgr:GetMgr("SkillControllerMgr").GetSkillController()
        if skillui and skillui.IsShowing then
            skillui.CastingOffset = hitPos - player.Position
        end
    end
end

--lua custom scripts end
return BeachLandingCtrl

