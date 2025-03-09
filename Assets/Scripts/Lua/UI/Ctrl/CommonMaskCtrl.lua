--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/CommonMaskPanel"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua class define
local super = UI.UIBaseCtrl
CommonMaskCtrl = class("CommonMaskCtrl", super)
--lua class define end

--lua functions
function CommonMaskCtrl:ctor()

    super.ctor(self, CtrlNames.CommonMask, UILayer.Function, nil, ActiveType.Standalone)

    self.GroupMaskType = GroupMaskType.Show
    self.MaskColor=BlockColor.Transparent

end --func end
--next--
function CommonMaskCtrl:Init()

    self.panel = UI.CommonMaskPanel.Bind(self)
    super.Init(self)

    --遮罩设置
    --self:SetBlockOpt(BlockColor.Transparent)

end --func end
--next--
function CommonMaskCtrl:Uninit()

    self:OnUninit()

    super.Uninit(self)
    self.panel = nil

end --func end
--next--
function CommonMaskCtrl:OnActive()


end --func end
--next--
function CommonMaskCtrl:OnDeActive()


end --func end
--next--
function CommonMaskCtrl:Update()

end --func end



--next--
function CommonMaskCtrl:BindEvents()

    --dont override this function

end --func end

--next--
--lua functions end

--lua custom scripts
local l_timer = nil
local l_effect = nil
local l_fx = nil

function CommonMaskCtrl:SetGuildCookInfo()
    self:RemoveTimer()
    self.panel.GuildCook.gameObject:SetActiveEx(true)
    self.panel.Slider.Slider.enabled = true
    self.panel.Slider.Slider.value = 0
    local l_showEffect = false
    local l_effectTime = 0.3

    l_timer = self:NewUITimer(function()
        self.panel.Slider.Slider.value = self.panel.Slider.Slider.value + 0.02
        if self.panel.Slider.Slider.value >= 0.98 then
            if not l_showEffect then
                l_showEffect = true
                local fxData = {}
                fxData.playTime = 0.3
                fxData.position = UnityEngine.Vector3.zero
                fxData.parent = self.panel.Slider.Slider.gameObject.transform
                l_fx = self:CreateEffect("Effects/Prefabs/Creature/Ui/Fx_Ui_JinDuTiao_01", fxData)
            end
            if l_effectTime>0 then
                l_effectTime = l_effectTime-0.05
                return
            end
            self:RemoveTimer()
            
            if Common.TimeMgr.GetNowTimestamp() > tonumber(tostring(DataMgr:GetData("GuildData").curDishData.endTime)) then
                MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("CUR_GUILD_DINNER_DISH_TIME_OUT"))
            else
                MgrMgr:GetMgr("GuildDinnerMgr").ReqTasteDish()
            end
            UIMgr:DeActiveUI(UI.CtrlNames.CommonMask)
        end
    end,0.05,-1,true)
    l_timer:Start()
end

function CommonMaskCtrl:SetEffectInfo(effectName,fxData)
    self:RemoveTimer()
    self.panel.Effect.gameObject:SetActiveEx(true)
    local l_fxData = fxData
    l_fxData.rawImage = self.panel.Effect.RawImg
    l_effect = self:CreateUIEffect(effectName, l_fxData)
    local l_index = 0
    l_timer = self:NewUITimer(function()
        l_index = l_index+1
        if l_index>=21 then
            UIMgr:DeActiveUI(UI.CtrlNames.CommonMask)
        end
    end,0.1,-1,true)
    l_timer:Start()
end

function CommonMaskCtrl:OnUninit()
    self:RemoveTimer()
    if l_effect then
        self:DestroyUIEffect(l_effect)
        l_effect = nil
    end
    if l_fx ~= nil then
        self:DestroyUIEffect(l_fx)
        l_fx = nil
    end
end

function CommonMaskCtrl:RemoveTimer()
    if l_timer then
        self:StopUITimer(l_timer)
        l_timer = nil
    end
end

--lua custom scripts end
