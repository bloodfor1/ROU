---@module ModuleMgr.MedalMgr
module("ModuleMgr.MedalMgr", package.seeall)

---------------事件相关---------------------
EventDispatcher = EventDispatcher.new()
MEDAL_STATE_UPGRADE = "MEDAL_STATE_UPGRADE"
MEDAL_TIP_SHOW_HELP = "MEDAL_TIP_SHOW_HELP"
MEDAL_STATE_ADVANCE = "MEDAL_STATE_ADVANCE"
MEDAL_GLORY_UPGRADE = "MEDAL_GLORY_UPGRADE"
---------------事件相关---------------------

--缓存一个MedalData的引用
local l_medalData = DataMgr:GetData("MedalData")

function OnSelectRoleNtf(info)
    l_medalData.SelectRolePbParse(info)
end

function OnReconnected(reconnectData)
    
end

--------------------------------------------勋章协议--Start------------------------------

--请求操作勋章
-- totalCost isNotCheck 为快捷付费数据可不传
function RequestMedalOperate(medalType, opType, medalId, resetAttrPos,optimes,totalCost,isNotCheck)

    if totalCost and totalCost > 0 then
        if optimes and optimes ~= 1 then
            totalCost =  totalCost * optimes
        end
        local _,l_needNum = Common.CommonUIFunc.ShowCoinStatusText(GameEnum.l_virProp.Coin101,totalCost)
        if l_needNum > 0 and not isNotCheck then
            MgrMgr:GetMgr("CurrencyMgr").ShowQuickExchangePanel(GameEnum.l_virProp.Coin101,l_needNum,function ()
                RequestMedalOperate(medalType, opType, medalId, resetAttrPos,optimes,totalCost,true)
            end)
            return
        end
    end

    local l_msgId = Network.Define.Rpc.MedalOp
    ---@type MedalOpArg
    local l_sendInfo = GetProtoBufSendTable("MedalOpArg")
    l_sendInfo.medal_type = medalType
    l_sendInfo.op_type = opType
    l_sendInfo.medal_id = medalId
    l_sendInfo.reset_attr_pos = resetAttrPos
    l_sendInfo.op_times = optimes or 1
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

--返回操作勋章
function ResponseMedalOperate(msg, arg)
    ---@type MedalOpRes
    local l_info = ParseProtoBufToTable("MedalOpRes", msg)
    if l_info.result == 0 then
        local medalData = l_info.changed_medals
        local medalOperate = arg.op_type
        local isUpgrade = false
        local isGloryLevelUp = false
        local isGloryMedalUpgrade = false
        if medalData.medal_type then
            if medalOperate == l_medalData.EMedalOperate.Upgrade then
                --重新计算总光辉勋章等级
                if medalData.medal_type == 1 then
                    if l_medalData.medalAllTable[medalData.medal_type][medalData.medal_id].level ~= medalData.level then
                        isGloryLevelUp = true
                    end
                end
            end
            --勋章数据处理
            l_medalData.MedalOperatePbParse(l_info,arg)
            medalData = l_medalData.medalAllTable[medalData.medal_type][medalData.medal_id]
            if medalOperate == l_medalData.EMedalOperate.Activate then
                --抛出激活勋章的动画事件
                EventDispatcher:Dispatch(MEDAL_STATE_ADVANCE, medalData)
            elseif medalOperate == l_medalData.EMedalOperate.Upgrade then
                --升级
                isUpgrade = true
                if medalData.type == 1 then
                    isGloryMedalUpgrade = true
                elseif medalData.type == 2 then
                    --神圣勋章激活
                    if medalData.level == 1 then
                        isUpgrade = false
                    --神圣勋章升级
                    else
                        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(StringEx.Format(Common.Utils.Lang("MEDAL_HOLY_MEDAL_UPLEVEL"), medalData.Name, medalData.level))
                    end
                end
            elseif medalOperate == l_medalData.EMedalOperate.Reset then
                --神圣勋章属性位置
                if not isUpgrade then
                    MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("MEDAL_HOLY_RESET_SUCCESS"))
                end
            end
        else
            medalData = nil
        end

        --晋升刷新 只有在晋升刷新的时候不会关闭TIP
        if isGloryMedalUpgrade then
            local prestigeItemData = TableUtil.GetItemTable().GetRowByItemID(402)
            local prestigeStr = StringEx.Format(Common.Utils.Lang("RICH_IMAGE"), tostring(prestigeItemData.ItemIcon), tostring(prestigeItemData.ItemAtlas), 20, 1)
            local showStr = StringEx.Format(Common.Utils.Lang("MEDAL_GLORY_MEDAL_GET_PRESTIGE"), medalData.Name, prestigeStr, l_info.add_prestige)
            if l_info.extra_prestige ~= 0 then
                showStr = showStr..StringEx.Format(Common.Utils.Lang("MEDAL_GLORY_MEDAL_EX_PRESTIGE"), prestigeStr, l_info.extra_prestige)
            end
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(showStr)
            EventDispatcher:Dispatch(MEDAL_GLORY_UPGRADE, medalData, isGloryLevelUp)
            local val = Common.Serialization.LoadData("MEDALTIPS", MPlayerInfo.UID:tostring())
            if val == nil then
                Common.Serialization.StoreData("MEDALTIPS", 1, MPlayerInfo.UID:tostring())
            end
        else--关闭Tips
            if UIMgr:IsActiveUI(UI.CtrlNames.MedalTips) then
                UIMgr:DeActiveUI(UI.CtrlNames.MedalTips)
            end
        end

        if isUpgrade then
            EventDispatcher:Dispatch(MEDAL_STATE_UPGRADE, medalData)
        end
    else
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.result))
    end
end

--请求服务器加成
function RequestMedalPrestigeAddition(medalId)
    local l_msgId = Network.Define.Rpc.GetPrestigeAddition
    ---@type GetPrestigeAdditionArg
    local l_sendInfo = GetProtoBufSendTable("GetPrestigeAdditionArg")
    l_sendInfo.role_uid = tostring(MPlayerInfo.UID)
    l_sendInfo.medal_id = medalId
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

--获取服务器加成
function ResponseMedalPrestigeAddition(msg, arg)
    ---@type GetPrestigeAdditionRes
    local l_info = ParseProtoBufToTable("GetPrestigeAdditionRes", msg)
    if l_info.result == 0 then
        EventDispatcher:Dispatch(MEDAL_TIP_SHOW_HELP, l_info.prestige_addition)
    else
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.result))
    end
end

--收取勋章变化
function ResponseMedalChangedNotify(msg)
    ---@type MedalChangedData
    local l_info = ParseProtoBufToTable("MedalChangedData", msg)
    local medalData = l_medalData.MedalChangedNtfPbParse(l_info)
    --提示 1勋章被集火 2升级了 3 升级满了 4激活进度变了
    if l_info.change_type == 1 then
        EventDispatcher:Dispatch(MEDAL_STATE_UPGRADE, l_medalData.medalAllTable[medalData.medal_type][medalData.medal_id])
    elseif l_info.change_type == 2 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(StringEx.Format(Common.Utils.Lang("MEDAL_GLORY_MEDAL_UPLEVEL"), l_medalData.medalAllTable[medalData.medal_type][medalData.medal_id].Name, medalData.level))
    elseif l_info.change_type == 3 then
        CommonUI.Dialog.ShowYesNoDlg(true, nil, Common.Utils.Lang("MEDAL_GLORY_LEVEL_FILL"), function()
            UIMgr:ActiveUI(UI.CtrlNames.Medal)
        end, function() end)
    elseif l_info.change_type == 4 then
        EventDispatcher:Dispatch(MEDAL_STATE_UPGRADE, l_medalData.medalAllTable[medalData.medal_type][medalData.medal_id])
    end
end

--------------------------------------------勋章协议--End----------------------------------

--------------------------------------------对外提供勋章相关逻辑接口--Start------------------------------

--二次确认操作勋章Dlg接口
function ShowMedalOperateDlg(medalType, opType, medalData, resetAttrPos,titleTxt)
    --提示文字
    local tipStr = ""
    --是否显示选框
    local togType
    --指定重置方法
    local onConfirmOther
    --消耗物品
    local consume = {{
        IsShowCount = false,
        IsShowRequire = true,
    }}
    --选项二提示文字
    local tipOtherStr
    --指定重置消耗物品
    local consumeOther
    --选项一文字
    local togOneStr
    --选项二文字
    local togTwoStr
    if opType == l_medalData.EMedalOperate.Activate then
        tipStr = Common.Utils.Lang("MEDAL_DLG_ACTIVATE")
        tipOtherStr = Common.Utils.Lang("MEDAL_DLG_ACTIVATE_SPECIFIC")
        togOneStr = Common.Utils.Lang("MEDAL_DLG_RESET_TIP_RANDOM")
        togTwoStr = Common.Utils.Lang("MEDAL_DLG_RESET_TIP_SPECIFIC")
        consume[1].ID = medalData.ActiviteConsume[0][0]
        consume[1].RequireCount = medalData.ActiviteConsume[0][1]
        consume = {{
            ID = medalData.ActiviteConsume[0][0],
            RequireCount = medalData.ActiviteConsume[0][1],
            IsShowCount = false,
            IsShowRequire = true,
        }}
        consumeOther = {{
            ID = medalData.ActiviteConsume[1][0],
            RequireCount = medalData.ActiviteConsume[1][1],
            IsShowCount = false,
            IsShowRequire = true,
        }}
        onConfirmOther = function()
            local l_medalOpenData = 
            {
                openType = l_medalData.EMedalOpenType.ChooseMedalAttr,
                medalData = medalData,
                stateNum = 4
            }
            UIMgr:ActiveUI(UI.CtrlNames.MedalTips,l_medalOpenData)
        end
    elseif opType == l_medalData.EMedalOperate.Reset then
        tipStr = Common.Utils.Lang("MEDAL_DLG_RESET")
        tipOtherStr = Common.Utils.Lang("MEDAL_DLG_RESET_SPECIFIC")
        togOneStr = Common.Utils.Lang("MEDAL_DLG_RESET_TIP_RANDOM")
        togTwoStr = Common.Utils.Lang("MEDAL_DLG_RESET_TIP_SPECIFIC")
        for k=0, medalData.RebornConsume.Length-1 do
            if medalData.RebornConsume[k][0] == 1 then
                consume[1].ID = medalData.RebornConsume[k][1]
                consume[1].RequireCount = medalData.RebornConsume[k][2]
            elseif medalData.RebornConsume[k][0] == 2 then
                consumeOther = {{
                    ID = medalData.RebornConsume[k][1],
                    RequireCount = medalData.RebornConsume[k][2],
                    IsShowCount = false,
                    IsShowRequire = true,
                }}
            end
        end
        onConfirmOther = function()
            local l_medalOpenData = 
            {
                openType = l_medalData.EMedalOpenType.ChooseMedalAttr,
                medalData = medalData,
                stateNum = 3
            }
            UIMgr:ActiveUI(UI.CtrlNames.MedalTips,l_medalOpenData)
        end
    elseif opType == l_medalData.EMedalOperate.Upgrade then
        tipStr = Common.Utils.Lang("MEDAL_DLG_UPGRADE")
        consume[1].ID = medalData.Consume[medalData.level-1][0]
        consume[1].RequireCount = medalData.Consume[medalData.level-1][1]
    end
    --确定
    local onConfirm = function()
        RequestMedalOperate(medalType, opType, medalData.MedalId, resetAttrPos)
    end

    CommonUI.Dialog.ShowConsumeChooseDlg(tipStr, tipOtherStr, nil, onConfirm, onConfirmOther, consume, consumeOther, togOneStr, togTwoStr,titleTxt)
end

--获取当前位置的完成状态
function GetMedalActiveState(activeProgress,pos)
    if activeProgress == nil then
        return
    end
    local stateString = MLuaCommonHelper.GetBinaryString(activeProgress)
    if string.len(stateString) < pos then
        return 0
    end
    local state = string.sub(stateString, string.len(stateString)-pos,string.len(stateString)-pos)
    return state
end

--获取当前位置的神圣勋章是否可激活
function CheckMedalState(activeProgress,length)
    if activeProgress == nil then
        return false
    end

    local stateString = MLuaCommonHelper.GetBinaryString(activeProgress)
    local finishString = ""
    for i = 1, length do
        finishString = finishString.."1"
    end

    if finishString == stateString then
        return true
    end
    return false
end

--是否推荐勋章 给死亡引导提供接口
function GetIsRecommendMedal( ... )
    local serverDay = MgrMgr:GetMgr("RoleInfoMgr").SeverLevelData.serverDay or 4
    if serverDay > TableUtil.GetServerLvTable().GetTableSize() then
        serverDay = TableUtil.GetServerLvTable().GetTableSize()
    end
    local nowData = TableUtil.GetServerLvTable().GetRowByDay(serverDay,true)
    if nowData and l_medalData.medalAllTable[2] then
        for k, v in pairs(l_medalData.medalAllTable[2]) do
            if v.level < nowData.Lv then
                return true
            end
        end
    end
    return false
end

--根据勋章数据 获取勋章的激活等级
function GetMedalActiveLevel(medalData)
    if medalData and medalData.Activition then
        for k=0,medalData.Activition.Length-1 do
            local activateData = medalData.Activition[k]
            if activateData[0] == 2 then
                return activateData[1]
            end
        end
    end
    return 0
end

function ReInintGloaryData(medalData)
    l_medalData.ReInintGloaryData(medalData)
end

--------------------------------------------对外读取勋章数据的接口--End----------------------------------

--------------------------------------------对外修改勋章数据的接口--Start--------------------------
--存储激活神圣勋章的Image
function SetMedalAdvanceImage(image)
    l_medalData.medalAdvanceImage = image
end
--------------------------------------------对外读取勋章数据的接口--End---------------------------------

return ModuleMgr.MedalMgr