--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/BattleMvpMaskPanel"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua fields
local super = UI.UIBaseCtrl
--next--
--lua fields end

--lua class define
BattleMvpMaskCtrl = class("BattleMvpMaskCtrl", super)
--lua class define end

--lua functions
function BattleMvpMaskCtrl:ctor()

    super.ctor(self, CtrlNames.BattleMvpMask, UILayer.Function, nil, ActiveType.Exclusive)

end --func end
--next--
function BattleMvpMaskCtrl:Init()

    self.startTime = nil
    self.action = nil
    self.panel = UI.BattleMvpMaskPanel.Bind(self)
    super.Init(self)

    self.tweenId=0

end --func end
--next--
function BattleMvpMaskCtrl:Uninit()

    --关闭暗角
    self.Blur = false
    MoonClient.MPostEffectMgr.UberInstance:SetVignette(0, Color.black,
        1, 1, true, Vector2.New(0.5, 0.5));

    if self.tweenId then
        MUITweenHelper.KillTween(self.tweenId)
    end
    self:ClearEffect()
    super.Uninit(self)
    self.panel = nil

end --func end
--next--
function BattleMvpMaskCtrl:OnActive()


end --func end
--next--
function BattleMvpMaskCtrl:OnDeActive()


end --func end
--next--
function BattleMvpMaskCtrl:Update()

    self:UpdateTimer()

end --func end





--next--
function BattleMvpMaskCtrl:BindEvents()


end --func end

--next--
--lua functions end

--lua custom scripts
local l_from = Vector3.New(740, -126, 0)
local l_to = Vector3.New(-396, -126, 0)
local l_id = 3001
local TWEEN_TIME = 0.5
local Max_PLAY_TIME = 6 + TWEEN_TIME


local l_e1 = "Effects/Prefabs/Creature/Ui/Fx_Ui_Battle_MVP_SpeedLines"
local l_e2 = "Effects/Prefabs/Creature/Ui/Fx_Ui_Battle_MVP_Text"
local l_e3 = "Effects/Prefabs/Creature/Ui/Fx_Ui_Battle_MVP_TextIn"

function BattleMvpMaskCtrl:Play(entity, action)

    if not MgrMgr:GetMgr("DungeonMgr").IsInDungeons() then
        return
    end

    if not (entity and entity.AttrComp and entity.Model.UObj) then
        UIMgr:DeActiveUI(UI.CtrlNames.BattleMvpMask)
        if action then
            action()
        end
        return
    end

    self:ClearEffect()

    local l_fxData = {}
    l_fxData.rawImage = self.panel.Effect1.RawImg
    l_fxData.scaleFac = Vector3.New(1.5,1.5,1.5)
    --l_fxData1.position = self.fromPos
    --l_fxData1.loadedCallback = function(go)
    --end
    self.fx[1] = self:CreateUIEffect(l_e1, l_fxData)
    

    local l_fxData2 = {}
    l_fxData2.rawImage = self.panel.Effect2.RawImg
    --l_fxData1.playTime = 2
    --l_fxData1.position = self.fromPos
    --l_fxData1.loadedCallback = function(go)
    --end
    self.fx[2] = self:CreateUIEffect(l_e2, l_fxData2)

    --MoonClient.MPostEffectMgr.UberInstance:RadialBlur(3, 7)
    self.Blur = true
    self.action = action
    self.IdleAnimPath = entity.AttrComp.CommonIdleAnimPath
    self.panel.Name.LabText = entity.AttrComp.Name
    self.tweenId = MUITweenHelper.TweenPos(self.panel.Bg.gameObject, l_from, l_to, TWEEN_TIME, function()
        MEventMgr:LuaFireEvent(MEventType.MEvent_Special, entity,
        ROGameLibs.kEntitySpecialType_Action, l_id)

        local l_fxData3 = {}
        l_fxData3.rawImage = self.panel.Effect3.RawImg
        --l_fxData1.playTime = 2
        --l_fxData1.position = self.fromPos
        --l_fxData1.loadedCallback = function(go)
        --end
        self.fx[3] = self:CreateUIEffect(l_e3, l_fxData3)

    end)
    self.startTime = Time.realtimeSinceStartup
end

function BattleMvpMaskCtrl:UpdateTimer()
    if self.startTime then
        local l_duration = Time.realtimeSinceStartup - self.startTime
        local l_value = Max_PLAY_TIME - l_duration
        if l_value < 0.5 then
            if self.Blur then
                --MoonClient.MPostEffectMgr.UberInstance:RadialBlur(0, 7)
                self.Blur = false
            end
            MoonClient.MPostEffectMgr.UberInstance:SetVignette(l_value*2, Color.black,
            1, 1, true, Vector2.New(0.5, 0.5));
        end
        if l_duration > Max_PLAY_TIME then
            self.startTime = nil
            --MPlayerInfo:ExitAdaptiveState()
            UIMgr:DeActiveUI(UI.CtrlNames.BattleMvpMask)
            if self.action then
                self.action()
            end
        end
    end
end

function BattleMvpMaskCtrl:ClearEffect()
    if self.fx and #self.fx>0 then
        for i = 1, #self.fx do
            if self.fx[i] ~= nil then
                self:DestroyUIEffect(self.fx[i])
            end
        end
    end
    self.fx = {}
end

function BattleMvpMaskCtrl:Test()
    UIMgr:ActiveUI(UI.CtrlNames.BattleMvpMask, function()
        local l_ui = UIMgr:GetUI(UI.CtrlNames.BattleMvpMask)
        if l_ui then
            l_ui:Play("1111")
        end
    end)
end
--lua custom scripts end
