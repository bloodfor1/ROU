-- 称号贴纸管理
require("ModuleMgr/CommonMsgProcessor")
require "UI/UIBaseCtrl"

---@module TitleStickerMgr
module("ModuleMgr.TitleStickerMgr", package.seeall)

----------------------- 事件相关 ------------------------
EventDispatcher = EventDispatcher.new()
EEventType = {
    CurrentTitleRefresh = "CurrentTitleRefresh",             -- 刷新当前称号
    TitleRefresh = "TitleRefresh",                           -- 刷新称号信息

    StickerGridsRefresh = "StickerGridsRefresh",             -- 贴纸栏位更新
    StickerInfosRefresh = "StickerInfosRefresh",             -- 贴纸信息刷新
}
----------------------- 事件相关 ------------------------

-- 称号贴纸数据
---@type ModuleData.TitleStickerData
titleStickerData = DataMgr:GetData("TitleStickerData")


-- 称号获取途径名称
titleGetWayNames = {
    [0] = "",
    [1] = Lang("ACHIEVEMENT_GET"),
    [2] = Lang("ACHIEVEMENT_LEVEL"),
    [3] = Lang("GARDEROBE_VALUE"),
    [4] = Lang("TITLE_CONDITION_SPECIAL")
}

-- 称号显示隐藏
function OnShowTitleCommonData(_, value)
    value = tonumber(value)
    -- logError(StringEx.Format("OnShowTitleCommonData {0},{1}", _, value))
    titleStickerData.IsTitleShown = value == 1
    EventDispatcher:Dispatch(EEventType.CurrentTitleRefresh)

    RefreshShownTitleId()
end

---@param itemInfoList ItemUpdateData[]
function OnItemChange(_, itemInfoList)
    for _, itemInfo in ipairs(itemInfoList) do
        local l_item = itemInfo:GetNewOrOldItem()
        local l_itemTid = l_item and l_item.TID or 0
        local l_titleInfo = GetTitleInfoById(l_itemTid)
        if l_titleInfo then
            l_titleInfo.isOwned = IsTitleOwned(l_itemTid)
            if itemInfo.Reason ~= ItemChangeReason.ITEM_REASON_MOVE_ITEM and itemInfo:IsItemNewAcquire() then
                l_titleInfo.isNew = true

                EnqueueNewTitleId(l_itemTid)
                -- 新称号提示
                UIMgr:ActiveUI(UI.CtrlNames.Titleget)
            end

            RefreshActiveTitleId()

            EventDispatcher:Dispatch(EEventType.TitleRefresh)
            EventDispatcher:Dispatch(EEventType.CurrentTitleRefresh)
            RefreshShownTitleId()
        end
    end
end

function OnBagSync()
    RefreshOwnInfo()
    RefreshActiveTitleId()
end

function RefreshShownTitleId()
    MPlayerInfo.ShownTitleId = titleStickerData.IsTitleShown and titleStickerData.ActiveTitleId or 0
end

function OnInit()
    -- 通用数据协议处理称号
    ---@type CommonMsgProcessor
    local l_commonData = Common.CommonMsgProcessor.new()
    local l_data = {}
    table.insert(l_data, {
        ModuleEnum = CommondataType.kCDT_NORMAL,
        DetailDataEnum = CommondataId.kCDI_SHOW_TITLE,
        Callback = OnShowTitleCommonData,
        -- CbSelf = ModuleMgr.TitleStickerMgr
    })
    l_commonData:Init(l_data)

    MgrMgr:GetMgr("GameEventMgr").Register(MgrMgr:GetMgr("GameEventMgr").OnBagUpdate, OnItemChange, ModuleMgr.TitleStickerMgr)
    MgrMgr:GetMgr("GameEventMgr").Register(MgrMgr:GetMgr("GameEventMgr").OnBagSync, OnBagSync, ModuleMgr.TitleStickerMgr)
end


function OnSelectRoleNtf(info)
    ProcessStickerInfo(info.sticker_info, true)
end

-- 处理贴纸协议数据
function ProcessStickerInfo(stickerInfoPb, hasStickerField)
    if hasStickerField and stickerInfoPb.own_stickers then
        for _, v in ipairs(stickerInfoPb.own_stickers) do
            titleStickerData.SetStickerInfo(v.value, {isOwned = true})
        end
    end
    -- 栏位的放置状态
    for i, v in ipairs(stickerInfoPb.grid) do
        titleStickerData.SetStickerGridInfo(i, { stickerId = v.value})
    end

    -- 栏位的解锁状态
    for i, v in ipairs(stickerInfoPb.grid_unlock_status) do
        titleStickerData.SetStickerGridInfo(i, { status = v.value})
    end
end


-- 找到第一个可用的栏位
function FindValidGridIndex(length)
    local l_index = 0
    local l_stickerGridInfos = titleStickerData.GetStickerGridInfos()
    local l_i = 1
    while l_i < #l_stickerGridInfos do
        local l_stickerGridInfo = l_stickerGridInfos[l_i]
        local l_canDrop = l_stickerGridInfo.stickerId == 0 and l_stickerGridInfo.status == titleStickerData.EStickerStatus.Open
        if l_index ~= 0 then
            if not l_canDrop then
                l_index = 0
            end
        elseif l_canDrop then
            l_index = l_i
        end
        if l_index ~= 0 and l_i - l_index + 1 == length then
            break
        elseif l_i + length - 1 > #l_stickerGridInfos then
            l_index = 0
            break
        end
        -- 处理栏位被覆盖的情况
        l_i = l_i + l_stickerGridInfo:GetLengthFunc()
    end
    return l_index
end


-- 获取称号的获取途径信息
function GetTitleGetWay(titleId)
    local l_getWay = {
        type = 0,        -- 0无途径，1成就，2成就等级，3典藏值，4其它
        typeName = "",
        btnText = "",
        btnFunc = nil,
        des = "",
        isShowSlider = false,
        sliderValue = 0,
        sliderText = "0/0",
        isDone = false,  -- 是否已完成
    }
    local l_titleRow = TableUtil.GetTitleTable().GetRowByTitleID(titleId)
    if l_titleRow and l_titleRow.Description ~= "" then
        l_getWay.type = 4
        l_getWay.typeName = titleGetWayNames[4]
        l_getWay.des = l_titleRow.Description
        return l_getWay
    end
    local l_searchInfo = ItemSearchTable[titleId]
    local l_isFound = false
    for k, v in pairs(l_searchInfo) do
        if #v ~= 0 then
            if l_isFound then
                logError(StringEx.Format("称号({0})的获取途径数量大于1！@韩艺鸣", titleId))
                break
            else
                l_isFound = true
                if #v > 1 then
                    logError(StringEx.Format("称号({0})的获取途径大于1！@韩艺鸣", titleId))
                end
                local l_achievementMgr = MgrMgr:GetMgr("AchievementMgr")
                local l_id = v[1]
                if k == GameEnum.ItemSearchType.Achievement then
                    l_getWay.type = 1
                    l_getWay.typeName = titleGetWayNames[1]
                    local l_achievementRow = TableUtil.GetAchievementDetailTable().GetRowByID(l_id)
                    if l_achievementRow then
                        if l_achievementRow.HideType == 0 then
                            l_getWay.typeName = titleGetWayNames[1] .. ":"
                            l_getWay.btnText = l_achievementRow.Name
                            l_getWay.des = RoColor.FormatWord(l_achievementMgr.GetAchievementDetailsWithTableInfo(l_achievementRow))
                            l_getWay.btnFunc = function()
                                l_achievementMgr.OpenAchievementPanel(l_id)
                            end
                            l_getWay.isDone = l_achievementMgr.IsFinishWithId(l_id)
                        elseif l_achievementRow.HideType == 1 then
                            l_getWay.des = Lang("ACHIEVEMENT_HIDE_GET")
                        end
                    end
                elseif k == GameEnum.ItemSearchType.AchievementBadge then
                    l_getWay.type = 2
                    l_getWay.typeName = titleGetWayNames[2] .. ":"
                    l_getWay.isShowSlider = true
                    local l_badgeRow = TableUtil.GetAchievementBadgeTable().GetRowByLevel(l_id)
                    if l_badgeRow then
                        l_getWay.btnText = l_badgeRow.Name
                        local l_curPoint = l_achievementMgr.TotalAchievementPoint
                        l_getWay.sliderValue = l_curPoint / l_badgeRow.Point
                        if l_getWay.sliderValue >= 1 then
                            l_getWay.sliderText = Lang("EDEN_TASK_FINISHED")
                        else
                            l_getWay.sliderText = StringEx.Format("{0}/{1}", l_curPoint, l_badgeRow.Point)
                        end

                        l_getWay.des = Lang("ACHIEVEMENT_POINT_GET", l_badgeRow.Point)

                        l_getWay.isDone = l_getWay.sliderValue >= 1
                    end
                    l_getWay.btnFunc = function()
                        l_achievementMgr.OpenAchievementPanel(nil, true, l_id)
                    end
                elseif k == GameEnum.ItemSearchType.GarderobeAward then
                    l_getWay.type = 3
                    l_getWay.typeName = titleGetWayNames[3]
                    l_getWay.isShowSlider = true
                    local l_garderobeRow = TableUtil.GetGarderobeAwardTable().GetRowByID(l_id)
                    if l_garderobeRow then
                        local l_curPoint = MgrMgr:GetMgr("GarderobeMgr").FashionRecord.fashion_count
                        l_getWay.sliderValue = l_curPoint / l_garderobeRow.Point

                        if l_getWay.sliderValue >= 1 then
                            l_getWay.sliderText = Lang("EDEN_TASK_FINISHED")
                        else
                            l_getWay.sliderText = StringEx.Format("{0}/{1}", l_curPoint, l_garderobeRow.Point)
                        end

                        l_getWay.des = Lang("GARDEROBE_POINT_GET", l_garderobeRow.Point)

                        l_getWay.isDone = l_getWay.sliderValue >= 1
                    end
                    l_getWay.btnFunc = function()
                        UIMgr:ActiveUI(UI.CtrlNames.Garderobe, {gardeorbePoint = l_garderobeRow.Point})
                    end
                end
            end
        end
    end
    return l_getWay
end

-- 打开称号界面并选中特定称号
function OpenTitleUI(titleId)
    UIMgr:ActiveUI(UI.CtrlNames.Personal, {titleId = titleId})
end

-- 称号分享
function ShareTitle(channel, titleId)
    local l_titleName = "<>"
    local l_isOwned = 0
    local l_titleInfo = titleStickerData.GetTitleInfoById(titleId)
    if l_titleInfo then
        l_titleName = StringEx.Format("[{0}]", l_titleInfo.titleTableInfo.TitleName)
        l_isOwned = l_titleInfo.isOwned and 1 or 0
    end
    local l_msg, l_msgParam = MgrMgr:GetMgr("LinkInputMgr").GetTitlePack("", titleId, l_titleName, l_isOwned, MPlayerInfo.Name)
    local l_isSendSucceed = MgrMgr:GetMgr("ChatMgr").SendChatMsg(MPlayerInfo.UID, l_msg, channel, l_msgParam)
    if l_isSendSucceed then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("ShareSucceedText"))
    end
end


function OnTitleShareClicked(titleId, isOwned, roleName)
    if isOwned == 1 then
        --MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("TITLE_SHARE_OWN", roleName))
    else
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("TITLE_SHARE_NOT_OWN", roleName))
    end

    MgrMgr:GetMgr("ItemTipsMgr").ShowTipsDisplayWithId(titleId)
end


-- 获取品质颜色
function GetQualityColor(quality)
    local l_color = RoColor.Hex2Color(RoQuality.GetTitleColorHex(quality))
    return l_color
end

--- 解析贴纸的pb数据
---@param stickers StickerBaseInfo
function ParseStickersPB(stickers)
    if not stickers then return {} end
    local l_gridInfos  = {}
    local l_lastEnd = 0
    for i = 1, #stickers.grid do
        local l_stickerId = stickers.grid[i].value
        table.insert(l_gridInfos, {
            stickerId = l_stickerId,
            status = stickers.grid_unlock_status[i].value,
            isCovered = i <= l_lastEnd,                 -- 是否被覆盖
        })
        if i > l_lastEnd then
            local l_gridLength = 1
            if l_stickerId ~= 0 then
                local l_stickerRow = TableUtil.GetStickersTable().GetRowByStickersID(l_stickerId)
                if l_stickerRow then
                    l_gridLength = l_stickerRow.Length
                end
            end
            l_lastEnd = i + l_gridLength - 1
        end
    end
    return l_gridInfos
end

--------------------------------------- 协议处理 ---------------------------------------

-- 显示隐藏称号, 0表示当前称号
function UpdateTitleStatus(titleId, status)
    local l_msgId = Network.Define.Rpc.UpdateTitleStatus
    local l_sendInfo = GetProtoBufSendTable("TitleStatusArg")
    l_sendInfo.new_status = status
    l_sendInfo.title_id = titleId
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

-- 分享自己的贴纸
function ShareSticker(channel)
    local l_isSendSucceed = MgrMgr:GetMgr("ChatMgr").SendChatMsg(MPlayerInfo.UID, Lang("STICKERS_SHARE", ""), channel,
            {{type = ChatHrefType.Sticker, param32 = {{value = 0}}}})
    if l_isSendSucceed then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("ShareSucceedText"))
    end
end

function OnShareSticker(msg)
    MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("ShareSucceedText"))
end

function OnUpdateTitleStatus(msg, sendInfo)
    local l_info = ParseProtoBufToTable("TitleStatusRes", msg)
    if l_info.error_code ~= ErrorCode.ERR_SUCCESS then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.error_code))
        return
    end
    if sendInfo.new_status == TitleStatus.TitleStatus_Show then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("TITLE_SHOW"))
    elseif sendInfo.new_status == TitleStatus.TitleStatus_Hide then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("TITLE_HIDE"))
    elseif sendInfo.new_status == TitleStatus.TitleStatus_SetId then

    end
    --EventDispatcher:Dispatch(EEventType.CurrentTitleRefresh)
end

-- 拥有贴纸变化协议
function OnOwnStickersNtf(msg)
    local l_info = ParseProtoBufToTable("OwnStickersNtfData", msg)
    for _, v in ipairs(l_info.stickers_id) do
        titleStickerData.SetStickerInfo(v.value, {isOwned = true})
    end

    EventDispatcher:Dispatch(EEventType.StickerGridsRefresh)
end

-- 请求栏位状态
function RequestGridState()
    local l_msgId = Network.Define.Rpc.RequestGridState
    local l_sendInfo = GetProtoBufSendTable("GridStateArg")
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

-- 刷新栏位状态
function OnRequestGridState(msg)
    local l_info = ParseProtoBufToTable("GridStateRes", msg)
    if l_info.result ~= ErrorCode.ERR_SUCCESS then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.result))
        return
    end
    ProcessStickerInfo(l_info)

    EventDispatcher:Dispatch(EEventType.StickerGridsRefresh)
    EventDispatcher:Dispatch(EEventType.StickerInfosRefresh)
end

-- 请求解锁栏位
function RequestUnlockGrid(gridIdx)
    local l_msgId = Network.Define.Rpc.RequestUnlockGrid
    local l_sendInfo = GetProtoBufSendTable("RequestUnlockGridArg")
    l_sendInfo.index = gridIdx - 1
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

function OnRequestUnlockGrid(msg, sendArg)
    local l_info = ParseProtoBufToTable("GridStateRes", msg)
    if l_info.result ~= ErrorCode.ERR_SUCCESS then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.result))
        return
    end
    ProcessStickerInfo(l_info)

    EventDispatcher:Dispatch(EEventType.StickerGridsRefresh)
    EventDispatcher:Dispatch(EEventType.StickerInfosRefresh)
end

-- 设置贴纸栏位
function RequestChangeSticker(id, gridIdx)
    local l_msgId = Network.Define.Rpc.RequestChangeSticker
    local l_sendInfo = GetProtoBufSendTable("RequestChangeStickerArg")
    l_sendInfo.sticker_id = id
    l_sendInfo.pos = gridIdx - 1
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

-- 刷新贴纸数据
function OnRequestChangeSticker(msg)
    local l_info = ParseProtoBufToTable("GridStateRes", msg)
    if l_info.result ~= ErrorCode.ERR_SUCCESS then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.result))
        return
    end
    ProcessStickerInfo(l_info)

    EventDispatcher:Dispatch(EEventType.StickerGridsRefresh)
    EventDispatcher:Dispatch(EEventType.StickerInfosRefresh)
end

return ModuleMgr.TitleStickerMgr