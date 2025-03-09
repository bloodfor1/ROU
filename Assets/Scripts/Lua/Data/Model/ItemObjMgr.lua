--- 这个文件做的事情是将所有的道具数据对象放到一个池当中进行管理
--- 这个地方只做道数据数据的映射表，这个类当中没有容器的概念

module("Data", package.seeall)
ItemObjMgr = class("ItemObjMgr")

local luaBaseType = GameEnum.ELuaBaseType

function ItemObjMgr:ctor()
    ---@type table<number, ItemData>
    self._itemMap = {}
end

---@return table<number, ItemData>
function ItemObjMgr:GetAllItems()
    return self._itemMap
end

---@param uid userdata
---@return ItemData
function ItemObjMgr:GetItemData(uid)
    if nil == uid then
        return nil
    end

    return self._itemMap[uid]
end

---@param itemData ItemData
function ItemObjMgr:UpdateItem(itemData)
    if luaBaseType.Table ~= type(itemData) then
        logError("[ItemObjMgr] invalid item data, update failed")
        return
    end

    self._itemMap[itemData.UID] = itemData
end

---@param uid number
function ItemObjMgr:Remove(uid)
    if nil == uid then
        logError("[ItemObjMgr] invalid uid, remove failed")
        return
    end

    self._itemMap[uid] = nil
end

--- 清空所有的数据
function ItemObjMgr:Clear()
    self._itemMap = {}
end

return ItemObjMgr