--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/DungeonTargetPanel"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua fields
local super = UI.UIBaseCtrl
local l_fx = "Effects/Prefabs/Creature/Ui/Fx_Ui_WenZi_SaoGuang_01"
local l_high = 18.6375
local l_pos = 90
local l_timer = nil
--next--
--lua fields end

--lua class define
DungeonTargetCtrl = class("DungeonTargetCtrl", super)
--lua class define end

--lua functions
function DungeonTargetCtrl:ctor()

    super.ctor(self, CtrlNames.DungeonTarget, UILayer.Tips, nil, ActiveType.Normal)

end --func end
--next--
function DungeonTargetCtrl:Init()

    self.panel = UI.DungeonTargetPanel.Bind(self)
    super.Init(self)
    self.dungeonTargetMgr = MgrMgr:GetMgr("DungeonTargetMgr")
    self.items = {}

    self.enhanceEffect = nil  --增强目标指引特效

end --func end
--next--
function DungeonTargetCtrl:Uninit()

    --增强目标指引特效销毁
    if self.enhanceEffect ~= nil then
        self:DestroyUIEffect(self.enhanceEffect)
        self.enhanceEffect = nil
    end

    if self.items then
        local l_count = #self.items
        if l_count > 0 then
            for i = 1, l_count do
                if self.items[i].fx ~= nil then
                    self:DestroyUIEffect(self.items[i].fx)
                    self.items[i].fx = nil
                end
                MResLoader:DestroyObj(self.items[i].go)
            end
        end
    end
    self.items = {}
    super.Uninit(self)
    self.panel = nil

end --func end
--next--
function DungeonTargetCtrl:OnActive()

    self:OnInit()

end --func end
--next--
function DungeonTargetCtrl:OnDeActive()

    self:OnUninit()

end --func end
--next--
function DungeonTargetCtrl:Update()

    self:RefreshPanel()

end --func end

--next--
function DungeonTargetCtrl:BindEvents()
    self:BindEvent(self.dungeonTargetMgr.EventDispatcher,self.dungeonTargetMgr.ON_UPDATE_DUNGEONS_TARGET,function(_, id, cueStep, totalCount)
        self:UpdateItem(id,cueStep,totalCount)
    end)
    self:BindEvent(self.dungeonTargetMgr.EventDispatcher,self.dungeonTargetMgr.ON_DUNGEONS_TARGET_SECTION,function()
        self.dungeonTargetMgr.l_refresh = true
        self:RefreshPanel()
    end)
    --副本内点击任务导航 指引观看副本目标
    self:BindEvent(self.dungeonTargetMgr.EventDispatcher,self.dungeonTargetMgr.ON_TASK_NAVGATION_GUIDE_DUNGEONS_TARGET, function()
        self:PlayEnhanceTargetGuideFx()
    end)
end --func end
--next--
--lua functions end

--lua custom scripts
function DungeonTargetCtrl:OnInit()
    local l_count = #self.items
    if l_count > 0 then
        for i = 1, l_count do
            if self.items[i].fx ~= nil then
                self:DestroyUIEffect(self.items[i].fx)
                self.items[i].fx = nil
            end
            self.items[i].go:SetActiveEx(false)
        end
    end
    self.panel.TargetHide.gameObject:SetActiveEx(false)
    if #self.dungeonTargetMgr.l_targetInfo < 1 or
    self.dungeonTargetMgr.l_id ~= MPlayerInfo.PlayerDungeonsInfo.DungeonID then
        self.panel.Target.gameObject:SetActiveEx(false)
        return
    end
    self.panel.TargetHide:AddClick(function ()
        self.panel.TargetHide.gameObject:SetActiveEx(false)
        self.panel.Target.gameObject:SetActiveEx(true)
    end)
    self.panel.OpenBtn:AddClick(function ()
        self.panel.TargetHide.gameObject:SetActiveEx(true)
        self.panel.Target.gameObject:SetActiveEx(false)
    end)
    self.panel.Target.gameObject:SetActiveEx(true)
    local l_tp = self.panel.CloneGoj.gameObject
    for i = 1, #self.dungeonTargetMgr.l_targetInfo do
        local l_info = self.dungeonTargetMgr.l_targetInfo[i]
        if not self.items[i] then
            self.items[i] = {}
            local l_temp = self:CloneObj(l_tp)
            self.items[i].go = l_temp
            l_temp.transform:SetParent(self.panel.Target.transform)
            l_temp:SetLocalScaleToOther(l_tp)
            --self.items[i].des = l_temp.transform:GetComponent("MLuaUICom")
            self.items[i].process = l_temp.transform:Find("process"):GetComponent("MLuaUICom")
            self.items[i].finish = l_temp.transform:Find("Image"):GetComponent("MLuaUICom")
            self.items[i].rawImg = l_temp.transform:Find("Text/RawImg"):GetComponent("MLuaUICom")
            self.items[i].des = l_temp.transform:Find("Text"):GetComponent("MLuaUICom")
        end
        self.items[i].go:SetActiveEx(true)
        self.items[i].rawImg.gameObject:SetLocalScaleOne()
        self.items[i].info = l_info
        self.items[i].id = l_info.id
        self.items[i].fx = nil
        self.items[i].state = l_info.cur_step>=l_info.total_count
        self:InitItem(l_info.id)
    end
    if l_timer then
        self:StopUITimer(l_timer)
        l_timer = nil
    end
    l_timer = self:NewUITimer(function()
        if self.dungeonTargetMgr.l_pos then
            local l_iconPos=Vector2.New(self.dungeonTargetMgr.l_pos[0],self.dungeonTargetMgr.l_pos[2])
            local l_mapInfoMgr=MgrMgr:GetMgr("MapInfoMgr")
            l_mapInfoMgr.EventDispatcher:Dispatch(l_mapInfoMgr.EventType.UpdateNavIconPos,l_mapInfoMgr.EUpdateNavIconType.DungeonTargetNav,l_iconPos)
        end
    end,1,-1,true)
    l_timer:Start()
    self.panel.CloneGoj:SetActiveEx(false)
end

function DungeonTargetCtrl:InitItem(id)
    local l_table =  TableUtil.GetDungeonTargetTable().GetRowByID(id)
    local l_count = #self.items
    local l_target
    if l_count > 0 then
        for i = 1, l_count do
            if id == self.items[i].id then
                l_target = self.items[i]
                break
            end
        end
    end
    if l_target then
        if l_target.state then
            local l_finishColor = self.panel.finishText.LabColor
            l_target.finish.gameObject:SetActiveEx(true)
            l_target.des.LabColor = l_finishColor
            l_target.process.LabColor = l_finishColor
        else
            local l_runColor = self.panel.runText.LabColor
            l_target.finish.gameObject:SetActiveEx(false)
            l_target.des.LabColor = l_runColor
            l_target.process.LabColor = l_runColor
        end
        if self.dungeonTargetMgr.l_refresh then
            self:PlayFx(l_target)
        end
        l_target.des.LabText = l_table.TargetDes
        l_target.process.LabText = tostring(l_target.info.cur_step).."/"..tostring(l_target.info.total_count)
    end
end

function DungeonTargetCtrl:UpdateItem(id, cueStep, totalCount)
    local l_count = #self.items
    local l_target
    if l_count > 0 then
        for i = 1, l_count do
            if id == self.items[i].id and not self.items[i].state then
                self.items[i].state = cueStep>=totalCount
                self.items[i].info.cur_step = cueStep
                self.items[i].info.total_count = totalCount
                l_target = self.items[i]
                break
            end
        end
    end
    if l_target then
        if l_target.state then
            local l_finishColor = self.panel.finishText.LabColor
            l_target.finish.gameObject:SetActiveEx(true)
            l_target.des.LabColor = l_finishColor
            l_target.process.LabColor = l_finishColor
            self:PlayFx(l_target)
        else
            local l_runColor = self.panel.runText.LabColor
            l_target.finish.gameObject:SetActiveEx(false)
            l_target.des.LabColor = l_runColor
            l_target.process.LabColor = l_runColor
        end
        l_target.process.LabText = tostring(l_target.info.cur_step).."/"..tostring(l_target.info.total_count)
    end
end

function DungeonTargetCtrl:PlayFx(item)
    if item.fx ~= nil then
        self:DestroyUIEffect(item.fx)
        item.fx = nil
    end
    self.effectTime = Time.realtimeSinceStartup
    local l_fxData = {}
    l_fxData.rawImage = item.rawImg.RawImg
    local l_scal = item.des:GetText().preferredHeight/l_high
    l_fxData.scaleFac = Vector3.New(1,l_scal, 1)
    l_fxData.loadedCallback = function()
        item.rawImg.RawImg.gameObject:SetActiveEx(true)
    end
    item.fx = self:CreateUIEffect(l_fx, l_fxData)
    item.rawImg.RawImg.gameObject:SetLocalPosY(l_pos-((l_scal-1)*l_high/2))
    
end

function DungeonTargetCtrl:RefreshPanel()
    if self.dungeonTargetMgr.l_refresh and
            ((self.effectTime and Time.realtimeSinceStartup-self.effectTime>2) or self.effectTime == nil) then
        self:OnInit()
        self.dungeonTargetMgr.l_refresh = false
    end
end

function DungeonTargetCtrl:OnUninit()
    if l_timer then
        self:StopUITimer(l_timer)
        l_timer = nil
    end
    MapObjMgr:RmObj(MapObjType.DungeonTarget)
end


function DungeonTargetCtrl:Test()
    local item = self.items[1]
    if item.fx ~= nil then
        self:DestroyUIEffect(item.fx)
        item.fx = nil
    end
    local l_fxData = {}
    l_fxData.rawImage = item.rawImg.RawImg
    local l_scal = item.des:GetText().preferredHeight/l_high
    l_fxData.scaleFac = Vector3.New(1,l_scal, 1)
    item.fx = self:CreateUIEffect(l_fx, l_fxData)
    item.rawImg.RawImg.gameObject:SetLocalPosY(l_pos-((l_scal-1)*l_high/2))
    
end

--播放增强目标指引特效
function DungeonTargetCtrl:PlayEnhanceTargetGuideFx()
    --不满足条件不显示
    if #self.dungeonTargetMgr.l_targetInfo < 1 or self.dungeonTargetMgr.l_id ~= MPlayerInfo.PlayerDungeonsInfo.DungeonID then
        return
    end
    --强行展开副本目标
    self.panel.TargetHide.gameObject:SetActiveEx(false)
    self.panel.Target.gameObject:SetActiveEx(true)
    --开启增强提示特效
    self.panel.EnhanceTipEffect.UObj:SetActiveEx(true)
    if not self.panel.EnhanceTipEffect.Animatior:IsPlaying("Fx_UI_FuBenDianJiFanKui") then
        self.panel.EnhanceTipEffect.Animatior:Play("Fx_UI_FuBenDianJiFanKui")
    end
end
--lua custom scripts end
return DungeonTargetCtrl