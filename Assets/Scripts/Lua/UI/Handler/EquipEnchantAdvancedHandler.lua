--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/Panel/EquipEnchantAdvancedPanel"
require "UI/Handler/BaseEquipEnchant"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua fields
local super = UI.BaseEquipEnchant
--next--
--lua fields end

--lua class define
EquipEnchantAdvancedHandler = class("EquipEnchantAdvancedHandler", super)
--lua class define end

--lua functions
function EquipEnchantAdvancedHandler:ctor()

    super.ctor(self, HandlerNames.EquipEnchantAdvanced, 0)

end --func end
--next--
function EquipEnchantAdvancedHandler:Init()

    self.panel = UI.EquipEnchantAdvancedPanel.Bind(self)
    super.Init(self)

end --func end
--next--
function EquipEnchantAdvancedHandler:Uninit()

    super.Uninit(self)

end --func end
--next--
function EquipEnchantAdvancedHandler:OnActive()
    super.OnActive(self)

end --func end
--next--
function EquipEnchantAdvancedHandler:OnDeActive()


end --func end
--next--
function EquipEnchantAdvancedHandler:Update()


end --func end


--next--
function EquipEnchantAdvancedHandler:BindEvents()
    super.BindEvents(self)

end --func end
--next--
--lua functions end

--lua custom scripts
---@param itemData ItemData
function EquipEnchantAdvancedHandler:_getCacheEntrys(itemData)
    local ret = itemData.AttrSet[GameEnum.EItemAttrModuleType.EnchantCacheHigh][1]
    return ret
end

function EquipEnchantAdvancedHandler:_requestEquipEnchant(uid)
    MgrMgr:GetMgr("EnchantMgr").RequestEquipEnchantAdvanced(uid)
end

function EquipEnchantAdvancedHandler:_requestConfirmEquipEnchant(uid)
    MgrMgr:GetMgr("EnchantMgr").RequestConfirmEquipEnchantAdvanced(uid)
end

function EquipEnchantAdvancedHandler:_showEnchantPreview(propId)
    UIMgr:ActiveUI(UI.CtrlNames.EquipEnchantPreview, function(ctrl)
        ctrl:ShowAdvancedEnchantPreview(propId)
    end)
end

function EquipEnchantAdvancedHandler:_getEquipEnchantConsume(tableInfo)
    return tableInfo.SeniorEnchantConsume
end
--lua custom scripts end
