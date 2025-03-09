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
---@class PlayeLeftTagParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field PlayeLeftTag MoonClient.MLuaUICom

---@class PlayeLeftTag : BaseUITemplate
---@field Parameter PlayeLeftTagParameter

PlayeLeftTag = class("PlayeLeftTag", super)
--lua class define end

--lua functions
function PlayeLeftTag:Init()
    super.Init(self)
end --func end
--next--
function PlayeLeftTag:BindEvents()
    -- do nothing
end --func end
--next--
function PlayeLeftTag:OnDestroy()
    -- do nothing
end --func end
--next--
function PlayeLeftTag:OnDeActive()
    -- do nothing
end --func end
--next--
function PlayeLeftTag:OnSetData(data)
    self:_onSetData(data)
end --func end
--next--
--lua functions end

--lua custom scripts
---@param data BattleFieldTagData
function PlayeLeftTag:_onSetData(data)
    if nil == data then
        logError("[BattleFieldTag] invalid data")
        return
    end

    local battleMgr = MgrMgr:GetMgr("BattleMgr")
    local atlasName, spriteName = battleMgr.GetPlayerTag(data.tagType)
    if nil == atlasName or nil == spriteName then
        logError("[BattleFieldTag] invalid data")
        return
    end

    self.Parameter.PlayeLeftTag:SetSpriteAsync(atlasName, spriteName)
end

--lua custom scripts end
return PlayeLeftTag