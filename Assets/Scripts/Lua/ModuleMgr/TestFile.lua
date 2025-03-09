require "Data/Model/ItemAttrData"
module("Data", package.seeall)

function _test()
    local item = Data.BagApi._itemPool:GetItemData("")
    logError(ToString(item))

    local container = Data.BagApi._itemContainer._container[GameEnum.EBagContainerType.VirtualItem]
    logError(ToString(container))

    local container = Data.BagApi._itemTidCountMap._container[GameEnum.EBagContainerType.Bag]
    logError(ToString(container))

    local itemFiltrateUtil = MgrMgr:GetMgr("ItemContainerMgr")
    local targetCount = itemFiltrateUtil.GetItemCountByContAndID(GameEnum.EBagContainerType.VirtualItem, 503)
    logError(tostring(targetCount))

    local itemLeftID = 12130203
    local itemRightID = 12130203
    local recommendMapMgr = MgrMgr:GetMgr("RecommendMapMgr")
    local result = recommendMapMgr.ItemMatchItemSchool(itemLeftID, itemRightID)
    logError("left: " .. tostring(itemLeftID) .. " right: " .. tostring(itemRightID) .. " result: " .. tostring(result))

    local itemLeft = Data.BagApi:CreateLocalItemData(12130203)
    local updateData = Data.ItemUpdateData.new()
    updateData.Reason = ItemChangeReason.ITEM_REASON_PICK_UP
    updateData.NewItem = itemLeft
    updateData.NewContType = GameEnum.EBagContainerType.Bag
    local msgParam = { updateData }
    local gameEventMgr = MgrProxy:GetGameEventMgr()
    gameEventMgr.RaiseEvent(gameEventMgr.OnBagUpdate, msgParam)

    local cardMgr = MgrMgr:GetMgr("EquipCardForgeHandlerMgr").ErrorCodeTips(1035)

    local newItem = Data.BagApi:CreateLocalItemData(13131506)

    ---@type ItemAttrData
    local data_0 = Data.ItemAttrData.new()
    data_0.TableID = 0
    data_0.AttrValue = 0
    data_0.AttrID = 400006001
    data_0.AttrType = 1
    data_0.ExtraParam = {
        [1] = {
            key = 1004,
            value = 283 },
        [2] = {
            key = 1005,
            value = 2000 },
        [3] = {
            key = 1019,
            value = 0 },
        [4] = {
            key = 1020,
            value = 2 }
    }

    local newAttrList = {
        data_0
    }

    local ret = MgrMgr:GetMgr("AttrDescUtil").GenItemSchoolAttrStrList(newItem.EquipConfig.EquipText, newAttrList, nil)
    logError(ToString(ret))

    local strs = MgrMgr:GetMgr("EquipReformMgr").GetItemDisplayAttrs(newItem)
    logError(ToString(strs))

    MgrMgr:GetMgr("SystemFunctionEventMgr").OnEquipReform()

    local targetAttrs = MgrMgr:GetMgr("IllustrationEquipAttrMgr").GetAttrStrsByID(13131605)
    logError(ToString(targetAttrs))

    local container = Data.BagApi._itemContainer._container[GameEnum.EBagContainerType.WareHousePage_1]
    logError(ToString(container))

    local int64_test = int64.new(500)
    local intPart, decimalPart = math.modf(int64_test)
    logError(tostring(intPart) .. ", " .. tostring(decimalPart))

    logError(tostring(int64_test % 3))

    local int64_test = int64.new(500)
    logError(1000 - int64_test)
    local ret = 0

    logError(int64_test > 100)
    logError(int64.equals(int64_test, 0))

    for i = 1, int64_test do
        ret = ret + 1
    end

    logError(tostring(ret))
    local moneyCount = Data.BagModel:GetCoinOrPropNumById(201)
    logError(type(moneyCount) .. ": " .. tostring(moneyCount))

    local targetColor = CommonUI.Color.Hex2Color("4b6cbb")
    logError(ToString(targetColor))

    local target = {
        1, nil, 2
    }

    local test_target = {
        [1] = 1,
        [2] = nil,
        [3] = 3,
    }

    logError(#test_target)

    local test = { 1, 2, 3 }
    table.sort(test, function(a, b)
        return a > b
    end)

    logError(ToString(test))

    UIMgr:DeActiveUI(UI.CtrlNames.ModifyCharacterName)

    local allEquipConfig = TableUtil.GetEquipTable().GetTable()
    for i = 1, #allEquipConfig do
        local single_config = allEquipConfig[i]
        local error_code, ret_value = pcall(MgrMgr:GetMgr("IllustrationEquipAttrMgr").GetAttrStrsByID, single_config.Id)
        if not error_code then
            logError(tostring(single_config.Id))
        end
    end

    local data = {
        [101] = {
            ShopID = 101,
            ShopDataMap = {
                [2010001] = {
                    ShopTableID = 10001,
                    ShopTargetItemID = 2010001,
                    ShopItemList = {
                        { Id = 101,
                          Value = 100, },
                    } },
            }
        },
        [102] = {

        }
    }

    logError(ToString(ShopOffLineMap))

    local itemDataPool = Data.ItemLocalDataCache.new()
    local testItem = Data.BagApi:CreateLocalItemData(2010001)
    local testItem_0 = Data.BagApi:CreateLocalItemData(2010001)
    local testItem_1 = Data.BagApi:CreateLocalItemData(2010002)
    local testItem_2 = Data.BagApi:CreateLocalItemData(2010002)
    local testItem_3 = Data.BagApi:CreateLocalItemData(2010002)
    local testItem_4 = Data.BagApi:CreateLocalItemData(2010002)
    local testItem_5 = Data.BagApi:CreateLocalItemData(2010002)
    itemDataPool:RecycleItemData(testItem)
    itemDataPool:RecycleItemData(testItem_0)
    itemDataPool:RecycleItemData(testItem_1)
    itemDataPool:RecycleItemData(testItem_2)
    itemDataPool:RecycleItemData(testItem_3)
    itemDataPool:RecycleItemData(testItem_4)
    itemDataPool:RecycleItemData(testItem_5)
    for i = 1, 50 do
        local singleItem = Data.BagApi:CreateLocalItemData(2010003)
        itemDataPool:RecycleItemData(singleItem)
    end

    local getItem = itemDataPool:GetItemData(2010002)
    itemDataPool:LogDetail()

    UIMgr:ActiveUI()
    UIMgr:ActiveUI(UI.CtrlNames.EquipCarryShop)

    local data = TableUtil.GetEquipText().GetRowByID(1163)
    for i = 0, data.ActTextTwo.Length - 1 do
        logError(ToString(data.ActTextTwo[i]))
    end

    local localItemData = Data.BagApi:CreateLocalItemData(12333305)
    local ret = {}
    local baseAttrList = localItemData:GetAttrsByType(GameEnum.EItemAttrModuleType.Base)
    local styleAttrList = localItemData:GetAttrsByType(GameEnum.EItemAttrModuleType.School)
    local attrUtil = MgrMgr:GetMgr("AttrDescUtil")
    --for i = 1, #baseAttrList do
    --    local singleAttr = baseAttrList[i]
    --    local str = attrUtil.GetAttrStr(singleAttr)
    --    table.insert(ret, str)
    --end

    logError(ToString(styleAttrList))
    for i = 1, #styleAttrList do
        local singleAttr = styleAttrList[i]
        local str = attrUtil.GetAttrStr(singleAttr)
        table.insert(ret, str)
    end

    logError(ToString(ret))
    local singleMap = MgrMgr:GetMgr("IllustrationMonsterMgr").RedSignSingleHash
    local groupMap = MgrMgr:GetMgr("IllustrationMonsterMgr").RedSignGroupHash
    logError(ToString(singleMap))
    logError(ToString(groupMap))
    MgrMgr:GetMgr("IllustrationEquipAttrMgr").Test()
end

function Test01()
    local equipTableFull = TableUtil.GetEquipTable().GetTable()
    for i = 1, #equipTableFull do
        local id = equipTableFull[i].Id
        local localItemData = Data.BagApi:CreateLocalItemData(id)
        local copyData = table.ro_deepCopy(localItemData)
    end

    local equipTableFull = TableUtil.GetEquipTable().GetTable()
    for i = 1, #equipTableFull do
        local id = equipTableFull[i].Id
        local localItemData = Data.BagApi:CreateLocalItemData(id)
        local copyData = localItemData:CreateCopy()
    end
end

function Test()
    local strList = {
        "AttrType",
        "AttrID",
        "AttrValue",
        "TableID",
        "RareAttr",
        "EquipTextID",
        "AttrIdx",
        "OverrideType",
        "RandomType",
    }

    local extraParamStrList = {
        "key",
        "value",
        "randomType",
        "name",
    }

    local equipTableFull = TableUtil.GetEquipTable().GetTable()
    for i = 1, #equipTableFull do
        local id = equipTableFull[i].Id
        local localItemData = Data.BagApi:CreateLocalItemData(id)
        local baseAttrList = localItemData:GetAttrsByType(GameEnum.EItemAttrModuleType.RareStyle)
        local baseNewList = Data.EquipAttrOffLineFactory:CreateEquipAttrList(id, GameEnum.EItemAttrModuleType.School, GameEnum.EAttrValueState.Rare)
        if #baseNewList == #baseAttrList then
            for j = 1, #baseAttrList do
                local ori_attr = baseAttrList[j]
                local new_attr = baseNewList[j]
                for k = 1, #strList do
                    local str = strList[k]
                    if ori_attr[str] ~= new_attr[str] then
                        logError("attr not match, id: " .. tostring(id) .. " attr name: " .. str .. " old value: " .. tostring(ori_attr[str]) .. " new value: " .. tostring(new_attr[str]))
                    end

                    local ori_extra_param_count = 0
                    if nil ~= ori_attr.ExtraParam then
                        ori_extra_param_count = #ori_attr.ExtraParam
                    end

                    if ori_extra_param_count ~= #new_attr.ExtraParam then
                        logError("attr extra param count not match, id: " .. tostring(id))
                    elseif 0 < ori_extra_param_count then
                        for t = 1, #ori_attr.ExtraParam do
                            local oldParam = ori_attr.ExtraParam[t]
                            local newParam = new_attr.ExtraParam[t]
                            for x = 1, #extraParamStrList do
                                local extra_param_name = extraParamStrList[x]
                                if oldParam[extra_param_name] ~= newParam[extra_param_name] then
                                    logError("attr not match, id: " .. tostring(id) .. " extra param name: " .. extra_param_name .. " old value: " .. tostring(oldParam[extra_param_name]) .. " new value: " .. tostring(newParam[extra_param_name]))
                                end
                            end
                        end
                    end
                end
            end
        else
            logError("base count mis match: " .. tostring(id))
        end
    end

    ---@type ResultPanelData
    local data = {}
    data.Win = true
    data.OnClick = function()
        UIMgr:DeActiveUI(UI.CtrlNames.BattleEndFail)
    end
    data.PassTime = 60
    data.ItemDataList = {
        Data.BagApi:CreateLocalItemData(2010001),
        Data.BagApi:CreateLocalItemData(2010001),
        Data.BagApi:CreateLocalItemData(2010001),
        Data.BagApi:CreateLocalItemData(2010001),
        Data.BagApi:CreateLocalItemData(2010001),
        Data.BagApi:CreateLocalItemData(2010001),
        Data.BagApi:CreateLocalItemData(2010001),
    }

    UIMgr:ActiveUI(UI.CtrlNames.BattleEndFail, data)

    UIMgr:ActiveUI(UI.CtrlNames.CommonVideo, { type = GameEnum.EPvPLuaType.BattleField })
end