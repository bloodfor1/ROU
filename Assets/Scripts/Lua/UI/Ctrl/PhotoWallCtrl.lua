--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/PhotoWallPanel"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua fields
local super = UI.UIBaseCtrl
--next--
--lua fields end

--lua class define
PhotoWallCtrl = class("PhotoWallCtrl", super)
--lua class define end

--lua functions
function PhotoWallCtrl:ctor()

	super.ctor(self, CtrlNames.PhotoWall, UILayer.Function, nil, ActiveType.Exclusive)
	self.photoPaths = {}
	self.photoDesc = {}
	self.currentPhotoIndex = 0
	--self:SetBlockOpt(BlockColor.Dark)
	self.GroupMaskType = GroupMaskType.Show
	self.MaskColor=BlockColor.Dark

end --func end
--next--
function PhotoWallCtrl:Init()

	self.panel = UI.PhotoWallPanel.Bind(self)
	super.Init(self)
	self.panel.BtnAutoPlay:AddClick(function()
		UIMgr:ActiveUI(UI.CtrlNames.PhotoWallPlayer, function(ctrl)
			ctrl:InitWithPhotoPathTable(self.photoPaths, self.currentPhotoIndex)
		end)
	end)
	self.panel.BtnClose:AddClick(function()
		UIMgr:DeActiveUI(UI.CtrlNames.PhotoWall)
	end)
	self.panel.BtnNext:AddClick(function()
		self:OnNextPhoto()
	end)
	self.panel.BtnPrev:AddClick(function()
		self:OnPrevPhoto()
	end)

end --func end
--next--
function PhotoWallCtrl:Uninit()

	super.Uninit(self)
	self.panel = nil
	self.photoPaths = {}
	self.photoDesc = {}

end --func end
--next--
function PhotoWallCtrl:OnActive()

	self.panel.BtnNext.gameObject:SetActive(self.currentPhotoIndex < #self.photoPaths)
	self.panel.BtnPrev.gameObject:SetActive(self.currentPhotoIndex > 1)

end --func end
--next--
function PhotoWallCtrl:OnDeActive()

	self.photoPaths = {}
	self.photoDesc = {}

end --func end
--next--
function PhotoWallCtrl:Update()


end --func end





--next--
function PhotoWallCtrl:BindEvents()


end --func end

--next--
--lua functions end

--lua custom scripts

function PhotoWallCtrl:InitWithPhotoPathTable(photos, photoDesc, index)
	self.photoPaths = photos
	self.photoDesc = photoDesc
	self.currentPhotoIndex = index
	local l_photoTexture = MgrMgr:GetMgr("AlbumMgr")
		.GetPhotoTexture(self.photoPaths[self.currentPhotoIndex], true, TextureFormat.RGB24)
    if l_photoTexture ~= nil then
        self.panel.ImgPhoto:SetNativeTexture(l_photoTexture)
	end

	local l_photoDesc = self.photoDesc[self.currentPhotoIndex]
	if not l_photoDesc or #l_photoDesc <= 1 then
		self.panel.DescPanel.gameObject:SetActiveEx(false)
		self.panel.Name.LabText = ""
	else
		self.panel.DescPanel.gameObject:SetActiveEx(true)
		self.panel.Name.LabText = l_photoDesc
	end
end

function PhotoWallCtrl:OnNextPhoto()
	if self.currentPhotoIndex == #self.photoPaths then
		return
	end
	self.currentPhotoIndex = self.currentPhotoIndex + 1

	local l_photoTexture = MgrMgr:GetMgr("AlbumMgr")
		.GetPhotoTexture(self.photoPaths[self.currentPhotoIndex], true, TextureFormat.RGB24)

	if l_photoTexture ~= nil then
		self.panel.ImgPhoto:SetNativeTexture(l_photoTexture)
	end

	local l_photoDesc = self.photoDesc[self.currentPhotoIndex]
	if not l_photoDesc or #l_photoDesc <= 1 then
		self.panel.DescPanel.gameObject:SetActiveEx(false)
		self.panel.Name.LabText = ""
	else
		self.panel.DescPanel.gameObject:SetActiveEx(true)
		self.panel.Name.LabText = l_photoDesc
	end

	self.panel.BtnNext.gameObject:SetActiveEx(self.currentPhotoIndex ~= #self.photoPaths)
	self.panel.BtnPrev.gameObject:SetActiveEx(self.currentPhotoIndex - 1 ~= 0)
end

function PhotoWallCtrl:OnPrevPhoto()

	if self.currentPhotoIndex - 1 == 0 then
		return
	end
	self.currentPhotoIndex = self.currentPhotoIndex - 1

	local l_photoTexture = MgrMgr:GetMgr("AlbumMgr")
		.GetPhotoTexture(self.photoPaths[self.currentPhotoIndex], true, TextureFormat.RGB24)

	if l_photoTexture ~= nil then
		self.panel.ImgPhoto:SetNativeTexture(l_photoTexture)
	end

	local l_photoDesc = self.photoDesc[self.currentPhotoIndex]
	if not l_photoDesc or #l_photoDesc <= 1 then
		self.panel.DescPanel.gameObject:SetActiveEx(false)
		self.panel.Name.LabText = ""
	else
		self.panel.DescPanel.gameObject:SetActiveEx(true)
		self.panel.Name.LabText = l_photoDesc
	end


	self.panel.BtnNext.gameObject:SetActiveEx(self.currentPhotoIndex ~= #self.photoPaths)
	self.panel.BtnPrev.gameObject:SetActiveEx(self.currentPhotoIndex - 1 ~= 0)
end

return PhotoWallCtrl
--lua custom scripts end
