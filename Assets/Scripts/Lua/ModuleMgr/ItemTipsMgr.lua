module("ModuleMgr.ItemTipsMgr", package.seeall)

--[[
--CommonItemTip类型
BagModel.WeaponStatus =
{
    IN_BAG = 1,                     --在背包中
    ON_BODY = 2,                    --身上的装备 显示卸下
    JUST_COMPARE = 3,               --单纯对比
    JUST_COMPARE_ORNAMENT1 = 4,     --更换
    JUST_COMPARE_ORNAMENT2 = 5,     --更换
    TO_POT = 6,                     --放入仓库
    TO_PROP = 7,                    --放入背包
    NORMAL_PROP = 8,                --普通道具
    TO_USE = 9,                     --使用物品
    TO_SHOP = 10,                   --商店
    TO_STALL = 11,                  --摆摊
    JUST_COMPARE_Dagger1 = 12,      --当盗贼学了双持武器技能的时候,可以装备两把匕首,这时候可以选择替换
    JUST_COMPARE_Dagger2 = 13,      --当盗贼学了双持武器技能的时候,可以装备两把匕首,这时候可以选择替换
    Gift = 14,                      --赠送礼物
    FISH_PROP = 15,                 --钓鱼用具
}
]]--

--根据item的id显示tips
function ShowTipsDisplayWithId(id, relativeTransform, propStatus, additionalData, isShowAchieve, extraData)
    local itemData = Data.BagModel:CreateItemWithTid(tonumber(id))
    ShowTipsDisplay(itemData, relativeTransform, propStatus, additionalData, isShowAchieve, extraData)
end

--根据item的propInfo显示tips
function ShowTipsDisplayWithInfo(itemData, relativeTransform, propStatus, additionalData, isShowAchieve, extraData)
    ShowTipsDisplay(itemData, relativeTransform, propStatus, additionalData, isShowAchieve, extraData)
end

--根据item的uid显示tips
function ShowTipsDisplayWithUid(uid, relativeTransform, propStatus, additionalData, isShowAchieve, extraData)
    local items = _getItemsInBag()
    for i = 1, #items do
        local singleItem = items[i]
        if singleItem.UID == uid then
            ShowTipsDisplay(singleItem, relativeTransform, propStatus, additionalData, isShowAchieve, extraData)
            break
        end
    end
end

--- 获取背包中的道具
---@return ItemData[]
function _getItemsInBag()
    local types = { GameEnum.EBagContainerType.Bag }
    local items = Data.BagApi:GetItemsByTypesAndConds(types, nil)
    return items
end

--根据propInfo显示tips
--propInfo 道具信息
--relativeTransform 位置
--Tips类型枚举
--addtionalData 附加数据
---@param propInfo ItemData
function ShowTipsDisplay(propInfo, relativeTransform, propStatus, addtionalData, isShowAchieve, extraData)
    if propInfo == nil then
        return
    end

    if isShowAchieve == nil then
        isShowAchieve = false
    end

    UIMgr:DeActiveUI(UI.CtrlNames.CommonItemTips)

    local l_capraCardMgr = MgrMgr:GetMgr("CapraCardMgr")
    --如果是卡普拉卡片则特殊展示
    if l_capraCardMgr.TryShowCapraCardPanel(propInfo,isShowAchieve,propStatus) then
        return
    end

    UIMgr:ActiveUI(UI.CtrlNames.CommonItemTips, function(l_ui)
        --是否显示获取途径
        if isShowAchieve then
            ShowCommonTipsByStatues(l_ui, propInfo, nil, propStatus, addtionalData, extraData)
            ShowItemAchieveWithId(propInfo.TID)
        else
            ShowCommonTipsByStatues(l_ui, propInfo, relativeTransform, propStatus, addtionalData, extraData)
        end
    end)
end

function ShowItemAchieveWithId(id,baseRect)
    if id ~= nil then
        if Common.CommonUIFunc.isItemHaveExport(id) then
            UIMgr:ActiveUI(UI.CtrlNames.ItemAchieveTipsNew, function(l_ui)
                if l_ui then
                    l_ui:InitItemAchievePanelByItemId(id)
                    l_ui:SetRelativePosition(baseRect)
                end
            end)
            return
        end
    end
    UIMgr:DeActiveUI(UI.CtrlNames.ItemAchieveTipsNew)
end

--显示Tips
function ShowCommonTipsByStatues(ui, cPropInfo, cRelativeTransform, cPropStatus, cAddtionalData, extraData)
    if not ui then
        return
    end
    --查看玩家身上的装备 按钮显示卸下 此时不需要对比
    if cPropStatus == Data.BagModel.WeaponStatus.ON_BODY then
        ui:ShowWeaponPropTip(cPropInfo)
        --查看玩家身上的装备 按钮显示卸下 此时不需要对比
    elseif cPropStatus == Data.BagModel.WeaponStatus.JUST_COMPARE then
        ui:ShowCompareWeaponTip(cPropInfo)
        --商店Tips单独处理
    elseif cPropStatus == Data.BagModel.WeaponStatus.TO_SHOP then
        ui:ShowShopTip(cPropInfo, cPropStatus, cAddtionalData)
    elseif cPropStatus == Data.BagModel.WeaponStatus.MALL then
        ui:ShowMallTip(cPropInfo, cPropStatus, cAddtionalData)
    elseif cPropStatus == Data.BagModel.WeaponStatus.TO_STALL then
        ui:ShowStallTip(cPropInfo, cPropStatus, cAddtionalData)
    elseif cPropStatus == Data.BagModel.WeaponStatus.TO_MERCHANT then
        ui:ShowMerchantTip(cPropInfo, cPropStatus, cAddtionalData)
    elseif cPropStatus == Data.BagModel.WeaponStatus.TO_MERCHANT_SELL then
        ui:ShowMerchantToSellTip(cPropInfo, cPropStatus, cAddtionalData)
    else
        --普通道具显示Tips
        ui:ShowDisplay(cPropInfo, cRelativeTransform, cPropStatus, extraData, Data.BagModel.ButtonStatus.Show)
        if cAddtionalData ~= nil then
            ui:SetShowCloseButton(cAddtionalData.IsShowCloseButton)
        end
    end
end

--TipsTransform tip的Transform
--RelativeTransform 自适应相应的物体的Transform
--OffsetLeft
--OffsetRight
function SelfAdaptionTips(data)
    if data == nil then
        return
    end
    if data.TipsTransform == nil then
        return
    end

    --同时显示Tips和获取途径不做自适应
    local l_ui_CommonTips = UIMgr:GetUI(UI.CtrlNames.CommonItemTips)
    local l_ui_ItemAchieve = UIMgr:GetUI(UI.CtrlNames.ItemAchieveTipsNew)
    if l_ui_CommonTips ~= nil and l_ui_ItemAchieve ~= nil then
        if l_ui_CommonTips.isActive and l_ui_ItemAchieve.isActive then
            return
        end
    end
    local l_ui_ItemUseful = UIMgr:GetUI(UI.CtrlNames.ItemUsefulTips)
    if l_ui_ItemUseful ~= nil and l_ui_ItemUseful.isActive then
        return
    end

    LayoutRebuilder.ForceRebuildLayoutImmediate(data.TipsTransform)

    --- 这里有一个隐藏的问题，如果 transform 已经被卸载掉了，会变成一个字符串"nil"，所以要用一个方法去判断
    if IsNil(data.RelativeTransform) then
        local position = Vector2.New(0, 0)
        if data.extraData ~= nil then
            if data.extraData.fixationPosX ~= nil then
                position.x = data.extraData.fixationPosX
            end
            if data.extraData.fixationPosY ~= nil then
                position.y = data.extraData.fixationPosY
            end
            if data.extraData.relativeScreenPosition ~= nil then
                local _, l_anchoredPos = RectTransformUtility.ScreenPointToLocalPointInRectangle(data.TipsTransform, data.extraData.relativeScreenPosition, MUIManager.UICamera, nil)
                position = l_anchoredPos
                if data.extraData.bottomAlign then
                    position.y = position.y + data.TipsTransform.rect.height / 2
                end
            end
        end
        data.TipsTransform.anchoredPosition = position
    else
        local ViewportPoint = MUIManager.UICamera:WorldToViewportPoint(data.RelativeTransform.position);
        local position = CoordinateHelper.WorldPositionToLocalPosition(data.RelativeTransform.position, data.TipsTransform)
        if ViewportPoint.x <= 0.5 then
            if data.OffsetRight ~= nil then
                position.x = position.x + data.OffsetRight
            end
        else
            if data.OffsetLeft ~= nil then
                position.x = position.x - data.OffsetLeft
            end
        end

        if data.extraData and data.extraData.relativePositionY then
            if data.extraData.bottomAlign then
                --tips框下边缘对齐
                position.y = position.y + data.extraData.relativePositionY + data.TipsTransform.rect.size.y / 2
            else
                position.y = data.extraData.relativePositionY
            end
        else
            position.y = 0
        end

        data.TipsTransform.anchoredPosition = position
    end
end

--自适应道具获取途径和通用TipsPos
function SortCommonTipsAndItemSearchPath()
    local l_ui_CommonTips = UIMgr:GetUI(UI.CtrlNames.CommonItemTips)
    local l_ui_ItemAchieve = UIMgr:GetUI(UI.CtrlNames.ItemAchieveTipsNew)

    if l_ui_CommonTips ~= nil and l_ui_ItemAchieve ~= nil then
        if l_ui_CommonTips.isActive and l_ui_ItemAchieve.isActive then
            local posx, posy, sizex, sizey = l_ui_CommonTips:GetSelfTipsPosInfo()
            l_ui_CommonTips:SetSelfPos(Vector3.New(-190, 0, 0))
            l_ui_ItemAchieve:SetSelfPos(Vector3.New(182, (sizey - 360) / 2, 0))
        end
    end
end

--自适应道具获取途径和道具易用性 从Tips打开道具易用性Tips
function SortCommonTipsAndItemUsefulPath()
    local l_ui_CommonTips = UIMgr:GetUI(UI.CtrlNames.CommonItemTips)
    local l_ui_ItemUseful = UIMgr:GetUI(UI.CtrlNames.ItemUsefulTips)
    if l_ui_CommonTips ~= nil and l_ui_ItemUseful ~= nil then
        if l_ui_CommonTips.isActive and l_ui_ItemUseful.isActive then
            local posx, posy, sizex, sizey = l_ui_CommonTips:GetSelfTipsPosInfo()
            local itemPosx, itemPosy, itemSizex, itemSizey, isMat = l_ui_ItemUseful:GetSelfTipsPosInfo()
            l_ui_CommonTips:SetSelfPos(Vector3.New(-190, 0, 0))
            if isMat then
                l_ui_ItemUseful:SetSelfPos(Vector3.New(170, itemSizey / 2 - (itemSizey - sizey) / 2, 0))
            else
                l_ui_ItemUseful:SetSelfPos(Vector3.New(170, (sizey - 360) / 2, 0))
            end
        end
    end
end

function SortItemUsefulAndPathCommonTips()
    local l_ui_CommonTips = UIMgr:GetUI(UI.CtrlNames.CommonItemTips)
    local l_ui_ItemUseful = UIMgr:GetUI(UI.CtrlNames.ItemUsefulTips)

    if l_ui_CommonTips ~= nil and l_ui_ItemUseful ~= nil then
        if l_ui_CommonTips.isActive and l_ui_ItemUseful.isActive then
            local tipsposx, tipsposy, tipssizex, tipssizey = l_ui_CommonTips:GetSelfTipsPosInfo()
            local posx, posy, sizex, sizey, isMat = l_ui_ItemUseful:GetSelfTipsPosInfo()
            local setposy = nil
            if isMat then
                setposy = posy - tipssizey / 2
            else
                setposy = sizey / 2 + posy - tipssizey / 2
            end
            l_ui_CommonTips:SetSelfPos(Vector3.New(-190, setposy, 0))
        end
    end
end

function ShowStallTipsWithInfo(info, callBack, addictionData)
    if info == nil then
        logError("功能传进来的需要显示的数据为空！请查看堆栈，核查一下自己的逻辑。")
        return
    end
    UIMgr:DeActiveUI(UI.CtrlNames.CommonItemTips)
    UIMgr:ActiveUI(UI.CtrlNames.CommonItemTips, function(ctrl)
        ShowCommonTipsByStatues(ctrl, info, nil, Data.BagModel.WeaponStatus.TO_STALL, addictionData)
        --ctrl:SetShowCloseButton(true)
        if callBack then
            callBack(ctrl)
        end
    end)
end

--关闭Tips
function CloseCommonTips()
    UIMgr:DeActiveUI(UI.CtrlNames.CommonItemTips)
end

return ModuleMgr.ItemTipsMgr