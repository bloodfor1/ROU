--this file is gen by script
--you can edit this file in custom part

--lua requires
require "UI/Panel/EquipEnchantPanel"
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
EquipEnchantHandler = class("EquipEnchantHandler", super)
--lua class define end

--lua functions
function EquipEnchantHandler:ctor()
    super.ctor(self, HandlerNames.EquipEnchant, 0)
end --func end
--next--
function EquipEnchantHandler:Init()
    self.panel = UI.EquipEnchantPanel.Bind(self)
    super.Init(self)
end --func end
--next--
function EquipEnchantHandler:Uninit()

    super.Uninit(self)

end --func end
--next--
function EquipEnchantHandler:OnActive()

    super.OnActive(self)

end --func end
--next--
function EquipEnchantHandler:OnDeActive()


end --func end
--next--
function EquipEnchantHandler:Update()


end --func end


--next--
function EquipEnchantHandler:BindEvents()
    super.BindEvents(self)

end --func end
--next--
--lua functions end

--lua custom scripts
---@param itemData ItemData
function EquipEnchantHandler:_getCacheEntrys(itemData)
    local ret = itemData.AttrSet[GameEnum.EItemAttrModuleType.EnchantCache][1]
    return ret
end

function EquipEnchantHandler:_requestEquipEnchant(uid)
    MgrMgr:GetMgr("EnchantMgr").RequestEquipEnchantCommon(uid)
end

function EquipEnchantHandler:_requestConfirmEquipEnchant(uid)
    MgrMgr:GetMgr("EnchantMgr").RequestConfirmEquipEnchantCommon(uid)
end

function EquipEnchantHandler:_showEnchantPreview(propId)
    UIMgr:ActiveUI(UI.CtrlNames.EquipEnchantPreview, function(ctrl)
        ctrl:ShowCommonEnchantPreview(propId)
    end)
end

function EquipEnchantHandler:_getEquipEnchantConsume(tableInfo)
    return tableInfo.EnchantConsume
end
--lua custom scripts end
