--- 这个文件目前是手写的，后面会变成代码生成文件
module("ModuleMgr", package.seeall)
---@class ModuleMgr.MgrProxy
MgrProxy = class("MgrProxy")

function MgrProxy:ctor()
    -- do nothing
end

---@return ModuleMgr.GarderobeMgr
function MgrProxy:GetGarderobeMgr()
    return MgrMgr:GetMgr("GarderobeMgr")
end
---@return ModuleMgr.ShareMgr
function MgrProxy:GetShareMgr()
    return MgrMgr:GetMgr("ShareMgr")
end

---@return ModuleMgr.CommonBroadcastMgr
function MgrProxy:GetCommonBroadcastMgr()
    return MgrMgr:GetMgr("CommonBroadcastMgr")
end

---@return ModuleMgr.GameEventMgr
function MgrProxy:GetGameEventMgr()
    return MgrMgr:GetMgr("GameEventMgr")
end

---@return ModuleMgr.BagMgr
function MgrProxy:GetBagMgr()
    ---@type ModuleMgr.BagMgr
    return MgrMgr:GetMgr("BagMgr")
end

---@return ModuleMgr.ShortCutItemMgr
function MgrProxy:GetShortCutItemMgr()
    return MgrMgr:GetMgr("ShortCutItemMgr")
end

---@return ModuleMgr.MultiTalentEquipMgr
function MgrProxy:GetMultiTalentEquipMgr()
    return MgrMgr:GetMgr("MultiTalentEquipMgr")
end

---@return ModuleMgr.WardrobeGmMgr
function MgrProxy:GetWardrobeGmMgr()
    return MgrMgr:GetMgr("WardrobeGmMgr")
end

---@return ModuleMgr.ItemDataFuncUtil
function MgrProxy:GetItemDataFuncUtil()
    return MgrMgr:GetMgr("ItemDataFuncUtil")
end

---@return ModuleMgr.QuickUseMgr
function MgrProxy:GetQuickUseMgr()
    return MgrMgr:GetMgr("QuickUseMgr")
end

---@return ModuleMgr.MultiTalentMgr
function MgrProxy:GetMultiTalentMgr()
    return MgrMgr:GetMgr("MultiTalentMgr")
end

---@return ModuleMgr.ItemFilter
function MgrProxy:GetItemFilter()
    return MgrMgr:GetMgr("ItemFilter")
end

return ModuleMgr.MgrProxy