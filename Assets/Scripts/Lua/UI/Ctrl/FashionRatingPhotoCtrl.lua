--this file is gen by script
--you can edit this file in custom part

--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/FashionRatingPhotoPanel"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua fields
local super = UI.UIBaseCtrl
--next--
--lua fields end

--lua class define
FashionRatingPhotoCtrl = class("FashionRatingPhotoCtrl", super)
--lua class define end

--lua functions
function FashionRatingPhotoCtrl:ctor()

    super.ctor(self, CtrlNames.FashionRatingPhoto, UILayer.Function, UITweenType.Up, ActiveType.Standalone)
    self.GroupMaskType = GroupMaskType.Show
    self.MaskColor = BlockColor.Dark

end --func end
--next--
function FashionRatingPhotoCtrl:Init()

    self.panel = UI.FashionRatingPhotoPanel.Bind(self)
    super.Init(self)
    self.Mgr = MgrMgr:GetMgr("FashionRatingMgr")
    self.data = DataMgr:GetData("FashionData")

    self.panel.BtnClose:AddClick(function()
        UIMgr:DeActiveUI(CtrlNames.FashionRatingPhoto)
    end, true)

end --func end
--next--
function FashionRatingPhotoCtrl:Uninit()

    self:ClearRT()
    super.Uninit(self)
    self.panel = nil

end --func end
--next--
function FashionRatingPhotoCtrl:OnActive()

    if self.uiPanelData then
        if self.uiPanelData.openType == self.data.EUIOpenType.RATING_PHOTO then
            self:SetData({type = self.uiPanelData.type, rid = self.uiPanelData.rid, photo_id = self.uiPanelData.photoId, is_click_link = true, rank = -1})
        end
        if self.uiPanelData.openType == self.data.EUIOpenType.RATING_PHOTO_INCLUDE then
            self:SetData(self.uiPanelData.data)
        end
    end

end --func end
--next--
function FashionRatingPhotoCtrl:OnDeActive()


end --func end
--next--
function FashionRatingPhotoCtrl:Update()


end --func end

--next--
function FashionRatingPhotoCtrl:BindEvents()

    self:BindEvent(self.Mgr.EventDispatcher, self.Mgr.Event.DetailData, function(self, data)
        if data then
            self:SetData(data)
        end
    end)

end --func end
--next--
--lua functions end

--lua custom scripts
function FashionRatingPhotoCtrl:SetData(data)

    self.Data = data
    -- 公会聊天里面点击查看照片，不显示文字信息
    if self.Data.is_click_link ~= nil and self.Data.is_click_link then
        self.panel.TxtName:SetActiveEx(false)
        self.panel.TxtScore:SetActiveEx(false)
        self.panel.TxtJob:SetActiveEx(false)
    end
    if self.Data.name then
        self.panel.TxtName.LabText = self.Data.name
        self.panel.TxtScore.LabText = Lang("Fashion_Point", self.Data.score)
        local l_ProRow = TableUtil.GetProfessionTable().GetRowById(self.Data.type or 0, true)--实际职业
        self.panel.TxtJob.LabText = l_ProRow and l_ProRow.Name or "???"
        self:ShowRT()
    else
        self.panel.Model:SetActiveEx(false)
        local l_st = ""
        self.panel.TxtName.LabText = l_st
        self.panel.TxtScore.LabText = l_st
        self.panel.TxtJob.LabText = l_st
        if self.Data.is_click_link ~= nil and self.Data.is_click_link then
            self.Mgr.ChatShareC2M(self.Data.type, self.Data.rid)
            --self.Mgr.RequestRoleFashionScore({{rid = self.Data.rid, photo_id = self.Data.photo_id, rank = self.Data.rank}})
        else
            self.Mgr.RequestRoleFashionScore({{rid = self.Data.rid, photo_id = -1, rank = self.Data.rank}})
        end
    end

end

function FashionRatingPhotoCtrl:ShowRT()

    if self.model or not self.Data then
        return
    end

    local l_attr = MgrMgr:GetMgr("PlayerInfoMgr").GetAttribData(self.Data)
    local l_pos, l_scale,l_rotation = self.Data:GetPSR()
    if not l_pos then
        l_pos = {x = 0, y = -1.51, z = -0.17}
        l_scale = {x = 1.9, y = 1.9, z = 1.9}
        l_rotation = {x = -10.295, y = 180, z = 0}
    end
    local l_vMat, l_pMat = self.Data:GetMatData()
    local l_fxData = {}
    l_fxData.rawImage = self.panel.Model.RawImg
    l_fxData.attr = l_attr
    l_fxData.useShadow = false
    l_fxData.useOutLine = false
    l_fxData.useCustomLight = true
    l_fxData.isOneFrame = true
    if l_pMat and l_vMat then
        l_fxData.isCameraMatrixCustom = true
        l_fxData.vMatrix = l_vMat
        l_fxData.pMatrix = l_pMat
        local l_rotEul = MUIModelManagerEx:GetRotationEulerByViewMatrix(l_vMat)
        l_fxData.customLightDirX = 0
        l_fxData.customLightDirY = l_rotEul.y - 180
        l_fxData.customLightDirZ = 0
    end
    l_fxData.position = Vector3.New(l_pos.x, l_pos.y, l_pos.z)
    l_fxData.scale = Vector3.New(l_scale.x, l_scale.y, l_scale.z)
    l_fxData.rotation = Quaternion.Euler(l_rotation.x, l_rotation.y, l_rotation.z)

    self.panel.Model:SetActiveEx(false)
    self.model = self:CreateUIModel(l_fxData)
    

    local l_animKey, l_animPath, l_animTime = self.Data:GetAnimInfo()
    l_animKey = l_animKey or "Idle"
    l_animPath = l_animPath or l_attr.CommonIdleAnimPath
    l_animTime = l_animTime or 0
    self.model.Ator:OverrideAnim(l_animKey, l_animPath)
    self.model.Ator:Play(l_animKey, l_animTime)
    self.model.Ator.Speed = 0
    
    local l_emotion1, l_emotion2 = self.Data:GetEmotion()
    if l_emotion1 and l_emotion2 then
        self.model:ChangeEmotion(l_emotion1, l_emotion2, 999999)
    end

    self.model:AddLoadModelCallback(function(m)
        self.panel.Model:SetActiveEx(true) 
    end)

end

function FashionRatingPhotoCtrl:ClearRT()

    if not self.model then
        return
    end
    self.panel.Model:SetActiveEx(false)
    if self.model then
        self:DestroyUIModel(self.model)
        self.model = nil
    end

end
--lua custom scripts end
return FashionRatingPhotoCtrl