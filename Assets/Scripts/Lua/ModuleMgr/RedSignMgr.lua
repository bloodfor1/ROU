---@module ModuleMgr.RedSignMgr
module("ModuleMgr.RedSignMgr", package.seeall)

--RedSignProcessor

--红点UI处理类
--UI界面上New出红点实例，用来控制红点UI的显示隐藏等
RedSignProcessor = class("RedSignProcessor")

--Key
--RedSignParent 红点的父物体
--ClickButton （MLuaUICom类型）点击的按钮，处理点击后隐藏相应的系统
--ClickTog （MLuaUICom类型）点击的tog，处理点击后隐藏相应的系统
--ClickTogEx （MLuaUICom类型）点击的togEx，处理点击后隐藏相应的系统
--OnRedSignShow（template,redTableInfo,redCounts) 显示隐藏红点的时候调用，redTableInfo是红点的表数据，redCounts红点个数
--RedSignParent、ClickButton、ClickTog、ClickTogEx传一个就可以，一般传ClickButton或ClickTog或ClickTogEx
function RedSignProcessor:ctor(redSignData)

    self.redSignData = redSignData
    AddRedSign(redSignData)

end
--仅显示隐藏UI红点，不做其他操作
function RedSignProcessor:ShowTemplateRedSign(redCount)

    local l_tableId = self.redSignData.Key
    local l_redTableInfo = TableUtil.GetRedDotIndex().GetRowByID(l_tableId)
    if l_redTableInfo == nil then
        return
    end
    local l_redCounts = {}
    table.insert(l_redCounts, redCount)
    _showTemplateRedSign(self.redSignData, l_redTableInfo, l_redCounts)

end

function RedSignProcessor:GetRedSignTemplate()
    return self.redSignData.RedSignTemplate
end

function RedSignProcessor:Uninit()
    RemoveRedSign(self.redSignData)
end
--RedSignProcessor


function AlwaysReturnTrue()
    return 1
end

function AlwaysReturnFalse()
    return 0
end

function GetID(id, son)
    return id * 32768 + son
end

function GetIgnoreState(id, sonId)

    if sonId == nil then
        sonId = 0
    end
    return _onceData[GetID(id, sonId)] == nil or (_onceData[GetID(id, sonId)] == 0)

end

function SetIgnoreState(id, sonId, val)

    if sonId == nil then
        sonId = 0
    end
    SetRedPointCommonData(GetID(id, sonId), val)

end
--UI注册的相应红点的数据，和RedSignTree分离
local debugMgr = MgrMgr:GetMgr("RedSignDebugMgr")
local _redSignData = {}
--检测方法，红点个数等数据
local _redCheckMethodDatas = {}
--红点额外显示数量
RedSignExCount = {}
RedSignTree = {}
UpdateDelay = 5
--先将所有的红点关系连成一张有向图，其中保证所有的检测方法入度都为0
--对于每个节点：father为所有的边，count为这个节点红点的数量
--tree[node].count = Σ tree[node].son.count
function _InitRedSign()

    RedSignTree = {}
    debugMgr.BeInit()
    local l_redTable = TableUtil.GetRedDotIndex().GetTable()
    for i = 1, #l_redTable do
        local l_key = l_redTable[i].ID
        if RedSignTree[l_key] == nil then
            RedSignTree[l_key] = {count = 0, father = {}, son = {}, banSon = {}, banFather = {}}
            debugMgr.AddRedSignAccLog(l_key, 1)
        end
        for j = 1, l_redTable[i].ChildrenID.Length do
            local l_childId = l_redTable[i].ChildrenID[j - 1]
            if RedSignTree[l_childId] == nil then
                RedSignTree[l_childId] = {count = 0, father = {}, son = {}, banSon = {}, banFather = {}}
            end
            debugMgr.AddTreeSon(l_key, l_childId)
            table.insert(RedSignTree[l_childId].father, l_key)
            table.insert(RedSignTree[l_key].son, l_childId)
        end
        if not l_redTable[i].Type then
            for j = 1, l_redTable[i].CheckID.Length do
                local l_childId = -l_redTable[i].CheckID[j - 1]
                if RedSignTree[l_childId] == nil then
                    RedSignTree[l_childId] = {count = 0, father = {}, son = {}, banSon = {}, banFather = {}}
                end
                debugMgr.AddTreeSon(l_key, l_childId)
                table.insert(RedSignTree[l_childId].father, l_key)
                table.insert(RedSignTree[l_key].son, l_childId)
            end
        end
        local l_closeCheck = Common.Functions.VectorSequenceToTable(l_redTable[i].CloseCheck)
        for i, v in ipairs(l_closeCheck) do
            local l_childId = v[2]
            if v[1] == 1 then                   --检测方法ID取负
                l_childId = -v[2]
            end
            if RedSignTree[l_childId] == nil then
                RedSignTree[l_childId] = {count = 0, father = {}, son = {}, banSon = {}, banFather = {}}
            end
            table.insert(RedSignTree[l_childId].banFather, l_key)
            table.insert(RedSignTree[l_key].banSon, l_childId)
        end
    end

    l_redTable = TableUtil.GetRedDotCheckTable().GetTable()
    for i = 1, #l_redTable do
        local l_key = -l_redTable[i].ID
        if RedSignTree[l_key] == nil then
            --logYellow("该检测方法没有红点绑定，那这个检测方法就永远不会被用到，id：", l_key)
            RedSignTree[l_key] = {count = 0, father = {}, son = {}, banSon = {}, banFather = {}}
        end
    end

end

--BFS，红点更新
--isRedSign表示当前更新的是否是红点
function UpdateRedSignTree(node, count, isRedSign)

    local L, R = 1, 1
    local flag, queue, needUpdate = {}, {}, {}
    if not isRedSign then
        node = -node
    end
    if #RedSignTree[node].son > 0 and count > 0 then
        logError("禁止对非叶子节点进行额外数据更新，id：", node)
        return
    end
    debugMgr.AddRedSignTreeLog(node, count, isRedSign)

    queue[R] = node
    while R >= L and R <= 32768 do
        local l_nowNode = queue[L]
        flag[l_nowNode] = true
        L = L + 1
        if l_nowNode > 0 then
            debugMgr.AddRedSignAccLog(l_nowNode, 4)
            table.insert(needUpdate, l_nowNode)
        end
        RedSignTree[l_nowNode].count = 0
        if l_nowNode == node and GetIgnoreState(l_nowNode) then
            RedSignTree[l_nowNode].count = count
        end
        for i = 1, #RedSignTree[l_nowNode].son do
            local l_son = RedSignTree[l_nowNode].son[i]
            if GetIgnoreState(l_nowNode, l_son) and GetIgnoreState(l_nowNode) then
                RedSignTree[l_nowNode].count = RedSignTree[l_nowNode].count + RedSignTree[l_son].count
            end
        end
        for i = 1, #RedSignTree[l_nowNode].father do
            local l_father = RedSignTree[l_nowNode].father[i]
            if flag[l_father] then
                logError("配置错误，红点配置表出现了环！，请检查对应的父子关系，id：", l_father)
            end
            if GetIgnoreState(l_father, l_nowNode) and GetIgnoreState(l_father) then
                R = R + 1
                queue[R] = l_father
            end
        end
        for i = 1, #RedSignTree[l_nowNode].banFather do
            local l_father = RedSignTree[l_nowNode].banFather[i]
            table.insert(needUpdate, l_father)
        end
    end

    flag = {}
    for i = 1, #needUpdate do
        if needUpdate[i] and flag[needUpdate[i]] == nil then
            _directUpdateRedSign(needUpdate[i], RedSignTree[needUpdate[i]].count)
            flag[needUpdate[i]] = true
        end
    end

end

--最终步骤：判断CloseCheck，显示红点！（只有唯一调用的地方，最终调用）
function _directUpdateRedSign(key, count)

    if count == nil then
        count = 0
    end
    local l_redCounts = {}
    if count > 0 then
        for i = 1, #RedSignTree[key].banSon do
            local l_son = RedSignTree[key].banSon[i]
            if RedSignTree[l_son].count > 0 then
                count = 0
                break
            end
        end
    end
    table.insert(l_redCounts, count)
    local l_redSignData = _redSignData[key]
    local l_redTableInfo = TableUtil.GetRedDotIndex().GetRowByID(key)
    _showTemplatesRedSignWithTableInfo(l_redSignData, l_redTableInfo, l_redCounts)

    local l_redSignCheckMgr = MgrMgr:GetMgr("RedSignCheckMgr")
    l_redSignCheckMgr.EventDispatcher:Dispatch(l_redSignCheckMgr.EventType.RedSignStateChanged,key,count)
end

--红点额外显示数量更新
function DirectUpdateRedSign(key, count)

    if RedSignTree[key] == nil then
        logError("当前红点ID不存在，请检查下配置：", key)
        return
    end
    local l_info = TableUtil.GetRedDotIndex().GetRowByID(key)
    if l_info.ChildrenID.Length > 0 then
        logError("此红点拥有子红点，不允许直接更新其红点数量，如果是服务器控制的红点，记得子节点留空，id = ", key)
        return
    end
    if RedSignExCount[key] == nil then
        RedSignExCount[key] = 0
    end
    RedSignExCount[key] = count
    UpdateRedSignTree(key, count, true)

end

function GetRedSignRegister()
    return _redSignData
end
--注册红点系统
function AddRedSign(redSignData)

    if redSignData.Key == nil then
        logError("UI注册的key是空的，请查看是哪个key没有配到表里")
        return
    end
    local l_key = redSignData.Key
    local l_redTableInfo = TableUtil.GetRedDotIndex().GetRowByID(l_key)
    if l_redTableInfo == nil then
        logError("找不到当前红点，请检查下配置，id：", l_key)
        return
    end

    local l_loseCheck = Common.Functions.VectorSequenceToTable(l_redTableInfo.LoseCheck)
    if l_loseCheck and #l_loseCheck > 0 then
        if redSignData.ClickButton then
            redSignData.ClickButton:AddClick(function(...)
                _attachToButtonMethod(l_key, l_loseCheck)
            end, false)
        elseif redSignData.ClickTogEx then
            redSignData.ClickTogEx:OnToggleExChanged(function(value)
                if value then
                    _attachToButtonMethod(l_key, l_loseCheck)
                end
            end, false)
        elseif redSignData.ClickTog then
            redSignData.ClickTog:OnToggleChanged(function(value)
                if value then
                    _attachToButtonMethod(l_key, l_loseCheck)
                end
            end, false)
        elseif redSignData.Listener then
            local l_listener = MLuaUIListener.Get(redSignData.Listener.UObj)
            l_listener.onDown = function(g, e)
                _attachToButtonMethod(l_key, l_loseCheck)
            end
        else
            logError("表配置了LoseCheck，但是调用的地方没传ClickButton或ClickTog或ClickTogEx或Listener参数，id：", l_key)
        end
    end
    --添加数据
    if _redSignData[l_key] == nil then
        _redSignData[l_key] = {}
    end
    debugMgr.AddRedSignAccLog(l_key, 2)
    table.insert(_redSignData[l_key], redSignData)
    _CheckAllRedSignMethod(l_key)

end

function InvokeButtonMethod(key)

    local l_redTableInfo = TableUtil.GetRedDotIndex().GetRowByID(key)
    if l_redTableInfo == nil then
        logError("找不到当前红点，请检查下配置，id：", key)
        return
    end

    local l_loseCheck = Common.Functions.VectorSequenceToTable(l_redTableInfo.LoseCheck)
    if l_loseCheck and #l_loseCheck > 0 then
        _attachToButtonMethod(key, l_loseCheck)
    end
end

function _attachToButtonMethod(key, loseCheck)

    if RedSignTree[key].count == 0 then
        return
    end
    for i, v in ipairs(loseCheck) do
        local l_time = Common.TimeMgr.GetNowTimestamp()
        local l_type, l_node, l_val = v[1], v[2], v[3]
        if l_node == 1 then
            SetIgnoreState(key, -l_val, l_time)
        elseif l_node == 2 then
            SetIgnoreState(key, l_val, l_time)
        elseif l_node == 3 then
            SetIgnoreState(key, nil, l_time)
        end
        UpdateRedSignTree(key, 0, true)
        if RedSignExCount[key] then
            RedSignExCount[key] = 0
        end
        if l_type == 1 then
            if l_node == 1 then
                SetIgnoreState(key, -l_val, 0)
            elseif l_node == 2 then
                SetIgnoreState(key, l_val, 0)
            elseif l_node == 3 then
                SetIgnoreState(key, nil, 0)
            end
        end
    end

end

--取消此系统的红点
function RemoveRedSign(redSignData)

    local key = redSignData.Key
    local l_redTableInfo = TableUtil.GetRedDotIndex().GetRowByID(key)
    if l_redTableInfo == nil then
        return
    end
    if _redSignData[key] == nil then
        logError("移除UI注册的红点系统时，发现没有存储此红点数据，查看此功能是否有问题。key：" .. tostring(key))
        return
    end
    debugMgr.AddRedSignAccLog(redSignData.Key, 3)
    table.ro_removeValue(_redSignData[key], redSignData)

end
--redTableInfo表数据
function _showTemplatesRedSignWithTableInfo(redSignDatas, redTableInfo, redCounts)

    if redSignDatas == nil or #redSignDatas == 0 then
        return
    end
    for i = 1, #redSignDatas do
        _showTemplateRedSign(redSignDatas[i], redTableInfo, redCounts)
    end

end

--redSignData UI注册的数据（一个）
function _showTemplateRedSign(redSignData, redTableInfo, redCounts)

    if redSignData == nil or redTableInfo == nil then
        return
    end
    redSignData.RedSignTemplate:AddLoadCallback(function(redSignTemplate)
        if not MLuaCommonHelper.IsNull(redSignTemplate.uObj) then
            redSignTemplate:ShowRedSign(redTableInfo, redCounts)
            debugMgr.AddRedSignAccLog(redTableInfo.ID, 5)
            if redSignData.OnRedSignShow then
                redSignData.OnRedSignShow(redSignTemplate, redTableInfo, redCounts)
            end
        else
            logError("此红点有问题,gameObject已经被销毁，key：" .. redSignData.Key)
        end
    end)

end

--添加检测方法
function AddCheckMethod(key, checkMethod)

    _fillCheckMethodData(key, checkMethod, 0)
    UpdateRedSign(key)

end

--把检测方法等一系列数据添加进去
function _fillCheckMethodData(key, checkMethod, redCount)

    local l_checkMethodData = {}
    l_checkMethodData.checkMethod = checkMethod         --检测方法，当红点的数据为服务器控制时为空
    l_checkMethodData.isInQueue = false
    l_checkMethodData.redSignCount = redCount               --检测方法返回值（整数，决定了绑定该检测方法的红点的显示数量）
    _redCheckMethodDatas[key] = l_checkMethodData

end

--显示红点
--当此红点状态改变时会改变关联系统的状态，数据也会相应改变
function ShowRedSign(key, redCount)

    local l_redTableInfo = TableUtil.GetRedDotCheckTable().GetRowByID(key)
    if l_redTableInfo == nil then
        return
    end
    _showFunctionRedSign(l_redTableInfo, redCount)

end

--显示当前系统的红点
function _showFunctionRedSign(redTableInfo, redCount)

    local l_key = redTableInfo.ID
    --数据已经在队列了，并且还没有被处理，等待处理
    if _redCheckMethodDatas[l_key].isInQueue then
        return
    end
    --如果没有传递红点个数，使用现在的数据进行显示
    if redCount == nil then
        redCount = _redCheckMethodDatas[l_key].redSignCount
    end
    local l_redTableInfo = TableUtil.GetRedDotCheckTable().GetRowByID(l_key)
    if not _isConformShowRule(l_redTableInfo, _redCheckMethodDatas[l_key].checkData) then
        redCount = 0
    end

    UpdateRedSignTree(l_key, redCount)
    _redCheckMethodDatas[l_key].redSignCount = redCount

end

function IsRedSignShow(key)

    if _redCheckMethodDatas[key] == nil then
        local l_redSign = TableUtil.GetRedDotIndex().GetRowByID(key)
        if l_redSign == nil then
            logError("即没有此红点数据，也可能没有此检测方法数据，id = ", key)
            return
        end
        for j = 1, l_redSign.CheckID.Length do
            local l_id = l_redSign.CheckID[j - 1]
            _updateRedSignQueueImmediateWithKey(l_id)       --为了保证取得数据是对的，需要对该红点的所有检测方法进行一次更新
        end
        if RedSignTree[key].count <= 0 then
            return false
        end
    else
        _updateRedSignQueueImmediateWithKey(key)        --为了保证取得数据是对的，需要进行一次更新
        if RedSignTree[key].count <= 0 then
            return false
        end
    end
    return true

end

--更新队列，添加到队列中的数据会进行更新
local _updateKeysQueue = {}
--更新检测方法
--此方法会把需要更新的红点或检测方法注册进更新队列，并不会立刻更新
--允许设置额外数据，其中一些自带参数如下：
--ignoreLimit：是否无视RedDotCheckLimit下的等级限制和功能限制
function UpdateRedSign(key, checkData)

    if key == nil then
        logError("更新红点传入的key为空！")
        return
    end

    if TableUtil.GetRedDotCheckTable().GetRowByID(key, true) == nil then
        --如果传入的不是检测方法，则说明传入的可能是红点，则遍历检测当前红点的所有检测方法
        _CheckAllRedSignMethod(key, checkData)
    else
        _updateRedSignCheckMethod(key, checkData)
    end

end

function _CheckAllRedSignMethod(key, checkData, deep)

    local l_redSign = TableUtil.GetRedDotIndex().GetRowByID(key)
    if l_redSign == nil then
        logError("即没有此红点数据，也可能没有此检测方法数据，id = ", key)
        return
    end
    if deep == nil then
        deep = 0
    end
    if deep > 8 then
        logError("递归深度过深！请检查配置中是否配置了环形的配置关系，又或者父子关系过于复杂，深度允许：<= 8")
        return
    end
    --如果是服务器控制的红点
    if l_redSign.Type then
        if RedSignExCount[key] == nil then
            RedSignExCount[key] = 0
        end
        UpdateRedSignTree(key, RedSignExCount[key], true)
    else
        for j = 1, l_redSign.CheckID.Length do
            local l_id = l_redSign.CheckID[j - 1]
            _updateRedSignCheckMethod(l_id, checkData)
        end
        for j = 1, l_redSign.ChildrenID.Length do
            local l_id = l_redSign.ChildrenID[j - 1]
            _CheckAllRedSignMethod(l_id, checkData, deep + 1)
        end
    end

end

--这里传入的key只能是检测方法
function _updateRedSignCheckMethod(key, checkData)

    if _redCheckMethodDatas[key] == nil or _redCheckMethodDatas[key].checkMethod == nil then
        --logYellow("当前检测方法没有数据，可能是刚玩家数据还未被初始化，ID：", key)
        return
    end
    _redCheckMethodDatas[key].isInQueue = true
    if checkData ~= nil then
        _redCheckMethodDatas[key].checkData = checkData
    end
    if not table.ro_contains(_updateKeysQueue, key) then
        table.insert(_updateKeysQueue, key)
    end

end

--立即更新
--取更新队列中相应key的红点数据进行更新
function _updateRedSignQueueImmediateWithKey(key)

    if not table.ro_contains(_updateKeysQueue, key) then
        return
    end
    table.ro_removeValue(_updateKeysQueue, key)
    _updateRedSignQueueImmediate(key)

end

--立即更新
--取更新队列中相应index的key进行更新
function _updateRedSignQueueImmediateWithIndex(index)

    if index <= 0 or index > #_updateKeysQueue then
        return
    end
    local l_key = _updateKeysQueue[index]
    table.remove(_updateKeysQueue, index)
    _updateRedSignQueueImmediate(l_key)

end

--更新相应key的检测方法数据
function _updateRedSignQueueImmediate(key)

    if _redCheckMethodDatas[key] == nil then
        logError("更新相应key的红点数据时失败，没有添加检测方法数据Key：" .. tostring(key))
        return
    end
    if _redCheckMethodDatas[key].isInQueue then
        local l_redCount = _callCheckMethod(key)
        _redCheckMethodDatas[key].isInQueue = false
        ShowRedSign(key, l_redCount)
    end

end

--调用检测方法，只有此处唯一一个调用的地方
function _callCheckMethod(key)

    if _redCheckMethodDatas[key].checkMethod == nil then
        logError("需要更新的红点没有检测方法，请查看是否有问题，key：" .. tostring(key))
        return 0
    end
    local l_redCount = _redCheckMethodDatas[key].checkMethod(_redCheckMethodDatas[key].checkData)
    _redCheckMethodDatas[key].checkData = nil
    return l_redCount

end

--获取需要更新的红点的个数
function GetNeedUpdateCount()
    return #_updateKeysQueue
end

function GetNeedUpdateRedSign()
    return _updateKeysQueue
end
----------------------------
--判断当前系统是否符合显示规则
function _isConformShowRule(redTableInfo, extraData)

    if extraData ~= nil and extraData.ignoreLimit then
        return true
    end
    local openSystemMgr = MgrMgr:GetMgr("OpenSystemMgr")
    if redTableInfo.OpenSystemID ~= 0 then
        if not openSystemMgr.IsSystemOpen(redTableInfo.OpenSystemID) then
            return false
        end
    end

    if redTableInfo.LevelCheck ~= nil then
        local l_Pass = false
        local l_levelData = Common.Functions.VectorSequenceToTable(redTableInfo.LevelCheck)
        for i, v in ipairs(l_levelData) do
            if v[1] ~= 0 then
                if #v ~= 3 or v[1] >= v[3] or v[2] == 0 then
                    logError("RedDotCheckTable 中 LevelCheck 的配置不正确，左闭右开，且第二个参数不能为0，请检查，id = ", redTableInfo.ID)
                    return false
                end
                local l_minLevel, l_skipLevel, l_maxLevel = v[1], v[2], v[3]
                if MPlayerInfo.Lv >= l_minLevel and MPlayerInfo.Lv < l_maxLevel and (MPlayerInfo.Lv - l_minLevel) % l_skipLevel == 0 then
                    l_Pass = true
                end
            end
        end
        if #l_levelData > 0 and (not l_Pass) then
            if redTableInfo.ID == 1 then
                return false
            end
        end
    end
    return true

end

--表规则相关
--用来执行检测的定时器
local _timer
--时间检测，保证一次循环用时不要太多
local _timeChecker = MoonClient.TimeChecker.New(500000)
function _updateRedSignQueueOnTimer()
    local l_index = #_updateKeysQueue
    if l_index <= 0 then
        return
    end
    if UpdateDelay > 0 then
        UpdateDelay = UpdateDelay - 1
    else
        _timeChecker:Start()
        while l_index > 0 and (not _timeChecker:IsBeyondGivenTime()) do
            _updateRedSignQueueImmediateWithIndex(l_index)
            l_index = l_index - 1
        end
    end
end

function _updateRedSignQueueOnTimerPCall()
    PCallAndDebug(_updateRedSignQueueOnTimer)
end

function OnInit()
    
    _InitRedSign()
    _timer = Timer.New(_updateRedSignQueueOnTimerPCall, 0.3, -1, true)
    _timer:Start()

    ---@type CommonMsgProcessor
    local l_commonData = Common.CommonMsgProcessor.new()
    local l_data = {}
    table.insert(l_data, {
        ModuleEnum = CommondataType.kCDT_RED_POINT,
        Callback = OnRedPointCommonData,
    })

    l_commonData:Init(l_data)

end

function OnUnInit()

    if _timer then
        _timer:Stop()
        _timer = nil
    end

end

function OnLogout()

    --当登出游戏的时候把所有的红点都设成隐藏
    for i, data in pairs(_redSignData) do
        if #data > 0 then
            local l_redCounts = {}
            table.insert(l_redCounts, 0)
            local l_redTableInfo = TableUtil.GetRedDotIndex().GetRowByID(data[1].Key)
            _showTemplatesRedSignWithTableInfo(data, l_redTableInfo, l_redCounts)
        end
    end
    _updateKeysQueue = {}
    _redCheckMethodDatas = {}
    _onceData = {}
    RedSignExCount = {}
    _InitRedSign()
    UpdateDelay = 3

end
--MgrMgr

-------------------------------------------------协议相关---------------------------------------------------
_onceData = {}
function SetRedPointCommonData(key, value)

    _onceData[key] = _onceData[key] or false
    if _onceData[key] ~= value then
        _onceData[key] = value
        ---@type SetRedPointCommonDataArg
        local l_sendInfo = GetProtoBufSendTable("SetRedPointCommonDataArg")
        l_sendInfo.key = key
        l_sendInfo.value = value
        Network.Handler.SendRpc(Network.Define.Rpc.SetRedPointCommonData, l_sendInfo)
    end

end

function GetRedPointCommonDataResult(msg)

    ---@type SetRedPointCommonDataRes
    local l_resInfo = ParseProtoBufToTable("SetRedPointCommonDataRes", msg)
    if l_resInfo.error_code ~= 0 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_resInfo.error_code))
    end

end

function OnRedPointCommonData(key, value)
    _onceData[key] = value
end

return ModuleMgr.RedSignMgr
