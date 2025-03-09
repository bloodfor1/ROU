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
---@class ReturnGiftParameter
---@field PanelRef MoonClient.MLuaUIPanel

---@class ReturnGift : BaseUITemplate
---@field Parameter ReturnGiftParameter

ReturnGift = class("ReturnGift", super)
--lua class define end

--lua functions
function ReturnGift:Init()
	
	super.Init(self)

	self.Parameter.Choice:OnToggleChanged(function(value)
		self:onTglChange(value)
	end)

	self.mgr = MgrMgr:GetMgr("ReBackMgr")
	
end --func end
--next--
function ReturnGift:BindEvents()
	
	
end --func end
--next--
function ReturnGift:OnDestroy()
	
	
end --func end
--next--
function ReturnGift:OnDeActive()
	
	
end --func end
--next--
function ReturnGift:OnSetData(UID)

	self.UID = UID
	MgrMgr:GetMgr("PlayerInfoMgr").GetPlayerInfoFromServer(UID,function(info)
		if info~=nil then
			self.Parameter.FriendName.LabText = info.name
			---@type HeadTemplateParam
			local param = {
				EquipData = MgrMgr:GetMgr("PlayerInfoMgr").GetEquipData(info),
				ShowProfession = true,
				Profession = info.type,
				ShowLv = true,
				Level = info.base_level
			}
			self.Parameter.head:SetData(param)
		else
			logError("没有找到好友，UID == "..tostring(UID))
		end
	end)
	
end --func end
--next--
--lua functions end

--lua custom scripts

function ReturnGift:onTglChange(value)
	self.mgr.l_eventDispatcher:Dispatch(self.mgr.SIG_WELCOME_FRIEND_CHOOSE_CHANGE,self.UID,value)
end

--lua custom scripts end
return ReturnGift