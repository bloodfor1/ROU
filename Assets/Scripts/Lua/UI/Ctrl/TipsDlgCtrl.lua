--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/TipsDlgPanel"
require "Common/CommonScreenPosUtil"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua class define
local super = UI.UIBaseCtrl
TipsDlgCtrl = class("TipsDlgCtrl", super)
--lua class define end
SHOW_TIME = 90
PENDING_TIME = 30000
GAP_TIME = 15
NORMAL_GAP = -2
MOVE_SPEED = 2
MAX_TIPS_NUM = 3
DEFAULT_DISTANCE = 45
NEW_SPEED = 60
normalAddList = {}
attrAddList = {}
attrNewAddList = {}
taskAddList = {}

local l_praiseInitPos = Vector3.New(0, -150, 0)  --点赞容器动画的起始位置
local l_praiseTargetPos = Vector3.New(0, -80, 0)  --点赞容器动画的结束位置
local l_praiseShowTime = 30 --展示时间 这里的单位是 帧
local l_downPraiseItemOffset = 50  --两个展示项容器的安全车距 （防重叠）

local m_importantNotice = {}
local m_importantNoticeState = false
local m_importantNoticeTime = 3
local m_normalTrumpet = {}
local m_dropItem = {}
local m_trumpetSpeed = 2
local m_curMiddleStr = nil
local m_startTimer = nil
local m_curMiddleStrPos

local l_importantTimer = nil
local l_secondImportantTimer = nil
local l_importantPos = nil
local l_importantTweenId = 0

local l_upItem = {}
local l_downItem = {}
local l_curIndex = 0

local l_battleTips = {}
local l_battleTimer = nil
local l_dungeonTimer = nil
local l_attrObjs = {}
local BATTLE_TIPS_TIME = MGlobalConfig:GetFloat("BgNotificationTime")
local l_tipsMgr = MgrMgr:GetMgr("TipsMgr")
local l_tipsData = DataMgr:GetData("TipsData")

--lua functions
function TipsDlgCtrl:ctor()
    super.ctor(self, CtrlNames.TipsDlg, UILayer.Tips, nil, ActiveType.Standalone)
    self.cacheGrade = EUICacheLv.VeryLow
    self.overrideSortLayer = UILayerSort.Tips + 1
    self.preTime = {}
    self.preStr = {}
    self.attrList = {}
    if not self.nowNormalTips then
        self.nowNormalTips = {}
    end

    if not self.nowAttrTips then
        self.nowAttrTips = {}
    end

    if not self.nowTaskTips then
        self.nowTaskTips = {}
    end

    self.attrIsPlayNow = false
    --需要展示的点赞者ID列表
    self._praiseIds = {}
    --前一展示项容器
    self._upPraiseItem = {}
    --后一展示项容器
    self._downPraiseItem = {}
    --当前展示的点赞者ID
    self._curPraiseIndex = 0
end --func end
--next--
function TipsDlgCtrl:Init()
    self.panel = UI.TipsDlgPanel.Bind(self)
    super.Init(self)
    self.SecondaryNoticePos = self.panel.SecondaryNoticeText.gameObject.transform.localPosition

    self.startYPos = {}
    self.dangerHintUIEffect = {}
end --func end
--next--
function TipsDlgCtrl:Uninit()

    if m_startTimer then
        self:StopUITimer(m_startTimer)
        m_startTimer = nil
    end
    if l_importantTimer then
        self:StopUITimer(l_importantTimer)
        l_importantTimer = nil
    end
    if l_secondImportantTimer then
        self:StopUITimer(l_secondImportantTimer)
        l_secondImportantTimer = nil
    end
    if l_battleTimer then
        self:StopUITimer(l_battleTimer)
        l_battleTimer = nil
    end
    if l_dungeonTimer then
        self:StopUITimer(l_dungeonTimer)
        l_dungeonTimer = nil
    end
    super.Uninit(self)
    self.panel = nil
end --func end
--next--
function TipsDlgCtrl:OnActive()
    self.startYPos["NormalTipsTpl"] = self.panel.NormalTipsTpl.transform.localPosition.y
    self.startYPos["AttrTipsTpl"] = self.panel.AttrTipsTpl.transform.localPosition.y
    self.startYPos["TaskTipsTpl"] = self.panel.TaskTipsTpl.transform.localPosition.y
    self.ImportantNoticeTweenId = 0
    self.SecondaryNoticeTweenId = 0
    self.DropItemTweenId = 0
    self.DropItemAlphaTweenId = 0
    self.MiddleTipsTweenId = 0
    m_curMiddleStr = nil
    m_startTimer = nil
    m_curMiddleStrPos = self.panel.MiddleTipsTpl.gameObject.transform.localPosition
    self.panel.DropItemGO.gameObject:SetActiveEx(true)
    self.panel.DropItem.gameObject:SetActiveEx(false)
    self.panel.SecondaryNotice.gameObject:SetActiveEx(false)

    local Marquee = self.panel.SecondaryNoticeText:GetComponent("UIMarquee")
    Marquee:SetFinish(function()
        self.panel.SecondaryNotice.gameObject:SetActiveEx(not MgrMgr:GetMgr("NoticeMgr").IsSecondaryNoticeListEmpty())
        MgrMgr:GetMgr("NoticeMgr").g_IsSecondaryNotice = false
    end)

end --func end
--next--
function TipsDlgCtrl:OnDeActive()
    if self.FxEffectID then
        self:DestroyUIEffect(self.FxEffectID)
        self.FxEffectID = nil
    end

    self:ClearUIObject(normalAddList, "nowNormalTips")
    self:ClearUIObject(attrAddList, "nowAttrTips")
    self:ClearUIObject(taskAddList, "nowTaskTips")
    self:ClearAttrObj()
    normalAddList = {}
    attrAddList = {}
    taskAddList = {}
    self:DestoryAttrList()
    self:ClearDropItem()
    l_battleTips = {}
    self.panel.PromptText.gameObject.transform.parent.gameObject:SetActiveEx(false)
    self:HideQuestionTip()
end --func end
--next--

function TipsDlgCtrl:Update()

    --[[
    warning:禁止再在update里面使用为localposition赋值的操作实现动画!!
    ]]--
    if self.uObj then
        self:AddNewMessage(normalAddList, "nowNormalTips", "NormalTipsTpl")
        self:AddNewMessage(attrAddList, "nowAttrTips", "AttrTipsTpl")
        self:AddNewMessage(taskAddList, "nowTaskTips", "TaskTipsTpl")
    end
    self:UpdateNowTips("nowNormalTips", "NormalTipsTpl")
    self:UpdateNowTips("nowAttrTips", "AttrTipsTpl")
    self:UpdateNowTips("nowTaskTips", "TaskTipsTpl")
    self:UpdateAttrTips()
    self:UpdateDropItem()
    self:UpdatePraiseItem() --被点赞提示动画更新 cmd 2018/07/16 添加
end
--func end


--next--
function TipsDlgCtrl:BindEvents()
    self:BindEvent(GlobalEventBus, EventConst.Names.EnterScene, function()
        self:ClearDropItem()
        self:ClearDungeonHints()
    end)

    self:BindEvent(l_tipsMgr.EventDispatcher, l_tipsData.ETipsEvent.Show_Fx_Tips_Event, self.ShowFxTips)
    self:BindEvent(l_tipsMgr.EventDispatcher, l_tipsData.ETipsEvent.Show_Normal_Tips_Event, self.SetNewTips)
    self:BindEvent(l_tipsMgr.EventDispatcher, l_tipsData.ETipsEvent.Show_Attr_Tips_Event, self.SetNewTips)
    self:BindEvent(l_tipsMgr.EventDispatcher, l_tipsData.ETipsEvent.Show_Attr_2_Tips_Event, self.SetNewTips)
    self:BindEvent(l_tipsMgr.EventDispatcher, l_tipsData.ETipsEvent.Show_Attr_List_Tips, self.ShowListTips)
    self:BindEvent(l_tipsMgr.EventDispatcher, l_tipsData.ETipsEvent.Show_Task_Tips_Event, self.SetNewTips)
    self:BindEvent(l_tipsMgr.EventDispatcher, l_tipsData.ETipsEvent.Show_Important_Notice_Event, self.SetImportantNotice)
    self:BindEvent(l_tipsMgr.EventDispatcher, l_tipsData.ETipsEvent.Clear_Important_Notice_Event, self.StopAndClearImportantNotice)
    self:BindEvent(l_tipsMgr.EventDispatcher, l_tipsData.ETipsEvent.Show_Secondary_Notice_Event, self.SetSecondaryNotice)
    self:BindEvent(l_tipsMgr.EventDispatcher, l_tipsData.ETipsEvent.Show_Normal_Trumpet_Event, self.SetNormalTrumpet)
    self:BindEvent(l_tipsMgr.EventDispatcher, l_tipsData.ETipsEvent.Show_Item_Drop_Notice_Event, self.SetDropItem)
    self:BindEvent(l_tipsMgr.EventDispatcher, l_tipsData.ETipsEvent.Show_Item_Praise_Notice_Event, self.SetPraiseItem)
    self:BindEvent(l_tipsMgr.EventDispatcher, l_tipsData.ETipsEvent.Show_Question_Tip_Event, self.ShowQuestionTip)
    self:BindEvent(l_tipsMgr.EventDispatcher, l_tipsData.ETipsEvent.Show_Battle_Tip_Event, self.ShowBattleTips)
    self:BindEvent(l_tipsMgr.EventDispatcher, l_tipsData.ETipsEvent.Show_Dungeon_Tips_Event, self.ShowDungeonTips)
    self:BindEvent(l_tipsMgr.EventDispatcher, l_tipsData.ETipsEvent.Hide_Question_Tip_Event, self.HideQuestionTip)
    self:BindEvent(l_tipsMgr.EventDispatcher, l_tipsData.ETipsEvent.Show_Middle_UpTips_Event, self.SetMiddleTips)
    self:BindEvent(l_tipsMgr.EventDispatcher, l_tipsData.ETipsEvent.Show_Middle_DownTips_Event, self.SetMiddleTips)
    self:BindEvent(l_tipsMgr.EventDispatcher, l_tipsData.ETipsEvent.Close_Dungeon_Hints_Story, self.CloseDungeonHintsStory)
    self:BindEvent(l_tipsMgr.EventDispatcher, l_tipsData.ETipsEvent.EnterScene, self.ClearQue)

    local gameEventMgr = MgrMgr:GetMgr("GameEventMgr")
    self:BindEvent(gameEventMgr.l_eventDispatcher, gameEventMgr.TipsOnSysLogout, self._clearPraiseTips)
end --func end
--next--
--lua functions end

--lua custom scripts
function TipsDlgCtrl:_clearPraiseTips()
    self._praiseIds = {}
    self._curPraiseIndex = 0
    self:_destroyItem(self._upPraiseItem.ui)
    self._upPraiseItem = {}
    self:_destroyItem(self._downPraiseItem.ui)
    self._downPraiseItem = {}
end

function TipsDlgCtrl:ClearUIObject(addList, nowList)
    for i = 1, table.maxn(self[nowList]) do
        MResLoader:DestroyObj(self[nowList][i].ui)
    end
    self[nowList] = {}
end

function TipsDlgCtrl:ClearAttrObj()
    attrNewAddList = {}
    self.attrIsPlayNow = false
end

function TipsDlgCtrl:UpdatePreShowTime(tplName)
    if not self.preTime[tplName] then
        self.preTime[tplName] = 0
    else
        self.preTime[tplName] = math.max(self.preTime[tplName] - 1, 0)
    end
end

function TipsDlgCtrl:UpdateAttrTips()
    local l_tplName = "attrAnim"
    if not self.attrIsPlayNow then
        if table.maxn(attrNewAddList) > 0 then
            self.attrIsPlayNow = true
            self.panel.AttrTipsNewTpl.gameObject:SetActiveEx(true)
            local uiInfo = {}
            local l_tipsInfo = attrNewAddList[1]
            uiInfo.ui = self:CloneObj(self.panel[l_tplName].gameObject)
            uiInfo.ui.transform:SetParent(self.panel[l_tplName].transform.parent)
            uiInfo.ui.gameObject:SetActiveEx(false)
            uiInfo.ui.transform:SetLocalScaleOne()
            uiInfo.Index = #l_attrObjs + 1
            self.panel[l_tplName].gameObject:SetActiveEx(false)
            local pos = self.panel[l_tplName].transform.localPosition
            uiInfo.ui.transform.localPosition = pos
            uiInfo.labeltext = MLuaClientHelper.GetOrCreateMLuaUICom(uiInfo.ui)
            uiInfo.returnPool = true

            l_tipsInfo = (string.gsub(l_tipsInfo, "\\n", "\n"))
            uiInfo.labeltext.LabText = l_tipsInfo

            table.remove(attrNewAddList, 1)

            uiInfo.fxanim = uiInfo.ui:GetComponent("FxAnimationHelper")
            uiInfo.ui.gameObject:SetActiveEx(true)
            uiInfo.fxanim:PlayAllOnce()
            uiInfo.fxanim:addFinishCallbackByIndex(function()
                uiInfo.ui.gameObject:SetActiveEx(false)
                MResLoader:DestroyObj(uiInfo.ui)
                table.remove(l_attrObjs, uiInfo.Index)
                self.attrIsPlayNow = false
            end)
            table.insert(l_attrObjs, uiInfo)
        else
            self.panel.AttrTipsNewTpl.gameObject:SetActiveEx(false)
            if #l_attrObjs > 0 then
                for _, v in pairs(l_attrObjs) do
                    if v.ui then
                        MResLoader:DestroyObj(v.ui)
                    end
                end
                l_attrObjs = {}
            end
        end
    end

end

function TipsDlgCtrl:AddNewMessage(addList, nowList, tplName)
    self:UpdatePreShowTime(tplName)
    if table.maxn(addList) > 0 and table.maxn(self[nowList]) <= MAX_TIPS_NUM and self.preTime[tplName] == 0 then
        self.preTime[tplName] = GAP_TIME
        local l_tipsInfo = addList[1]
        local uiInfo = {}
        uiInfo.ui = self:CloneObj(self.panel[tplName].gameObject)
        uiInfo.ui.transform:SetParent(self.panel[tplName].transform.parent)
        uiInfo.ui.gameObject:SetActiveEx(false)
        uiInfo.ui.transform:SetLocalScaleOne()
        uiInfo.preX = self.panel[tplName].transform.localPosition.x
        local pos = self.panel[tplName].transform.localPosition
        pos.x = 5000
        uiInfo.ui.transform.localPosition = pos
        uiInfo.ui.gameObject:SetActiveEx(true)

        uiInfo.label = MLuaClientHelper.GetOrCreateMLuaUICom(uiInfo.ui.transform:Find("Text"))
        uiInfo.layoutGroup = uiInfo.ui.transform:GetComponent("HorizontalLayoutGroup")
        uiInfo.returnPool = true

        if tplName == "NormalTipsTpl" and type(l_tipsInfo) ~= "string" then
            uiInfo.layoutGroup.childControlWidth = false
            --默认标题是获得奖励
            --自定义在$后再加个占位符 比如 赠送道具
            local l_title = Common.Utils.Lang("To_GET_ITEM")
            if l_tipsInfo.title then
                l_title = l_tipsInfo.title
            end
            --默认不做自适应大小
            if l_tipsInfo.adapter then
                uiInfo.layoutGroup.childControlWidth = true
            end
            local l_itemName = GetItemText(l_tipsInfo.itemId, l_tipsInfo.itemOpts)
            local l_tips = StringEx.Format("  {0}{1}  ", l_title, l_itemName)
            if l_tipsInfo.addin then
                l_tips = l_tips .. l_tipsInfo.addin
            end
            uiInfo.label.LabText = l_tips
        else
            l_tipsInfo = (string.gsub(l_tipsInfo, "\\n", "\n"))
            uiInfo.label.LabText = l_tipsInfo
            uiInfo.layoutGroup.childControlWidth = true
        end

        uiInfo.reMainTime = PENDING_TIME
        uiInfo.nowPos = self.startYPos[tplName]
        uiInfo.ui:SetActiveEx(true)

        uiInfo.hasStart = false
        table.insert(self[nowList], uiInfo)
        table.remove(addList, 1)

        MLuaCommonHelper.ForceUpdateContentSizeFitter(uiInfo.ui)

    end
end

function TipsDlgCtrl:UpdateNowTips(nowList, tplName)
    if self[nowList] and self.uObj then
        local targetPos = self.startYPos[tplName] + DEFAULT_DISTANCE
        for i = table.maxn(self[nowList]), 1, -1 do
            local l_replay = false
            if self[nowList][i].hasStart and self[nowList][i].targetYPos and
                    targetPos > self[nowList][i].targetYPos then
                l_replay = true
            end
            self[nowList][i].targetYPos = targetPos
            if l_replay then
                local z = self[nowList][i].ui.transform.localPosition.z
                local y = self[nowList][i].ui.transform.localPosition.y
                local l_from = Vector3.New(self[nowList][i].preX, self[nowList][i].nowPos, z)
                local l_to = Vector3.New(self[nowList][i].preX, self[nowList][i].targetYPos, z)
                self:PlayTween(self[nowList][i], l_from, l_to)
            end
            local layoutGroup = self[nowList][i].ui:GetComponent("LayoutGroup")
            preferredHeight = layoutGroup.preferredHeight
            if preferredHeight <= 0 then
                preferredHeight = 300
            end
            targetPos = targetPos + preferredHeight + NORMAL_GAP
            self[nowList][i].startPos = self.startYPos[tplName] + preferredHeight + NORMAL_GAP--启动位置
        end
        --开始移动
        for i = table.maxn(self[nowList]), 1, -1 do
            if not self[nowList][i].hasStart then
                if i == 1 or self[nowList][i - 1].nowPos >= self[nowList][i].startPos then
                    self[nowList][i].hasStart = true
                    self[nowList][i].reMainTime = SHOW_TIME
                    --TODO:重置位置;
                    local z = self[nowList][i].ui.transform.localPosition.z
                    local y = self[nowList][i].ui.transform.localPosition.y
                    self[nowList][i].nowPos = self.startYPos[tplName]
                    local l_from = Vector3.New(self[nowList][i].preX, self[nowList][i].nowPos, z)
                    local l_to = Vector3.New(self[nowList][i].preX, self[nowList][i].targetYPos, z)
                    self:PlayTween(self[nowList][i], l_from, l_to)
                end
            end
            if self[nowList][i].hasStart then
                if self[nowList][i].nowPos < self[nowList][i].targetYPos then
                    self[nowList][i].nowPos = self[nowList][i].ui.transform.localPosition.y
                end
            end
        end
        --删除超时的
        for i = table.maxn(self[nowList]), 1, -1 do
            self[nowList][i].reMainTime = self[nowList][i].reMainTime - 1
            if self[nowList][i].reMainTime <= 0 then
                if self[nowList][i].tweenId then
                    MUITweenHelper.KillTweenDeleteCallBack(self[nowList][i].tweenId)
                    self[nowList][i].tweenId = nil
                end
                MResLoader:DestroyObj(self[nowList][i].ui, self[nowList][i].returnPool)
                table.remove(self[nowList], i)
            end
            --TODO:这个if判断按理说不需要,好像dotween的bug?;
            if self[nowList][i] and self[nowList][i].tweenId and self[nowList][i].targetYPos and
                    self[nowList][i].nowPos and self[nowList][i].nowPos >= self[nowList][i].targetYPos then
                MUITweenHelper.KillTweenDeleteCallBack(self[nowList][i].tweenId)
                self[nowList][i].tweenId = nil
                local z = self[nowList][i].ui.transform.localPosition.z
                self[nowList][i].ui.transform.localPosition = Vector3.New(self[nowList][i].preX, self[nowList][i].targetYPos, z)
            end
        end
        if table.maxn(self[nowList]) > MAX_TIPS_NUM then
            self[nowList][1].ui:SetActiveEx(false)
            if self[nowList][1].nowPos >= self[nowList][1].targetYPos - 5 then
                if self[nowList][1].tweenId then
                    MUITweenHelper.KillTweenDeleteCallBack(self[nowList][1].tweenId)
                    self[nowList][1].tweenId = nil
                end
                MResLoader:DestroyObj(self[nowList][1].ui, self[nowList][1].returnPool)
                table.remove(self[nowList], 1)
            end
        end
    end
end

function TipsDlgCtrl:PlayTween(target, from, to)
    --TODO
    local l_speed = (to.y - from.y) / NEW_SPEED
    if l_speed < 0 then
        return
    end
    if target.tweenId then
        target.tweenId = MUITweenHelper.ReTweenPos(target.tweenId, target.ui, from, to, l_speed)
    else
        target.tweenId = MUITweenHelper.TweenPos(target.ui, from, to, l_speed)
    end
end

function TipsDlgCtrl:ShowFxTips(fxPath, width, height, time)
    MLuaCommonHelper.SetRectTransformSize(self.panel.FxTips.UObj, width, height)
    if self.FxEffectID then
        self:DestroyUIEffect(self.FxEffectID)
        self.FxEffectID = nil
    end
    local l_fxData = {}
    l_fxData.playTime = time
    l_fxData.rawImage = self.panel.FxTips.RawImg
    l_fxData.destroyHandler = function(...)
        self.FxEffectID = nil
    end
    self.FxEffectID = self:CreateUIEffect(fxPath, l_fxData)

end

function TipsDlgCtrl:SetNewTips(tipsType, str)
    if tipsType == "Attr" then
        table.insert(attrAddList, str)
    elseif tipsType == "Normal" then
        table.insert(normalAddList, str)
        self.preStr["Normal"] = str
    elseif tipsType == "Task" then
        if str ~= self.preStr["Task"] or (table.maxn(taskAddList) + table.maxn(self.nowTaskTips) <= 0) then
            table.insert(taskAddList, str)
            self.preStr["Task"] = str
        end
    elseif tipsType == "Attr2" then
        table.insert(attrNewAddList, str)
    end
end

function TipsDlgCtrl:AlwaysSetNewTips(tipsType, str)
    if tipsType == "Attr" then
        table.insert(attrAddList, str)
    elseif tipsType == "Normal" then
        table.insert(normalAddList, str)
        self.preStr["Normal"] = str
    elseif tipsType == "Task" then
        table.insert(taskAddList, str)
        self.preStr["Task"] = str
    elseif tipsType == "Attr2" then
        table.insert(attrNewAddList, str)
    end
    --end
end

function TipsDlgCtrl:ShowListTips(cListTb)
    local cDuration = 0.45
    self:DestoryAttrList()
    self.panel.AttrListTipsTpl.gameObject:SetActiveEx(true)
    self.panel.AttrListTxtInfo.gameObject:SetActiveEx(false)
    local cPos = self.panel.AttrListTxtInfo.transform.localPosition
    local cTargetPos = self.panel.AttrListTargetPos.transform.localPosition

    local cAllDelay = 1 + 0.2 * (table.maxn(cListTb) - 1)
    local cEndTween = self.panel.AttrListEndTween.transform:GetComponent("DOTweenAnimation")
    cEndTween.delay = cAllDelay
    cEndTween:CreateTween()
    cEndTween.tween.onComplete = function()
        self:DestoryAttrList()
    end
    cEndTween:DOPlay()

    for i = 1, table.maxn(cListTb) do
        self.attrList[i] = {}
        self.attrList[i].ui = self:CloneObj(self.panel.AttrListTxtInfo.gameObject)
        self.attrList[i].ui.transform:SetParent(self.panel.AttrListTxtInfo.transform.parent)
        self.attrList[i].ui.transform:SetLocalScaleOne()
        self.attrList[i].ui.transform.localPosition = Vector3.New(cPos.x, (cPos.y - 35 * (i - 1)), cPos.z)
        MLuaClientHelper.GetOrCreateMLuaUICom(self.attrList[i].ui.transform).LabText = cListTb[i]

        self.attrList[i].cDotweenAni = self.attrList[i].ui.transform:GetComponent("DOTweenAnimation")
        self.attrList[i].cDotweenAni.duration = cDuration
        self.attrList[i].cDotweenAni.delay = (i - 1) * 0.2
        cAllDelay = cAllDelay + self.attrList[i].cDotweenAni.delay
        self.attrList[i].cDotweenAni.endValueV3 = Vector3.New(cTargetPos.x, (cTargetPos.y - 35 * (i - 1)), cTargetPos.z)
        self.attrList[i].cDotweenAni:CreateTween()
        self.attrList[i].cDotweenAni:DOPlay()
    end
end

function TipsDlgCtrl:DestoryAttrList()
    local cEndTween = self.panel.AttrListEndTween.transform:GetComponent("DOTweenAnimation")
    cEndTween:DOKill()
    for i = 1, table.maxn(self.attrList) do
        self.attrList[i].ui.gameObject:SetActiveEx(false)
        MResLoader:DestroyObj(self.attrList[i].ui)
    end
    self.attrList = {}
end

--======================================================================================================================

function TipsDlgCtrl:StopAndClearImportantNotice()
    if l_importantTweenId > 0 then
        MUITweenHelper.KillTweenDeleteCallBack(l_importantTweenId)
        l_importantTweenId = 0
    end
    if l_importantTimer ~= nil then
        self:StopUITimer(l_importantTimer)
        l_importantTimer = nil
    end
    self.panel.ImportantNotice.gameObject:SetActiveEx(false)
    if l_importantPos then
        self.panel.ImportantNoticeText.gameObject.transform.localPosition = l_importantPos
    end
    m_importantNotice = {}
    m_importantNoticeState = false
end

function TipsDlgCtrl:SetImportantNotice(str, duration)
    local l_index = 1
    if #m_importantNotice == 0 then
        l_index = 1
    else
        l_index = #m_importantNotice + 1
    end
    m_importantNotice[l_index] = str
    if l_index == 1 then
        m_importantNoticeState = false
        self.panel.ImportantNotice.gameObject:SetActiveEx(false)
    end
    if not m_importantNoticeState then
        m_importantNoticeState = true
        self:ShowImportantNotice(duration)
    end
end

function TipsDlgCtrl:ShowImportantNotice(duration)
    if #m_importantNotice == 0 then
        self.panel.ImportantNotice.gameObject:SetActiveEx(false)
        m_importantNoticeState = false
        return
    end
    local l_index = 1
    self:StartShowImportantNotice(l_index, duration)
end

function TipsDlgCtrl:StartShowImportantNotice(index, duration)
    local l_pos = self.panel.ImportantNoticeText.gameObject.transform.localPosition
    l_importantPos = l_pos
    if m_importantNotice[index] == nil then
        m_importantNotice = {}
        self.panel.ImportantNotice.gameObject:SetActiveEx(false)
        m_importantNoticeState = false
        return
    end

    local l_info = m_importantNotice[index]
    local l_emojiText = self.panel.ImportantNoticeText.gameObject:GetComponent("EmojiText")
    l_emojiText.text = ""
    self.panel.ImportantNotice.gameObject:SetActiveEx(true)
    local l_preferredHeight = l_emojiText.preferredHeight
    local l_lineSpacing = l_emojiText.lineSpacing
    l_emojiText.text = tostring(l_info)
    local l_allHeight = l_emojiText.preferredHeight
    local l_line = (math.floor(((l_allHeight - l_preferredHeight) / (l_preferredHeight + l_lineSpacing)) + 0.5)) + 1
    local l_cb = function()
        self.panel.ImportantNoticeText.gameObject.transform.localPosition = l_pos
        self:StartShowImportantNotice(index + 1, duration)
    end

    self:PlayImportantForward(l_emojiText, l_preferredHeight + l_lineSpacing, l_line - 1, l_cb, self.ImportantNoticeTweenId, duration)
end

-- todo 这段代码是靠捕获的一个上值逻辑来完成缓存调用的，这个做法有很大问题
function TipsDlgCtrl:PlayImportantForward(go, distance, lines, callback, tweenId, duration)
    local l_imp = self.panel.ImportantNoticeText.gameObject:GetComponent("EmojiText")
    --清理原计时器
    if l_importantTimer ~= nil then
        self:StopUITimer(l_importantTimer)
        l_importantTimer = nil
    end
    --公告只是一行
    if lines < 1 then
        if duration ~= -1 then
            local l_lastTime = duration or m_importantNoticeTime  --持续时间获取
            l_importantTimer = self:NewUITimer(function()
                if l_importantTimer ~= nil then
                    self:StopUITimer(l_importantTimer)
                    l_importantTimer = nil
                end
                callback()
            end, l_lastTime, 0, true)
            l_importantTimer:Start()
        end
    else
        --公告大于一行 每隔一秒向上滑动一行
        lines = lines - 1
        if tweenId > 0 then
            MUITweenHelper.KillTween(tweenId)
            tweenId = 0
        end
        --播放Dotween的时间计时器
        l_importantTimer = self:NewUITimer(function()
            tweenId = MUITweenHelper.TweenPos(go.gameObject, go.gameObject.transform.localPosition, go.gameObject.transform.localPosition + Vector3.New(0, distance, 0), 1,
                    function()
                        if l_importantTimer ~= nil then
                            self:StopUITimer(l_importantTimer)
                            l_importantTimer = nil
                        end
                        self:PlayImportantForward(go, distance, lines, callback, tweenId)
                        if l_imp == go then
                            l_importantTweenId = tweenId
                        end
                    end)
            if l_imp == go then
                l_importantTweenId = tweenId
            end
        end, 0, 0, true)
        l_importantTimer:Start()
    end
end

--======================================================================================================================
--显示底部公告
function TipsDlgCtrl:SetSecondaryNotice(str)
    --当前已有公告 重置计时 显示新公告位置 字段
    if l_secondImportantTimer ~= nil then
        self:StopUITimer(l_secondImportantTimer)
        l_secondImportantTimer = nil
    end
    if self.SecondaryNoticeTweenId > 0 then
        MUITweenHelper.KillTween(self.SecondaryNoticeTweenId)
        self.SecondaryNoticeTweenId = 0
    end
    if self.panel.SecondaryNoticeText.gameObject.transform.localPosition ~= self.SecondaryNoticePos then
        self.panel.SecondaryNoticeText.gameObject:SetActiveEx(false)
        self.panel.SecondaryNoticeText.gameObject.transform.localPosition = self.SecondaryNoticePos
        self.panel.SecondaryNoticeText.gameObject:SetActiveEx(true)
    end
    --local l_emojiText = self.panel.SecondaryNoticeText.gameObject:GetComponent("EmojiText")
    --l_emojiText.text = ""
    MgrMgr:GetMgr("NoticeMgr").IsSecondaryNotice = 0
    MgrMgr:GetMgr("NoticeMgr").IsSecondaryNotice = true
    self.panel.SecondaryNoticeText.LabText = str
    local Marquee = self.panel.SecondaryNoticeText:GetComponent("UIMarquee")
    self.panel.SecondaryNotice.gameObject:SetActiveEx(true)
    Marquee:CheckStartMarquee()
    if self.panel.SecondaryNoticeText.RectTransform.rect.width <= Marquee.MaskWidth then
        l_secondImportantTimer = self:NewUITimer(function()
            if l_secondImportantTimer ~= nil then
                self:StopUITimer(l_secondImportantTimer)
                l_secondImportantTimer = nil
            end
            self.panel.SecondaryNotice.gameObject:SetActiveEx(not MgrMgr:GetMgr("NoticeMgr").IsSecondaryNoticeListEmpty())
            MgrMgr:GetMgr("NoticeMgr").g_IsSecondaryNotice = false
        end, MgrMgr:GetMgr("NoticeMgr").NoticeSpeed, 0, true)
        l_secondImportantTimer:Start()
    else
        Marquee:CheckStartMarquee()
    end
    --local l_preferredHeight = l_emojiText.preferredHeight
    --local l_lineSpacing = l_emojiText.lineSpacing
    --l_emojiText.text = tostring(str)
    --local l_allHeight = l_emojiText.preferredHeight
    --local l_line = (math.floor(((l_allHeight - l_preferredHeight) / (l_preferredHeight + l_lineSpacing)) + 0.5)) + 2
    --self:PlaySecondaryNoticeForward(l_emojiText, l_preferredHeight + l_lineSpacing, l_line - 1,
    --        function()
    --            self.panel.SecondaryNotice.gameObject:SetActiveEx(not MgrMgr:GetMgr("NoticeMgr").IsSecondaryNoticeListEmpty())
    --            MgrMgr:GetMgr("NoticeMgr").g_IsSecondaryNotice = false
    --            self.panel.SecondaryNoticeText.gameObject.transform.localPosition = self.SecondaryNoticePos
    --        end, self.SecondaryNoticeTweenId)
end

--======================================================================================================================
function TipsDlgCtrl:PlaySecondaryNoticeForward(go, distance, times, callback, tweenId)
    if times >= 1 then
        --公告大于一行 向上滑动
        distance = times * distance
        if self.SecondaryNoticeTweenId > 0 then
            MUITweenHelper.KillTween(self.SecondaryNoticeTweenId)
            self.SecondaryNoticeTweenId = 0
        end
        self.SecondaryNoticeTweenId = MUITweenHelper.TweenPos(go.gameObject, go.gameObject.transform.localPosition, go.gameObject.transform.localPosition + Vector3.New(0, distance, 0), times)
    end
    l_secondImportantTimer = self:NewUITimer(function()
        if l_secondImportantTimer ~= nil then
            self:StopUITimer(l_secondImportantTimer)
            l_secondImportantTimer = nil
        end
        callback()
    end, MgrMgr:GetMgr("NoticeMgr").NoticeSpeed, 0, true)
    l_secondImportantTimer:Start()
end
--======================================================================================================================

function TipsDlgCtrl:SetNormalTrumpet(str)
    local l_index = 1
    if #m_normalTrumpet == 0 then
        l_index = 1
    else
        l_index = #m_normalTrumpet + 1
    end
    m_normalTrumpet[l_index] = str
    if l_index == 1 then
        self.panel.NormalTrumpet.gameObject:SetActiveEx(true)
        self:ShowNormalTrumpet()
    end
end

function TipsDlgCtrl:ShowNormalTrumpet()
    if #m_normalTrumpet == 0 then
        self.panel.NormalTrumpet.gameObject:SetActiveEx(false)
        return
    end
    local l_index = 1
    self:StartShowNormalTrumpet(l_index)
end

function TipsDlgCtrl:StartShowNormalTrumpet(index)
    if not self.panel then
        return
    end
    if m_normalTrumpet[index] == nil then
        m_normalTrumpet = {}
        self.panel.NormalTrumpet.gameObject:SetActiveEx(false)
        return
    end
    local l_info = m_normalTrumpet[index]
    local l_emojiText = self.panel.NormalTrumpetText
    l_emojiText.LabText = ""
    self.panel.NormalTrumpet.gameObject:SetActiveEx(true)
    l_emojiText.LabText = tostring(l_info)
    local l_tim = self:NewUITimer(function()
        self:StartShowNormalTrumpet(index + 1)
    end, m_trumpetSpeed, 0, true)
    l_tim:Start()
    return l_tim
end

function TipsDlgCtrl:ShowQuestionTip(str, eventData, pivot, useFitter, maxWidth, pressCamera, isPassThrouth, fontsize)
    if useFitter == nil then
        useFitter = false
    end
    if maxWidth == nil then
        maxWidth = 360
    end
    self.panel.QuestionCloseBtn.Listener.onClick = function(obj, data)
        l_tipsMgr.HideQuestionTip()
        if isPassThrouth then
            MLuaClientHelper.ExecuteClickEvents(data.position, "Question")
        end
    end
    self.panel.QuestionTipsTpl.gameObject:SetActiveEx(true)
    self.panel.QuestionText.LabText = str
    self.panel.QuestionText:GetText().fontSize = fontsize or 16
    local sizeFitter = self.panel.QuestionTipsTpl.gameObject:GetComponent("ContentSizeFitter")
    local parentRectTransform = self.panel.QuestionTipsTpl.Transform.parent:GetComponent("RectTransform")

    -- todo CLX: 这个地方做法有问题：如果没有约束，都是自适应，当显示框出现缩放之后会那之前适应的宽度作为新的宽度，去自适应高度
    -- todo 必须先开了字数多的界面后开了字数少的界面，再开大界面的时候会按照小界面的宽度计算自适应
    if useFitter and self.panel.QuestionText:GetText().preferredWidth < maxWidth then
        sizeFitter.horizontalFit = FitMode.PreferredSize
    else
        sizeFitter.horizontalFit = FitMode.Unconstrained
    end
    --parentRectTransform.sizeDelta = Vector2.New(maxWidth, parentRectTransform.sizeDelta.y)
    self.panel.QuestionTipsTpl.RectTransform.sizeDelta = Vector2.New(maxWidth, self.panel.QuestionTipsTpl.RectTransform.sizeDelta.y)
    if eventData then
        pressCamera = pressCamera or eventData.pressEventCamera
        local ret, pos = RectTransformUtility.ScreenPointToLocalPointInRectangle(parentRectTransform, eventData.position, pressCamera, nil)
        if ret and pos then
            self.panel.QuestionTipsTpl.RectTransform.anchoredPosition = pos
            self.panel.QuestionTipsTpl.RectTransform.pivot = pivot or Vector2(0.5, 0)
        end
    end

    LayoutRebuilder.ForceRebuildLayoutImmediate(self.panel.QuestionTipsTpl.RectTransform)
    ---@type Common.CommonScreenPosUtil
    -- local l_util = Common.CommonScreenPosUtil
    -- local bg_size = {
    --     x = self.panel.QuestionTipsTpl.RectTransform.sizeDelta.x,
    --     y = self.panel.QuestionTipsTpl.RectTransform.sizeDelta.y
    -- }

    -- local l_verticalOffset = bg_size.y * 0.5
    -- local l_UIPos = self.panel.QuestionTipsTpl.RectTransform.localPosition
    -- local l_pos = {
    --     x = l_UIPos.x,
    --     y = l_UIPos.y - l_verticalOffset,
    --     z = l_UIPos.z
    -- }

    -- local l_retPos = l_util.CalcPos(l_pos, bg_size)
    -- self.panel.QuestionTipsTpl.gameObject:SetRectTransformPos(l_retPos.x, l_retPos.y)
end

function TipsDlgCtrl:HideQuestionTip()
    self.panel.QuestionTipsTpl.gameObject:SetActiveEx(false)
end

--======================================================================================================================

function TipsDlgCtrl:SetDropItem(itemId, itemNum)

    -- TODO 临时屏蔽铜钱的飘字
    -- https://www.tapd.cn/20332331/prong/stories/view/1120332331001030695
    if itemId == 101 or itemId == 201 or itemId == 202 then
        return
    end

    local l_itemInfo = TableUtil.GetItemTable().GetRowByItemID(itemId)
    if l_itemInfo == nil then
        return
    end
    local l_index = 1
    if #m_dropItem == 0 then
        l_index = 1
    else
        l_index = #m_dropItem + 1
    end
    m_dropItem[l_index] = {}
    m_dropItem[l_index].ItemNum = itemNum
    m_dropItem[l_index].id = itemId
    if l_index == 1 then
        self:ShowDropItem()
    end
end

function TipsDlgCtrl:ShowDropItem()
    if #m_dropItem == 0 then
        return
    end
    local l_index = 1
    --self:StartShowDropItem(l_index)
    l_upItem = {}
    l_downItem = {}
    l_curIndex = 1
end

local UP_DROP_DISTANCE = Vector3.New(0, 80, 0)
local DOWN_DROP_DISTANCE = UP_DROP_DISTANCE - Vector3.New(0, 43, 0)
local DROP_SHOW_TIME = 150

function TipsDlgCtrl:UpdateDropItem()
    if l_curIndex == 0 and l_upItem.ui == nil then
        return
    end
    if l_upItem.ui == nil and m_dropItem[l_curIndex] ~= nil then
        self:CreateItem(l_upItem, Vector3.New(0, 0, 0), UP_DROP_DISTANCE, DROP_SHOW_TIME)
        return
    end
    if l_upItem.ui.transform.localPosition.y < l_upItem.targetPos.y - 3 then
        if not l_upItem.tweenId then
            local x = l_upItem.ui.transform.localPosition.x
            local z = l_upItem.ui.transform.localPosition.z
            local y = l_upItem.ui.transform.localPosition.y
            local l_from = Vector3.New(x, y, z)
            local l_to = Vector3.New(x, l_upItem.targetPos.y, z)
            local l_speed = (l_upItem.targetPos.y - y) / NEW_SPEED
            l_upItem.tweenId = MUITweenHelper.TweenPos(l_upItem.ui, l_from, l_to, l_speed, function()
                l_upItem.time = 0
            end)
        end
    else
        if l_upItem.tweenId then
            MUITweenHelper.KillTweenDeleteCallBack(l_upItem.tweenId)
            l_upItem.tweenId = nil
            local x = l_upItem.ui.transform.localPosition.x
            local z = l_upItem.ui.transform.localPosition.z
            local l_to = Vector3.New(x, l_upItem.targetPos.y, z)
            l_upItem.ui.transform.localPosition = l_to
            l_upItem.time = 0
        end
    end
    if l_upItem.ui ~= nil and l_downItem.ui == nil and m_dropItem[l_curIndex] ~= nil then
        if l_upItem.ui.transform.localPosition.y > 50 then
            self:CreateItem(l_downItem, Vector3.New(0, 0, 0), UP_DROP_DISTANCE, DROP_SHOW_TIME)
        end
    end

    l_upItem.time = l_upItem.time - 1
    if l_upItem.time < 1 then
        if l_upItem.tweenId then
            MUITweenHelper.KillTweenDeleteCallBack(l_upItem.tweenId)
            l_upItem.tweenId = nil
        end
        MResLoader:DestroyObj(l_upItem.ui)
        l_upItem = {}
        if l_downItem.ui then
            if l_downItem.tweenId then
                MUITweenHelper.KillTweenDeleteCallBack(l_downItem.tweenId)
                l_downItem.tweenId = nil
                local x = l_downItem.ui.transform.localPosition.x
                local z = l_downItem.ui.transform.localPosition.z
                local l_to = Vector3.New(x, DOWN_DROP_DISTANCE.y, z)
                l_downItem.ui.transform.localPosition = l_to
            end
            l_upItem = l_downItem
            l_downItem = {}
        else
            m_dropItem = {}
            l_curIndex = 0
        end
    end

    if l_downItem.ui then
        local l_targetPos = DOWN_DROP_DISTANCE
        if l_downItem.ui.transform.localPosition.y < l_targetPos.y - 3 then
            if not l_downItem.tweenId then
                local x = l_downItem.ui.transform.localPosition.x
                local z = l_downItem.ui.transform.localPosition.z
                local y = l_downItem.ui.transform.localPosition.y
                local l_from = Vector3.New(x, y, z)
                local l_to = Vector3.New(x, l_targetPos.y, z)
                local l_speed = (l_targetPos.y - y) / NEW_SPEED
                l_downItem.tweenId = MUITweenHelper.TweenPos(l_downItem.ui, l_from, l_to, l_speed)
            end
        else
            if l_downItem.tweenId then
                MUITweenHelper.KillTweenDeleteCallBack(l_downItem.tweenId)
                l_downItem.tweenId = nil
                local x = l_downItem.ui.transform.localPosition.x
                local z = l_downItem.ui.transform.localPosition.z
                local l_to = Vector3.New(x, l_targetPos.y, z)
                l_downItem.ui.transform.localPosition = l_to
            end
        end
        --l_downItem.time = l_downItem.time -1
    end
end

function TipsDlgCtrl:ClearDropItem()
    m_dropItem = {}
    l_curIndex = 0
    if l_upItem.tweenId then
        MUITweenHelper.KillTweenDeleteCallBack(l_upItem.tweenId)
        l_upItem.tweenId = nil
    end
    if l_upItem.ui then
        MResLoader:DestroyObj(l_upItem.ui)
    end
    l_upItem = {}

    if l_downItem.tweenId then
        MUITweenHelper.KillTweenDeleteCallBack(l_downItem.tweenId)
        l_downItem.tweenId = nil
    end
    if l_downItem.ui then
        MResLoader:DestroyObj(l_downItem.ui)
    end
    l_downItem = {}
end

function TipsDlgCtrl:CreateItem(item, initPos, targetPos, time)
    l_curIndex = l_curIndex + 1
    item.ui = self:CloneObj(self.panel.DropItem.gameObject)
    item.ui.transform:SetParent(self.panel.DropItem.gameObject.transform.parent)
    item.ui.transform.localPosition = initPos
    item.ui.transform:SetLocalScaleOne()
    item.ui.transform.localRotation = Vector3.New(0, 0, 0)
    local l_info = m_dropItem[l_curIndex - 1]
    local l_textCom = item.ui.transform:Find("Name"):GetComponent("Text")
    local l_textName = MLuaClientHelper.GetOrCreateMLuaUICom(l_textCom.gameObject)

    l_textName.LabText = Lang("To_GET_ITEM") .. GetItemText(l_info.id, {
        num = l_info.ItemNum,
        icon = { size = l_textCom.fontSize }
    })

    item.ui:SetActiveEx(true)
    item.targetPos = targetPos
    item.time = time
    item.tweenId = nil
end

--======================================================================================================================

function TipsDlgCtrl:SetMiddleTips(str, ...)
    ---args1:方向,args2:动画距离,args3:动画开始延迟时间,TODO：字体大小+格式
    local tweenDirection = 0
    local tweenDistance = 20
    local startDelay = 0.5
    local args = { ... }

    if #args > 0 then
        tweenDirection = args[1]
    end
    if #args > 1 then
        tweenDistance = args[2]
    end
    if #args > 2 then
        startDelay = args[3]
    end

    if m_curMiddleStr ~= nil and m_curMiddleStr == str then
        return
    end
    if m_curMiddleStr ~= nil and m_curMiddleStr ~= str then
        m_curMiddleStr = str
        self:PlayMiddleTips(str, tweenDirection, tweenDistance, startDelay)
    end
    if m_curMiddleStr == nil then
        m_curMiddleStr = str
        self:PlayMiddleTips(str, tweenDirection, tweenDistance, startDelay)
    end
end

function TipsDlgCtrl:PlayMiddleTips(str, tweenDirection, tweenDistance, startDelay)
    if m_startTimer ~= nil then
        self:StopUITimer(m_startTimer)
        m_startTimer = nil
    end
    if self.MiddleTipsTweenId > 0 then
        MUITweenHelper.KillTween(self.MiddleTipsTweenId)
        self.MiddleTipsTweenId = 0
    end
    local l_go = self.panel.MiddleTipsTpl.gameObject
    l_go:SetActiveEx(false)
    local l_pos = m_curMiddleStrPos
    local l_text = MLuaClientHelper.GetOrCreateMLuaUICom(l_go.transform:Find("Text"))
    l_text.LabText = str
    l_go:SetActiveEx(true)
    local l_distance = 0
    if tweenDirection < 1 then
        l_distance = Vector3.New(0, tweenDistance, 0)
    else
        l_distance = Vector3.New(0, -tweenDistance, 0)
    end
    m_startTimer = self:NewUITimer(function()
        if m_startTimer ~= nil then
            self:StopUITimer(m_startTimer)
            m_startTimer = nil
        end
        self.MiddleTipsTweenId = MUITweenHelper.TweenPos(l_go, l_pos, l_pos + l_distance, 1, function()
            l_go:SetActiveEx(false)
            l_go.transform.localPosition = l_pos
            m_curMiddleStr = nil
        end)
    end, startDelay, 0, true)
    m_startTimer:Start()
end

------------------------------------------- PraisedTipTpl 被赞提示 cmd 2018/07/16添加 -----------------------------------------------------
function TipsDlgCtrl:SetPraiseItem(roleId)
    table.insert(self._praiseIds, roleId)
    if 1 == #self._praiseIds then
        self:ShowPraiseItem()
    end
end

function TipsDlgCtrl:ShowPraiseItem()
    if 0 >= #self._praiseIds then
        return
    end

    self._curPraiseIndex = 1
    self._upPraiseItem = {}
    self._downPraiseItem = {}
end

function TipsDlgCtrl:UpdatePraiseItem()
    --如果没有需要展示的项目则返回
    if self._curPraiseIndex == 0 and self._upPraiseItem.ui == nil then
        return
    end

    --如果第一展示项容器为空 且有展示内容 则创建一个新的展示项放入第一个容器
    if self._upPraiseItem.ui == nil and self._praiseIds[self._curPraiseIndex] ~= nil then
        self:CreatePraiseItem(self._upPraiseItem, l_praiseInitPos, l_praiseTargetPos, l_praiseShowTime)
        return
    end

    --前一个展示项容器的动画展示
    if self._upPraiseItem.ui:GetLocalPos().y < self._upPraiseItem.targetPos.y then
        --未到指定地点则移动
        self._upPraiseItem.ui:UpdateLocalPos(self._upPraiseItem.ui:GetLocalPos() + Vector3.New(0, MOVE_SPEED, 0))
    else
        --展示时间倒计时 单位:帧
        self._upPraiseItem.time = self._upPraiseItem.time - 1
        if self._upPraiseItem.time < 1 then
            --展示时间结束后销毁目标
            self:_destroyItem(self._upPraiseItem.ui)
            self._upPraiseItem = {}
            --后一个展示项内容放入前一个展示项容器 如果有的话
            if self._downPraiseItem.ui then
                self._upPraiseItem = self._downPraiseItem
                self._downPraiseItem = {}
            else
                --没有的话 清空相关内容
                self._praiseIds = {}
                self._curPraiseIndex = 0
            end
        end
    end
    --如果前一个展示项容器正在使用 且还有新的展示内容 则在后一个展示项容器中创建一个新的展示项
    if self._upPraiseItem.ui ~= nil and self._downPraiseItem.ui == nil and self._praiseIds[self._curPraiseIndex] ~= nil then
        self:CreatePraiseItem(self._downPraiseItem, l_praiseInitPos, l_praiseTargetPos, l_praiseShowTime)
        return
    end

    --后一个展示项容器的动画
    if self._downPraiseItem.ui then
        local l_nextPos = self._downPraiseItem.ui:GetLocalPos() + Vector3.New(0, MOVE_SPEED, 0)
        local l_maxPos = self._upPraiseItem.ui:GetLocalPos() - Vector3.New(0, l_downPraiseItemOffset, 0)
        if l_nextPos.y > l_maxPos.y then
            self._downPraiseItem.ui:UpdateLocalPos(l_maxPos)
        else
            self._downPraiseItem.ui:UpdateLocalPos(l_nextPos)
        end
    end
end

function TipsDlgCtrl:_destroyItem(item)
    if nil == item then
        return
    end

    self:UninitTemplate(item)
end

function TipsDlgCtrl:CreatePraiseItem(item, initPos, targetPos, time)
    --组件克隆
    local l_roleId = self._praiseIds[self._curPraiseIndex]
    self._curPraiseIndex = self._curPraiseIndex + 1
    item.ui = self:NewTemplate("PraisedTipTpl", {
        TemplateParent = self.panel.TipsDummy.transform,
        TemplatePrefab = self.panel.PraisedTipTpl.gameObject,
    })

    item.ui:InitPos(initPos)
    item.ui:SetData(l_roleId)
    --动画展示用属性
    item.targetPos = targetPos
    item.time = time
end

------------------------------------------------ End PraisedTipTpl ----------------------------------------------------------

function TipsDlgCtrl:ShowBattleTips(str, forceUpdate)
    if forceUpdate then
        if l_battleTimer then
            self:StopUITimer(l_battleTimer)
            l_battleTimer = nil
        end
        l_battleTips = {}
    end
    local l_index = #l_battleTips + 1
    l_battleTips[l_index] = str
    if not l_battleTimer then
        local l_curIndex = 1
        local l_tips = l_battleTips[l_curIndex]
        local l_root = self.panel.PromptText.gameObject.transform.parent.gameObject
        self.panel.PromptText.LabText = l_tips
        l_root:SetActiveEx(true)
        BATTLE_TIPS_TIME = BATTLE_TIPS_TIME > 0 and BATTLE_TIPS_TIME or 1.5
        l_battleTimer = self:NewUITimer(function()
            if #l_battleTips == l_curIndex then
                if l_battleTimer then
                    self:StopUITimer(l_battleTimer)
                    l_battleTimer = nil
                end
                l_battleTips = {}
                l_root:SetActiveEx(false)
                return
            end
            l_curIndex = l_curIndex + 1
            l_tips = l_battleTips[l_curIndex]
            self.panel.PromptText.LabText = l_tips
        end, BATTLE_TIPS_TIME, -1, true)
        l_battleTimer:Start()
    end
end

function TipsDlgCtrl:ShowDungeonTips(str)
    if l_dungeonTimer then
        self:StopUITimer(l_dungeonTimer)
        l_dungeonTimer = nil
    end
    self.panel.DungeonPromptLab.LabText = str
    local l_root = self.panel.DungeonPrompt.gameObject
    l_root:SetActiveEx(true)
    l_dungeonTimer = self:NewUITimer(function()
        if l_dungeonTimer then
            self:StopUITimer(l_dungeonTimer)
            l_dungeonTimer = nil
        end
        l_root:SetActiveEx(false)
    end, 2, -1, true)
    l_dungeonTimer:Start()
end


--显示副本提示信息,EMessageRouterType[23, 27]
function TipsDlgCtrl:ShowDungeonHints(id, msgType, content, isClose)
    if not self.mrMgr then
        self.mrMgr = MgrMgr:GetMgr("MessageRouterMgr")
    end

    if not self:IsDungeonHintsCanShow(msgType) then
        return
    end

    local l_row = TableUtil.GetMessageTable().GetRowByID(id)
    if not l_row then
        return
    end

    self:InitDungeonHints()

    if msgType == self.mrMgr.EMessageRouterType.DungeonHintOnceWarning or msgType == self.mrMgr.EMessageRouterType.DungeonHintOnceAuxiliary then
        self:ShowDungeonHintsMid(msgType, content, l_row.Duration, l_row.CountDown)
    elseif msgType == self.mrMgr.EMessageRouterType.DungeonHintAside then
        self:ShowDungeonHintsStory(content, l_row.Duration)
    end

end
function TipsDlgCtrl:InitDungeonHints()
    --初始化副本提示相关组件
    if not self.dungeonHintsComponents then
        self.dungeonHintsComponents = {}
        self.dungeonHintsComponents.rootPanel = self.panel.DangerHint.gameObject
        self.dungeonHintsComponents.midPanel = self.panel.DangerHint.transform:Find("TipsMid").gameObject
        self.dungeonHintsComponents.midWarningPanel = self.panel.DangerHint.transform:Find("TipsMid/DangerPanel").gameObject
        self.dungeonHintsComponents.midAuxiliaryPanel = self.panel.DangerHint.transform:Find("TipsMid/HintPanel").gameObject
        self.dungeonHintsComponents.midWarningContent = self.panel.DangerHint.transform:Find("TipsMid/DangerPanel/Text"):GetComponent("Text")
        self.dungeonHintsComponents.midAuxiliaryContent = self.panel.DangerHint.transform:Find("TipsMid/HintPanel/Text"):GetComponent("Text")
        self.dungeonHintsComponents.storyPanel = self.panel.DangerHint.transform:Find("Story").gameObject
        self.dungeonHintsComponents.storyContent = MLuaClientHelper.GetOrCreateMLuaUICom(self.panel.DangerHint.transform:Find("Story/Text"))
    end
    self.dungeonHintsComponents.rootPanel:SetActiveEx(true)
end
function TipsDlgCtrl:ClearDungeonHints()
    if self.dungeonHintsComponents then
        self.dungeonHintsComponents.rootPanel:SetActiveEx(false)
        self.dungeonHintsComponents.midPanel:SetActiveEx(false)
        self.dungeonHintsComponents.storyPanel:SetActiveEx(false)
    end
end

--单次副本提示
function TipsDlgCtrl:ShowDungeonHintsMid(msgType, content, duration, countDown)
    self.midMsgType = msgType
    self.dungeonHintsComponents.midPanel:SetActiveEx(true)
    self.dungeonHintsComponents.midWarningPanel:SetActiveEx(false)
    self.dungeonHintsComponents.midAuxiliaryPanel:SetActiveEx(false)

    local l_curContent = self.dungeonHintsComponents.midWarningContent
    if msgType == self.mrMgr.EMessageRouterType.DungeonHintOnceWarning then
        self.dungeonHintsComponents.midWarningPanel:SetActiveEx(true)
        l_curContent = self.dungeonHintsComponents.midWarningContent
        MLuaClientHelper.PlayFxHelper(self.dungeonHintsComponents.midWarningPanel)
    elseif msgType == self.mrMgr.EMessageRouterType.DungeonHintOnceAuxiliary then
        self.dungeonHintsComponents.midAuxiliaryPanel:SetActiveEx(true)
        l_curContent = self.dungeonHintsComponents.midAuxiliaryContent
        MLuaClientHelper.PlayFxHelper(self.dungeonHintsComponents.midAuxiliaryPanel)
    end

    local l_com = MLuaClientHelper.GetOrCreateMLuaUICom(l_curContent.gameObject)
    l_com.LabText = content

    if not self.dungeonHintUIEffectName then
        self.dungeonHintUIEffectName = {
            [self.mrMgr.EMessageRouterType.DungeonHintOnceAuxiliary] = "Effects/Prefabs/Creature/Ui/Fx_ui_fb1",
            [self.mrMgr.EMessageRouterType.DungeonHintOnceWarning] = "Effects/Prefabs/Creature/Ui/Fx_ui_fb"
        }
    end
    if not self.dungeonHintParent then
        self.dungeonHintParent = {
            [self.mrMgr.EMessageRouterType.DungeonHintOnceAuxiliary] = "HintEffectParent1",
            [self.mrMgr.EMessageRouterType.DungeonHintOnceWarning] = "HintEffectParent2"
        }
    end

    local l_fxData = {}
    --l_fxData.scaleFac = Vector3.New(350, 350, 1)
    l_fxData.parent = self.panel[self.dungeonHintParent[msgType]].Transform
    l_fxData.layer = MLayer.ID_UI
    l_fxData.destroyHandler = function()
        if self.dangerHintUIEffect[msgType] then
            self.dangerHintUIEffect[msgType] = nil
        end
    end
    l_fxData.loadedCallback = function()
        --加载完成时动画已结束的情况
        if not self.dungeonHintsComponents.midPanel.activeSelf and self.dangerHintUIEffect[msgType] then
            self:DestroyUIEffect(self.dangerHintUIEffect[msgType])
        end
    end
    if self.dangerHintUIEffect[msgType] then
        self:DestroyUIEffect(self.dangerHintUIEffect[msgType])
        self.dangerHintUIEffect[msgType] = nil
    end
    self.dangerHintUIEffect[msgType] = self:CreateEffect(self.dungeonHintUIEffectName[msgType], l_fxData)

    LayoutRebuilder.ForceRebuildLayoutImmediate(self.dungeonHintsComponents.midPanel.transform)

    if self.midHintTimer then
        self:StopUITimer(self.midHintTimer)
        self.midHintTimer = nil
    end
    if duration ~= -1 then
        self.midHintTimer = self:NewUITimer(function()
            MUITweenHelper.TweenAlpha(self.dungeonHintsComponents.midPanel, 1, 0, 0.5, function()
                self.dungeonHintsComponents.midPanel:GetComponent("CanvasGroup").alpha = 1
                self.dungeonHintsComponents.midPanel:SetActiveEx(false)
                if self.dangerHintUIEffect[msgType] then
                    self:DestroyUIEffect(self.dangerHintUIEffect[msgType])
                    self.dangerHintUIEffect[msgType] = nil
                end
            end)
            self.midMsgType = nil
            if self.midHintTimer then
                self:StopUITimer(self.midHintTimer)
                self.midHintTimer = nil
            end
        end, duration)
        self.midHintTimer:Start()
    end

    if self.midHintCounter then
        self:StopUITimer(self.midHintCounter)
        self.midHintCounter = nil
    end

    --3,2,1展示时间倒计时
    if countDown and countDown ~= 0 then
        l_curContent.text = StringEx.Format(content, countDown)
        self.midHintCounter = self:NewUITimer(function()
            countDown = countDown - 1
            l_curContent.text = StringEx.Format(content, countDown)
            if countDown == 0 then
                self:StopUITimer(self.midHintCounter)
                self.midHintCounter = nil
            end
        end, 1, -1)

        self.midHintCounter:Start()
    end
end

--副本旁白
function TipsDlgCtrl:ShowDungeonHintsStory(content, duration)
    self:InitDungeonHints()

    self.dungeonHintsComponents.storyPanel:SetActiveEx(true)
    self.dungeonHintsComponents.storyContent.LabText = content

    MLuaClientHelper.PlayFxHelper(self.dungeonHintsComponents.storyPanel)

    if self.storyHintTimer then
        self:StopUITimer(self.storyHintTimer)
        self.rightHintTimer = nil
    end

    if duration ~= -1 then
        self.storyHintTimer = self:NewUITimer(function()
            MUITweenHelper.TweenAlpha(self.dungeonHintsComponents.storyPanel, 1, 0, 0.5, function()
                self.dungeonHintsComponents.storyPanel:GetComponent("CanvasGroup").alpha = 1
                self.dungeonHintsComponents.storyPanel:SetActiveEx(false)
            end)
            if self.storyHintTimer then
                self:StopUITimer(self.storyHintTimer)
                self.storyHintTimer = nil
            end
        end, duration)
        self.storyHintTimer:Start()
    end
end

--关闭副本旁白
function TipsDlgCtrl:CloseDungeonHintsStory()

    if self.dungeonHintsComponents and self.dungeonHintsComponents.storyPanel.activeSelf then
        MUITweenHelper.TweenAlpha(self.dungeonHintsComponents.storyPanel, 1, 0, 0.5, function()
            self.dungeonHintsComponents.storyPanel:GetComponent("CanvasGroup").alpha = 1
            self.dungeonHintsComponents.storyPanel:SetActiveEx(false)
        end)
    end

end

function TipsDlgCtrl:ClearQue()
    if l_battleTimer then
        self:StopUITimer(l_battleTimer)
        l_battleTimer = nil
        self.panel.PromptText.transform.parent.gameObject:SetActiveEx(false)
    end
    l_battleTips = {}

end


--副本提示的互斥规则
function TipsDlgCtrl:IsDungeonHintsCanShow(msgType)
    return not (msgType == self.mrMgr.EMessageRouterType.DungeonHintOnceAuxiliary and self.midMsgType == self.mrMgr.EMessageRouterType.DungeonHintOnceWarning)
end

--lua custom scripts end

return TipsDlgCtrl
