--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/GuildCrystalPanel"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua fields
local super = UI.UIBaseCtrl
--next--
--lua fields end

--lua class define
GuildCrystalCtrl = class("GuildCrystalCtrl", super)
--lua class define end

local l_guildData = nil
local l_guildCrystalMgr = nil

--lua functions
function GuildCrystalCtrl:ctor()
    
    super.ctor(self, CtrlNames.GuildCrystal, UILayer.Function, nil, ActiveType.Exclusive)
    
end --func end
--next--
function GuildCrystalCtrl:Init()
    
    self.panel = UI.GuildCrystalPanel.Bind(self)
    super.Init(self)

    l_guildData = DataMgr:GetData("GuildData")
    l_guildCrystalMgr = MgrMgr:GetMgr("GuildCrystalMgr")
    
    --是否展示充能动画标志初始化
    self.isNeedShowChargeAnim = false
    --关闭按钮点击
    self.panel.BtnClose:AddClick(function()
        UIMgr:DeActiveUI(UI.CtrlNames.GuildCrystal)
    end)
    --请求建筑信息
    MgrMgr:GetMgr("GuildBuildMgr").ReqGuildBuildMsg()

    --充能动画计时器
    self.effectTimer = nil
    --主水晶特效
    self.mianCrystalEffect = nil
    --连接特效表
    self.crystalLinkEffect = {}
    --水晶充能瞬间特效表
    self.crystalChargeFlashEffect = {}
    --水晶充能持续特效表
    self.crystalChargeStayEffect = {}

end --func end
--next--
function GuildCrystalCtrl:Uninit()

    self:ClearAllEffect()

    if l_guildCrystalMgr then
        l_guildCrystalMgr.curShowHandlerId = 0
    end
    
    self.isNeedShowChargeAnim = false
    l_getExeTimeCount = 0
    
    l_guildCrystalMgr = nil
    l_guildData = nil

    super.Uninit(self)
    self.panel = nil
    
end --func end

------------------------- Handler加载重写 ---------------------------------
function GuildCrystalCtrl:SetupHandlers()
    local l_handlerTb = {
        {HandlerNames.GuildCrystalPray, Lang("PRAY"), "CommonIcon", "UI_CommonIcon_GuildCrystal_Tab02.png", "UI_CommonIcon_GuildCrystal_Tab01.png"},
        {HandlerNames.GuildCrystalStudy, Lang("STUDY"), "CommonIcon", "UI_CommonIcon_GuildCrystal_Tab04.png", "UI_CommonIcon_GuildCrystal_Tab03.png"},
    }
    self:InitHandler(l_handlerTb, self.panel.ToggleTpl, nil, HandlerNames.GuildCrystalPray)
end
-------------------------  END Handler加载重写 ---------------------------------

--next--
function GuildCrystalCtrl:OnActive()

    --MLuaClientHelper.PlayFxHelper(self.panel.MagicCircleBg.UObj)
    
end --func end
--next--
function GuildCrystalCtrl:OnDeActive()
    
    
end --func end
--next--
function GuildCrystalCtrl:Update()
    
    
end --func end





--next--
function GuildCrystalCtrl:BindEvents()
    
    --水晶信息获取事件
    self:BindEvent(l_guildCrystalMgr.EventDispatcher,l_guildCrystalMgr.ON_GET_GUILD_CRYSTAL_INFO,function(self)
        --设置水晶信息
        self:SetCrystalInfo()
    end)
    --标签页切换事件
    self:BindEvent(l_guildCrystalMgr.EventDispatcher,l_guildCrystalMgr.ON_SWITCH_CRYSTAL_HANDLER,function(self)
        --重置选中效果
        for i = 1, 6 do
            self.panel.IsSelectd[i].UObj:SetActiveEx(false)
            if l_guildCrystalMgr.curShowHandlerId == 0 then
                self.panel.IsStudying[i].UObj:SetActiveEx(false)
            end
        end
    end)
    --水晶选择事件
    self:BindEvent(l_guildCrystalMgr.EventDispatcher,l_guildCrystalMgr.ON_SELECT_CRYSTAL,function(self, crystalId)
        --水晶选中效果设置
        for j = 1, 6 do
            self.panel.IsSelectd[j].UObj:SetActiveEx(false)
        end
        self.panel.IsSelectd[crystalId].UObj:SetActiveEx(true)
    end)
    --水晶取消选中事件
    self:BindEvent(l_guildCrystalMgr.EventDispatcher,l_guildCrystalMgr.ON_CANCEL_SELECT_CRYSTAL,function(self)
        for j = 1, 6 do
            self.panel.IsSelectd[j].UObj:SetActiveEx(false)
        end
    end)
    --水晶充能事件
    self:BindEvent(l_guildCrystalMgr.EventDispatcher,l_guildCrystalMgr.ON_GUILD_CRYSTAL_CHARGE,function(self)
        --设置需要展示充能动画 祈福界面
        if l_guildCrystalMgr.curShowHandlerId == 0 then
            self.isNeedShowChargeAnim = true
        end
    end)
    --被踢出回调
    self:BindEvent(MgrMgr:GetMgr("GuildMgr").EventDispatcher,MgrMgr:GetMgr("GuildMgr").ON_GUILD_KICKOUT,function(self)
        UIMgr:DeActiveUI(UI.CtrlNames.GuildCrystal)
    end)
    
end --func end
--next--
--lua functions end

--lua custom scripts
--设置水晶信息
function GuildCrystalCtrl:SetCrystalInfo()

    local l_crystalList = l_guildData.guildCrystalInfo.crystalList
    --如果需要展示充能动画则展示
    if self.isNeedShowChargeAnim then
        self:ShowChargeEffectAnim()
        self.isNeedShowChargeAnim = false
    end
    --如果没有正在展示的充能动画 则清理原特效
    if not self.effectTimer or l_guildCrystalMgr.curShowHandlerId == 1 then
        self:ClearAllEffect()
    end
    --水晶信息展示
    for i = 1, #l_crystalList do
        local l_crystalInfo = l_crystalList[i]
        local l_crystalData = TableUtil.GetGuildCrystalTable().GetRowByCrystalId(l_crystalInfo.id)
        self.panel.ImgCrystal[i]:SetSprite(l_crystalData.CrystalIconAltas, l_crystalData.CrystalIconName, true)
        self.panel.ImgCrystal[i].UObj:SetActiveEx(true)
        self.panel.IsStudying[i].UObj:SetActiveEx(l_crystalInfo.isStudy and l_guildCrystalMgr.curShowHandlerId == 1)
        self.panel.NameText[i].LabText = Lang("TROLLEY_REFIT_SKILL_LIMIT", Lang(l_crystalData.CrystalName), l_crystalInfo.level)
        --如果水晶充能 且 没有正在播放充能动画的计时器 则展示常驻特效 仅祈福界面
        if l_guildCrystalMgr.curShowHandlerId == 0 and not self.effectTimer and l_crystalInfo.isCharged then
            --水晶常驻充能特效展示
            local l_fxData = {}
            l_fxData.rawImage = self.panel.CrystalStayEffectView[i].RawImg
            l_fxData.scaleFac = Vector3.New(1, 1, 1)
            l_fxData.loadedCallback = function(a) self.panel.CrystalStayEffectView[i].gameObject:SetActiveEx(true) end
            l_fxData.destroyHandler = function ()
                self.panel.CrystalStayEffectView[i].gameObject:SetActiveEx(false)
                self.crystalChargeStayEffect[i] = nil
            end
            self.crystalChargeStayEffect[i] = self:CreateUIEffect("Effects/Prefabs/Creature/Ui/Fx_Ui_Crystal_BaoShiChiXu_00", l_fxData)
            
        end
        --点击效果
        self.panel.BtnCrystal[i]:AddClick(function()
            l_guildCrystalMgr.SelectOneCrystal(l_crystalInfo.id)
        end)
    end

end

--充能特效动画展示
function GuildCrystalCtrl:ShowChargeEffectAnim()
    --清理原特效
    self:ClearAllEffect()
    --主水晶特效
    self:ShowMainCrystalEffect()
    --充能动画计时器
    self.effectTimeCount = 0
    self.effectTimer = self:NewUITimer(function()
        self.effectTimeCount = self.effectTimeCount + 0.2
        if self.effectTimeCount >= 1 then
            --主水晶充能特效播放1秒后 展示水晶常驻特效 并关闭计时器
            self:ShowCrystalChargeStayEffect()
            if self.effectTimer then
                self:StopUITimer(self.effectTimer)
                self.effectTimer = nil
            end
        elseif self.effectTimeCount >= 0.4 and self.effectTimeCount < 0.5 then
            --主水晶充能特效播放0.4秒后 展示水晶瞬间特效
            self:ShowCrystalChargeFlashEffect()
        elseif self.effectTimeCount == 0.2 then
            --主水晶充能特效播放0.2秒后 展示水晶连接特效
            self:ShowCrystalLinkEffect()
        end
    end, 0.2, -1, true)
    self.effectTimer:Start()
end

--主水晶特效
function GuildCrystalCtrl:ShowMainCrystalEffect()
    local l_fxData = {}
    l_fxData.rawImage = self.panel.MainCrystalEffectView.RawImg
    l_fxData.scaleFac = Vector3.New(1, 1, 1)
    l_fxData.loadedCallback = function(a) self.panel.MainCrystalEffectView.gameObject:SetActiveEx(true) end
    l_fxData.destroyHandler = function ()
        self.panel.MainCrystalEffectView.gameObject:SetActiveEx(false)
        self.mianCrystalEffect = nil
    end
    self.mianCrystalEffect = self:CreateUIEffect("Effects/Prefabs/Creature/Ui/Fx_Ui_Crystal_ShuiJingShunJian_00", l_fxData)
    
end

--充能连接特效加载
function GuildCrystalCtrl:ShowCrystalLinkEffect()
    local l_crystalList = l_guildData.guildCrystalInfo.crystalList
    for i = 1, #l_crystalList do
        if l_crystalList[i].isCharged then
            local l_fxData = {}
            l_fxData.rawImage = self.panel.CrystalLinkEffectView[i].RawImg
            l_fxData.scaleFac = Vector3.New(1, 1, 1)
            l_fxData.rotation = Quaternion.Euler(0, 0, 210 - i * 60)
            l_fxData.loadedCallback = function(a) self.panel.CrystalLinkEffectView[i].gameObject:SetActiveEx(true) end
            l_fxData.destroyHandler = function ()
                self.panel.CrystalLinkEffectView[i].gameObject:SetActiveEx(false)
                self.crystalLinkEffect[i] = nil
            end
            self.crystalLinkEffect[i] = self:CreateUIEffect("Effects/Prefabs/Creature/Ui/Fx_Ui_Crystal_ShuiJingLianJie_00", l_fxData)
            
        end
    end
end

--水晶充能瞬间特效加载
function GuildCrystalCtrl:ShowCrystalChargeFlashEffect()
    local l_crystalList = l_guildData.guildCrystalInfo.crystalList
    for i = 1, #l_crystalList do
        if l_crystalList[i].isCharged then
            local l_fxData = {}
            l_fxData.rawImage = self.panel.CrystalFlashEffectView[i].RawImg
            l_fxData.scaleFac = Vector3.New(1, 1, 1)
            l_fxData.loadedCallback = function(a) self.panel.CrystalFlashEffectView[i].gameObject:SetActiveEx(true) end
            l_fxData.destroyHandler = function ()
                self.panel.CrystalFlashEffectView[i].gameObject:SetActiveEx(false)
                self.crystalChargeFlashEffect[i] = nil
            end
            self.crystalChargeFlashEffect[i] = self:CreateUIEffect("Effects/Prefabs/Creature/Ui/Fx_Ui_Crystal_BaoShiShunJian_00", l_fxData)
            
        end
    end
end

--水晶充能持续特效加载
function GuildCrystalCtrl:ShowCrystalChargeStayEffect()
    local l_crystalList = l_guildData.guildCrystalInfo.crystalList
    for i = 1, #l_crystalList do
        if l_crystalList[i].isCharged then
            local l_fxData = {}
            l_fxData.rawImage = self.panel.CrystalStayEffectView[i].RawImg
            l_fxData.scaleFac = Vector3.New(1, 1, 1)
            l_fxData.loadedCallback = function(a) self.panel.CrystalStayEffectView[i].gameObject:SetActiveEx(true) end
            l_fxData.destroyHandler = function ()
                self.panel.CrystalStayEffectView[i].gameObject:SetActiveEx(false)
                self.crystalChargeStayEffect[i] = nil
            end
            self.crystalChargeStayEffect[i] = self:CreateUIEffect("Effects/Prefabs/Creature/Ui/Fx_Ui_Crystal_BaoShiChiXu_00", l_fxData)
            
        end
    end
end

--特效清理
function GuildCrystalCtrl:ClearAllEffect()

    --特效动画计时器清理
    if self.effectTimer then
        self:StopUITimer(self.effectTimer)
        self.effectTimer = nil
    end

    --主水晶特效销毁
    if self.mianCrystalEffect ~= nil then
        self:DestroyUIEffect(self.mianCrystalEffect)
        self.mianCrystalEffect = nil
    end

    --连接特效销毁
    for k,v in pairs(self.crystalLinkEffect) do
        self:DestroyUIEffect(v)
        self.crystalLinkEffect[k] = nil
    end

    --水晶充能瞬间特效销毁
    for k,v in pairs(self.crystalChargeFlashEffect) do
        self:DestroyUIEffect(v)
        self.crystalChargeFlashEffect[k] = nil
    end

    --水晶充能持续特效销毁
    for k,v in pairs(self.crystalChargeStayEffect) do
        self:DestroyUIEffect(v)
        self.crystalChargeStayEffect[k] = nil
    end
end

--lua custom scripts end
return GuildCrystalCtrl