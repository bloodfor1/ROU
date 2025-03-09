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
---@class IllustrationMonster_StorageCabinet_DollTemParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field Text_Name MoonClient.MLuaUICom
---@field Text_Have MoonClient.MLuaUICom
---@field Image_MonsterIcon MoonClient.MLuaUICom

---@class IllustrationMonster_StorageCabinet_DollTem : BaseUITemplate
---@field Parameter IllustrationMonster_StorageCabinet_DollTemParameter

IllustrationMonster_StorageCabinet_DollTem = class("IllustrationMonster_StorageCabinet_DollTem", super)
--lua class define end

--lua functions
function IllustrationMonster_StorageCabinet_DollTem:Init()
    super.Init(self)
end --func end
--next--
function IllustrationMonster_StorageCabinet_DollTem:BindEvents()
    -- do nothing
end --func end
--next--
function IllustrationMonster_StorageCabinet_DollTem:OnDestroy()
    -- do nothing
end --func end
--next--
function IllustrationMonster_StorageCabinet_DollTem:OnDeActive()
    -- do nothing
end --func end
--next--
function IllustrationMonster_StorageCabinet_DollTem:OnSetData(data)
    self.Parameter.Text_Name.LabText = data.ItemName
    self.Parameter.Image_MonsterIcon:SetSprite(data.ItemAtlas, data.ItemIcon, true)
    local currentCount = MgrMgr:GetMgr("ItemContainerMgr").GetItemCountByContAndID(GameEnum.EBagContainerType.VirtualItem, data.ItemID)
    self.Parameter.Text_Have.LabText = StringEx.Format(Common.Utils.Lang("ILLUSTRATION_STORAGE_CABINET_TEXT"), tostring(currentCount))
    self.Parameter.Image_MonsterIcon:AddClick(function()
        MgrMgr:GetMgr("ItemTipsMgr").ShowTipsDisplayWithId(data.ItemID)
    end)
end --func end
--next--
--lua functions end

--lua custom scripts

--lua custom scripts end
return IllustrationMonster_StorageCabinet_DollTem