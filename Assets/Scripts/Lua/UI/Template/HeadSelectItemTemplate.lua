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
---@class HeadSelectItemTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field TimeLimit MoonClient.MLuaUICom
---@field ImgMask MoonClient.MLuaUICom
---@field IconTrial MoonClient.MLuaUICom
---@field IconSelected MoonClient.MLuaUICom
---@field IconContent MoonClient.MLuaUICom

---@class HeadSelectItemTemplate : BaseUITemplate
---@field Parameter HeadSelectItemTemplateParameter

HeadSelectItemTemplate = class("HeadSelectItemTemplate", super)
--lua class define end

--lua functions
function HeadSelectItemTemplate:Init()
    super.Init(self)
    self.Mgr = MgrMgr:GetMgr("HeadSelectMgr")
end --func end

--next--
function HeadSelectItemTemplate:BindEvents()
    if self.Mgr == nil then
        self.Mgr = MgrMgr:GetMgr("HeadSelectMgr")
    end

    self:BindEvent(self.Mgr.EventDispatcher, self.Mgr.UPDATE_HEAD_SELF, function(self, uid)
        if self.data then
            self:SetCurrentState()
        end
    end)
end --func end

--next--
function HeadSelectItemTemplate:OnDestroy()
    self.head2d = nil
end --func end
--next--
function HeadSelectItemTemplate:OnDeActive()
    -- do nothing
end --func end
--next--
function HeadSelectItemTemplate:OnSetData(data)
    self.data = data
    if not self.head2d then
        self.head2d = self:NewTemplate("HeadWrapTemplate", {
            TemplateParent = self.Parameter.IconContent.transform,
            TemplatePath = "UI/Prefabs/HeadWrapTemplate"
        })
    end

    self._onSelectedCb = data.OnSelected
    self._onSelectedCbSelf = data.OnSelectedSelf
    if data.tableInfo == "default" then
        self.id = 0
        self.target = nil
    else
        self.id = data.tableInfo.ProfilePhotoID
        self.target = data.target
    end

    self.enough = data.have > 0
    self:SetCurrentState()
    self:SetSelectedState()
    self:SetMaskState()
    self:SetContent()
    self.Parameter.TimeLimit.gameObject:SetActiveEx(false)
    self.Parameter.IconTrial.gameObject:SetActiveEx(false)
end --func end

--next--
--lua functions end

--lua custom scripts
function HeadSelectItemTemplate:SetCurrentState()
    self.Parameter.IconSelected.gameObject:SetActiveEx(MPlayerInfo.HeadID == self.id)
end

function HeadSelectItemTemplate:SetSelectedState()
    local l_state = self.Mgr.CurSelectedHead.id == self.id
    if l_state then
        self.Mgr.CurSelectedHead.selected = self
    end
end

function HeadSelectItemTemplate:SetMaskState()
    local l_state = nil == self.target and self.id ~= 0
    self.Parameter.ImgMask.gameObject:SetActiveEx(l_state)
    self.Parameter.ImgMask:AddClick(function()
        self:Click()
    end)
end

function HeadSelectItemTemplate:SetContent()
    local equipData = nil
    if self.id == 0 then
        equipData = self.Mgr.GetDefaultEquipData()
    else
        equipData = self.Mgr.GetDefaultEquipData(self.id)
    end

    ---@type HeadTemplateParam
    local param = {
        OnClick = self.Click,
        OnClickSelf = self,
        ShowFrame = false,
        ShowBg = false,
        EquipData = equipData
    }

    self.head2d:SetData(param)
end

function HeadSelectItemTemplate:Click()
    self.Mgr.CurSelectedHead.id = self.id
    self.Mgr.CurSelectedHead.uid = (self.id == 0 or self.target == nil) and 0 or self.target.UID
    self:SetSelectedState()
    self.Mgr.EventDispatcher:Dispatch(self.Mgr.ON_SELECT_HEAD_ITEM, self.enough)
    self._onSelectedCb(self._onSelectedCbSelf, self.id)
end

function HeadSelectItemTemplate:OnSelect()
    self.Parameter.IconTrial.gameObject:SetActiveEx(true)
end

function HeadSelectItemTemplate:OnDeselect()
    self.Parameter.IconTrial.gameObject:SetActiveEx(false)
end

return HeadSelectItemTemplate