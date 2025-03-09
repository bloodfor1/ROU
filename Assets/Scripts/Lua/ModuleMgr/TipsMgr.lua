---@module ModuleMgr.TipsMgr
module("ModuleMgr.TipsMgr", package.seeall)

--缓存一个TipsData的引用
EventDispatcher = EventDispatcher.new()

local l_tipsData = DataMgr:GetData("TipsData")

function OnLogout()
    ClearImportantNotice()
    local gameEventMgr = MgrMgr:GetMgr("GameEventMgr")
    gameEventMgr.RaiseEvent(gameEventMgr.TipsOnSysLogout)
    --登出的时候把飘字关了，进入场景还会开
    UIMgr:DeActiveUI(UI.CtrlNames.TipsDlg)
end

function OnEnterScene(sceneId)
    if not UIMgr:IsActiveUI(UI.CtrlNames.TipsDlg) then
        UIMgr:ActiveUI(UI.CtrlNames.TipsDlg)
    end
    EventDispatcher:Dispatch(l_tipsData.ETipsEvent.EnterScene)
end

function OnLuaDoEnterScene()
    MgrMgr:GetMgr("TipsMgr").PopPendingNormalTips()
end

--function OnReconnected(reconnectData)
--    UIMgr:DeActiveUI(UI.CtrlNames.TipsDlg)
--end

------------------------------以下TipsDialog----------------------------

--显示特效类型的Tips
function ShowFxTips(fxPath, width, height, time)
    EventDispatcher:Dispatch(l_tipsData.ETipsEvent.ETipsEvent.Show_Fx_Tips_Event, fxPath, width, height, time)
end

--根据ErrorCode显示Tips
function ShowErrorCodeTips(errorCode)
    if errorCode then
        ShowNormalTips(Common.Functions.GetErrorCodeStr(errorCode))
    end
end

---普通提示,飘正中央,带黑框底
function ShowNormalTips(str)
    if str == nil or str == "" or str == "nil" then
        if Application.isEditor then
            logError("Tips内容为空，检查下逻辑和配置")
        end
        return
    end

    --服务器返回过来的ErrorCode有的是不需要显示的 在GetErrorCodeStr那里返回了字符串"NotShow"直接Return
    if str == "NotShow" then
        return
    end

    if MStageMgr.IsSwitchingScene then
        --切场景时不弹tips，进pending队列，切完后再弹
        table.insert(l_tipsData:GetPendingNormalTips(), str)
    else
        EventDispatcher:Dispatch(l_tipsData.ETipsEvent.Show_Normal_Tips_Event, "Normal", str)
    end
end

function ShowNormalTipsWithLang(langKey)
    ShowNormalTips(Lang(langKey))
end

function PopPendingNormalTips()
    local l_tmp = l_tipsData:GetPendingNormalTips()
    l_tipsData:ResetPendingNormalTips()
    for i, v in ipairs(l_tmp) do
        ShowNormalTips(v)
    end
end

---属性提示,飘正中央偏下
function ShowAttrTips(str)
    EventDispatcher:Dispatch(l_tipsData.ETipsEvent.Show_Attr_Tips_Event, "Attr", str)
end

---属性2提示,飘正中央偏下
function ShowAttr2Tips(str)
    EventDispatcher:Dispatch(l_tipsData.ETipsEvent.Show_Attr_2_Tips_Event, "Attr2", str)
end

function ShowAttr2ListTips(strTb)
    for _, v in pairs(strTb) do
        ShowAttr2Tips(v)
    end
end

---属性List提示,飘正中央偏下
function ShowAttrListTips(strTb)
    local cTb = ChangeStringTb(strTb)
    EventDispatcher:Dispatch(l_tipsData.ETipsEvent.Show_Attr_List_Tips, cTb)
end

--单行显示 切换 双行显示
function ChangeStringTb(strTb)
    local cStringTb = {}
    local cString = ""
    for i = 1, table.maxn(strTb) do
        cString = cString .. "  " .. strTb[i]
        if i % 2 == 0 then
            table.insert(cStringTb, cString)
            cString = ""
        end

        if i == table.maxn(strTb) and table.maxn(strTb) % 2 ~= 0 then
            table.insert(cStringTb, cString)
            cString = ""
        end
    end
    return cStringTb
end

---任务提示,飘正中央偏上
function ShowTaskTips(str)
    EventDispatcher:Dispatch(l_tipsData.ETipsEvent.Show_Task_Tips_Event, "Task", str)
end

---主要公告,正上方跑马灯;
--如果设置持续时间为0 则直接关闭  -1表示长时间显示
function ShowImportantNotice(str, duration)
    if duration == 0 then
        ClearImportantNotice()
        return
    end
    EventDispatcher:Dispatch(l_tipsData.ETipsEvent.Show_Important_Notice_Event, str, duration)
end

---主要公告,正上方跑马灯
function ClearImportantNotice()
    EventDispatcher:Dispatch(l_tipsData.ETipsEvent.Clear_Important_Notice_Event)
end

---次级公告,底部跑马灯
function ShowSecondaryNotice(str)
    EventDispatcher:Dispatch(l_tipsData.ETipsEvent.Show_Secondary_Notice_Event, str)
end

--普通玩家喇叭,聊天框上部分
function ShowNormalTrumpet(str)
    EventDispatcher:Dispatch(l_tipsData.ETipsEvent.Show_Normal_Trumpet_Event, str)
end

--掉落Tips
function ShowItemDropNotice(id, num)
    EventDispatcher:Dispatch(l_tipsData.ETipsEvent.Show_Item_Drop_Notice_Event, id, num)
end

--被点赞提示 cmd 2018/07/16
function ShowItemPraiseNotice(roleId)
    EventDispatcher:Dispatch(l_tipsData.ETipsEvent.Show_Item_Praise_Notice_Event, roleId)
end

--提示型的Tips
function ShowQuestionTip(str, eventData, pivot, useFitter, maxWidth, pressCamera, isPassThrough, fontsize)
    if useFitter == nil then
        useFitter = false
    end
    if maxWidth == nil then
        maxWidth = 360
    end
    EventDispatcher:Dispatch(l_tipsData.ETipsEvent.Show_Question_Tip_Event, str, eventData, pivot, useFitter, maxWidth, pressCamera, isPassThrough, fontsize)
end

--战斗型的Tips
function ShowBattleTips(str, forceUpdate)
    EventDispatcher:Dispatch(l_tipsData.ETipsEvent.Show_Battle_Tip_Event, str, forceUpdate)
end

--副本型的Tips
function ShowDungeonTips(str)
    EventDispatcher:Dispatch(l_tipsData.ETipsEvent.Show_Dungeon_Tips_Event, str)
end

function HideQuestionTip()
    EventDispatcher:Dispatch(l_tipsData.ETipsEvent.Hide_Question_Tip_Event, str)
end

--文字提示型Tips C#在用
function ShowMiddleUpTips(str)
    EventDispatcher:Dispatch(l_tipsData.ETipsEvent.Show_Middle_UpTips_Event, str, 0)
end

--文字提示型Tips C#在用
function ShowMiddleDownTips(str)
    EventDispatcher:Dispatch(l_tipsData.ETipsEvent.Show_Middle_DownTips_Event, str, 1)
end

--关闭副本旁白
function CloseDungeonHintsStory()
    EventDispatcher:Dispatch(l_tipsData.ETipsEvent.Close_Dungeon_Hints_Story)
end

------------------------------以上TipsDialog----------------------------
-- 公会点赞信息
function ShowLikesDialog(title, mainInfo, defaultInfo, additionData, func)
    local l_panelOpenData = {
        openType = l_tipsData.ETipsOpenType.GuildLikesOpen,
        title = title,
        mainInfo = mainInfo,
        defaultInfo = defaultInfo,
        additionData = additionData,
        func = func
    }
    UIMgr:ActiveUI(UI.CtrlNames.LikesDialog, l_panelOpenData)
end

-- 怪物信息提示数据
-- todo CLX：不要传回调进来改中心，调位置，屏幕适配做代码里面了
function ShowMonsterInfoTips(EntityId, Pos, IsMask, FindSceneId, ShowGotoPosBtn)
    ---怪物信息 pos:vector3;
    local l_openData = {
        openType = l_tipsData.MonsterInfoTipsOpenType.ShowTips,
        entityId = EntityId,
        pos = Pos,
        isMask = IsMask,
        findSceneId = FindSceneId,
        showGotoPosBtn = ShowGotoPosBtn
    }

    UIMgr:ActiveUI(UI.CtrlNames.MonsterInfoTips, l_openData)
end

function ShowMonsterInfoTipsFromMap(EntityId, pos, isMask, findSceneId, monsterRectT)
    ShowMonsterInfoTips(EntityId, pos, isMask, findSceneId, true)
end

function HideMonsterInfoTips()
    UIMgr:DeActiveUI(UI.CtrlNames.MonsterInfoTips)
end

--提示性Tips
function ShowMarkTips(title, infoText, eventData, pivot, pressCamera, isPassThrough)
    --isPassThrough是否点穿
    UIMgr:ActiveUI(UI.CtrlNames.MarkTips, function(ctrl)
        ctrl:SetMarkTips(title, infoText, eventData, pivot, pressCamera, isPassThrough)
    end)
end

--特殊的跑马灯
function ShowHorseLampTips(info, existTime, runSpeed, runDirect, runCircel, finishFunc)
    if info ~= nil then
        UIMgr:DeActiveUI(UI.CtrlNames.HorseLamp)
        UIMgr:ActiveUI(UI.CtrlNames.HorseLamp, function(ctrl)
            ctrl:ShowHorseLamp(info, existTime, runSpeed, runDirect, runCircel, finishFunc)
        end)
    end
end

--特殊的道具获取
function ShowGetSpecialItemTips(title, content, btn01Txt, btn02Txt, btn01Func, btn02Func, consume, titleSprite)
    UIMgr:ActiveUI(UI.CtrlNames.GetSpecialItemDialog, function(ctrl)
        ctrl:SetDlgInfo(title, content, btn01Txt, btn02Txt, btn01Func, btn02Func, consume, titleSprite)
    end)
end

--返回icon+name x number
function GetNormalItemTips(id, count)
    return GetItemText(id, { num = count, icon = { size = 19, width = 1 } })
end

function GetItemIconTips(id)
    return GetItemIconText(id, 19, 1)
end

--显示特殊道具获取提示
--itemId 道具Id
--itemCount 道具数量
--btnOkFunc 点击回调
--additionData 附加数据
function ShowSpecialItemTips(itemId, itemCount, btnOkFunc, additionData)
    local l_openData = {
        openType = l_tipsData.ESpecialTipsOpenType.ShowSpecialItem,
        itemId = itemId,
        itemCount = itemCount,
        btnOkFunc = btnOkFunc,
        additionData = additionData
    }
    UIMgr:ActiveUI(UI.CtrlNames.SpecialTips, l_openData)
end

--显示特殊字符串获取提示
function ShowSpecialStrTips(str, btnOkFunc, isShowCloseBtn)
    local l_openData = {
        openType = l_tipsData.ESpecialTipsOpenType.ShowSpecialStr,
        str = str,
        btnOkFunc = btnOkFunc,
        isShowCloseBtn = isShowCloseBtn,
    }
    UIMgr:ActiveUI(UI.CtrlNames.SpecialTips, l_openData)
end

function ShowSpecialAwardListTips(itemData, btnOkFunc, isShowCloseBtn)
    local l_openData = {
        openType = l_tipsData.ESpecialTipsOpenType.ShowSpecialItemList,
        itemData = itemData,
        btnOkFunc = btnOkFunc,
        isShowCloseBtn = isShowCloseBtn,
    }
    UIMgr:ActiveUI(UI.CtrlNames.SpecialTips, l_openData)
end

--params
--  title       标题
--  content     正文
-- relativeTransform 跟随节点
-- hideTitle    隐藏标题
-- horizontalFit 设置背景Filtter
function ShowTipsInfo(params)
    UIMgr:ActiveUI(UI.CtrlNames.TipsInfo, function(ctrl)
        ctrl:SetParams(params)
    end)
end

function HideTipsInfo()
    if UIMgr:IsActiveUI(UI.CtrlNames.TipsInfo) then
        UIMgr:DeActiveUI(UI.CtrlNames.TipsInfo)
    end
end

function ShowExplainPanelTips(params)
    UIMgr:ActiveUI(UI.CtrlNames.ExplainPanelTips, function(ctrl)
        ctrl:SetInfo(params)
    end)
end

--next--
function ShowQualityChangeTips(curLevel, targetLevel, frameRateTipsTime)
    --C#call
    local l_strCurLevelText = CommonUI.Quality.GetName(curLevel)
    local l_strTargetLevelText = CommonUI.Quality.GetName(targetLevel);
    local l_strTipsDesc = Common.Utils.Lang("LOW_FRAME_TIP", l_strCurLevelText, l_strTargetLevelText)

    local l_openData = {
        openType = MgrMgr:GetMgr("VehicleMgr").EOpenType.AddOfferInfo,

        okFuc = function()
            MQualityGradeSetting.SetCurLevel(targetLevel)
        end,
        nameTxt = Common.Utils.Lang("LOW_FRAME_TIP_TITLE"),
        labTxt = l_strTipsDesc,
        totalTime = frameRateTipsTime,
        cTime = 0,
        timeOverIsCancle = true,
        strBtnYesKey = "DLG_BTN_OK"
    }
    UIMgr:ActiveUI(UI.CtrlNames.VehicleOffer, l_openData)

end --func end

function ShowTimedQuestionTip(leftTime, str, ed, pivot, worldEventId)
    local sdata = TableUtil.GetWorldEventTable().GetRowByID(worldEventId)
    if not sdata then
        return
    end

    local redColorStr = RoColorTag.Red
    local yellowColorStr = RoColorTag.Yellow
    local greenColorStr = RoColorTag.Green

    local colorStr = ""
    local lvColorStr = ""
    if leftTime < l_tipsData:GetEventWarningTime1() * 60 and leftTime >= l_tipsData:GetEventWarningTime2() * 60 then
        colorStr = yellowColorStr
    elseif leftTime >= 0 and leftTime < l_tipsData:GetEventWarningTime2() * 60 then
        colorStr = redColorStr
    end

    local delta = sdata.RecommendLevel - MPlayerInfo.Lv
    if delta >= 5 then
        lvColorStr = redColorStr
    elseif delta <= -5 then
        lvColorStr = greenColorStr
    else
        lvColorStr = yellowColorStr
    end

    if not IsEmptyOrNil(sdata.WorldDes) then
        str = sdata.WorldDes
    end

    local contents = {}
    table.insert(contents, str)
    table.insert(contents, Lang("WORLD_EVENT_RECOMMAND_LEVEL", GetColorText(sdata.RecommendLevel, lvColorStr)))
    table.insert(contents, GetColorText(Lang("WORLD_EVENT_LEFT_TIME", math.ceil(leftTime / 60)), colorStr))

    MgrMgr:GetMgr("TipsMgr").ShowQuestionTip(table.concat(contents, '\n'), ed, pivot)
end

--- itemChange数据当中是没有错误码的
---@param itemPairList ItemIdCountPair
---@param title string
---@param tipsTitle string
function ShowAwardItemTips(itemPairList, title, tipsTitle)
    if nil == itemPairList then
        logError("[TipsMgr] invalid param")
        return
    end

    if 0 == #itemPairList then
        return
    end

    local C_TIPS_TYPE_MAP = {
        [GameEnum.EGainItemTipsType.SpecialTips] = 1,
        [GameEnum.EGainItemTipsType.HighQualityTips] = 1,
    }

    if 1 == #itemPairList then
        local itemConfig = TableUtil.GetItemTable().GetRowByItemID(itemPairList[1].id)
        if nil ~= C_TIPS_TYPE_MAP[itemConfig.AccessPrompt] then
            _showSpecialTips(itemPairList[1].id, itemPairList[1].count)
        else
            _showLifeProfessionReward(itemPairList, title, tipsTitle)
        end

        return
    end

    _showLifeProfessionReward(itemPairList, title, tipsTitle)
end

--- 显示特殊tips
---@param itemID number
---@param itemCount number
function _showSpecialTips(itemID, itemCount)
    if nil == itemID or nil == itemCount then
        logError("[TipsMgr] invalid param")
        return
    end

    local onClickClose = function()
        UIMgr:DeActiveUI(UI.CtrlNames.SpecialTips)
    end

    local l_openData = {
        openType = l_tipsData.ESpecialTipsOpenType.ShowSpecialItem,
        itemId = itemID,
        itemCount = itemCount,
        btnOkFunc = onClickClose,
    }

    UIMgr:ActiveUI(UI.CtrlNames.SpecialTips, l_openData)
end

--- 显示获取多个道具的奖励
---@param itemList ItemIdCountPair
---@param titleParam string
---@param tipsInfoParam string
function _showLifeProfessionReward(itemList, titleParam, tipsInfoParam)
    if nil == itemList then
        logError("[TipsMgr] invalid param")
        return
    end

    local l_openUIData = {
        type = DataMgr:GetData("LifeProfessionData").EUIOpenType.LifeProfessionReward_Tip,
        itemList = itemList,
        closeFunc = function()
            GlobalEventBus:Dispatch(EventConst.Names.ShowNextSpecialTip)
        end,
        tipsInfo = { title = titleParam, tipsInfo = tipsInfoParam }
    }

    UIMgr:ActiveUI(UI.CtrlNames.LifeProfessionReward, l_openUIData)
end

-- 获得道具的特效提示
function ShowGetItemTip(id, count, onClose, onCloseSelf, onCloseParam)
    local l_onCloseCb = function()
        UIMgr:DeActiveUI(UI.CtrlNames.SpecialTips)
        if onClose then
            if nil == onCloseSelf then
                onClose(onCloseParam)
                return
            end
            onClose(onCloseSelf, onCloseParam)
        end
    end
    MgrMgr:GetMgr("TipsMgr").ShowSpecialItemTips(id, count, l_onCloseCb)
end

return TipsMgr