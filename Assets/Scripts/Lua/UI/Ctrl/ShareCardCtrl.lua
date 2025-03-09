--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/ShareCardPanel"
--lua requires end

--lua model
module("UI", package.seeall)

--lua model end

--lua fields
local super = UI.UIBaseCtrl
--lua fields end

--lua class define
---@class ShareCardCtrl : UIBaseCtrl
ShareCardCtrl = class("ShareCardCtrl", super)
--lua class define end
local Mgr = MgrMgr:GetMgr("ShareMgr")
--lua functions
function ShareCardCtrl:ctor()
	
	super.ctor(self, CtrlNames.ShareCard, UILayer.Tips, nil, ActiveType.Exclusive)
	self.GroupMaskType = GroupMaskType.Show
	self.MaskColor=BlockColor.Dark
	self.ClosePanelNameOnClickMask=UI.CtrlNames.ShareCard
	self.MaskDelayClickTime=2
end --func end
--next--
function ShareCardCtrl:Init()
	
	self.panel = UI.ShareCardPanel.Bind(self)
	super.Init(self)
	self:Bind()
	self.Model = nil
	self.sharetype = nil
	self.rowdata = nil
	self.invitationCode = nil
	self.QRcode = nil
	self.EquipCardTablerow = nil
	self.texture = nil
	self.Share2SdkData = nil
	self.paramID = nil
	self._SaveToAlbumNameList={}
end --func end
--next--
function ShareCardCtrl:Uninit()
	
	super.Uninit(self)
	self.panel = nil
	self.Model = nil
	self.sharetype = nil
	self.rowdata = nil
	self.invitationCode = nil
	self.QRcode = nil
	self.EquipCardTablerow = nil
	self.texture = nil
	self.paramID = nil
	self._SaveToAlbumNameList={}

	if self.Share2SdkData ~= nil then
		Object.Destroy(self.Share2SdkData)
		self.Share2SdkData = nil
	end
end --func end
--next--
function ShareCardCtrl:OnActive()
	MgrMgr:GetMgr("AlbumMgr").InitFolder()
	self.panel.fragmentStory.gameObject:SetActive(true)
	self:SetPlayerName(MPlayerInfo.Name)
	self:SetServerName(MPlayerInfo.ServerName)
	self:refreshRowImgLogo(self.rowdata.GameLogoShow)
	self:SetInvitationCode(self.rowdata.InvitationCodeShow,self.invitationCode)
	self:SetQRCode(self.rowdata.QRCodeShow)
	self:SetModel(self.Model)


	self.panel.channelSavephone.gameObject:SetActive(self.rowdata.MoblieButtonShow)
	self.panel.channelSavexiangce.gameObject:SetActive(self.rowdata.AlbumButtonShow)
	self.panel.channelShareFacebook.gameObject:SetActive(Mgr.ShareSDKFBIsOn)
	self.panel.channelKakao.gameObject:SetActive(Mgr.ShareSDKKaKaoIsOn)

	if self.rowdata.ShareContentForm ~= MgrMgr:GetMgr("ShareMgr").ShareStyle.Link then
		self.timer = self:NewUITimer(function()
			self:NewTexture(function()
				self:StopUITimer(self.timer)
			end)
		end,0.5,-1,true)
		self.timer:Start()
	else
		self.Share2SdkData = row.ShareLink
	end
end --func end
--next--
function ShareCardCtrl:OnDeActive()
	
	
end --func end
--next--
function ShareCardCtrl:Update()
	
	
end --func end
--next--
function ShareCardCtrl:BindEvents()
	
	
end --func end
--next--
--lua functions end
function ShareCardCtrl:SetShareInfo(shareid,Model,type,paramID)
	local row = TableUtil.GetShareTable().GetRowByShareId(shareid,false)
	self.EquipCardTablerow = TableUtil.GetEquipCardTable().GetRowByID(paramID,false)
	self.Model = Model
	self.sharetype = type
	self.rowdata = row
	self.paramID = paramID
end
--next--
function ShareCardCtrl:Bind()
	self.panel.Close:AddClick(function()
		UIMgr:DeActiveUI(UI.CtrlNames.ShareCard)
	end)
	self.panel.channelKakao:AddClick(function() self:SendKakao() end)
	self.panel.channelShareFacebook:AddClick(function() self:Sendfacebook() end)
	self.panel.channelSavephone:AddClick(function() self:Savephone() end)
	self.panel.channelSavexiangce:AddClick(function() self:Savexiangce() end)
end
function ShareCardCtrl:SendKakao()
	MgrMgr:GetMgr("ShareMgr").SendKakao(self.rowdata.ShareContentForm,self.Share2SdkData,self.rowdata.ShareId,function()

	end)
end
function ShareCardCtrl:Sendfacebook()
	MgrMgr:GetMgr("ShareMgr").SendFacebook(self.rowdata.ShareContentForm,self.Share2SdkData,self.rowdata.ShareId,function()

	end)
end
function ShareCardCtrl:Savephone()
	if self.rowdata.ShareContentForm ~= Mgr.ShareStyle.Link then
		if self.Share2SdkData ~= nil then
			Mgr.Savephone(self.Share2SdkData)
		end
	end
end
function ShareCardCtrl:Savexiangce()
	if self.rowdata.ShareContentForm ~= Mgr.ShareStyle.Link then
		local albumList = MgrMgr:GetMgr("AlbumMgr").GetAlbumNameList()
		if #albumList == 1 then
			MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("PHOTOGRAPH_SAVE_TO_ALBUM_SUCC"))
			if #self._SaveToAlbumNameList>0 then
				logGreen("return")
				return
			end

			table.insert(self._SaveToAlbumNameList,albumList[1])

			if self.Share2SdkData then
				MgrMgr:GetMgr("AlbumMgr").SavePhotoToAlbum(albumList[1],self.Share2SdkData, false)
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

						if self.Share2SdkData then
							MgrMgr:GetMgr("AlbumMgr").SavePhotoToAlbum(albumName,self.Share2SdkData, false)
						end
					end, function()
					end)
		end
	end
end



function ShareCardCtrl:SetPlayerName(name)
	self.panel.fragmentStoryName.LabText = name
end
function ShareCardCtrl:SetServerName(name)
	self.panel.fragmentStoryServer.LabText = name
end
function ShareCardCtrl:SetInvitationCode(isactive,code)
	self.panel.invitation.gameObject:SetActive(isactive)
	self.panel.invitationCode.LabText = tostring(code)
end
function ShareCardCtrl:SetQRCode(isactive)
	self.panel.QRcode.gameObject:SetActive(isactive)
	if g_Globals.IsChina then
		self.panel.QRcode:SetRawTexAsync(Mgr.QRcodeType.tencent_qrcode)
	elseif g_Globals.IsKorea then
		self.panel.QRcode:SetRawTexAsync(Mgr.QRcodeType.korea_qrcode)
	end
end
function ShareCardCtrl:SetModel(model)
	local l_cardInfo = self.EquipCardTablerow
	self.panel.Img:SetRawTex(l_cardInfo.CardTexture)
	self.panel.Name.LabText = l_cardInfo.CardName

	local l_bgAtlas, l_bgIcon = Data.BagModel:getCardTextureBgInfo(self.paramID)
	self.panel.CardBG:SetSprite(l_bgAtlas, l_bgIcon)
	local l_c1,l_c2 = Data.BagModel:getCardTextureBgColor(self.paramID)
	self.panel.InforBG.Img.color = l_c1
	self.panel.NameBG.Img.color = l_c2
end

function ShareCardCtrl:NewTexture(callback)
	local l_panelCorners = System.Array.CreateInstance(System.Type.GetType("UnityEngine.Vector3, UnityEngine.CoreModule"), 4)
	self.panel.BorderPanel.RectTransform:GetWorldCorners(l_panelCorners)
	local l_panelDownLeft = MUIManager.UICamera:WorldToScreenPoint(l_panelCorners[0])
	local l_panelTopRight = MUIManager.UICamera:WorldToScreenPoint(l_panelCorners[2])

	local l_screenRect = UnityEngine.Rect.New(l_panelDownLeft.x, l_panelDownLeft.y, l_panelTopRight.x - l_panelDownLeft.x, l_panelTopRight.y - l_panelDownLeft.y)
	MScreenCapture.TakeScreenShot(l_screenRect, function(l_photo)
		if self.Share2SdkData ~= nil then
			Object.Destroy(self.Share2SdkData)
			self.Share2SdkData = nil
		end
		self.Share2SdkData=l_photo
		--
		--self.panel.ImgTexturePhoto:SetManualTexture(l_photo)
		--MgrMgr:GetMgr("AlbumMgr").OpenPhotoByTexture(l_photo,"Photograph" , l_info, false, false, true)

		--self.Photo = l_photo

		if callback ~= nil then
			callback()
		end
	end)
end

function ShareCardCtrl:refreshRowImgLogo(status)
	if status then
		self.panel.RawImgLogoChina:SetActiveEx(g_Globals.IsChina)
		self.panel.RawImgLogoKorea:SetActiveEx(g_Globals.IsKorea)
	else
		self.panel.RawImgLogoChina:SetActiveEx(status)
		self.panel.RawImgLogoKorea:SetActiveEx(status)
	end
end
--lua custom scripts

--lua custom scripts end
return ShareCardCtrl