--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/CatCaravanPanel"
require "UI/Template/CatCaravanTrainTem"



--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua class define
local super = UI.UIBaseCtrl
CatCaravanCtrl = class("CatCaravanCtrl", super)
--lua class define end

--lua functions
function CatCaravanCtrl:ctor()

    super.ctor(self, CtrlNames.CatCaravan, UILayer.Function, nil, ActiveType.Exclusive)
    self.isFullScreen = true
end --func end
--next--
function CatCaravanCtrl:Init()

    self.panel = UI.CatCaravanPanel.Bind(self)
    super.Init(self)
    self.Mgr = MgrMgr:GetMgr("CatCaravanMgr")
    self.AwardTween = self.panel.PromptIcon.gameObject:GetComponent("DOTweenAnimation")
    self.panel.CloseBtn:AddClick(function()
        UIMgr:DeActiveUI(CtrlNames.CatCaravan)
    end)
    self.panel.TrainPrefab.LuaUIGroup.gameObject:SetActiveEx(false)
    self:SetAllNone(false)
    self.TrainTems = {}
    --奖励状态变化事件
    self:ResetAwardState()
    --月卡返岗按钮
    self.panel.Btn_Month:AddClick(function()
        self.Mgr.SendGetInfo(true)
        self:ResetTime()
        self.Mgr.TryGetTask()
    end)
    --奖励按钮
    self.panel.PromptBtn:AddClick(function()
        if self.Mgr.AwardStatus == 0 then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("CatCaravan_NoAward"))--奖励还不能领取
            if self.AwardItem ~= nil then
                MgrMgr:GetMgr("ItemTipsMgr").ShowTipsDisplayWithId(self.AwardItem.ItemID, nil, nil, nil, false)
            end
        elseif self.Mgr.AwardStatus == 1 then
            self.Mgr.SendGetReward()
        elseif self.Mgr.AwardStatus == 2 then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("CatCaravan_AwardOver"))--"奖励已经领取"
            if self.AwardItem ~= nil then
                MgrMgr:GetMgr("ItemTipsMgr").ShowTipsDisplayWithId(self.AwardItem.ItemID, nil, nil, nil, false)
            end
        end
    end, true)
    --奖励显示
    self.AwardItem = nil
    local l_awardID = MGlobalConfig:GetInt("FillTotalAward")
    local l_awardData = TableUtil.GetAwardTable().GetRowByAwardId(l_awardID)
    if l_awardData ~= nil then
        for i = 0, l_awardData.PackIds.Length - 1 do
            local l_packData = TableUtil.GetAwardPackTable().GetRowByPackId(l_awardData.PackIds[i])
            if l_packData ~= nil then
                for j = 0, l_packData.GroupContent.Count - 1 do
                    self.AwardItem = l_packData.GroupContent:get_Item(j, 0)
                    self.AwardItem = TableUtil.GetItemTable().GetRowByItemID(self.AwardItem)
                    break
                end
            end
        end
    end
    if self.AwardItem ~= nil then
        self.panel.PromptIcon:SetSprite(self.AwardItem.ItemAtlas, self.AwardItem.ItemIcon, true)
    end

    --
    self.Mgr.SendGetInfo()

    --定时开始
    self:ResetTime()

    --红点
    self.RedSignProcessor = self:NewRedSign({
        Key = eRedSignKey.CatCaravan,
        ClickButton = self.panel.PromptIcon,
    })

    --勋章按钮
    self.panel.MedalBtn:AddClick(function()
        if MPlayerInfo.ProID == 1000 then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("MEDAL_FUNC_OPEN_LIMIT_TIP"))
        else
            UIMgr:DeActiveUI(CtrlNames.CatCaravan)
            UIMgr:ActiveUI(UI.CtrlNames.Medal)
        end
    end)

    self.Mgr.TryGetTask()
    self.panel.GMBtn1:AddClick(function()
        for i = 1, #self.Mgr.Datas do
            for k, v in pairs(self.Mgr.Datas[i].seat_list) do
                if not v.is_full then
                    local recycleRow = TableUtil.GetRecycleTable().GetRowByID(v.item_id)
                    local itemId = recycleRow.ItemID
                    MgrMgr:GetMgr("GmMgr").SendCommand(StringEx.Format("{0} {1}", itemId, v.item_count))
                end
            end
        end
    end)
    self.panel.GMBtn2:AddClick(function()
        for i = 1, #self.Mgr.Datas do
            local boatId = self.Mgr.Datas[i].id
            for k, v in pairs(self.Mgr.Datas[i].seat_list) do
                local recycleRow = TableUtil.GetRecycleTable().GetRowByID(v.item_id)
                local itemId = recycleRow.ItemID
                local items = self.Mgr._getValidBagItems(itemId)
                local needCount = v.item_count
                local needDatas = {}
                for _, itemData in pairs(items) do
                    if needCount <= 0 then
                        break
                    end
                    table.insert(needDatas, { uid = itemData.UID, num = needCount > itemData.ItemCount and itemData.ItemCount or needCount })
                    needCount = needCount - itemData.ItemCount
                end
                self.Mgr.SendSellGoods(boatId, v.id, needDatas)
            end
        end
    end)
end --func end
--next--
function CatCaravanCtrl:Uninit()

    if self.AllNoneTask then
        self:StopUITimer(self.AllNoneTask)
        self.AllNoneTask = nil
    end

    self.TrainTems = nil
    if self.Clock ~= nil then
        self:StopUITimer(self.Clock)
        self.Clock = nil
    end

    self.RedSignProcessor = nil
    if self.ChuanCatModel ~= nil then
        self:DestroyUIModel(self.ChuanCatModel);
        self.ChuanCatModel = nil
    end

    super.Uninit(self)
    self.panel = nil
end --func end
--next--
function CatCaravanCtrl:OnActive()
    self.panel.GMBtn1:SetActiveEx(MGameContext.IsOpenGM)
    self.panel.GMBtn2:SetActiveEx(MGameContext.IsOpenGM)

end --func end
--next--
function CatCaravanCtrl:OnDeActive()

end --func end
--next--
function CatCaravanCtrl:Update()


end --func end



--next--
function CatCaravanCtrl:BindEvents()

    self:BindEvent(self.Mgr.EventDispatcher, self.Mgr.Event.InitData, function(self)
        for i = 1, #self.Mgr.Datas do
            local l_data = {
                data = self.Mgr.Datas[i],
                index = i,
            }
            if self.TrainTems[i] == nil then
                self.TrainTems[i] = self:NewTemplate("CatCaravanTrainTem", {
                    TemplatePrefab = self.panel.TrainPrefab.LuaUIGroup.gameObject,
                    TemplateParent = self.panel.Trains.transform,
                    Data = l_data
                })
            else
                self.TrainTems[i]:SetData(l_data)
            end
        end
        self:SetAllNone(self.Mgr.AllFull)
        UIMgr:DeActiveUI(CtrlNames.CatCaravanTips)
    end)
    self:BindEvent(self.Mgr.EventDispatcher, self.Mgr.Event.ResetData, function(self, tid, sid, AllChange)
        for i = 1, #self.TrainTems do
            if self.TrainTems[i].netData.id == tid or AllChange then
                self.TrainTems[i]:ResetData()
            end
        end

        --延时打开
        if AllChange and self.Mgr.AllFull then
            if self.AllNoneTimer then
                self:StopUITimer(self.AllNoneTimer)
                self.AllNoneTimer = nil
            end
            self.AllNoneTimer = self:NewUITimer(function()
                self:SetAllNone(self.Mgr.AllFull)
                self.AllNoneTimer = nil
            end, 5)
            self.AllNoneTimer:Start()
        end
    end)
    self:BindEvent(self.Mgr.EventDispatcher, self.Mgr.Event.AwardChange, self.ResetAwardState)

end --func end

--next--
--lua functions end

--lua custom scripts
function CatCaravanCtrl:ResetAllNone()

end

function CatCaravanCtrl:ResetTime()
    --定时开始
    local l_CurTimeObj = os.date("!*t", Common.TimeMgr.GetLocalNowTimestamp())
    local l_Exceed = (l_CurTimeObj.hour * 60 + l_CurTimeObj.min) * 60 + l_CurTimeObj.sec >= 18001
    l_CurTimeObj.hour = 5
    l_CurTimeObj.min = 0
    l_CurTimeObj.sec = 1
    l_CurTimeObj = Common.TimeMgr.GetUtcTimeByTimeTable(l_CurTimeObj)
    if l_Exceed then
        l_CurTimeObj = l_CurTimeObj + 86400
    end
    if self.Clock ~= nil then
        self:StopUITimer(self.Clock)
        self.Clock = nil
    end
    self.Clock = self:NewUITimer(function()
        local l_curIndex = MLuaCommonHelper.Long2Int(MServerTimeMgr.UtcSeconds)
        if l_curIndex >= l_CurTimeObj then
            if self.Clock ~= nil then
                self:StopUITimer(self.Clock)
                self.Clock = nil
            end
            logWarn("过五点重新拉取服务器数据!")
            self.Mgr.SendGetInfo()

            --重新截取日常任务
            self.LastTaskDay = nil
            self.Mgr.TryGetTask()

            self:ResetTime()
        end
    end, 0.7, -1, true)
    self.Clock:Start()
end

function CatCaravanCtrl:ResetAwardState()
    local l_canAward = self.Mgr.AwardStatus == 1
    if l_canAward then
        self.AwardTween.transform:SetLocalScale(0.4, 0.4, 0.4)
        self.AwardTween:DOPlay()
    else
        self.AwardTween:DOPause()
        self.AwardTween.transform:SetLocalScale(0.4, 0.4, 0.4)
    end
    --self.AwardTween
end

function CatCaravanCtrl:SetAllNone(b)
    if self.panel == nil then
        return
    end
    self.panel.Monthlycard:SetActiveEx(false)
    self.panel.AllNone:SetActiveEx(b)
    self.panel.AllNoneRt:SetActiveEx(false)

    if self.ChuanCatModel ~= nil then
        self:DestroyUIModel(self.ChuanCatModel);
        self.ChuanCatModel = nil
    end

    if b then
        local l_limitBuyMgr = MgrMgr:GetMgr("LimitBuyMgr")
        --todo 月卡特权返港
        if MgrMgr:GetMgr("MonthCardMgr").GetIsBuyMonthCard()
                and l_limitBuyMgr.GetItemCanBuyCount(l_limitBuyMgr.g_limitType.CatCaravan,3026101) > 0 then
            self.panel.Monthlycard:SetActiveEx(true)
        else
            self.panel.Monthlycard:SetActiveEx(false)
        end
        local l_clipPath = MAnimationMgr:GetClipPath("NPC_M_FuMo_JieMian_Idle")
        local l_modelData = {
            prefabPath = "Prefabs/NPC_M_FuMo",
            rawImage = self.panel.AllNoneRt.RawImg,
            defaultAnim = l_clipPath,
        }
        self.ChuanCatModel = self:CreateUIModelByPrefabPath(l_modelData)
        self.ChuanCatModel:AddLoadModelCallback(function(m)
            self.panel.AllNoneRt:SetActiveEx(true)
            self.ChuanCatModel.Trans:SetPos(0.2, -0.13, 0.1470049)
            self.ChuanCatModel.Trans:SetLocalScale(1.5, 1.5, 1.5)
            self.ChuanCatModel.UObj:SetRotEuler(0, 158.3, 0)
        end)
        if MgrMgr:GetMgr("MonthCardMgr").GetIsBuyMonthCard() then
            self.panel.AllNoneTxt.LabText = Common.Utils.Lang("CATCARAVAN_ALLNONE_VIP")
        else
            self.panel.AllNoneTxt.LabText = Common.Utils.Lang("CATCARAVAN_ALLNONE_NORMAL")
        end
    end
end
--lua custom scripts end
return CatCaravanCtrl
