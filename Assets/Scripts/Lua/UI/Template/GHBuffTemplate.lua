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
---@class GHBuffTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field BuffPrefabButton MoonClient.MLuaUICom

---@class GHBuffTemplate : BaseUITemplate
---@field Parameter GHBuffTemplateParameter

GHBuffTemplate = class("GHBuffTemplate", super)
colorNormal = "667DB1FF"
colorGreen = "32A293FF"
textSize = 16
--lua class define end

--lua functions
function GHBuffTemplate:Init()
	
	self.data = nil
	self.dataString = ""
	super.Init(self)
	
end --func end
--next--
function GHBuffTemplate:OnDestroy()
	
	self.data = nil
	self.dataString = nil
	
end --func end
--next--
function GHBuffTemplate:OnDeActive()
	
	
end --func end
--next--
function GHBuffTemplate:OnSetData(data)
	
	self.data = data
	self.dataString = ""
	self.Parameter.BuffPrefabButton:SetSprite(data.PicAtlas, data.Pic)
	local l_passCount, l_sealCount = MgrMgr:GetMgr("GuildHuntMgr").BuffGetCount()
	if data.Type == 1 then
		self.dataString = self.dataString .. self:GetRichText(16, colorNormal, data.Name .. "（" .. Lang("STICKER_DEACTIVE_TXT") .. "）")
		self.dataString = self.dataString .. "\n" .. self:GetRichText(16, colorNormal, Lang("CURRENT_EFFECTIVE") .. "：" .. data.NextEffect)
		self.dataString = self.dataString .. "\n" .. self:GetRichText(16, colorNormal, Lang("EFFECTIVE_FROM") .. "：" .. data.NextAccess)
		if data.BuffType == 1 then
			self.dataString = self.dataString .. "\n" .. self:GetRichText(16, colorNormal, Lang("NOW") .. "：" .. l_passCount .. "/" .. data.Time)
		end
	else
		self.dataString = self.dataString .. self:GetRichText(16, colorGreen, data.Name)
		self.dataString = self.dataString .. "\n" .. self:GetRichText(16, colorGreen, Lang("CURRENT_EFFECTIVE") .. "：" .. data.Effect)
		self.dataString = self.dataString .. "\n" .. self:GetRichText(16, colorGreen, Lang("EFFECTIVE_FROM") .. "：" .. data.Access)
		if data.Type == 2 then
			self.dataString = self.dataString .. "\n----------------------------"
			self.dataString = self.dataString .. "\n" .. self:GetRichText(16, colorNormal, Lang("NEXT_EFFECTIVE") .. "：" .. data.NextEffect)
			self.dataString = self.dataString .. "\n" .. self:GetRichText(16, colorNormal, Lang("EFFECTIVE_FROM") .. "：" .. data.NextAccess)
			if data.BuffType == 1 then
				self.dataString = self.dataString .. "\n" .. self:GetRichText(16, colorNormal, Lang("NOW") .. "：" .. l_passCount .. "/" .. data.Time)
			end
		end
	end
	self.Parameter.BuffPrefabButton:SetGray(data.Type == 1)
	self.Parameter.BuffPrefabButton.Listener.onClick = function(go, ed)
		MgrMgr:GetMgr("TipsMgr").ShowQuestionTip(self.dataString, ed, Vector2(0, 0.75), false, nil, nil, nil, 16)
	end
	
end --func end
--next--
function GHBuffTemplate:BindEvents()
	
	
end --func end
--next--
--lua functions end

--lua custom scripts
function GHBuffTemplate:GetRichText(size, color, text)

	local str = ""
	if color == nil then
		color = "FFFFFFFF"
	end
	if size == nil then
		size = 16
	end
	str = str .. "<size=" .. tostring(size) .. ">"
	str = str .. "<color=#" .. color .. ">"
	str = str .. text
	str = str .. "</color></size>"
	return str

end
--lua custom scripts end
return GHBuffTemplate