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
---@class IllustrationMonster_StorageCabinet_ElementTemParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field Text_Name MoonClient.MLuaUICom
---@field Text_Have MoonClient.MLuaUICom
---@field Image_ElementIcon MoonClient.MLuaUICom

---@class IllustrationMonster_StorageCabinet_ElementTem : BaseUITemplate
---@field Parameter IllustrationMonster_StorageCabinet_ElementTemParameter

IllustrationMonster_StorageCabinet_ElementTem = class("IllustrationMonster_StorageCabinet_ElementTem", super)
--lua class define end

--lua functions
function IllustrationMonster_StorageCabinet_ElementTem:Init()

    super.Init(self)

end --func end
--next--
function IllustrationMonster_StorageCabinet_ElementTem:BindEvents()


end --func end
--next--
function IllustrationMonster_StorageCabinet_ElementTem:OnDestroy()


end --func end
--next--
function IllustrationMonster_StorageCabinet_ElementTem:OnDeActive()


end --func end
--next--
function IllustrationMonster_StorageCabinet_ElementTem:OnSetData(data)
    self.Parameter.Text_Name.LabText = data.ItemName
    self.Parameter.Image_ElementIcon:SetSprite(data.ItemAtlas, data.ItemIcon)
    self.Parameter.Image_ElementIcon.Img:SetNativeSize()
    local currentCount = MgrMgr:GetMgr("ItemContainerMgr").GetItemCountByContAndID(GameEnum.EBagContainerType.VirtualItem, data.ItemID)
    self.Parameter.Text_Have.LabText = StringEx.Format(Common.Utils.Lang("ILLUSTRATION_STORAGE_CABINET_TEXT"), tostring(currentCount))
    self.Parameter.Image_ElementIcon:AddClick(function()
        MgrMgr:GetMgr("ItemTipsMgr").ShowTipsDisplayWithId(data.ItemID)
    end)

end --func end
--next--
--lua functions end

--lua custom scripts

--lua custom scripts end
return IllustrationMonster_StorageCabinet_ElementTem