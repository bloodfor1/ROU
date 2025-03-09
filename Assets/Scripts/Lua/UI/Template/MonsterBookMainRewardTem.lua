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
---@class MonsterBookMainRewardTemParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field Txt_Level MoonClient.MLuaUICom
---@field LoopScroll MoonClient.MLuaUICom
---@field Effective MoonClient.MLuaUICom

---@class MonsterBookMainRewardTem : BaseUITemplate
---@field Parameter MonsterBookMainRewardTemParameter

MonsterBookMainRewardTem = class("MonsterBookMainRewardTem", super)
--lua class define end

--lua functions
function MonsterBookMainRewardTem:Init()

    super.Init(self)
    self.RowTm = nil

end --func end
--next--
function MonsterBookMainRewardTem:BindEvents()


end --func end
--next--
function MonsterBookMainRewardTem:OnDestroy()
    self.RowTm = nil

end --func end
--next--
function MonsterBookMainRewardTem:OnDeActive()


end --func end
--next--

function MonsterBookMainRewardTem:OnSetData(data)
    self.Parameter.Txt_Level.LabText = Lang("REACH_LEVEL", data.Lv)
    self.Parameter.Effective:SetActiveEx(data.Acquired)
    local l_data = {}
    for k, v in ipairs(data.Attrs) do
        local attr = Data.ItemAttrData.new(GameEnum.EItemAttrType.Attr, v[2], v[3])
        local attrstr = MgrMgr:GetMgr("AttrDescUtil").GetAttrStr(attr)
        table.insert(l_data, { Name = attrstr.Desc })
    end
    if data.HaveUnlock then
        table.insert(l_data, { Name = Common.Utils.Lang("UNLOCK_SHOP_CAN_BUY_ITEM"), Value = nil })
    end
    if self.RowTem == nil then
        self.RowTem = self:NewTemplatePool({
            TemplateClassName = "MonsterBookAttrRewardLineTem",
            TemplatePath = "UI/Prefabs/MonsterBookAttrRewardLineTem",
            ScrollRect = self.Parameter.LoopScroll.LoopScroll,
        })
    end
    self.RowTem:ShowTemplates({ Datas = l_data })

end --func end
--next--
--lua functions end

--lua custom scripts

--lua custom scripts end
return MonsterBookMainRewardTem