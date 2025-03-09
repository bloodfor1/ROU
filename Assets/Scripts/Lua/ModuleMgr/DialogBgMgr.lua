---@module ModuleMgr.DialogBgMgr
module("ModuleMgr.DialogBgMgr", package.seeall)

--- 这个代码和HeadFrameMgr代码是有一定相似度的
--- 为什么没有抽象？原因是两个管理器代码可能未来差异会越来越大，而且使用的不是同一张表
--- 所以决定采用这种单独维护的模式

---@type table<number, number>
_idSlotMap = {}

---@type table<number, DialogBgShowData>
_slotDataMap = {}

C_VALID_CONT_TYPE = {
    [GameEnum.EBagContainerType.PlayerCustom] = 1,
    [GameEnum.EBagContainerType.HeadIcon] = 1,
}

--- 默认气泡框ID，这个值是在初始化的时候设置好的
_defaultBubbleId = 0

function OnInit()
    local gameEventMgr = MgrMgr:GetMgr("GameEventMgr")
    gameEventMgr.Register(gameEventMgr.OnBagSync, _onBagSync)
    gameEventMgr.Register(gameEventMgr.OnBagUpdate, _onBagItemChange)
    _initTable()
end

function OnLogout()
    -- do nothing
end

---@param reconnectData ReconectSync
function OnReconnected(reconnectData)
    -- do nothing
end

function GetDefault()
    return _defaultBubbleId
end

--- 根据模糊搜索来取道具数量
---@param str string
---@return table<number, DialogBgShowData>
function GetBgByPattern(str)
    if nil == str then
        return _slotDataMap
    end

    local ret = {}
    for i = 1, #_slotDataMap do
        local singleData = _slotDataMap[i]
        if _configMatchesPattern(singleData, str) then
            table.insert(ret, singleData)
        end
    end

    return ret
end

--- 这里会做一个判断，如果是启用默认置，这里会将当前槽位得道具移出去
function ReqChangeDialogBg(id)
    if nil == id then
        logError("[FrameMgr] invalid param")
        return
    end

    _reqChangeDialogBg(id)
end

function _reqChangeDialogBg(id)
    if nil == id then
        logError("[FrameMgr] invalid param")
        return
    end

    local E_CONT_TYPE = GameEnum.EBagContainerType
    if _defaultBubbleId == id then
        local currentItem = Data.BagApi:GetItemByTypeSlot(E_CONT_TYPE.PlayerCustom, GameEnum.ECustomContClientSlot.ChatBubble)
        if nil == currentItem then
            return
        end

        Data.BagApi:ReqSwapItem(currentItem.UID, E_CONT_TYPE.HeadIcon)
        return
    end

    local targetSingleItem = _getTargetItem(id)
    if nil == targetSingleItem then
        logError("[DialogMgr] try use item failed, id: " .. tostring(id))
        return
    end

    Data.BagApi:ReqSwapItem(targetSingleItem.UID, E_CONT_TYPE.PlayerCustom, GameEnum.ECustomContSvrSlot.ChatBubble, -1)
end

--- 对单个ID更新标记，针对点击操作调用的接口
function SetNewState(id, state)
    _setNewState(id, state)
end

--- 清空所有的新状态，在界面关闭的时候会调用
function ClearAllNewFlag()
    for i = 1, #_slotDataMap do
        local singleData = _slotDataMap[i]
        singleData.newTag = false
    end
end

---@return DialogBgShowData
function GetDataByID(id)
    return _getDataBytID(id)
end

--- 这里不会返回空，如果数据找不到也不会报错，但是会返回默认置
---@return number
function GetDataIdxByID(id)
    if nil == id then
        logError("[DialogBgMgr] invalid param")
        return -1
    end

    local ret = _idSlotMap[id]
    if nil == ret then
        return -1
    end

    return ret
end

---@return ItemData
function _getTargetItem(id)
    local E_CONT_TYPE = GameEnum.EBagContainerType
    ---@type FiltrateCond
    local condition = { Cond = MgrProxy:GetItemDataFuncUtil().ItemMatchesTid, Param = id }
    local conditions = { condition }
    local contTypes = { E_CONT_TYPE.HeadIcon }
    local targetItems = Data.BagApi:GetItemsByTypesAndConds(contTypes, conditions)
    local targetSingleItem = targetItems[1]
    return targetSingleItem
end

function _setCurrentBubble(id)
    if nil == id then
        logError("[BubbleMgr] invalid param")
        return
    end

    local ECustomItemType = GameEnum.ECustomItemActiveType
    local playerCustomDataApi = MgrMgr:GetMgr("PlayerCustomDataMgr")
    playerCustomDataApi.SetBubbleID(id)
    _setBgStateByID(id, ECustomItemType.InUse)
end

function _useDialogBg(id)
    local ECustomItemType = GameEnum.ECustomItemActiveType
    local playerCustomDataApi = MgrMgr:GetMgr("PlayerCustomDataMgr")
    local targetBg = playerCustomDataApi.GetBubbleID()
    _setBgStateByID(targetBg, ECustomItemType.Active)
    _setBgStateByID(id, ECustomItemType.InUse)
    _setDialogBgInUse(id)
end

--- 匹配配置名字当中是否有匹配字符串
---@param showData DialogBgShowData
---@return boolean
function _configMatchesPattern(showData, pattern)
    if nil == pattern then
        return true
    end

    if nil == showData then
        return false
    end

    local ret = nil ~= string.find(showData.config.Name, pattern)
    return ret
end

--- 如果是获得道具，但是此时这个头像已经被启用了，这个时候不处理
--- 如果是删除道具，此时对应头像框默认变成非激活状态
---@param itemUpdateDataList ItemUpdateData[]
function _onBagItemChange(itemUpdateDataList)
    local needRaiseEvent = false
    for i = 1, #itemUpdateDataList do
        local singleData = itemUpdateDataList[i]
        if nil ~= C_VALID_CONT_TYPE[singleData.OldContType] or nil ~= C_VALID_CONT_TYPE[singleData.NewContType] then
            needRaiseEvent = true
            break
        end
    end

    if not needRaiseEvent then
        return
    end

    local autoUseId = {}
    local ECustomItemType = GameEnum.ECustomItemActiveType
    local needRefresh = false
    for id, slot in pairs(_idSlotMap) do
        local targetItem = _getTargetItem(id)
        local targetItemCount = 0
        if nil ~= targetItem then
            targetItemCount = targetItem.ItemCount
            _setLimitTime(id, targetItem:NeedShowTimer(), targetItem:GetExpireTime())
        else
            _setLimitTime(id, false, 0)
        end

        local singleData = _slotDataMap[slot]
        local oriState = singleData.state
        local currentState = ECustomItemType.None
        if 0 >= targetItemCount and _defaultBubbleId ~= id then
            currentState = ECustomItemType.InActive
        else
            currentState = ECustomItemType.Active
        end

        _setBgStateByID(id, currentState)
        if currentState ~= oriState then
            needRefresh = true
        end

        if ECustomItemType.InActive == oriState and ECustomItemType.Active == currentState then
            _setNewState(id, true)
            table.insert(autoUseId, id)
        else
            _setNewState(id, false)
        end
    end

    if needRefresh then
        _resortMap()
    end

    local currentBubble = Data.BagApi:GetItemByTypeSlot(GameEnum.EBagContainerType.PlayerCustom, GameEnum.ECustomContClientSlot.ChatBubble)
    local currentBubbleID = _defaultBubbleId
    if nil ~= currentBubble then
        currentBubbleID = currentBubble.TID
        _setLimitTime(currentBubbleID, currentBubble:NeedShowTimer(), currentBubble:GetExpireTime())
    end

    _setCurrentBubble(currentBubbleID)
    _raiseEvent()

    for i = 1, #autoUseId do
        local id = autoUseId[i]
        _tryAutoUseDialogBg(id)
    end
end

--- 可能会有一些头像框是需要默认使用的，在黑夜里做一个判断
function _tryAutoUseDialogBg(frameID)
    if nil == frameID then
        logError("[DialogBgMgr] invalid data")
        return
    end

    local showData = _getDataBytID(frameID)
    if nil == showData then
        logError("[DialogBgMgr] invalid tid: " .. tostring(frameID))
        return
    end

    if 1 <= showData.config.AutoUse then
        _reqChangeDialogBg(frameID)
    end
end

function _resortMap()
    table.sort(_slotDataMap, _sortFunc)
    _idSlotMap = {}
    for i = 1, #_slotDataMap do
        local singleData = _slotDataMap[i]
        _idSlotMap[singleData.config.ID] = i
    end
end

---@param a DialogBgShowData
---@param b DialogBgShowData
function _sortFunc(a, b)
    --- 表注一下这个值的作用，因为默认框服务器是不存的，所以默认获取到的数量一定是0
    --- 默认框一定要排在第一位，所以赋值给99，如果单个框获得数量超过这个值会打乱排序
    local C_DEFAULT_ID_COUNT = 99
    local types = { GameEnum.EBagContainerType.HeadIcon, GameEnum.EBagContainerType.PlayerCustom }
    local aCount = Data.BagApi:GetItemCountByContListAndTid(types, a.config.ID)
    if _defaultBubbleId == a.config.ID then
        aCount = C_DEFAULT_ID_COUNT
    end

    local bCount = Data.BagApi:GetItemCountByContListAndTid(types, b.config.ID)
    if _defaultBubbleId == b.config.ID then
        bCount = C_DEFAULT_ID_COUNT
    end

    if not int64.equals(aCount, bCount) then
        return aCount > bCount
    end

    return a.config.SortID < b.config.SortID
end

--- 全局广播更新头像数据
function _raiseEvent()
    local gameEventMgr = MgrMgr:GetMgr("GameEventMgr")
    gameEventMgr.RaiseEvent(gameEventMgr.OnDialogBgUpdate)
end

--- 请求超时调用的函数
function _onTimeOut()
    local ECustomItemType = GameEnum.ECustomItemActiveType
    local playerCustomDataApi = MgrMgr:GetMgr("PlayerCustomDataMgr")
    local id = playerCustomDataApi.GetBubbleID()
    _setBgStateByID(id, ECustomItemType.InUse)
    _raiseEvent()
end

function _onDialogBgChange()
    local playerCustomDataApi = MgrMgr:GetMgr("PlayerCustomDataMgr")
    local targetTid = playerCustomDataApi.GetBubbleID()
    local ECustomItemType = GameEnum.ECustomItemActiveType
    _setBgStateByID(targetTid, ECustomItemType.InUse)
end

--- 背包同步和角色同步是有时间顺序的，这里需要脱离这个时间顺序
function _onBagSync()
    local ECustomItemType = GameEnum.ECustomItemActiveType
    for id, slot in pairs(_idSlotMap) do
        local targetItem = _getTargetItem(id)
        local targetItemCount = 0
        if nil ~= targetItem then
            targetItemCount = targetItem.ItemCount
            _setLimitTime(id, targetItem:NeedShowTimer(), targetItem:GetExpireTime())
        else
            _setLimitTime(id, false, 0)
        end

        local currentState = ECustomItemType.None
        if 0 >= targetItemCount then
            currentState = ECustomItemType.InActive
        else
            currentState = ECustomItemType.Active
        end

        _setBgStateByID(id, currentState)
    end

    _resortMap()
    local currentBubble = Data.BagApi:GetItemByTypeSlot(GameEnum.EBagContainerType.PlayerCustom, GameEnum.ECustomContClientSlot.ChatBubble)
    local currentID = _defaultBubbleId
    if nil ~= currentBubble then
        currentID = currentBubble.TID
        _setLimitTime(currentID, currentBubble:NeedShowTimer(), currentBubble:GetExpireTime())
    end

    _useDialogBg(currentID)
end

--- 初始化所有的缓存数据
function _initTable()
    local fullTable = TableUtil.GetDialogBgTable().GetTable()
    local ECustomItemType = GameEnum.ECustomItemActiveType
    for i = 1, #fullTable do
        local singleConfig = fullTable[i]
        local state = ECustomItemType.None
        if 0 >= singleConfig.Default then
            state = ECustomItemType.None
        else
            _defaultBubbleId = singleConfig.ID
            state = ECustomItemType.Active
        end

        ---@type DialogBgShowData
        local newData = {
            config = singleConfig,
            state = state,
            newTag = false,
            timeLimited = false,
            expireTime = 0,
        }

        _slotDataMap[i] = newData
        _idSlotMap[singleConfig.ID] = i
    end

    local playerCustomMgr = MgrMgr:GetMgr("PlayerCustomDataMgr")
    playerCustomMgr.SetBubbleID(_defaultBubbleId)
end

function _setDialogBgInUse(id)
    local playerCustomDataApi = MgrMgr:GetMgr("PlayerCustomDataMgr")
    playerCustomDataApi.SetBubbleID(id)
    _raiseEvent()
end

function _getDialogBgState(id)
    local ECustomItemType = GameEnum.ECustomItemActiveType
    if nil == id then
        logError("[DialogBgMgr] invalid param")
        return ECustomItemType.None
    end

    local targetData = _getDataBytID(id)
    if nil == targetData then
        return ECustomItemType.None
    end

    return targetData.state
end

function _setNewState(id, isNew)
    if nil == id or nil == isNew then
        logError("[DialogBgMgr] invalid param")
        return
    end

    local targetSlot = _idSlotMap[id]
    if nil == targetSlot then
        logError("[DialogBgMgr] invalid frame id: " .. tostring(id))
        return
    end

    local targetData = _getDataBytID(id)
    if nil == targetData then
        logError("[DialogBgMgr] invalid slot id: " .. tostring(id))
        return
    end

    targetData.newTag = isNew
end

function _setLimitTime(id, isLimitedTime, expireTime)
    if nil == id or nil == isLimitedTime then
        logError("[DialogBgMgr] invalid param")
        return
    end

    local targetData = _getDataBytID(id)
    if nil == targetData then
        logError("[DialogBgMgr] invalid slot id: " .. tostring(id))
        return
    end

    targetData.timeLimited = isLimitedTime
    targetData.expireTime = expireTime
end

--- 这个函数在更新的时候会被调用两次，会先取消当前的，等到收到回包之后会重新设置一次
function _setBgStateByID(frameID, state)
    if nil == frameID or nil == state then
        logError("[DialogBgMgr] invalid param")
        return
    end

    local targetData = _getDataBytID(frameID)
    if nil == targetData then
        logError("[DialogBgMgr] invalid slot id: " .. tostring(frameID))
        return
    end

    targetData.state = state
end

---@return DialogBgShowData
function _getDataBytID(frameID)
    if nil == frameID then
        return nil
    end

    local targetSlot = _idSlotMap[frameID]
    if nil == targetSlot then
        return nil
    end

    local targetData = _slotDataMap[targetSlot]
    return targetData
end

return ModuleMgr.DialogBgMgr