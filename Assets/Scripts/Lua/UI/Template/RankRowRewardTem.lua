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
---@class RankRowRewardTemParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field Text_BlockTitle MoonClient.MLuaUICom
---@field ItemParent MoonClient.MLuaUICom

---@class RankRowRewardTem : BaseUITemplate
---@field Parameter RankRowRewardTemParameter

RankRowRewardTem = class("RankRowRewardTem", super)
--lua class define end

--lua functions
function RankRowRewardTem:Init()

    super.Init(self)
    self.itemPool = nil
end --func end
--next--
function RankRowRewardTem:BindEvents()


end --func end
--next--
function RankRowRewardTem:OnDestroy()
    self.itemPool = nil

end --func end
--next--
function RankRowRewardTem:OnDeActive()


end --func end
--next--
function RankRowRewardTem:OnSetData(data)

    local str = Lang("RANK_NUM_2", data.left)
    if tonumber(data.left) ~= tonumber(data.right) then
        str = str .. "~" .. Lang("RANK_NUM_2", data.right)
    end
    self.Parameter.Text_BlockTitle.LabText = str
    local datas = {}
    for k, v in ipairs(data.items) do
        datas[#datas + 1] = {
            ID = tonumber(v[1]),
            Count = tonumber(v[2]),
        }
    end
    if self.itemPool == nil then
        self.itemPool = self:NewTemplatePool({
            TemplateClassName = "ItemTemplate",
            TemplatePath = "UI/Prefabs/ItemPrefab",
            TemplateParent = self.Parameter.ItemParent.transform
        })
    end
    self.itemPool:ShowTemplates({ Datas = datas })
end --func end
--next--
--lua functions end

--lua custom scripts

--lua custom scripts end
return RankRowRewardTem