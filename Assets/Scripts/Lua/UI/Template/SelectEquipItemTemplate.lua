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
---@class SelectEquipItemTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field Txt_EquipLv MoonClient.MLuaUICom
---@field Selected MoonClient.MLuaUICom
---@field Name MoonClient.MLuaUICom
---@field ItemPrompt MoonClient.MLuaUICom
---@field ItemButton MoonClient.MLuaUICom
---@field ImageEquipFlag MoonClient.MLuaUICom
---@field GenreText MoonClient.MLuaUICom
---@field EquipIconBg MoonClient.MLuaUICom

---@class SelectEquipItemTemplate : BaseUITemplate
---@field Parameter SelectEquipItemTemplateParameter

SelectEquipItemTemplate = class("SelectEquipItemTemplate", super)
--lua class define end

--lua functions
function SelectEquipItemTemplate:Init()
    super.Init(self)
    self._item = self:NewTemplate("ItemTemplate", { TemplateParent = self.Parameter.EquipIconBg.transform })
end --func end
--next--
function SelectEquipItemTemplate:OnDestroy()
    self._item = nil
end --func end
--next--
function SelectEquipItemTemplate:OnDeActive()
    -- do nothing
end --func end
--next--
function SelectEquipItemTemplate:OnSetData(data, mgrName)
    self:_showEquipItem(data, mgrName)
end --func end
--next--
function SelectEquipItemTemplate:BindEvents()
    -- do nothing
end --func end
--next--
--lua functions end

--lua custom scripts
---@param equipData ItemData
---@param mgrName string
function SelectEquipItemTemplate:_showEquipItem(equipData, mgrName)
    if nil == equipData then
        return
    end

    self.data = equipData
    local itemTableInfo = equipData.ItemConfig
    self._item:SetData({ PropInfo = equipData, IsShowCount = false })
    self.Parameter.ImageEquipFlag.gameObject:SetActiveEx(MgrMgr:GetMgr("EquipMgr").CheckEquipIsBody(equipData.UID))
    self.Parameter.GenreText:SetActiveEx(true)
    self.Parameter.GenreText.LabText = MgrMgr:GetMgr("EquipMgr").GetEquipTypeName(equipData.TID)
    local l_currentRefineLevel = equipData.RefineLv
    local l_text = itemTableInfo.ItemName
    self.Parameter.Name.LabText = l_text
    self.Parameter.Txt_EquipLv.LabText = StringEx.Format(Common.Utils.Lang("C_EQUIP_LV"), tostring(itemTableInfo.LevelLimit[0]))
    local l_showType = nil
    local l_selectDataMgr = MgrMgr:GetMgr(mgrName)
    if l_selectDataMgr.GetSelectEquipShowType ~= nil then
        l_showType = l_selectDataMgr.GetSelectEquipShowType()
    end

    if l_showType == MgrMgr:GetMgr("SelectEquipMgr").eSelectEquipShowType.Refine then
        if l_currentRefineLevel ~= 0 then
            local l_refineLevelText = "+" .. tostring(l_currentRefineLevel)
            self.Parameter.Name.LabText = l_refineLevelText .. l_text
        end
    end

    local l_isShowRedSign = false
    if l_selectDataMgr.IsSelectCanShowRedSign then
        l_isShowRedSign = l_selectDataMgr.IsSelectCanShowRedSign(equipData)
    end

    if l_isShowRedSign then
        self.Parameter.ItemPrompt:SetActiveEx(true)
    else
        self.Parameter.ItemPrompt:SetActiveEx(false)
    end

    self.Parameter.ItemButton:AddClick(function()
        UIMgr:DeActiveUI(UI.CtrlNames.CommonItemTips)
        self.MethodCallback(self.ShowIndex)
    end)
end

function SelectEquipItemTemplate:OnSelect()
    self.Parameter.Selected.gameObject:SetActiveEx(true)
end
function SelectEquipItemTemplate:OnDeselect()
    self.Parameter.Selected.gameObject:SetActiveEx(false)
end
--lua custom scripts end
return SelectEquipItemTemplate