--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/ShareNormalPanel"
--lua requires end

--lua model
module("UI", package.seeall)

--lua model end

--lua fields
local super = UI.UIBaseCtrl
--lua fields end

--lua class define
ShareNormalCtrl = class("ShareNormalCtrl", super)
--lua class define end

local Mgr = MgrMgr:GetMgr("ShareMgr")

--lua functions
function ShareNormalCtrl:ctor()
	
	super.ctor(self, CtrlNames.ShareNormal, UILayer.Function, nil, ActiveType.Exclusive)
	
end --func end
--next--
function ShareNormalCtrl:Init()
	MgrMgr:GetMgr("AlbumMgr").InitFolder()
	self.panel = UI.ShareNormalPanel.Bind(self)
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
	self:Bind()
end --func end
--next--
function ShareNormalCtrl:Uninit()
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
end --func end
--next--
function ShareNormalCtrl:OnActive()
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
function ShareNormalCtrl:OnDeActive()
	
	
end --func end
--next--
function ShareNormalCtrl:Update()
	
	
end --func end
--next--
function ShareNormalCtrl:BindEvents()
	
end --func end

function ShareNormalCtrl:SetShareInfo(shareid,Model,type,paramID)
	local row = TableUtil.GetShareTable().GetRowByShareId(shareid,false)
	self.isShowLogo = row.GameLogoShow
	self.isQRcode = row.QRCodeShow
	self.isinvitationCode = row.InvitationCodeShow
	self.Model = Model
	self.sharetype = type
	self.rowdata = row

end

--next--
function ShareNormalCtrl:Bind()
	self.panel.Close:AddClick(function()
		UIMgr:DeActiveUI(UI.CtrlNames.ShareNormal)
	end)
	self.panel.channelKakao:AddClick(function() self:SendKakao() end)
	self.panel.channelShareFacebook:AddClick(function() self:Sendfacebook() end)
	self.panel.channelSavephone:AddClick(function() self:Savephone() end)
	self.panel.channelSavexiangce:AddClick(function() self:Savexiangce() end)
end
function ShareNormalCtrl:SendKakao()
	Mgr.SendKakao(self.rowdata.ShareContentForm,self.Share2SdkData,self.rowdata.ShareId,function()

	end)
end
function ShareNormalCtrl:Sendfacebook()
	Mgr.SendFacebook(self.rowdata.ShareContentForm,self.Share2SdkData,self.rowdata.ShareId,function()

	end)
end
function ShareNormalCtrl:Savephone()
	if self.rowdata.ShareContentForm ~= Mgr.ShareStyle.Link then
		if self.Share2SdkData ~= nil then
			Mgr.Savephone(self.Share2SdkData)
		end
	end
end
function ShareNormalCtrl:Savexiangce()
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
function ShareNormalCtrl:SetPlayerName(name)
	if self.sharetype == Mgr.ShareID.GarderobeShare then
		self.panel.PlayerName.LabColor = RoColor.Hex2Color("4B6CBB")
	end
	self.panel.PlayerName.LabText = name
end
function ShareNormalCtrl:SetServerName(name)
	if self.sharetype == Mgr.ShareID.GarderobeShare then
		self.panel.ServerName.LabColor = RoColor.Hex2Color("5987E5")
		self.panel.ServerImage.LabColor = RoColor.Hex2Color("5987E5")
	end
	self.panel.ServerName.LabText = name
end
function ShareNormalCtrl:SetInvitationCode(isactive,code)
	self.panel.invitation.gameObject:SetActive(isactive)
	self.panel.invitationCode.LabText = tostring(code)
end
function ShareNormalCtrl:SetQRCode(isactive)
	self.panel.QRCode.gameObject:SetActive(isactive)
	if g_Globals.IsChina then
		self.panel.QRCode:SetRawTexAsync(Mgr.QRcodeType.tencent_qrcode)
	elseif g_Globals.IsKorea then
		self.panel.QRCode:SetRawTexAsync(Mgr.QRcodeType.korea_qrcode)
	end
	--self.panel.QRCode.RawImg = QRcode
end
function ShareNormalCtrl:SetModel(modle)
	self.panel.Model.gameObject:SetActiveEx(false)
	self.panel.ModelImg.gameObject:SetActiveEx(false)
	if Mgr.ShareID.RoleShare == self.sharetype then
		local careerrow = TableUtil.GetProfessionTable().GetRowById(MPlayerInfo.ProfessionId)
		--logError(MPlayerInfo.ProfessionId.." "..careerrow.RrofessionPainting[0].." "..careerrow.RrofessionPainting[1])
		local l_careerImgPath = MPlayerInfo.IsMale and careerrow.RrofessionPainting[0] or careerrow.RrofessionPainting[1]
		if string.find(l_careerImgPath,"Painting") ~= nil then
			self.panel.ModelImg.transform:SetLocalScale(1,1,1)
		end
		self.panel.ModelImg.gameObject:SetActiveEx(true)
		self.panel.ModelImg:SetRawTexAsync(l_careerImgPath,function()
			self.timer = self:NewUITimer(function()
				self:NewTexture(function()
					self:StopUITimer(self.timer)
				end)
			end,1,-1,true)
			self.timer:Start()
		end,true)
	elseif Mgr.ShareID.GarderobeShare == self.sharetype then
		attr = MgrMgr:GetMgr("GarderobeMgr").GetRoleAttr()
		local l_fxData = {}
		l_fxData.rawImage = self.panel.Model.RawImg
		l_fxData.attr = attr
		l_fxData.useShadow = true
		l_fxData.height = 1024 * 1.5
		l_fxData.width = 1024 * 1.5
		l_fxData.enablePostEffect = true
		l_fxData.defaultAnim = MgrMgr:GetMgr("GarderobeMgr").GetRoleAnim(attr)
		
		l_fxData.isCameraPosRotCustom = true
		l_fxData.cameraPos = Vector3.New(0.0, 1.1, -3.10)
		l_fxData.cameraRot = Quaternion.Euler(0.0, 2.0, 0.0)
		
		if attr.EquipData ~= nil and attr.EquipData.FashionItemID > 0 then
			local fashionRow = TableUtil.GetFashionTable().GetRowByFashionID(attr.EquipData.FashionItemID, true)
			if fashionRow ~= nil and fashionRow.IdleAnim ~= nil and fashionRow.IdleAnim ~= "" then
				local animPath = MAnimationMgr:GetClipPath(fashionRow.IdleAnim)
				if animPath ~= nil and animPath ~= "" then
					l_fxData.defaultAnim = animPath
				end
			end
		end
		model = self:CreateUIModel(l_fxData)
		model.LocalPosition = Vector3.New(0.3, 0.0, 0.0)
		model.Scale = Vector3.New(0.9, 0.9, 0.9)
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

function ShareNormalCtrl:NewTexture(callback)
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
function ShareNormalCtrl:SetOthers(flag)
	self.panel.Close.gameObject:SetActive(flag)
	self.panel.channels.gameObject:SetActive(flag)
end

function ShareNormalCtrl:refreshRowImgLogo(status)
	if status then
		self.panel.RawImgLogoChina:SetActiveEx(g_Globals.IsChina)
		self.panel.RawImgLogoKorea:SetActiveEx(g_Globals.IsKorea)
	else
		self.panel.RawImgLogoChina:SetActiveEx(status)
		self.panel.RawImgLogoKorea:SetActiveEx(status)
	end
end

--lua functions end

--lua custom scripts

--lua custom scripts end
return ShareNormalCtrl