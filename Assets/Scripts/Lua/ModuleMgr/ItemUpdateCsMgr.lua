--- 标注一下，监听道具变化数据时，希望调用一些CS的接口
--- 这个文件职责便是整合这些功能的入口，将逻辑判断做好，CS当中只负责单纯显示的一些入口

---@module ModuleMgr.ItemUpDataCsMgr
module("ModuleMgr.ItemUpdateCsMgr", package.seeall)

function OnInit()
    local gameEventMgr = MgrMgr:GetMgr("GameEventMgr")
    gameEventMgr.Register(gameEventMgr.OnBagUpdate, _onItemUpdate)
end

---@param updateDataList ItemUpdateData[]
function _onItemUpdate(updateDataList)
    local funcMap = {
        _jumpWordOnBaseExp,
        _jumpWordOnJobExp,
        _createDropEntities,
        _showCollection,
        _showFish,
    }

    for i = 1, #updateDataList do
        local singleUpDataList = updateDataList[i]
        for key, singleFunc in pairs(funcMap) do
            singleFunc(singleUpDataList)
        end
    end
end

---@param updateData ItemUpdateData
function _jumpWordOnBaseExp(updateData)
    local C_VALID_REASON_MAP = {
        [ItemChangeReason.ITEM_REASON_EXP_BLESS] = 1,
        [ItemChangeReason.ITEM_REASON_EXP_HEALTH] = 1,
        [ItemChangeReason.ITEM_REASON_PICK_UP_EXP] = 1,
        [ItemChangeReason.ITEM_REASON_PICK_UP] = 1,
        [ItemChangeReason.ITEM_REASON_HEALTH_QUICKLY] = 1,
        [ItemChangeReason.ITEM_REASON_DABAO_CANDY ] = 1,
    }

    if nil == C_VALID_REASON_MAP[updateData.Reason] then
        return
    end

    local EVirtualItemType = GameEnum.l_virProp
    local itemCompareData = updateData:GetItemCompareData()
    if EVirtualItemType.exp == itemCompareData.id and 0 < itemCompareData.count then
        MoonClient.MLuaItemInterfaces.JumpWordOnBaseValue(itemCompareData.count)
    end
end

---@param updateData ItemUpdateData
function _jumpWordOnJobExp(updateData)
    local C_VALID_REASON_MAP = {
        [ItemChangeReason.ITEM_REASON_EXP_BLESS] = 1,
        [ItemChangeReason.ITEM_REASON_EXP_HEALTH] = 1,
        [ItemChangeReason.ITEM_REASON_PICK_UP_EXP] = 1,
        [ItemChangeReason.ITEM_REASON_PICK_UP] = 1,
        [ItemChangeReason.ITEM_REASON_HEALTH_QUICKLY] = 1,
        [ItemChangeReason.ITEM_REASON_DABAO_CANDY ] = 1,
    }

    if nil == C_VALID_REASON_MAP[updateData.Reason] then
        return
    end

    local EVirtualItemType = GameEnum.l_virProp
    local itemCompareData = updateData:GetItemCompareData()
    if EVirtualItemType.jobExp == itemCompareData.id and 0 < itemCompareData.count then
        MoonClient.MLuaItemInterfaces.JumpWordOnJobExp(itemCompareData.count)
    end
end

---@param updateData ItemUpdateData
function _showCollection(updateData)
    local C_VALID_REASON_MAP = {
        [ItemChangeReason.ITEM_REASON_COLLECT_GARDEN] = 1,
        [ItemChangeReason.ITEM_REASON_COLLECT_MINING] = 1,
        [ItemChangeReason.ITEM_REASON_COLLECT_FOOD] = 1,
        [ItemChangeReason.ITEM_REASON_COLLECT_MEDICINE] = 1,
        [ItemChangeReason.ITEM_REASON_COLLECT_DESSERT] = 1,
        [ItemChangeReason.ITEM_REASON_COLLECT_SMELT] = 1,
        [ItemChangeReason.ITEM_REASON_COLLECT_FISHING] = 1,
    }

    if nil == C_VALID_REASON_MAP[updateData.Reason] then
        return
    end

    MoonClient.MLuaItemInterfaces.SendCollectionEvent()
end

---@param updateData ItemUpdateData
function _createDropEntities(updateData)
    if ItemChangeReason.ITEM_REASON_DUNGEONS_RESULT ~= updateData.Reason then
        return
    end

    local itemCompareData = updateData:GetItemCompareData()
    if 0 >= itemCompareData.count then
        return
    end

    local C_EXP_MAP = {
        [GameEnum.l_virProp.exp] = 1,
        [GameEnum.l_virProp.jobExp] = 1,
    }

    --- 如果是这个货币，不创建entity
    if MgrMgr:GetMgr("PropMgr").IsVirtualCoin(itemCompareData.id) or nil ~= C_EXP_MAP[itemCompareData.id] then
        return
    end

    --- 这个地方参数需要int
    local num1, num2 = tonumber(itemCompareData.count)
    MoonClient.MLuaItemInterfaces.CreateDropItemEntities(itemCompareData.id, num1)
end

---@param updateData ItemUpdateData
function _showFish(updateData)
    if ItemChangeReason.ITEM_REASON_COLLECT_FISHING ~= updateData.Reason then
        return
    end

    local itemCompareData = updateData:GetItemCompareData()
    if 0 >= itemCompareData.count then
        return
    end

    local bigFish = false
    local fishTableData = TableUtil.GetFishTable().GetRowByID(itemCompareData.id, true)
    if nil ~= fishTableData and GameEnum.EFishGradeDefine.FISH_GRADE_XL == fishTableData.Grade then
        bigFish = true
    end

    MoonClient.MLuaItemInterfaces.SendBigFishEvent(bigFish)
end

return ModuleMgr.ItemUpdateCsMgr