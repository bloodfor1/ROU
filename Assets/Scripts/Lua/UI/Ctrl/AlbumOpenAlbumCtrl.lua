--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/AlbumOpenAlbumPanel"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua class define
local super = UI.UIBaseCtrl
AlbumOpenAlbumCtrl = class("AlbumOpenAlbumCtrl", super)
--lua class define end

--lua functions
function AlbumOpenAlbumCtrl:ctor()

    super.ctor(self, CtrlNames.AlbumOpenAlbum, UILayer.Function, UITweenType.UpAlpha, ActiveType.Exclusive)
    self.stopMoveOnActive = true

end --func end
--next--
function AlbumOpenAlbumCtrl:Init()

    self.panel = UI.AlbumOpenAlbumPanel.Bind(self)
    super.Init(self)

    self.photoShowInstances = {}
    self.photoShowInstances[1] = self.panel.photo1
    self.photoShowInstances[2] = self.panel.photo2
    self.photoShowInstances[3] = self.panel.photo3
    self.photoShowInstances[4] = self.panel.photo4

    self.panel.BtnNext:AddClick(function() self:OnNext() end)
    self.panel.BtnPrev:AddClick(function() self:OnPrev() end)
    self.panel.BtnClose:AddClick(function() self:OnClose() end)

end --func end
--next--
function AlbumOpenAlbumCtrl:Uninit()

    super.Uninit(self)
    self.panel = nil

end --func end
--next--
function AlbumOpenAlbumCtrl:OnActive()

end --func end
--next--
function AlbumOpenAlbumCtrl:OnDeActive()

end --func end
--next--
function AlbumOpenAlbumCtrl:Update()


end --func end


--next--
function AlbumOpenAlbumCtrl:BindEvents()
    self:BindEvent(GlobalEventBus,EventConst.Names.RefreshAlbum, function()
        self:OpenAlbum(self.currentAlbum)
    end)
    self:BindEvent(GlobalEventBus,EventConst.Names.DeleteAlbum, function()
        self:OpenAlbum(self.currentAlbum)
    end)
end --func end
--next--
--lua functions end

--lua custom scripts

--打开相册
function AlbumOpenAlbumCtrl:OpenAlbum(albumName)

    self.currentAlbum = albumName
    self.currentPageNumber = 0
    self.photoPaths = Directory.GetFiles(MgrMgr:GetMgr("AlbumMgr").GetAlbumPath(albumName), "*.png")
    self.maxPageNumber = math.ceil(MgrMgr:GetMgr("AlbumMgr").GetPhotoNumber(albumName) / 4.0)-1

    self:RefreshPage(self.currentPageNumber)

end

--刷新页面
function AlbumOpenAlbumCtrl:RefreshPage(pageNumber)
    for i = 1,4 do
        local l_index = i + pageNumber * 4
        if self.photoPaths.Length >= l_index then
            self:SetPhoto(i, self.photoPaths[l_index - 1])
        else
            self:SetPhoto(i, nil)
        end
    end
    self.panel.PageLeftValue.LabText = self.currentPageNumber*2 + 1
    self.panel.PageRightValue.LabText = self.currentPageNumber*2 + 2
end

--设置单张照片
function AlbumOpenAlbumCtrl:SetPhoto(index, path)
    local l_showInstance = self.photoShowInstances[index]
    if path == nil or not File.Exists(path) then
        l_showInstance.BGToTakePhoto:SetActiveEx(true)
        l_showInstance.InputMessage:SetActiveEx(false)
        l_showInstance.Photo:SetActiveEx(false)
        l_showInstance.BtnPhoto:AddClick(function()
            UIMgr:DeActiveUI(UI.CtrlNames.AlbumOpenAlbum)
            local cMethod = MgrMgr:GetMgr("SystemFunctionEventMgr").GetSystemFunctionEvent(MgrMgr:GetMgr("OpenSystemMgr").eSystemId.Camera)
            if cMethod then
                cMethod()
            end
        end)
    else
        l_showInstance.BGToTakePhoto:SetActiveEx(false)
        l_showInstance.InputMessage:SetActiveEx(true)
        l_showInstance.InputMessage.Input.onSelect = function()
            l_showInstance.InputMessage.Img.color = Color.New(0, 0, 0)
        end
        l_showInstance.InputMessage.Input.onDeselect = function()
            l_showInstance.InputMessage.Input.text = StringEx.DeleteEmoji(l_showInstance.InputMessage.Input.text)
            local l_requestText = l_showInstance.InputMessage.Input.text
            local ForbidTextMgr = require("ModuleMgr.ForbidTextMgr")
            ForbidTextMgr.RequestJudgeTextForbid(l_requestText, function(checkInfo)
                local l_resultCode = checkInfo.result
                local l_name = checkInfo.text
                if l_resultCode ~= 0 then
                    --判断服务器是否判断失败 如果失败什么都不发生
                    if l_resultCode ~= ErrorCode.ERR_FAILED then
                        --含有屏蔽字则提示
                        MgrMgr:GetMgr("TipsMgr").ShowErrorCodeTips(l_resultCode)
                    end
                    l_name = ""
                end
                if self.panel == nil or l_showInstance == nil or l_showInstance.InputMessage == nil or  l_name == nil or l_name == "" then
                    return
                end
                l_showInstance.InputMessage.Input.text = l_name
                MgrMgr:GetMgr("AlbumMgr").SetPhotoMessage(path, l_name)
            end)
        end

        local l_message = MgrMgr:GetMgr("AlbumMgr").GetPhotoMessage(path)
        l_showInstance.Photo:SetActiveEx(true)
        l_showInstance.Photo:ResetRawTex()

        local l_photoTexture = MgrMgr:GetMgr("AlbumMgr").GetPhotoTexture(path,false,TextureFormat.RGB24)
        l_showInstance.Photo:SetNativeTexture(l_photoTexture)
        l_showInstance.InputMessage.Input.text = l_message
        l_showInstance.BtnPhoto:AddClick(function()
            MgrMgr:GetMgr("AlbumMgr").OpenPhotoByPath(path, CtrlNames.AlbumOpenAlbum, true)
        end)
    end
end


-------------------------------回调函数---------------------------------
--关闭
function AlbumOpenAlbumCtrl:OnClose()
    --UIMgr:ActiveUI(UI.CtrlNames.Album)
    UIMgr:DeActiveUI(UI.CtrlNames.AlbumOpenAlbum)
end
--下一页
function AlbumOpenAlbumCtrl:OnNext()
    self.currentPageNumber = self.currentPageNumber + 1
    if self.currentPageNumber > self.maxPageNumber then
        self.currentPageNumber = self.maxPageNumber
    else
        self:RefreshPage(self.currentPageNumber)
    end
end
--前一页
function AlbumOpenAlbumCtrl:OnPrev()
    self.currentPageNumber = self.currentPageNumber - 1
    if self.currentPageNumber < 0 then
        self.currentPageNumber = 0
    else
        self:RefreshPage(self.currentPageNumber)
    end
end
-------------------------------回调函数---------------------------------
--lua custom scripts end
