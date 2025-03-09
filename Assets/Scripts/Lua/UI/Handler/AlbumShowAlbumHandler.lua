--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseHandler"
require "UI/Panel/AlbumShowAlbumPanel"

--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua class define
local super = UI.UIBaseHandler
AlbumShowAlbumHandler = class("AlbumShowAlbumHandler", super)
--lua class define end

--lua functions
function AlbumShowAlbumHandler:ctor()

    super.ctor(self, HandlerNames.AlbumShowAlbum, UILayer.Function)

end --func end
--next--
function AlbumShowAlbumHandler:Init()

    self.panel = UI.AlbumShowAlbumPanel.Bind(self)
    super.Init(self)
    self.albumTable = {}
    self.panel.BtnEdit:AddClick(function()
        self:OnEdit()
    end)
    self.panel.BtnBack:AddClick(function()
        self:OnBack()
    end)
    self.panel.BtnShare:AddClick(function()
        self:OnShareAlbum()
    end)
    self.panel.BtnEditName:AddClick(function()
        self:OnEditAlbumName()
    end)
    self.panel.BtnDelete:AddClick(function()
        self:OnDeleteAlbum()
    end)
    self.panel.BtnAddAlbum:AddClick(function()
        self:OnAddAlbum()
    end)

end --func end
--next--
function AlbumShowAlbumHandler:Uninit()

    super.Uninit(self)
    self.panel = nil

end --func end
--next--
function AlbumShowAlbumHandler:OnActive()

    self.editMode = false
    self.selectedAlbum = nil
    self.panel.EditPanel:SetActiveEx(false)
    self:RefreshAlbums()

end --func end
--next--
function AlbumShowAlbumHandler:OnDeActive()


end --func end
--next--
function AlbumShowAlbumHandler:Update()


end --func end


--next--
function AlbumShowAlbumHandler:BindEvents()

    self:BindEvent(GlobalEventBus, EventConst.Names.PhotoNumberChange, function(self)
        self:RefreshAlbums()
    end)

end --func end
--next--
function AlbumShowAlbumHandler:OnShow()
    self:RefreshAlbums()
end--func end

--lua functions end

--lua custom scripts
-------------------------------相册对象---------------------------

function AlbumShowAlbumHandler:RefreshAlbums()

    local content = self.panel.AlbumContent.transform
    local childCount = content.childCount
    for i = childCount - 1, 0, -1 do
        local currentChild = content:GetChild(i)
        if currentChild.gameObject.activeSelf then
            if currentChild.gameObject.name ~= "DefaultAlbum" and
                    currentChild.gameObject.name ~= "LoverAlbum" and
                    currentChild.gameObject.name ~= "BtnAddAlbum" then
                MResLoader:DestroyObj(currentChild.gameObject)
            end
        end
    end

    local photoNumber = 0
    self.albumTable = {}

    local defaultAlbumName = MgrMgr:GetMgr("AlbumMgr").defaultAlbumName
    local loverAlbumName = MgrMgr:GetMgr("AlbumMgr").loverAlbumName

    self.defaultAlbum = self:GetAlbum(self.panel.DefaultAlbum, defaultAlbumName)
    self:AddAlbum(self.defaultAlbum)
    photoNumber = photoNumber + MgrMgr:GetMgr("AlbumMgr").GetPhotoNumber(defaultAlbumName)

    if MgrMgr:GetMgr("AlbumMgr").HasLoverAlbum() then
        self.loverAlbum = self:GetAlbum(self.panel.loverAlbum, loverAlbumName)
        self:AddAlbum(self.loverAlbum)
        photoNumber = photoNumber + MgrMgr:GetMgr("AlbumMgr").GetPhotoNumber(loverAlbumName)
        self.loverAlbum.gameObject:SetActiveEx(true)
    end

    local albumFolders = Directory.GetDirectories(MgrMgr:GetMgr("AlbumMgr").GetAlbumRoot())
    for i = 0, albumFolders.Length - 1 do
        local l_folderName = MoonCommonLib.PathEx.GetShortName(albumFolders[i])
        if l_folderName ~= MgrMgr:GetMgr("AlbumMgr").EncodeAlbumName(defaultAlbumName) and
                l_folderName ~= MgrMgr:GetMgr("AlbumMgr").EncodeAlbumName(loverAlbumName) then

            local retCode, pcallValue = pcall(function()
                return MgrMgr:GetMgr("AlbumMgr").DecodeAlbumName(l_folderName)
            end)
            local l_albumName
            if retCode then
                l_albumName = pcallValue
            else
                logError("相册名解码有错误")
            end
            if l_albumName then
                local newAlbum = self:CreateAlbum(l_albumName)
                self:AddAlbum(newAlbum)
                photoNumber = photoNumber + MgrMgr:GetMgr("AlbumMgr").GetPhotoNumber(l_albumName)
            end
        end
    end


end

--创建相册按钮
function AlbumShowAlbumHandler:CreateAlbum(name)

    name = StringEx.DeleteEmoji(name)
    local l_instance = self.panel.InstanceAlbum
    local l_newInstance = self:CloneObj(l_instance.gameObject):GetComponent("MLuaUICom")

    local l_albumPath = MgrMgr:GetMgr("AlbumMgr").GetAlbumPath(name)

    if not Directory.Exists(l_albumPath) then
        Directory.CreateDirectory(l_albumPath)
    end

    return self:GetAlbum(l_newInstance, name)

end

--获取相册
function AlbumShowAlbumHandler:GetAlbum(uiCom, name)

    local l_albumInstance = {}
    l_albumInstance.com = uiCom
    l_albumInstance.name = name or ""
    l_albumInstance.photoNumber = MgrMgr:GetMgr("AlbumMgr").GetPhotoNumber(name)
    l_albumInstance.gameObject = uiCom.gameObject
    l_albumInstance.isDefaultAlbum = self:IsDefaultAlbumGameObjectName(l_albumInstance.gameObject.name)
    l_albumInstance.transform = uiCom.transform
    l_albumInstance.introduceText = MLuaClientHelper.GetOrCreateMLuaUICom(uiCom.transform:Find("IntroduceButtom/Introduce").gameObject)
    l_albumInstance.introduceText.LabText = name .. ": " .. tostring(l_albumInstance.photoNumber)
    l_albumInstance.selectTog = uiCom.transform:Find("Tog").gameObject:GetComponent("MLuaUICom")
    l_albumInstance.selectTog.gameObject:SetActiveEx(self.editMode)
    l_albumInstance.selectTog.Tog.isOn = false

    l_albumInstance.selectTog:OnToggleChanged(function(on)
        if on then
            if self.selectedAlbum ~= nil then
                self.selectedAlbum.selectTog.Tog.isOn = false
                self:SetCurrentSelectAlbum(nil)
            end
            self:SetCurrentSelectAlbum(l_albumInstance)
        else
            if self.selectedAlbum == l_albumInstance then
                self:SetCurrentSelectAlbum(nil)
            end
        end
    end)

    uiCom:AddClick(function()
        if self.editMode then
            l_albumInstance.selectTog.Tog.isOn = not l_albumInstance.selectTog.Tog.isOn
        else
            --UIMgr:DeActiveUI(UI.CtrlNames.Album)
            MgrMgr:GetMgr("AlbumMgr").ShowAlbum(l_albumInstance.name)
        end
    end)

    return l_albumInstance

end

--加相册
function AlbumShowAlbumHandler:AddAlbum(album)
    self.albumTable[album.name] = album

    album.gameObject:SetActiveEx(true)
    album.transform:SetParent(self.panel.AlbumContent.transform)
    album.transform:SetAsLastSibling()
    album.transform:SetLocalScaleOne()
    self.panel.BtnAddAlbum.transform:SetAsLastSibling()

    local l_albumPath = MgrMgr:GetMgr("AlbumMgr").GetAlbumPath(album.name)
    if not Directory.Exists(l_albumPath) then
        StringEx.PrintBadChar(l_albumPath)
        Directory.CreateDirectory(l_albumPath)
    end
end

function AlbumShowAlbumHandler:RemoveAlbum(album)
    if album == nil then
        return
    end
    local l_albumName = album.name
    if l_albumName == nil then
        return
    end
    if self.albumTable[l_albumName] == nil then
        return
    end
    self.albumTable[l_albumName] = nil
    MgrMgr:GetMgr("AlbumMgr").RemoveAlbum(l_albumName)
    MResLoader:DestroyObj(album.gameObject)
end

function AlbumShowAlbumHandler:RenameAlbum(album, newName)
    self.albumTable[newName] = self.albumTable[album.name]
    self.albumTable[album.name] = nil
    MgrMgr:GetMgr("AlbumMgr").AlbumReName(album.name, newName)
    album.name = newName
    self:RefreshAlbums()
end

-------------------------------相册对象---------------------------
-------------------------------按钮回调---------------------------

function AlbumShowAlbumHandler:OnAddAlbum()

    CommonUI.Dialog.ShowYesNoInputDlg(true, Lang("ALBUM_NEW_ALBUM"),
            Common.Utils.Lang("ALBUM_MAX_ALBUM_NAME_LENGTH"),
            Common.Utils.Lang("DLG_BTN_YES"),
            Common.Utils.Lang("DLG_BTN_NO"), function(txt)
                txt = StringEx.DeleteEmoji(txt)
                local l_error = MgrMgr:GetMgr("AlbumMgr").IsValidName(txt)
                if l_error == nil then
                    local ForbidTextMgr = require("ModuleMgr.ForbidTextMgr")
                    ForbidTextMgr.RequestJudgeTextForbid(txt, function(checkInfo)
                        local l_resultCode = checkInfo.result
                        if l_resultCode ~= 0 then
                            --判断服务器是否判断失败 如果失败什么都不发生
                            if l_resultCode == ErrorCode.ERR_FAILED then
                                logError("屏蔽词服务器判断失败！！！！")
                                return
                            end
                            --含有屏蔽字则提示
                            MgrMgr:GetMgr("TipsMgr").ShowErrorCodeTips(l_resultCode)
                            return
                        end
                        local l_name = checkInfo.text
                        local l_tryCreateError = MgrMgr:GetMgr("AlbumMgr").IsValidName(l_name)
                        if l_tryCreateError ~= nil then
                            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(l_tryCreateError)
                            return
                        end
                        if self.panel == nil or l_name == nil or l_name == "" then
                            logError("返回名称为空！！！！")
                            return
                        end
                        local l_newAlbumInstance = self:CreateAlbum(l_name)
                        self:AddAlbum(l_newAlbumInstance)
                    end)
                else
                    MgrMgr:GetMgr("TipsMgr").ShowNormalTips(l_error)
                end
            end, function()

            end)

end

function AlbumShowAlbumHandler:OnEdit()

    self.editMode = true
    self:SetCurrentSelectAlbum(nil)
    self.panel.EditPanel.gameObject:SetActiveEx(true)
    self.panel.BtnBack.gameObject:SetActiveEx(true)
    self.panel.BtnEdit.gameObject:SetActiveEx(false)
    for _, albumInstance in pairs(self.albumTable) do
        albumInstance.selectTog.gameObject:SetActiveEx(true)
        albumInstance.selectTog.Tog.isOn = false
    end
    self:UpdateEditPanel()

end

function AlbumShowAlbumHandler:OnBack()

    self.editMode = false
    self:SetCurrentSelectAlbum(nil)
    self.panel.EditPanel.gameObject:SetActiveEx(false)
    self.panel.BtnBack.gameObject:SetActiveEx(false)
    self.panel.BtnEdit.gameObject:SetActiveEx(true)
    for _, albumInstance in pairs(self.albumTable) do
        albumInstance.selectTog.gameObject:SetActiveEx(false)
        albumInstance.selectTog.Tog.isOn = false
    end
end

function AlbumShowAlbumHandler:SetCurrentSelectAlbum(album)
    self.selectedAlbum = album
    self:UpdateEditPanel(album)
end

--EditPanel的按钮状态
function AlbumShowAlbumHandler:UpdateEditPanel(album)
    if not self.editMode then
        return
    end

    local l_btnShare = self.panel.BtnShare
    local l_btnEditName = self.panel.BtnEditName
    local l_btnDelete = self.panel.BtnDelete
    if album == nil then
        l_btnShare:SetGray(false)
        l_btnEditName:SetGray(false)
        l_btnDelete:SetGray(false)
    elseif album.isDefaultAlbum then
        l_btnShare:SetGray(false)
        l_btnEditName:SetGray(true)
        l_btnDelete:SetGray(true)
    else
        l_btnShare:SetGray(false)
        l_btnEditName:SetGray(false)
        l_btnDelete:SetGray(false)
    end

end

function AlbumShowAlbumHandler:OnShareAlbum()
    MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("NOT_OPEN_PLEASE_WAITTING"))
end

function AlbumShowAlbumHandler:OnEditAlbumName()
    if self.selectedAlbum == nil then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("PHOTOGRAPH_PLEASE_SELECT_ALBUM"))
    elseif self.selectedAlbum.isDefaultAlbum then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("PHOTOGRAPH_DEFAULT_CANT_EDIT_NAME"))
    else
        CommonUI.Dialog.ShowYesNoInputDlg(true, Common.Utils.Lang("PHOTOGRAPH_RENAME_ALBUM"),
                Common.Utils.Lang("ALBUM_MAX_ALBUM_NAME_LENGTH"),
                Common.Utils.Lang("DLG_BTN_YES"),
                Common.Utils.Lang("DLG_BTN_NO"), function(newName)
                    newName = StringEx.DeleteEmoji(newName)
                    local l_error = MgrMgr:GetMgr("AlbumMgr").IsValidName(newName)
                    if l_error == nil then
                        self:RenameAlbum(self.selectedAlbum, newName)
                    else
                        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(l_error)
                    end

                end, function()

                end)
    end
end

function AlbumShowAlbumHandler:OnDeleteAlbum()
    if self.selectedAlbum == nil then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("PHOTOGRAPH_PLEASE_SELECT_ALBUM"))
    elseif self.selectedAlbum.isDefaultAlbum then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("PHOTOGRAPH_DEFAULT_CANT_DELETE"))
    else
        CommonUI.Dialog.ShowYesNoDlg(true, nil, Common.Utils.Lang("ALBUM_TIP_DELETE_ALBUM_COMFIRM", self.selectedAlbum.name), function()
            self:RemoveAlbum(self.selectedAlbum)
            self:SetCurrentSelectAlbum(nil)
        end, function()
        end)
    end
end
-------------------------------按钮回调---------------------------
-------------------------------常用函数---------------------------

function AlbumShowAlbumHandler:IsDefaultAlbumGameObjectName(albumName)
    if albumName ~= "DefaultAlbum" and
            albumName ~= "LoverAlbum" and
            albumName ~= "BtnAddAlbum" then
        return false
    else
        return true
    end
end

return AlbumShowAlbumHandler
-------------------------------常用函数---------------------------
--lua custom scripts end
