--lua model
---@class magicLetterReceiveInfo
---@field letterUId int64
---@field fragranceId number
---@field blessing string
---@field receivePlayerName string
---@field receivePlayerUId int64

---@class grabRedEnvelopePlayerInfo
---@field playerUid int64 @ 玩家Uid
---@field rewardPropId number @ 玩家抢到的道具Id
---@field number number @ 玩家抢到的道具数量
---@field isSuperRedEnvelope boolean @是否是超级祝福礼包

---@class letterDetailInfo
---@field hasGrabRedEnvelope boolean @自家是否抢过红包
---@field hasGrabRedEnvelopeInfos grabRedEnvelopePlayerInfo[] @抢过红包玩家信息

---@class letterInfo
---@field letterUid number @add 信笺唯一Id
---@field sendPlayerName string @add 发送玩家名字
---@field sendPlayerUid int64 @add 发送玩家Uid
---@field receivePlayerName string @add 接收玩家名字
---@field receivePlayerUid int64 @add 接收玩家Uid
---@field blessing string @add 祝福语
---@field isAllAllocated boolean @add 是否已经分配完
---@field letterDetailInfo letterDetailInfo
---@field isReceived boolean @ 是否已领取 
---@field hasThanks boolean @ 是否感谢过

---@class showLetterInfo
---@field letterUid number @add 信笺唯一Id
---@field isEmptyData boolean @ 是否为空的占位数据
---@field isLoadingData boolean @add 是否是加载数据，仅滚动列表中使用
---@field isLastLoadingData boolean @add 是否最后一条加载数据，仅滚动列表中使用
--@field sendTime number @add 发送时间
---@module MagicLetterData
module("ModuleData.MagicLetterData", package.seeall)
--lua model end
---@type EventDispatcher
EventDispatcher = EventDispatcher.new()
EMagicLetterStateType = {
    UnAllAllocated = 1, --未分配完
    AllAllocated = 2, --已分配完
}
EMagicEvent = {
    OnGetMagicLetterInfo = 1, --收到魔法信笺信息
    OnGetMagicLetterDetailInfo = 2, --获得魔法信笺红包领取详细信息
    OnCurrentChooseFragranceChanged = 3, --当前选择的香氛发生变化
    OnCurrentReceiveLetterFriendChanged = 4, --当前选择的接收信笺好友发生变化
    OnMagicLetterDetailInfoChanged = 5, --信笺详细信息变更
    OnGetGrabRedEnvelopeResult = 6, --收到抢魔法信笺红包的结果
    OnMagicLetterRedEnvelopeStateChanged=7,--魔法信笺红包状态（领取状态、分配完状态）变更
    FragranceMovieTexLoadComplete = 8, --特效电影截图加载完毕
    PlayFullScreenEffect = 9,-- 播放全屏 接收或者发送 信笺特效
}

---@type letterInfo[]
local l_allLetterInfos = {}
local l_letterInfoShowUse = {}
local l_magicLetterDetailInfos = {}
local l_currentChooseFragranceEffect = 1
---@type FriendInfo
local l_currentReceiveLetterFriendInfo = nil
local l_tempSetReceiveLetterFriendInfo = nil

local l_letterInfoReqState = EMagicLetterStateType.UnAllAllocated
---@Description:当前请求信笺信息过程中请求到的信笺的最小uuid，
---0，代表从头开始请求，-1代表已请求到所有数据
local l_currentReqLetterInfoMinUUID = 0
---@Description:信笺查看中显示的列数
local l_showletterColumn = 4
---@Description:上一次发送的信笺的内容
local l_lastSendLetterContent = "" 
--region 生命周期
--初始化
function Init(...)
    l_allLetterInfos = {}
    l_magicLetterDetailInfos = {}
    l_currentChooseFragranceEffect = 1
    l_currentReceiveLetterFriendInfo = nil
    l_tempSetReceiveLetterFriendInfo = nil
    l_letterInfoReqState = EMagicLetterStateType.UnAllAllocated
    l_currentReqLetterInfoMinUUID = 0
    ClearLetterInfo()
    SetLastSendLetterContent("")
end

--登出重置
function Logout(...)
    SetLastSendLetterContent("")
    ClearLetterInfo()
end
--endregion
--region 私有接口
---@Description:更新数据前，需要移除末尾加的loading数据和empty数据
function deleteLoadingAndEmptyData()
    local l_letterInfoDataNum = #l_letterInfoShowUse
    for i = l_letterInfoDataNum, 1, -1 do
        local l_letterInfo = l_letterInfoShowUse[i]
        if l_letterInfo.isLoadingData or l_letterInfo.isEmptyData then
            table.remove(l_letterInfoShowUse)
        else
            return
        end
    end
end

---@Description:在信笺信息末尾插入loadingData 和 emptyData
---loadingData用来判断是否需要请求接下来的信笺数据
---当循环滚动列表中的loadingData展示出来时，说明已到
---底部，此时候需继续从服务器请求接下来的数据
---emptyData用来占位，当第一页无法填满时，用空数据填充，之后
---若一行未填满时用空数据填充
function insertLoadingAndEmptyData()
    local l_letterInfoDataNum = #l_letterInfoShowUse
    ---无letter时显示空面板无需插入数据
    if l_letterInfoDataNum <= 0 then
        return
    end
    local l_firstPageCanShowLetterNum = l_showletterColumn * 2
    local l_needAddLoadingDataNum = l_showletterColumn - l_letterInfoDataNum % l_showletterColumn
    local l_needAddEmptyDataNum = 0

    ---如果信笺数量无法填满一页，剩余填充空格子
    if l_letterInfoDataNum < l_firstPageCanShowLetterNum then
        l_needAddEmptyDataNum = l_firstPageCanShowLetterNum - l_letterInfoDataNum
    else
        ---如果信笺数量无法占满一行，则补充满一行
        if l_needAddLoadingDataNum<l_showletterColumn then
            l_needAddEmptyDataNum = l_needAddLoadingDataNum
        end
    end

    local l_maxNeedAddDataNum = math.max(l_needAddEmptyDataNum,l_needAddLoadingDataNum)
    for i = 1, l_maxNeedAddDataNum do
        local l_extraData = {
            isLoadingData = false,
            isEmptyData = false,
        }
        if l_needAddEmptyDataNum>0 then
            l_extraData.isEmptyData = true
            l_needAddEmptyDataNum = l_needAddEmptyDataNum - 1
        end
        if l_needAddLoadingDataNum>0 then
            l_extraData.isLoadingData = true
            l_needAddLoadingDataNum = l_needAddLoadingDataNum - 1
            if 0 == l_needAddLoadingDataNum then
                l_extraData.isLastLoadingData = true
            end
        end

        table.insert(l_letterInfoShowUse, l_extraData)
    end
end
function containShowLetterInfo(letterInfo)
    for i = 1, #l_letterInfoShowUse do
        ---@type showLetterInfo
        local l_showLetterInfo = l_letterInfoShowUse[i]
        if l_showLetterInfo.letterUid == letterInfo.letterUid then
            return true
        end
    end
    return false
end
--endregion

--region 公开接口
function GetShowLetterColumn()
     return l_showletterColumn
end
function GetReqMagicLetterStateInfo()
    return l_letterInfoReqState, l_currentReqLetterInfoMinUUID
end
function GetFragranceEffectMoviePath(effectName)
    return StringEx.Format("EffectMovie/{0}.mp4",effectName)
end
---@Description:获取每次请求信笺信息最多可得到的信笺信息数量
function GetMaxLetterNumsFromServerPerReq()
    return 12
end
function ClearLetterInfo()
    l_currentReqLetterInfoMinUUID = 0
    l_letterInfoReqState = EMagicLetterStateType.UnAllAllocated
    l_letterInfoShowUse = {}
end
--region 数据相关
function GetLastSendLetterContent()
     return l_lastSendLetterContent
end
function SetLastSendLetterContent(content)
    l_lastSendLetterContent = content
end
function HasGradMagicLetterRedEnvelope(letterUid)
    ---@type letterInfo
    local l_letterInfo = GetLetterInfoByUid(letterUid)
    return l_letterInfo ~= nil and l_letterInfo.isReceived
end
---@param uid uint64
---@return letterInfo
function GetLetterInfoByUid(letterUid)
    local l_checkLetterUid = MLuaCommonHelper.ULong(letterUid)
    return l_allLetterInfos[l_checkLetterUid]
end
---@Description:获取仅展示用的魔法信笺信息，此信息会在面板关闭时清空，重开时刷新
function GetShowUseLetterInfos()
    return l_letterInfoShowUse
end
---@param data letterInfo[]
function SetLetterInfos(data, reqLetterStateType)
    if data == nil then
        return
    end
    local l_getValidDataNum = 0

    deleteLoadingAndEmptyData()

    for i = 1, #data do
        ---@type letterInfo
        local l_letterInfo = CreateLetterInfo(data[i])
        --如果当前请求的是未领取完的红包 或者 之前未请求过此红包则插入此数据
        if reqLetterStateType == EMagicLetterStateType.UnAllAllocated or
                (not containShowLetterInfo(l_letterInfo)) then
            if l_currentReqLetterInfoMinUUID == 0 or l_letterInfo.letterUid < l_currentReqLetterInfoMinUUID then
                l_currentReqLetterInfoMinUUID = l_letterInfo.letterUid
            end
            l_getValidDataNum = l_getValidDataNum + 1
            table.insert(l_letterInfoShowUse, {letterUid = l_letterInfo.letterUid})
        end
    end

    insertLoadingAndEmptyData()

    local l_maxGetLetterInfoNum = GetMaxLetterNumsFromServerPerReq()
    if l_letterInfoReqState == EMagicLetterStateType.UnAllAllocated then
        ---@Description:如果获得的数据数量小于最大的数量，说明未领取的红包已经请求完毕，
        ---该请求已领取的红包信息了
        if l_getValidDataNum < l_maxGetLetterInfoNum then
            l_letterInfoReqState = EMagicLetterStateType.AllAllocated
            l_currentReqLetterInfoMinUUID = 0
        end
    else
        ---@Description:如果获得的数据数量小于最大的数量,说明所有数据已到位
        if l_getValidDataNum < l_maxGetLetterInfoNum then
            l_currentReqLetterInfoMinUUID = -1
        end
    end
    EventDispatcher:Dispatch(EMagicEvent.OnGetMagicLetterInfo)
end
---@param serverLetterInfo PaperBrief
function InsertSendLetterSelf(serverLetterInfo)
    local l_letterInfo = CreateLetterInfo(serverLetterInfo)
    deleteLoadingAndEmptyData()
    table.insert(l_letterInfoShowUse, 1, {letterUid = l_letterInfo.letterUid})
    insertLoadingAndEmptyData()
    EventDispatcher:Dispatch(EMagicEvent.OnGetMagicLetterInfo)
end
---@Description:供聊天频道创建的魔法信笺红包信息使用
function CreateSimpleLetterInfo(letterUid,sendPlayerName)
    local l_oldLetterInfo = l_allLetterInfos[letterUid]
    if l_oldLetterInfo==nil then
        return
    end
    l_allLetterInfos[letterUid]=
    {
        letterUid = letterUid,
        sendPlayerName = sendPlayerName,
    }
end
---@param serverLetterInfo PaperBrief
function CreateLetterInfo(serverLetterInfo)
    if serverLetterInfo == nil then
        logError("CreateLetterInfo serverdata is null!")
        return {}
    end
    local l_oldLetterInfo = l_allLetterInfos[serverLetterInfo.paper_uid]
    local l_letterInfo = nil
    if l_oldLetterInfo ~= nil then
        l_oldLetterInfo.letterUid = serverLetterInfo.paper_uid
        l_oldLetterInfo.sendPlayerName = serverLetterInfo.sender_name
        l_oldLetterInfo.receivePlayerName = serverLetterInfo.recv_name
        l_oldLetterInfo.blessing = serverLetterInfo.bless_words
        l_oldLetterInfo.isAllAllocated = serverLetterInfo.is_allocated
        l_oldLetterInfo.isReceived = serverLetterInfo.is_received
        l_oldLetterInfo.hasThanks = serverLetterInfo.thanks
        l_oldLetterInfo.sendPlayerUid = serverLetterInfo.sender_uid
        l_oldLetterInfo.receivePlayerUid = serverLetterInfo.recv_uid
        l_letterInfo=l_oldLetterInfo
    else
        l_letterInfo = {
            letterUid = serverLetterInfo.paper_uid,
            sendPlayerName = serverLetterInfo.sender_name,
            receivePlayerName = serverLetterInfo.recv_name,
            blessing = serverLetterInfo.bless_words,
            isAllAllocated = serverLetterInfo.is_allocated,
            isReceived = serverLetterInfo.is_received,
            hasThanks = serverLetterInfo.thanks,
            sendPlayerUid = serverLetterInfo.sender_uid,
            receivePlayerUid = serverLetterInfo.recv_uid
        }
    end
    l_allLetterInfos[serverLetterInfo.paper_uid]=l_letterInfo
    return l_letterInfo
end
---@return letterDetailInfo
function GetMagicLetterDetailInfo(letterUid)
    local l_checkLetterUid = MLuaCommonHelper.ULong(letterUid)
    local l_rewardInfo = l_magicLetterDetailInfos[l_checkLetterUid]
    return l_rewardInfo
end
---@param data GrapResult[]
function SetMagicLetterDetailInfo(letterUid, data)
    if data == nil then
        return
    end
    CreateMagicLetterDetailInfo(letterUid,data)
    EventDispatcher:Dispatch(EMagicEvent.OnGetMagicLetterDetailInfo)
end
---@param serverData GrapResult[]
function CreateMagicLetterDetailInfo(letterUid,serverData)
    local l_letterUidUlong = MLuaCommonHelper.ULong(letterUid)
    ---@type letterDetailInfo
    local l_letterDetailInfo = l_magicLetterDetailInfos[l_letterUidUlong]

    table.sort(serverData,function(a,b)
        return a.role_uid==MPlayerInfo.UID and b.role_uid~=MPlayerInfo.UID
    end)

    if l_letterDetailInfo~=nil then
        l_letterDetailInfo.hasGrabRedEnvelopeInfos = serverData
    else
        l_letterDetailInfo=
        {
            hasGrabRedEnvelopeInfos = serverData
        }
    end
    l_magicLetterDetailInfos[l_letterUidUlong]=l_letterDetailInfo
end
function SetFragranceEffectId(effectId)
    l_currentChooseFragranceEffect = effectId
    EventDispatcher:Dispatch(EMagicEvent.OnCurrentChooseFragranceChanged)
end
function GetFragranceEffectId()
    return l_currentChooseFragranceEffect
end
---@param isTemp boolean @ 是否为临时选择的接收信笺好友
function SetReceiveLetterFriendInfo(friendInfo, scrollShowIndex, isTemp)
    if not isTemp then
        l_currentReceiveLetterFriendInfo = friendInfo
    else
        l_tempSetReceiveLetterFriendInfo = friendInfo
    end
    EventDispatcher:Dispatch(EMagicEvent.OnCurrentReceiveLetterFriendChanged, isTemp, scrollShowIndex)
end
---@return FriendInfo
function GetReceiveLetterFriendInfo(isTemp)
    if isTemp then
        return l_tempSetReceiveLetterFriendInfo
    end
    return l_currentReceiveLetterFriendInfo
end
function GetSendMagicLetterMaxCharacterLimit()
    local l_maxCharacterNum = MGlobalConfig:GetInt("MagicPaperTalkLength", 100)
    return l_maxCharacterNum
end

--endregion

--endregion
return ModuleData.MagicLetterData