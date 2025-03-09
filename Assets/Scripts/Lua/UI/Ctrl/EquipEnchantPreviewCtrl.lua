--this file is gen by script
--you can edit this file in custom part

--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/EquipEnchantPreviewPanel"

--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua fields
local super = UI.UIBaseCtrl
--next--
--lua fields end

--lua class define
EquipEnchantPreviewCtrl = class("EquipEnchantPreviewCtrl", super)
--lua class define end

--lua functions
function EquipEnchantPreviewCtrl:ctor()
    super.ctor(self, CtrlNames.EquipEnchantPreview, UILayer.Function, nil, ActiveType.Standalone)
end --func end
--next--
function EquipEnchantPreviewCtrl:Init()
    self.panel = UI.EquipEnchantPreviewPanel.Bind(self)
    super.Init(self)
    self.panel.ClosePreviewButton:AddClick(function()
        UIMgr:DeActiveUI(UI.CtrlNames.EquipEnchantPreview)
    end)

    self._buffPropertyPreviewPool = self:NewTemplatePool({
        TemplateClassName = "EnchantBuffPropertyPreviewTemplate",
        TemplateParent = self.panel.PropertyPreviewParent1.transform,
        TemplatePrefab = self.panel.EnchantBuffPropertyPreviewPrefab.gameObject
    })

    self._playerPropertyPreviewPool = self:NewTemplatePool({
        TemplateClassName = "EnchantPlayerPropertyPreviewTemplate",
        TemplateParent = self.panel.PropertyPreviewParent2.transform,
        TemplatePrefab = self.panel.EnchantPlayerPropertyPreviewPrefab.gameObject
    })

    self._commonPropertyPreviewPool = self:NewTemplatePool({
        TemplateClassName = "EnchantCommonPropertyPreviewTemplate",
        TemplateParent = self.panel.PropertyPreviewParent3.transform,
        TemplatePrefab = self.panel.EnchantCommonPropertyPreviewPrefab.gameObject
    })
end --func end
--next--
function EquipEnchantPreviewCtrl:Uninit()
    super.Uninit(self)
    self.panel = nil

    self._buffPropertyPreviewPool = nil
    self._playerPropertyPreviewPool = nil
    self._commonPropertyPreviewPool = nil
end --func end
--next--
function EquipEnchantPreviewCtrl:OnActive()

end --func end
--next--
function EquipEnchantPreviewCtrl:OnDeActive()

end --func end
--next--
function EquipEnchantPreviewCtrl:Update()

end --func end
--next--
function EquipEnchantPreviewCtrl:BindEvents()

end --func end

--next--
--lua functions end

--lua custom scripts
function EquipEnchantPreviewCtrl:ShowCommonEnchantPreview(equipId)
    self:_showPreview(equipId, true)
end

function EquipEnchantPreviewCtrl:ShowAdvancedEnchantPreview(equipId)
    self:_showPreview(equipId, false)
end

function EquipEnchantPreviewCtrl:_showPreview(equipId, isCommonEnchant)
    local l_previewDatas1 = self:_getPreviewData(equipId, isCommonEnchant, 1)
    if l_previewDatas1 then
        self._buffPropertyPreviewPool:ShowTemplates({ Datas = l_previewDatas1 })
        self.panel.PropertyPreviewParent1:SetActiveEx(true)
    else
        self.panel.PropertyPreviewParent1:SetActiveEx(false)
    end


    local l_previewDatas2 = self:_getPreviewData(equipId, isCommonEnchant, 2)
    if l_previewDatas2 then
        self._playerPropertyPreviewPool:ShowTemplates({ Datas = l_previewDatas2 })
        self.panel.PropertyPreviewParent2:SetActiveEx(true)
    else
        self.panel.PropertyPreviewParent2:SetActiveEx(false)
    end


    local l_previewDatas3 = self:_getPreviewData(equipId, isCommonEnchant, 3)
    if l_previewDatas3 then
        self._commonPropertyPreviewPool:ShowTemplates({ Datas = l_previewDatas3 })
        self.panel.PropertyPreviewParent3:SetActiveEx(true)
    else
        self.panel.PropertyPreviewParent3:SetActiveEx(false)
    end

end

--- 初级附魔和高级附魔之间界限，不会等于这个值
local C_ENCHANT_OP_DIV_TAG = 100000

---@param config EquipEnchantTable
---@param isCommonEnchant boolean
---@param enchantID number
---@param idx number
---@return boolean
function EquipEnchantPreviewCtrl:_configValid(config, isCommonEnchant, enchantID, idx)
    if nil == config then
        return false
    end

    if isCommonEnchant and config.Id > C_ENCHANT_OP_DIV_TAG then
        -- do nothing
    elseif not isCommonEnchant and config.Id < C_ENCHANT_OP_DIV_TAG then
        -- do nothing
    else
        return false
    end
    local result = config.EnchantId == enchantID and config.TypeId == idx
    return result
end

---@return EnchantPreviewAttrConfig[]
function EquipEnchantPreviewCtrl:_getPreviewData(equipId, isCommonEnchant, index)
    local l_equipTableInfo = TableUtil.GetEquipTable().GetRowById(equipId)
    local l_enchantingId = l_equipTableInfo.EnchantingId
    local l_equipEnchantTable = TableUtil.GetEquipEnchantTable().GetTable()

    ---@type EquipEnchantTable[]
    local l_datas = {}
    for i = 1, #l_equipEnchantTable do
        local valid = self:_configValid(l_equipEnchantTable[i], isCommonEnchant, l_enchantingId, index)
        if valid then
            table.insert(l_datas, l_equipEnchantTable[i])
        end
    end

    if 0 == #l_datas then
        return nil
    end

    local l_keyValueDatas = {}
    local l_key
    for i = 1, #l_datas do
        if GameEnum.EEnchantAttrQuality.Gold == l_datas[i].Quality then
            l_key = math.floor(l_datas[i].Property[0][1] * 0.001)
        else
            l_key = l_datas[i].PropertyDec
        end

        if l_keyValueDatas[l_key] == nil then
            l_keyValueDatas[l_key] = {}
        end

        table.insert(l_keyValueDatas[l_key], l_datas[i])
    end

    ---@type EnchantPreviewAttrConfig[]
    local l_previewDatas = {}
    for i, equipEnchantTableInfos in pairs(l_keyValueDatas) do
        ---@type EnchantPreviewAttrConfig
        local l_data = {}
        l_data.IsCommonEnchant = isCommonEnchant
        l_data.EquipEnchantTableInfos = equipEnchantTableInfos
        table.insert(l_previewDatas, l_data)
    end

    table.sort(l_previewDatas, self._sortFunc)
    return l_previewDatas
end

---@param a EnchantPreviewAttrConfig
---@param b EnchantPreviewAttrConfig
function EquipEnchantPreviewCtrl._sortFunc(a, b)
    local l_enchantMgr = MgrMgr:GetMgr("EnchantMgr")
    local l_isConformProfessionA = l_enchantMgr.IsConformProfessionWithEnchantTableInfo(a.EquipEnchantTableInfos[1])
    local l_isConformProfessionB = l_enchantMgr.IsConformProfessionWithEnchantTableInfo(b.EquipEnchantTableInfos[1])
    if l_isConformProfessionA == l_isConformProfessionB then
        return a.EquipEnchantTableInfos[1].SortId < b.EquipEnchantTableInfos[1].SortId
    end

    return l_isConformProfessionA
end

return EquipEnchantPreviewCtrl
--lua custom scripts end
