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
---@class TeamPlayerDutyTagParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field Label MoonClient.MLuaUICom
---@field Icon MoonClient.MLuaUICom

---@class TeamPlayerDutyTag : BaseUITemplate
---@field Parameter TeamPlayerDutyTagParameter

TeamPlayerDutyTag = class("TeamPlayerDutyTag", super)
--lua class define end

--lua functions
function TeamPlayerDutyTag:Init()
    super.Init(self)
end --func end
--next--
function TeamPlayerDutyTag:BindEvents()
    -- do nothing
end --func end
--next--
function TeamPlayerDutyTag:OnDestroy()
    -- do nothing
end --func end
--next--
function TeamPlayerDutyTag:OnDeActive()
    -- do nothing
end --func end
--next--
function TeamPlayerDutyTag:OnSetData(data)
    self:_onSetData(data)
end --func end
--next--
--lua functions end

--lua custom scripts
---@param dutyID number
function TeamPlayerDutyTag:_onSetData(dutyID)
    if nil == dutyID then
        logError("[TeamMatch] invalid param")
        return
    end

    local config = TableUtil.GetMatchDutyTable().GetRowByID(dutyID)
    if nil == config then
        logError("[TeamMatch] invalid duty id: " .. tostring(dutyID))
        return
    end

    self.Parameter.Label.LabText = config.DutyName
    self.Parameter.Icon:SetSpriteAsync(config.Atlas, config.Icon)
    self.Parameter.Icon.Img:SetNativeSize()
end

--lua custom scripts end
return TeamPlayerDutyTag