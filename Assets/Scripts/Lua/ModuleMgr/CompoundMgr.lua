-- 合成mgr
---@module CompoundMgr
module("ModuleMgr.CompoundMgr", package.seeall)

AwardItems = {}
CurIndex = 0
Type = {}
ShowTypes = {}

function GetTypeForShowIndex(index)
    return index
end

------------------------------------生命周期
function OnInit()
    Type = {}
    Type["All"] = 0
    ShowTypes[1] = Lang("AllText")

    local l_rows = TableUtil.GetComposeClassifyTable().GetTable()
    for i = 1, #l_rows do
        local l_row = l_rows[i]
        ShowTypes[i + 1] = l_row.ComposeClassifyName
        Type["Ele" .. tostring(i)] = i
    end
end

------------------------------------协议
--发送合成请求
function SendCompound(items)
    local l_msgId = Network.Define.Rpc.EquipCompound
    ---@type EquipCompoundArg
    local l_sendInfo = GetProtoBufSendTable("EquipCompoundArg")
    for i = 1, #items do
        ---@type ItemData
        local l_curitem = items[i]
        local l_dataItem = l_sendInfo.uid_items:add()
        l_dataItem.item_uid = l_curitem.uid
        l_dataItem.item_count = MLuaCommonHelper.Int(l_curitem.num)
    end
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

--接收协议返回
function OnEquipCompound(msg, arg)
    ---@type EquipCompoundRes
    local l_resInfo = ParseProtoBufToTable("EquipCompoundRes", msg)
    MgrMgr:GetMgr("ComErrorCodeMgr").ShowMarkedWords(l_resInfo.result)
end

--道具改变信息
function OnItemChange(info)
    if info.reason ~= ItemChangeReason.ITEM_REASON_EQUIP_COMPOUND then
        return
    end
end

function GetCanCompoundPropCount(id)
    local l_types = {
        GameEnum.EBagContainerType.Bag
    }
    local l_itemFuncUtil = MgrProxy:GetItemDataFuncUtil()
    ---@type FiltrateCond
    local condition = { Cond = l_itemFuncUtil.IsItemCanCompound }
    local condition1 = {  Cond = l_itemFuncUtil.ItemMatchesTid, Param = id  }
    local conditions = { condition,condition1 }
    ---@return ItemData[]
    local l_retItemDatas = Data.BagApi:GetItemsByTypesAndConds(l_types, conditions)
    local l_propCount = 0
    for i = 1, #l_retItemDatas do
        l_propCount = l_propCount + l_retItemDatas[i].ItemCount
    end
    return l_propCount
end

---@param row ComposeTable
function CheckCanCompoundByCost(row)
    for i = 0, row.Cost.Count-1 do
        v = row.Cost[i]
        local id = v[0]
        local num = v[1]
        local has = tonumber(Data.BagModel:GetCoinOrPropNumById(id))
        if num > has then
            return false
        end
    end
    return true
end

function GetCanCompoundPropList(PropIds)
    local l_types = {
        GameEnum.EBagContainerType.Bag
    }
    local l_itemFuncUtil = MgrProxy:GetItemDataFuncUtil()
    ---@type FiltrateCond
    local condition = { Cond = l_itemFuncUtil.IsItemCanCompound }
    local condition1 = { Cond = l_itemFuncUtil.ItemMatchesMultiTid, Param =  PropIds  }
    local conditions = { condition,condition1 }
    ---@return ItemData[]
    local l_retItemDatas = Data.BagApi:GetItemsByTypesAndConds(l_types, conditions)
    return l_retItemDatas
end