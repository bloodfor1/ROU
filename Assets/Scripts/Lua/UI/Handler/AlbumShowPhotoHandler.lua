--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseHandler"
require "UI/Panel/AlbumShowPhotoPanel"

--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua class define
local super = UI.UIBaseHandler
AlbumShowPhotoHandler = class("AlbumShowPhotoHandler", super)
--lua class define end

--lua functions
function AlbumShowPhotoHandler:ctor()

    super.ctor(self, HandlerNames.AlbumShowPhoto, UILayer.Function)

end --func end
--next--
function AlbumShowPhotoHandler:Init()

    self.panel = UI.AlbumShowPhotoPanel.Bind(self)
    super.Init(self)
    self.panel.BtnEdit:AddClick(function() self:OnEdit() end)
    self.panel.BtnBack:AddClick(function() self:OnBack() end)
    self.panel.BtnShare:AddClick(function() self:OnShare() end)
    self.panel.BtnChangeAlbum:AddClick(function() self:OnChangeAlbum() end)
    self.panel.BtnDelete:AddClick(function() self:OnDeletePhoto() end)
    self.photoTable = {}
    self.panel.EditPanel.gameObject:SetActiveEx(false)
    self.panel.NoData.gameObject:SetActiveEx(false)
end --func end
--next--
function AlbumShowPhotoHandler:Uninit()
    super.Uninit(self)
    self.panel = nil

end --func end
--next--
function AlbumShowPhotoHandler:OnActive()

    self.editMode = false
    self:RefreshPhoto()
    self.selectedPhoto = {}

end --func end
--next--
function AlbumShowPhotoHandler:OnDeActive()

    for path,photoInstance in pairs(self.photoTable) do
        MResLoader:DestroyObj(photoInstance.gameObject)
    end
    self.photoTable = {}

end --func end
--next--
function AlbumShowPhotoHandler:Update()


end --func end


--next--
function AlbumShowPhotoHandler:BindEvents()

    self:BindEvent(GlobalEventBus,EventConst.Names.RefreshPhoto, function()
        self:RefreshPhoto()
    end)

end --func end
--next--
--lua functions end

--lua custom scripts
function AlbumShowPhotoHandler:OnShow()
    self:RefreshPhoto()
end
function AlbumShowPhotoHandler:RefreshPhoto()

    for path,photoInstance in pairs(self.photoTable) do
        MResLoader:DestroyObj(photoInstance.gameObject)
    end
    self.photoTable = {}

    local l_photoFiles = Directory.GetFiles(MgrMgr:GetMgr("AlbumMgr").GetAlbumRoot(), "*.png", System.IO.SearchOption.AllDirectories)
    self.panel.NoData.gameObject:SetActiveEx(l_photoFiles.Length-1<0)
    for i=0,l_photoFiles.Length-1 do
        local l_currentPhoto = l_photoFiles[i]
        local l_path = l_photoFiles[i]

        local l_message = MgrMgr:GetMgr("AlbumMgr").GetPhotoMessage(l_photoFiles[i])
        local l_photoObject = self:CreatePhotoInstance(l_path, l_message)
        l_photoObject.transform:SetParent(self.panel.PhotoContent.transform)
        l_photoObject.transform:SetLocalScaleOne()
        self.photoTable[l_path] = l_photoObject
    end

end

---------------------------创建照片实例-------------------------------------

function AlbumShowPhotoHandler:CreatePhotoInstance(path, message)

    local l_newPhoto = {}
    local l_newPhotoGameObject = self:CloneObj(self.panel.InstancePhoto.gameObject)
    l_newPhotoGameObject:SetActiveEx(true)

    l_newPhoto.gameObject = l_newPhotoGameObject
    l_newPhoto.transform = l_newPhotoGameObject.transform
    l_newPhoto.path = path
    l_newPhoto.btn = l_newPhotoGameObject:GetComponent("MLuaUICom")
    l_newPhoto.com = l_newPhotoGameObject.transform:Find("Photo/Photo").gameObject:GetComponent("MLuaUICom")
    l_newPhoto.text = MLuaClientHelper.GetOrCreateMLuaUICom(l_newPhotoGameObject.transform:Find("Photo/IntroduceButtom/Introduce").gameObject)
    l_newPhoto.selectTog = l_newPhotoGameObject.transform:Find("Photo/Tog").gameObject:GetComponent("MLuaUICom")
    l_newPhoto.selectTog.gameObject:SetActiveEx(self.editMode)
    l_newPhoto.selectTog.Tog.isOn = false

    l_newPhoto.selectTog:OnToggleChanged(function(on)
        if on then
            self:AddSelectPhoto(l_newPhoto)
        else
            self:RemoveSelectPhoto(l_newPhoto)
        end
    end)

    l_newPhoto.nativeImg = MgrMgr:GetMgr("AlbumMgr").GetPhotoTexture(path .. ".mip")
    l_newPhoto.com:SetNativeTexture(l_newPhoto.nativeImg)
    
    local l_photoDateInfo=MPlayerInfo.albumInfo:GetPhotoDateInfo(path)
    local l_photoPlaceInfo=MgrMgr:GetMgr("AlbumMgr").DecodeAlbumName(MPlayerInfo.albumInfo:GetPhotoPlaceInfo(path))
    l_newPhoto.text.LabText = l_photoDateInfo .." "..l_photoPlaceInfo

    l_newPhoto.message = l_newPhoto.text.LabText

    l_newPhoto.com:AddClick(function()
        if self.editMode then
            l_newPhoto.selectTog.Tog.isOn = not l_newPhoto.selectTog.Tog.isOn
        else
            MgrMgr:GetMgr("AlbumMgr").OpenPhotoByPath(path, UI.CtrlNames.Album, false)
        end
    end)

    return l_newPhoto

end

---------------------------创建照片实例-------------------------------------
---------------------------选择照片-----------------------------------------

function AlbumShowPhotoHandler:AddSelectPhoto(photoInstance)
    self.selectedPhoto[photoInstance.path] = photoInstance
    self:OnSelectedPhotoChange()
end

function AlbumShowPhotoHandler:RemoveSelectPhoto(photoInstance)
    self.selectedPhoto[photoInstance.path] = nil
    self:OnSelectedPhotoChange()
end

function AlbumShowPhotoHandler:OnSelectedPhotoChange()

    local l_btnShare = self.panel.BtnShare
    local l_btnChangeAlbum = self.panel.BtnChangeAlbum
    local l_btnDelete = self.panel.BtnDelete
    if self:GetSelectedPhotoNumber() == 0 then
        l_btnShare:SetGray(false)
        l_btnChangeAlbum:SetGray(false)
        l_btnDelete:SetGray(false)
    elseif self:GetSelectedPhotoNumber() == 1 then
        l_btnShare:SetGray(false)
        l_btnChangeAlbum:SetGray(false)
        l_btnDelete:SetGray(false)
    else
        l_btnShare:SetGray(true)
        l_btnChangeAlbum:SetGray(false)
        l_btnDelete:SetGray(false)
    end

end

---------------------------选择照片-----------------------------------------
---------------------------事件回调----------------------------------------


function AlbumShowPhotoHandler:OnEdit()

    self.editMode = true
    self.selectedPhoto = {}
    self.panel.BtnEdit.gameObject:SetActiveEx(false)
    self.panel.BtnBack.gameObject:SetActiveEx(true)
    self.panel.EditPanel.gameObject:SetActiveEx(true)
    for path,photoInstance in pairs(self.photoTable) do
        photoInstance.selectTog.gameObject:SetActiveEx(true)
        photoInstance.selectTog.Tog.isOn = false
    end
    self:OnSelectedPhotoChange()
end

function AlbumShowPhotoHandler:OnBack()

    self.editMode = false
    self.selectedPhoto = {}
    self.panel.BtnEdit.gameObject:SetActiveEx(true)
    self.panel.BtnBack.gameObject:SetActiveEx(false)
    self.panel.EditPanel.gameObject:SetActiveEx(false)
    for path,photoInstance in pairs(self.photoTable) do
        photoInstance.selectTog.gameObject:SetActiveEx(false)
        photoInstance.selectTog.Tog.isOn = false
    end
end

function AlbumShowPhotoHandler:OnShare()
    if self:GetSelectedPhotoNumber() == 0 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("PHOTOGRAPH_PLEASE_SELECT_PHOTO"))
    elseif self:GetSelectedPhotoNumber() == 1 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("NOT_OPEN_PLEASE_WAITTING"))
    else
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("PHOTOGRAPH_SHARE_NEED_SINGLE_PHOTO"))
    end
end

function AlbumShowPhotoHandler:OnChangeAlbum()
    if self:GetSelectedPhotoNumber() == 0 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("PHOTOGRAPH_PLEASE_SELECT_PHOTO"))
    else
        CommonUI.Dialog.ShowYesNoDropDownDlg(true, Lang("PHOTOGRAPH_SELECT_ALBUM"), MgrMgr:GetMgr("AlbumMgr").GetAlbumNameList(),
        nil, nil, function(albumName)
            CommonUI.Dialog.ShowYesNoDlg(true, nil, Common.Utils.Lang("ALBUM_TIP_MOVE_PHOTO_COMFIRM", albumName), function()
                for path,photo in pairs(self.selectedPhoto) do
                    local l_newPath = MgrMgr:GetMgr("AlbumMgr").MovePhoto(path, albumName)
                    self.photoTable[l_newPath] = photo
                    self.photoTable[photo.path] = nil
                    photo.path = l_newPath
                end
                for path,photoInstance in pairs(self.photoTable) do
                    photoInstance.selectTog.Tog.isOn = false
                    self.selectedPhoto = {}
                end
                MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("PHOTOGRAPH_MOVE_ALBUM_SUCC"))
            end, function()
            end)
        end, function()
        end)
    end
end

function AlbumShowPhotoHandler:OnDeletePhoto()
    if self:GetSelectedPhotoNumber() == 0 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("PHOTOGRAPH_PLEASE_SELECT_PHOTO"))
    else
        CommonUI.Dialog.ShowYesNoDlg(true, nil, Common.Utils.Lang("ALBUM_TIP_DELETE_PHOTO_COMFIRM"), function()
            for path,photo in pairs(self.selectedPhoto) do
                --删除时不发送消息，防止频繁刷新
                MgrMgr:GetMgr("AlbumMgr").RemovePhotoWithoutMessage(path)
            end
            self:RefreshPhoto()
            GlobalEventBus:Dispatch(EventConst.Names.PhotoNumberChange)
        end, function()
        end)
    end
end
---------------------------事件回调----------------------------------------
-------------------------------常用函数---------------------------

function AlbumShowPhotoHandler:GetSelectedPhotoNumber()
    local l_number = 0
    for k,v in pairs(self.selectedPhoto) do
        l_number = l_number + 1
    end
    return l_number
end

-- function AlbumShowPhotoHandler:DestroyPhoto(photo)
--     Object.Destroy(photo.texture)
--     MResLoader:DestroyObj(photo.gameObject)
--     self.photoTable[photo.path] = nil

-- end


-------------------------------常用函数---------------------------
--lua custom scripts end
return AlbumShowPhotoHandler