--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/ShareFashionPanel"
--lua requires end

--lua model
module("UI", package.seeall)

--lua model end

--lua fields
local super = UI.UIBaseCtrl
--lua fields end

local Mgr = MgrMgr:GetMgr("ShareMgr")
--lua class define
---@class ShareFashionCtrl : UIBaseCtrl
ShareFashionCtrl = class("ShareFashionCtrl", super)
--lua class define end

--lua functions
function ShareFashionCtrl:ctor()

	super.ctor(self, CtrlNames.ShareFashion, UILayer.Tips, nil, ActiveType.Exclusive)
	
end --func end
--next--
function ShareFashionCtrl:Init()
	MgrMgr:GetMgr("AlbumMgr").InitFolder()
	self.panel = UI.ShareFashionPanel.Bind(self)
	super.Init(self)
	self.isShowLogo = false
	self.isQRcode = false
	self.QRcode = nil
	self.isinvitationCode = false
	self.invitationCode = ""
	self.Model = nil
	self.sharetype = nil
	self.texture = nil
	self.Share2SdkData = nil
	self._SaveToAlbumNameList={}
	self.rowdata = nil
	self.paramID = nil
	self:Bind()
end --func end
--next--
function ShareFashionCtrl:Uninit()
	
	super.Uninit(self)
	self.panel = nil
	self.isShowLogo = false
	self.isQRcode = false
	self.QRcode = nil
	self.isinvitationCode = false
	self.invitationCode = ""
	self.Model = nil
	self.sharetype = nil
	self.texture = nil
	if self.Share2SdkData ~= nil then
		Object.Destroy(self.Share2SdkData)
		self.Share2SdkData = nil
	end
	self.Share2SdkData = nil
	self._SaveToAlbumNameList={}
	self.rowdata = nil
	self.paramID = nil
end --func end
--next--
function ShareFashionCtrl:OnActive()
	self:SetPlayerName(MPlayerInfo.Name)
	self:SetServerName(MPlayerInfo.ServerName)
	self:refreshRowImgLogo(self.isShowLogo)
	self:SetInvitationCode(self.isinvitationCode,self.invitationCode)
	self:SetQRCode(self.isQRcode)
	self.panel.channelSavephone.gameObject:SetActive(self.rowdata.MoblieButtonShow)
	self.panel.channelSavexiangce.gameObject:SetActive(self.rowdata.AlbumButtonShow)
	self.panel.channelShareFacebook.gameObject:SetActive(Mgr.ShareSDKFBIsOn)
	self.panel.channelKakao.gameObject:SetActive(Mgr.ShareSDKKaKaoIsOn)
	self.panel.Background:SetRawTex(self.rowdata.ShareBasePicture)

	self:SetModel(self.Model)

	if self.rowdata.ShareContentForm ~= MgrMgr:GetMgr("ShareMgr").ShareStyle.Link then
		--self.timer = self:NewUITimer(function()
		--	self:NewTexture()
		--	self:StopUITimer(self.timer)
		--end,2,-1,true)
		--self.timer:Start()
		--self:NewTexture(nil)
	else
		self.Share2SdkData = row.ShareLink
	end
	
end --func end
--next--
function ShareFashionCtrl:OnDeActive()
	
	
end --func end
--next--
function ShareFashionCtrl:Update()
	
	
end --func end
--next--
function ShareFashionCtrl:BindEvents()
	
	
end --func end
--next--
--lua functions end
function ShareFashionCtrl:SetShareInfo(shareid,Model,type,paramID)
	local row = TableUtil.GetShareTable().GetRowByShareId(shareid,false)
	self.isShowLogo = row.GameLogoShow
	self.isQRcode = row.QRCodeShow
	self.isinvitationCode = row.InvitationCodeShow
	self.Model = Model
	self.sharetype = type
	self.rowdata = row
	self.paramID = paramID
end

--next--
function ShareFashionCtrl:Bind()
	self.panel.Close:AddClick(function()
		UIMgr:DeActiveUI(UI.CtrlNames.ShareFashion)
	end)
	self.panel.channelKakao:AddClick(function() self:SendKakao() end)
	self.panel.channelShareFacebook:AddClick(function() self:Sendfacebook() end)
	self.panel.channelSavephone:AddClick(function() self:Savephone() end)
	self.panel.channelSavexiangce:AddClick(function() self:Savexiangce() end)
end
function ShareFashionCtrl:SendKakao()
	Mgr.SendKakao(self.rowdata.ShareContentForm,self.Share2SdkData,self.rowdata.ShareId,function()

	end)
end
function ShareFashionCtrl:Sendfacebook()
	Mgr.SendFacebook(self.rowdata.ShareContentForm,self.Share2SdkData,self.rowdata.ShareId,function()

	end)
end
function ShareFashionCtrl:Savephone()
	if self.rowdata.ShareContentForm ~= Mgr.ShareStyle.Link then
		if self.Share2SdkData ~= nil then
			Mgr.Savephone(self.Share2SdkData)
		end
	end
end
function ShareFashionCtrl:Savexiangce()
	if self.rowdata.ShareContentForm ~= Mgr.ShareStyle.Link and self.Share2SdkData ~= nil then
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
function ShareFashionCtrl:SetPlayerName(name)
	if self.sharetype == Mgr.ShareID.FashionShare then
		self.panel.PlayerName.LabColor = RoColor.Hex2Color("6B7584")
	end
	self.panel.PlayerName.LabText = name
end
function ShareFashionCtrl:SetServerName(name)
	if self.sharetype == Mgr.ShareID.FashionShare then
		self.panel.ServerName.LabColor = RoColor.Hex2Color("6B7584")
		self.panel.ServerImage.LabColor = RoColor.Hex2Color("6B7584")
	end
	self.panel.ServerName.LabText = name
end
function ShareFashionCtrl:SetInvitationCode(isactive,code)
	self.panel.invitation.gameObject:SetActive(isactive)
	self.panel.invitationCode.LabText = tostring(code)
end
function ShareFashionCtrl:SetQRCode(isactive)
	self.panel.QRCode.gameObject:SetActive(isactive)
	if g_Globals.IsChina then
		self.panel.QRCode:SetRawTexAsync(Mgr.QRcodeType.tencent_qrcode)
	elseif g_Globals.IsKorea then
		self.panel.QRCode:SetRawTexAsync(Mgr.QRcodeType.korea_qrcode)
	end
	--self.panel.QRCode.RawImg = QRcode
end
function ShareFashionCtrl:SetModel(modle)
	self.panel.Model.gameObject:SetActiveEx(false)
	if Mgr.ShareID.FashionShare == self.sharetype then
		attr = MgrMgr:GetMgr("GarderobeMgr").GetRoleAttr()
		attr:SetFashion(self.paramID)
		local l_fxData = {}
		l_fxData.rawImage = self.panel.Model.RawImg
		l_fxData.attr = attr
		l_fxData.useShadow = true
		l_fxData.enablePostEffect = true
		l_fxData.defaultAnim = attr.CommonIdleAnimPath
		l_fxData.width = 1024*1.5
		l_fxData.height = 1024*1.5
		l_fxData.isCameraPosRotCustom = true
		l_fxData.cameraPos = Vector3.New(0.0, 1.1, -3.10)
		l_fxData.cameraRot = Quaternion.Euler(0.0, 2.0, 0.0)
		l_fxData.defaultAnim = MgrMgr:GetMgr("GarderobeMgr").GetRoleAnim(attr, self.paramID)
		model = self:CreateUIModel(l_fxData)
		model.LocalPosition = Vector3.New(0.3, -0.5, 0.0)
		model.Scale = Vector3.New(1.5, 1.5, 1.5)
		model:AddLoadModelCallback(function(m)
			self.panel.Model.gameObject:SetActiveEx(true)
			self.timer = self:NewUITimer(function()
				self:NewTexture(function()
					self:StopUITimer(self.timer)
				end)
			end,1,-1,true)
			self.timer:Start()
		end)
	end
end

function ShareFashionCtrl:NewTexture(callback)
	self:SetOthers(false)

	MScreenCapture.TakeScreenShotWithRatio(16/9, nil,function(l_photo)
		if self.Share2SdkData ~= nil then
			Object.Destroy(self.Share2SdkData)
			self.Share2SdkData = nil
		end

		self.Share2SdkData = l_photo
		self:SetOthers(true)

		if callback ~= nil then
			callback()
		end
	end)
end
function ShareFashionCtrl:SetOthers(flag)
	self.panel.Close.gameObject:SetActive(flag)
	self.panel.channels.gameObject:SetActive(flag)
	self.panel.blue.gameObject:SetActive(flag)
end

function ShareFashionCtrl:refreshRowImgLogo(status)
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
return ShareFashionCtrl