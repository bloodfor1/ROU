--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/SignInPanel"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua fields
local super = UI.UIBaseCtrl
--next--
--lua fields end

--lua class define
SignInCtrl = class("SignInCtrl", super)
--lua class define end

--lua functions
function SignInCtrl:ctor()

	super.ctor(self, CtrlNames.SignIn, UILayer.Function, UITweenType.Alpha, ActiveType.Standalone)
    self.isFullScreen = true
end --func end
--next--
function SignInCtrl:Init()

	self.panel = UI.SignInPanel.Bind(self)
    super.Init(self)
    self.Mgr = MgrMgr:GetMgr("SignInMgr")

    self.panel.PointModel.LuaUIGroup.gameObject:SetActiveEx(false)
    self.panel.PointFloor.LuaUIGroup.gameObject:SetActiveEx(false)

    self.panel.BtnClose:AddClick(function()
        UIMgr:DeActiveUI(CtrlNames.SignIn)
    end,true)

    self.MaxDay = 0
    local l_allRows = TableUtil.GetMouthAttendanceTable().GetTable()
    for i=1,#l_allRows do
        self.MaxDay = math.max(self.MaxDay,l_allRows[i].Day)
    end

    self.FloorTems = {}
    local l_startTem = self:AddFloorTem(self.panel.FloorGroup.transform:Find("Start"),{
        isStart = true,
    })
    local l_endTem = self:AddFloorTem(self.panel.FloorGroup.transform:Find("End"),{
        isEnd = true,
    })

    self.PointNodes = {}
    self.PointTems = {}
    for i=1,self.MaxDay do
        self.PointNodes[i] = self.panel.FloorGroup.transform:Find(tostring(i))
        if self.PointNodes[i] ~= nil then
            self.PointTems[#self.PointTems+1] = self:NewTemplate("SignInPointTem",{
                TemplateParent=self.panel.PointGroup.transform,
                TemplatePrefab=self.panel.PointModel.LuaUIGroup.gameObject,
                Data = {
                    Index = i,
                    Pos = self.PointNodes[i].anchoredPosition,
                },
            })

            self:AddFloorTem(self.PointNodes[i],{
                index = i,
                pos = self.PointTems[i]:transform().position,
            })
        else
            logError("缺少节点 => index={0}",i)
        end
    end

    --匹配按钮的特效
    self.panel.CurPointObj:SetActiveEx(false)
    self.panel.MatchEffect:SetActiveEx(false)
    self.panel.MatchEffect.RawImg.enabled = false
    local l_fxData = {}
    l_fxData.rawImage = self.panel.MatchEffect.RawImg
    l_fxData.scaleFac = Vector3.New(1.1,1.1,1.1)
    l_fxData.position = Vector3.New(0,0.05,0) --settime 2019 1 20 10 10 10
    l_fxData.loadedCallback = function(a)
        self.panel.MatchEffect.RawImg.enabled = true
        self:ResetEffect()
    end
    self.PiPeiEffectID = self:CreateUIEffect("Effects/Prefabs/Creature/Ui/Fx_Ui_QianDaoJiangLi_01", l_fxData)
    
end --func end
--next--
function SignInCtrl:Uninit()

	super.Uninit(self)
	self.panel = nil
    self.PointTems = nil
    self.FloorTems = nil

    if self.PiPeiEffectID then
        self:DestroyUIEffect(self.PiPeiEffectID)
        self.PiPeiEffectID = nil
    end
end --func end
--next--
function SignInCtrl:OnActive()
    local l_ids = {}
    for day=1,self.MaxDay do
        local l_row = TableUtil.GetMouthAttendanceTable().GetRowByDay(day)
        l_ids[day] = l_row.Award
    end
    self.Mgr.SendThirtySignActivityGetInfo()
    MgrMgr:GetMgr("AwardPreviewMgr").GetBatchPreviewRewards(l_ids,self.Mgr.Event.Award)

end --func end
--next--
function SignInCtrl:OnDeActive()


end --func end
--next--
function SignInCtrl:Update()


end --func end





--next--
function SignInCtrl:BindEvents()
    self:BindEvent(self.Mgr.EventDispatcher,self.Mgr.Event.ResetIndex, function(self,CurIndex)
        local l_tem = self.PointTems[CurIndex]
        if l_tem~=nil then
            l_tem:SetData(l_tem.Data)
        end
        self:ResetEffect()
    end)

    self:BindEvent(MgrMgr:GetMgr("AwardPreviewMgr").EventDispatcher,self.Mgr.Event.Award, function(self, awardInfo)
        local l_find = function(aid)
            if awardInfo then
                for i=1,#awardInfo do
                    local l_info = awardInfo[i]
                    if l_info.award_id == aid then
                        local l_awardItems = {}
                        for i, v in ipairs(l_info.award_list) do
                            local l_itemRow = TableUtil.GetItemTable().GetRowByItemID(v.item_id)
                            if l_itemRow then
                                l_awardItems[#l_awardItems+1] = {id = v.item_id, count = v.count}
                            end
                        end
                        return l_awardItems
                    end
                end
            end
        end
        for day=1,self.MaxDay do
            local l_tem = self.PointTems[day]
            local l_data = l_tem.Data
            local l_row = TableUtil.GetMouthAttendanceTable().GetRowByDay(day)
            l_data.ItemInfos = l_find(l_row.Award)
            l_tem:SetData(l_data)
        end
    end)
end --func end
--lua functions end

--lua custom scripts
function SignInCtrl:ResetEffect()
    self.panel.MatchEffect:SetActiveEx(false)
    self.panel.CurPointObj:SetActiveEx(false)
    if self.Mgr:CanSignIn() then
        local l_node = self.PointNodes[self.Mgr.MaxIndex]
        if l_node~=nil then
            self.panel.MatchEffect.transform:SetPos(l_node.position)
            self.panel.MatchEffect:SetActiveEx(true)
            self.panel.CurPointObj.transform:SetPos(l_node.position)
            self.panel.CurPointObj:SetActiveEx(true)
        end
    end
end
function SignInCtrl:AddFloorTem(parent,data)
    local l_tem = self:NewTemplate("SignInFloorTem",{
        TemplateParent=parent,
        TemplatePrefab=self.panel.PointFloor.LuaUIGroup.gameObject,
        Data = data,
    })
    self.FloorTems[#self.FloorTems+1] = l_tem
    return l_tem
end
--lua custom scripts end
