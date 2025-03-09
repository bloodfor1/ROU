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
---@class MercenaryUpgradeItemTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field Item MoonClient.MLuaUICom
---@field ExpText MoonClient.MLuaUICom

---@class MercenaryUpgradeItemTemplate : BaseUITemplate
---@field Parameter MercenaryUpgradeItemTemplateParameter

MercenaryUpgradeItemTemplate = class("MercenaryUpgradeItemTemplate", super)
--lua class define end

--lua functions
function MercenaryUpgradeItemTemplate:Init()

    super.Init(self)

    self.mercenaryMgr = MgrMgr:GetMgr("MercenaryMgr")

end --func end
--next--
function MercenaryUpgradeItemTemplate:OnDestroy()

end --func end
--next--
function MercenaryUpgradeItemTemplate:OnDeActive()


end --func end
--next--
function MercenaryUpgradeItemTemplate:OnSetData(data)
    if not self.itemTemplate then
        self.itemTemplate = self:NewTemplate("ItemTemplate", {
            TemplateParent = self.Parameter.Item.transform,
        })
    end
    self.itemId = data.itemId
    self.mercenaryId = data.mercenaryId
    local l_itemCount = Data.BagModel:GetBagItemCountByTid(self.itemId)
    local l_clickFunc = function()
        if 0 >= l_itemCount then
            return
        end

        self.mercenaryMgr.RequestUpgrade(self.mercenaryId, self.itemId, 1)
    end

    local l_func = function()
        if l_itemCount > 0 then
            return
        end

        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("ITEM_NOT_ENOUGH"))
        local itemData = Data.BagModel:CreateItemWithTid(self.itemId)
        MgrMgr:GetMgr("ItemTipsMgr").ShowTipsDisplay(itemData, nil, nil, nil, true)
    end

    local l_param = { ID = self.itemId,
                      Count = l_itemCount,
                      IsShowTips = false,
                      ContinuousButtonDownMethod = l_func,
                      ButtonMethod = l_clickFunc,
                      ContinuousButtonMethod = l_clickFunc }

    self.itemTemplate:SetData(l_param)
    self.Parameter.ExpText.LabText = "+" .. data.expAdd
end --func end

--next--
--lua functions end

--lua custom scripts

--lua custom scripts end
return MercenaryUpgradeItemTemplate