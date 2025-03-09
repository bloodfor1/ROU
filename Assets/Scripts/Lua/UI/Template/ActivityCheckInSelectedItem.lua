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
local l_mgr = MgrMgr:GetMgr("ActivityCheckInMgr")
--lua fields end

--lua class define
---@class ActivityCheckInSelectedItemParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field Dice MoonClient.MLuaUICom

---@class ActivityCheckInSelectedItem : BaseUITemplate
---@field Parameter ActivityCheckInSelectedItemParameter

ActivityCheckInSelectedItem = class("ActivityCheckInSelectedItem", super)
--lua class define end

--lua functions
function ActivityCheckInSelectedItem:Init()
	
	super.Init(self)
	
end --func end
--next--
function ActivityCheckInSelectedItem:BindEvents()
	
	
end --func end
--next--
function ActivityCheckInSelectedItem:OnDestroy()
	
	
end --func end
--next--
function ActivityCheckInSelectedItem:OnDeActive()
	
	
end --func end
--next--
function ActivityCheckInSelectedItem:OnSetData(data)
	
	local num = data.m_num or 0
	if num > 0 then
		self.Parameter.Dice:SetSprite(l_mgr.ImgNames.Atlas, l_mgr.ImgNames.Dice[num])
	else
		self.Parameter.Dice:SetSprite(l_mgr.ImgNames.Atlas, l_mgr.ImgNames.Dice[1])
		logError("some thing is error，check it")
	end
end --func end
--next--
--lua functions end

--lua custom scripts

--lua custom scripts end
return ActivityCheckInSelectedItem