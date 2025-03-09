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
---@class NearPeopleTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field Txt_PlayerName MoonClient.MLuaUICom
---@field Img_Head MoonClient.MLuaUICom
---@field Img_CheckMark MoonClient.MLuaUICom
---@field Btn_Bg MoonClient.MLuaUICom

---@class NearPeopleTemplate : BaseUITemplate
---@field Parameter NearPeopleTemplateParameter

NearPeopleTemplate = class("NearPeopleTemplate", super)
--lua class define end

--lua functions
function NearPeopleTemplate:Init()
    super.Init(self)
end --func end
--next--
function NearPeopleTemplate:BindEvents()
    -- do nothing
end --func end
--next--
function NearPeopleTemplate:OnDestroy()
    ---@type MoonClient.MHeadBehaviour
    self.head2D = nil
end --func end
--next--
function NearPeopleTemplate:OnDeActive()
    -- do nothing
end --func end
--next--
function NearPeopleTemplate:OnSetData(data)
    if data == nil then
        return
    end

    ---@type MoonClient.MEntity
    local l_data = data.entity
    ---@type MoonClient.MEntity
    self.data = l_data
    if self.head2D == nil then
        self.head2D = self:NewTemplate("HeadWrapTemplate", {
            TemplateParent = self.Parameter.Img_Head.transform,
            TemplatePath = "UI/Prefabs/HeadWrapTemplate"
        })
    end

    ---@type HeadTemplateParam
    local param = {
        Entity = self.data,
        OnClick = self._onIconClick,
        OnClickSelf = self,
        ShowProfession = true,
        Profession = l_data.AttrComp and l_data.AttrComp.EquipData.ProfessionID or 0,
        ShowLv = l_data.AttrComp ~= nil,
        Level = l_data.AttrComp and l_data.AttrComp.Level or 0
    }

    self.head2D:SetData(param)
    self.Parameter.Txt_PlayerName.LabText = l_data.Name
    self.Parameter.Btn_Bg:AddClick(function()
        if data.onSelectMethod ~= nil then
            data.onSelectMethod(self.ShowIndex)
        end
    end, true)
end --func end
--next--
--lua functions end

--lua custom scripts
function NearPeopleTemplate:_onIconClick()
    local l_playerMenuOffsetPos = Vector2.New(400, -60)
    local l_playerMenuPos = l_playerMenuOffsetPos + self.Parameter.Img_Head.RectTransform.anchoredPosition3D
    local l_menuWorldPos = self.Parameter.Img_Head.RectTransform:TransformPoint(l_playerMenuPos)
    local l_menuScreenPos = MUIManager.UICamera:WorldToScreenPoint(l_menuWorldPos)
    MgrMgr:GetMgr("TeamMgr").OnSelectPlayer(self.data.UID, nil, l_menuScreenPos)
end

function NearPeopleTemplate:OnSelect()
    self.Parameter.Img_CheckMark:SetActiveEx(true)
end

function NearPeopleTemplate:OnDeselect()
    self.Parameter.Img_CheckMark:SetActiveEx(false)
end
--lua custom scripts end
return NearPeopleTemplate