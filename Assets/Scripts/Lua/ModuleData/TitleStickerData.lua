-- 称号和贴纸数据
---@module ModuleData.TitleStickerData
module("ModuleData.TitleStickerData", package.seeall)

-- 贴纸栏位个数
STICKER_GRID_NUM = 5
-- 贴纸最大长度
MAX_STICKER_LENGTH = 5


EStickerStatus = {
    Close = 0,        -- 未开启
    CanGet = 1,       -- 可获取
    Open = 2,         -- 开启状态
}

-- 称号数据
titleInfos = {}
-- 称号的分类信息
titleIndexInfos = {}

-- 贴纸数据
stickerInfos = {}
-- 贴纸栏位信息
stickerGridInfos = {}

-- 当前激活的称号
ActiveTitleId = 0

-- 称号显示隐藏
IsTitleShown = true

-- 缓存新获得的称号
newGetTitleIds = {}

---@type TitleStickerMgr
titleStickerMgr = MgrMgr:GetMgr("TitleStickerMgr")


-- 初始化
function Init( ... )
    ResetData()
end

-- Logout重置动态数据
function Logout( ... )
    ResetData()
end


-- 重置数据状态
function ResetData()
    ActiveTitleId = 0

    newGetTitleIds = {}

    -- 初始化称号数据
    titleInfos = {}
    for _, titleRow in pairs(TableUtil.GetTitleTable().GetTable()) do
        local l_itemRow = TableUtil.GetItemTable().GetRowByItemID(titleRow.TitleID)
        if l_itemRow then

            titleInfos[titleRow.TitleID] = {
                titleId = titleRow.TitleID,
                isOwned = IsTitleOwned(titleRow.TitleID),                           -- 是否已拥有
                itemTableInfo = l_itemRow,                 -- 每个称号对应一个item数据
                titleTableInfo = titleRow,
            }

            -- 添加贴纸信息
            if titleRow.StickersID ~= 0 then
                local l_stickerRow = TableUtil.GetStickersTable().GetRowByStickersID(titleRow.StickersID)
                if l_stickerRow then
                    stickerInfos[titleRow.StickersID] = {
                        stickerId = l_stickerRow.StickersID,
                        titleId = titleRow.TitleID,            -- 所属的称号id
                        isOwned = false,                       -- 是否已拥有
                        gridIndex = 0,                         -- 所在栏位序号
                        tableInfo = l_stickerRow,                -- 表数据
                    }
                end
            end
        else
            logError(StringEx.Format("称号({0})没有对应的item数据！！！！", titleRow.TitleID))
        end
    end
    -- 初始化分类信息
    titleIndexInfos = {}
    for _, titleIndexRow in pairs(TableUtil.GetTitleIndexTable().GetTable()) do
        table.insert(titleIndexInfos,  {index = titleIndexRow.ID, tableInfo = titleIndexRow})
    end
    -- 分类排序
    table.sort(titleIndexInfos, function (a, b)
        return a.tableInfo.SortID < b.tableInfo.SortID
    end)

    -- 获取栏位长度
    local l_getLengthFunc = function(self)
        if self.stickerId ~= 0 then
            local l_stickerRow = TableUtil.GetStickersTable().GetRowByStickersID(self.stickerId)
            if l_stickerRow then
                return l_stickerRow.Length
            end
        end
        return 1
    end

    -- 初始化贴纸栏位信息
    stickerGridInfos = {}
    for _, stickerColumnRow in pairs(TableUtil.GetStickersColumnTable().GetTable()) do
        stickerGridInfos[stickerColumnRow.ID] = {
            index = stickerColumnRow.ID,          -- 序号
            tableInfo = stickerColumnRow,
            stickerId = 0,                        -- 该位置的贴纸id
            status = EStickerStatus.Close,        -- 栏位状态，EStickerStatus
            GetLengthFunc = l_getLengthFunc
        }
    end
end


------------------------------ 称号 -----------------------------------------------

function RefreshOwnInfo()
    for _, info in pairs(titleInfos) do
        info.isOwned = IsTitleOwned(info.titleId)
    end
end


function IsTitleOwned(titleId)
    local l_isInTitleBag = MgrMgr:GetMgr("ItemContainerMgr").GetItemCountByContAndID(GameEnum.EBagContainerType.Title, titleId) > 0
    local l_isInTitleUsingBag = MgrMgr:GetMgr("ItemContainerMgr").GetItemCountByContAndID(GameEnum.EBagContainerType.TitleUsing, titleId) > 0
    return l_isInTitleBag or l_isInTitleUsingBag
end

function RefreshActiveTitleId()
    local l_items = Data.BagApi:GetItemsByTypesAndConds({ GameEnum.EBagContainerType.TitleUsing })
    ActiveTitleId = l_items[1] and l_items[1].TID or 0
end

function EnqueueNewTitleId(titleId)
    table.insert(newGetTitleIds, titleId)
end

function DequeueNewTitleId()
    local l_titleId = newGetTitleIds[1]
    if #newGetTitleIds > 0 then
        table.remove(newGetTitleIds, 1)
    end
    return l_titleId
end

-- 通过分类获取称号信息，index = 0表示获取所有数据
function GetTitleInfosByIndex(index)
    local l_titleInfos = {}
    for _, titleInfo in pairs(titleInfos) do
        if index == 0 or titleInfo.titleTableInfo.Index == index then
            table.insert(l_titleInfos, titleInfo)
        end
    end
    -- 称号排序
    -- 新获得的放在最前方，已解锁>未解锁，最后按排序id从小到大排列
    table.sort(l_titleInfos, function(a, b)
        local l_aNew = a.isNew and 0 or 1
        local l_bNew = b.isNew and 0 or 1
        local l_aOwned = a.isOwned and 0 or 1
        local l_bOwned = b.isOwned and 0 or 1
        if l_aNew ~= l_bNew then return l_aNew < l_bNew end
        if l_aOwned ~= l_bOwned then return l_aOwned < l_bOwned end
        return a.titleTableInfo.SortID < b.titleTableInfo.SortID
    end)
    return l_titleInfos
end

-- 获取称号的分类信息
function GetTitleIndexInfos()
    return titleIndexInfos
end

-- 去掉所有称号的新获取状态
function RemoveAllTitleNew()
    for _, titleInfo in pairs(titleInfos) do
        titleInfo.isNew = false
    end
end


-- 获取称号信息
function GetTitleInfoById(titleId)
    return titleInfos[titleId]
end


-- 获取当前已激活称号
function GetActiveTitle()
    return titleInfos[ActiveTitleId]
end

-- 设置称号数据
function SetTitleInfo(titleId, titleInfo)
    if not titleId then return end
    local l_titleInfo = titleInfos[titleId]
    if l_titleInfo then
        if titleInfo.isNew ~= nil then
            l_titleInfo.isNew = titleInfo.isNew
        end
    end
end

-- 称号是否已激活
function IsTitleActive(titleId)
    return titleId == ActiveTitleId
end


------------------------------ 贴纸 ------------------------------------------------

-- 获取贴纸对应的称号id
function GetStickerTitleId(stickerId)
    local l_titleId = 0
    if stickerInfos[stickerId] then
        l_titleId = stickerInfos[stickerId].titleId
    end
    return l_titleId
end


-- 设置贴纸数据
function SetStickerInfo(stickerId, stickerInfo)
    if not stickerId then return end
    local l_stickerInfo = stickerInfos[stickerId]
    if l_stickerInfo then
        if stickerInfo.isOwned ~= nil then
            l_stickerInfo.isOwned = stickerInfo.isOwned
        end
        if stickerInfo.gridIndex ~= nil then
            l_stickerInfo.gridIndex = stickerInfo.gridIndex
        end
    end
end


-- 设置栏位信息
function SetStickerGridInfo(index, stickerGridInfo)
    if not index then return end
    local l_stickerGridInfo = stickerGridInfos[index]
    if l_stickerGridInfo then
        if stickerGridInfo.stickerId ~= nil then
            -- 更新贴纸栏位
            if l_stickerGridInfo.stickerId ~= 0 then
                if stickerInfos[l_stickerGridInfo.stickerId].gridIndex == index then
                    SetStickerInfo(l_stickerGridInfo.stickerId, {gridIndex = 0})
                end
            end
            SetStickerInfo(stickerGridInfo.stickerId, {gridIndex = l_stickerGridInfo.index})

            l_stickerGridInfo.stickerId = stickerGridInfo.stickerId
        end
        if stickerGridInfo.status ~= nil then
            l_stickerGridInfo.status = stickerGridInfo.status
        end
    end
end

-- 通过贴纸长度获取贴纸
function GetStickerInfosByLength(length)
    local l_infos = {}
    for _, stickerInfo in pairs(stickerInfos) do
        if stickerInfo.tableInfo.Length == length then
            table.insert(l_infos, stickerInfo)
        end
    end
    -- 进行排序
    table.sort(l_infos, function(a, b)
        return a.tableInfo.SortID < b.tableInfo.SortID
    end)
    return l_infos
end

-- 获取贴纸栏位信息
function GetStickerGridInfos()
    return stickerGridInfos
end

-- 通过贴纸id获取贴纸信息
function GetStickerInfoById(id)
    return stickerInfos[id]
end

return ModuleData.TitleStickerData