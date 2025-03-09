--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/BaseUITemplate"
--lua requires end

--lua model
module("UITemplate", package.seeall)

--lua model end

--lua fields
local super = UITemplate.BaseUITemplate
--lua fields end

--lua class define
---@class GiftItemTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field RemoveBtn MoonClient.MLuaUICom
---@field ItemIcon MoonClient.MLuaUICom
---@field ItemCount MoonClient.MLuaUICom
---@field ItemButton MoonClient.MLuaUICom
---@field GiftSelecte MoonClient.MLuaUICom
---@field CardPos MoonClient.MLuaUICom
---@field CardBg MoonClient.MLuaUICom

---@class GiftItemTemplate : BaseUITemplate
---@field Parameter GiftItemTemplateParameter

GiftItemTemplate = class("GiftItemTemplate", super)
--lua class define end

--lua functions
function GiftItemTemplate:Init()
    super.Init(self)
    --去除道具
    self.Parameter.RemoveBtn:AddClickWithLuaSelf(self._onRemoveBtnClick, self)
end --func end
--next--
function GiftItemTemplate:OnDeActive()
    self.data = nil
end --func end
--next--
---@param data GiftItemData
function GiftItemTemplate:OnSetData(data)
    self.data = data
    self.isShowTips = true
    self.isLongButton = true
    self:ShowItemInfo(self.data)
end --func end

--next--
--lua functions end

--lua custom scripts
---@param data GiftItemData
function GiftItemTemplate:ShowItemInfo(data)
    self.Parameter.ItemIcon.gameObject:SetActiveEx(data ~= nil)
    self.Parameter.ItemCount.gameObject:SetActiveEx(data ~= nil)
    self.Parameter.CardBg.gameObject:SetActiveEx(false)
    self.Parameter.CardPos.gameObject:SetActiveEx(false)
    local l_color = Color.New(1, 1, 1, 1)
    self.Parameter.ItemButton.Img.color = l_color
    if data == nil then
        self.Parameter.GiftSelecte.gameObject:SetActiveEx(false)
        self.Parameter.RemoveBtn.gameObject:SetActiveEx(false)
        --空的
        self.Parameter.ItemButton.LongBtn.onClick = function(go, data)
            local l_ui = UIMgr:GetUI(UI.CtrlNames.CommonItemTips)
            if l_ui ~= nil then
                UIMgr:DeActiveUI(UI.CtrlNames.CommonItemTips)
            end
        end
        self.Parameter.ItemButton.LongBtn.onLongClick = nil
        return
    end

    --道具信息
    local l_friendDegree = 0
    local l_giftRow = TableUtil.GetGiftTable().GetRowByItemID(data.Item.TID)
    if l_giftRow then
        l_friendDegree = l_giftRow.FriendDegree
    end

    --好友度不足不能选择此道具
    if l_friendDegree > MgrMgr:GetMgr("GiftMgr").g_currentSelectFriend.friend_list.intimacy_degree or data.Item.IsBind then
        l_color = Color.New(0, 0, 0, 1)
    end
    self.Parameter.ItemIcon.Img.color = l_color
    self.Parameter.ItemButton.Img.color = l_color
    self.Parameter.ItemIcon:SetSprite(data.Item.ItemConfig.ItemAtlas, data.Item.ItemConfig.ItemIcon, true)
    --卡片
    if data.Item.ItemConfig.TypeTab == Data.BagModel.PropType.Card then
        local l_bgAtlas, l_bgIcon = Data.BagModel:getCardBgInfo(data.Item.TID)
        local l_atlas, l_sprite = Data.BagModel:getCardPosInfo(data.Item.TID)
        self.Parameter.CardBg.gameObject:SetActiveEx(true)
        self.Parameter.CardPos.gameObject:SetActiveEx(true)
        self.Parameter.CardBg:SetSprite(l_bgAtlas, l_bgIcon)
        self.Parameter.CardPos:SetSprite(l_atlas, l_sprite, true)
    end
    self.Parameter.ItemButton.LongBtn.onClick = function(go, eventData)
        --道具tips
        MgrMgr:GetMgr("ItemTipsMgr").ShowTipsDisplayWithUid(data.Item.UID, self.Parameter.ItemButton.transform, Data.BagModel.WeaponStatus.Gift)
        self.isLongButton = false
        self:ClickGifts(data, l_friendDegree)
    end
    if data.Item.ItemConfig.Overlap <= 1 then
        --不是叠加道具不显示count
        self.Parameter.ItemCount.LabText = ""
        self.Parameter.ItemButton.LongBtn.onLongClick = nil
    else
        --叠加道具显示count
        self.Parameter.ItemButton.LongBtn.onLongClick = function(go, eventData)
            self.isLongButton = true
            self:ClickGifts(data, l_friendDegree)
        end

        self.Parameter.ItemCount.LabText = tostring(data.Item.ItemCount)
    end

    --如果数量大于0的说明已经选中了这个礼物
    --显示选择，去除按钮
    self.Parameter.GiftSelecte.gameObject:SetActiveEx(data.count > 0)
    self.Parameter.RemoveBtn.gameObject:SetActiveEx(data.count > 0 and data.Item.ItemConfig.Overlap > 1)
    if data.count > 0 and data.Item.ItemConfig.Overlap > 1 then
        self.Parameter.ItemCount.LabText = StringEx.Format("{0}/{1}", tostring(data.count), tostring(data.Item.ItemCount))
    end
end

function GiftItemTemplate:_onRemoveBtnClick()
    if nil == self.data then
        return
    end

    --当前是已选中状态
    --先判断是否堆叠 不是堆叠取消选中礼物
    --可堆叠 堆叠数减一 到0取消选中礼物
    self.data.count = self.data.count - 1
    if self.data.Item.ItemConfig.Overlap > 1 then
        if self.data.count == 0 then
            self.Parameter.RemoveBtn.gameObject:SetActiveEx(false)
            self.Parameter.ItemCount.LabText = tostring(self.data.Item.ItemCount)
        else
            self.Parameter.RemoveBtn.gameObject:SetActiveEx(true)
            self.Parameter.ItemCount.LabText = StringEx.Format("{0}/{1}", tostring(self.data.count), tostring(self.data.Item.ItemCount))
        end
    end

    self.isShowTips = true
    self:RemoveGifts()
end

--点击道具
---@param data GiftItemData
function GiftItemTemplate:ClickGifts(data, friendDegree)
    --加入赠送道具列表
    if data == nil then
        return
    end
    --当前是已选中状态
    --如果不可堆叠 取消选中
    if self.Parameter.GiftSelecte.gameObject.activeSelf and data.Item.ItemConfig.Overlap <= 1 then
        self.Parameter.GiftSelecte.gameObject:SetActiveEx(false)
        data.count = data.count - 1
        self.isShowTips = true
        self:RemoveGifts()
        return
    end
    --是专用道具
    if self.isLongButton then
        if self.isShowTips then
            self:ShowTips(data, friendDegree)
        end
    else
        self:ShowTips(data, friendDegree)
    end
end

--显示提示
---@param itemData GiftItemData
function GiftItemTemplate:ShowTips(itemData, friendDegree)
    if itemData.Item.IsBind then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("GIFT_IS_CANNOT_TRADE"))
        self.isShowTips = false
        return
        --好友度不足提示
    elseif friendDegree > MgrMgr:GetMgr("GiftMgr").g_currentSelectFriend.friend_list.intimacy_degree then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(StringEx.Format(Common.Utils.Lang("FRIEND_DEGREE_NOT_ENOUGH"), friendDegree))
        self.isShowTips = false
        return
        --道具数量上限
    elseif itemData.count >= itemData.Item.ItemCount then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("GIFTS_IS_ENOUGH"))
        self.isShowTips = false
        return
        --本人今日赠送数量已达上限
    elseif MgrMgr:GetMgr("GiftMgr").g_giftTimesInfo.present_times[1].left_times <= MgrMgr:GetMgr("GiftMgr").g_giftCount then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("MY_GIFTS_LIMIT"))
        self.isShowTips = false
        return
        --目标今日获赠数量已达上限
    elseif MgrMgr:GetMgr("GiftMgr").g_giftTimesInfo.gift_recipient_times <= MgrMgr:GetMgr("GiftMgr").g_giftCount then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("FRIEND_GIFTS_LIMIT"))
        self.isShowTips = false
        return
    end

    itemData.count = itemData.count + 1
    if itemData.Item.ItemConfig.Overlap > 1 then
        self.Parameter.ItemCount.LabText = StringEx.Format("{0}/{1}", tostring(itemData.count), tostring(itemData.Item.ItemCount))
    end

    --显示选中跟去除按钮
    if not self.Parameter.GiftSelecte.gameObject.activeSelf then
        self.Parameter.GiftSelecte.gameObject:SetActiveEx(true)
        if itemData.Item.ItemConfig.Overlap > 1 then
            self.Parameter.RemoveBtn.gameObject:SetActiveEx(true)
            self.Parameter.RemoveBtn.Img:SetNativeSize()
        end
    end

    self:AddGifts()
end

--选中礼物
function GiftItemTemplate:AddGifts()
    local l_isHave = false
    --已经选过 更新数量
    for i = 1, #MgrMgr:GetMgr("GiftMgr").g_giftItems do
        if uint64.equals(MgrMgr:GetMgr("GiftMgr").g_giftItems[i].uid, self.data.Item.UID) then
            MgrMgr:GetMgr("GiftMgr").g_giftItems[i].count = self.data.count
            l_isHave = true
            break
        end
    end

    if not l_isHave then
        local l_item = {}
        l_item.uid = self.data.Item.UID
        l_item.itemID = self.data.Item.TID
        l_item.count = self.data.count
        table.insert(MgrMgr:GetMgr("GiftMgr").g_giftItems, l_item)
    end

    MgrMgr:GetMgr("GiftMgr").g_giftCount = MgrMgr:GetMgr("GiftMgr").g_giftCount + 1
    MgrMgr:GetMgr("GiftMgr").EventDispatcher:Dispatch(MgrMgr:GetMgr("GiftMgr").SelectGiftItem)
end

--取消礼物
function GiftItemTemplate:RemoveGifts()
    for i = #MgrMgr:GetMgr("GiftMgr").g_giftItems, 1, -1 do
        if uint64.equals(MgrMgr:GetMgr("GiftMgr").g_giftItems[i].uid, self.data.Item.UID) then
            if self.data.count == 0 then
                table.remove(MgrMgr:GetMgr("GiftMgr").g_giftItems, i)
                self.Parameter.GiftSelecte.gameObject:SetActiveEx(false)
                self.Parameter.RemoveBtn.gameObject:SetActiveEx(false)
            else
                MgrMgr:GetMgr("GiftMgr").g_giftItems[i].count = self.data.count
            end

            break
        end
    end

    MgrMgr:GetMgr("GiftMgr").g_giftCount = MgrMgr:GetMgr("GiftMgr").g_giftCount - 1
    MgrMgr:GetMgr("GiftMgr").EventDispatcher:Dispatch(MgrMgr:GetMgr("GiftMgr").SelectGiftItem)
end
--lua custom scripts end
