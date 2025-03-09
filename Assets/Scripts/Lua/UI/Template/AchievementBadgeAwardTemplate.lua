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
---@class AchievementBadgeAwardTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field Icon MoonClient.MLuaUICom
---@field Count MoonClient.MLuaUICom

---@class AchievementBadgeAwardTemplate : BaseUITemplate
---@field Parameter AchievementBadgeAwardTemplateParameter

AchievementBadgeAwardTemplate = class("AchievementBadgeAwardTemplate", super)
--lua class define end

--lua functions
function AchievementBadgeAwardTemplate:Init()
	
	    super.Init(self)
	
end --func end
--next--
function AchievementBadgeAwardTemplate:OnDestroy()
	
	
end --func end
--next--
function AchievementBadgeAwardTemplate:OnDeActive()
	
	
end --func end
--next--
function AchievementBadgeAwardTemplate:OnSetData(data)
	
	    local l_privilegeSystemDesTableInfo = TableUtil.GetPrivilegeSystemDesTable().GetRowById(data)
	    self.Parameter.Icon:SetSpriteAsync(l_privilegeSystemDesTableInfo.SystemAtlas, l_privilegeSystemDesTableInfo.SystemIcon, nil, true)
	
end --func end
--next--
function AchievementBadgeAwardTemplate:BindEvents()
	
	
end --func end
--next--
--lua functions end

--lua custom scripts

--lua custom scripts end
return AchievementBadgeAwardTemplate