---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by richardjiang.
--- DateTime: 2018/12/11 10:46
---
---@module ModuleMgr.StickerMgr
module("ModuleMgr.StickerMgr", package.seeall)
EventDispatcher = EventDispatcher.new()

StickerStatus = {
    close = 0, -- 未开启
    award = 1, -- 可领奖
    open = 2, -- 开启状态
}

g_stickerInfo = {
    ownStickers = {}, -- 开放的贴纸
    pasterInfo = {}, -- 装备贴纸信息
}

g_pasterGroupInfo = {}
g_itemBaseWidth = 80 -- 格子基础宽度
g_itemBaseChooseWidth = 94 -- 选框基础宽度
g_rewardFxId = MGlobalConfig:GetInt("NoticeRewardEffect")
g_maxGridCount = 5
g_gridGap = 10

EVENT_REFRESH_GRIDS = "EVENT_REFRESH_GRIDS" -- 刷新贴纸状态栏
EVENT_REFRESH_STICKS = "EVENT_REFRESH_STICKS" -- 刷新拥有的贴纸

function OnInit()
    Reset()
    --g_stickerInfo.pasterInfo = ProcessData(g_stickerInfo.pasterInfo)
    g_pasterGroupInfo = array.group(TableUtil.GetStickersTable().GetTable(), "Length")
    g_pasterAchievementInfo = nil
end

function OnUninit()
    Reset()
    g_pasterGroupInfo = {}
end

function OnLogout()
    Reset()
end

function Reset()
    g_stickerInfo = {
        ownStickers = {},
        pasterInfo = {},
    }
end

function OnSelectRoleNtf(info)
    g_stickerInfo = ProcessData(info.sticker_info)
end

--==============================--
--@Description:获取已经装备的贴纸
--@Date: 2018/12/12
--@Param: [args]
--@Return:
--==============================--
function GetEquipStickers()
    RefreshGridInfos()
    local ret = {}
    for i, v in ipairs(g_stickerInfo.pasterInfo) do
        if v.isReal then
            table.insert(ret, v)
        end
    end
    return ret
end

function ProcessData(stickerInfo)
    local ret = {
        pasterInfo = {},
        ownStickers = g_stickerInfo.ownStickers or {}
    }
    if stickerInfo.own_stickers then
        for i, v in ipairs(stickerInfo.own_stickers) do
            array.addUnique(ret.ownStickers, v.value)
        end
    end
    local sdata
    for i, v in ipairs(stickerInfo.grid) do
        if v.value and v.value > 0 then
            sdata = TableUtil.GetStickersTable().GetRowByStickersID(v.value)
            if not next(stickerInfo.grid_unlock_status[i]) then
                logError("贴纸RoleAllInfo数据 Grid和GridStatus 不一致")
            end
            if sdata then
                table.insert(ret.pasterInfo, {
                    id = v.value,
                    idx = i,
                    status = stickerInfo.grid_unlock_status[i] and stickerInfo.grid_unlock_status[i].value or StickerStatus.open,
                    length = sdata.Length,
                    isReal = true,
                    sortId = sdata.SortID,
                })
            else
                if not sdata then
                    logError("未找到贴纸静态数据 @韩艺鸣 ", v.id)
                end
            end
        else
            table.insert(ret.pasterInfo, {
                id = v.value or 0, -- id = - 1 补位数据
                idx = i,
                status = stickerInfo.grid_unlock_status[i] and stickerInfo.grid_unlock_status[i].value or StickerStatus.close,
                length = 1,
                isReal = true,
                sortId = -1,
            })
        end
    end
    RefreshGridInfos()
    return ret
end

function RefreshGridInfos()
    local len = 0
    local pasterInfo = g_stickerInfo.pasterInfo
    if pasterInfo then
        for i, v in ipairs(pasterInfo) do
            if v.id > 0 then
                len = len + v.length
                v.isReal = true
            else
                v.isReal = i > len
                if v.isReal then
                    len = len + v.length
                end
            end
        end
    end
end

function DropStick(id, pos)
    if not IsOpen(id) then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("STICKER_DROP_GRID_NOT_HAVE_STICKER"))
        return
    end
    if pos then
        local sdata = TableUtil.GetStickersTable().GetRowByStickersID(id)
        if not sdata then
            logError("未找到贴纸静态数据 @韩艺鸣 ", id)
            return
        end
        local length = sdata.Length
        local _candrop, err = CanDrop(id, pos, length)
        if err then
            --TODO
            local tips = ""
            if err == 1 then
                -- 格子未解锁
                tips = Lang("STICKER_DROP_GRID_UNLOCK", GetNeedTotalAchieve(pos))
            elseif err == 2 or err == 3 then
                -- 长度不足
                tips = Lang("STICKER_DROP_GRID_LENGTH_NOT_ENOUGH")
            end
            if not IsEmptyOrNil(tips) then
                MgrMgr:GetMgr("TipsMgr").ShowNormalTips(tips)
            end
        end
        if _candrop then
            DropPlace(sdata, pos, pos + length - 1)
            EventDispatcher:Dispatch(EVENT_REFRESH_GRIDS)
            EventDispatcher:Dispatch(EVENT_REFRESH_STICKS, true)
        end
    else
        local pasterInfo = g_stickerInfo.pasterInfo
        local isDrop = false
        for i, v in ipairs(pasterInfo) do
            if v.id == id then
                pasterInfo[i] = {
                    id = 0,
                    idx = i,
                    status = StickerStatus.open,
                    length = 1,
                    isReal = true,
                    sortId = -1,
                }
                isDrop = true
                break
            end
        end
        RefreshGridInfos()
        if isDrop then
            EventDispatcher:Dispatch(EVENT_REFRESH_GRIDS)
            EventDispatcher:Dispatch(EVENT_REFRESH_STICKS, true)
        end
    end
end

function DoubleClickSticker(id, isOn)
    if not IsOpen(id) then
        return
    end
    if isOn then
        -- 双击装上
        if not IsUse(id) then
            local canDrop, pos = FindProperDropPos(id)
            if canDrop then
                PlaceStick(id, pos)
            else
                MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("STICKER_GRID_OUT_OF_MEMORY"))
            end
        end
    else
        -- 双击卸下
        DropStick(id)
    end
end

function ConvertItemPos2GridPos(itemPos)
    local gridPos = 1
    local pasterInfo = g_stickerInfo.pasterInfo
    for i = 1, itemPos - 1 do
        if pasterInfo[i] then
            gridPos = gridPos + pasterInfo[i].length
        end
    end
    return gridPos
end

function FindProperDropPos(id)
    local ret = false
    local sdata = TableUtil.GetStickersTable().GetRowByStickersID(id)
    if not sdata then
        logError("未找到贴纸静态数据 @韩艺鸣 ", id)
        return ret
    end
    local pasterInfo = g_stickerInfo.pasterInfo
    local function _isEmpty(fromPos, endPos)
        local ret = true
        for i = fromPos, endPos do
            if not pasterInfo[i] or pasterInfo[i].id > 0 then
                ret = false
                break
            end
        end
        return ret
    end
    for i, v in ipairs(pasterInfo) do
        if CanPlace(id, i, sdata.Length) and _isEmpty(i, i + sdata.Length - 1) then
            ret = true
            return ret, i
        end
    end
    return false
end

function PlaceStick(id, pos)
    local pasterInfo = g_stickerInfo.pasterInfo
    local gridInfo = pasterInfo[pos]
    if not gridInfo then
        logError("PlaceStick invalid pos ", id, pos)
        return
    end
    local sdata = TableUtil.GetStickersTable().GetRowByStickersID(id)
    if not sdata then
        logError("未找到贴纸静态数据 @韩艺鸣 ", id)
        return
    end
    local length = sdata.Length
    local canPlace, err = CanPlace(id, pos, length)
    if err then
        --TODO
    end
    if canPlace then
        DropPlace(sdata, pos, pos + length - 1)
    end
    EventDispatcher:Dispatch(EVENT_REFRESH_GRIDS)
    EventDispatcher:Dispatch(EVENT_REFRESH_STICKS, true)
end

function DropPlace(sdata, fromPos, endPos)
    local pasterInfo = g_stickerInfo.pasterInfo
    local id = sdata.StickersID
    local sortId = sdata.SortID
    local originLength = 0
    local length = sdata.Length
    for i, v in ipairs(pasterInfo) do
        local gridFrom, gridTo = v.idx, v.idx + v.length - 1
        if (fromPos >= gridFrom and fromPos <= gridTo) or (endPos >= gridFrom and endPos <= gridTo)
                and v.status == StickerStatus.open then
            pasterInfo[i] = {
                id = 0,
                idx = i,
                status = StickerStatus.open,
                length = 1,
                isReal = true,
                sortId = -1,
            }
        end
        if v.id == id then
            originLength = v.length
            pasterInfo[i] = {
                id = 0,
                idx = i,
                status = StickerStatus.open,
                length = 1,
                isReal = true,
                sortId = -1,
            }
        end
    end
    pasterInfo[fromPos] = {
        id = id,
        idx = fromPos,
        status = StickerStatus.open,
        length = length,
        isReal = true,
        sortId = sortId,
    }

    RefreshGridInfos()
end

function CheckValidItemIdx(idx)
    return idx >= 1 and idx <= g_maxGridCount
end

function GetItemPosByGridIdx(pos)
    local pasterInfo = g_stickerInfo.pasterInfo
    local itemIdx = 0
    for i, v in ipairs(pasterInfo) do
        if pos >= v.length then
            itemIdx = itemIdx + 1
            pos = pos - v.length
            if pos <= 0 then
                break
            end
        else
            itemIdx = itemIdx + 1
            break
        end
    end
    return itemIdx
end

--==============================--
--@Description:能否放置
--@Date: 2018/12/18
--@Param: [args]
--@Return:
--==============================--
function CanPlace(id, pos, length)
    local ret = true
    local pasterInfo = g_stickerInfo.pasterInfo
    local gridInfo = pasterInfo[pos]
    if gridInfo then
        if not gridInfo.isReal then
            ret = false
            return ret, 0
        end

        if gridInfo.status ~= StickerStatus.open then
            ret = false
            return ret, 1
        end

        local leftPlace = g_maxGridCount - pos + 1
        if leftPlace < length then
            ret = false
            return ret, 2
        end

        for i = pos, pos + length - 1 do
            if not pasterInfo[i] or pasterInfo[i].status ~= StickerStatus.open or not pasterInfo[i].isReal then
                ret = false
                return ret, 3
            end
        end
    end
    return ret
end

function CanDrop(id, pos, length)
    local ret = true
    local pasterInfo = g_stickerInfo.pasterInfo
    local gridInfo = pasterInfo[pos]
    if gridInfo then
        if gridInfo.status ~= StickerStatus.open then
            ret = false
            return ret, 1
        end

        local leftPlace = g_maxGridCount - pos + 1
        if leftPlace < length then
            ret = false
            return ret, 2
        end

        for i = pos, pos + length - 1 do
            if not pasterInfo[i] or pasterInfo[i].status ~= StickerStatus.open then
                ret = false
                return ret, 3
            end
        end
    end
    return ret
end

function SaveStickersInGrid()
    local l_msgId = Network.Define.Rpc.SaveStickersInGrid
    ---@type SaveStickersInGridArg
    local l_sendInfo = GetProtoBufSendTable("SaveStickersInGridArg")
    local posToStickerId
    for i, v in ipairs(g_stickerInfo.pasterInfo) do
        if v.id > 0 then
            posToStickerId = l_sendInfo.pos_to_sticker_id:add()
            posToStickerId.pos = v.idx - 1
            posToStickerId.sticker_id = v.id
        end
    end
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

function OnSaveStickersInGrid(msg, sendArg)
    ---@type GridStateRes
    local info = ParseProtoBufToTable("GridStateRes", msg)
    if info.result ~= 0 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(info.result))
        return
    end
    g_stickerInfo = ProcessData(info)

end

--==============================--
--@Description:根据长度获取贴纸集合
--@Date: 2018/12/14
--@Param: [args]
--@Return:
--==============================--
function GetStickersByLength(length)
    return g_pasterGroupInfo[length] or {}
end

--==============================--
--@Description:根据stickerId获取成就数据
--@Date: 2018/12/14
--@Param: [args]
--@Return:
--==============================--
function GetAchieveSdataByStickerId(id)
    if not g_pasterAchievementInfo then
        g_pasterAchievementInfo = {}
        for i, v in ipairs(TableUtil.GetAchievementDetailTable().GetTable()) do
            if v.StickersID > 0 then
                g_pasterAchievementInfo[v.StickersID] = v
            end
        end
    end
    return g_pasterAchievementInfo[id]
end

function IsUse(id)
    if array.find(g_stickerInfo.pasterInfo, function(v)
        return v.id == id
    end) then
        return true
    else
        return false
    end
end

function IsOpen(id)
    return array.contains(g_stickerInfo.ownStickers, id)
end

function IsGridOpen(idx)
    local ret = false
    local gridInfo = g_stickerInfo.pasterInfo[idx]
    if gridInfo then
        ret = gridInfo.id > 0 or gridInfo.status == StickerStatus.open
    end
    return ret
end

function GetGridBuffText(idx)
    local ret = ""
    local sdata = TableUtil.GetStickersColumnTable().GetRowByID(idx)
    if sdata then
        local attrs = Common.Functions.VectorSequenceToTable(sdata.AddAttr)
        for i, v in ipairs(attrs) do
            local attr = { type = v[1], id = v[2], val = v[3] }
            if attr.type and attr.id and attr.val then
                ret = ret .. (i > 1 and '、' or '') .. MgrMgr:GetMgr("EquipMgr").GetAttrStrByData(attr)
            end
        end
    end
    return ret
end

function GetGridBuffTexts()
    local ret = {}
    local prefixs = {
        'PERSONAL_PLASTER_GRID_ONE',
        'PERSONAL_PLASTER_GRID_TWO',
        'PERSONAL_PLASTER_GRID_THREE',
        'PERSONAL_PLASTER_GRID_FOUR',
        'PERSONAL_PLASTER_GRID_FIVE',
    }
    local text
    for i = 1, g_maxGridCount do
        text = Lang(prefixs[i], GetGridBuffText(i) .. (i < g_maxGridCount and '\n' or ""))
        table.insert(ret, text)
    end
    return ret
end

function GetGridName(idx)
    local ret = ""
    local sdata = TableUtil.GetStickersColumnTable().GetRowByID(idx)
    if sdata then
        ret = sdata.StickersColumnName
    end
    return ret
end

function GetNeedTotalAchieve(idx)
    local ret = 0
    local sdata = TableUtil.GetStickersColumnTable().GetRowByID(idx)
    if sdata then
        ret = sdata.AchievementPoint
    end
    return ret
end


--region 协议
--==============================--
--@Description:贴纸变化通知
--@Date: 2018/12/15
--@Param: [args]
--@Return:
--==============================--
function OnOwnStickersNtf(info)
    g_stickerInfo.ownStickers = g_stickerInfo.ownStickers or {}
    for i, v in ipairs(info.stickers_id) do
        array.addUnique(g_stickerInfo.ownStickers, v.value)
        MgrMgr:GetMgr("NoticeMgr").AddSpecialItemTip(v.value, GameEnum.SpecialItemTipShowType.Sticker)
    end
    if #info.stickers_id > 0 then
        EventDispatcher:Dispatch(EVENT_REFRESH_GRIDS)
        EventDispatcher:Dispatch(EVENT_REFRESH_STICKS, true)
    end
end

--==============================--
--@Description:请求格子状态
--@Date: 2018/12/24
--@Param: [args]
--@Return:
--==============================--
function RequestGridState()
    local l_msgId = Network.Define.Rpc.RequestGridState
    ---@type GridStateArg
    local l_sendInfo = GetProtoBufSendTable("GridStateArg")
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

function OnRequestGridState(msg)
    ---@type GridStateRes
    local info = ParseProtoBufToTable("GridStateRes", msg)
    if info.result ~= 0 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(info.result))
        return
    end
    g_stickerInfo = ProcessData(info)
    EventDispatcher:Dispatch(EVENT_REFRESH_GRIDS)
end

--==============================--
--@Description:请求解锁格子
--@Date: 2018/12/24
--@Param: [args]
--@Return:
--==============================--
function RequestUnlockGrid(gridIdx)
    local l_msgId = Network.Define.Rpc.RequestUnlockGrid
    ---@type RequestUnlockGridArg
    local l_sendInfo = GetProtoBufSendTable("RequestUnlockGridArg")
    l_sendInfo.index = gridIdx - 1
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

function OnRequestUnlockGrid(msg, sendArg)
    ---@type GridStateRes
    local info = ParseProtoBufToTable("GridStateRes", msg)
    if info.result ~= 0 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(info.result))
        return
    end
    if sendArg and sendArg.index then
        local itemInfo = g_stickerInfo.pasterInfo[sendArg.index + 1]
        itemInfo.status = StickerStatus.open
        EventDispatcher:Dispatch(EVENT_REFRESH_GRIDS)
    end
end

function RequestChangeSticker(id, gridIdx)
    local l_msgId = Network.Define.Rpc.RequestChangeSticker
    ---@type RequestChangeStickerArg
    local l_sendInfo = GetProtoBufSendTable("RequestChangeStickerArg")
    l_sendInfo.sticker_id = id
    l_sendInfo.pos = gridIdx
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

function OnRequestChangeSticker(msg)
    ---@type GridStateRes
    local info = ParseProtoBufToTable("GridStateRes", msg)
    if info.result ~= 0 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(info.result))
        return
    end
    g_stickerInfo = ProcessData(info)
    EventDispatcher:Dispatch(EVENT_REFRESH_GRIDS)
end
--endregion

return ModuleMgr.StickerMgr
