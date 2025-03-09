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
---@class CommonItemTipsSealCardComponentParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field CommonItemTipsSealCardComponent MoonClient.MLuaUICom
---@field CardName MoonClient.MLuaUICom

---@class CommonItemTipsSealCardComponent : BaseUITemplate
---@field Parameter CommonItemTipsSealCardComponentParameter

CommonItemTipsSealCardComponent = class("CommonItemTipsSealCardComponent", super)
--lua class define end

--lua functions
function CommonItemTipsSealCardComponent:Init()
	
	super.Init(self)
    self.Parameter.CardName:AddClick(function()
        if self.unsealCardId then
            --UIMgr:DeActiveUI(UI.CtrlNames.CommonItemTips)
            local l_itemData = Data.BagModel:CreateItemWithTid(self.unsealCardId)
            MgrMgr:GetMgr("ItemTipsMgr").ShowTipsDisplay(l_itemData)
        end
    end)
	
end --func end
--next--
function CommonItemTipsSealCardComponent:BindEvents()
	
	
end --func end
--next--
function CommonItemTipsSealCardComponent:OnDestroy()
	
	
end --func end
--next--
function CommonItemTipsSealCardComponent:OnDeActive()
	
	
end --func end
--next--
function CommonItemTipsSealCardComponent:OnSetData(data)
	
	self.unsealCardId = data.unsealCardId
    local l_itemRow = TableUtil.GetItemTable().GetRowByItemID(self.unsealCardId)
    if l_itemRow then
        self.Parameter.CardName.LabText = l_itemRow.ItemName
    end
end --func end
--next--
--lua functions end

--lua custom scripts
CommonItemTipsSealCardComponent.TemplatePath="UI/Prefabs/CommonItemTips/CommonItemTipsSealCardComponent"
--lua custom scripts end
return CommonItemTipsSealCardComponent