--- 静态类，为了容易转换用的，不是作为对象创建的

module("Data", package.seeall)

--- 为什么要定义-1，因为PB生成工具当中枚举不能设置负数
local C_INVALID_SVR_TYPE = -1
local bagContainerType = GameEnum.EBagContainerType

--- 服务器和客户端枚举转换表
local C_SVR_TO_CLIENT_MAP = {
    [BagType.BAG] = bagContainerType.Bag,
    [BagType.BODY] = bagContainerType.Equip,
    [BagType.FASHION_BAG] = bagContainerType.Wardrobe,
    [BagType.WARDROBE] = bagContainerType.Wardrobe,
    [BagType.MERCHANT_BAG] = bagContainerType.Merchant,
    [BagType.CART] = bagContainerType.Cart,
    [BagType.SPITEM] = bagContainerType.HeadIcon,
    [BagType.VIRTUALITEM] = bagContainerType.VirtualItem,
    [BagType.TITLE] = bagContainerType.Title,
    [BagType.TITLE_USING] = bagContainerType.TitleUsing,
    [BagType.LIFE_EQUIP] = bagContainerType.LifeProfession,

    --- 快速使用会作为容器是因为服务器创建了假数据，以假数据作为映射来做这个东西
    --- 所以对客户端来说只要做了容器即可
    [BagType.SHORTCUTBAR] = bagContainerType.ShortCut,

    --- 仓库分页容器表
    [BagType.WAREHOUSE] = bagContainerType.WareHousePage_1,
    [BagType.Warehouse_2] = bagContainerType.WareHousePage_2,
    [BagType.Warehouse_3] = bagContainerType.WareHousePage_3,
    [BagType.Warehouse_4] = bagContainerType.WareHousePage_4,
    [BagType.Warehouse_5] = bagContainerType.WareHousePage_5,
    [BagType.Warehouse_6] = bagContainerType.WareHousePage_6,
    [BagType.Warehouse_7] = bagContainerType.WareHousePage_7,
    [BagType.Warehouse_8] = bagContainerType.WareHousePage_8,
    [BagType.Warehouse_9] = bagContainerType.WareHousePage_9,
    [BagType.BELLUZ] = bagContainerType.BeiluzCore,
    [BagType.PHOTO_FRAME] = bagContainerType.PlayerCustom,
}

--- 服务器对客户端枚举类型
local C_CLIENT_TO_SVR_MAP = {
    [bagContainerType.Bag] = BagType.BAG,
    [bagContainerType.Wardrobe] = BagType.WARDROBE,
    [bagContainerType.Equip] = BagType.BODY,
    [bagContainerType.Cart] = BagType.CART,
    [bagContainerType.Merchant] = BagType.MERCHANT_BAG,
    [bagContainerType.Title] = BagType.TITLE,
    [bagContainerType.TitleUsing] = BagType.TITLE_USING,
    [bagContainerType.ShortCut] = BagType.SHORTCUTBAR,
    [bagContainerType.HeadIcon] = BagType.SPITEM,

    --- 仓库分页容器
    [bagContainerType.WareHousePage_1] = BagType.WAREHOUSE,
    [bagContainerType.WareHousePage_2] = BagType.Warehouse_2,
    [bagContainerType.WareHousePage_3] = BagType.Warehouse_3,
    [bagContainerType.WareHousePage_4] = BagType.Warehouse_4,
    [bagContainerType.WareHousePage_5] = BagType.Warehouse_5,
    [bagContainerType.WareHousePage_6] = BagType.Warehouse_6,
    [bagContainerType.WareHousePage_7] = BagType.Warehouse_7,
    [bagContainerType.WareHousePage_8] = BagType.Warehouse_8,
    [bagContainerType.WareHousePage_9] = BagType.Warehouse_9,
    [bagContainerType.BeiluzCore] = BagType.BELLUZ,
    [bagContainerType.PlayerCustom] = BagType.PHOTO_FRAME,
}

--- 客户端启用了哪些容器，用客户端类型
local C_ACTIVE_CONT_HASH_TABLE = {
    [bagContainerType.Bag] = 1,
    [bagContainerType.Cart] = 1,
    [bagContainerType.Equip] = 1,
    [bagContainerType.Merchant] = 1,
    [bagContainerType.Wardrobe] = 1,
    [bagContainerType.HeadIcon] = 1,
    [bagContainerType.LifeProfession] = 1,
    [bagContainerType.Title] = 1,
    [bagContainerType.TitleUsing] = 1,
    [bagContainerType.VirtualItem] = 1,
    [bagContainerType.ShortCut] = 1,
    [bagContainerType.WareHousePage_1] = 1,
    [bagContainerType.WareHousePage_2] = 1,
    [bagContainerType.WareHousePage_3] = 1,
    [bagContainerType.WareHousePage_4] = 1,
    [bagContainerType.WareHousePage_5] = 1,
    [bagContainerType.WareHousePage_6] = 1,
    [bagContainerType.WareHousePage_7] = 1,
    [bagContainerType.WareHousePage_8] = 1,
    [bagContainerType.WareHousePage_9] = 1,
    [bagContainerType.BeiluzCore] = 1,
    [bagContainerType.PlayerCustom] = 1,
}

--- 这个表是一个外界可以访问到的表，是一个静态数据
--- 这个数据主要是为了发生道具的移动的时候，能够缩小搜索UID的范围
--- 这个数据描述的是目标容器对应的能够移动到这个目标的容器有哪些，比如钓鱼道具本身是和任何容器之间都没有交互的
local C_CONT_SRC_TAR_MAP = {
    [bagContainerType.Bag] = {
        bagContainerType.Cart,
        bagContainerType.Equip,
        bagContainerType.Merchant,
        bagContainerType.Wardrobe,
        bagContainerType.WareHousePage_1,
        bagContainerType.WareHousePage_2,
        bagContainerType.WareHousePage_3,
        bagContainerType.WareHousePage_4,
        bagContainerType.WareHousePage_5,
        bagContainerType.WareHousePage_6,
        bagContainerType.WareHousePage_7,
        bagContainerType.WareHousePage_8,
        bagContainerType.WareHousePage_9,
        bagContainerType.BeiluzCore,
    },
    [bagContainerType.Cart] = { bagContainerType.Bag, },
    [bagContainerType.Equip] = { bagContainerType.Bag, },
    [bagContainerType.Wardrobe] = { bagContainerType.Bag, },
    [bagContainerType.Merchant] = { bagContainerType.Bag, },
    [bagContainerType.Title] = { bagContainerType.TitleUsing },
    [bagContainerType.TitleUsing] = { bagContainerType.Title },
    [bagContainerType.WareHousePage_1] = { bagContainerType.Bag, },
    [bagContainerType.WareHousePage_2] = { bagContainerType.Bag, },
    [bagContainerType.WareHousePage_3] = { bagContainerType.Bag, },
    [bagContainerType.WareHousePage_4] = { bagContainerType.Bag, },
    [bagContainerType.WareHousePage_5] = { bagContainerType.Bag, },
    [bagContainerType.WareHousePage_6] = { bagContainerType.Bag, },
    [bagContainerType.WareHousePage_7] = { bagContainerType.Bag, },
    [bagContainerType.WareHousePage_8] = { bagContainerType.Bag, },
    [bagContainerType.WareHousePage_9] = { bagContainerType.Bag, },
    [bagContainerType.BeiluzCore] = { bagContainerType.Bag, },
    [bagContainerType.PlayerCustom] = { bagContainerType.HeadIcon, },
    [bagContainerType.HeadIcon] = { bagContainerType.PlayerCustom, },
}

local C_WAREHOUSE_PAGE_IDX_MAP = {
    [1] = bagContainerType.WareHousePage_1,
    [2] = bagContainerType.WareHousePage_2,
    [3] = bagContainerType.WareHousePage_3,
    [4] = bagContainerType.WareHousePage_4,
    [5] = bagContainerType.WareHousePage_5,
    [6] = bagContainerType.WareHousePage_6,
    [7] = bagContainerType.WareHousePage_7,
    [8] = bagContainerType.WareHousePage_8,
    [9] = bagContainerType.WareHousePage_9,
}

--- 容器和子容器类型映射
--- 以为仓库页是分容器，但是客户端查询道具的时候需要写九个枚举
--- 为了减少参数的数量，所以做一个映射表
local C_SUB_CONT_MAP = {
    [bagContainerType.WareHouse] = {
        bagContainerType.WareHousePage_1,
        bagContainerType.WareHousePage_2,
        bagContainerType.WareHousePage_3,
        bagContainerType.WareHousePage_4,
        bagContainerType.WareHousePage_5,
        bagContainerType.WareHousePage_6,
        bagContainerType.WareHousePage_7,
        bagContainerType.WareHousePage_8,
        bagContainerType.WareHousePage_9,
    }
}

---@class BagTypeClientSvrMap
BagTypeClientSvrMap = class("BagTypeClientSvrMap")

function BagTypeClientSvrMap:ctor()
    -- do nothing
end

--- 获取子类型列表
function BagTypeClientSvrMap:GetSubContTypeList(contType)
    if nil == contType then
        logError("[BagTypeClientSvrMap] invalid param")
        return nil
    end

    local ret = C_SUB_CONT_MAP[contType]
    return ret
end

--- 根据编号获取仓库页的容器类型
function BagTypeClientSvrMap:GetWareHouseContTypeByIdx(idx)
    if nil == idx then
        logError("[BagTypeClientSvrMap] invalid param")
        return C_INVALID_SVR_TYPE
    end

    local ret = C_WAREHOUSE_PAGE_IDX_MAP[idx]
    if nil == ret then
        logError("[BagTypeMap] invalid idx: " .. tostring(idx))
        return C_INVALID_SVR_TYPE
    end

    return ret
end

--- 获取服务器非法容器类型的，如果收到了这个类型说明有问题
function BagTypeClientSvrMap:GetInvalidSvrType()
    return C_INVALID_SVR_TYPE
end

function BagTypeClientSvrMap:GetActiveContTable()
    return C_ACTIVE_CONT_HASH_TABLE
end

--- 获取转移位置映射关系的映射表
function BagTypeClientSvrMap:GetMoveRelationMap()
    return C_CONT_SRC_TAR_MAP
end

function BagTypeClientSvrMap:IsContActive(clientType)
    if nil == clientType then
        logError("[BagTypeClientSvrMap] invalid param")
        return false
    end

    local target = C_ACTIVE_CONT_HASH_TABLE[clientType]
    return nil ~= target
end

--- 根据服务器背包容器类型转换到客户端背包容器类型
function BagTypeClientSvrMap:GetClientContType(svrType)
    if nil == svrType then
        logError("[BagTypeMap] invalid param")
        return bagContainerType.None
    end

    local ret = C_SVR_TO_CLIENT_MAP[svrType]
    if nil == ret then
        logError("[BagTypeMap] invalid type: " .. tostring(svrType))
        return bagContainerType.None
    end

    return ret
end

--- 根据客户端类型返回服务器类型
function BagTypeClientSvrMap:GetSvrContType(clientType)
    if nil == clientType then
        logError("[BagTypeMap] invalid param")
        return C_INVALID_SVR_TYPE
    end

    local ret = C_CLIENT_TO_SVR_MAP[clientType]
    if nil == ret then
        logError("[BagTypeMap] invalid type: " .. tostring(clientType))
        return C_INVALID_SVR_TYPE
    end

    return ret
end

--- 根据服务器装备槽位转换客户端装备槽位
--- 其实这里应该做成映射
function BagTypeClientSvrMap:GetClientEquipSlot(svrSlot)
    if nil == svrSlot then
        logError("[BagTypeMap] invalid param")
        return GameEnum.EEquipSlotIdxType.None
    end

    return svrSlot + 1
end