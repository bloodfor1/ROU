--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/BoliFindPanel"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua fields
local super = UI.UIBaseCtrl

local l_boliModel = nil  --波利的模型
--next--
--lua fields end

--lua class define
BoliFindCtrl = class("BoliFindCtrl", super)
--lua class define end

--lua functions
function BoliFindCtrl:ctor()

    super.ctor(self, CtrlNames.BoliFind, UILayer.Function, nil, ActiveType.Exclusive)

    self.GroupMaskType = GroupMaskType.Show
    self.MaskColor=BlockColor.Dark
    self.ClosePanelNameOnClickMask=UI.CtrlNames.BoliFind

end --func end
--next--
function BoliFindCtrl:Init()

    self.panel = UI.BoliFindPanel.Bind(self)
    super.Init(self)

    --遮罩设置
    --self:SetBlockOpt(BlockColor.Dark, function()
    --    UIMgr:DeActiveUI(UI.CtrlNames.BoliFind)
    --end)

end --func end
--next--
function BoliFindCtrl:Uninit()

    --波利模型销毁
    if l_boliModel ~= nil then
        self:DestroyUIModel(l_boliModel);
        l_boliModel = nil
    end

    super.Uninit(self)
    self.panel = nil

end --func end
--next--
function BoliFindCtrl:OnActive()

    if self.uiPanelData then
        if self.uiPanelData.type == DataMgr:GetData("BoliGroupData").EUIOpenType.BoliFind then
            self:ShowBoliInfo(self.uiPanelData.boliId)
        end
    end

end --func end
--next--
function BoliFindCtrl:OnDeActive()


end --func end
--next--
function BoliFindCtrl:Update()


end --func end





--next--
function BoliFindCtrl:BindEvents()


end --func end

--next--
--lua functions end

--lua custom scripts
--展示波利
--boliId 波利Id
function BoliFindCtrl:ShowBoliInfo(boliId)
    --获取对应波利数据
    local l_boliInfo = TableUtil.GetElfTable().GetRowByID(boliId)
    if not l_boliInfo then
        UIMgr:DeActiveUI(UI.CtrlNames.BoliFind)
        return
    end
    --获取对应波利类型数据
    local l_showBoliTypeId = l_boliInfo.ElfTypeID
    local l_boliTypeInfo = TableUtil.GetElfTypeTable().GetRowByID(l_showBoliTypeId)
    if not l_boliTypeInfo then
        UIMgr:DeActiveUI(UI.CtrlNames.BoliFind)
        return
    end

    --发现文字的动画播放
    MLuaClientHelper.PlayFxHelper(self.panel.FindText.UObj)

    self.panel.BoliName.LabText = Lang("FIND_SOMETHING", l_boliTypeInfo.Name)

    self.panel.BtnIllustration:AddClick(function()
        local l_regionId = self.uiPanelData.boliInfo.region_id
        UIMgr:DeActiveUI(UI.CtrlNames.BoliFind)
        MgrMgr:GetMgr("BoliGroupMgr").ShowBoliIllustration(l_regionId)
        --MgrMgr:GetMgr("BoliGroupMgr").ShowBoliIllustration(l_showBoliTypeId)
    end)

    self:ShowBoliModel(l_boliTypeInfo)

end

function BoliFindCtrl:ShowBoliModel(boliTypeInfo)

    --不同波利的背景
    self.panel.BoliBg:SetRawTexAsync(boliTypeInfo.ShowBG, function ()
        self.panel.BoliBg.UObj:SetActiveEx(true)
    end, true)
    local l_entityData = TableUtil.GetEntityTable().GetRowById(boliTypeInfo.EntityID)
    if l_entityData == nil then
        return
    end
    local l_presentData = TableUtil.GetPresentTable().GetRowById(l_entityData.PresentID)
    if l_presentData == nil then
        return
    end
    --不同波利的模型
    local l_tempId = MUIModelManagerEx:GetTempUID()
    local l_attr = MAttrMgr:InitMonsterAttr(l_tempId, "BoliElf", boliTypeInfo.EntityID)

    local l_fxData = {}
    l_fxData.rawImage = self.panel.BoliShowView.RawImg
    l_fxData.attr = l_attr
    l_fxData.defaultAnim = MAnimationMgr:GetClipPath(l_presentData.IdleAnim) 

    l_boliModel = self:CreateUIModel(l_fxData)
    l_boliModel:AddLoadModelCallback(function(m)
        MLuaCommonHelper.SetRotEuler(m.UObj, 0, 180, 0)
        MLuaCommonHelper.SetLocalScale(m.UObj, 0.85, 0.85, 0.85)
        MLuaCommonHelper.SetLocalPos(m.UObj, 0, 0.95, 0)
        self.panel.BoliShowView.UObj:SetActiveEx(true)
    end)
    

end


--lua custom scripts end
return BoliFindCtrl