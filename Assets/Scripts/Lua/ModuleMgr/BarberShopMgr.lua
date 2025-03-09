---@module BarberShopMgr
module("ModuleMgr.BarberShopMgr", package.seeall)

ON_INIT_SLIDER_VALUE = "ON_INIT_SLIDER_VALUE"

EventDispatcher = EventDispatcher.new()

local LimitMgr = MgrMgr:GetMgr("LimitMgr")

-- message: FashionRecord
FashionRecord = {}
MaxLimitCondition = 3

function SetHair(id)
    FashionRecord.hair_style_id = id
    MPlayerInfo.HairStyle = id
    -- 模型
    if MEntityMgr.PlayerEntity ~= nil and MEntityMgr.PlayerEntity.AttrComp ~= nil then
        MEntityMgr.PlayerEntity.AttrComp:SetHair(id)
    end
end

-- message: FashionRecord
function OnSelectRoleNtf(info)
    local pbFashionRecord = info.fashion
    FashionRecord.hair_style_id = pbFashionRecord.current_hair_id
    FashionRecord.own_hairs = pbFashionRecord.own_hairs
    FashionRecord.own_eyes = pbFashionRecord.own_eyes
    SetHair(FashionRecord.hair_style_id)
end

function OnReconnected(reconnectData)
    local l_roleAllInfo = reconnectData.role_data
    OnSelectRoleNtf(l_roleAllInfo)
end

-- message: UnlockHairArg
function RequestUnlockHair(id)
    local l_msgId = Network.Define.Rpc.UnlockHair
    ---@type UnlockHairArg
    local l_sendInfo = GetProtoBufSendTable("UnLockHairArg")
    l_sendInfo.hair_id = id
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

-- message: UnlockHairRes
function OnUnlockHair(msg)
    ---@type UnlockHairRes
    local l_info = ParseProtoBufToTable("UnLockHairRes", msg)
    if l_info.result ~= 0 then
        logWarn("UnLockHairRes error: " .. l_info.result)
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.result))
        return
    end
    local l_ui = nil
    if UIMgr:IsActiveUI(UI.CtrlNames.BarberShop) then
        l_ui = UIMgr:GetUI(UI.CtrlNames.BarberShop)
    end
    if l_ui ~= nil then
        l_ui:OnUnlockHair(l_info)
    end
end


-- message: ChangeHairArg
-- totalCost isNotCheck 为快捷付费数据可不传
function RequestChangeHair(id,totalCost,isNotCheck)

    if totalCost and totalCost > 0 then
        local _,l_needNum = Common.CommonUIFunc.ShowCoinStatusText(GameEnum.l_virProp.Coin101,totalCost)
        if l_needNum > 0 and not isNotCheck then
            MgrMgr:GetMgr("CurrencyMgr").ShowQuickExchangePanel(GameEnum.l_virProp.Coin101,l_needNum,function ()
                RequestChangeHair(id,totalCost,true)
            end)
            return
        end
    end

    local l_msgId = Network.Define.Rpc.ChangeHair
    ---@type ChangeHairArg
    local l_sendInfo = GetProtoBufSendTable("ChangeHairArg")
    l_sendInfo.hair_id = id
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

-- message: ChangeHairRes
function OnChangeHair(msg)
    ---@type ChangeHairRes
    local l_info = ParseProtoBufToTable("ChangeHairRes", msg)
    if l_info.result ~= 0 then
        logWarn("ChangeHairRes error: " .. l_info.result)
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.result))
        return
    end

    SetHair(l_info.hair_id)
    local l_ui = nil
    if UIMgr:IsActiveUI(UI.CtrlNames.BarberShop) then
        l_ui = UIMgr:GetUI(UI.CtrlNames.BarberShop)
    end

    if l_ui ~= nil then
        l_ui:OnChangeHair(l_info)
    end
end

m_sliderValue = -1

function OnInitSlider(table, value)
    m_sliderValue = value
    EventDispatcher:Dispatch(ON_INIT_SLIDER_VALUE)
end

function CheckLimit(barberId)
    local result = true

    local barberRow = TableUtil.GetBarberTable().GetRowByBarberID(barberId)
    if barberRow ~= nil then
        local barberUseItemSeq = Common.Functions.SequenceToTable(barberRow.UseItem)
        if barberRow.UseItem ~= nil and barberUseItemSeq[1] ~= 0 then
            --logGreen("barberRow.UseItem ~= nil"..barberUseItemSeq[1].."="..barberUseItemSeq[2])
            if not LimitMgr.CheckUseItemLimitInhairs(barberRow.BarberID) then
                result = false
            end
        elseif barberRow.CollectionScoreLimit > 0 then
            if not LimitMgr.CheckCollectionScoreLimit(barberRow.CollectionScoreLimit) then
                result = false
            end
        elseif barberRow.AchievementPointLimit > 0 then
            if not LimitMgr.CheckAchievementPointLimit(barberRow.AchievementPointLimit) then
                result = false
            end
        elseif barberRow.AchievementLimit > 0 then
            if not LimitMgr.CheckAchievementLimit(barberRow.AchievementLimit) then
                result = false
            end
        elseif barberRow.TaskLimit > 0 then
            if not LimitMgr.CheckTaskLimit(barberRow.TaskLimit) then
                result = false
            end
        elseif barberRow.AchievementLevelLimit > 0 then
            if not LimitMgr.CheckAchievementLevelLimit(barberRow.AchievementLevelLimit) then
                result = false
            end
        end
    end

    return result
end

function GetLimitStr(barberId)
    local data = {}
    local barberRow = TableUtil.GetBarberTable().GetRowByBarberID(barberId)

    local barberUseItemSeq = Common.Functions.SequenceToTable(barberRow.UseItem)
    if barberRow.UseItem ~= nil and barberUseItemSeq[1] ~= 0 then --道具解锁区别于其他条件解锁
        local item = {}
        item.limitType = LimitMgr.ELimitType.UESITEM_LIMIT
        item.finish = LimitMgr.CheckUseItemLimitInhairs(barberRow.BarberID)
        item.UseItemSeq = barberUseItemSeq
        --local colorTag = item.finish and RoColorTag.None or RoColorTag.Gray
        --local count = item.finish and barberRow.CollectionScoreLimit or MgrProxy:GetGarderobeMgr().FashionRecord.fashion_count
        --local countStr = tostring(count)
        --item.str = GetColorText(StringEx.Format(Common.Utils.Lang("COLLECTION_LIMIT"), countStr, barberRow.CollectionScoreLimit), colorTag)
        table.insert(data, item)
        return data
    end

    if barberRow.CollectionScoreLimit > 0 then
        local item = {}
        item.limitType = LimitMgr.ELimitType.COLLECTION_LIMIT
        item.finish = LimitMgr.CheckCollectionScoreLimit(barberRow.CollectionScoreLimit)
        local colorTag = item.finish and RoColorTag.None or RoColorTag.Gray
        local count = item.finish and barberRow.CollectionScoreLimit or MgrProxy:GetGarderobeMgr().FashionRecord.fashion_count
        local countStr = tostring(count)
        item.str = GetColorText(StringEx.Format(Common.Utils.Lang("COLLECTION_LIMIT"), countStr, barberRow.CollectionScoreLimit), colorTag)
        table.insert(data, item)
    end

    if barberRow.AchievementPointLimit > 0 then
        local item = {}
        item.limitType = LimitMgr.ELimitType.ACHIEVEMENTPOINT_LIMIT
        item.finish = LimitMgr.CheckAchievementPointLimit(barberRow.AchievementPointLimit)
        local colorTag = item.finish and RoColorTag.None or RoColorTag.Gray
        item.str = GetColorText(StringEx.Format(Common.Utils.Lang("ACHIEVEMENTPOINT_LIMIT"), barberRow.AchievementPointLimit), colorTag)
        table.insert(data, item)
    end

    if barberRow.AchievementLimit > 0 then
        local item = {}
        item.limitType = LimitMgr.ELimitType.ACHIEVEMENT_LIMIT
        item.finish = LimitMgr.CheckAchievementLimit(barberRow.AchievementLimit)
        item.AchievementId = barberRow.AchievementLimit
        local achievementInfo = MgrMgr:GetMgr("AchievementMgr").GetAchievementTableInfoWithId(barberRow.AchievementLimit)
        local colorTag = item.finish and RoColorTag.None or RoColorTag.Gray
        item.str = GetColorText(StringEx.Format(Common.Utils.Lang("ACHIEVEMENT_LIMIT"), achievementInfo.Name), colorTag)
        table.insert(data, item)
    end

    if barberRow.TaskLimit > 0 then
        local task = MgrMgr:GetMgr("TaskMgr").GetTaskTableInfoByTaskId(barberRow.TaskLimit)
        local item = {}
        item.limitType = LimitMgr.ELimitType.TASK_LIMIT
        item.finish = LimitMgr.CheckTaskLimit(barberRow.TaskLimit)
        if task ~= nil then
            local colorTag = item.finish and RoColorTag.None or RoColorTag.Gray
            item.str = GetColorText(StringEx.Format(Common.Utils.Lang("TASK_LIMIT"), task.typeTitle, task.name), colorTag)
        else
            item.str = "<color=$$Red$$>" .. "Error" .. "</color>"
        end

        item.task = task
        table.insert(data, item)
    end

    if barberRow.AchievementLevelLimit > 0 then
        local item = {}
        item.finish = LimitMgr.CheckAchievementLevelLimit(barberRow.AchievementLevelLimit)
        item.limitType = LimitMgr.ELimitType.ACHIEVEMENTLEVEL_LIMIT
        local colorTag = item.finish and RoColorTag.None or RoColorTag.Gray
        local badgeTableInfo = TableUtil.GetAchievementBadgeTable().GetRowByLevel(barberRow.AchievementLevelLimit, true)
        local name = ""
        if badgeTableInfo then
            name = badgeTableInfo.Name
        end
        item.str = GetColorText(StringEx.Format(Common.Utils.Lang("ACHIEVEMENTLEVEL_LIMIT"), name), colorTag)
        table.insert(data, item)
    end
    return data
end
