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
---@class MonsterBookAttrRewardLineTemParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field AttrValue MoonClient.MLuaUICom
---@field AttrName MoonClient.MLuaUICom

---@class MonsterBookAttrRewardLineTem : BaseUITemplate
---@field Parameter MonsterBookAttrRewardLineTemParameter

MonsterBookAttrRewardLineTem = class("MonsterBookAttrRewardLineTem", super)
--lua class define end

--lua functions
function MonsterBookAttrRewardLineTem:Init()

    super.Init(self)

end --func end
--next--
function MonsterBookAttrRewardLineTem:BindEvents()


end --func end
--next--
function MonsterBookAttrRewardLineTem:OnDestroy()


end --func end
--next--
function MonsterBookAttrRewardLineTem:OnDeActive()


end --func end
--next--
function MonsterBookAttrRewardLineTem:OnSetData(data)

    if data.Value then
        self.Parameter.AttrValue:SetActiveEx(true)
        self.Parameter.AttrValue.LabText = "+" .. data.Value
    else
        self.Parameter.AttrValue:SetActiveEx(false)
    end
    if data.Color ~= nil then
        self.Parameter.AttrName.LabColor = data.Color
        self.Parameter.AttrValue.LabColor = data.Color
    else
        self.Parameter.AttrName.LabColor = CommonUI.Color.UIDefineColor.DeclarativeColor
        self.Parameter.AttrValue.LabColor = CommonUI.Color.UIDefineColor.DeclarativeColor
    end
    self.Parameter.AttrName.LabText = data.Name

end --func end
--next--
--lua functions end

--lua custom scripts

--lua custom scripts end
return MonsterBookAttrRewardLineTem