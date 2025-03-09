--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/BaseUITemplate"
require "UI/Template/IllustrationEquipCellTemplate"
--lua requires end

--lua model
module("UITemplate", package.seeall)

--lua model end

--lua fields
local super = UITemplate.BaseUITemplate
--lua fields end

--lua class define
---@class IllustrationEquipListTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field EquipFivePrefab MoonClient.MLuaUICom

---@class IllustrationEquipListTemplate : BaseUITemplate
---@field Parameter IllustrationEquipListTemplateParameter

IllustrationEquipListTemplate = class("IllustrationEquipListTemplate", super)
--lua class define end

--lua functions
function IllustrationEquipListTemplate:Init()
    super.Init(self)
    self.equipCellTemplatePool = self:NewTemplatePool({
        UITemplateClass = UITemplate.IllustrationEquipCellTemplate,
        TemplatePath = "UI/Prefabs/EquipmentPrefab",
        TemplateParent = self.Parameter.EquipFivePrefab.transform,
        SetCountPerFrame = 1,
        CreateObjPerFrame = 1,
    })
end --func end
--next--
function IllustrationEquipListTemplate:OnDestroy()
    self.equipCellTemplatePool = nil
end --func end
--next--
function IllustrationEquipListTemplate:OnSetData(data)
    self:ShowEquipList(data)
end --func end
--next--
function IllustrationEquipListTemplate:BindEvents()
    -- do nothing
end --func end
--next--
function IllustrationEquipListTemplate:OnDeActive()
    -- do nothing
end --func end
--next--
--lua functions end

--lua custom scripts
--- templatePool当中驱动产生的Update
function IllustrationEquipListTemplate:_onTemplatePoolUpdate()
    self.equipCellTemplatePool:OnUpdate()
end

function IllustrationEquipListTemplate:ShowEquipList(listData)
    self.Parameter.EquipFivePrefab.gameObject:SetActiveEx(true)
    self.equipCellTemplatePool:ShowTemplates({
        Datas = listData,
    })
end

function IllustrationEquipListTemplate:GetTemplatePool()
    return self.equipCellTemplatePool
end
--lua custom scripts end
return IllustrationEquipListTemplate