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
---@class AchievementGetBadgeStarTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field StarShow MoonClient.MLuaUICom
---@field StarFX MoonClient.MLuaUICom

---@class AchievementGetBadgeStarTemplate : BaseUITemplate
---@field Parameter AchievementGetBadgeStarTemplateParameter

AchievementGetBadgeStarTemplate = class("AchievementGetBadgeStarTemplate", super)
--lua class define end

--lua functions
function AchievementGetBadgeStarTemplate:Init()

    super.Init(self)

end --func end
--next--
function AchievementGetBadgeStarTemplate:BindEvents()


end --func end
--next--
function AchievementGetBadgeStarTemplate:OnDestroy()
    self.Parameter.StarFX:StopDynamicEffect()

end --func end
--next--
function AchievementGetBadgeStarTemplate:OnDeActive()


end --func end
--next--
function AchievementGetBadgeStarTemplate:OnSetData(data)
    self:_showStar(data)

end --func end
--next--
--lua functions end

--lua custom scripts
local _intervalTime=0.3
function AchievementGetBadgeStarTemplate:_showStar(data)
    local l_isLight=false
    if data then
        l_isLight=data.IsLight
    end
    self.Parameter.StarShow:SetActiveEx(false)
    if l_isLight then
        self.Parameter.StarFX:SetActiveEx(false)
        local l_delayTime = (self.ShowIndex - 1) * _intervalTime
        self.Parameter.StarFX:PlayDynamicEffect(1, {
            delayTime = l_delayTime,
            destroyCallback = function()
                self.Parameter.StarShow:SetActiveEx(true)
            end
        })
    else
        self.Parameter.StarFX:SetActiveEx(false)
    end
end
--lua custom scripts end
return AchievementGetBadgeStarTemplate