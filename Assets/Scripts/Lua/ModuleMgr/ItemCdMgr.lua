module("ModuleMgr.ItemCdMgr", package.seeall)

--暂时O(n)算法
--可扩充伪O(1)算法，性能有明显影响可加

--local var
local l_itemCds
local l_groupCds
local l_itemSCds = {}
local l_itemSGroupCds = {}
local l_groupIds = {}
local l_preSecTime --userdata,using string compare server


-----------base func

function OnInit()
    l_itemCds = {}
    l_groupCds = {}
    l_preSecTime = MServerTimeMgr.UtcSeconds
end

function OnUpdate()
    local gameEventMgr = MgrMgr:GetMgr("GameEventMgr")
    --run logic in the per one sec
    local l_nowSecond = MServerTimeMgr.UtcSeconds
    if l_preSecTime == l_nowSecond then
        --return
    end
    l_preSecTime = l_nowSecond
    local l_subSec = Time.deltaTime
    for k, v in pairs(l_itemCds) do
        l_itemCds[k] = v - l_subSec
        if l_itemCds[k] <= 0 then
            l_itemCds[k] = nil
            gameEventMgr.RaiseEvent(gameEventMgr.OnItemCdOver, k)
        end
    end
    for k, v in pairs(l_groupCds) do
        l_groupCds[k] = v - l_subSec
        if l_groupCds[k] <= 0 then
            l_groupCds[k] = nil
            gameEventMgr.RaiseEvent(gameEventMgr.OnItemGroupCdOver, k)
        end
    end
end

function OnUnInit()
    l_itemCds = nil
    l_groupCds = nil
    l_preSecTime = nil
end

function OnLogout()
    l_itemSCds = {}
    l_groupIds = {}
    l_itemSGroupCds = {}
end

-------read table func
function GetItemCdFromTable(itemId)
    if not l_itemSCds[itemId] then
        local l_itemFucRow = TableUtil.GetItemFunctionTable().GetRowByItemId(itemId)
        l_itemSCds[itemId] = l_itemFucRow and l_itemFucRow.ItemCD or 0
    end
    return l_itemSCds[itemId]
end

function GetGroupIdFromTable(itemId)
    if not l_groupIds[itemId] then
        local l_itemFucRow = TableUtil.GetItemFunctionTable().GetRowByItemId(itemId, true)
        l_groupIds[itemId] = l_itemFucRow and l_itemFucRow.ItemCDGroup or 0
    end
    return l_groupIds[itemId]
end

function GetGroupCdFromTable(itemId)
    local l_groupCdId = GetGroupIdFromTable(itemId)
    if l_groupCdId == 0 then
        return 0
    end
    if not l_itemSGroupCds[l_groupCdId] then
        local l_itemGroupCdRow = TableUtil.GetItemGroupCDTable().GetRowByItemGroupId(l_groupCdId)
        l_itemSGroupCds[l_groupCdId] = l_itemGroupCdRow and l_itemGroupCdRow.ItemGroupCD or 0
    end
    return l_itemSGroupCds[l_groupCdId]
end

function GetCdFromTable(itemId)
    local l_gcd = GetGroupCdFromTable(itemId)
    local l_icd = GetItemCdFromTable(itemId)
    if l_gcd > l_icd then
        return l_gcd
    end
    return l_icd
end
-------logic func

-------add
function AddCd(itemId)
    local l_itemFucRow = TableUtil.GetItemFunctionTable().GetRowByItemId(itemId)
    if l_itemFucRow == nil then
        return
    end

    local l_itemCd = l_itemFucRow.ItemCD
    if l_itemCds[itemId] == nil then
        l_itemCds[itemId] = l_itemCd
    end
    local l_itemCdGroupId = l_itemFucRow.ItemCDGroup
    if l_itemCdGroupId == 0 then
        --only itemCd
        return
    end
    local l_itemGroupCdRow = TableUtil.GetItemGroupCDTable().GetRowByItemGroupId(l_itemCdGroupId)
    if l_itemGroupCdRow == nil then
        return
    end
    local l_groupCd = l_itemGroupCdRow.ItemGroupCD
    if l_groupCds[l_itemCdGroupId] == nil then
        l_groupCds[l_itemCdGroupId] = l_groupCd
    end
end

--- 获取配置CD
function GetItemTotalCd(itemId)
    local l_itemFucRow = TableUtil.GetItemFunctionTable().GetRowByItemId(itemId, true)
    if l_itemFucRow == nil then
        return 0
    end

    local l_itemCd = l_itemFucRow.ItemCD
    local l_itemCdGroupId = l_itemFucRow.ItemCDGroup
    if l_itemCdGroupId == 0 then
        return l_itemCd
    end

    local l_itemGroupCdRow = TableUtil.GetItemGroupCDTable().GetRowByItemGroupId(l_itemCdGroupId)
    if l_itemGroupCdRow == nil then
        return l_itemCd
    end

    local l_groupCd = l_itemGroupCdRow.ItemGroupCD
    return l_itemCd > l_groupCd and l_itemCd or l_groupCd
end

-------seek
function GetCd(itemId)
    --get max
    local l_itemCd = l_itemCds[itemId] or 0
    local l_groupCdId = GetGroupIdFromTable(itemId)
    local l_groupCd = l_groupCds[l_groupCdId] or 0
    if l_itemCd > l_groupCd then
        return l_itemCd
    end
    return l_groupCd
end

-----------------

return ModuleMgr.ItemCdMgr