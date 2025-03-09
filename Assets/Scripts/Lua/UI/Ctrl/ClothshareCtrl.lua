--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/ClothsharePanel"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua fields
local super = UI.UIBaseCtrl
--next--
--lua fields end

--lua class define
ClothshareCtrl = class("ClothshareCtrl", super)
--lua class define end

--lua functions
function ClothshareCtrl:ctor()
    super.ctor(self, CtrlNames.Clothshare, UILayer.Function, nil, ActiveType.Standalone)
    self.GroupMaskType = GroupMaskType.Show
    self.MaskColor = BlockColor.Transparent
    self.ClosePanelNameOnClickMask = UI.CtrlNames.Clothshare
end --func end
--next--
function ClothshareCtrl:Init()

    self.panel = UI.ClothsharePanel.Bind(self)
    super.Init(self)

    --遮罩设置
    --self:SetBlockOpt(BlockColor.Transparent, function()
    --	UIMgr:DeActiveUI(self.name)
    --end)
end --func end
--next--
function ClothshareCtrl:Uninit()
    self:ClearModel()
    super.Uninit(self)
    self.panel = nil

end --func end
--next--
function ClothshareCtrl:OnActive()
    if self.uiPanelData ~= nil then
        if self.uiPanelData.isLocalPlan then
            self:ShowClothPlan(true, 0, nil, nil)
        else
            self:ShowClothPlan(false, self.uiPanelData.planId, self.uiPanelData.memberBaseInfo, self.uiPanelData.shareData)
        end
    end
end --func end
--next--
function ClothshareCtrl:OnDeActive()


end --func end
--next--
function ClothshareCtrl:Update()


end --func end





--next--
function ClothshareCtrl:BindEvents()


end --func end

--next--
--lua functions end

--lua custom scripts
function ClothshareCtrl:ShowClothPlan(isLocalPlan, planId, MemberBaseInfo, wardrobeShare)
    self.panel.mod.gameObject:SetActiveEx(false)
    self:ClearModel()
    if isLocalPlan then
        --本地方案（暂无多方案，故planId可忽略）
        self:ShowLocalClothPlan(planId)
    else
        self:ShowOtherClothPlan(planId, MemberBaseInfo, wardrobeShare)
    end

    local listener = self.panel.touchArea.Listener
    listener.onDrag = function(uobj, event)
        if self.model and self.model.Trans then
            self.model.Trans:Rotate(Vector3.New(0, -event.delta.x, 0))
        end
    end
end
function ClothshareCtrl:ShowOtherClothPlan(planId, MemberBaseInfo, wardrobeShare)
    if wardrobeShare == nil then
        logError("ClothshareCtrl:ShowOtherClothPlan 衣橱分享数据为空！")
        return
    end
    self:UpdateBaseInfo(wardrobeShare.collection, wardrobeShare.head, wardrobeShare.face, wardrobeShare.mouth, wardrobeShare.back, wardrobeShare.tail, wardrobeShare.fashion)
    if MemberBaseInfo == nil then
        return
    end
    self.panel.Title.LabText = Lang("CLOTH_SHARE_TITLE", MemberBaseInfo.data.name)
    self.panel.mod.gameObject:SetActiveEx(false)
    local l_attr = MemberBaseInfo:GetAttribData()
    self:ShowModel(l_attr)
end
function ClothshareCtrl:ShowLocalClothPlan(planId)
    self.panel.Title.LabText =Lang("CLOTH_SHARE_TITLE", MPlayerInfo.Name)

    local l_garderobeMgr = MgrProxy:GetGarderobeMgr()
    local l_clothNums, l_totalPoint = l_garderobeMgr.GetClothShareInfo()
    local l_headNum = l_clothNums[l_garderobeMgr.EOrnamentType.Head]
    local l_faceNum = l_clothNums[l_garderobeMgr.EOrnamentType.Face]
    local l_mouthNum = l_clothNums[l_garderobeMgr.EOrnamentType.Mouth]
    local l_backNum = l_clothNums[l_garderobeMgr.EOrnamentType.Back]
    local l_tailNum = l_clothNums[l_garderobeMgr.EOrnamentType.Tail]
    local l_fashionNum = l_clothNums[l_garderobeMgr.EOrnamentType.Fashion]
    self:UpdateBaseInfo(l_totalPoint, l_headNum, l_faceNum, l_mouthNum, l_backNum, l_tailNum, l_fashionNum)

    -- 试穿模型
    local l_attr = MgrMgr:GetMgr("GarderobeMgr").GetRoleAttr(self.name)
    self:ShowModel(l_attr)
end
function ClothshareCtrl:ShowModel(attr)
    if attr == nil then
        return
    end
    local l_fxData = {}
    l_fxData.rawImage = self.panel.mod.RawImg
    l_fxData.attr = attr
    l_fxData.useShadow = false
    l_fxData.defaultAnim = MgrMgr:GetMgr("GarderobeMgr").GetRoleAnim(attr)

    self.model = self:CreateUIModel(l_fxData)
    self.model.Scale = Vector3.New(1.2, 1.2, 1.2)
    self.model:AddLoadModelCallback(function(m)
        self.panel.mod.gameObject:SetActiveEx(true)
    end)
    
end
function ClothshareCtrl:UpdateBaseInfo(storageValue, headClothNum, faceClothNum, mouthClothNum, backClothNum, tailClothNum, fashionClothNum)
    self.panel.StorageValue.LabText = storageValue
    self.panel.headClothNum.LabText = headClothNum
    self.panel.faceClothNum.LabText = faceClothNum
    self.panel.mouthClothNum.LabText = mouthClothNum
    self.panel.backClothNum.LabText = backClothNum
    --self.panel.tailClothNum.LabText = tailClothNum
    self.panel.fashionClothNum.LabText = fashionClothNum
end

function ClothshareCtrl:ClearModel()
    if self.model ~= nil then
        self:DestroyUIModel(self.model)
        self.model = nil
    end
end
--lua custom scripts end
return ClothshareCtrl