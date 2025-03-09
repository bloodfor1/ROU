---@module ModuleMgr.HeadFrameMgr
module("ModuleMgr.HeadFrameMgr", package.seeall)

--- 为什么弄了两个表做映射，主要是为了性能上的考虑，可以通过槽位或者通过ID都能迅速定位道数据

--- id对槽位映射，只有两个数字
---@type table<number, number>
_idSlotMap = {}

--- 槽位对数据映射，这个文件只维护这么多数据，不会维护额外的数据
---@type table<number, FrameShowData>
_slotDataMap = {}

C_VALID_CONT_TYPE = {
    [GameEnum.EBagContainerType.PlayerCustom] = 1,
    [GameEnum.EBagContainerType.HeadIcon] = 1,
}

_defaultFrameID = 0

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
    return _defaultFrameID
end

--- 根据模糊搜索来取道具数量
---@param str string
---@return table<number, FrameShowData>
function GetFrameByPattern(str)
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

function ReqChangeFrame(id)
    if nil == id then
        logError("[FrameMgr] invalid param")
        return
    end

    _reqChangeFrame(id)
end

function _reqChangeFrame(id)
    if nil == id then
        logError("[FrameMgr] invalid param")
        return
    end

    local E_CONT_TYPE = GameEnum.EBagContainerType
    if _defaultFrameID == id then
        local currentItem = Data.BagApi:GetItemByTypeSlot(E_CONT_TYPE.PlayerCustom, GameEnum.ECustomContClientSlot.HeadFrame)
        if nil == currentItem then
            return
        end

        Data.BagApi:ReqSwapItem(currentItem.UID, E_CONT_TYPE.HeadIcon)
        return
    end

    local targetSingleItem = _getTargetItem(id)
    if nil == targetSingleItem then
        logError("[FrameMgr] try use item failed, id: " .. tostring(id))
        return
    end

    Data.BagApi:ReqSwapItem(targetSingleItem.UID, E_CONT_TYPE.PlayerCustom, GameEnum.ECustomContSvrSlot.HeadFrame, -1)
end

--- 对单个ID更新标记，针对点击操作调用的接口
function SetNewState(id, state)
    _setNewState(id, state)
end

--- 清空所有的新状态，在界面关闭的时候会调用
function ClearAllNewFlag()
    for i = 1, #_slotDataMap do
        local singleData = _slotDataMap[i]
        singleData.newIconFrame = false
    end
end

---@return FrameShowData
function GetDataByID(id)
    return _getDataBytID(id)
end

--- 这里不会返回空，如果数据找不到也不会报错，但是会返回默认置
---@return number
function GetDataIdxByID(id)
    if nil == id then
        logError("[FrameMgr] invalid param")
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

function _setCurrentFrame(id)
    if nil == id then
        logError("[FrameMgr] invalid param")
        return
    end

    local ECustomItemType = GameEnum.ECustomItemActiveType
    local playerCustomDataApi = MgrMgr:GetMgr("PlayerCustomDataMgr")
    playerCustomDataApi.SetIconFrame(id)
    _setIconStateByID(id, ECustomItemType.InUse)
end

function _useFrame(id)
    local ECustomItemType = GameEnum.ECustomItemActiveType
    local playerCustomDataApi = MgrMgr:GetMgr("PlayerCustomDataMgr")
    local targetFrame = playerCustomDataApi.GetIconFrame()
    _setIconStateByID(targetFrame, ECustomItemType.Active)
    _setIconStateByID(id, ECustomItemType.InUse)
    _setFrameInUse(id)
end

--- 匹配配置名字当中是否有匹配字符串
---@param showData FrameShowData
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
        local targetData = _getTargetItem(id)
        local targetItemCount = 0
        if nil ~= targetData then
            targetItemCount = targetData.ItemCount
            _setLimitTime(id, targetData:NeedShowTimer(), targetData:GetExpireTime())
        else
            _setLimitTime(id, false, 0)
        end

        local singleData = _slotDataMap[slot]
        local oriState = singleData.state
        local currentState = ECustomItemType.None
        if 0 >= targetItemCount and _defaultFrameID ~= id then
            currentState = ECustomItemType.InActive
        else
            currentState = ECustomItemType.Active
        end

        _setIconStateByID(id, currentState)
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

    local currentFrame = Data.BagApi:GetItemByTypeSlot(GameEnum.EBagContainerType.PlayerCustom, GameEnum.ECustomContClientSlot.HeadFrame)
    local currentFrameID = _defaultFrameID
    if nil ~= currentFrame then
        currentFrameID = currentFrame.TID
        _setLimitTime(currentFrameID, currentFrame:NeedShowTimer(), currentFrame:GetExpireTime())
    end

    _setCurrentFrame(currentFrameID)
    _raiseEvent()

    for i = 1, #autoUseId do
        local id = autoUseId[i]
        _tryAutoUseFrame(id)
    end
end

--- 可能会有一些头像框是需要默认使用的，在黑夜里做一个判断
function _tryAutoUseFrame(frameID)
    if nil == frameID then
        logError("[FrameMgr] invalid data")
        return
    end

    local showData = _getDataBytID(frameID)
    if nil == showData then
        logError("[FrameMgr] invalid tid: " .. tostring(frameID))
        return
    end

    if 1 <= showData.config.AutoUse then
        _reqChangeFrame(frameID)
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

---@param a FrameShowData
---@param b FrameShowData
function _sortFunc(a, b)
    --- 表注一下这个值的作用，因为默认框服务器是不存的，所以默认获取到的数量一定是0
    --- 默认框一定要排在第一位，所以赋值给99，如果单个框获得数量超过这个值会打乱排序
    local C_DEFAULT_ID_COUNT = 99
    local types = { GameEnum.EBagContainerType.HeadIcon, GameEnum.EBagContainerType.PlayerCustom }
    local aCount = Data.BagApi:GetItemCountByContListAndTid(types, a.config.ID)
    if _defaultFrameID == a.config.ID then
        aCount = C_DEFAULT_ID_COUNT
    end

    local bCount = Data.BagApi:GetItemCountByContListAndTid(types, b.config.ID)
    if _defaultFrameID == b.config.ID then
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
    gameEventMgr.RaiseEvent(gameEventMgr.OnIconFrameUpdate)
end

--- 请求超时调用的函数
function _onTimeOut()
    local ECustomItemType = GameEnum.ECustomItemActiveType
    local playerCustomDataApi = MgrMgr:GetMgr("PlayerCustomDataMgr")
    local id = playerCustomDataApi.GetIconFrame()
    _setIconStateByID(id, ECustomItemType.InUse)
    _raiseEvent()
end

function _onFrameChange()
    local playerCustomDataApi = MgrMgr:GetMgr("PlayerCustomDataMgr")
    local targetTid = playerCustomDataApi.GetIconFrame()
    local ECustomItemType = GameEnum.ECustomItemActiveType
    _setIconStateByID(targetTid, ECustomItemType.InUse)
end

--- 背包同步和角色同步是有时间顺序的，这里需要脱离这个时间顺序
function _onBagSync()
    local ECustomItemType = GameEnum.ECustomItemActiveType
    for id, slot in pairs(_idSlotMap) do
        local targetData = _getTargetItem(id)
        local targetItemCount = 0
        if nil ~= targetData then
            targetItemCount = targetData.ItemCount
            _setLimitTime(id, targetData:NeedShowTimer(), targetData:GetExpireTime())
        else
            _setLimitTime(id, false, 0)
        end

        local currentState = ECustomItemType.None
        if 0 >= targetItemCount then
            currentState = ECustomItemType.InActive
        else
            currentState = ECustomItemType.Active
        end

        _setIconStateByID(id, currentState)
    end

    _resortMap()
    local currentFrame = Data.BagApi:GetItemByTypeSlot(GameEnum.EBagContainerType.PlayerCustom, GameEnum.ECustomContClientSlot.HeadFrame)
    local currentID = _defaultFrameID
    if nil ~= currentFrame then
        currentID = currentFrame.TID
        _setLimitTime(currentID, currentFrame:NeedShowTimer(), currentFrame:GetExpireTime())
    end

    _useFrame(currentID)
end

--- 初始化所有的缓存数据
function _initTable()
    local fullTable = TableUtil.GetPhotoFrameTable().GetTable()
    local ECustomItemType = GameEnum.ECustomItemActiveType
    for i = 1, #fullTable do
        local singleConfig = fullTable[i]
        local state = ECustomItemType.None
        if 0 >= singleConfig.Default then
            state = ECustomItemType.None
        else
            _defaultFrameID = singleConfig.ID
            state = ECustomItemType.Active
        end

        ---@type FrameShowData
        local newData = {
            config = singleConfig,
            state = state,
            newIconFrame = false,
            timeLimited = false,
            expireTime = 0,
        }

        _slotDataMap[i] = newData
        _idSlotMap[singleConfig.ID] = i
    end

    local playerCustomMgr = MgrMgr:GetMgr("PlayerCustomDataMgr")
    playerCustomMgr.SetIconFrame(_defaultFrameID)
end

function _setFrameInUse(id)
    local playerCustomDataApi = MgrMgr:GetMgr("PlayerCustomDataMgr")
    playerCustomDataApi.SetIconFrame(id)
    _raiseEvent()
end

function _getIconState(id)
    local ECustomItemType = GameEnum.ECustomItemActiveType
    if nil == id then
        logError("[FrameMgr] invalid param")
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
        logError("[FrameMgr] invalid param")
        return
    end

    local targetSlot = _idSlotMap[id]
    if nil == targetSlot then
        logError("[FrameMgr] invalid frame id: " .. tostring(id))
        return
    end

    local targetData = _getDataBytID(id)
    if nil == targetData then
        logError("[FrameMgr] invalid slot id: " .. tostring(id))
        return
    end

    targetData.newIconFrame = isNew
end

function _setLimitTime(id, isLimitedTime, expireTime)
    if nil == id or nil == isLimitedTime then
        logError("[FrameMgr] invalid param")
        return
    end

    local targetData = _getDataBytID(id)
    if nil == targetData then
        logError("[FrameMgr] invalid slot id: " .. tostring(id))
        return
    end

    targetData.timeLimited = isLimitedTime
    targetData.expireTime = expireTime
end

--- 这个函数在更新的时候会被调用两次，会先取消当前的，等到收到回包之后会重新设置一次
function _setIconStateByID(frameID, state)
    if nil == frameID or nil == state then
        logError("[FrameMgr] invalid param")
        return
    end

    local targetData = _getDataBytID(frameID)
    if nil == targetData then
        logError("[FrameMgr] invalid slot id: " .. tostring(frameID))
        return
    end

    targetData.state = state
end

---@return FrameShowData
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

return ModuleMgr.HeadFrameMgr