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
---@class MainWatchWarTeamTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field TextK MoonClient.MLuaUICom
---@field TextD MoonClient.MLuaUICom
---@field TextA MoonClient.MLuaUICom
---@field SliderMP MoonClient.MLuaUICom
---@field SliderHP MoonClient.MLuaUICom
---@field Single MoonClient.MLuaUICom
---@field PlayerLvTxt MoonClient.MLuaUICom
---@field NoTeam MoonClient.MLuaUICom
---@field Name MoonClient.MLuaUICom
---@field ImagePro MoonClient.MLuaUICom
---@field Head2D MoonClient.MLuaUICom
---@field Expand MoonClient.MLuaUICom
---@field Checkmark MoonClient.MLuaUICom
---@field BG MoonClient.MLuaUICom

---@class MainWatchWarTeamTemplate : BaseUITemplate
---@field Parameter MainWatchWarTeamTemplateParameter

MainWatchWarTeamTemplate = class("MainWatchWarTeamTemplate", super)
--lua class define end

--lua functions
function MainWatchWarTeamTemplate:Init()
    super.Init(self)
    self.head2d = self:NewTemplate("HeadWrapTemplate", {
        TemplateParent = self.Parameter.Single.transform,
        TemplatePath = "UI/Prefabs/HeadWrapTemplate"
    })

    self.mgr = MgrMgr:GetMgr("WatchWarMgr")
    self.lastHp = nil
    self.lastSp = nil
    self.lastKill = nil
    self.lastDead = nil
    self.lastAssist = nil
    self.hasInit = nil
    self.customVisible = nil
    self.lastDisplayRoleId = nil

end --func end
--next--
function MainWatchWarTeamTemplate:BindEvents()
    self:BindEvent(self.mgr.EventDispatcher, self.mgr.ON_MAIN_WATCH_BRIEF_INFO_UPDATE, self.OnRoomBriefStatusUpdate)
    self:BindEvent(self.mgr.EventDispatcher, self.mgr.ON_SWITCH_WATCH_PLAYER, self.UpdateCheckmark)
end --func end
--next--
function MainWatchWarTeamTemplate:OnDestroy()
    self.head2d = nil
    self.lastHp = nil
    self.lastSp = nil
    self.lastKill = nil
    self.lastDead = nil
    self.lastAssist = nil
    self.hasInit = nil
    self.dataIndex = nil
    self.teamIndex = nil
    self.customVisible = nil
    self.lastDisplayRoleId = nil
    self.mgr = nil
end --func end
--next--
function MainWatchWarTeamTemplate:OnDeActive()
    -- do nothing
end --func end
--next--
function MainWatchWarTeamTemplate:OnSetData(data)
    self:CustomSetData(data)
end --func end
--next--
--lua functions end

--lua custom scripts
function MainWatchWarTeamTemplate:CustomSetData(data)
    self.hasInit = true
    self.dataIndex = data.dataIndex
    self.teamId = data.teamId
    self:UpdateExpand(data.expand)
    self:OnRoomBriefStatusUpdate()
    self:UpdateCheckmark()
    self.Parameter.BG:AddClick(function()
        self.mgr.WatcherSwitchPlayer(self.mgr.GetWatchUnitIdByTeamAndIndex(self.teamId, self.dataIndex))
    end)
end

function MainWatchWarTeamTemplate:SetTemplateVisible(visible)
    if self.customVisible == visible then
        return
    end

    self.customVisible = visible
    self.Parameter.BG.gameObject:SetActiveEx(self.customVisible)
    self.Parameter.NoTeam.gameObject:SetActiveEx(not self.customVisible)
end

-- 有变化时才做更新
function MainWatchWarTeamTemplate:UpdateHpSp(hp, sp)
    if hp and self.lastHp ~= hp then
        self.lastHp = hp
        self.Parameter.SliderHP.Slider.value = hp / 100
    end

    if sp and self.lastSp ~= sp then
        self.lastSp = sp
        self.Parameter.SliderMP.Slider.value = sp / 100
    end
end

-- 有变化时才做更新
function MainWatchWarTeamTemplate:UpdateKDA(k, d, a)
    if k and self.lastKill ~= k then
        self.lastKill = k
        self.Parameter.TextK.LabText = k
    end

    if d and self.lastDead ~= d then
        self.lastDead = d
        self.Parameter.TextD.LabText = d
    end

    if a and self.lastAssist ~= a then
        self.lastAssist = a
        self.Parameter.TextA.LabText = a
    end
end

function MainWatchWarTeamTemplate:UpdateExpand(expand)
    self.Parameter.Expand.gameObject:SetActiveEx(expand)
    MLuaCommonHelper.SetRectTransformWidth(self.Parameter.BG.gameObject, expand and 274 or 200.4)
    MLuaCommonHelper.SetRectTransformWidth(self.Parameter.NoTeam.gameObject, expand and 274 or 200.4)
    MLuaCommonHelper.SetRectTransformWidth(self.Parameter.Checkmark.gameObject, expand and 288 or 216)
end

function MainWatchWarTeamTemplate:UpdateCheckmark()
    local l_displayRoleId = self.mgr.GetWatchUnitIdByTeamAndIndex(self.teamId, self.dataIndex)
    local l_visible = false
    if l_displayRoleId and tostring(l_displayRoleId) == tostring(MPlayerInfo.WatchFocusPlayerId) then
        l_visible = true
    end

    self.Parameter.Checkmark.gameObject:SetActiveEx(l_visible)
end

function MainWatchWarTeamTemplate:OnRoomBriefStatusUpdate()
    -- 未初始化前不好处理
    if not self.hasInit then
        return
    end

    -- 无数据则显示为空
    local l_displayRoleId = self.mgr.GetWatchUnitIdByTeamAndIndex(self.teamId, self.dataIndex)
    if not l_displayRoleId then
        self:SetTemplateVisible(false)
        return
    end

    -- 无数据则显示为空
    local l_data = self.mgr.GetWatchUnitInfoByRoleId(l_displayRoleId)
    if not l_data then
        self:SetTemplateVisible(false)
        return
    end

    -- 显示角色不一致时，刷新头像等信息
    if l_displayRoleId ~= self.lastDisplayRoleId then
        self.lastDisplayRoleId = l_displayRoleId
        ---@type HeadTemplateParam
        local param = {}
        if l_data.is_hit_outlook then
            param.EquipData = MgrMgr:GetMgr("PlayerInfoMgr").GetDefaultEquip(l_data.avatar_info.type, l_data.avatar_info.sex)
            param.ShowProfession = true
            param.Profession = l_data.avatar_info.type
            param.IsMale = l_data.avatar_info.sex
        else

            param.EquipData = MgrMgr:GetMgr("PlayerInfoMgr").GetEquipData(l_data.avatar_info)
        end

        self.head2d:SetData(param)
        self.Parameter.Name.LabText = self:getDisplayName(l_data)
        self.Parameter.PlayerLvTxt.LabText = l_data.avatar_info.base_level
        self.Parameter.ImagePro:SetSpriteAsync("Common", DataMgr:GetData("TeamData").GetProfessionImageById(l_data.avatar_info.type) or "")
    end

    -- 更新状态信息
    if not l_data.is_in_dungeon then
        return
    end

    self:UpdateHpSp(l_data.hp, l_data.sp)
    self:UpdateKDA(l_data.kill, l_data.dead, l_data.assist)
    self:SetTemplateVisible(true)
end

function MainWatchWarTeamTemplate:getDisplayName(data)
    if data.is_hit_outlook then
        return Lang("Mysterious_Adventurer")
    else
        return data.name
    end
end
--lua custom scripts end
return MainWatchWarTeamTemplate