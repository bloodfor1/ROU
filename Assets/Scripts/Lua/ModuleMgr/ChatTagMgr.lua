---@module ModuleMgr.ChatTagMgr
module("ModuleMgr.ChatTagMgr", package.seeall)

--- 这个管理器的交互模式是一对RPC加上一个ptc
--- 具体数据是通过ptc全量接收的
--- 交互时rpc回报只回错误码

--- 槽位对类型枚举，主要是对应各个大类
--- 这里如果对应得大类为空，则这里没有对应的槽位
--- 如果想要有对应得槽位这里一定要有数据
---@type table<number, number>
_slotTypeMap = {}

--- 类型对数据枚举，主要是用来显示当前各个类型都有标签可用，这边主要是服务器功能
---@type table<number, ChatTagData>
_typeDataMap = {}

--- 类型对大类枚举，第一层的值是一个以ID为key的映射表
---@type table<number, table<number, ChatTagData>>
_typeDataHashMap = {}

--- ID对类型映射，主要是为了利用ID获取的时候能快速查找
---@type table<number, number>
_idTypeMap = {}

---@type table<number, DialogTabTable[]>
_typePreviewMap = {}

--- 聊天表标签的数据管理类

function OnInit()
    _initData()
end

--- 这个系统是根据服务器全量同步的协议来进行更新
--- 所以退出的时候是不需要清空数据的
function OnLogout()
    -- do nothing
end

---@param reconnectData ReconectSync
function OnReconnected(reconnectData)
    -- do nothing
end

---@param msg RoleAllInfo
function OnSelectRoleNtf(msg)
    if nil == msg then
        logError("[ChatTagMgr] invalid param")
        return
    end

    local currentList = msg.chat_tag.own_tags
    local currentID = msg.chat_tag.cur_tag
    _refreshAllData(currentID, currentList)
end

---@return DialogTabTable[]
function GetTagPreviewList(id)
    if nil == id then
        logError("[ChatTagMgr] invalid data")
        return nil
    end

    local ret = _typePreviewMap[id]
    return ret
end

---@return ChatTagData[]
function GetTagListByPattern(pattern)
    local ret = {}
    for i = 1, #_slotTypeMap do
        local singleType = _slotTypeMap[i]
        local currentData = _typeDataMap[singleType]
        if nil ~= currentData and _dataMatchesPattern(currentData, pattern) then
            table.insert(ret, currentData)
        end
    end

    return ret
end

function ReqChangeTag(id)
    if nil == id then
        logError("[ChatTagMgr] invalid param")
        return
    end

    local msgID = Network.Define.Rpc.ChangeChatTag
    ---@type ChangeChatTagArg
    local sendInfo = GetProtoBufSendTable("ChangeChatTagArg")
    sendInfo.tag_id = id
    Network.Handler.SendRpc(msgID, sendInfo)
end

function OnChangeConfirm(msg)
    ---@type ChangeChatTagRes
    local info = ParseProtoBufToTable("ChangeChatTagRes", msg)
    local errorCode = info.result
    if ErrorCode.ERR_SUCCESS ~= errorCode then
        MgrMgr:GetMgr("TipsMgr").ShowErrorCodeTips(errorCode)
        return
    end

    -- todo 如果需要加提示在这里加
end

--- 获得新标签的时候走全量同步
function OnTagUpdate(msg)
    ---@type ChatTagRecord
    local info = ParseProtoBufToTable("ChatTagRecord", msg)
    local currentList = info.own_tags
    local currentID = info.cur_tag
    _refreshAllData(currentID, currentList)

    -- todo 先屏蔽掉临时提示
    -- MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("C_CHAT_TAG_UPDATED"))
end

--- 根据ID获取数据
---@return ChatTagData
function GetDataByID(id)
    if nil == id then
        return nil
    end

    local type = _idTypeMap[id]
    if nil == type then
        return nil
    end

    local targetHash = _typeDataHashMap[type]
    if nil == targetHash then
        return nil
    end

    local ret = targetHash[id]
    return ret
end

--- 根据ID获取数据编号
function GetDataIdxByID(id)
    if nil == id then
        logError("[ChatTagMgr] invalid param")
        return 0
    end

    local type = _idTypeMap[id]
    if nil == type then
        logError("[ChatTagMgr] invalid id: " .. tostring(id))
        return 0
    end

    local currentID = _typeDataMap[type]
    if nil == currentID then
        return 0
    end

    for k, v in pairs(_slotTypeMap) do
        if v == type then
            return k
        end
    end

    return 0
end

---@param data ChatTagData
function _dataMatchesPattern(data, pattern)
    if nil == data then
        return false
    end

    if nil == pattern then
        return true
    end

    local ret = nil ~= string.find(data.config.Name, pattern)
    return ret
end

function _refreshAllData(currentID, currentList)
    if nil == currentID or nil == currentList then
        logError("[ChatTagMgr] invalid param")
        return
    end

    playerCustomMgr = MgrMgr:GetMgr("PlayerCustomDataMgr")
    playerCustomMgr.SetChatTagID(currentID)
    local idMap = _createIdHash(currentList)
    local E_CUSTOM_STATE = GameEnum.ECustomItemActiveType
    _typeDataMap = {}
    for dataType, dataHashMap in pairs(_typeDataHashMap) do
        for id, data in pairs(dataHashMap) do
            local inProcession = nil ~= idMap[id]
            if inProcession then
                data.state = E_CUSTOM_STATE.Active
                _typeDataMap[dataType] = data
            else
                data.state = E_CUSTOM_STATE.InActive
            end

            if currentID == data.config.ID then
                data.state = E_CUSTOM_STATE.InUse
                _typeDataMap[dataType] = data
            end
        end
    end

    for dataType, dataHashMap in pairs(_typeDataHashMap) do
        if nil == _typeDataMap[dataType] then
            local defaultData = _getDefaultDataFromHash(dataHashMap)
            _typeDataMap[dataType] = defaultData
        end
    end

    _reGenerateSlotTypeMap()
    local gameEventMgr = MgrMgr:GetMgr("GameEventMgr")
    gameEventMgr.RaiseEvent(gameEventMgr.OnChatLabelUpdate)
end

--- 在map当中获取默认配置
---@param map table<number, ChatTagData>
function _getDefaultDataFromHash(map)
    if nil == map then
        logError("[ChatTagMgr] invalid map, get default data failed")
        return nil
    end

    for id, data in pairs(map) do
        if 0 < data.config.ShowLimit then
            return data
        end
    end

    return nil
end

---@param list number[]
function _createIdHash(list)
    if nil == list then
        logError("[ChatTagMgr] invalid param")
        return {}
    end

    local ret = {}
    for i = 1, #list do
        local singleValue = list[i]
        ret[singleValue] = 1
    end

    return ret
end

--- 初始化所有数据，主要是对配置进行分类
--- 初始化的过程中会直接设置默认启用了什么东西
function _initData()
    _typeDataMap = {}
    local dialogTagList = TableUtil.GetDialogTabTable().GetTable()
    for i = 1, #dialogTagList do
        local singleTagConfig = dialogTagList[i]
        local singleType = singleTagConfig.Type
        _idTypeMap[singleTagConfig.ID] = singleType
        if nil == _typeDataHashMap[singleType] then
            _typeDataHashMap[singleType] = {}
        end

        local newData = _createTagData(singleTagConfig)
        _typeDataHashMap[singleTagConfig.Type][singleTagConfig.ID] = newData
        if _isConfigDefault(singleTagConfig) then
            _typeDataMap[singleType] = newData
        end

        --- 因为是顺序遍历表，所以本身就是已经排好序的状态，不需要再额外排序了
        _tryAddPreviewData(singleTagConfig)
    end

    _reGenerateSlotTypeMap()
end

--- 重新生成槽位合类型映射表
function _reGenerateSlotTypeMap()
    ---@type ChatTagData[]
    local typeList = {}
    for key, value in pairs(_typeDataMap) do
        table.insert(typeList, value)
    end

    _slotTypeMap = {}
    table.sort(typeList, _sortTypeFunc)
    for i = 1, #typeList do
        local singleConfig = typeList[i]
        local singleType = singleConfig.config.Type
        if nil ~= _typeDataMap[singleType] then
            table.insert(_slotTypeMap, singleConfig.config.Type)
        end
    end
end

---@param a ChatTagData
---@param b ChatTagData
function _sortTypeFunc(a, b)
    return a.config.Type < b.config.Type
end

---@param config DialogTabTable
---@return boolean
function _isConfigDefault(config)
    if nil == config then
        logError("[ChatTagMgr] invalid param")
        return false
    end

    local ret = 1 == config.ShowLimit
    return ret
end

--- 这个地方默认设置的状态是未激活
---@param config DialogTabTable
---@return ChatTagData
function _createTagData(config)
    if nil == config then
        logError("[ChatTagMgr] invalid param")
        return nil
    end

    ---@type ChatTagData
    local ret = {
        config = config,
        state = GameEnum.ECustomItemActiveType.InActive
    }

    return ret
end

---@param chatTagConfig DialogTabTable
function _tryAddPreviewData(chatTagConfig)
    if nil == chatTagConfig then
        logError("[ChatTagMgr] invalid data")
        return
    end

    if 0 >= chatTagConfig.ShowInPreview then
        return
    end

    local type = chatTagConfig.Type
    if nil == _typePreviewMap[type] then
        _typePreviewMap[type] = {}
    end

    table.insert(_typePreviewMap[type], chatTagConfig)
end

return ModuleMgr.ChatTagMgr