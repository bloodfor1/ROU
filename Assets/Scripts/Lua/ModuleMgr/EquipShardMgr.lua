require "TableEx/ShopOffLineMap"

module("ModuleMgr.EquipShardMgr", package.seeall)

---@param itemData ItemData
local function _getEquipIDFunc(itemData)
    --- 图纸道具类型是11，这里欧阳那个1200 - 1199 = 1这个1来表示equipID
    local C_NUMBER_SUB_CLASS_INIT_VALUE = 1200
    if nil == itemData then
        return GameEnum.EEquipSlotType.None
    end

    local currentSubClass = itemData.ItemConfig.Subclass
    local ret = C_NUMBER_SUB_CLASS_INIT_VALUE - currentSubClass
    return ret
end

local equipShardMgr = {}

function equipShardMgr:Init()
    self.C_NUMBER_EQUIP_SHARD_SHOP_ID = GameEnum.EShopType.EquipShardShop
    self._itemCache = Data.ItemLocalDataCache.new(50)
    self._currentLvRangeID = -1
    self._currentEquipCategory = -1
    ---@type table<number, EquipRange>
    self._equipRangeMap = {}
    ---@type EquipShardDataPack[]
    self._currentPageData = {}
    self:_initEquipLvRange()
end

function equipShardMgr:OnLogOut()
    -- do nothing
end

function equipShardMgr:OnReconnected()
    -- do nothing
end

function equipShardMgr:ReqExchange(shopItemID)
    local l_msgId = Network.Define.Rpc.RequestBuyShopItem
    ---@type BuyShopItemArg
    local l_sendInfo = GetProtoBufSendTable("BuyShopItemArg")
    l_sendInfo.shop_type = self.C_NUMBER_EQUIP_SHARD_SHOP_ID
    local item = l_sendInfo.items:add()
    item.table_id = shopItemID
    item.count = 1
    Network.Handler.SendRpc(l_msgId, l_sendInfo, count)
end

function equipShardMgr:InitOnOpen()
    self:_setDefaultPageData()
    self:_setPageData(self._currentLvRangeID, self._currentEquipCategory)
end

---@return table<number, EquipRange>
function equipShardMgr:GetRangeLvData()
    return self._equipRangeMap
end

function equipShardMgr:GetCurrentRangeID()
    return self._currentLvRangeID
end

function equipShardMgr:GetCurrentEquipType()
    return self._currentEquipCategory
end

---@return EquipShardDataPack[]
function equipShardMgr:GetPageData(id, equipID)
    self:_genPageDataByIdType(id, equipID)
    return self._currentPageData
end

---@param itemUpdateDataList ItemUpdateData[]
function equipShardMgr:OnBagUpdate(itemUpdateDataList)
    if nil == itemUpdateDataList then
        return
    end

    for i = 1, #self._currentPageData do
        local requireItems = self._currentPageData[i].RequireItems
        for j = 1, #requireItems do
            local singleRequireItem = requireItems[j]
            local currentItemCount = Data.BagApi:GetItemCountByContListAndTid({ GameEnum.EBagContainerType.Bag }, singleRequireItem.Item.TID)
            singleRequireItem.CurrentCount = currentItemCount
        end
    end

    local gameEventMgr = MgrMgr:GetMgr("GameEventMgr")
    gameEventMgr.RaiseEvent(gameEventMgr.OnShardMatCountUpdate)
end

function equipShardMgr:_setDefaultPageData()
    local currentPlayerLV = MPlayerInfo.Lv
    for i = 1, #self._equipRangeMap do
        local singleData = self._equipRangeMap[i]
        if singleData.LowLv <= currentPlayerLV and singleData.HighLv >= currentPlayerLV then
            self._currentLvRangeID = i
            break
        end
    end

    self._currentEquipCategory = GameEnum.EEquipSlotType.None
end

function equipShardMgr:_setPageData(id, equipType)
    self._currentLvRangeID = id
    self._currentEquipCategory = equipType
    for i = #self._currentPageData, 1, -1 do
        local singleData = self._currentPageData[i]
        self._itemCache:RecycleItemData(singleData.MainData)
        for j = #singleData.RequireItems, 1, -1 do
            local singleMat = singleData.RequireItems[j]
            self._itemCache:RecycleItemData(singleMat.Item)
        end
    end

    self._currentPageData = {}
    local shopOfflineMap = ShopOffLineMap
    local targetData = shopOfflineMap[self.C_NUMBER_EQUIP_SHARD_SHOP_ID]
    if nil == targetData then
        logError("[EquipShardMgr] invalid data")
        return
    end

    local lvRange = self._equipRangeMap[id]
    if nil == lvRange then
        return
    end

    ---@type EquipRangeCondData
    local param = {
        EquipRangeData = lvRange,
        EquipID = equipType
    }

    for key, value in pairs(targetData) do
        local mainData = self._itemCache:GetItemData(key)
        if self._equipMatchesCond(mainData, param) then
            ---@type EquipShardDataPack
            local newShardData = {
                MainData = mainData,
                ShopItemID = value.ShopID,
                RequireItems = {}
            }

            for innerKey, innerValue in pairs(value.ShopDataMap) do
                for i = 1, #innerValue.ShopItemList do
                    local singlePair = innerValue.ShopItemList[i]
                    local singleItem = self._itemCache:GetItemData(singlePair.Id)
                    local currentCount = Data.BagApi:GetItemCountByContListAndTid({ GameEnum.EBagContainerType.Bag }, singlePair.Id)
                    ---@type EquipShardRequireData
                    local itemShopData = {
                        Item = singleItem,
                        RequireCount = singlePair.Value,
                        CurrentCount = currentCount
                    }

                    table.insert(newShardData.RequireItems, itemShopData)
                end

                table.insert(self._currentPageData, newShardData)
            end

            table.sort(self._currentPageData, self._sortFunc)
        else
            self._itemCache:RecycleItemData(mainData)
            mainData = nil
        end
    end
end

--- 参数表示选中了第几个等级区间，以及装备部位选中需要什么东西
function equipShardMgr:_genPageDataByIdType(id, equipType)
    if id == self._currentLvRangeID and equipType == self._currentEquipCategory then
        return
    end

    self:_setPageData(id, equipType)
end

--- 初始化等级分段
function equipShardMgr:_initEquipLvRange()
    local C_STR_TABLE_KEY = "EquipLevelRange"
    local targetStr = TableUtil.GetGlobalTable().GetRowByName(C_STR_TABLE_KEY)
    local strParseMgr = MgrMgr:GetMgr("TableStrParseMgr")
    local lvRange = strParseMgr.ParseValue(targetStr.Value, GameEnum.EStrParseType.Matrix, GameEnum.ELuaBaseType.Number)
    for i = 1, #lvRange do
        local minLv = lvRange[i][1]
        local maxLv = lvRange[i][2]
        ---@type EquipRange
        local range = {
            LowLv = minLv,
            HighLv = maxLv,
        }

        self._equipRangeMap[i] = range
    end
end

--- 判断筛选道具是否满足等级范围和基础类别
---@param itemData ItemData
---@param param EquipRangeCondData
function equipShardMgr._equipMatchesCond(itemData, param)
    if nil == itemData then
        return false
    end

    if nil == param then
        return true
    end

    local equipLv = itemData:GetEquipTableLv()
    if equipLv < param.EquipRangeData.LowLv or equipLv >= param.EquipRangeData.HighLv then
        return false
    end

    --- 如果能获取离线表数据，但是不能获取对应职业，这个时候表示职业不匹配；如果只是在离线表当中没获取到任何数据则认为匹配
    local offLineMapData = ItemProOffLineMap[itemData.TID]
    if nil ~= offLineMapData and nil == offLineMapData[MPlayerInfo.ProfessionId] then
        return false
    end

    --- 如果是没有定义过的类型这个时候认为所以道具都满足这个类型
    if GameEnum.EEquipSlotType.None == param.EquipID then
        return true
    end

    local targetEquipID = _getEquipIDFunc(itemData)
    local ret = targetEquipID == param.EquipID
    return ret
end

---@param a EquipShardDataPack
---@param b EquipShardDataPack
function equipShardMgr._sortFunc(a, b)
    local aEquipID = _getEquipIDFunc(a.MainData)
    local bEquipID = _getEquipIDFunc(b.MainData)
    if aEquipID ~= bEquipID then
        return aEquipID < bEquipID
    end

    local aQuality = a.MainData.ItemConfig.ItemQuality
    local bQuality = b.MainData.ItemConfig.ItemQuality
    if aQuality ~= bQuality then
        return aQuality < bQuality
    end

    local aTID = a.MainData.TID
    local bTID = b.MainData.TID
    return aTID < bTID
end

MgrObj = equipShardMgr

function OnInit()
    MgrObj:Init()
    local gameEventMgr = MgrMgr:GetMgr("GameEventMgr")
    gameEventMgr.Register(gameEventMgr.OnBagUpdate, MgrObj.OnBagUpdate, MgrObj)
end

function OnLogout()
    MgrObj:OnLogOut()
end

function OnReconnected()
    MgrObj:OnReconnected()
end

return ModuleMgr.EquipShardMgr