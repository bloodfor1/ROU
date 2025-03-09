require "Data/Model/BagApi"

---@module ModuleMgr.MultiTalentEquipMgr
module("ModuleMgr.MultiTalentEquipMgr", package.seeall)

local luaBaseType = GameEnum.ELuaBaseType
local C_EMPTY_UID = 0
local itemDataFuncMgr = MgrProxy:GetItemDataFuncUtil()
local commonDataProcessor = Common.CommonMsgProcessor.new()
local C_BIT_16 = 65536

--当前的装备页
_currentPage = 1
--所有的天赋页的名字
---@type string[]
_allEquipTalentNames = {}
--所有的装备数据
---@type table<number, table<number, string>>
_allEquips = { [1] = {} }
--红点相关的标记
MultiTalents_EquipMultiRedSign = "MultiTalents_EquipMultiRedSign"

function OnInit()
    local gameEventMgr = MgrMgr:GetMgr("GameEventMgr")
    gameEventMgr.Register(gameEventMgr.OnPlayerDataSync, _syncAllNames)
    MgrProxy:GetMultiTalentMgr().OnOpenMultiTalentFunc = _onAddMultiEquipTalent
    ---@type CommonBroadcastData
    local singleParam = {
        ModuleEnum = CommondataType.kCDT_EQUIP_PAGE,
        Callback = _onMultiEquipTalentUpdate,
    }

    local pageParam = {
        ModuleEnum = CommondataType.kCDT_NORMAL,
        DetailDataEnum = CommondataId.kCDT_HAS_EQUIP_PAGE,
        Callback = _onPageInit,
    }

    local curPageParam = {
        ModuleEnum = CommondataType.kCDT_NORMAL,
        DetailDataEnum = CommondataId.kCDT_CUR_EQUIP_PAGE,
        Callback = _onCurrentPageSet,
    }

    local paramList = { singleParam, pageParam, curPageParam }
    commonDataProcessor:Init(paramList)
end

function _onAddMultiEquipTalent()
    table.insert(_allEquips, {})
end

--- value 是int64
function _onCurrentPageSet(id, value)
    _currentPage = tonumber(value) + 1
end

--- 这里会有一个时序未知的问题，要避免掉把数据刷掉
function _onPageInit(id, value)
    for i = 1, tonumber(value) do
        if nil == _allEquips[i] then
            _allEquips[i] = {}
        end
    end
end

---@param id number @前16位是页，后16位是槽位
---@param value int64 @道具UID
function _onMultiEquipTalentUpdate(id, value)
    local cppPage, slot = _splitInt32(id)
    local luaPage = cppPage + 1
    -- logError(tostring(luaPage) .. " " .. tostring(slot) .. " " .. tostring(value))
    if nil == _allEquips[luaPage] then
        _allEquips[luaPage] = {}
    end

    _allEquips[luaPage][slot] = value
end

--- 这个方法是有时序的，一开始一定会有这个方法
---@param roleAllInfo RoleAllInfo
function _syncAllNames(roleAllInfo)
    _allEquipTalentNames = {}
    for i = 1, #roleAllInfo.equips.equip_page do
        local singleName = roleAllInfo.equips.equip_page[i].page_name
        if "" == singleName or nil == singleName then
            singleName = _getDefaultPageNameByIdx(i)
        end

        _allEquipTalentNames[i] = singleName
    end
end

---@return number, number
function _splitInt32(value)
    local leftHalf = math.floor(value / C_BIT_16)
    local rightHalf = math.fmod(value, C_BIT_16)
    return leftHalf, rightHalf
end

--- 一开始如果没有起名字服务器是不会下发名字的，所以这个时候要创建一个默认的名字
function _getDefaultPageNameByIdx(idx)
    if luaBaseType.Number ~= type(idx) then
        return nil
    end

    local systemID = MgrMgr:GetMgr("OpenSystemMgr").eSystemId.EquipMultiTalent
    local l_multiTalentsTableInfos = MgrMgr:GetMgr("MultiTalentMgr").GetMultiTableDataBySystemId(systemID)
    local l_tableInfo = l_multiTalentsTableInfos[idx]
    if nil == l_tableInfo then
        logError("多天赋表里没有取到这条数据，functionId：" .. tostring(systemID) .. " index:" .. tostring(idx))
        return ""
    end

    return Lang(l_tableInfo.Name)
end

--得到当前的装备页
function GetCurrentPage()
    return _currentPage
end

--设置当前的装备页，从1开始
function SetCurrentPage(page)
    if page <= 0 then
        return
    end

    _currentPage = page
end

--切换天赋做了一个特殊处理
--当将要切换的天赋里的装备不存在时，修改一些数据
function WillChangeEquipMultiTalent(page)
    if luaBaseType.Number ~= type(page) then
        logError("[MultiTalentEquipMgr] invalid page idx: " .. tostring(page))
        return
    end

    if 0 >= page or page > #_allEquips then
        logError("[MultiTalentEquipMgr] invalid page idx: " .. tostring(page))
        return
    end

    local l_targetPageEquips = _allEquips[page]
    for idx, uid in pairs(l_targetPageEquips) do
        if C_EMPTY_UID ~= uid then
            local item = _getItemByUID(uid)
            if nil == item then
                l_targetPageEquips[idx] = nil
            end
        end
    end
end

--- 总页数更新
function _onPageCountUpdate(pageCount)
    if luaBaseType.Number ~= type(pageCount) then
        logError("[MultiTalentEquipMgr] invalid page count")
        return
    end

    local diffValue = pageCount - #_allEquips
    if 0 < diffValue then
        for i = 1, diffValue do
            table.insert(_allEquips, {})
        end
    elseif 0 > diffValue then
        for i = #_allEquips, pageCount, -1 do
            _allEquips[i] = nil
        end
    end
end

--- 根据UID获取单个装备
---@param uid string
---@return ItemData
function _getItemByUID(uid)
    if nil == uid then
        return nil
    end

    local types = {
        GameEnum.EBagContainerType.Equip,
        GameEnum.EBagContainerType.Bag,
    }

    ---@type FiltrateCond
    local condition = {
        Cond = itemDataFuncMgr.IsItemUID,
        Param = uid
    }

    local conditions = { condition }
    local ret = Data.BagApi:GetItemsByTypesAndConds(types, conditions)
    if 1 < #ret then
        logError("[MultiTalentEquipMgr] invalid item count: " .. tostring(#ret))
        return nil
    end

    return ret[1]
end

--- 取天赋名字
function _getPageNameByIdx(index)
    if luaBaseType.Number ~= type(index) then
        logError("[MultiTalentEquipMgr] invalid param")
        return nil
    end

    if index <= 0 then
        logError("传递的index有问题，index：" .. tostring(index))
        return nil
    end

    local l_name
    if index <= #_allEquipTalentNames then
        l_name = _allEquipTalentNames[index]
    end

    if string.ro_isEmpty(l_name) then
        local systemID = MgrMgr:GetMgr("OpenSystemMgr").eSystemId.EquipMultiTalent
        local l_multiTalentsTableInfos = MgrMgr:GetMgr("MultiTalentMgr").GetMultiTableDataBySystemId(systemID)
        local l_tableInfo = l_multiTalentsTableInfos[index]
        if l_tableInfo == nil then
            local sysID = MgrMgr:GetMgr("OpenSystemMgr").eSystemId.EquipMultiTalent
            logError("多天赋表里没有取到这条数据，functionId：" .. tostring(sysID) .. " index:" .. tostring(index))
            return nil
        end

        l_name = Lang(l_tableInfo.Name)
    end

    return l_name
end

--- 取天赋名字
function GetEquipTalentNameWithIndex(index)
    return _getPageNameByIdx(index)
end

--是否开启
function IsEquipTalentOpenWithIndex(index)
    if index <= 0 then
        logError("传递的index有问题：" .. tostring(index))
        return false
    end

    return #_allEquips >= index
end

--设置名字
function SetEquipTalentName(index, name)
    _allEquipTalentNames[index] = name
end

--装备是否在多天赋中
---@param itemData ItemData
function IsInMultiTalentEquip(itemData)
    if itemData == nil then
        return false, "", 0
    end

    local l_uid = itemData.UID
    local isInPlan, name, idx = _isUidInPlan(l_uid)
    return isInPlan, name, idx
end

--装备是否再多天赋中
---@return boolean, string, number
function IsInMultiTalentEquipWithUid(uid)
    return _isUidInPlan(uid)
end

---@return boolean, string, number
function _isUidInPlan(uid)
    if _allEquips == nil then
        return false, "", 0
    end

    for i = 1, #_allEquips do
        local equipPlan = _allEquips[i]
        for index, itemUid in pairs(equipPlan) do
            if int64.equals(itemUid, uid) then
                local l_name = _getPageNameByIdx(i)
                return true, l_name, i
            end
        end
    end

    return false, "", 0
end

--此功能的所有条件判断都移到表里配置，此处只返回1就可以了
function CheckBagRedSign()
    return 1
end

function HideBagRedSign()
    local sysID = MgrMgr:GetMgr("OpenSystemMgr").eSystemId.EquipMultiTalent
    if not MgrMgr:GetMgr("OpenSystemMgr").IsSystemOpen(sysID) then
        return
    end

    UserDataManager.SetDataFromLua(MultiTalents_EquipMultiRedSign, MPlayerSetting.PLAYER_SETTING_GROUP, MultiTalents_EquipMultiRedSign)
    MgrMgr:GetMgr("RedSignMgr").UpdateRedSign(eRedSignKey.EquipMultiTalentRedSign)
end

--得到这个id在双天赋中的所有uid
function _getAllEquipUidInMultiTalentWithId(id)
    local l_uids = {}
    if _allEquips == nil then
        return l_uids
    end

    for i = 1, #_allEquips do
        for n, equipData in pairs(_allEquips[i]) do
            if equipData.TID == id then
                table.insert(l_uids, equipData.UID)
            end
        end
    end

    return l_uids
end

---@return ItemData
function _getBagItemByUID(uid)
    if nil == uid then
        logError("[ItemMgr] uid got nil")
        return nil
    end

    local types = { GameEnum.EBagContainerType.Bag }
    local itemFuncUtil = MgrProxy:GetItemDataFuncUtil()
    ---@type FiltrateCond
    local condition = { Cond = itemFuncUtil.IsItemUID, Param = uid }
    local conditions = { condition }
    local ret = Data.BagApi:GetItemsByTypesAndConds(types, conditions)
    return ret[1]
end

--得到这个id在双天赋中的装备，在背包中的个数
function _getTalentEquipInBagCountWithid(id)
    local l_uids = _getAllEquipUidInMultiTalentWithId(id)
    local l_count = 0
    local l_propInfo
    for i = 1, #l_uids do
        l_propInfo = _getBagItemByUID(l_uids[i])
        if l_propInfo ~= nil then
            l_count = l_count + 1
        end
    end

    return l_count
end

function OnLogout()
    _currentPage = 1
    _allEquips = { [1] = {} }
    _allEquipTalentNames = {}
end

return ModuleMgr.MultiTalentEquipMgr