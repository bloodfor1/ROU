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
---@class GuildRankActScoreTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field Txt_Title MoonClient.MLuaUICom
---@field Txt_Score_Not_Open MoonClient.MLuaUICom
---@field Txt_Score MoonClient.MLuaUICom
---@field Txt_Logo_Not_Open MoonClient.MLuaUICom
---@field Text_ScoreDesc MoonClient.MLuaUICom
---@field Img MoonClient.MLuaUICom

---@class GuildRankActScoreTemplate : BaseUITemplate
---@field Parameter GuildRankActScoreTemplateParameter

GuildRankActScoreTemplate = class("GuildRankActScoreTemplate", super)
--lua class define end

--lua functions
function GuildRankActScoreTemplate:Init()
    super.Init(self)
end --func end
--next--
function GuildRankActScoreTemplate:BindEvents()
    -- do nothing
end --func end
--next--
function GuildRankActScoreTemplate:OnDestroy()
    -- do nothing
end --func end
--next--
function GuildRankActScoreTemplate:OnDeActive()
    -- do nothing

end --func end
--next--
function GuildRankActScoreTemplate:OnSetData(data)
    self:_setData(data)
end --func end
--next--
--lua functions end

--lua custom scripts
---@param data GuildRankScoreData
function GuildRankActScoreTemplate:_setData(data)
    if nil == data then
        logError("[GuildRankActScore] param got nil")
        return
    end

    self.Parameter.Txt_Title.LabText = data.name
    self.Parameter.Img:SetSpriteAsync(data.atlasName, data.spriteName, nil, true)
    self.Parameter.Txt_Score.LabText = tostring(data.score)
    self.Parameter.Txt_Logo_Not_Open.LabText = data.desc
    self.Parameter.Text_ScoreDesc.LabText = data.desc

    self.Parameter.Txt_Title.gameObject:SetActiveEx(data.isOpening)
    self.Parameter.Txt_Score.gameObject:SetActiveEx(data.isOpening)
    self.Parameter.Text_ScoreDesc.gameObject:SetActiveEx(data.isOpening)
    self.Parameter.Txt_Logo_Not_Open.gameObject:SetActiveEx(not data.isOpening)
    self.Parameter.Txt_Score_Not_Open.gameObject:SetActiveEx(not data.isOpening)
end
--lua custom scripts end
return GuildRankActScoreTemplate