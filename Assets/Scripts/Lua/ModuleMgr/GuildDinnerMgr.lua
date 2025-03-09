---
--- Created by cmd(TonyChen) detach from GuildMgr.
--- DateTime: 2019/02/25 20:47
---
---@module ModuleMgr.GuildDinnerMgr
module("ModuleMgr.GuildDinnerMgr", package.seeall)

EventDispatcher = EventDispatcher.new()
--更新大乱斗人数事件
UPDATE_GUILD_DINNER_FIGHT_MEMBER_NUM = "UPDATE_GUILD_DINNER_FIGHT_MEMBER_NUM"
UPDATE_GUILD_DINNER_FIGHT_SHOW_STATE = "UPDATE_GUILD_DINNER_FIGHT_SHOW_STATE"
UPDATE_COOK_PERSONAL_RANK = "UPDATE_COOK_PERSONAL_RANK"
UPDATE_GUILD_SCORE_INFO = "UPDATE_GUILD_SCORE_INFO"
UPDATE_RANDOM_EVENT_TIME = "UPDATE_RANDOM_EVENT_TIME"
UPDATE_GUILD_COOK_COMPETITION_STATE = "UPDATE_GUILD_COOK_COMPETITION_STATE" --更新公会烹饪比赛状态

--公会数据获取
local l_guildData = DataMgr:GetData("GuildData")
local gameEventMgr = MgrMgr:GetMgr("GameEventMgr")

function OnInit()
    gameEventMgr.Register(gameEventMgr.OnBagUpdate, _onItemUpdate)
end

function OnEnterScene(sceneId)
    if sceneId ~= DataMgr:GetData("GuildData").GUILD_SCENE_ID then
        return
    end
    --如果时间没有记录则获取表中时间 或者 今日的0点时间大于展示时间（防止一天不下线）
    if not l_guildData.dinnerFightInfoShowTime or Common.TimeMgr.GetDayTimestamp() > l_guildData.dinnerFightInfoShowTime then
        GetDinnerFightTime()
    end
    --当前时间获取
    local l_curTime = Common.TimeMgr.GetNowTimestamp()
    --如果还在准备时间则可以加入大乱斗 请求大乱斗人数
    if l_curTime >= l_guildData.dinnerFightInfoShowTime and l_curTime <= l_guildData.dinnerFightEndTime then
        ReqGuildDinnerCreamMeleeRenshu()
    end
    showCookRankInfo()
end

function OnLeaveScene(sceneId)
    if sceneId == DataMgr:GetData("GuildData").GUILD_SCENE_ID then
        UIMgr:DeActiveUI(UI.CtrlNames.GuildDinnerFightInfo)
        UIMgr:DeActiveUI(UI.CtrlNames.GuildDinner)
        local l_dailyTaskMgr = MgrMgr:GetMgr("DailyTaskMgr")
        l_dailyTaskMgr.EventDispatcher:RemoveObjectAllFunc(l_dailyTaskMgr.DAILY_ACTIVITY_STATE_CHANGE, GuildDinnerMgr)
    end
end

--获取宴会大乱斗的时间
function GetDinnerFightTime()
    local l_dinnerFightTipTime = tonumber(TableUtil.GetGuildActivityTable().GetRowBySetting("BanquetFightEventNodeTime").Value)
    local l_dinnerFightStartTime = tonumber(TableUtil.GetGuildActivityTable().GetRowBySetting("BanquetFightEventTime").Value)
    local l_dinnerFightEndTime = tonumber(TableUtil.GetGuildActivityTable().GetRowBySetting("BanquetFightEventLastTime").Value)

    local l_todayTime = Common.TimeMgr.GetDayTimestamp()

    l_guildData.dinnerFightInfoShowTime = l_todayTime + math.floor(l_dinnerFightTipTime / 100) * 3600 + l_dinnerFightTipTime % 100 * 60
    l_guildData.dinnerFightStartTime = l_guildData.dinnerFightInfoShowTime + l_dinnerFightStartTime
    l_guildData.dinnerFightEndTime = l_guildData.dinnerFightStartTime + l_dinnerFightEndTime
end
--点击链接品尝菜肴
--dishUid  菜的UID
function ClickLinkToTasteDish(dishUid)

    if MScene.SceneID ~= DataMgr:GetData("GuildData").GUILD_SCENE_ID then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("ONLY_IN_GUILD_SCENE_CAN_TASTE"))
        return
    end

    local l_dishEntity = MEntityMgr:GetEntity(dishUid)
    if not l_dishEntity then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("CUR_GUILD_DINNER_DISH_TIME_OUT"))
        return
    end

    MEventMgr:LuaFireEvent(MEventType.MEvent_GuildDinner_ShowMenu, l_dishEntity)

end
function setRichTextPropImgClickEvent(propId, eventData)
    local l_extraData = {
        relativeScreenPosition = eventData.position,
        bottomAlign = true
    }
    local l_itemData = Data.BagModel:CreateItemWithTid(propId)
    MgrMgr:GetMgr("ItemTipsMgr").ShowTipsDisplay(l_itemData, nil, nil, nil, false, l_extraData)
end
function ShowOpenDinnerWishDialog()
    if l_guildData.HasOpenDinnerWish() then
        local l_openPlayer = l_guildData.GetDinnerWishOpener()
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("DINNER_WISH_HAS_OPEN", l_openPlayer))
        return
    end
    local l_coinPropId, l_needCoinNum = l_guildData.GetOpenDinnerWishNeedCoinInfo()
    local l_openWishPropId, l_needPropNum = l_guildData.GetOpenDinnerWishNeedPropInfo()
    local l_coinItem = TableUtil.GetItemTable().GetRowByItemID(l_coinPropId)
    local l_openWishItem = TableUtil.GetItemTable().GetRowByItemID(l_openWishPropId)

    if MLuaCommonHelper.IsNull(l_coinItem) or MLuaCommonHelper.IsNull(l_openWishItem) then
        logError("ItemTable not exist Id:" .. tostring(l_coinPropId) .. " or Id:" .. tostring(l_openWishPropId))
        return
    end

    local l_coinPropText = GetImageText(l_coinItem.ItemIcon, l_coinItem.ItemAtlas, 20, 26, false)
    local l_hasOpenWishPropNum = Data.BagModel:GetBagItemCountByTid(l_openWishPropId)
    local l_openWishPropTxt = GetImageText(l_openWishItem.ItemIcon, l_openWishItem.ItemAtlas, 20, 1, false)
    local l_content = Lang("OPEN_DINNER_WISH_DIALOG_CONTENT", l_openWishPropTxt, 
        MNumberFormat.GetNumberFormat(l_needPropNum), l_coinPropText, 
        MNumberFormat.GetNumberFormat(l_needCoinNum), l_openWishPropTxt, 
        MNumberFormat.GetNumberFormat(tostring(l_hasOpenWishPropNum)))

    local l_dialogExtraData = {
        imgClickInfos = {
            {
                imgName = l_openWishItem.ItemIcon,
                clickAction = function(spriteName, ed)
                    Common.CommonUIFunc.SetDialogRichTextPropClickEvent(l_openWishPropId, ed.position)
                end,
            },
            {
                imgName = l_coinItem.ItemIcon,
                clickAction = function(spriteName, ed)
                    Common.CommonUIFunc.SetDialogRichTextPropClickEvent(l_coinPropId, ed.position)
                end,
            },
        }
    }    local l_confirm = Common.Utils.Lang("DLG_BTN_YES")
    local l_cancel = Common.Utils.Lang("DLG_BTN_NO")

    local dlgType = CommonUI.Dialog.DialogType.YES_NO
    if Data.BagModel:IsDiamond(l_coinPropId) then
        dlgType = CommonUI.Dialog.DialogType.PaymentConfirm
    end

    CommonUI.Dialog.ShowDlg(CommonUI.Dialog.DialogType.PaymentConfirm,true,Lang("OPEN_WISH"), l_content,
            Common.Utils.Lang("DLG_BTN_YES"),Common.Utils.Lang("DLG_BTN_NO"),function()
        if l_guildData.HasOpenDinnerWish() then
            local l_openPlayer = l_guildData.GetDinnerWishOpener()
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("DINNER_WISH_HAS_OPEN", l_openPlayer))
            return
        end
        local l_hasCoinNum = Data.BagModel:GetCoinNumById(l_coinPropId)
        if l_hasOpenWishPropNum < l_needPropNum and l_hasCoinNum < l_needCoinNum then
            if not MLuaCommonHelper.IsNull(l_coinItem) then
                MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("LEVEL_REWARD_PROP_NOT_ENOUGTH", l_coinItem.ItemName))
            end
            return
        end
        ReqOpenDinnerWish()
    end, nil, nil, nil, nil, nil, nil, nil, UnityEngine.TextAnchor.MiddleLeft, l_dialogExtraData)
end
--region ==================================  CS调用 ===============================================
function OnNpcDisappear(npcId)

    MgrMgr:GetMgr("NpcTalkDlgMgr").OnNpcDisappear(npcId)
end
local l_tempData = nil
function ShowGuildDinnerMenuTips(dishEntity, isEatAlready)
    --菜谱数据未更新到位时不显示
    if l_guildData.curDishData.makers == nil then
        return
    end
    l_guildData.curDishData.dishEntity = dishEntity
    local l_openData = {
        type = l_guildData.EUIOpenType.GuildDinnerMenuTips,
        dishData = l_guildData.curDishData,
        isEated = isEatAlready
    }
    l_tempData = l_openData
    UIMgr:ActiveUI(UI.CtrlNames.GuildDinnerMenuTips, l_openData)
end

function OnGuildEat()
    UIMgr:ActiveUI(UI.CtrlNames.CommonMask, function(ctrl)
        ctrl:SetGuildCookInfo()
    end)
end

function OnGuildEffect()
    UIMgr:ActiveUI(UI.CtrlNames.CommonMask, function()
        local l_ui = UIMgr:GetUI(UI.CtrlNames.CommonMask)
        if l_ui then
            local l_fxData = MFxMgr:GetDataFromPool()
            l_fxData.playTime = 2
            l_fxData.loadedCallback = function(go)
                go:SetActiveEx(false)
                go:SetActiveEx(true)
                MLuaClientHelper.PlayFxHelper(go)
            end
            l_ui:SetEffectInfo("Effects/Prefabs/Creature/Ui/Fx_Ui_XianGaiZi_01", l_fxData)
            MFxMgr:ReturnDataToPool(l_fxData)
        else
            UIMgr:DeActiveUI(UI.CtrlNames.CommonMask)
        end
    end)
end
function OnDinnerOpenChampagneEffect()
    UIMgr:ActiveUI(UI.CtrlNames.CommonMask, function()
        local l_ui = UIMgr:GetUI(UI.CtrlNames.CommonMask)
        if l_ui then
            local l_fxData = MFxMgr:GetDataFromPool()
            l_fxData.playTime = 2
            l_fxData.scaleFac = Vector3.New(3, 3, 3)
            l_fxData.position = Vector3.New(0.3, -0.5, 0)
            l_fxData.loadedCallback = function(go)
                go:SetActiveEx(false)
                go:SetActiveEx(true)
                MLuaClientHelper.PlayFxHelper(go)
            end
            l_ui:SetEffectInfo("Effects/Prefabs/Creature/Ui/Fx_Ui_XiangBin_01", l_fxData)
            MFxMgr:ReturnDataToPool(l_fxData)
        else
            UIMgr:DeActiveUI(UI.CtrlNames.CommonMask)
        end
    end)
end
--endregion ================================= end CS调用 ===============================================

--region==================================  其他通用结构协议分支 ===============================================

---@param itemUpdateDataList ItemUpdateData[]
function _onItemUpdate(itemUpdateDataList)
    if nil == itemUpdateDataList then
        logError("[GuildDinner] invalid param")
        return
    end

    local C_REASON_MAP = {
        [ItemChangeReason.ITEM_REASON_GUILD_DINNER_SCENE_REWARD] = Common.Utils.Lang("GUILD_COOK_EXP_TIPS2"),
        [ItemChangeReason.ITEM_REASON_GUILD_DINNER_CHAMPAGNE_EXP] = Common.Utils.Lang("GET_GUILD_DINNER_CHAMPAGNE_REWARD"),
        [ItemChangeReason.ITEM_REASON_COOK_DUNGEONS_WEEKEND] = Common.Utils.Lang("WEEK_COOK_REWARD_TIP"),
    }

    local reasonMap = {}
    for i = 1, #itemUpdateDataList do
        local singleUpdateData = itemUpdateDataList[i]
        local reason = singleUpdateData.Reason
        local reasonStr = C_REASON_MAP[reason]
        if nil ~= reasonStr then
            reasonMap[reason] = reasonStr
        end
    end

    for key, value in pairs(reasonMap) do
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(value)
    end
end

--endregion================================= end 其他通用结构协议分支 ===============================================

--region==================================  RPC ===============================================
function SendGuildDinnerViewMenuReq()
    local l_msgId = Network.Define.Rpc.GuildDinnerViewMenu
    ---@type GuildDinnerViewMenuArg
    local l_sendInfo = GetProtoBufSendTable("GuildDinnerViewMenuArg")
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

function OnGuildDinnerViewMenuRsp(msg)
    ---@type GuildDinnerViewMenuRes
    local l_info = ParseProtoBufToTable("GuildDinnerViewMenuRes", msg)
    if l_info.error_code ~= 0 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.error_code))
        MPlayerInfo:FocusToMyPlayer()
        return
    end
    --设置菜单数据
    l_guildData.SetGuildDinnerMenu(l_info.menu_list)

    MgrMgr:GetMgr("NpcTalkDlgMgr").CloseTalkDlg()
    UIMgr:ActiveUI(UI.CtrlNames.GuildBanquet)
end

function SendGuildDinnerTaskAcceptReq()
    require "Command/CommandMacro"
    local l_msgId = Network.Define.Rpc.GuildDinnerTaskAccept
    ---@type GuildDinnerTaskAcceptArg
    local l_sendInfo = GetProtoBufSendTable("GuildDinnerTaskAcceptArg")
    l_sendInfo.npc_uuid = tostring(CommandMacro.NPCUuid())
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

function OnGuildDinnerTaskAcceptRsp(msg)
    ---@type GuildDinnerTaskAcceptRes
    local l_info = ParseProtoBufToTable("GuildDinnerTaskAcceptRes", msg)
    if l_info.error_code ~= 0 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.error_code))
        MgrMgr:GetMgr("NpcTalkDlgMgr").CloseTalkDlg()
        return
    end
    MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("GUILD_COOK_TASK"))
end

--获取公会宴会当前菜的状态（CS请求 两边同时收）
function OnGuildDinnerGetDishNPCState(msg, arg)
    ---@type GuildDinnerGetDishNPCStateRes
    local l_info = ParseProtoBufToTable("GuildDinnerGetDishNPCStateRes", msg)

    if l_info.error_code == 0 then
        l_guildData.curDishData = {}
        l_guildData.curDishData.dishCount = l_info.dish_count
        l_guildData.curDishData.costTime = l_info.cost_time
        l_guildData.curDishData.endTime = l_info.end_time
        l_guildData.curDishData.makers = l_info.makers
    else
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.error_code))
    end

end

--请求品尝(品尝动画结束后请求)
function ReqTasteDish()
    if l_guildData.curDishData and l_guildData.curDishData.dishEntity then
        MEventMgr:LuaFireEvent(MEventType.MEvent_GuildEat, l_guildData.curDishData.dishEntity)
    end
end

--接收请求品尝结果（Cs lua两边同时收）
function OnReqTasteDish(msg)
    ---@type GuildDinnerEatDishRes
    local l_info = ParseProtoBufToTable("GuildDinnerEatDishRes", msg)
    if l_info.error_code ~= 0 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.error_code))
        return
    end

    MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("GUILD_DINNER_TASTE_SUCCESS"))
    if l_info.item ~= nil and l_info.item.item_id > 0 then
        --展示多倍奖励
        local l_extraData = {
            titleName = Lang("MULTIPLE_REWARDS_TIPS"),
            playMultipleRewardEffect = true,
        }
        MgrMgr:GetMgr("TipsMgr").ShowSpecialItemTips(l_info.item.item_id, l_info.item.item_count, nil, l_extraData)
    end
end

--请求分享宴会品尝
function ReqGuildDinnerShareDish()
    if l_guildData.curDishData and l_guildData.curDishData.dishEntity then
        local l_msgId = Network.Define.Rpc.GuildDinnerShareDish
        ---@type GuildDinnerShareDishArg
        local l_sendInfo = GetProtoBufSendTable("GuildDinnerShareDishArg")

        l_sendInfo.dish_uuid = tostring(l_guildData.curDishData.dishEntity.UID)
        Network.Handler.SendRpc(l_msgId, l_sendInfo)
    end
end

--请求分享宴会品尝的结果接收
function OnGuildDinnerShareDish(msg)
    ---@type GuildDinnerShareDishRes
    local l_info = ParseProtoBufToTable("GuildDinnerShareDishRes", msg)

    if l_info.error.errorno == 0 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("ShareSucceedText"))
    elseif l_info.error.errorno == 1683 then
        --还有%s秒才能分享
        local l_tips = StringEx.Format(Common.Functions.GetErrorCodeStr(l_info.error.errorno), tostring(l_info.error.param[1].value))
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(l_tips)
    else
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.error.errorno))
    end
end

--请求参与大乱斗的人数
function ReqGuildDinnerCreamMeleeRenshu()
    local l_msgId = Network.Define.Rpc.GuildDinnerCreamMeleeRenshu
    ---@type GuildDinnerCreamMeleeRenshuArg
    local l_sendInfo = GetProtoBufSendTable("GuildDinnerCreamMeleeRenshuArg")
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

--接收大乱斗人数消息
function OnReqGuildDinnerCreamMeleeRenshu(msg)
    ---@type GuildDinnerCreamMeleeRenshuData
    local l_info = ParseProtoBufToTable("GuildDinnerCreamMeleeRenshuData", msg)

    l_guildData.dinnerFightTotalNum = l_info.total_count
    l_guildData.dinnerFightCurNum = l_info.alive_count

    if l_guildData.dinnerFightCurNum > 0 and l_guildData.dinnerFightTotalNum > tonumber(TableUtil.GetGuildActivityTable().GetRowBySetting("BanquetFightEventNum").Value) then
        UIMgr:ActiveUI(UI.CtrlNames.GuildDinnerFightInfo, { isGuildDinnerFightStart = true })
    end
end

--请求与石像拍照的奖励
function ReqPhotoWithStoneStatueAward(roleId)
    local l_msgId = Network.Define.Rpc.GuildDinnerGetPhotoAward
    ---@type GuildDinnerGetPhotoAwardArg
    local l_sendInfo = GetProtoBufSendTable("GuildDinnerGetPhotoAwardArg")
    l_sendInfo.role_id = roleId
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end

--接收与石像拍照的奖励结果
function OnReqPhotoWithStoneStatueAward(msg)
    ---@type GuildDinnerGetPhotoAwardRes
    local l_info = ParseProtoBufToTable("GuildDinnerGetPhotoAwardRes", msg)

    if l_info.error ~= 0 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.error.errorno))
    end
end

function ReqGuildCookingScoreInfo()
    local l_msgId = Network.Define.Rpc.GuildDinnerGetCompetitionResult
    ---@type GuildDinnerGetCompetitionResultArg
    local l_sendInfo = GetProtoBufSendTable("GuildDinnerGetCompetitionResultArg")
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end
function OnReqGuildCookingScoreInfo(msg)
    ---@type GuildDinnerGetCompetitionResultRes
    local l_info = ParseProtoBufToTable("GuildDinnerGetCompetitionResultRes", msg)
    l_guildData.SetGuildCookScoreInfo(l_info.competiton_list)
    EventDispatcher:Dispatch(UPDATE_GUILD_SCORE_INFO)
end
function ReqPersonalCookingScoreInfo(onlyMyGuild)
    local l_msgId = Network.Define.Rpc.GuildDinnerGetPersonResult
    ---@type GuildDinnerGetPersonResultArg
    local l_sendInfo = GetProtoBufSendTable("GuildDinnerGetPersonResultArg")
    l_sendInfo.is_personal = onlyMyGuild and 1 or 0
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end
function OnReqPersonalCookingScoreInfo(msg, arg)
    ---@type GuildDinnerGetPersonResultRes
    local l_info = ParseProtoBufToTable("GuildDinnerGetPersonResultRes", msg)

    local l_isAll = arg.is_personal == 0
    l_guildData.SetGuildCookScorePersionalRank(l_info.person_list, l_isAll)

    EventDispatcher:Dispatch(UPDATE_COOK_PERSONAL_RANK, l_isAll)
end
--@Description:请求开启香槟祝福
function ReqOpenDinnerWish()
    local l_msgId = Network.Define.Rpc.GuildDinnerOpenChampagne
    Network.Handler.SendRpc(l_msgId, nil)
end
function OnReqOpenDinnerWish(msg)
    ---@type GuildDinnerOpenChampagneRes
    local l_info = ParseProtoBufToTable("GuildDinnerOpenChampagneRes", msg)
    if l_info.result ~= nil then
        if l_info.result.errorno ~= 0 then
            if l_info.result.errorno == ErrorCode.ERR_IN_PAYING then
                game:GetPayMgr():RegisterPayResultCallback(Network.Define.Rpc.GuildDinnerOpenChampagne, OnOpenDinnerPaySuccess)
            elseif l_info.result.errorno == ErrorCode.ERR_GUILD_DINNER_CHAMPAGNE_HAS_OPEND then
                if string.len(l_info.result.message) > 0 then
                    l_guildData.SetDinnerWishOpener(l_info.result.message)
                    MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("DINNER_WISH_HAS_OPEN", l_info.result.message))
                end
            else
                MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Functions.GetErrorCodeStr(l_info.result.errorno))
            end
        end
    end
end
function OnOpenDinnerPaySuccess()
end
function OnGuildDinnerOpenChampagneNtf(msg)
    ---@type GuildDinnerOpenChampagneData
    local l_info = ParseProtoBufToTable("GuildDinnerOpenChampagneData", msg)
    local l_roleName = l_info.role_name
    if string.len(l_roleName) > 0 then
        l_guildData.SetDinnerWishOpener(l_roleName)
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("DINNER_WISH_HAS_OPEN", l_roleName))
        OnDinnerOpenChampagneEffect()
        return
    end
end
function OnGuildDinnerRandomEventNtf(msg)
    ---@type GuildDinnerRandomEventNtfData
    local l_info = ParseProtoBufToTable("GuildDinnerRandomEventNtfData", msg)
    l_guildData.SetRandomEventStartTime(l_info.event_start_time)

    if not UIMgr:IsActiveUI(UI.CtrlNames.GuildDinnerFightInfo) then
        UIMgr:ActiveUI(UI.CtrlNames.GuildDinnerFightInfo, { isShowRandomEvent = true })
    else
        EventDispatcher:Dispatch(UPDATE_RANDOM_EVENT_TIME)
    end
end
function ReqCheckGuildDinnerOpen()
    local l_msgId = Network.Define.Rpc.CheckGuildDinnerOpen
    ---@type NullArg
    local l_sendInfo = GetProtoBufSendTable("NullArg")
    Network.Handler.SendRpc(l_msgId, l_sendInfo)
end
function OnCheckGuildDinnerOpen(msg)
    ---@type CheckGuildDinnerOpenRes
    local l_info = ParseProtoBufToTable("CheckGuildDinnerOpenRes", msg)
    if l_info.is_open then
        if not UIMgr:IsActiveUI(UI.CtrlNames.GuildDinnerFightInfo) then
            UIMgr:ActiveUI(UI.CtrlNames.GuildDinnerFightInfo, {
                isGuildCookStart = true,
            })
        else
            EventDispatcher:Dispatch(UPDATE_GUILD_COOK_COMPETITION_STATE, true)
        end
    end
end
--endregion================================= end RPC ===============================================

--region==================================  PTC ===============================================
--接收别人的宴会品尝分享信息
function OnGuildDinnerShareDishNtf(msg)
    ---@type GuildDinnerShareDishNtfData
    local l_info = ParseProtoBufToTable("GuildDinnerShareDishNtfData", msg)

    local l_chatMgr = MgrMgr:GetMgr("ChatMgr")
    local l_chatDataMgr = DataMgr:GetData("ChatData")
    local l_linkSt, l_linkPack = MgrMgr:GetMgr("LinkInputMgr").GetCookingPack("", l_info.dish_uuid)
    l_chatMgr.DoHandleMsgNtf(
            l_info.role_id,
            l_chatDataMgr.EChannel.GuildChat,
            Lang("GUILD_DINNER_DISH_SHARE_CHAT", l_info.names, l_info.dish_count, l_linkSt),
            "StoneLink", nil, true,
            { MsgParam = l_linkPack }
    )
end

--接收大乱斗倒计时开始信息
function OnGuildDinnerCreamMeleeStart(msg)
    --UIMgr:ActiveUI(UI.CtrlNames.GuildDinnerFightInfo)
end
--接收大乱斗结束信息
function OnGuildDinnerCreamMeleeEnd(msg)
    EventDispatcher:Dispatch(UPDATE_GUILD_DINNER_FIGHT_SHOW_STATE, false)
    l_guildData.ReleaseGuildDinnerFightInfo()
end


--接收大乱斗的参与人数变化
function OnGuildDinnerCreamMeleeMemberChange(msg)
    ---@type GuildDinnerCreamMeleeRenshuData
    local l_info = ParseProtoBufToTable("GuildDinnerCreamMeleeRenshuData", msg)

    l_guildData.dinnerFightTotalNum = l_info.total_count
    l_guildData.dinnerFightCurNum = l_info.alive_count

    --如果大乱斗信息界面未开启则打开界面
    if not UIMgr:IsActiveUI(UI.CtrlNames.GuildDinnerFightInfo) then
        UIMgr:ActiveUI(UI.CtrlNames.GuildDinnerFightInfo, { isGuildDinnerFightStart = true })
    else
        EventDispatcher:Dispatch(UPDATE_GUILD_DINNER_FIGHT_MEMBER_NUM)
    end
end


--接收公会宴会有人变成石像信息
function OnGuildDinnerPetrifactionNtf(msg)
    ---@type UserID
    local l_info = ParseProtoBufToTable("UserID", msg)
    local l_entity = MEntityMgr:GetEntity(l_info.uid)
    if l_entity then
        MoonClient.MCheckInCameraManager.AddEntityCheckInCamera(9999, l_info.uid)
        GlobalEventBus:Add(EventConst.Names.PhotographCompleted, function(object, photoObjectIds)
            local l_photoObjectIds = Common.Functions.ListToTable(photoObjectIds)
            for k, v in pairs(l_photoObjectIds) do
                if v == 9999 then
                    ReqPhotoWithStoneStatueAward(l_info.uid)
                end
            end
        end, MgrMgr:GetMgr("GuildDinnerMgr"))
    end
end

--接收公会宴会有人变成石像结束信息
function OnGuildDinnerPetrifactionEndNtf(msg)
    ---@type UserID
    local l_info = ParseProtoBufToTable("UserID", msg)

    local l_entity = MEntityMgr:GetEntity(l_info.uid)
    if l_entity then
        MoonClient.MCheckInCameraManager.RemoveEntityCheckInCamera(l_info.uid)
    end
    GlobalEventBus:RemoveObjectAllFunc(EventConst.Names.PhotographCompleted, MgrMgr:GetMgr("GuildDinnerMgr"))
end
function showCookRankInfo()
    local l_dailyTaskMgr = MgrMgr:GetMgr("DailyTaskMgr")
    local l_isOpenState = l_dailyTaskMgr.IsActivityOpend(l_dailyTaskMgr.g_ActivityType.activity_GuildCookWeek)

    l_dailyTaskMgr.EventDispatcher:RemoveObjectAllFunc(l_dailyTaskMgr.DAILY_ACTIVITY_STATE_CHANGE, GuildDinnerMgr)
    l_dailyTaskMgr.EventDispatcher:Add(l_dailyTaskMgr.DAILY_ACTIVITY_STATE_CHANGE, OnGuildCookWeekStateChanged)

    OnGuildCookWeekStateChanged(l_dailyTaskMgr.g_ActivityType.activity_GuildCookWeek, l_isOpenState)
end
function OnGuildCookWeekStateChanged(activityId, isOpen)
    if MScene.SceneID ~= DataMgr:GetData("GuildData").GUILD_SCENE_ID then
        return
    end
    local l_dailyMgr = MgrMgr:GetMgr("DailyTaskMgr")
    if activityId ~= l_dailyMgr.g_ActivityType.activity_GuildCookWeek then
        return
    end
    if isOpen then
        --服务器再次验证开启状态
        ReqCheckGuildDinnerOpen()
        -- 清楚公会宴会的数据
        l_guildData.InitGuildDinnerInfo()
    else
        l_guildData.ClearRankInfo()
        EventDispatcher:Dispatch(UPDATE_GUILD_COOK_COMPETITION_STATE, false)
    end
end

--endregion================================= end PTC ===============================================
return GuildDinnerMgr