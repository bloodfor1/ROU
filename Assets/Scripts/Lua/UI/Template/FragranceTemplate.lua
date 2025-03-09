--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/BaseUITemplate"
--lua requires end

--lua model
module("UITemplate", package.seeall)

--lua model end

--lua fields
local super = UITemplate.BaseUITemplate
--lua fields end

--lua class define
---@class FragranceTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field Raw_Effect MoonClient.MLuaUICom
---@field Img_Choice MoonClient.MLuaUICom
---@field Effect_Select MoonClient.MLuaUICom
---@field Btn_FragranceGif MoonClient.MLuaUICom

---@class FragranceTemplate : BaseUITemplate
---@field Parameter FragranceTemplateParameter

FragranceTemplate = class("FragranceTemplate", super)
--lua class define end

--lua functions
function FragranceTemplate:Init()
	
	super.Init(self)
	---@type MagicLetterMgr
	self.magicLetterMgr = MgrMgr:GetMgr("MagicLetterMgr")
	
end --func end
--next--
function FragranceTemplate:BindEvents()
	
	
end --func end
--next--
function FragranceTemplate:OnDestroy()
	
	
end --func end
--next--
function FragranceTemplate:OnDeActive()
	
	self.mediaPlayer = nil
	
end --func end
--next--
function FragranceTemplate:OnSetData(data)
	
	---@type MagicPaperTypeTable
	    self.fragranceData = data
	if self.fragranceData==nil then
		return
	end
	self.mediaPlayer = self.Parameter.Raw_Effect.gameObject:GetComponent("MediaPlayer")
	self:closeMovie()
	local l_location = self.magicLetterMgr.GetFragranceEffectMoviePath(self.fragranceData.MagicPaperVideo)
	local l_isChoosed = self.fragranceData.MagicPaperID == self.magicLetterMgr.GetFragranceEffectId()
	if VideoPlayerMgr.IsMovieExist(l_location) then
		self.Parameter.Raw_Effect.gameObject:SetActiveEx(true)
		local l_url = VideoPlayerMgr.GetVideoUrl(l_location, MoonCommonLib.EFileLocation.RelativeToStreamingAssetsFolder)
		self.mediaPlayer:OpenVideoFromFile(MoonCommonLib.EFileLocation.RelativeToStreamingAssetsFolder, l_url, l_isChoosed)
	else
		self.Parameter.Raw_Effect.gameObject:SetActiveEx(false)
	end
	self.Parameter.Img_Choice:SetActiveEx(l_isChoosed)
	self.Parameter.Btn_FragranceGif:AddClick(function()
		local l_isChoosed = self.fragranceData.MagicPaperID == self.magicLetterMgr.GetFragranceEffectId()
		if not l_isChoosed then
			self.magicLetterMgr.SetFragranceEffectId(self.fragranceData.MagicPaperID)
		end
	end,true)
	self:UpdateSelected()
end --func end
--next--
--lua functions end

--lua custom scripts
function FragranceTemplate:UpdateSelected()
	local l_isChoosed = self.fragranceData.MagicPaperID == self.magicLetterMgr.GetFragranceEffectId()
	
	if self.mediaPlayer then
		if l_isChoosed then
			self.mediaPlayer:Play()
			self.Parameter.Effect_Select:SetActiveEx(true)
		else
			self.mediaPlayer:Rewind(true)
			self.Parameter.Effect_Select:SetActiveEx(false)
		end
	end
	self.Parameter.Img_Choice:SetActiveEx(l_isChoosed)
end

function FragranceTemplate:closeMovie()
	
	if self.mediaPlayer then
		self.mediaPlayer:Pause()
	end
end
--lua custom scripts end
return FragranceTemplate