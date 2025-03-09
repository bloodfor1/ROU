--- 这个文件是一个助手引导系统，负责监听玩家装备状态发生变化时，进行一些处理
--- 结构上是有操作，验证节点和行为节点三种
---@module ModuleMgr.EquipAssistGuideMgr
module("ModuleMgr.EquipAssistGuideMgr", package.seeall)

function OnInit()
    local gameEventMgr = MgrMgr:GetMgr("GameEventMgr")
    gameEventMgr.Register(gameEventMgr.OnBagUpdate, _onUpdateItem)
end

function OnUninit()
    local gameEventMgr = MgrMgr:GetMgr("GameEventMgr")
    gameEventMgr.UnRegister(gameEventMgr.OnBagUpdate, _onUpdateItem)
end

--- 这里会判断一个状态，状态和状态之间是无关的互斥的；
--- 还会同时返回两个道具数据，两个道具数据表示的含义在不同的目的函数当中会有区别
---@param itemUpdateDataList ItemUpdateData[]
function _onUpdateItem(itemUpdateDataList)
    if nil == itemUpdateDataList then
        logError("[EquipAssistGuide] invalid param")
        return
    end

    local opType, itemLeft, itemRight = _validateState(itemUpdateDataList)
    local opStepType = _launchOperation(opType, itemLeft, itemRight)
    _executeStep(opStepType, itemLeft, itemRight)
end

--- 验证操作的总入口，对于后面的东西能够进行验证
---@param itemUpdateDataList ItemUpdateData[]
---@return number, ItemData, ItemData
function _validateState(itemUpdateDataList)
    local E_OP_TYPE = GameEnum.EEquipEnhanceGuideType
    local C_FUNC_MAP = {
        _onSwitchEquip,
        _onRefineTransfer,
        _onEnchantExtracted,
        _onEnchantInherited,
    }

    for i = 1, #C_FUNC_MAP do
        local func = C_FUNC_MAP[i]
        local opType, itemLeft, itemRight = func(itemUpdateDataList)
        if E_OP_TYPE.Fault ~= opType then
            return opType, itemLeft, itemRight
        end
    end

    return E_OP_TYPE.Fault, nil, nil
end

--- 验证操作结束之后进入实际操作的总入口
---@param itemDataLeft ItemData
---@param itemDataRight ItemData
function _launchOperation(opType, itemDataLeft, itemDataRight)
    local E_STEP_TYPE = GameEnum.EEquipEnhanceStepType
    if nil == opType then
        logError("[EquipAssist] invalid param")
        return E_STEP_TYPE.Fault
    end

    --  战斗状态下不会进行验证
    if MEntityMgr.PlayerEntity and MEntityMgr.PlayerEntity.InBattle then
        return E_STEP_TYPE.Fault
    end

    local E_OP_TYPE = GameEnum.EEquipEnhanceGuideType
    local C_TYPE_FUNC_MAP = {
        [E_OP_TYPE.SwitchEquip] = {
            _canGotoRefineTrans,
            _canGotoEnchantInherit,
            _canGotoEnchantExtract,
            _canGotoRemoveCard,
        },
        [E_OP_TYPE.RefineTransfer] = {
            _canGotoEnchantInherit,
            _canGotoEnchantExtract,
            _canGotoRemoveCard,
        },
        [E_OP_TYPE.EnchantInherit] = {
            _canGotoRemoveCard,
        },
        [E_OP_TYPE.EnchantExtract] = {
            _canGotoRemoveCard,
        },
    }

    local targetFuncList = C_TYPE_FUNC_MAP[opType]
    if nil == targetFuncList then
        return E_STEP_TYPE.Fault
    end

    for i = 1, #targetFuncList do
        local singleFunc = targetFuncList[i]
        local ret = singleFunc(itemDataLeft, itemDataRight)
        if E_STEP_TYPE.Fault ~= ret then
            return ret
        end
    end

    return E_STEP_TYPE.Fault
end

---@param itemLeft ItemData
---@param itemRight ItemData
function _executeStep(stepType, itemLeft, itemRight)
    if nil == stepType then
        logError("[EquipAssist] invalid param")
        return
    end

    local E_STEP_TYPE = GameEnum.EEquipEnhanceStepType
    local C_OPERATION_MAP = {
        [E_STEP_TYPE.RefineTransfer] = _gotoRefineTrans,
        [E_STEP_TYPE.EnchantInherit] = _gotoEnchantInherit,
        [E_STEP_TYPE.EnchantExtract] = _gotoEnchantExtract,
        [E_STEP_TYPE.RemoveCard] = _gotoRemoveCard,
    }

    local targetFunc = C_OPERATION_MAP[stepType]
    if nil == targetFunc then
        return
    end

    targetFunc(itemLeft, itemRight)
end

--- 如果进行的是装备替换操作，则这个时候判断是可以进行下一步引导的
--- 对服务器消息格式有依赖
---@param itemUpdateDataList ItemUpdateData[]
---@return number, ItemData, ItemData
function _onSwitchEquip(itemUpdateDataList)
    local E_BAG_CONT_TYPE = GameEnum.EBagContainerType
    local E_OP_TYPE = GameEnum.EEquipEnhanceGuideType
    ---@type ItemData
    local oldEquip = nil
    ---@type ItemData
    local newEquip = nil

    --- 用来计算双天赋同槽位上旧数据的
    ---@type ItemData
    local preSlotEquip = nil

    --- 如果是双天赋切换，这个时候会一下发很多变化数据，这个时候不处理
    if 2 < #itemUpdateDataList then
        return E_OP_TYPE.Fault, nil, nil
    end

    for i = 1, #itemUpdateDataList do
        local singleItemData = itemUpdateDataList[i]
        if E_BAG_CONT_TYPE.Bag == singleItemData.NewContType and E_BAG_CONT_TYPE.Equip == singleItemData.OldContType then
            oldEquip = singleItemData.NewItem
            preSlotEquip = singleItemData.OldItem
        elseif E_BAG_CONT_TYPE.Bag == singleItemData.OldContType and E_BAG_CONT_TYPE.Equip == singleItemData.NewContType then
            newEquip = singleItemData.NewItem
        end
    end

    if nil == oldEquip or nil == newEquip then
        return E_OP_TYPE.Fault, nil, nil
    end

    --- 饰品可能有重复格子，所以要用旧装备的前期数据进行比对，比对槽位是不是相同的
    if preSlotEquip.SvrSlot ~= newEquip.SvrSlot then
        return E_OP_TYPE.Fault, nil, nil
    end

    --- 如果是双天赋，但是两个双天赋页都只有对应槽位的一个装备，就默认是切换装备
    return E_OP_TYPE.SwitchEquip, oldEquip, newEquip
end

---@param itemUpdateDataList ItemUpdateData[]
---@return number, ItemData, ItemData
function _onRefineTransfer(itemUpdateDataList)
    local E_OP_TYPE = GameEnum.EEquipEnhanceGuideType
    local oldEquip = nil
    local newEquip = nil

    for i = 1, #itemUpdateDataList do
        local singleItemData = itemUpdateDataList[i]
        if ItemChangeReason.ITEM_REASON_EQUIP_INHERIT == singleItemData.Reason then
            return E_OP_TYPE.Fault, nil, nil
        end

        --- 转移之后必须原本是没有没有属性的才会产生引导行为
        if singleItemData.OldContType == singleItemData.NewContType then
            if 0 < singleItemData.OldItem.RefineLv and 0 >= singleItemData.NewItem.RefineLv then
                oldEquip = singleItemData.NewItem
            elseif 0 < singleItemData.NewItem.RefineLv and 0 >= singleItemData.OldItem.RefineLv then
                newEquip = singleItemData.NewItem
            end
        end
    end

    if nil == oldEquip or nil == newEquip then
        return E_OP_TYPE.Fault, nil, nil
    end

    return E_OP_TYPE.RefineTransfer, oldEquip, newEquip
end

--- 如果玩家完成了附魔提炼，就引导玩家去拆卡
---@param itemUpdateDataList ItemUpdateData[]
---@return number, ItemData, ItemData
function _onEnchantExtracted(itemUpdateDataList)
    local E_OP_TYPE = GameEnum.EEquipEnhanceGuideType
    local oldEquip = nil
    local newEquip = nil
    for i = 1, #itemUpdateDataList do
        local singleItemData = itemUpdateDataList[i]
        if ItemChangeReason.ITEM_REASON_ENCHANT_REBORN == singleItemData.Reason and singleItemData.OldContType == singleItemData.NewContType then
            if not singleItemData.OldItem.EnchantExtracted and singleItemData.NewItem.EnchantExtracted then
                oldEquip = singleItemData.NewItem
                return E_OP_TYPE.EnchantExtract, oldEquip, nil
            end
        end
    end

    return E_OP_TYPE.Fault, nil, nil
end

--- 如果玩家完成了附魔继承，也会引导玩家去拆卡
---@param itemUpdateDataList ItemUpdateData[]
---@return number, ItemData, ItemData
function _onEnchantInherited(itemUpdateDataList)
    local E_OP_TYPE = GameEnum.EEquipEnhanceGuideType
    local oldEquip = nil
    local newEquip = nil
    for i = 1, #itemUpdateDataList do
        local singleItemData = itemUpdateDataList[i]
        if ItemChangeReason.ITEM_REASON_ENCHANT_INHERIT == singleItemData.Reason and singleItemData.OldContType == singleItemData.NewContType then
            local oldItemEnchantAttrs = singleItemData.OldItem:GetAttrsByType(GameEnum.EItemAttrModuleType.Enchant)
            local newItemEnchantAttrs = singleItemData.NewItem:GetAttrsByType(GameEnum.EItemAttrModuleType.Enchant)
            local oldItemEnchanted = 0 < #oldItemEnchantAttrs
            local newItemEnchanted = 0 < #newItemEnchantAttrs
            if oldItemEnchanted and not newItemEnchanted then
                oldEquip = singleItemData.NewItem
            end

            if not oldItemEnchanted and newItemEnchanted then
                newEquip = singleItemData.NewItem
            end
        end
    end

    if nil ~= oldEquip then
        return E_OP_TYPE.EnchantInherit, oldEquip, newEquip
    end

    return E_OP_TYPE.Fault, nil, nil
end

--- 只有在切换装备的时候有可能进入这个流程
--- 判断两个装备之间是否能够进行精炼转移
---@param itemDataLeft ItemData
---@param itemDataRight ItemData
function _canGotoRefineTrans(itemDataLeft, itemDataRight)
    local E_STEP_TYPE = GameEnum.EEquipEnhanceStepType
    if nil == itemDataLeft or nil == itemDataRight then
        return E_STEP_TYPE.Fault
    end

    local openSysMgr = MgrMgr:GetMgr("OpenSystemMgr")
    if not openSysMgr.IsSystemOpen(openSysMgr.eSystemId.RefineTransfer) then
        return E_STEP_TYPE.Fault
    end

    if itemDataLeft.TID == itemDataRight.TID then
        return E_STEP_TYPE.Fault
    end

    if 0 >= itemDataLeft.RefineLv then
        return E_STEP_TYPE.Fault
    end

    if itemDataLeft.RefineLv < itemDataRight.RefineLv then
        return E_STEP_TYPE.Fault
    end

    if itemDataLeft.Damaged then
        return E_STEP_TYPE.Fault
    end

    local refineTransMgr = MgrMgr:GetMgr("RefineTransferMgr")
    if refineTransMgr.CheckTwoEquipCanTransfer(itemDataLeft, itemDataRight) then
        return E_STEP_TYPE.RefineTransfer
    end

    return E_STEP_TYPE.Fault
end

--- 判断是否应该进入附魔继承阶段
---@param itemDataLeft ItemData @老装备
---@param itemDataRight ItemData @新装备
function _canGotoEnchantInherit(itemDataLeft, itemDataRight)
    local E_STEP_TYPE = GameEnum.EEquipEnhanceStepType
    if nil == itemDataRight then
        return E_STEP_TYPE.Fault
    end

    local openSysMgr = MgrMgr:GetMgr("OpenSystemMgr")
    if not openSysMgr.IsSystemOpen(openSysMgr.eSystemId.EnchantInherit) then
        return E_STEP_TYPE.Fault
    end

    local enchantAttrs = itemDataLeft:GetAttrsByType(GameEnum.EItemAttrModuleType.Enchant)
    if 0 >= #enchantAttrs then
        return E_STEP_TYPE.Fault
    end

    local containsBuff = false
    for i = 1, #enchantAttrs do
        local singleAttr = enchantAttrs[i]
        if GameEnum.EItemAttrType.Buff == singleAttr.AttrType then
            containsBuff = true
            break
        end
    end

    local items = _getMatchStoneEquipList(itemDataLeft)
    if 0 < #items and containsBuff then
        return E_STEP_TYPE.EnchantInherit
    end

    return E_STEP_TYPE.Fault
end

--- 判断玩家是否能去附魔提炼
---@param itemDataLeft ItemData @老装备
---@param itemDataRight ItemData @新装备
function _canGotoEnchantExtract(itemDataLeft, itemDataRight)
    local E_STEP_TYPE = GameEnum.EEquipEnhanceStepType
    local openSysMgr = MgrMgr:GetMgr("OpenSystemMgr")
    if not openSysMgr.IsSystemOpen(openSysMgr.eSystemId.EnchantExtract) then
        return E_STEP_TYPE.Fault
    end

    local enchantAttrs = itemDataLeft:GetAttrsByType(GameEnum.EItemAttrModuleType.Enchant)
    if 0 >= #enchantAttrs then
        return E_STEP_TYPE.Fault
    end

    local containsBuff = false
    for i = 1, #enchantAttrs do
        local singleAttr = enchantAttrs[i]
        if GameEnum.EItemAttrType.Buff == singleAttr.AttrType then
            containsBuff = true
            break
        end
    end

    if containsBuff then
        return E_STEP_TYPE.Fault
    end

    return E_STEP_TYPE.EnchantExtract
end

---@param itemDataLeft ItemData @装备
---@param itemDataRight ItemData @可能为空
function _canGotoRemoveCard(itemDataLeft, itemDataRight)
    local E_STEP_TYPE = GameEnum.EEquipEnhanceStepType
    if nil == itemDataLeft then
        return E_STEP_TYPE.Fault
    end

    local openSysMgr = MgrMgr:GetMgr("OpenSystemMgr")
    if not openSysMgr.IsSystemOpen(openSysMgr.eSystemId.EquipCard) then
        return E_STEP_TYPE.Fault
    end

    local E_ATTR_TYPE = GameEnum.EItemAttrModuleType
    local cards = itemDataLeft:GetAttrsByType(E_ATTR_TYPE.Card)
    if 0 < #cards then
        return E_STEP_TYPE.RemoveCard
    end

    return E_STEP_TYPE.Fault
end

--- 返回获取能够使用该封魔石的道具列表
---@param itemData ItemData
---@return ItemData[]
function _getMatchStoneEquipList(itemData)
    local types = { GameEnum.EBagContainerType.Bag }
    local itemFuncUtil = MgrProxy:GetItemDataFuncUtil()
    ---@type FiltrateCond
    local condition = { Cond = itemFuncUtil.ItemMatchesSlot, Param = itemData.EquipConfig.EquipId }
    ---@type FiltrateCond
    local condition_1 = { Cond = itemFuncUtil.ItemLvAbove, Param = itemData:GetEquipTableLv() }
    local condition_2 = { Cond = itemFuncUtil.ItemNotUID, Param = itemData.UID }
    local conditions = { condition, condition_1, condition_2 }
    local ret = Data.BagApi:GetItemsByTypesAndConds(types, conditions)
    return ret
end

--- 引导玩家去进行精炼转移操作
---@param itemDataLeft ItemData
---@param itemDataRight ItemData
function _gotoRefineTrans(itemDataLeft, itemDataRight)
    local onConfirm = function()
        -- MgrMgr:GetMgr("SelectEquipMgr").SetNeedSelectWithPropInfo(itemDataLeft)
        MgrMgr:GetMgr("RefineTransferMgr").SelectOldEquip = itemDataLeft.UID
        MgrMgr:GetMgr("RefineTransferMgr").SelectNewEquip = itemDataRight.UID
        --寻路成功才关闭对应界面
        local l_result = Common.CommonUIFunc.InvokeFunctionByFuncId(MgrMgr:GetMgr("OpenSystemMgr").eSystemId.RefineAssist)
        if l_result then
            game:ShowMainPanel()
        end
    end

    CommonUI.Dialog.ShowYesNoDlg(true, nil, Lang("EquipAssistant_RefineTransferTips"), onConfirm, nil, nil, 0, "EquipAssistant_DealWithTips")
end

--- 为什么这里没有循路，因为这个阶段和上一个阶段是同一个页签下的，需要的操作是切换，不是循路
---@param itemDataLeft ItemData 新装备
---@param itemDataRight ItemData 旧装备
function _gotoEnchantInherit(itemDataLeft, itemDataRight)
    local l_enchantInheritMgr = MgrMgr:GetMgr("EnchantInheritMgr")
    local onConfirm = function()
        local l_param = {
            handlerName = GameEnum.EEquipAssistType.EnchantAssistOnInherit,
            EquipPropInfo = itemDataRight,
            ItemPropInfo = itemDataLeft,
            switchPerfect = false }

        --寻路成功才关闭对应界面
        local l_result = Common.CommonUIFunc.InvokeFunctionByFuncId(MgrMgr:GetMgr("OpenSystemMgr").eSystemId.EnchantmentAssist, l_param)
        if l_result then
            game:ShowMainPanel()
        end
    end

    local l_funcDeny = function()
        l_enchantInheritMgr.SetOldEquip(nil)
        l_enchantInheritMgr.SetNewEquip(nil)
    end

    CommonUI.Dialog.ShowYesNoDlg(true, nil, Lang("EQUIP_ASSIST_ENCHANT_INHERIT_TIPS"), onConfirm, l_funcDeny, nil, 0, "EquipAssistant_DealWithTips")
end

--- 为什么这里没有循路，因为这个阶段和上一个阶段是同一个页签下的，需要的操作是切换，不是循路
---@param itemDataLeft ItemData 新装备
---@param itemDataRight ItemData 旧装备
function _gotoEnchantExtract(itemDataLeft, itemDataRight)
    local l_enchantInheritMgr = MgrMgr:GetMgr("EnchantmentExtractMgr")
    local onConfirm = function()
        local l_param = {
            handlerName = GameEnum.EEquipAssistType.EnchantAssistOnPerfect,
            EquipPropInfo = itemDataRight,
            ItemPropInfo = itemDataLeft,
            switchPerfect = false }

        --寻路成功才关闭对应界面
        local l_result = Common.CommonUIFunc.InvokeFunctionByFuncId(MgrMgr:GetMgr("OpenSystemMgr").eSystemId.EnchantmentAssist, l_param)
        if l_result then
            game:ShowMainPanel()
        end
    end

    local l_funcDeny = function()
        l_enchantInheritMgr.SetCacheData(nil)
    end

    CommonUI.Dialog.ShowYesNoDlg(true, nil, Common.Utils.Lang("EQUIP_ASSIST_ENCHANT_EXTRACT_TIPS"), onConfirm, l_funcDeny, nil, 0, "EquipAssistant_DealWithTips")
end

---@param itemDataLeft ItemData
---@param itemDataRight ItemData
function _gotoRemoveCard(itemDataLeft, itemDataRight)
    local onConfirm = function()
        local gotoCardData = { EquipUid = itemDataLeft.UID, IsRemoveCard = true }
        MgrMgr:GetMgr("SelectEquipMgr").SetNeedSelectUid(gotoCardData.EquipUid)
        game:ShowMainPanel()
        _openInsertCardPage(nil)
    end

    CommonUI.Dialog.ShowYesNoDlg(true, nil, StringEx.Format(Lang("EquipAssistant_RemoveCardTips"), itemDataLeft.ItemConfig.ItemName), onConfirm, nil, nil, 0, "EquipAssistant_DealWithTips")
end

--- 开启插卡界面
function _openInsertCardPage(cardId)
    MgrMgr:GetMgr("NpcTalkDlgMgr").CloseTalkDlg()
    MgrMgr:GetMgr("ShowEquipPanleMgr").OpenCardForgePanle(cardId)
end

return ModuleMgr.EquipAssistGuideMgr