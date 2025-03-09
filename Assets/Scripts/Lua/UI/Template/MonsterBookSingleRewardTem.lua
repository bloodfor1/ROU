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
---@class MonsterBookSingleRewardTemParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field reward MoonClient.MLuaUICom
---@field reach MoonClient.MLuaUICom

---@class MonsterBookSingleRewardTem : BaseUITemplate
---@field Parameter MonsterBookSingleRewardTemParameter

MonsterBookSingleRewardTem = class("MonsterBookSingleRewardTem", super)
--lua class define end

--lua functions
function MonsterBookSingleRewardTem:Init()

    super.Init(self)

end --func end
--next--
function MonsterBookSingleRewardTem:BindEvents()


end --func end
--next--
function MonsterBookSingleRewardTem:OnDestroy()


end --func end
--next--
function MonsterBookSingleRewardTem:OnDeActive()


end --func end
--next--
---@param data MonsterBookSingleRewardTemData
function MonsterBookSingleRewardTem:OnSetData(data)
    local strItemHref = "<a href=ItemTips><color=#FFE788>[{0}]</color></a>"
    local strCount = "*{0}"
    local str = data.str
    if data.ItemId then
        str = str .. StringEx.Format(strItemHref, TableUtil.GetItemTable().GetRowByItemID(data.ItemId).ItemName)
    end
    if data.Count then
        str = str .. StringEx.Format(strCount, data.Count)
    end
    self.Parameter.reward.LabText = Lang("LEVEL_DESCRIPTION", data.Lvl, str)
    self.Parameter.reach:SetActiveEx(DataMgr:GetData("IllustrationMonsterData").GetMonsterRewardLevelById(data.EntityId) >= data.Lvl)
    self.Parameter.reward:GetRichText().onHrefClick:RemoveAllListeners()
    local tipsTransform = self.Parameter.reward.Transform
    tipsTransform.anchoredPosition = Vector2.zero
    tipsTransform.anchorMax = Vector2(0.5, 0.5)
    tipsTransform.anchorMin = Vector2(0.5, 0.5)
    self.Parameter.reward:GetRichText().onHrefClick:AddListener(function(hrefName)
        MgrMgr:GetMgr("ItemTipsMgr").ShowTipsDisplayWithId(data.ItemId, tipsTransform)
    end)
end --func end
--next--
--lua functions end

--lua custom scripts

--lua custom scripts end
return MonsterBookSingleRewardTem