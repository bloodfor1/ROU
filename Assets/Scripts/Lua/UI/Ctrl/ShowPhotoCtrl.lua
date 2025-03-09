--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/ShowPhotoPanel"

--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua class define
local super = UI.UIBaseCtrl
ShowPhotoCtrl = class("ShowPhotoCtrl", super)
--lua class define end

--lua functions
function ShowPhotoCtrl:ctor()

    -- 如果是手机截图的话，不需要关闭后面的UI
    local activeType = MgrMgr:GetMgr("AlbumMgr").CurShowPothoChannel == MgrMgr:GetMgr("AlbumMgr").ShowPothoChannel.ScreenCapture and ActiveType.None or ActiveType.Exclusive
    super.ctor(self, CtrlNames.ShowPhoto, UILayer.Tips, nil, activeType)
    self.stopMoveOnActive = false
    self.keepLastUI = true
    self.autoSave = false

end --func end
--next--
function ShowPhotoCtrl:Init()

    self.panel = UI.ShowPhotoPanel.Bind(self)
    super.Init(self)
    self.path = nil
    self.lastCtrlName = nil

    self.texture=nil

    self.panel.BtnSaveTheLocal:AddClick(function() self:OnSaveToPhone() end)
    self.panel.BtnSaveAlbum:AddClick(function() self:OnSaveToAlbum() end)
    self.panel.BtnMoveAlbum:AddClick(function() self:OnMoveToAlbum() end)
    self.panel.BtnDiscard:AddClick(function() self:OnDeletePhoto() end)
    self.panel.BtnClose:AddClick(function() self:OnClose() end)
    self.panel.BlackBG:AddClick(function()
        if self.path ~= nil then
            self:OnClose()
        end
    end)
    self.panel.BtnNext:AddClick(function() self:OnNextPhoto() end)
    self.panel.BtnPrev:AddClick(function() self:OnPrevPhoto() end)
    self.panel.BtnShare:AddClick(function() self:OnShare() end)
    self.panel.BtnKakaotalk:AddClick(function() self:Sendkakao() end)
    self.panel.BtnFacebook:AddClick(function() self:Sendfacebook() end)
    self.ShareRow = nil
    self.Share2SdkData = nil
    self.photoList = nil
    self.cached_info = nil
    self.isSaveToPhone = false

    self._SaveToAlbumNameList={}
end --func end
--next--
function ShowPhotoCtrl:Uninit()
    if self.texture ~= nil then
        Object.Destroy(self.texture)
        self.texture = nil
    end

    if self.Share2SdkData ~= nil then
        Object.Destroy(self.Share2SdkData)
        self.Share2SdkData = nil
    end
    self.lastCtrlName = nil
    self.cached_info = nil
    self.keepLastUI = true
    self.autoSave = false
    self.isSaveToPhone = false
    self._SaveToAlbumNameList={}

    super.Uninit(self)
    self.panel = nil
end --func end
--next--
function ShowPhotoCtrl:OnActive()

    if self.autoSave == true then
        self:OnSaveToAlbum(false)
    end



end --func end
--next--
function ShowPhotoCtrl:OnDeActive()
    self.photoList = nil
    if self.texture ~= nil then
        Object.Destroy(self.texture)
        self.texture = nil
    end

    if self.Share2SdkData ~= nil then
        Object.Destroy(self.Share2SdkData)
        self.Share2SdkData = nil
    end

    GlobalEventBus:Dispatch(EventConst.Names.OnCloseShowPhoto)
end --func end

function ShowPhotoCtrl:DeActive(isPlayTween)
    if (not MStageMgr.IsSwitchingScene) and (not self.keepLastUI) and (self.lastCtrlName ~= nil) then
        MPlayerInfo.CurrentPhotoCameraMode = MoonClient.MCameraState.Photo
        UIMgr:DeActiveUI(self.lastCtrlName)
    end
    super.DeActive(self, isPlayTween)
end
--next--
function ShowPhotoCtrl:Update()


end --func end



--next--
function ShowPhotoCtrl:BindEvents()

    --dont override this function

end --func end

--next--
--lua functions end

--lua custom scripts
--从相机打开
function ShowPhotoCtrl:SetShowPhotoByTexture(texture, lastCtrlName, cached_info, keepLastUI, autoSave, isShare)
    local shareID = MgrMgr:GetMgr("ShareMgr").ShareID.PhotoShare
    local row = TableUtil.GetShareTable().GetRowByShareId(shareID,true)

    self.ShareRow = row
    self.panel.BtnFacebook.gameObject:SetActive(MgrMgr:GetMgr("ShareMgr").ShareSDKFBIsOn)
    self.panel.BtnKakaotalk.gameObject:SetActive(MgrMgr:GetMgr("ShareMgr").ShareSDKKaKaoIsOn)
    self:refreshRowImgLogo(row.GameLogoShow and MgrMgr:GetMgr("ShareMgr").CanShare_merge())

    self.path = nil

    self.panel.ImgTexturePhoto:SetActiveEx(true)
    self.panel.ImgNativePhoto:SetActiveEx(false)
    self.panel.ImgTexturePhoto:SetManualTexture(texture)
    if self.texture ~= nil then
        Object.Destroy(self.texture)
        self.texture = nil
    end
    self.texture=texture
    self.panel.BtnSaveAlbum.gameObject:SetActiveEx(true)
    self.panel.BtnMoveAlbum.gameObject:SetActiveEx(false)
    self.lastCtrlName = lastCtrlName
    self.panel.BtnNext.gameObject:SetActiveEx(false)
    self.panel.BtnPrev.gameObject:SetActiveEx(false)
    self.panel.BtnDiscard.gameObject:SetActiveEx(false)
    self.cached_info = cached_info
    self.keepLastUI = keepLastUI
    if keepLastUI == nil then
        keepLastUI = true
    end
    if autoSave then
        self.autoSave = autoSave
        self.panel.BtnSaveAlbum.gameObject:SetActiveEx(false)
    end
    self.panel.BtnShare.gameObject:SetActiveEx(isShare)

    if row.ShareContentForm ~= MgrMgr:GetMgr("ShareMgr").ShareStyle.Link then
        self.timer = self:NewUITimer(function()
            self:NewTexture(function()
                --logError(tostring(self.Share2SdkData))
                self:StopUITimer(self.timer)
            end)

        end,0.5,-1,true)
        self.timer:Start()
    else
        self.Share2SdkData = row.ShareLink
    end
end

--从相册打开
function ShowPhotoCtrl:SetShowPhotoByPath(path, lastCtrlName, inAlbum)
    self:ShowPhoto(path)

    self.panel.BtnFacebook.gameObject:SetActive(false)
    self.panel.BtnKakaotalk.gameObject:SetActive(false)
    self:refreshRowImgLogo(false)
    self.panel.BtnSaveAlbum.gameObject:SetActiveEx(false)
    self.panel.BtnMoveAlbum.gameObject:SetActiveEx(true)
    self.lastCtrlName = lastCtrlName
    self.panel.BtnNext.gameObject:SetActiveEx(true)
    self.panel.BtnPrev.gameObject:SetActiveEx(true)
    self.panel.BtnDiscard.gameObject:SetActiveEx(true)

    if inAlbum then
        self.photoList = MgrMgr:GetMgr("AlbumMgr").GetPhotoList(MgrMgr:GetMgr("AlbumMgr").GetAlbumName(self.path))
    else
        self.photoList = MgrMgr:GetMgr("AlbumMgr").GetPhotoList()
    end

    self.maxPhotoNumber = self.photoList.Length
    for i = 0, self.photoList.Length-1 do
        if self.path == self.photoList[i] then
            self.currentPhotoIndex = i
        end
    end

end

--lua custom scripts
--从截图打开
function ShowPhotoCtrl:SetShowPhotoByScreenCapture(texture, lastCtrlName, cached_info, keepLastUI, autoSave, isShare)
    local shareID = MgrMgr:GetMgr("ShareMgr").ShareID.ScreenShot
    local row = TableUtil.GetShareTable().GetRowByShareId(shareID,true)
    self.ShareRow = row

    self.panel.BtnFacebook.gameObject:SetActive(MgrMgr:GetMgr("ShareMgr").ShareSDKFBIsOn)
    self.panel.BtnKakaotalk.gameObject:SetActive(MgrMgr:GetMgr("ShareMgr").ShareSDKKaKaoIsOn)
    self:refreshRowImgLogo(row.GameLogoShow)
    self.panel.BtnSaveTheLocal.gameObject:SetActive(row.MoblieButtonShow)

    self.path = nil

    self.panel.ImgTexturePhoto:SetActiveEx(true)
    self.panel.ImgNativePhoto:SetActiveEx(false)
    self.panel.ImgTexturePhoto:SetManualTexture(texture)
    if self.texture ~= nil then
        Object.Destroy(self.texture)
        self.texture = nil
    end
    self.texture=texture
    self.panel.BtnSaveAlbum.gameObject:SetActiveEx(row.AlbumButtonShow)
    self.panel.BtnMoveAlbum.gameObject:SetActiveEx(false)
    self.lastCtrlName = lastCtrlName
    self.panel.BtnNext.gameObject:SetActiveEx(false)
    self.panel.BtnPrev.gameObject:SetActiveEx(false)
    self.panel.BtnDiscard.gameObject:SetActiveEx(false)
    self.cached_info = cached_info
    self.keepLastUI = keepLastUI
    if keepLastUI == nil then
        keepLastUI = true
    end
    self.panel.BtnShare.gameObject:SetActiveEx(isShare)

    if row.ShareContentForm ~= MgrMgr:GetMgr("ShareMgr").ShareStyle.Link then
        self.timer = self:NewUITimer(function()
            self:NewTexture(function()
                --logError(tostring(self.Share2SdkData))
                self:StopUITimer(self.timer)
            end)

        end,0.5,-1,true)
        self.timer:Start()
    else
        self.Share2SdkData = row.ShareLink
    end
end
function ShowPhotoCtrl:Sendkakao()
    MgrMgr:GetMgr("ShareMgr").SendKakao(self.ShareRow.ShareContentForm,self.Share2SdkData,self.ShareRow.ShareId,function()

    end)
end
function ShowPhotoCtrl:Sendfacebook()
    MgrMgr:GetMgr("ShareMgr").SendFacebook(self.ShareRow.ShareContentForm,self.Share2SdkData,self.ShareRow.ShareId,function()

    end)
end

function ShowPhotoCtrl:NewTexture(callback)
    local l_panelCorners = System.Array.CreateInstance(System.Type.GetType("UnityEngine.Vector3, UnityEngine.CoreModule"), 4)
    self.panel.ImgTexturePhoto.RectTransform:GetWorldCorners(l_panelCorners)
    local l_panelDownLeft = MUIManager.UICamera:WorldToScreenPoint(l_panelCorners[0])
    local l_panelTopRight = MUIManager.UICamera:WorldToScreenPoint(l_panelCorners[2])

    local l_screenRect = UnityEngine.Rect.New(l_panelDownLeft.x, l_panelDownLeft.y, l_panelTopRight.x - l_panelDownLeft.x, l_panelTopRight.y - l_panelDownLeft.y)
    MScreenCapture.TakeScreenShot(l_screenRect, function(l_photo)
        if self.Share2SdkData ~= nil then
            Object.Destroy(self.Share2SdkData)
            self.Share2SdkData = nil
        end

        self.Share2SdkData = l_photo
        --self.texture=l_photo
        --
        --self.panel.ImgTexturePhoto:SetManualTexture(l_photo)
        --MgrMgr:GetMgr("AlbumMgr").OpenPhotoByTexture(l_photo,"Photograph" , l_info, false, false, true)

        --self.Photo = l_photo

        if callback ~= nil then
            callback()
        end
    end)
end

function ShowPhotoCtrl:ShowPhoto(path)
    self.path = path
    local l_photoTexture = MgrMgr:GetMgr("AlbumMgr").GetPhotoTexture(path,false,TextureFormat.RGB24)
    if l_photoTexture ~= nil then
        self.texture=l_photoTexture.Tex
        self.panel.ImgTexturePhoto:SetActiveEx(false)
        self.panel.ImgNativePhoto:SetActiveEx(true)
        self.panel.ImgNativePhoto:SetNativeTexture(l_photoTexture)
    end
end

function ShowPhotoCtrl:OnClose()

    if self.cached_info and not self.isSaveToPhone and #self._SaveToAlbumNameList==0 then
        MgrMgr:GetMgr("AlbumMgr").PhotoFlowTlog(self.cached_info, 0)
        self.cached_info = nil
    end

    if self.texture ~= nil then
        Object.Destroy(self.texture)
        self.texture = nil
    end

    if self.Share2SdkData ~= nil then
        Object.Destroy(self.Share2SdkData)
        self.Share2SdkData = nil
    end

    UIMgr:DeActiveUI(UI.CtrlNames.ShowPhoto)

end

--保存到手机
function ShowPhotoCtrl:OnSaveToPhone()
    --TODO Save
    if self.isSaveToPhone then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("PHOTOGRAPH_SAVE_TO_PHONE_SUCC"))
        return
    end

    if self.texture then
        MgrMgr:GetMgr("AlbumMgr").SavePhotoToSystemAlbum(self.texture, function(state)
            self.isSaveToPhone = state
        end)
    end

    if self.cached_info then
        MgrMgr:GetMgr("AlbumMgr").PhotoFlowTlog(self.cached_info, 1)
    end

    --UIMgr:DeActiveUI(UI.CtrlNames.ShowPhoto)
end

--保存到相册
function ShowPhotoCtrl:OnSaveToAlbum(closeUI)

    if closeUI == nil then
        closeUI = true
    end

    local albumList = MgrMgr:GetMgr("AlbumMgr").GetAlbumNameList()
    if #albumList == 1 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("PHOTOGRAPH_SAVE_TO_ALBUM_SUCC"))
        if #self._SaveToAlbumNameList>0 then
            logGreen("return")
            return
        end

        table.insert(self._SaveToAlbumNameList,albumList[1])

        if self.texture then
            MgrMgr:GetMgr("AlbumMgr").SavePhotoToAlbum(albumList[1],self.texture, false)
        end

        if self.cached_info then
            MgrMgr:GetMgr("AlbumMgr").PhotoFlowTlog(self.cached_info, 2)
        end

        if closeUI == true then
            -- @陈华需求 保存到本地或者相册不关闭当前界面
            --UIMgr:DeActiveUI(UI.CtrlNames.ShowPhoto)
        end
    else
        CommonUI.Dialog.ShowYesNoDropDownDlg(true, Lang("PHOTOGRAPH_SELECT_ALBUM"), albumList,
        nil, nil, function(albumName)
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("PHOTOGRAPH_SAVE_TO_ALBUM_SUCC"))

            if table.ro_contains(self._SaveToAlbumNameList,albumName) then
                logGreen("return")
                return
            end
            table.insert(self._SaveToAlbumNameList,albumName)

            if self.texture then
                MgrMgr:GetMgr("AlbumMgr").SavePhotoToAlbum(albumName,self.texture, false)
            end

            if self.cached_info then
                MgrMgr:GetMgr("AlbumMgr").PhotoFlowTlog(self.cached_info, 2)
            end
            if closeUI == true then
                -- @陈华需求 保存到本地或者相册不关闭当前界面
                --UIMgr:DeActiveUI(UI.CtrlNames.ShowPhoto)
            end
        end, function()
        end)
    end


end

--移动相册
function ShowPhotoCtrl:OnMoveToAlbum()
    if self.path ~= nil then
        CommonUI.Dialog.ShowYesNoDropDownDlg(true, Lang("PHOTOGRAPH_SELECT_ALBUM"), MgrMgr:GetMgr("AlbumMgr").GetAlbumNameList(),
        nil, nil, function(albumName)
            CommonUI.Dialog.ShowYesNoDlg(true, nil, Common.Utils.Lang("ALBUM_TIP_MOVE_PHOTO_COMFIRM", albumName), function()
                MgrMgr:GetMgr("AlbumMgr").MovePhoto(self.path, albumName)
                MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("PHOTOGRAPH_MOVE_ALBUM_SUCC"))
                UIMgr:DeActiveUI(UI.CtrlNames.ShowPhoto)
            end, function()
            end)
        end, function()
        end)
    else
        logerror("还未保存这张照片！")
    end
end

--删除照片
function ShowPhotoCtrl:OnDeletePhoto()

    --如果有路径就删除
    if self.path ~= nil then
        CommonUI.Dialog.ShowYesNoDlg(true, nil, Common.Utils.Lang("ALBUM_TIP_DELETE_PHOTO_COMFIRM"), function()
            MgrMgr:GetMgr("AlbumMgr").RemovePhoto(self.path)
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("PHOTOGRAPH_DELETE_PHOTO_SUCC"))
            UIMgr:DeActiveUI(UI.CtrlNames.ShowPhoto)
        end, function()
        end)
    else
        UIMgr:DeActiveUI(UI.CtrlNames.ShowPhoto)
    end

end

function ShowPhotoCtrl:OnNextPhoto()
    if self.photoList == nil then
        return
    end
    if self.currentPhotoIndex + 1 >= self.maxPhotoNumber then
        return
    end
    self.currentPhotoIndex = self.currentPhotoIndex + 1
    self:ShowPhoto(self.photoList[self.currentPhotoIndex])
end

function ShowPhotoCtrl:OnPrevPhoto()
    if self.photoList == nil then
        return
    end
    if self.currentPhotoIndex <= 0 then
        return
    end
    self.currentPhotoIndex = self.currentPhotoIndex - 1
    self:ShowPhoto(self.photoList[self.currentPhotoIndex])
end

function ShowPhotoCtrl:OnShare()
    if MgrMgr:GetMgr("FashionRatingMgr").IsFashionRatingPhoto then
        MgrMgr:GetMgr("FashionRatingMgr").ShareFashionRating()
        -- @陈华需求 保存到本地或者相册不关闭当前界面
        --UIMgr:DeActiveUI(UI.CtrlNames.ShowPhoto)
    end

end

function ShowPhotoCtrl:refreshRowImgLogo(status)
    if status then
        self.panel.RawImgLogoChina:SetActiveEx(g_Globals.IsChina)
        self.panel.RawImgLogoKorea:SetActiveEx(g_Globals.IsKorea)
    else
        self.panel.RawImgLogoChina:SetActiveEx(status)
        self.panel.RawImgLogoKorea:SetActiveEx(status)
    end
end
return ShowPhotoCtrl
--lua custom scripts end
