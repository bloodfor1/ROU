--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/GiftPanel"
require "UI/Template/GiftFriendTemplate"
require "UI/Template/GiftItemTemplate"
require "UI/Template/EmblemGiftTemplate"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end`

--lua class define
local super = UI.UIBaseCtrl
GiftCtrl = class("GiftCtrl", super)
--lua class define end

--lua functions
function GiftCtrl:ctor()

    super.ctor(self, CtrlNames.Gift, UILayer.Function, UITweenType.UpAlpha, ActiveType.Exclusive)
    self.IgnoreHidePanelNames = { UI.CtrlNames.DailyTask }

end --func end
--next--
function GiftCtrl:Init()
    self.panel = UI.GiftPanel.Bind(self)
    super.Init(self)
    self.giftMgr = MgrMgr:GetMgr("GiftMgr")
    --初始化显示的item数量
    local l_scrollY = self.panel.FriendScroll.RectTransform.sizeDelta.y
    local l_prefabY = self.panel.GiftItemPrefab.RectTransform.sizeDelta.y
    self.isActiveCount = math.floor(l_scrollY / l_prefabY)
    --礼物数据
    ---@type GiftItemData[]
    self.canGiftsItem = {}
    --好友列表对象池
    self.friendTemplatePool = self:NewTemplatePool(
            {
                UITemplateClass = UITemplate.GiftFriendTemplate,
                TemplatePrefab = self.panel.GiftItemPrefab.gameObject,
                ScrollRect = self.panel.FriendScroll.LoopScroll
            })

    --道具列表对象池
    self.itemTemplatePool = self:NewTemplatePool(
            {
                UITemplateClass = UITemplate.GiftItemTemplate,
                TemplatePrefab = self.panel.ItemPrefab.gameObject,
                ScrollRect = self.panel.ItemScroll.LoopScroll
            })
    self.emblemTemplatePool = self:NewTemplatePool(
            {
                UITemplateClass = UITemplate.EmblemGiftTemplate,
                TemplatePrefab = self.panel.EmblemGiftTemplate.LuaUIGroup.gameObject,
                ScrollRect = self.panel.Emblem.LoopScroll,
            })
    --关闭界面
    self.panel.BtnClose:AddClick(function()
        self:ClearData()
        UIMgr:DeActiveUI(UI.CtrlNames.Gift)
    end)
    --赠送规则
    self.panel.BtnHelp:AddClick(function()
        self.panel.ExplainPanel.gameObject:SetActiveEx(true)
    end)
    self.panel.CloseExplainPanelButton:AddClick(function()
        self.panel.ExplainPanel.gameObject:SetActiveEx(false)
    end)

    self:_updateGiftPageData(0)
    --默认分类
    self.panel.ItemBtn:OnToggleExChanged(function(value)
        if self.giftMgr.g_giftType == 0 then
            return
        end
        self:_updateGiftPageData(0)
        self:ResetGifts()
    end)

    --头饰分类
    self.panel.HeadBtn:OnToggleExChanged(function(value)
        if self.giftMgr.g_giftType == 1 then
            return
        end

        self:_updateGiftPageData(1)
        self:ResetGifts()
    end)
    -- 特殊
    self.panel.SpecialBtn:OnToggleExChanged(function(value)
        if self.giftMgr.g_giftType == 3 then
            return
        end

        self:_updateGiftPageData(3)
        self:ResetGifts()
    end)
    -- 徽章
    self.panel.EmblemBtn:OnToggleExChanged(function(value)
        if self.giftMgr.g_giftType == 2 then
            return
        end

        self:_updateGiftPageData(2)
        self:ResetGifts()
    end)
    --赠送礼物
    self.panel.GiftBtn:AddClick(function()
        if self.giftMgr.g_giftTimesInfo.present_times[1].left_times <= 0 then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("MY_GIFTS_LIMIT"))
            return
        elseif self.giftMgr.g_giftTimesInfo.gift_recipient_times <= 0 then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("FRIEND_GIFTS_LIMIT"))
            return
        end
        self.giftMgr.SendGifts()
    end)
end --func end
--next--
function GiftCtrl:Uninit()
    if self.giftMgr then
        self.giftMgr.g_currentSelectFriend = nil
        self.giftMgr.g_giftType = 0
        self.giftMgr.g_giftTimesInfo = nil
        self.giftMgr = nil
    end

    super.Uninit(self)
    self.panel = nil
end --func end
--next--
function GiftCtrl:OnActive()
    --根据礼物类型拿到背包里所有可以赠送的物品
    self:ShowFriends(self.giftMgr.g_friendsList)
end --func end
--next--
function GiftCtrl:OnDeActive()

end --func end
--next--
function GiftCtrl:Update()

end --func end

--next--
function GiftCtrl:BindEvents()
    self:BindEvent(MgrProxy:GetGameEventMgr().l_eventDispatcher, MgrProxy:GetGameEventMgr().OnBagUpdate, self._onBagUpdate, self)
    ----赠送成功重置道具列表信息
    self:BindEvent(self.giftMgr.EventDispatcher, self.giftMgr.GiveGiftsSuccess, self._onSendGiftConfirm, self)
    --选择道具刷新道具进度条
    self:BindEvent(self.giftMgr.EventDispatcher, self.giftMgr.SelectGiftItem, function(self)
        self:UpdateSlider()
    end)
end --func end
--next--
--lua functions end

--lua custom scripts
function GiftCtrl:_updateGiftPageData(type)
    self.giftMgr.g_giftType = type
    self.canGiftsItem = self.giftMgr.GetGiftItem()
    self.giftMgr.g_giftCount = 0
    self.giftMgr.g_giftItems = {}
end

function GiftCtrl:_onSendGiftConfirm()
    self.canGiftsItem = self.giftMgr.GetGiftItem()
    self.giftMgr.g_giftCount = 0
    self.giftMgr.g_giftItems = {}
    self.friendTemplatePool.Datas[self.giftMgr.g_currentSelectFriendIndex] = self.giftMgr.g_currentSelectFriend
    self:UpdateGiftsInfo()
end

---@param updateItemDataList ItemUpdateData[]
function GiftCtrl:_onBagUpdate(updateItemDataList)
    for i = 1, #updateItemDataList do
        local singleData = updateItemDataList[i]
        if 0 < singleData:GetItemCompareData().count then
            self.giftMgr.UpdateAllGiftInfo(singleData, self.canGiftsItem)
        end
    end

    self.friendTemplatePool.Datas[self.giftMgr.g_currentSelectFriendIndex] = self.giftMgr.g_currentSelectFriend
    self:UpdateGiftsInfo()
end

--清空数据
function GiftCtrl:ClearData()
    self.giftMgr.g_currentSelectFriendUID = 0
    self.canGiftsItem = {}
    self.isActiveCount = 0
    self.giftMgr.g_giftItems = {}
    self.giftMgr.g_giftCount = 0
    self.giftMgr.g_stallItemTable = {}
    self.giftMgr.g_friendsList = {}
    self.friendTemplatePool = nil
    self.itemTemplatePool = nil
    self.emblemTemplatePool = nil
end

--- 比较函数
--- 陌生人置顶
--- 在线-离线
--- 好友度降序
---@param x GiftLimitInfo
---@param y GiftLimitInfo
local function _compareFunc(x, y)
    if x.friend_list.friend_type > y.friend_list.friend_type then
        return true
    elseif x.friend_list.friend_type < y.friend_list.friend_type then
        return false
    end

    if x.friend_list.base_info.status < y.friend_list.base_info.status then
        return true
    elseif x.friend_list.base_info.status > y.friend_list.base_info.status then
        return false
    end

    return x.friend_list.intimacy_degree > y.friend_list.intimacy_degree
end

--显示好友
function GiftCtrl:ShowFriends(friendsList)
    self.panel.TextMessage.LabText = Common.Utils.Lang("Gift_Head_Help")

    --清空索引
    self.giftMgr.g_currentSelectFriendIndex = 1
    table.sort(friendsList, _compareFunc)

    --定位到所选玩家的位置
    local l_index = 1
    if self.giftMgr.g_currentSelectFriendUID ~= 0 then
        for i = 1, #friendsList do
            if friendsList[i].friend_list.uid == self.giftMgr.g_currentSelectFriendUID then
                l_index = i
                break
            end
        end
        self.giftMgr.g_currentSelectFriendIndex = l_index
    end

    --总数据不大于显示区域个数 不需要定位
    if self.isActiveCount >= l_index then
        l_index = 1
    else
        l_index = l_index - self.isActiveCount + 1
    end

    --玩家列表
    self.friendTemplatePool:ShowTemplates({ Datas = friendsList, StartScrollIndex = l_index, Method = function(item)
        if self.giftMgr.g_currentSelectFriendIndex == item.ShowIndex then
            return
        end
        local l_lastIndex = self.giftMgr.g_currentSelectFriendIndex
        self.giftMgr.g_currentSelectFriendIndex = item.ShowIndex
        self.panel.FriendScroll.LoopScroll:RefreshCell(l_lastIndex - 1)
        self:ChooseFriend(item.data)
    end })

    --默认选中玩家
    if self.giftMgr.g_currentSelectFriendUID ~= 0 then
        for i = 1, #self.friendTemplatePool.Datas do
            if self.friendTemplatePool.Datas[i].friend_list.uid == self.giftMgr.g_currentSelectFriendUID then
                self:ChooseFriend(self.friendTemplatePool.Datas[i])
                break
            end
        end
    end
end

--选择好友
function GiftCtrl:ChooseFriend(friendData)
    --选择赠送的玩家
    --重复点击无效
    if self.giftMgr.g_currentSelectFriend == friendData then
        return
    end
    local l_friendInfo = friendData.friend_list
    if l_friendInfo.is_guild_beauty then
        self.panel.NormalNamePanel:SetActiveEx(false)
        self.panel.LongNamePanel:SetActiveEx(true)
        self.panel.GiftFriendSpecialText.LabText = StringEx.Format(Common.Utils.Lang("GIFT_PLAYER_NAME") .. " <color=#FF869D>{1}</color>",
                l_friendInfo.base_info.name, Lang("BEAUTY"))
        self.panel.GiftFriendSpecialBtn.Listener.onClick = function(go, ed)
            MgrMgr:GetMgr("TipsMgr").ShowQuestionTip(Lang("GUILD_BEAUTY_GIFT_GET"), ed, Vector2(1, 0), false)
        end
    else
        self.panel.NormalNamePanel:SetActiveEx(true)
        self.panel.LongNamePanel:SetActiveEx(false)
        self.panel.GiftFriendText.LabText = StringEx.Format(Common.Utils.Lang("GIFT_PLAYER_NAME"), l_friendInfo.base_info.name)
    end

    self.giftMgr.g_currentSelectFriend = friendData
    self:ResetGifts()
end

--重置进度条
function GiftCtrl:ResetGifts()
    self.giftMgr.g_giftTimesInfo = nil
    for i = 1, #self.giftMgr.g_currentSelectFriend.gift_times do
        local l_target = self.giftMgr.g_currentSelectFriend.gift_times[i]
        if l_target.gift_type == nil then
            l_target.gift_type = 0
        end
        if l_target.gift_recipient_times == nil then
            l_target.gift_recipient_times = 0
        end

        if l_target.present_times[1].left_times == nil then
            l_target.present_times[1].left_times = 0
        end

        if l_target.present_times[1].total_count == nil then
            l_target.present_times[1].total_count = 1
        end
        if self.giftMgr.g_currentSelectFriend.gift_times[i].gift_type == self.giftMgr.g_giftType then
            self.giftMgr.g_giftTimesInfo = self.giftMgr.g_currentSelectFriend.gift_times[i]
            break
        end
    end
    if not self.giftMgr.g_giftTimesInfo then
        logError("not have gifttype " .. self.giftMgr.g_giftType)
        return
    end
    --刷新进度条
    self:UpdateSlider()
    if self.giftMgr.g_giftType == 1 or self.giftMgr.g_giftType == 0 or self.giftMgr.g_giftType == 3 then
        self.panel.Empty.gameObject:SetActiveEx(#self.canGiftsItem <= 0)
        self.panel.ItemScroll.gameObject:SetActiveEx(#self.canGiftsItem > 0)
        if #self.canGiftsItem > 0 then
            --实例化道具列表
            self.itemTemplatePool:ShowTemplates({ Datas = self.canGiftsItem, StartScrollIndex = 1, ShowMinCount = 25 })
        end

        self.panel.Emblem.gameObject:SetActiveEx(false)
    end

    if self.giftMgr.g_giftType == 2 then
        local l_datas = {}
        local l_emblemIds = MgrMgr:GetMgr("DelegateModuleMgr").GetEmblemIds()
        for i, v in ipairs(l_emblemIds) do
            local l_count = MgrMgr:GetMgr("ItemContainerMgr").GetItemCountByContAndID(GameEnum.EBagContainerType.VirtualItem, v)
            if l_count > 0 then
                table.insert(l_datas, { id = v, count = l_count })
            end
        end

        self.panel.Empty.gameObject:SetActiveEx(table.ro_size(l_datas) <= 0)
        self.emblemTemplatePool:ShowTemplates({ Datas = l_datas })
        self.panel.ItemScroll.gameObject:SetActiveEx(false)
        self.panel.Emblem.gameObject:SetActiveEx(true)
    end
end

--礼物赠送成功
--刷新道具
function GiftCtrl:UpdateGiftsInfo()
    if self.giftMgr.g_giftType == 1 or self.giftMgr.g_giftType == 0 then
        for i = 1, #self.giftMgr.g_giftItems do
            for j = #self.canGiftsItem, 1, -1 do
                --遍历找出所有赠送出的道具
                if uint64.equals(self.giftMgr.g_giftItems[i].UID, self.canGiftsItem[j].Item.UID) then
                    if not self:_checkItemInBag(self.canGiftsItem[j].Item.UID) then
                        --道具数量为0则删除
                        self.canGiftsItem[j] = nil
                    end

                    self.itemTemplatePool.Datas[j] = self.canGiftsItem[j]
                    self.panel.ItemScroll.LoopScroll:RefreshCell(j - 1)
                    break
                end
            end
        end
    end

    self:ResetGifts()
end

---@param uid string
---@return boolean
function GiftCtrl:_checkItemInBag(uid)
    if nil == uid then
        logError("[GiftCtrl] invalid param")
        return false
    end

    local targetItem = Data.BagApi:GetItemByUID(uid)
    local itemExists = nil ~= targetItem
    if not itemExists then
        return false
    end

    local containerValid = GameEnum.EBagContainerType.Bag == targetItem.ContainerType
    return containerValid
end

--刷新进度条
function GiftCtrl:UpdateSlider()
    --已经赠送了多少次
    local l_type = self.giftMgr.g_giftTimesInfo.present_times[1].limit_type
    self.panel.timeText.LabText = Common.Utils.Lang("GIFT_TODAY")
    if l_type == 2 then
        self.panel.timeText.LabText = Common.Utils.Lang("GIFT_WEEK")
    end

    local l_giftTimes = self.giftMgr.g_giftTimesInfo.present_times[1].total_count -
            self.giftMgr.g_giftTimesInfo.present_times[1].left_times + self.giftMgr.g_giftCount
    if l_giftTimes >= self.giftMgr.g_giftTimesInfo.present_times[1].total_count then
        l_giftTimes = self.giftMgr.g_giftTimesInfo.present_times[1].total_count
    elseif 0 >= l_giftTimes then
        l_giftTimes = 0
    end

    self.panel.SliderText.LabText = StringEx.Format("{0}/{1}", l_giftTimes, self.giftMgr.g_giftTimesInfo.present_times[1].total_count)
    self.panel.GiftSlider.Slider.fillRect.gameObject:SetActiveEx(l_giftTimes > 0)
    self.panel.GiftSlider.Slider.value = l_giftTimes / self.giftMgr.g_giftTimesInfo.present_times[1].total_count
end

--lua custom scripts end
return GiftCtrl