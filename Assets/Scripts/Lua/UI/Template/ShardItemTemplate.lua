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
---@class ShardItemTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field txt_limit MoonClient.MLuaUICom
---@field txt_equip_shard_name MoonClient.MLuaUICom
---@field itemDummy MoonClient.MLuaUICom
---@field img_selected MoonClient.MLuaUICom
---@field btn_selected MoonClient.MLuaUICom
---@field btn_exchange MoonClient.MLuaUICom
---@field btn_bg MoonClient.MLuaUICom
---@field bg_mask MoonClient.MLuaUICom

---@class ShardItemTemplate : BaseUITemplate
---@field Parameter ShardItemTemplateParameter

ShardItemTemplate = class("ShardItemTemplate", super)
--lua class define end

--lua functions
function ShardItemTemplate:Init()
    super.Init(self)
    self._data = nil
    self._onSelected = nil
    self._onSelectedSelf = nil
    self:_initConfig()
    self:_initWidget()
end --func end
--next--
function ShardItemTemplate:BindEvents()
    -- do nothing
end --func end
--next--
function ShardItemTemplate:OnDestroy()
    -- do nothing
end --func end
--next--
function ShardItemTemplate:OnDeActive()
    -- do nothing
end --func end
--next--
function ShardItemTemplate:OnSetData(data)
    self:_setData(data)
end --func end
--next--
--lua functions end

--lua custom scripts
function ShardItemTemplate:OnSelect()
    self.Parameter.img_selected:SetActiveEx(true)
end

function ShardItemTemplate:OnDeselect()
    self.Parameter.img_selected:SetActiveEx(false)
end

function ShardItemTemplate:_initConfig()
    self._selectedItemConfig = {
        name = "ItemTemplate",
        config = {
            TemplatePath = "UI/Prefabs/ItemPrefab",
            TemplateParent = self.Parameter.itemDummy.transform,
        },
    }
end

function ShardItemTemplate:_initWidget()
    self._itemTemplate = self:NewTemplate(self._selectedItemConfig.name, self._selectedItemConfig.config)
end

---@param data EquipShardDataWrap
function ShardItemTemplate:_setData(data)
    if nil == data then
        logError("[EquipShardTemplate] invalid data")
        return
    end

    self._data = data.EquipShardData
    self._onSelected = data.OnSelected
    self._onSelectedSelf = data.OnSelectedSelf
    self.Parameter.btn_selected:AddClickWithLuaSelf(self._tryInvokeClick, self)
    self.Parameter.txt_equip_shard_name.LabText = data.EquipShardData.MainData:GetName()
    ---@type ItemTemplateParam
    local param = {
        PropInfo = self._data.MainData,
        IsShowCount = false
    }

    self._itemTemplate:SetData(param)
    self.Parameter.img_selected:SetActiveEx(false)
end

--- 触发选中回调
function ShardItemTemplate:_tryInvokeClick()
    if nil == self._onSelected then
        return
    end

    if nil == self._onSelectedSelf then
        self._onSelected(self._data, self.ShowIndex)
    end

    self._onSelected(self._onSelectedSelf, self._data, self.ShowIndex)
end

--lua custom scripts end
return ShardItemTemplate