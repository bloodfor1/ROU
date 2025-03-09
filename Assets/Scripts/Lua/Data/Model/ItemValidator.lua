--- 这个类是用来做客户端交换逻辑的验证的
module("Data", package.seeall)

---@class ItemValidator
ItemValidator = class("ItemValidator")

local E_CLIENT_ERROR_CODE = GameEnum.EClientErrorCode
local E_CLIENT_BAG_TYPE = GameEnum.EBagContainerType

function ItemValidator:ctor()
    self._errCodeStrMap = {
        [E_CLIENT_ERROR_CODE.ItemLvInvalid] = "C_INVALID_LV",
        [E_CLIENT_ERROR_CODE.ItemGenderInvalid] = "C_INVALID_GENDER",
        [E_CLIENT_ERROR_CODE.ItemProfessionInvalid] = "C_INVALID_PROFESSION",
        [E_CLIENT_ERROR_CODE.BagWeightExceeded] = "C_INVALID_BAG_WEIGHT",
        [E_CLIENT_ERROR_CODE.ItemCannotGotoWarehouse] = "C_CANNOT_GOTO_WAREHOUSE",
        [E_CLIENT_ERROR_CODE.RunningGearCannotGotoWareHouse] = "C_RUNNING_GEAR_CANNOT_GOTO_WAREHOUSE",
        [E_CLIENT_ERROR_CODE.ItemCannotGotoCart] = "C_CANNOT_GOTO_CART",
        [E_CLIENT_ERROR_CODE.ItemCannotGotoShortCutBar] = "C_CANNOT_GOTO_SHORT",
        [E_CLIENT_ERROR_CODE.CannotEquipBackUpWeapon] = "C_CANNOT_EQUIP_BACKUP_WEAPON",
        [E_CLIENT_ERROR_CODE.EquipSwitchInCd] = "C_EQUIP_SWITCH_IN_CD",
        [E_CLIENT_ERROR_CODE.TrolleyWeightExceeded] = "C_INVALID_TROLLEY_WEIGHT",
        [E_CLIENT_ERROR_CODE.CarItemMax] = "C_CAR_ITEM_MAX"
    }
end

--- 这里调用的方法没有递进关系，每个方法独立判断，当遇到一个条件不满足就会返回错误码
---@param itemData ItemData
---@return number
function ItemValidator:ValidateItem(itemData, targetClientContType, targetPos, itemCount)
    if nil == itemData or nil == targetClientContType then
        logError("[ItemValidator] invalid param")
        return E_CLIENT_ERROR_CODE.Unknown
    end

    local C_VALIDATE_FUNC_MAP = {
        self._validateItemLv,
        self._validateItemGender,
        self._validateItemProfession,
        self._validateBagWeight,
        self._validateTrolleyWeight,
        self._validateWareHouse,
        self._validateCart,
        self._validateShortCutBar,
        self._validateBackUpWeapon,
    }

    local result = E_CLIENT_ERROR_CODE.Success
    local str = nil
    for i = 1, #C_VALIDATE_FUNC_MAP do
        local singleFunc = C_VALIDATE_FUNC_MAP[i]
        result, str = singleFunc(self, itemData, targetClientContType, targetPos, itemCount)
        if E_CLIENT_ERROR_CODE.Success ~= result then
            break
        end
    end

    if E_CLIENT_ERROR_CODE.Success ~= result then
        local tipsMgr = MgrMgr:GetMgr("TipsMgr")
        if nil == str then
            tipsMgr.ShowNormalTips(Lang(self._errCodeStrMap[result]))
        else
            tipsMgr.ShowNormalTips(Lang(self._errCodeStrMap[result], str))
        end
    end

    return result
end

--- 验证道具等级是否满足需求，仅限于装备道具的情况
---@param itemData ItemData
---@return number
function ItemValidator:_validateItemLv(itemData, targetClientContType, targetPos)
    if E_CLIENT_BAG_TYPE.ShortCut == itemData.ContainerType then
        return E_CLIENT_ERROR_CODE.Success
    end

    if E_CLIENT_BAG_TYPE.Equip ~= targetClientContType then
        return E_CLIENT_ERROR_CODE.Success
    end

    local equipLv = itemData:GetEquipTableLv()
    if MPlayerInfo.Lv < equipLv then
        return E_CLIENT_ERROR_CODE.ItemLvInvalid
    end

    return E_CLIENT_ERROR_CODE.Success
end

--- 验证道具性别是否满足需求
---@param itemData ItemData
---@return number
function ItemValidator:_validateItemGender(itemData, targetClientContType, targetPos)
    if E_CLIENT_BAG_TYPE.ShortCut == itemData.ContainerType then
        return E_CLIENT_ERROR_CODE.Success
    end

    if E_CLIENT_BAG_TYPE.Equip ~= targetClientContType then
        return E_CLIENT_ERROR_CODE.Success
    end

    local genderType = GameEnum.EPlayerGender
    local playerGender = MPlayerInfo.IsMale and genderType.Male or genderType.Female
    local matchGender = genderType.NoGender == itemData.ItemConfig.SexLimit or itemData.ItemConfig.SexLimit == playerGender
    if not matchGender then
        return E_CLIENT_ERROR_CODE.ItemGenderInvalid
    end

    return E_CLIENT_ERROR_CODE.Success
end

--- 验证道具职业是否满足需求
---@param itemData ItemData
---@return number
function ItemValidator:_validateItemProfession(itemData, targetClientContType, targetPos)
    if E_CLIENT_BAG_TYPE.ShortCut == itemData.ContainerType then
        return E_CLIENT_ERROR_CODE.Success
    end

    if E_CLIENT_BAG_TYPE.Equip ~= targetClientContType then
        return E_CLIENT_ERROR_CODE.Success
    end

    local proHash = {}
    self:_getProIdHash(MPlayerInfo.ProfessionId, proHash)
    for i = 0, itemData.ItemConfig.Profession.Length - 1 do
        local singlePro = itemData.ItemConfig.Profession[i][0]
        local isProOnly = 1 == itemData.ItemConfig.Profession[i][1]

        --- 如果出现了0，默认没有职业限制
        if 0 == singlePro then
            return E_CLIENT_ERROR_CODE.Success
        end

        if isProOnly then
            if MPlayerInfo.ProfessionId == singlePro then
                return E_CLIENT_ERROR_CODE.Success
            end
        else
            if nil ~= proHash[singlePro] then
                return E_CLIENT_ERROR_CODE.Success
            end
        end
    end

    return E_CLIENT_ERROR_CODE.ItemProfessionInvalid
end

--- 返回职业的哈希表
function ItemValidator:_getProIdHash(professionID, hashTable)
    if nil == hashTable then
        hashTable = {}
    end

    ---@type ProfessionTable
    local config = TableUtil.GetProfessionTable().GetRowById(professionID, true)
    if nil == config then
        return
    end

    hashTable[config.Id] = 1
    self:_getProIdHash(config.ParentProfession, hashTable)
end

--- 验证背包是否超重
---@param itemData ItemData
---@return number
function ItemValidator:_validateBagWeight(itemData, targetClientContType, targetPos, itemCount)
    if E_CLIENT_BAG_TYPE.ShortCut == itemData.ContainerType then
        return E_CLIENT_ERROR_CODE.Success
    end

    if E_CLIENT_BAG_TYPE.Bag ~= targetClientContType then
        return E_CLIENT_ERROR_CODE.Success
    end

    local itemWeightMgr = MgrMgr:GetMgr("ItemWeightMgr")
    if itemWeightMgr.IsWeightExceeded(E_CLIENT_BAG_TYPE.Bag) then
        return E_CLIENT_ERROR_CODE.BagWeightExceeded
    end

    local currentWeight = itemWeightMgr.GetCurrentWeightByType(E_CLIENT_BAG_TYPE.Bag)
    local maxWeight = itemWeightMgr.GetMaxWeightByType(E_CLIENT_BAG_TYPE.Bag)
    local diffWeight = maxWeight - currentWeight
    if diffWeight < itemData:GetWeight() * itemCount then
        return E_CLIENT_ERROR_CODE.BagWeightExceeded
    end

    return E_CLIENT_ERROR_CODE.Success
end

---@param itemData ItemData
---@return number
function ItemValidator:_validateTrolleyWeight(itemData, targetClientContType, targetPos, itemCount)
    if E_CLIENT_BAG_TYPE.Cart ~= targetClientContType then
        return E_CLIENT_ERROR_CODE.Success
    end

    local itemWeightMgr = MgrMgr:GetMgr("ItemWeightMgr")
    if itemWeightMgr.IsWeightExceeded(E_CLIENT_BAG_TYPE.Cart) then
        return E_CLIENT_ERROR_CODE.TrolleyWeightExceeded
    end

    --- 如果道具得重量大于当前剩余得重量，这个时候也会产生拦截
    local currentWeight = itemWeightMgr.GetCurrentWeightByType(E_CLIENT_BAG_TYPE.Cart)
    local maxWeight = itemWeightMgr.GetMaxWeightByType(E_CLIENT_BAG_TYPE.Cart)
    local diffWeight = maxWeight - currentWeight
    if diffWeight < itemData:GetWeight() * itemCount then
        return E_CLIENT_ERROR_CODE.TrolleyWeightExceeded
    end

    return E_CLIENT_ERROR_CODE.Success
end

--- 验证道具是否能进入仓库
---@param itemData ItemData
---@return number
function ItemValidator:_validateWareHouse(itemData, targetClientContType, targetPos)
    if E_CLIENT_BAG_TYPE.ShortCut == itemData.ContainerType then
        return E_CLIENT_ERROR_CODE.Success
    end

    local C_VALID_WAREHOUSE_TYPE_MAP = {
        [E_CLIENT_BAG_TYPE.WareHousePage_1] = 1,
        [E_CLIENT_BAG_TYPE.WareHousePage_2] = 1,
        [E_CLIENT_BAG_TYPE.WareHousePage_3] = 1,
        [E_CLIENT_BAG_TYPE.WareHousePage_4] = 1,
        [E_CLIENT_BAG_TYPE.WareHousePage_5] = 1,
        [E_CLIENT_BAG_TYPE.WareHousePage_6] = 1,
        [E_CLIENT_BAG_TYPE.WareHousePage_7] = 1,
        [E_CLIENT_BAG_TYPE.WareHousePage_8] = 1,
        [E_CLIENT_BAG_TYPE.WareHousePage_9] = 1,
    }

    if nil == C_VALID_WAREHOUSE_TYPE_MAP[targetClientContType] then
        return E_CLIENT_ERROR_CODE.Success
    end

    if 0 < itemData:GetExpireTime() then
        if itemData:ItemMatchesType(GameEnum.EItemType.BelluzGear) then
            return E_CLIENT_ERROR_CODE.RunningGearCannotGotoWareHouse
        end

        return E_CLIENT_ERROR_CODE.ItemCannotGotoWarehouse
    end

    if 0 == itemData.ItemConfig.CanStorehouse then
        return E_CLIENT_ERROR_CODE.ItemCannotGotoWarehouse
    end

    return E_CLIENT_ERROR_CODE.Success
end

--- 验证道具是否能进入小推车
---@param itemData ItemData
---@return number
function ItemValidator:_validateCart(itemData, targetClientContType, targetPos)
    if E_CLIENT_BAG_TYPE.ShortCut == itemData.ContainerType then
        return E_CLIENT_ERROR_CODE.Success
    end

    if E_CLIENT_BAG_TYPE.Cart ~= targetClientContType then
        return E_CLIENT_ERROR_CODE.Success
    end

    if 0 < itemData:GetExpireTime() then
        return E_CLIENT_ERROR_CODE.ItemCannotGotoCart
    end

    if 0 == itemData.ItemConfig.CanCart then
        return E_CLIENT_ERROR_CODE.ItemCannotGotoCart
    end

    local containerTypes = { GameEnum.EBagContainerType.Cart }
    local cartItems = Data.BagApi:GetItemsByTypesAndConds(containerTypes, nil)
    local carItemCount = Data.BagModel:getMaxCarItemNum()
    if #cartItems < carItemCount then
        return E_CLIENT_ERROR_CODE.Success
    end

    for i = 1, #cartItems do
        local singleItem = cartItems[i]
        if itemData:CanCollapse(singleItem) then
            return E_CLIENT_ERROR_CODE.Success
        end
    end
    if #cartItems >= carItemCount then
        return E_CLIENT_ERROR_CODE.CarItemMax
    end
    return E_CLIENT_ERROR_CODE.ItemCannotGotoCart
end

--- 验证道具是否能进入快捷使用
---@param itemData ItemData
---@return number
function ItemValidator:_validateShortCutBar(itemData, targetClientContType, targetPos)
    if E_CLIENT_BAG_TYPE.ShortCut ~= targetClientContType then
        return E_CLIENT_ERROR_CODE.Success
    end

    if 0 == itemData.ItemConfig.CanQuick then
        return E_CLIENT_ERROR_CODE.ItemCannotGotoShortCutBar
    end

    return E_CLIENT_ERROR_CODE.Success
end

--- 判断是否能装备副手武器
---@param itemData ItemData
---@return number
function ItemValidator:_validateBackUpWeapon(itemData, targetClientContType, targetPos)
    if E_CLIENT_BAG_TYPE.ShortCut == itemData.ContainerType then
        return E_CLIENT_ERROR_CODE.Success
    end

    if E_CLIENT_BAG_TYPE.Equip ~= targetClientContType then
        return E_CLIENT_ERROR_CODE.Success
    end

    if EquipPos.SECONDARY_WEAPON ~= targetPos then
        return E_CLIENT_ERROR_CODE.Success
    end

    local targetWeapon = Data.BagApi:GetItemByTypeSlot(GameEnum.EBagContainerType.Equip, GameEnum.EEquipSlotIdxType.MainWeapon)
    if nil == targetWeapon then
        return E_CLIENT_ERROR_CODE.Success
    end

    ---@type EquipWeaponTable
    local weaponConfig = TableUtil.GetEquipWeaponTable().GetRowById(targetWeapon.EquipConfig.WeaponId)
    local C_HOLDING_MAP = {
        [GameEnum.EWeaponCarryType.DoubleHand] = 1,
        [GameEnum.EWeaponCarryType.DoubleWeaponDoubleHand] = 1,
    }

    if nil ~= C_HOLDING_MAP[weaponConfig.HoldingMode] then
        return E_CLIENT_ERROR_CODE.CannotEquipBackUpWeapon
    end

    return E_CLIENT_ERROR_CODE.Success
end

return ItemValidator