--this file is gen by script
--you can edit this file in custom part


--lua model
module("ModuleMgr.BeiluzCoreMgr", package.seeall)

l_eventDispatcher = EventDispatcher.new()

DataName = "BeiluzCoreData"

SIG_WHEEL_MAINTAIN_RES = "BeiluzCoreMgr.SIG_WHEEL_MAINTAIN_RES"
SIG_WHEEL_GREY_STATE_UPDATE = "BeiluzCoreMgr.SIG_WHEEL_GREY_STATE_UPDATE"
SIG_COMBINE_CANCEL_SELECT_ITEM = "BeiluzCoreMgr.SIG_COMBINE_CANCEL_SELECT_ITEM"
SIG_COMBINE_SELECT_ITEM = "BeiluzCoreMgr.SIG_COMBINE_SELECT_ITEM"
SIG_COMBINE_UPDATE_SELECTABLE = "BeiluzCoreMgr.SIG_COMBINE_UPDATE_SELECTABLE"
SIG_RESET_RESET_SUCCESS = "BeiluzCoreMgr.SIG_RESET_RESET_SUCCESS"
SIG_RESET_CHOOSE_SUCCESS = "BeiluzCoreMgr.SIG_RESET_CHOOSE_SUCCESS"
SIG_WHEEL_ON_CLICK_ICON = "BeiluzCoreMgr.SIG_WHEEL_ON_CLICK_ICON"
SIG_COMBINE_REFRESH_SLOTUI = "BeiluzCoreMgr.SIG_COMBINE_REFRESH_SLOTUI"
SIG_COMBINE_CLEAR_SHOW_ITEM = "BeiluzCoreMgr.SIG_COMBINE_CLEAR_SHOW_ITEM"
SIG_RESET_ATTR_CHANGE = "SIG_RESET_ATTR_CHANGE"

KEY_WHEEL_RESET_WARNING = "BeiluzCoreMgr.KEY_WHEEL_RESET_WARNING"
KEY_WHEEL_REPLACE_WARNING = "BeiluzCoreMgr.KEY_WHEEL_REPLACE_WARNING"
KEY_WHEEL_RESET_SWITCH_WARING = "BeiluzCoreMgr.KEY_WHEEL_RESET_SWITCH_WARING"

MAX_SLOT_COUNT = 3          -- 槽位个数
MAX_ATTR_COUNT = 2          -- 每个齿轮最大技能个数
MAX_COMBINE_MAT_SLOT_COUNT = 4

BEILUZCORE_QUALITY = {
    None = 0,       -- 无齿轮
    Normal = 1,
    Good = 2,
    Rare = 3,
    Perfect = 4,
}

C_BEILUZCORE_SKILL_COLOR_MAP = {
    [GameEnum.EBeiluzCoreSkillQuality.None] = RoColor.Tag.Green,
    [GameEnum.EBeiluzCoreSkillQuality.Blue] = RoColor.Tag.Blue,
    [GameEnum.EBeiluzCoreSkillQuality.Purple] = RoColor.Tag.Purple,
    [GameEnum.EBeiluzCoreSkillQuality.Gold] = RoColor.Tag.Yellow,
}

C_BEILUZCORE_SKILL_BG_COLOR_MAP = {
    [GameEnum.EBeiluzCoreSkillQuality.None] = "50BE6CFF",           -- 没有0品质，隐藏
    [GameEnum.EBeiluzCoreSkillQuality.Blue] = "4290e0FF",
    [GameEnum.EBeiluzCoreSkillQuality.Purple] = "ae4aedFF",
    [GameEnum.EBeiluzCoreSkillQuality.Gold] = "f3a83dFF",
}

BEILUZCORE_WHEEL_PATH = {
    [BEILUZCORE_QUALITY.None] = "Item_Collect_BeiLuZi_BuJian_Bai",
    [BEILUZCORE_QUALITY.Normal] = "Item_Collect_BeiLuZi_BuJian_Lv",
    [BEILUZCORE_QUALITY.Good] = "Item_Collect_BeiLuZi_BuJian_Lan",
    [BEILUZCORE_QUALITY.Rare] = "Item_Collect_BeiLuZi_Bujian_Zi",
    [BEILUZCORE_QUALITY.Perfect] = "Item_Collect_BeiLuZi_BuJian_Jin",
}

BEILUZCORE_EFFECT_PATH = {
    [BEILUZCORE_QUALITY.Normal] = "FX_ui_blzhx_cl4",
    [BEILUZCORE_QUALITY.Good] = "FX_ui_blzhx_cl3",
    [BEILUZCORE_QUALITY.Rare] = "FX_ui_blzhx_cl",
    [BEILUZCORE_QUALITY.Perfect] = "FX_ui_blzhx_cl2",
}

BEILUZCORE_OVER_LOAD_IMG = {
    default = "UI_CommonIcon_beiluzi0.png",
    [1] = "UI_CommonIcon_beiluzi1.png",       -- 对应wheelEffect表ID
    [2] = "UI_CommonIcon_beiluzi2.png",
    [3] = "UI_CommonIcon_beiluzi3.png",
    [4] = "UI_CommonIcon_beiluzi4.png"
}

BEILUZCORE_EFFECT_STATE = {
    IDLE = 1,           -- 自转时
    Opening = 2,        -- 打开过程中
    Opened = 3,         -- 打开
}

BEILUZCORE_MODEL_STATE = {
    Open = 1,
    Close = 2
}

--齿轮TID列表，同一TID的齿轮属于同一类
BEILUZCORE_TYPE_ITEM_IDS = {
    [BEILUZCORE_QUALITY.None] = 0,            --所有类型
    [BEILUZCORE_QUALITY.Normal] = 3024022,
    [BEILUZCORE_QUALITY.Good] = 3024023,
    [BEILUZCORE_QUALITY.Rare] = 3024024,
    [BEILUZCORE_QUALITY.Perfect] = 3024025,
}
-- 打开齿轮背包后的操作
BEILUZCORE_OPEN_FUNC = {
    Equip = 1,      -- 镶嵌
    Maintain = 2    -- 保养
}

BEILUZCORE_NAME_COLOR = {
    [BEILUZCORE_QUALITY.Normal] = "4db952",
    [BEILUZCORE_QUALITY.Good] = "4290e0",
    [BEILUZCORE_QUALITY.Rare] = "ae4aed",
    [BEILUZCORE_QUALITY.Perfect] = "f3a83d",
}

ECombineType = {
    Common = 2,     -- 普通合成
    Double = 4,     -- 双技能合成
}

EOperationType = {
    Combine = 1,        -- 合成
    Reset = 2,          -- 重置
    Maintain = 3,       -- 保养(目前无用)
}

BEILUZCORE_ATTRDESC_NORMAL_COLOR = "667db1"

Cache_CORE_UIDSTR = nil     -- 从背包界面齿轮进入重置、合成界面时，要选中这个齿轮，这里缓存该齿轮。每次使用后要清空。

BEILUZCORE_GET_WAY_ID = 3024024     -- 获取途径ID（临时）

BEILUZCORE_TASK_ID = {
    6000270,
    6000272,
    6000274
}

--- GameEnum当中有一个复制过去的枚举EGearState，如果产生修改需要连同那个一起改了
---@class E_ACTIVE_STATE
E_ACTIVE_STATE = {
    Unused = 1,     -- 未使用过
    NoLife = 2,     -- 使用过但寿命耗尽
    InUse = 3,      -- 使用过且寿命未耗尽
}

-- 齿轮镶嵌界面数据
g_equippedWeight = 0
g_fullEquipped = false      -- 所有已解锁槽位都镶嵌了贝鲁兹
g_equippedCoreList = {}
-- 齿轮合成数据
g_selectedList = {}
g_newCoreList = {}      -- "新"生成的核心列表
g_combineWheelCost = false  -- 用于判断是否是合成操作
g_combineSlotCount = ECombineType.Common

local l_curWaitMessage = nil

--lua model end

--lua custom scripts

function OnEnterScene()
    if not StageMgr:CurStage():IsStaticStage(StageMgr:CurStage()) then
        NotifyZeroLifeIfNeed()
    end
end

function OnLogout()
    l_curWaitMessage = nil
    g_fullEquipped = false
    g_newCoreList = {}
    g_selectedList = {}
    g_equippedWeight = 0
    g_equippedCoreList = {}
end

---@param reconnectData ReconectSync
function OnReconnected(reconnectData)
    l_curWaitMessage = nil
    local effectID = GetCurAppearanceEffectID()
    MPlayerInfo.BeiluzEffectID = effectID
    local entity = MEntityMgr:GetEntity(MPlayerInfo.UID)
    if entity~= nil and not entity:Equals(nil) and entity.AttrComp and not entity.AttrComp:Equals(nil) then
        entity.AttrComp:SetBeiLuZi(effectID)
    end
end

function OnInit()
    local gameEventMgr = MgrMgr:GetMgr("GameEventMgr")
    gameEventMgr.Register(gameEventMgr.OnBagSync, _onBagSync)
    --gameEventMgr.Register(gameEventMgr.OnBagUpdate, _onBagItemChange)
end

function _onBagSync()
    RefreshEquippedCoreList()
    g_fullEquipped = IsFullEquipped()
end

function GetItemMaxAttrQuality(data)
    local skillIDs = data:GetAttrsByType(GameEnum.EItemAttrModuleType.BelluzGear)
    local maxQuality = 0
    if skillIDs[1] then
        local wheelSkillCfg = TableUtil.GetWheelSkillTable().GetRowById(skillIDs[1].TableID)
        if not wheelSkillCfg then return 1,0 end
        maxQuality = wheelSkillCfg.SkillQuality
    end
    if skillIDs[2] then
        local wheelSkillCfg = TableUtil.GetWheelSkillTable().GetRowById(skillIDs[2].TableID)
        if not wheelSkillCfg then return 1,0 end
        local skill2Quality = wheelSkillCfg.SkillQuality
        if skill2Quality > maxQuality then
            maxQuality = skill2Quality
        end
    end
    return maxQuality,#skillIDs
end

---@return E_ACTIVE_STATE
function GetActiveState(data)
    if data.EffectiveTime == 0 then
        return E_ACTIVE_STATE.Unused
    end
    local remainLife = data.EffectiveTime - Common.TimeMgr.GetNowTimestamp()
    if remainLife > 0 then
        return E_ACTIVE_STATE.InUse
    else
        return E_ACTIVE_STATE.NoLife
    end
end

function IsWheelCanEquip(data)
    if g_fullEquipped then return false end
    return g_equippedWeight + data.Weight <= maxWeight
end

-- 所有已解锁槽位都镶嵌了贝鲁兹
function IsFullEquipped()
    for i=1, MAX_SLOT_COUNT do
        if IsSlotUnlock(i) and not g_equippedCoreList[i] then
            return false
        end
    end
    return true
end

-- 返回重量和是否是极品负重
function GetWeight(data)
    return data.Weight,lowWeightConfig[data.TID][data.Weight] ~= nil
end

-- 镶嵌界面排序规则：寿命（可用>寿命耗尽>未用过）> 可镶嵌 > 品质 > 极品负重 > 双技能 > 技能品质
function SortByEquipPanelRule(a,b)
    local aLifeState = GetActiveState(a)
    local bLifeState = GetActiveState(b)
    if aLifeState ~= bLifeState then
        return aLifeState > bLifeState
    else
        aCanEquip = IsWheelCanEquip(a)
        bCanEquip = IsWheelCanEquip(b)
        if aCanEquip ~= bCanEquip then
            return aCanEquip
        elseif a.ItemConfig.ItemQuality ~= b.ItemConfig.ItemQuality then
            return a.ItemConfig.ItemQuality > b.ItemConfig.ItemQuality
        else
            local aLowWeight = lowWeightConfig[a.TID][a.Weight] ~= nil
            local bLowWeight = lowWeightConfig[b.TID][b.Weight] ~= nil
            if aLowWeight ~= bLowWeight then
                return aLowWeight == true
            else
                local aMaxQuality,aAttrCount = GetItemMaxAttrQuality(a)
                local bMaxQuality,bAttrCount = GetItemMaxAttrQuality(b)
                if aAttrCount ~= bAttrCount then
                    return bAttrCount < aAttrCount
                else
                    return bMaxQuality < aMaxQuality
                end
            end
        end
    end
end

-- 镶嵌界面排序规则：寿命（可用>寿命耗尽>未用过） > 品质 > 极品负重 > 双技能 > 技能品质
function SortByResetOrBagPanelRule(a,b)
    local aLifeState = GetActiveState(a)
    local bLifeState = GetActiveState(b)
    if aLifeState ~= bLifeState then
        return aLifeState > bLifeState
    elseif a.ItemConfig.ItemQuality ~= b.ItemConfig.ItemQuality then
        return a.ItemConfig.ItemQuality > b.ItemConfig.ItemQuality
    else
        local aLowWeight = lowWeightConfig[a.TID][a.Weight] ~= nil
        local bLowWeight = lowWeightConfig[b.TID][b.Weight] ~= nil
        if aLowWeight ~= bLowWeight then
            return aLowWeight == true
        else
            local aMaxQuality,aAttrCount = GetItemMaxAttrQuality(a)
            local bMaxQuality,bAttrCount = GetItemMaxAttrQuality(b)
            if aAttrCount ~= bAttrCount then
                return bAttrCount < aAttrCount
            else
                return bMaxQuality < aMaxQuality
            end
        end
    end
end

-- 镶嵌界面排序规则：新 > 寿命（可用>寿命耗尽>未用过） > 品质 > 双技能 > 负重(高的在前) > 技能品质
function SortByCombinePanelRule(a,b)
    local newA = (g_newCoreList[a.UID]~=nil)
    local newB = (g_newCoreList[b.UID]~=nil)
    if newA ~= newB then
        return newA
    else
        local aLifeState = GetActiveState(a)
        local bLifeState = GetActiveState(b)
        if aLifeState ~= bLifeState then
            return aLifeState > bLifeState
        elseif a.ItemConfig.ItemQuality ~= b.ItemConfig.ItemQuality then
            return a.ItemConfig.ItemQuality > b.ItemConfig.ItemQuality
        else
            local aMaxQuality,aAttrCount = GetItemMaxAttrQuality(a)
            local bMaxQuality,bAttrCount = GetItemMaxAttrQuality(b)
            if aAttrCount ~= bAttrCount then
                return bAttrCount < aAttrCount
            elseif a.Weight ~= b.Weight then
                return a.Weight > b.Weight
            else
                return bMaxQuality < aMaxQuality
            end
        end
    end
end

function GetBagCoreListByTID(TID)
    if TID == 0 then
        local types = { GameEnum.EBagContainerType.Bag }
        local condition = { Cond = MgrProxy:GetItemDataFuncUtil().ItemMatchesTypes, Param = { GameEnum.EItemType.BelluzGear } }
        local conditions = { condition }
        return Data.BagApi:GetItemsByTypesAndConds(types,conditions)
    end

    local types = { GameEnum.EBagContainerType.Bag }
    local condition = { Cond = MgrProxy:GetItemDataFuncUtil().ItemMatchesTid, Param = TID }
    local conditions = { condition }
    return Data.BagApi:GetItemsByTypesAndConds(types,conditions)
end

function GetSortedBagCoreListByTID(TID,SortFunc)
    local data = GetBagCoreListByTID(TID)
    table.sort(data,SortFunc)
    return data
end

-- 根据品质排序
function GetSortedEquippedCoreByTID(TID,SortFunc)
    local data = GetEquippedCoreByTID(TID)
    table.sort(data,SortFunc)
    return data
end

function GetSortedAllCoreByTID(TID,SortFunc)
    local data = GetAllCoreByTID(TID)
    table.sort(data,SortFunc)
    return data
end

function RefreshEquippedCoreList()
    local type = GameEnum.EBagContainerType.BeiluzCore
    local weight = 0
    local slotWheel1 = Data.BagApi:GetItemByTypeSlot(type,1)
    local slotWheel2 = Data.BagApi:GetItemByTypeSlot(type,2)
    local slotWheel3 = Data.BagApi:GetItemByTypeSlot(type,3)
    if slotWheel1 then
        weight = weight + slotWheel1.Weight
    end
    if slotWheel2 then
        weight = weight + slotWheel2.Weight
    end
    if slotWheel3 then
        weight = weight + slotWheel3.Weight
    end
    g_equippedWeight = weight
    local result = {
        [1] = slotWheel1,
        [2] = slotWheel2,
        [3] = slotWheel3,
    }
    g_equippedCoreList = result
    l_eventDispatcher:Dispatch(SIG_WHEEL_GREY_STATE_UPDATE)
end

function GetEquippedCoreByTID(TID)
    local result = {}
    RefreshEquippedCoreList()
    for i = 1,MAX_SLOT_COUNT do
        if TID == 0 then
            if g_equippedCoreList[i] then
                table.insert(result,g_equippedCoreList[i])
            end
        else
            if g_equippedCoreList[i] and g_equippedCoreList[i].TID == TID then
                table.insert(result,g_equippedCoreList[i])
            end
        end
    end
    return result
end

-- 获取指定类型的所有齿轮（背包和已镶嵌）
function GetAllCoreByTID(TID)
    local result = GetBagCoreListByTID(TID)
    table.ro_insertRange(result,GetEquippedCoreByTID(TID))
    return result
end

-- 返回列表里的双技能齿轮
function FilterDoubleAttrCore(coreList)
    local result = {}
    for _,v in ipairs(coreList) do
        local skillIDs = v:GetAttrsByType(GameEnum.EItemAttrModuleType.BelluzGear)
        if #skillIDs > 1 then
            table.insert(result,v)
        end
    end
    return result
end

-- 单位：秒
function GetCoreRemainTimeInSeconds(itemData)
    local specialRemainTime = _getCoreSpecialRemainTime(itemData)
    if specialRemainTime >= 0 then
        return specialRemainTime * dayToSeconds
    end
    local curTime = Common.TimeMgr.GetNowTimestamp()
    local remainTime = itemData.EffectiveTime - curTime
    if remainTime < 0 then
        remainTime = 0
    end
    return remainTime
end

-- 剩余时间，天为单位，去尾
function GetCoreRemainTimeInDay(itemData)
    local specialRemainTime = _getCoreSpecialRemainTime(itemData)
    if specialRemainTime >= 0 then
        return specialRemainTime
    end
    local curTime = Common.TimeMgr.GetNowTimestamp()
    local remainTime = itemData.EffectiveTime - curTime
    if remainTime < 0 then
        remainTime = 0
    end
    return math.floor(remainTime/dayToSeconds)
end

function _getCoreSpecialRemainTime(itemData)
    if itemData.EffectiveTime == 0 then
        if itemData.WheelAttrTID ~= 0 then
            local wheelAttrCfg = TableUtil.GetWheelAttrTable().GetRowById(itemData.WheelAttrTID)
            if wheelAttrCfg then
                return wheelAttrCfg.Life
            end
        else
            return 0
        end
    end
    return -1
end

-- 寿命上限
function GetMaxLifeInDay(TID)

    local result = maxLife[TID]
    if result == nil then
        logError("没找到齿轮最大寿命配置 ItemID:"..TID)
        return
    end

    return result
end

function GetMaxLifeInSeconds(TID)

    local result = maxLife[TID]
    if result == nil then
        logError("没找到齿轮最大寿命配置 ItemID:"..TID)
        return
    end

    return result * dayToSeconds
end

-- 获取齿轮保养一次增加多少寿命 单位：天
function GetAddLifeOnceInDay(ItemData)

    local lubricant = GetLubricantID(ItemData.TID)

    local addLife = 0
    if addLifeConfig[lubricant.id] then
        addLife = addLifeConfig[lubricant.id]
    else
        logError("没找到润滑剂增加寿命配置")
    end
    return addLife
end

function GetAddLifeOnceInSeconds(ItemData)
    return GetAddLifeOnceInDay(ItemData) * dayToSeconds
end

-- 获取保养齿轮消耗的道具
function GetLubricantID(TID)
    local result = {}
    if coreLubricantPair[TID] then
        result = coreLubricantPair[TID]
    end
    return result
end

-- 是否是贝鲁兹镶嵌界面相关物品
function IsEquipRelativeMat(id)
    -- 目前只判断润滑剂
    for _,v in pairs(coreLubricantPair) do
        if v.id == id then
            return true
        end
    end
    return false
end

-- 合成界面：槽位是否为空
function IsCombineSelectListEmpty()
    for i = 1,g_combineSlotCount do
        if g_selectedList[i] ~= nil then
            return false,g_selectedList[i]
        end
    end
    return true
end

-- 返回职业的哈希表
function GetProIdHash(professionID, hashTable)
    if nil == hashTable then
        hashTable = {}
    end
    local config = TableUtil.GetProfessionTable().GetRowById(professionID, true)
    if nil == config then
        return
    end

    hashTable[config.Id] = 1
    GetProIdHash(config.ParentProfession, hashTable)
end

function CheckRedSign()
    return 1
end

-- 齿轮保养确认
function WheelMaintainConfirm(UID)
    local types = { GameEnum.EBagContainerType.Bag ,GameEnum.EBagContainerType.BeiluzCore}
    local condition = { Cond = MgrProxy:GetItemDataFuncUtil().IsItemUID, Param = UID }
    local conditions = { condition }
    local data = Data.BagApi:GetItemsByTypesAndConds(types,conditions)
    if data[1] then
        if data[1].EffectiveTime == 0 then     -- 寿命未开始计时
            local tipStr = StringEx.Format(Common.Utils.Lang("WHEEL_LIFE_INTERCEPT"))
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(tipStr)
            return
        end

        UIMgr:ActiveUI(UI.CtrlNames.BeiLuZiDialog,data[1])

    end
end

-- 登录和切场景时调用，如果镶嵌的核心寿命为0，则提示
function NotifyZeroLifeIfNeed()
    local equippedCore = GetEquippedCoreByTID(0)
    for _,v in ipairs(equippedCore) do
        if GetCoreRemainTimeInSeconds(v) <= 0 then
            local tipStr = StringEx.Format(Common.Utils.Lang("WHEEL_LIFE_ZERO_INVALID_WARNING"),v.ItemConfig.ItemName)
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(tipStr)
        end
    end
end

-- 检查槽位是否解锁，预留接口
function IsSlotUnlock(index)
    --return true
    ---[[
    local cfg = TableUtil.GetWheelSlotUnlock().GetRowBySlotId(index)
    if cfg then
        return MPlayerInfo.Lv >= cfg.OpenLevel
    end
    return false
    --]]
end

function GetUnlockLv(index)
    local cfg = TableUtil.GetWheelSlotUnlock().GetRowBySlotId(index)
    if cfg then
        return cfg.OpenLevel
    end
    logError("找不到槽位开启等级配置：index = "..index)
end

function GetColorNameByQuality(str,quality)
    local color = BEILUZCORE_NAME_COLOR[quality]
    if color then
        str = StringEx.Format("<color=#{0}>{1}</color>",color,str)
    end
    return str
end

function GetCommonTxt(str)
    return StringEx.Format("<color=#{0}>{1}</color>",BEILUZCORE_ATTRDESC_NORMAL_COLOR,str)
end

function ShowSkillDesc(itemData,index,position)
    if itemData then
        local skillIDs = itemData:GetAttrsByType(GameEnum.EItemAttrModuleType.BelluzGear)
        if skillIDs[index] then
            local l_position = position
            local skillData = {}
            skillData.type = 3
            skillData.id = skillIDs[index].AttrID
            local l_skillData = {
                openType = DataMgr:GetData("SkillData").OpenType.ShowSkillInfo,
                position = l_position,
                data = skillData,
                pivot = Vector2.New(0.5,1)
            }
            UIMgr:ActiveUI(UI.CtrlNames.SkillAttr, l_skillData)
        end
    end
end

function GetCurOverLoadImageName()
    local row = _getCurEquipLevelRow()
    if row then
        return BEILUZCORE_OVER_LOAD_IMG[row.EffectlId]
    else
        return BEILUZCORE_OVER_LOAD_IMG.default
    end
end

function GetCurAppearanceEffectID()
    local row =_getCurEquipLevelRow()
    if row then
        return row.EffectlId
    end
    return 0
end

-- 合成界面：获取第一个镶嵌了的槽位
function GetFirstEquippedSlotIndex()
    local index = -1
    for i=1,MAX_COMBINE_MAT_SLOT_COUNT do
        if g_selectedList[i] then
            index = i
            break
        end
    end
    return index
end

function _getCurEquipLevelRow()
    local equippedCore = GetEquippedCoreByTID(BEILUZCORE_QUALITY.None)
    table.sort(equippedCore,function(a,b)
        return a.ItemConfig.ItemQuality > b.ItemConfig.ItemQuality
    end)
    for i=TableUtil.GetWheelEffects().GetTableSize(),1,-1 do
        local row = TableUtil.GetWheelEffects().GetRow(i)
        local match = true
        for i=0,row.conditions.Length - 1 do
            if not equippedCore[i+1] or equippedCore[i+1].ItemConfig.ItemQuality < row.conditions[i] then
                match = false
                break
            end
        end
        if match then
            return row
        end
    end
    return nil
end

-- 返回是否需要引导和下一个引导任务ID
function NeedGuide()
    local needGuide = false
    local nextGuideID = 0
    local taskMgr = MgrMgr:GetMgr("TaskMgr")
    for _,v in ipairs(BEILUZCORE_TASK_ID) do
        local taskID = v
        local state = taskMgr.GetTaskStatusAndStep(taskID)
        if state == taskMgr.ETaskStatus.CanTake or state == taskMgr.ETaskStatus.Taked or state == taskMgr.ETaskStatus.CanFinish then
            nextGuideID = taskID
            needGuide = true
            break
        end
    end
    return needGuide,nextGuideID
end

-- 记录装备信息，用于进入界面时和最新装备信息比较
-- 用于策划需求：齿轮寿命为0到期自动卸下后，下次首次进入镶嵌界面跳出上浮提示“齿轮寿命为0已自动卸下”
function UpdateEquipInfo()
    for i = 1,MAX_SLOT_COUNT do
        local tempUID = 0
        if g_equippedCoreList[i] then
            tempUID = g_equippedCoreList[i].UID
        end
        UserDataManager.SetDataFromLua(StringEx.Format("WHEELSLOt{0}",i),MPlayerSetting.PLAYER_SETTING_GROUP,tostring(tempUID))
    end
end

function TipNoLifeWheelUnload()
    for i = 1,MAX_SLOT_COUNT do
        local tempUID = UserDataManager.GetStringDataOrDef(StringEx.Format("WHEELSLOt{0}",i),MPlayerSetting.PLAYER_SETTING_GROUP,"0")
        local curUID = "0"
        if g_equippedCoreList[i] then
            curUID = tostring(g_equippedCoreList[i].UID)
            if GetActiveState(g_equippedCoreList[i]) == E_ACTIVE_STATE.NoLife then
                tipStr = Common.Utils.Lang("C_INVALID_BAG_WEIGHT")      -- 背包负重满无法自动卸载时提示
                MgrMgr:GetMgr("TipsMgr").ShowNormalTips(tipStr)
            end
        end
        if tempUID ~= "0" and curUID == "0" then
            tipStr = Common.Utils.Lang("WHEEL_EQUIP_NOLIFE")
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(tipStr)
        end
        break
    end
    UpdateEquipInfo()
end

function OpenOperationPanelByType(type)
    if type == EOperationType.Combine then
        UIMgr:ActiveUI(UI.CtrlNames.BeiluzOperationContainer, { [UI.CtrlNames.BeiluzOperationContainer] = { opType = UI.HandlerNames.BeiluzCoreSynthesis } })
    elseif type == EOperationType.Reset then
        UIMgr:ActiveUI(UI.CtrlNames.BeiluzOperationContainer, { [UI.CtrlNames.BeiluzOperationContainer] = { opType = UI.HandlerNames.BeiluzCoreReset } })
    end
end

--- message begin
-- 保养
function reqMaintainCore(UID)
    if l_curWaitMessage then
        return
    end
    l_curWaitMessage = Network.Define.Rpc.MaintenanceWheelRpc
    local msgId = Network.Define.Rpc.MaintenanceWheelRpc
    ---@type MaintenanceWheelArg
    local sendInfo = GetProtoBufSendTable("MaintenanceWheelArg")
    sendInfo.uid = tostring(UID)
    Network.Handler.SendRpc(msgId, sendInfo)
end

-- 保养回调
function OnMaintainRes(msg)
    if l_curWaitMessage then
        l_curWaitMessage = nil
    end
    ---@type MaintenanceWheelRes
    local l_info = ParseProtoBufToTable("MaintenanceWheelRes", msg)
    local l_errorCode = l_info.result
    if 0 == l_errorCode then
        l_eventDispatcher:Dispatch(SIG_WHEEL_MAINTAIN_RES)
        return
    end
    MgrMgr:GetMgr("TipsMgr").ShowErrorCodeTips(l_errorCode)
end

-- 合成
function reqCombineCore(UIDList)
    if l_curWaitMessage then
        return
    end
    l_curWaitMessage = Network.Define.Rpc.CombineWheelRpc
    g_combineWheelCost = true
    local msgId = Network.Define.Rpc.CombineWheelRpc
    ---@type CompositeWheelsArg
    local sendInfo = GetProtoBufSendTable("CompositeWheelsArg")
    for _,v in ipairs(UIDList) do
        table.insert(sendInfo.uids,v)
    end
    Network.Handler.SendRpc(msgId, sendInfo)
end

-- 合成回调
function onCombineCoreRes(msg)
    if l_curWaitMessage then
        l_curWaitMessage = nil
    end
    ---@type CompositeWheelsArg
    local l_info = ParseProtoBufToTable("CompositeWheelsRes", msg)
    local l_errorCode = l_info.result
    if 0 == l_errorCode then
        return
    end
    g_combineWheelCost = false
    local l_str = Common.Functions.GetErrorCodeStr(l_errorCode)
    MgrMgr:GetMgr("TipsMgr").ShowNormalTips(l_str)
end

-- 请求重置
function reqResetCore(UID)
    if l_curWaitMessage then
        return
    end
    l_curWaitMessage = Network.Define.Rpc.WheelReset
    local msgId = Network.Define.Rpc.WheelReset
    ---@type ResetWheelArg
    local sendInfo = GetProtoBufSendTable("ResetWheelArg")
    sendInfo.uid = UID
    Network.Handler.SendRpc(msgId, sendInfo)
end

-- 请求重置回调
function onResetRes(msg)
    if l_curWaitMessage then
        l_curWaitMessage = nil
    end
    ---@type ResetWheelRes
    local l_info = ParseProtoBufToTable("ResetWheelRes", msg)
    local l_errorCode = l_info.result
    if 0 == l_errorCode then
        l_eventDispatcher:Dispatch(SIG_RESET_RESET_SUCCESS)
        return
    end
    local l_str = Common.Functions.GetErrorCodeStr(l_errorCode)
    MgrMgr:GetMgr("TipsMgr").ShowNormalTips(l_str)
end

-- 选中重置
function reqWheelChooseReset(UID)
    if l_curWaitMessage then
        return
    end
    l_curWaitMessage = Network.Define.Rpc.WheelChooseReset
    local msgId = Network.Define.Rpc.WheelChooseReset
    ---@type ChooseWheelResetSkillArg
    local sendInfo = GetProtoBufSendTable("ChooseWheelResetSkillArg")
    sendInfo.uid = UID
    Network.Handler.SendRpc(msgId, sendInfo)
end

-- 选中重置回调
function onChooseResetRes(msg)
    if l_curWaitMessage then
        l_curWaitMessage = nil
    end
    ---@type ChooseWheelResetSkillRes
    local l_info = ParseProtoBufToTable("ChooseWheelResetSkillRes", msg)
    local l_errorCode = l_info.result
    if 0 == l_errorCode then
        l_eventDispatcher:Dispatch(SIG_RESET_CHOOSE_SUCCESS)
        return
    end
    local l_str = Common.Functions.GetErrorCodeStr(l_errorCode)
    MgrMgr:GetMgr("TipsMgr").ShowNormalTips(l_str)
end

--- message end

--lua custom scripts end
return ModuleMgr.BeiluzCoreMgr