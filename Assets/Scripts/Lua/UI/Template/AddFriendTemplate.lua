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
---@class AddFriendTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field PlayerIconRoot MoonClient.MLuaUICom
---@field Number MoonClient.MLuaUICom
---@field NamePanel MoonClient.MLuaUICom
---@field Name MoonClient.MLuaUICom
---@field Item MoonClient.MLuaUICom
---@field Image MoonClient.MLuaUICom
---@field BtnAdd MoonClient.MLuaUICom
---@field AchieveTpl MoonClient.MLuaUICom

---@class AddFriendTemplate : BaseUITemplate
---@field Parameter AddFriendTemplateParameter

AddFriendTemplate = class("AddFriendTemplate", super)
--lua class define end

--lua functions
function AddFriendTemplate:Init()
    super.Init(self)
    self.head2d = self:NewTemplate("HeadWrapTemplate", {
        TemplateParent = self.Parameter.PlayerIconRoot.transform,
        TemplatePath = "UI/Prefabs/HeadWrapTemplate"
    })
end --func end
--next--
function AddFriendTemplate:OnDeActive()
    -- do nothing
end --func end
--next--
function AddFriendTemplate:OnSetData(data)
    self:CustomSetData(data)
end --func end
--next--
function AddFriendTemplate:BindEvents()
    -- do nothing
end --func end
--next--
function AddFriendTemplate:OnDestroy()
    self.head2d = nil
end --func end
--next--
--lua functions end

--lua custom scripts
function AddFriendTemplate:CustomSetData(data)
    self.Parameter.Name.LabText = data.name
    self.Parameter.Number.LabText = tostring(data.role_uid)
    LayoutRebuilder.ForceRebuildLayoutImmediate(self.Parameter.NamePanel.transform)
    local l_sex = data.sex
    if (not l_sex) or (l_sex == 0) then
        self.Parameter.Image:SetSprite("Common", "UI_Common_TypeMale.png")
    else
        self.Parameter.Image:SetSprite("Common", "UI_Common_TypeFemale.png")
    end

    ---@type HeadTemplateParam
    local param = {
        EquipData = MgrMgr:GetMgr("PlayerInfoMgr").GetEquipData(data),
        ShowProfession = true,
        Profession = data.type,
        ShowLv = true,
        Level = data.base_level,
        OnClick = function()
            Common.CommonUIFunc.RefreshPlayerMenuLByUid(data.role_uid)
        end,
    }

    self.head2d:SetData(param)
    self.Parameter.BtnAdd:AddClick(function()
        if self.MethodCallback then
            self.MethodCallback(data.role_uid)
        end
    end)
end
--lua custom scripts end
return AddFriendTemplate