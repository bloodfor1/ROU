--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/FashionRatingMainPanel"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua fields
local super = UI.UIBaseCtrl
--next--
--lua fields end

--lua class define
FashionRatingMainCtrl = class("FashionRatingMainCtrl", super)
--lua class define end

--lua functions
function FashionRatingMainCtrl:ctor()

    super.ctor(self, CtrlNames.FashionRatingMain, UILayer.Function, UITweenType.UpAlpha, ActiveType.Exclusive)
    self.GroupMaskType = GroupMaskType.Show
    self.MaskColor = BlockColor.Dark
    --self:SetBlockOpt(BlockColor.Dark)

end --func end
--next--
function FashionRatingMainCtrl:Init()

    self.panel = UI.FashionRatingMainPanel.Bind(self)
    super.Init(self)
    self.Mgr = MgrMgr:GetMgr("FashionRatingMgr")
    self.data = DataMgr:GetData("FashionData")

    self.panel.BtnClose:AddClick(function()
        UIMgr:DeActiveUI(CtrlNames.FashionRatingMain)
    end,true)

    self.panel.BtnOpen:AddClick(function()
        UIMgr:ActiveUI(CtrlNames.FashionRating)
    end, true)

    self.panel.PlayerInfo.Btn:AddClick(function()
        if self.MainData and self.MainData.rid then
            Common.CommonUIFunc.RefreshPlayerMenuLByUid(self.MainData.rid)
        end
    end, true)

    self.panel.PlayerInfo.Model:SetActiveEx(false)

end --func end
--next--
function FashionRatingMainCtrl:Uninit()

    super.Uninit(self)
    self.panel = nil
    self.MainData = nil
    if self.PlayerModel then
        self:DestroyUIModel(self.PlayerModel)
        self.PlayerModel = nil
    end

end --func end
--next--
function FashionRatingMainCtrl:OnActive()

    self.data.NowChooseTheme = self.uiPanelData
    self.Mgr.RequestFashionMagazine(self.uiPanelData)

end --func end
--next--
function FashionRatingMainCtrl:OnDeActive()

end --func end
--next--
function FashionRatingMainCtrl:Update()

end --func end

--next--
function FashionRatingMainCtrl:BindEvents()
    --刷新所有数据
    self:BindEvent(self.Mgr.EventDispatcher, self.Mgr.Event.ResetData, function(self)
        self:ResetData()
    end)
    self:BindEvent(self.Mgr.EventDispatcher, self.Mgr.Event.DetailData, function(self, data)
        if data.rid == self.MainData.rid and data.rank == self.MainData.rank then
            self:ResetData()
        end
    end)

end --func end
--next--
--lua functions end

--lua custom scripts
function FashionRatingMainCtrl:ShowMain(obj)
    self.panel.PanelMain:SetActiveEx(obj)
end

function FashionRatingMainCtrl:ResetData()

    if self.data.JournalTheme then
        local l_themeRow = TableUtil.GetFashionThemeTable().GetRowByID(self.data.JournalTheme, true)
        self.panel.TxtThemeName.LabText = l_themeRow and l_themeRow.Name or tostring(self.data.JournalTheme)
        self.panel.ThemeRound.LabText = tostring(self.data.JournalRound)
    end

    local l_dataLis = self.data.GetSortData()
    self.MainData = (#l_dataLis > 0) and l_dataLis[1] or nil
    self.panel.BtnOpen:SetActiveEx(#l_dataLis > 1)
    if self.MainData then
        if self.MainData.name then
            self.panel.PlayerInfo.TxtName.LabText = self.MainData.name
            self.panel.PlayerInfo.TxtScore.LabText = Lang("Fashion_Point", self.MainData.score)
            local l_ProRow = TableUtil.GetProfessionTable().GetRowById(self.MainData.type or 0, true)--实际职业
            self.panel.PlayerInfo.TxtJob.LabText = l_ProRow and l_ProRow.Name or "???"
            self.panel.PlayerInfo.TxtRank.LabText = "1st"
            self.panel.PlayerInfo.TxtPoint.LabText = self.MainData.outlook.fashion_count
            self:ShowModel(true)
        else
            self.Mgr.RequestRoleFashionScore({{rid = self.MainData.rid, photo_id = -1, rank = self.MainData.rank}}, self.data.NowChooseTheme)
        end
    else
        self.panel.PlayerInfo.Model:SetActiveEx(false)
        local l_st = ""
        self.panel.PlayerInfo.TxtName.LabText = l_st
        self.panel.PlayerInfo.TxtScore.LabText = l_st
        self.panel.PlayerInfo.TxtJob.LabText = l_st
        self.panel.PlayerInfo.TxtRank.LabText = "1st"
        self.panel.PlayerInfo.TxtPoint.LabText = l_st
        self:ShowModel(false)
    end

end

function FashionRatingMainCtrl:ShowModel(objData)

    if not self.panel then
        return
    end
    objData = objData and self.MainData
    if self.PlayerModel and not objData then
        self:DestroyUIModel(self.PlayerModel)
        self.PlayerModel = nil
        self.panel.PlayerInfo.Model:SetActiveEx(false)
    end

    if not self.PlayerModel and objData then
        local l_attr = MgrMgr:GetMgr("PlayerInfoMgr").GetAttribData(self.MainData)
        local l_pos, l_scale, l_rotation = self.MainData:GetPSR()  --拍照时玩家的坐标 缩放 旋转获取
        if not l_pos then
            l_pos = {x = 0, y = -1.51, z = -0.17}
            l_scale = {x = 1.9, y = 1.9, z = 1.9}
            l_rotation = {x = -10.295, y = 180, z = 0}
        end
        local l_vMat, l_pMat = self.MainData:GetMatData()  --拍照时相机的观察矩阵和投影矩阵获取
        local l_fxData = {}
        l_fxData.rawImage = self.panel.PlayerInfo.Model.RawImg
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

        self.panel.PlayerInfo.Model:SetActiveEx(false)
        self.PlayerModel = self:CreateUIModel(l_fxData)
        

        local l_animKey, l_animPath, l_animTime = self.MainData:GetAnimInfo()
        l_animKey = l_animKey or "Idle"
        l_animPath = l_animPath or l_attr.CommonIdleAnimPath
        l_animTime = l_animTime or 0
        self.PlayerModel.Ator:OverrideAnim(l_animKey, l_animPath)
        self.PlayerModel.Ator:Play(l_animKey, l_animTime)
        self.PlayerModel.Ator.Speed = 0

        local l_emotion1, l_emotion2 = self.MainData:GetEmotion()
        if l_emotion1 and l_emotion2 then
            self.PlayerModel:ChangeEmotion(l_emotion1, l_emotion2, 999999)
        end

        self.PlayerModel:AddLoadModelCallback(function(m)
            self.panel.PlayerInfo.Model:SetActiveEx(true)        
        end)
    end

end
return FashionRatingMainCtrl
--lua custom scripts end
