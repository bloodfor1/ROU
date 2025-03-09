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
---@class GuildItemTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field Prefab MoonClient.MLuaUICom
---@field MemberNum MoonClient.MLuaUICom
---@field ItemButton MoonClient.MLuaUICom
---@field IsSelected MoonClient.MLuaUICom
---@field IsApplied MoonClient.MLuaUICom
---@field GuildName MoonClient.MLuaUICom
---@field GuildLv MoonClient.MLuaUICom
---@field GuildIcon MoonClient.MLuaUICom
---@field ChairmanSexIcon MoonClient.MLuaUICom
---@field ChairmanName MoonClient.MLuaUICom

---@class GuildItemTemplate : BaseUITemplate
---@field Parameter GuildItemTemplateParameter

GuildItemTemplate = class("GuildItemTemplate", super)
--lua class define end

--lua functions
function GuildItemTemplate:Init()

    super.Init(self)

end --func end
--next--
function GuildItemTemplate:OnDeActive()


end --func end
--next--

--data 传入的数据(这里是公会列表中的单个公会数据)
function GuildItemTemplate:OnSetData(data)
    self.data = data  -- 记录数据 点击回调用
    local l_iconData = TableUtil.GetGuildIconTable().GetRowByGuildIconID(data.icon_id)
    self.Parameter.GuildIcon:SetSprite(l_iconData.GuildIconAltas, l_iconData.GuildIconName)
    self.Parameter.GuildName.LabText = data.name
    self.Parameter.GuildLv.LabText = "Lv." .. data.level
    self.Parameter.MemberNum.LabText = data.cur_member .. "/" .. data.total_member
    self.Parameter.ChairmanName.LabText = data.chairman.base_info.name
    self.Parameter.IsSelected.UObj:SetActiveEx(false)
    if data.chairman.base_info.sex ~= 0 then
        self.Parameter.ChairmanSexIcon:SetSprite("Common", "UI_Common_TypeFemale.png", true)
    else
        self.Parameter.ChairmanSexIcon:SetSprite("Common", "UI_Common_TypeMale.png", true)
    end
    if data.is_apply then
        self.Parameter.IsApplied.UObj:SetActiveEx(true)
    else
        self.Parameter.IsApplied.UObj:SetActiveEx(false)
    end
    self.Parameter.ItemButton:AddClick(function()
        self:MethodCallback(self)
    end)

end --func end
--next--
function GuildItemTemplate:BindEvents()

end --func end
--next--
function GuildItemTemplate:OnDestroy()

end --func end
--next--
--lua functions end

--lua custom scripts
--设置被选中框是否显示
function GuildItemTemplate:SetSelect(isSelected)
    self.Parameter.IsSelected.UObj:SetActiveEx(isSelected)
end
--lua custom scripts end
return GuildItemTemplate