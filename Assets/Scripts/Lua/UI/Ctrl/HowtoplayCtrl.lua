--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/HowtoplayPanel"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua fields
local super = UI.UIBaseCtrl
--next--
--lua fields end

--lua class define
HowtoplayCtrl = class("HowtoplayCtrl", super)
--lua class define end

--lua functions
function HowtoplayCtrl:ctor()
    
    super.ctor(self, CtrlNames.Howtoplay, UILayer.Function, nil, ActiveType.Standalone)
    self.overrideSortLayer = UILayerSort.Function + 2
    
end --func end
--next--
function HowtoplayCtrl:Init()
    
    self.panel = UI.HowtoplayPanel.Bind(self)
    super.Init(self)
    self.point = {}
    self.tweenId=0

end --func end
--next--
function HowtoplayCtrl:Uninit()
    
    super.Uninit(self)
    self.panel = nil
    
end --func end
--next--
function HowtoplayCtrl:OnActive()
    --self:SetParent(UI.CtrlNames.DelegatePanel)
    
end --func end
--next--
function HowtoplayCtrl:OnDeActive()

    if self.tweenId then
        MUITweenHelper.KillTween(self.tweenId)
    end
    local l_count = #self.point
    if l_count > 0 then
        for i = 1, l_count do
            --if self.point[i].fx ~= nil then
            --  self:DestroyUIEffect(self.point[i].fx)
            --  self.point[i].fx = nil
            --end
            MResLoader:DestroyObj(self.point[i].go)
        end
    end
    self.point = {}

    --新手指引相关
    MgrMgr:GetMgr("BeginnerGuideMgr").HowToPlayClose()

end --func end
--next--
function HowtoplayCtrl:Update()
    
    
end --func end





--next--
function HowtoplayCtrl:BindEvents()
    
    
end --func end

--next--
--lua functions end

--lua custom scripts
--==============================--
--@Description:打开说明面板
--@Date: 2019/6/10
--@Param: id 具体玩法 idx 玩法内部说明编号
--@Return:
--==============================--
function HowtoplayCtrl:ShowPanel(id, idx)
    if not id then
        UIMgr:DeActiveUI(CtrlNames.Howtoplay)
        return
    end
    local l_data = TableUtil.GetGameTipsTable().GetRowByMajorId(id)
    if not l_data then
        logError("not find GameTipsTable MajorId:"..tostring(id))
        UIMgr:DeActiveUI(CtrlNames.Howtoplay)
        return
    end
    idx = idx or 1
    self.iconTab = Common.Functions.VectorToTable(l_data.SystemIcon)
    self.tipsTab = Common.Functions.VectorToTable(l_data.Tips)
    if idx > #self.iconTab then
        logError("非法的玩法索引 @戴瑞轩", id, idx)
        idx = math.min(#self.iconTab, idx)
    end
    local l_count = #self.iconTab
    if l_count==1 then
        self.panel.Right.gameObject:SetActiveEx(false)
        self.panel.Left.gameObject:SetActiveEx(false)
        self.panel.Point.gameObject.transform.parent.gameObject:SetActiveEx(false)
    end
    local l_number = #self.point
    if l_number > 0 then
        for i = 1, l_number do
            MResLoader:DestroyObj(self.point[i].go)
        end
    end
    self.point = {}
    local l_tp = self.panel.Point.gameObject
    for i = 1, l_count do
        local l_index = #self.point + 1
        self.point[l_index] = {}
        local l_temp = self:CloneObj(l_tp)
        l_temp.transform:SetParent(l_tp.transform.parent.transform)
        l_temp.transform:SetLocalPosZero()
        l_temp:SetLocalScaleToOther(l_tp)
        self.point[l_index].go = l_temp
        self.point[l_index].go:SetActiveEx(true)
        self.point[l_index].mask = l_temp.transform:Find("Checkmark"):GetComponent("MLuaUICom")
        self.point[l_index].mask.gameObject:SetActiveEx(false)
        self.point[l_index].fx = nil
    end
    self.point[idx].mask.gameObject:SetActiveEx(true)
    self.panel.Image2:SetRawTex("HowToPlay/"..self.iconTab[idx])
    self.panel.Text.LabText = self.tipsTab[idx] or ""
    self.panel.Mask.gameObject:SetActiveEx(false)
    self.index = idx
    self.count = l_count
    self.panel.Right:AddClick(function ()
        self:PlayTween(true)
    end)
    self.panel.Left:AddClick(function ()
        self:PlayTween(false)
    end)
    self.panel.CloseBtn:AddClick(function ()
        UIMgr:DeActiveUI(CtrlNames.Howtoplay)
    end)

    local l_listener = MUIEventListener.Get(self.panel.Image2.gameObject)
    l_listener.onDrag = function(go,data)
        if self.lastPoint == nil then
            self.lastPoint = data.position.x
            return
        end
    end
    l_listener.onDragEnd = function(go,data)
        local l_dis = self.lastPoint - data.position.x
        self:PlayTween(l_dis>0)
        self.lastPoint = nil
    end
end

function HowtoplayCtrl:PlayTween(right)
    if right then
        if self.index>= self.count  then
            return
        end
        self.point[self.index].mask.gameObject:SetActiveEx(false)
        self.panel.Image1:SetRawTex("HowToPlay/"..self.iconTab[self.index])
        self.index = self.index+1
        self.panel.Tween.gameObject:SetLocalPosX(591)
        self.panel.Image2:SetRawTex("HowToPlay/"..self.iconTab[self.index])
        self.panel.Mask.gameObject:SetActiveEx(true)
        self.tweenId = MUITweenHelper.TweenPos(self.panel.Tween.gameObject,self.panel.Tween.gameObject.transform.localPosition,
        Vector3.New(0,0,0), 0.2,function ()
            if self.panel then
                self.panel.Mask.gameObject:SetActiveEx(false)
            end
        end)
    else
        if self.index<= 1  then
            return
        end
        self.point[self.index].mask.gameObject:SetActiveEx(false)
        self.panel.Image3:SetRawTex("HowToPlay/"..self.iconTab[self.index])
        self.index = self.index-1
        self.panel.Tween.gameObject:SetLocalPosX(-591)
        self.panel.Image2:SetRawTex("HowToPlay/"..self.iconTab[self.index])
        self.panel.Mask.gameObject:SetActiveEx(true)
        self.tweenId = MUITweenHelper.TweenPos(self.panel.Tween.gameObject,self.panel.Tween.gameObject.transform.localPosition,
        Vector3.New(0,0,0), 0.2,function ()
            if self.panel then
                self.panel.Mask.gameObject:SetActiveEx(false)
            end
        end)
    end
    self.panel.Text.LabText = self.tipsTab[self.index]
    self.point[self.index].mask.gameObject:SetActiveEx(true)
end
--lua custom scripts end
return HowtoplayCtrl