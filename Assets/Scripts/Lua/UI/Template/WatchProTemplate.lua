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
---@class WatchProTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field WatchProTemplate MoonClient.MLuaUICom

---@class WatchProTemplate : BaseUITemplate
---@field Parameter WatchProTemplateParameter

WatchProTemplate = class("WatchProTemplate", super)
--lua class define end

--lua functions
function WatchProTemplate:Init()
	
	super.Init(self)
	
end --func end
--next--
function WatchProTemplate:OnDestroy()
	
	
end --func end
--next--
function WatchProTemplate:OnDeActive()
	
	
end --func end
--next--
function WatchProTemplate:OnSetData(data)
	
	local l_imageName
	if data and data > 0 then
		l_imageName = DataMgr:GetData("TeamData").GetProfessionImageById(data)
	end
	l_imageName = l_imageName or "UI_Common_LiebiaoKuang_03.png"
	self.Parameter.WatchProTemplate:SetSpriteAsync("Common", l_imageName)
	
end --func end
--next--
function WatchProTemplate:BindEvents()
	
	
end --func end
--next--
--lua functions end

--lua custom scripts

--lua custom scripts end
return WatchProTemplate