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
local C_DEFAULT_ATLAS = "Common"
local guildRankMgr = MgrMgr:GetMgr("GuildRankMgr")
local C_NIL_STR = "NIL"
--lua fields end

--lua class define
---@class GuildRankIconTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field Txt_Name_1 MoonClient.MLuaUICom
---@field Txt_lv MoonClient.MLuaUICom
---@field Panel_Head2 MoonClient.MLuaUICom
---@field Img_Pro_1 MoonClient.MLuaUICom
---@field Head2D MoonClient.MLuaUICom
---@field Btn_Member2 MoonClient.MLuaUICom

---@class GuildRankIconTemplate : BaseUITemplate
---@field Parameter GuildRankIconTemplateParameter

GuildRankIconTemplate = class("GuildRankIconTemplate", super)
--lua class define end

--lua functions
function GuildRankIconTemplate:Init()
    super.Init(self)
    self:_initWidgets()

    ---@type GuildMainMemberData
    self._data = nil
end --func end
--next--
function GuildRankIconTemplate:BindEvents()


end --func end
--next--
function GuildRankIconTemplate:OnDestroy()


end --func end
--next--
function GuildRankIconTemplate:OnDeActive()


end --func end
--next--
---@param data GuildMainMemberData
function GuildRankIconTemplate:OnSetData(data)
    if GameEnum.ELuaBaseType.String == type(data) and C_NIL_STR == data then
        self:_setData(nil)
        return
    end

    self:_setData(data)
end --func end
--next--
--lua functions end

--lua custom scripts

function GuildRankIconTemplate:_initWidgets()
    local onClick = function()
        self:_onHeadIconClick()
    end

    self.Parameter.Btn_Member2:AddClick(onClick)
end

---@param data GuildMainMemberData
function GuildRankIconTemplate:_setData(data)
    if nil == data then
        self:SetGameObjectActive(false)
        return
    end

    self._data = data
    self:SetGameObjectActive(true)
    self.Parameter.Txt_Name_1.LabText = tostring(data.Name)
    self.Parameter.Txt_lv.LabText = tostring(data.Level)
    local atlasName, spriteName = self:_getProfessionIconData(data.Profession)
    if nil ~= atlasName and nil ~= spriteName then
        self.Parameter.Img_Pro_1:SetSpriteAsync(atlasName, spriteName)
    end

    local csData = guildRankMgr.ParsePlayerIconData(data)
    if nil == csData then
        logError("[GuildRank] parse failed")
        return
    end

    self.Parameter.Head2D.Head2D:SetRoleHead(csData)
end

function GuildRankIconTemplate:_onHeadIconClick()
    guildRankMgr.OnSingleIconClick(self._data.UID)
end

--- 返回两个数据，一个是图集名，一个是图名
---@return string, string
function GuildRankIconTemplate:_getProfessionIconData(proID)
    local professionConfig = TableUtil.GetProfessionTable().GetRowById(proID, false)
    if nil == professionConfig then
        return nil, nil
    end

    return C_DEFAULT_ATLAS, professionConfig.ProfessionIcon
end
--lua custom scripts end
return GuildRankIconTemplate