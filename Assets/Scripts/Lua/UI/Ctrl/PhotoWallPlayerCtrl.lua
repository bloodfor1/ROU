--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/PhotoWallPlayerPanel"
require "Common/ActionQueue"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua fields
local super = UI.UIBaseCtrl
--next--
--lua fields end

--lua class define
PhotoWallPlayerCtrl = class("PhotoWallPlayerCtrl", super)
--lua class define end

--lua functions
function PhotoWallPlayerCtrl:ctor()

	super.ctor(self, CtrlNames.PhotoWallPlayer, UILayer.Function, nil, ActiveType.Exclusive)
	self.photoPaths = {}
	self.currentPhotoIndex = 0
	self.actionQueue = Common.ActionQueue.new()
	self.tweenIdTable = {}

end --func end
--next--
function PhotoWallPlayerCtrl:Init()

	self.panel = UI.PhotoWallPlayerPanel.Bind(self)
	super.Init(self)
	self.panel.BtnClose:AddClick(function()
		UIMgr:DeActiveUI(UI.CtrlNames.PhotoWallPlayer)
	end)

end --func end
--next--
function PhotoWallPlayerCtrl:Uninit()

	super.Uninit(self)
	self.panel = nil
	self.photoPaths = {}
	self.actionQueue:Clear()

end --func end
--next--
function PhotoWallPlayerCtrl:OnActive()


end --func end
--next--
function PhotoWallPlayerCtrl:OnDeActive()

	self.photoPaths = {}
	self.actionQueue:Clear()
	for k,v in pairs(self.tweenIdTable) do
		MUITweenHelper.KillTween(k)
	end
	self.tweenIdTable = {}

end --func end
--next--
function PhotoWallPlayerCtrl:Update()


end --func end





--next--
function PhotoWallPlayerCtrl:BindEvents()


end --func end

--next--
--lua functions end

--lua custom scripts

function PhotoWallPlayerCtrl:InitWithPhotoPathTable(photos, index)
	self.photoPaths = photos
	self.currentPhotoIndex = index
	self.startIndex = self.currentPhotoIndex
	self:PlayWithCurrentPhoto(true)

end

function PhotoWallPlayerCtrl:PlayWithCurrentPhoto(isFirst)

	if not isFirst and self.currentPhotoIndex == self.startIndex then
		UIMgr:DeActiveUI(UI.CtrlNames.PhotoWallPlayer)
		return
	end

	local l_photoTexture = MgrMgr:GetMgr("AlbumMgr")
		.GetPhotoTexture(self.photoPaths[self.currentPhotoIndex], true, TextureFormat.RGB24)

	if l_photoTexture ~= nil then
		self.panel.ImgPhoto:SetNativeTexture(l_photoTexture)
	end

	local l_canvasGroup = self.panel.ImgPhoto.Transform.parent:GetComponent("CanvasGroup")
	l_canvasGroup.alpha = 0

	self.actionQueue:AddAciton(function(cb)
		l_canvasGroup.transform:DORotate(Vector3.New(0, 0, math.random(-5, 5)), 1.2)
		local l_tweenId 
		l_tweenId = MUITweenHelper.TweenAlpha(l_canvasGroup.gameObject, 0, 1, 1, function()
			self.tweenIdTable[l_tweenId] = nil
			if cb ~= nil then
				cb()
			end
		end)
		self.tweenIdTable[l_tweenId] = true

	end):AddAciton(function(cb)
		local l_timer = self:NewUITimer(function()
			cb()
		end, 2)
		l_timer:Start()
	end):AddAciton(function(cb)
		l_canvasGroup.transform:DORotate(Vector3.New(0, 0, math.random(-5, 5)), 1.2)
		l_tweenId = MUITweenHelper.TweenAlpha(l_canvasGroup.gameObject, 1, 0, 1, function()
			self.tweenIdTable[l_tweenId] = nil
			if cb ~= nil then
				cb()
			end
		end)
		self.tweenIdTable[l_tweenId] = true
	end):AddAciton(function(cb)
		self.currentPhotoIndex = self.currentPhotoIndex + 1
		if self.currentPhotoIndex > #self.photoPaths then
			self.currentPhotoIndex = 1
		end
		self:PlayWithCurrentPhoto(false)
		if cb ~= nil then
			cb()
		end
	end)


end

--lua custom scripts end
