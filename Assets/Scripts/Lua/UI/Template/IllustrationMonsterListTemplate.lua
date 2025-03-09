--this file is gen by script
--you can edit this file in custom part

--lua requires
require "UI/BaseUITemplate"
require "UI/Template/IllustrationMonsterCellTemplate"
--lua requires end

--lua model
module("UITemplate", package.seeall)

--lua model end

--lua fields
local super = UITemplate.BaseUITemplate
--lua fields end

--lua class define
---@class IllustrationMonsterListTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field MonsterFivePrefab MoonClient.MLuaUICom

---@class IllustrationMonsterListTemplate : BaseUITemplate
---@field Parameter IllustrationMonsterListTemplateParameter

IllustrationMonsterListTemplate = class("IllustrationMonsterListTemplate", super)
--lua class define end

--lua functions
function IllustrationMonsterListTemplate:Init()
    super.Init(self)
    self.monsterCellTemplatePool = self:NewTemplatePool({
        UITemplateClass = UITemplate.IllustrationMonsterCellTemplate,
        TemplatePath = "UI/Prefabs/MonsterPrefab",
        TemplateParent = self.Parameter.MonsterFivePrefab.transform,
        SetCountPerFrame = 1,
        CreateObjPerFrame = 1,
    })
end --func end
--next--

function IllustrationMonsterListTemplate:OnDestroy()
    self.monsterCellTemplatePool = nil
end --func end
--next--
function IllustrationMonsterListTemplate:OnSetData(data)
    self:ShowMonsterList(data)
end --func end
--next--
function IllustrationMonsterListTemplate:BindEvents()
    -- do nothing
end --func end
--next--
function IllustrationMonsterListTemplate:OnDeActive()
    -- do nothing
end --func end
--next--
--lua functions end

--lua custom scripts
--- templatePool当中驱动产生的Update
function IllustrationMonsterListTemplate:_onTemplatePoolUpdate()
    self.monsterCellTemplatePool:OnUpdate()
end

function IllustrationMonsterListTemplate:ShowMonsterList(listData)
    self.monsterCellTemplatePool:ShowTemplates({
        Datas = listData,
    })
end

function IllustrationMonsterListTemplate:GetTemplatePool()
    return self.monsterCellTemplatePool
end
--lua custom scripts end
return IllustrationMonsterListTemplate