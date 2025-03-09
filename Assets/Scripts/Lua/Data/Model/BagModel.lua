require "Data/BaseModel"
require "Event/EventDispacher"

module("Data", package.seeall)

local super = Data.BaseModel
BagModel = class("BagModel", super)

BagModel.MONEYNUMBER = EventDispatcher.new()

BagModel.AssassinDoubleHandSkillID = MGlobalConfig:GetInt("AssassinDoubleHandSkillID")

local l_potName = {}
local l_potNowId = 1
local l_propNowType = 0
local l_openModel = 1

--红点
local l_redTable = {}
--道具解锁个数
local l_propUnlockNum = 0
--仓库解锁页数
local l_potUnlockNum = 0
--ItemDlg数据结构
local l_potPageItemInfo = { {} }

--全局表数据
local l_bagLoadExtendPerTime = MGlobalConfig:GetInt("BagLoadExtendPerTime")
local l_bagLoadExtendTimes = MGlobalConfig:GetInt("BagLoadExtendTimes")
local l_bagLoadUnlockItemID = MGlobalConfig:GetInt("BagLoadUnlockItemID")

local l_potInitialNum = MGlobalConfig:GetInt("PotInitialNum")
local l_potExNum = MGlobalConfig:GetInt("PotExNum")
local l_potUnlockPerNum = MGlobalConfig:GetInt("PotUnlockPerNum")
local l_potShowLockRow = MGlobalConfig:GetInt("PotShowLockRow")
local l_potUnlockItemId = MGlobalConfig:GetInt("PotUnlockItemId")
local l_potUnlockItemNums = MGlobalConfig:GetSequenceOrVectorInt("PotUnlockItemNums")
local l_potGridNum = MGlobalConfig:GetInt("PotGridNum")
local l_potDefaultName = Lang(MGlobalConfig:GetString("PotDefaultName"))

local l_cardBorderAtlas = MGlobalConfig:GetString("CardBorderAtlas")
local l_cardBorder1 = MGlobalConfig:GetString("CardBorder1")
local l_cardBorder2 = MGlobalConfig:GetString("CardBorder2")
local l_cardBorder3 = MGlobalConfig:GetString("CardBorder3")
local l_cardBorder4 = MGlobalConfig:GetString("CardBorder4")

local l_itemBluePrintBg = MGlobalConfig:GetString("ItemBluePrintBg")
local l_itemDefaultBg = MGlobalConfig:GetString("ItemDefaultBg")
local l_itemExistBg = MGlobalConfig:GetString("ItemExistBg")

local l_itemDefaultWH = MGlobalConfig:GetSequenceOrVectorFloat("ItemDefaultWH")
local l_itemCardWH = MGlobalConfig:GetSequenceOrVectorFloat("ItemCardWH")
local l_itemDragScale = MGlobalConfig:GetSequenceOrVectorFloat("ItemDragScale")

local l_itemPropBg1 = MGlobalConfig:GetString("ItemPropBg1")
local l_itemPropBg2 = MGlobalConfig:GetString("ItemPropBg2")
local l_itemPropBg3 = MGlobalConfig:GetString("ItemPropBg3")
local l_itemPropBg4 = MGlobalConfig:GetString("ItemPropBg4")

local l_bigItemPropBg1 = MGlobalConfig:GetString("ItemComBig1")
local l_bigItemPropBg2 = MGlobalConfig:GetString("ItemComBig2")
local l_bigItemPropBg3 = MGlobalConfig:GetString("ItemComBig3")
local l_bigItemPropBg4 = MGlobalConfig:GetString("ItemComBig4")
local l_bigItemPropBg5 = MGlobalConfig:GetString("ItemComBig5")

local l_qualitySp = { l_cardBorder1, l_cardBorder2, l_cardBorder3, l_cardBorder4 }
local l_propQualitySp = { [0] = l_itemExistBg, [1] = l_itemPropBg1, [2] = l_itemPropBg2, [3] = l_itemPropBg3, [4] = l_itemPropBg4 }
local l_bigPropQualitySp = { [0] = l_bigItemPropBg1, [1] = l_bigItemPropBg2, [2] = l_bigItemPropBg3, [3] = l_bigItemPropBg4, [4] = l_bigItemPropBg5 }

--每个页签下的道具数量
local l_typePropNum = {}

--根据道具表ID索引的道具数量
local l_propNumByItemId = {}

--负重
local l_reAddWeightNum = 0

--手推车
local l_maxCarItemNum = 0

local l_diamondPolicy = {
    [1] = { GameEnum.l_virProp.Coin103 },
    [2] = { GameEnum.l_virProp.Coin104 },
    [3] = { GameEnum.l_virProp.Coin103, GameEnum.l_virProp.Coin104 },
    [4] = { GameEnum.l_virProp.Coin104, GameEnum.l_virProp.Coin103 },
}

local l_ItemIDCombinePolicyMap = {
    [GameEnum.l_virProp.Coin103] = "GetDiamondByPolicy",
    [GameEnum.l_virProp.Coin104] = "GetDiamondByPolicy"
}
---------------------
--public
BagModel.ItemFunction = {
    Buff = 1,
    RandomTrans = 2,
    ConstTrans = 3,
    OpenUI = 4,
    Gift = 5,
    Ticket = 6,
    Award = 7,
    Arrow = 8,
    ExchangeItemShop = 10,
    EvilTicket = 13
} -- 9是读取一个技能 11是使用工会礼盒 13恶魔宝藏的卷子

--- 背包页当前状态
BagModel.OpenModel = {
    None = 0,
    Normal = 1,
    QuickItem = 2,
    Shop = 3,
    Sale = 4,
    Pot = 5,
    Test = 6,
    Tips = 7,
    Car = 8
}

-- 已废弃，移至GameEnum.EItemType
BagModel.PropType = {
    Weapon = 1, -- 装备
    Consume = 2, -- 消耗品
    Material = 3, -- 材料
    Card = 4, -- 卡片
    NotType = 5, -- 背包内道具
    Fashion = 6, -- 时装
    Coin = 7, -- 货币
    Cookbook = 8, -- 菜谱
    Task = 9, -- 任务道具
    Life = 10, -- 生活职业道具
    BluePrint = 11, -- 头饰图纸
    Displacer = 12, -- 置换器
    Head = 13, -- 头像
    Vehicle = 14, --载具
    VehicleExp = 15, --载具经验道具
    CardFragment = 16, --卡片碎片r
    Title = 17, -- 称号
    Beiluz = 20, -- 贝鲁兹
    CountLimit = 23, --有使用次数限制的道具
}

BagModel.WeapType = {
    Head = EquipPos.HEAD_GEAR,
    Mouth = EquipPos.MOUTH_GEAR,
    MainWeapon = EquipPos.MAIN_WEAPON,
    Cloak = EquipPos.CLOAK,
    OrnaL = EquipPos.ORNAMENT1,
    Face = EquipPos.FACE_GEAR,
    Cloth = EquipPos.ARMOR,
    Assist = EquipPos.SECONDARY_WEAPON,
    Shoe = EquipPos.BOOTS,
    OrnaR = EquipPos.ORNAMENT2,
    Back = EquipPos.BACK_GEAR,
    Ride = EquipPos.HORSE,
    TROLLEY = EquipPos.TROLLEY,
    BattleHorse = EquipPos.BATTLE_HORSE,
    BattleBird = EquipPos.BATTLE_BIRD,
    Fashion = EquipPos.FASHION,
}

BagModel.WeapTableType = {
    EquipPos.MAIN_WEAPON, --主武器
    EquipPos.SECONDARY_WEAPON, --副武器
    EquipPos.ARMOR, --盔甲
    EquipPos.CLOAK, --披风
    EquipPos.BOOTS, --靴子
    EquipPos.ORNAMENT1, --饰品
    EquipPos.HEAD_GEAR,
    EquipPos.FACE_GEAR,
    EquipPos.MOUTH_GEAR,
    EquipPos.BACK_GEAR,
    EquipPos.HORSE,
    EquipPos.TROLLEY,
    EquipPos.BATTLE_HORSE,
    EquipPos.BATTLE_BIRD,
    EquipPos.FASHION,
}

--CommonItemTip类型
BagModel.WeaponStatus = {
    IN_BAG = 1, --在背包中
    ON_BODY = 2, --身上的装备 显示卸下
    JUST_COMPARE = 3, --单纯对比
    JUST_COMPARE_ORNAMENT1 = 4, --更换
    JUST_COMPARE_ORNAMENT2 = 5, --更换
    TO_POT = 6, --放入仓库
    TO_PROP = 7, --放入背包
    NORMAL_PROP = 8, --普通道具
    TO_USE = 9, --使用物品
    TO_SHOP = 10, --商店
    TO_STALL = 11, --摆摊
    JUST_COMPARE_Dagger1 = 12, --当盗贼学了双持武器技能的时候,可以装备两把匕首,这时候可以选择替换
    JUST_COMPARE_Dagger2 = 13, --当盗贼学了双持武器技能的时候,可以装备两把匕首,这时候可以选择替换
    Gift = 14, --赠送礼物
    FISH_PROP = 15, --钓鱼用具
    EXTRACT_CARD = 16, --抽卡
    RECOVE_CARD = 17, --分解
    CHOOSE_GIFT = 18, --选择礼品
    TO_MERCHANT = 19, --跑商
    MALL = 20, --商城界面的特例商品
    TO_MERCHANT_SELL = 21, --跳转跑商
}

--tips按钮显示规则
BagModel.ButtonStatus = {
    Show = 1, --显示
    NoShow = 2, --不显示
}

g_currentSelectUID = 0

-- 是否是金币
function BagModel:IsDiamond(id)
    if not self.C_GOLD_COIN_HASH then
        self.C_GOLD_COIN_HASH = {
            [MgrMgr:GetMgr("PropMgr").l_virProp.Coin103] = 1,
            [MgrMgr:GetMgr("PropMgr").l_virProp.Coin104] = 1,
        }
    end
    return self.C_GOLD_COIN_HASH[id] ~= nil
end

---@param roleData RoleAllInfo
function BagModel:OnSelectRoleNtf(roleData)
    local l_bagTable = roleData.bag
    local l_wareTable = l_bagTable.warehouse
    local l_bagUnlockSpace = l_bagTable.bag_unlock_space
    local l_warehouseUnlockPages = l_bagTable.warehouse_unlock_pages
    local l_bagLoadAddTimes = l_bagTable.bag_load_extend_times
    local l_cartMaxBlank = l_bagTable.cart_max_blank
    local health = roleData.role_health
    if health then
        if health.extra_fight_time ~= nil then
            Data.PlayerInfoModel:SetExtraFightTime(health.extra_fight_time)
        end
    end

    l_maxCarItemNum = l_cartMaxBlank
    for i = 1, #l_wareTable do
        local l_wareName = l_wareTable[i].name
        if l_wareName == nil or l_wareName == "" then
            l_potName[i] = l_potDefaultName .. i
        else
            l_potName[index] = l_wareName
        end
    end

    l_reAddWeightNum = l_bagLoadExtendTimes - l_bagLoadAddTimes
    l_propNumByItemId = {}
    l_typePropNum = {}
    l_propUnlockNum = l_bagUnlockSpace or 0
    l_potUnlockNum = l_warehouseUnlockPages or 0
end

function BagModel:addRed(uid)
    l_redTable[uid] = true
end

function BagModel:addPotPageUnlock()
    l_potUnlockNum = l_potUnlockNum + l_potUnlockPerNum
    l_potUnlockNum = math.min(l_potUnlockNum, l_potExNum)
end

function BagModel:deleteAddWeightNum(num)
    l_reAddWeightNum = l_reAddWeightNum + num
end

function BagModel:deleteAll()
    l_potName = {}
    l_redTable = {}
    for k, v in pairs(l_propNumByItemId) do
        local l_id = k
        l_propNumByItemId[l_id] = 0
        self:OnItemNumChange(l_id)
    end

    l_propNumByItemId = {}
    l_openModel = self.OpenModel.Normal
end

function BagModel:deleteRed(uid)
    l_redTable[uid] = nil
end

function BagModel:mdMaxCarItemNum(num)
    l_maxCarItemNum = num
end

function BagModel:mdPotId(id)
    l_potNowId = id
end

--- 获取当前的背包页签编号
---@return number
function BagModel:GetCurrentBagPageIdx()
    return l_propNowType
end

function BagModel:mdPropType(type)
    l_propNowType = type
end

function BagModel:mdOpenModel(model)
    l_openModel = model
end

--seek
function BagModel:getReAddWeightNum()
    return l_reAddWeightNum
end

function BagModel:getMaxCarItemNum()
    return l_maxCarItemNum
end

function BagModel:getMaxItemNum(itemId)
    local l_item = TableUtil.GetItemTable().GetRowByItemID(itemId)
    if not l_item then
        return false, 0
    end

    local l_w = l_item.Weight
    if l_w <= 0 then
        return false, 0
    end

    local bagMaxWeight = MgrMgr:GetMgr("ItemWeightMgr").GetMaxWeightByType(GameEnum.EBagContainerType.Bag)
    local bagCurrentWeight = MgrMgr:GetMgr("ItemWeightMgr").GetCurrentWeightByType(GameEnum.EBagContainerType.Bag)
    local l_remain = bagMaxWeight - bagCurrentWeight
    if l_remain <= 0 then
        return true, 0
    end

    return true, math.floor(l_remain / l_w)
end

function BagModel:getPotUnlockItemId()
    return l_potUnlockItemId
end

function BagModel:getDragScale()
    return Vector3.New(l_itemDragScale[0], l_itemDragScale[1], 1)
end

--获取卡片部位图标
function BagModel:getCardPosInfo(propId)
    ---@type EquipCardTable
    local l_ecRow = TableUtil.GetEquipCardTable().GetRowByID(propId)
    if not l_ecRow then
        logError("EquipCardTable is not have  " .. propId)
        return nil, nil
    end

    local l_itemTableInfo = TableUtil.GetItemTable().GetRowByItemID(propId)
    if not l_itemTableInfo then
        logError("ItemTable is not have  " .. propId)
        return nil, nil
    end

    local l_eposId = l_ecRow.CanUsePosition[0]
    local l_epRow = TableUtil.GetEquipPositionTable().GetRowByEquipPosition(l_eposId)
    if not l_epRow then
        logError("EquipPositionTable is not have  " .. l_eposId)
        return nil, nil
    end

    local l_equipPositionIconName = nil
    if l_itemTableInfo.ItemQuality == 1 then
        l_equipPositionIconName = l_epRow.CardSpt1
    elseif l_itemTableInfo.ItemQuality == 2 then
        l_equipPositionIconName = l_epRow.CardSpt2
    elseif l_itemTableInfo.ItemQuality == 3 then
        l_equipPositionIconName = l_epRow.CardSpt3
    else
        l_equipPositionIconName = l_epRow.CardSpt4
    end

    return l_epRow.Atlas, l_equipPositionIconName
end

--获取卡片图集背景颜色图标
function BagModel:getCardBgInfo(propId)
    local l_itemTableInfo = TableUtil.GetItemTable().GetRowByItemID(propId)
    if not l_itemTableInfo then
        logError("ItemTable is not have  " .. propId)
        return nil, nil
    end

    local cardAtlas = MGlobalConfig:GetString("CardBorderAtlas")
    local sprite = ""
    if l_itemTableInfo.ItemQuality == 1 then
        sprite = MGlobalConfig:GetString("CardBorder1")
    elseif l_itemTableInfo.ItemQuality == 2 then
        sprite = MGlobalConfig:GetString("CardBorder2")
    elseif l_itemTableInfo.ItemQuality == 3 then
        sprite = MGlobalConfig:GetString("CardBorder3")
    else
        sprite = MGlobalConfig:GetString("CardBorder4")
    end

    return cardAtlas, sprite
end

--获取卡片立绘背景颜色图标
function BagModel:getCardTextureBgInfo(propId)
    local l_itemTableInfo = TableUtil.GetItemTable().GetRowByItemID(propId)
    if not l_itemTableInfo then
        logError("ItemTable is not have  " .. propId)
        return nil, nil
    end

    local cardAtlas = MGlobalConfig:GetString("CardBorderAtlas")
    local sprite = ""
    if l_itemTableInfo.ItemQuality == 1 then
        sprite = MGlobalConfig:GetString("CardFrame1")
    elseif l_itemTableInfo.ItemQuality == 2 then
        sprite = MGlobalConfig:GetString("CardFrame2")
    elseif l_itemTableInfo.ItemQuality == 3 then
        sprite = MGlobalConfig:GetString("CardFrame3")
    else
        sprite = MGlobalConfig:GetString("CardFrame4")
    end

    return cardAtlas, sprite
end

--获取卡片立绘背景颜色图标
function BagModel:getCardTextureBgColor(propId)
    local l_itemTableInfo = TableUtil.GetItemTable().GetRowByItemID(propId)
    if not l_itemTableInfo then
        logError("ItemTable is not have  " .. propId)
        return Color.New(255 / 255, 255 / 255, 255 / 255)
    end

    if l_itemTableInfo.ItemQuality == 1 then
        return Color.New(223 / 255, 237 / 255, 244 / 255), Color.New(64 / 255, 97 / 255, 124 / 255)
    elseif l_itemTableInfo.ItemQuality == 2 then
        return Color.New(226 / 255, 249 / 255, 237 / 255), Color.New(75 / 255, 117 / 255, 96 / 255)
    elseif l_itemTableInfo.ItemQuality == 3 then
        return Color.New(234 / 255, 230 / 255, 244 / 255), Color.New(84 / 255, 88 / 255, 122 / 255)
    else
        return Color.New(246 / 255, 238 / 255, 213 / 255), Color.New(132 / 255, 103 / 255, 72 / 255)
    end

    return Color.New(255 / 255, 255 / 255, 255 / 255)
end

---@param itemData ItemData
function BagModel:getItemWH(itemData)
    local l_type = itemData.ItemConfig.TypeTab
    if l_type == GameEnum.EItemType.Card then
        return Vector2.New(l_itemCardWH[0], l_itemCardWH[1])
    else
        return Vector2.New(l_itemDefaultWH[0], l_itemDefaultWH[1])
    end
end

function BagModel:getCardScale()
    if not l_itemCardWH or not l_itemDefaultWH or l_itemDefaultWH[0] == 0 then
        return 1
    end
    return l_itemCardWH[0] / l_itemDefaultWH[0]
end

---@param itemData ItemData
function BagModel:getItemBgAtlas(itemData)
    local l_res = "Common"
    if itemData ~= nil and itemData.ItemConfig.TypeTab == self.PropType.Card then
        l_res = l_cardBorderAtlas
    end

    return l_res
end

---@param itemData ItemData
function BagModel:getItemBg(itemData)
    if itemData == nil then
        return l_itemDefaultBg
    end

    local l_type = itemData.ItemConfig.TypeTab
    if l_type == self.PropType.BluePrint then
        return l_itemBluePrintBg
    elseif l_type == self.PropType.Card then
        return l_qualitySp[itemData.ItemConfig.ItemQuality]
    end

    if not l_propQualitySp[itemData.ItemConfig.ItemQuality] then
        logError("invalid prop quality ", itemData.ItemConfig.ItemQuality)
    end

    return l_propQualitySp[itemData.ItemConfig.ItemQuality] or l_itemExistBg
end

function BagModel:getItemBgById(id)
    local itemSdata = TableUtil.GetItemTable().GetRowByItemID(id)
    return l_propQualitySp[itemSdata.ItemQuality] or l_itemExistBg
end

function BagModel:getItemBigBg(quality)
    return l_bigPropQualitySp[quality] or l_bigItemPropBg1
end

function BagModel:isRed(uid)
    if l_redTable[uid] == true then
        return true
    end

    return false
end

function BagModel:getAddWeightConsume()
    local l_awConsumeDatas = {}
    local l_awData = {
        ID = l_bagLoadUnlockItemID,
        IsShowCount = false,
        IsShowRequire = true,
        RequireCount = 1,
    }

    table.insert(l_awConsumeDatas, l_awData)
    return l_awConsumeDatas
end

function BagModel:getAddWeightTipsInfo()
    local l_fmTable = {
        [1] = tostring(l_bagLoadExtendPerTime),
        [2] = tostring(l_reAddWeightNum),
    }

    local l_res = StringEx.Format(Lang("ADD_WEIGHT_TIPS"), l_fmTable)
    return l_res
end

function BagModel:getPotPageUnlockTipsInfo()
    local l_itemRow = TableUtil.GetItemTable().GetRowByItemID(l_potUnlockItemId)
    local l_fmTable = {
        [1] = tostring(l_potUnlockPerNum),
        [2] = tostring(l_potUnlockItemNums[l_potUnlockNum / l_potUnlockPerNum]),
        [3] = l_itemRow.ItemName,
    }

    local l_res = StringEx.Format(Lang("POT_UNLOCK_TIPS"), l_fmTable)
    return l_res
end

function BagModel:getPotPageUnlockItemlist()
    l_potPageItemInfo[1].id = l_potUnlockItemId
    l_potPageItemInfo[1].needCount = l_potUnlockItemNums[l_potUnlockNum / l_potUnlockPerNum]
    l_potPageItemInfo[1].showName = true
    l_potPageItemInfo[1].showNeed = true
    return l_potPageItemInfo
end

-- todo 这个地方是因为道具显示一行是5个，如果不满一行需要自动补齐
function BagModel:getPotCellNum()
    if l_openModel == self.OpenModel.Car then
        local items = self:_getItemsInTrolley()
        local trolleyItemCount = #items
        local diffValue = 5 - (trolleyItemCount % 5)
        local currentItemValue = 0
        if 0 == diffValue then
            currentItemValue = trolleyItemCount
        else
            currentItemValue = diffValue + trolleyItemCount
        end

        return math.max(l_maxCarItemNum, currentItemValue)
    end

    return l_potGridNum
end

---@return ItemData[]
function BagModel:_getItemsInTrolley()
    local types = { GameEnum.EBagContainerType.Cart }
    local ret = Data.BagApi:GetItemsByTypesAndConds(types, nil)
    return ret
end

function BagModel:getPotPageCellNum()
    local l_col = 3
    local l_res = l_potInitialNum + l_potUnlockNum
    local l_mod = l_res % l_col
    local l_sub = l_potExNum - l_potUnlockNum
    local l_slNum = l_potShowLockRow * l_col - l_mod
    local l_aNum = math.min(l_sub, l_slNum)
    l_res = l_res + l_aNum
    return l_res
end

---@return ItemData[]
function BagModel:_getItemInBag()
    local types = { GameEnum.EBagContainerType.Bag }
    local ret = Data.BagApi:GetItemsByTypesAndConds(types, nil)
    return ret
end

-- todo 这个方法有严重的问题
-- todo 这个地方不应该自己转一层数据出去
---@return ItemConvertedData[]
function BagModel:getPropList(propIdList)
    local l_result = {}
    local l_table = self:_getItemInBag()
    for i = 1, #l_table do
        local singleItem = l_table[i]
        if propIdList[singleItem.TID] then
            ---@type ItemConvertedData
            local singleData = {
                id = singleItem.TID,
                name = singleItem.ItemConfig.ItemName,
                uid = singleItem.UID,
                num = singleItem.ItemCount,
                is_bind = singleItem.IsBind,
            }

            table.insert(l_result, singleData)
        end
    end

    return l_result
end

function BagModel:getPotName(index)
    return l_potName[index] or (l_potDefaultName .. index)
end

function BagModel:getPotId()
    return l_potNowId
end

function BagModel:getOpenModel()
    return l_openModel
end

--参数 目标武器的装备孔位equipId目标武器的装备类型weaponId
function BagModel:getWeapAdornPos(equipId, weaponId)
    -- todo 获取对应的服务器类型
    local l_pos = Data.BagModel.WeapTableType[equipId]
    local weaponData = nil

    -- todo 如果是左饰品位，但是左饰品有装备，则切换到右饰品（一定是先装左饰品？）
    if l_pos == EquipPos.ORNAMENT1 then
        if nil ~= Data.BagApi:GetItemByTypeSlot(GameEnum.EBagContainerType.Equip, l_pos + 1) then
            l_pos = EquipPos.ORNAMENT2
        end
    end

    -- todo 如果不是主武器，则直接返回获取到的类型
    if l_pos ~= EquipPos.MAIN_WEAPON then
        return l_pos
    end

    -- todo 如果不是刺客双手，直接返回获取到的类型
    if MPlayerInfo:GetCurrentSkillInfo(self.AssassinDoubleHandSkillID).lv <= 0 then
        return l_pos
    end

    -- todo 如果没有主武器，直接装
    if nil == Data.BagApi:GetItemByTypeSlot(GameEnum.EBagContainerType.Equip, l_pos + 1) then
        return l_pos
    end

    -- todo 如果是武器，则需要进一步判断武器类型
    if weaponId and weaponId > 0 then
        weaponData = TableUtil.GetEquipWeaponTable().GetRowById(weaponId)
    end

    -- todo 目标装备武器为双持和双手武器默认装备在主手
    if weaponData and (weaponData.HoldingMode == 2 or weaponData.HoldingMode == 3) then
        l_pos = EquipPos.MAIN_WEAPON
    else
        -- todo 如果是单手武器或者是盾牌
        local wearWeaponId = Data.BagApi:GetItemByTypeSlot(GameEnum.EBagContainerType.Equip, l_pos + 1).TID
        local wearWeaponEquipData = TableUtil.GetEquipTable().GetRowById(wearWeaponId)
        local wearweaponData = wearWeaponEquipData ~= nil and TableUtil.GetEquipWeaponTable().GetRowById(wearWeaponEquipData.WeaponId) or nil

        -- todo 如果当前装备的武器的武器类型是双持和双手武器 那么装备在主手
        if wearweaponData and (wearweaponData.HoldingMode == 2 or wearweaponData.HoldingMode == 3) then
            l_pos = EquipPos.MAIN_WEAPON
        else
            l_pos = EquipPos.SECONDARY_WEAPON
        end
    end

    return l_pos
end

--通过道具ID获取数量，不给出售预览用
---@return int64
function BagModel:GetBagItemCountByTid(tid)
    return MgrMgr:GetMgr("ItemContainerMgr").GetItemCountByContAndID(GameEnum.EBagContainerType.Bag, tid)
end

---@return int64
function BagModel:GetCoinOrPropNumById(id)
    local bagItemCount = self:GetBagItemCountByTid(id)
    local virtualItemCount = self:GetCoinNumById(id)
    return bagItemCount + virtualItemCount
end

---@return int64
function BagModel:GetCoinNumById(id, ignoreCombine)
    local virtualItemCount = 0
    if l_ItemIDCombinePolicyMap[id] and not ignoreCombine then
        virtualItemCount = self[l_ItemIDCombinePolicyMap[id]]()
    else
        virtualItemCount = MgrMgr:GetMgr("ItemContainerMgr").GetItemCountByContAndID(GameEnum.EBagContainerType.VirtualItem, id)
    end
    return virtualItemCount
end

-- 获取金币数量，0：103数量，1：104数量，2：103和104数量，优先103，3：103和104数量，优先104
-- 对于客户端，2和3是一样的，获取103和104的总和
function BagModel:GetDiamondByPolicy(policy)
    local diamondList = l_diamondPolicy[policy]
    if diamondList == nil then
        diamondList = l_diamondPolicy[tonumber(TableUtil.GetGlobalTable().GetRowByName("RechargeMoneyReduceType").Value)]
    end
    if diamondList == nil then
        logError("消耗金币的策略ID传错了")
        return 0
    end
    local count = 0
    for _, v in ipairs(diamondList) do
        count = count + MgrMgr:GetMgr("ItemContainerMgr").GetItemCountByContAndID(GameEnum.EBagContainerType.VirtualItem, v)
    end
    return count
end

function BagModel:PotPageIsLock(index)
    if index - l_potInitialNum - l_potUnlockNum > 0 then
        return true
    end
    return false
end

local YEZI_ID = 2031004
local LANMOKUANG_ID = 2020002

function BagModel:OnItemNumChange(id)
    if id == YEZI_ID or id == LANMOKUANG_ID then
        MEventMgr:LuaFireGlobalEvent(MEventType.MGlobalEvent_Revive_ItemChange)
    end
end

--- 用TID创建Item数据，主要是提供一些假数据的时候用的
---@param tid number
---@return ItemData
function BagModel:CreateItemWithTid(tid)
    if nil == tid then
        logError("[BagModel] item tid got nil")
        return nil
    end

    return Data.BagApi:CreateLocalItemData(tid)
end

--- 外部方法，创建本地道具数据
---@param itemPBData Item
---@return ItemData
function BagModel:CreateLocalItemData(itemPBData)
    if nil == itemPBData then
        logError("[BagModel] item PB Data got nil")
        return nil
    end

    return Data.BagApi:CreateSvrItemData(itemPBData)
end


-- 返回带品质色的物品名
function BagModel:GetItemNameText(itemId)
    local l_itemName = ""
    local l_itemRow = TableUtil.GetItemTable().GetRowByItemID(itemId)
    if l_itemRow then
        if l_itemRow.ItemQuality ~= 0 then
            l_itemName = GetColorText(l_itemRow.ItemName, RoQuality.GetColorTag(l_itemRow.ItemQuality))
        else
            l_itemName = l_itemRow.ItemName
        end
    end
    return l_itemName
end

-- 获取期限道具倒计时
---@param itemData ItemData
function BagModel:GetRemainingTimeFormat(itemData)
    if nil == itemData then
        return nil
    end

    local l_remainingTime = itemData:GetRemainingTime()
    if l_remainingTime <= 0 then
        return Lang("TimeOut")
    else
        local l_ret = Common.TimeMgr.GetCountDownDayTimeTable(l_remainingTime)
        local dayStr = Lang("TIME_DAY", l_ret.day)
        local hourStr = Lang("TIME_HOUR", l_ret.hour)
        local minStr = Lang("TIME_MINUTE", l_ret.min)
        if l_ret.day > 0 then
            return Lang("TASK_LAST_TIME", StringEx.Format("{0}{1}{2}", dayStr, hourStr, minStr))
        elseif l_ret.hour > 0 then
            return Lang("TASK_LAST_TIME", StringEx.Format("{0}{1}", hourStr, minStr))
        else
            return Lang("TASK_LAST_TIME", minStr)
        end
    end
end

--lua custom scripts end
return BagModel