--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/AlbumPanel"

--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua class define
local super = UI.UIBaseCtrl
AlbumCtrl = class("AlbumCtrl", super)
--lua class define end

--lua functions
function AlbumCtrl:ctor()

    super.ctor(self, CtrlNames.Album, UILayer.Function, UITweenType.UpAlpha, ActiveType.Exclusive)
    self.stopMoveOnActive = true

end --func end
--next--
function AlbumCtrl:Init()

    MgrMgr:GetMgr("AlbumMgr").InitFolder()

    self.panel = UI.AlbumPanel.Bind(self)
    super.Init(self)
    self.panel.BtnClose:AddClick(function()
        UIMgr:DeActiveUI(UI.CtrlNames.Album)
    end)

    self:UpdateAlbumPhotoNumber()

end --func end
--next--
function AlbumCtrl:SetupHandlers()
    local l_handlerTb = {
        {HandlerNames.AlbumShowAlbum, Lang("PHOTOGRAPH_ALUBUM_IDENTIFICATION"),"CommonIcon","UI_CommonIcon_Tab_xiangce_01.png","UI_CommonIcon_Tab_xiangce_02.png"},
        {HandlerNames.AlbumShowPhoto, Lang("PHOTOGRAPH_PHOTO_IDENTIFICATION"),"CommonIcon","UI_CommonIcon_Tab_xiangpian_01.png","UI_CommonIcon_Tab_xiangpian_02.png"}
    }
    self:InitHandler(l_handlerTb, self.panel.ToggleTpl)
end --func end
--next--
function AlbumCtrl:Uninit()

    super.Uninit(self)
    self.panel = nil

end --func end
--next--
function AlbumCtrl:OnActive()



end --func end
--next--
function AlbumCtrl:OnDeActive()


end --func end
--next--
function AlbumCtrl:Update()


end --func end


--next--
function AlbumCtrl:BindEvents()

    self:BindEvent(GlobalEventBus,EventConst.Names.PhotoNumberChange,function(self)
        self:UpdateAlbumPhotoNumber()
    end)

end --func end
--next
--lua functions end

--lua custom scripts

function AlbumCtrl:UpdateAlbumPhotoNumber()
    local l_length = Directory.GetFiles(MgrMgr:GetMgr("AlbumMgr").GetAlbumRoot(), "*.png", System.IO.SearchOption.AllDirectories).Length
    self.panel.PhotoNumber.LabText = tostring(l_length)

end

--lua custom scripts end
