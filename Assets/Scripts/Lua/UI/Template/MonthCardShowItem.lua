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
local l_monthCardMgr = MgrMgr:GetMgr("MonthCardMgr")
--lua fields end

--lua class define
---@class MonthCardShowItemParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field Txt_Tips MoonClient.MLuaUICom
---@field Item_LimitedPrivilege MoonClient.MLuaUICom
---@field Item_Ios MoonClient.MLuaUICom
---@field Item_Appearance MoonClient.MLuaUICom
---@field Content MoonClient.MLuaUICom
---@field Btn_Subscribe MoonClient.MLuaUICom

---@class MonthCardShowItem : BaseUITemplate
---@field Parameter MonthCardShowItemParameter

MonthCardShowItem = class("MonthCardShowItem", super)
--lua class define end

--lua functions
function MonthCardShowItem:Init()
	super.Init(self)
	self.itemPool = self:NewTemplatePool({
        UITemplateClass = UITemplate.ItemTemplate,
	})
	--红点
	self.RedSignProcessor=self:NewRedSign({
		Key=eRedSignKey.MonthCardSmallGift,
		ClickButton=self.Parameter.Btn_FreeReward,
	})
	self.Parameter.TipsList:SetScrollRectGameObjListener(self.Parameter.ImageUp.gameObject, self.Parameter.ImageDown.gameObject, nil, nil)
end --func end
--next--
function MonthCardShowItem:BindEvents()
	self:BindEvent(l_monthCardMgr.EventDispatcher,l_monthCardMgr.ON_GET_MONTH_CARD_TEXT, function()
		self.Parameter.Txt_LimitedPrivilege.LabText = l_monthCardMgr.GetMonthCardStr()
	end)
	self.Parameter.Txt_LimitedPrivilege:GetRichText().onHrefDown:RemoveAllListeners()
	self.Parameter.Txt_LimitedPrivilege:GetRichText().onHrefDown:AddListener(function (hrefName, ed)
		local itemId = string.ro_split(hrefName,"|")
		MgrMgr:GetMgr("ItemTipsMgr").ShowTipsDisplayWithId(tonumber(itemId[2]), nil, nil, nil, false)
	end)
	self.Parameter.Txt_LimitedPrivilege:GetRichText().raycastTarget = true
	--奖励预览
	if self.data.ShowType == l_monthCardMgr.EMouthCardShowType.AwardPreview then
		self:BindEvent(MgrMgr:GetMgr("AwardPreviewMgr").EventDispatcher,l_monthCardMgr.ON_GEI_AWARD_LIMIT,function(object, ...)
			self:RefreshPreviewAwards(...)
		end)
		self:BindEvent(l_monthCardMgr.EventDispatcher,l_monthCardMgr.ON_REFRESH_AWARD_PANEL,function()
			self:SetAwardShowInfo()
		end)
		self:BindEvent(l_monthCardMgr.EventDispatcher,l_monthCardMgr.ON_GET_SMALL_GIFT,function()
			self.Parameter.Already_Get.gameObject:SetActiveEx(not l_monthCardMgr.GetIsCanGetSmallGift())
		end)
	end
	--月卡特权
	if self.data.ShowType == l_monthCardMgr.EMouthCardShowType.LimitedPrivilege then
		self:BindEvent(l_monthCardMgr.EventDispatcher,l_monthCardMgr.ON_BUY_MONTHCARD_SUCCESS,function()
			self:SetPrivilege()
		end)
	else
		--非月卡界面设置以激活
		self:BindEvent(l_monthCardMgr.EventDispatcher,l_monthCardMgr.ON_BUY_MONTHCARD_SUCCESS,function()
			self.Parameter.Txt_State.LabText = l_monthCardMgr.GetIsBuyMonthCard() and Lang("STICKER_ACTIVE_TXT") or Lang("STICKER_DEACTIVE_TXT")
		end)
	end
end --func end
--next--
function MonthCardShowItem:OnDestroy()
	self.itemPool = nil
	self:DestoryModel()
	self.RedSignProcessor = nil
end --func end
--next--
function MonthCardShowItem:OnDeActive()
	
	
end --func end
--next--
function MonthCardShowItem:OnSetData(data)
	self.data = data
	self:ShowPanel()
end --func end

function MonthCardShowItem:Update()
	if self.data.ShowType == l_monthCardMgr.EMouthCardShowType.LimitedPrivilege and
		l_monthCardMgr.GetIsBuyMonthCard() then
		self.Parameter.Txt_Surplus.LabText = l_monthCardMgr.GetMonthCardLeftTime()
	end
end
--next--
--lua functions end

--lua custom scripts
function MonthCardShowItem:ShowPanel()
	if self.data.ShowType == l_monthCardMgr.EMouthCardShowType.IosSubscribe then
		self:SetIos()
	elseif self.data.ShowType == l_monthCardMgr.EMouthCardShowType.LimitedPrivilege then
		self:SetPrivilege()
		self:ShowItemMask(l_monthCardMgr.EMouthCardShowType.LimitedPrivilege)
	elseif self.data.ShowType == l_monthCardMgr.EMouthCardShowType.AwardPreview then
		local l_rewards = l_monthCardMgr.GetAwardLimitIds()
		self.rewardDats = l_rewards
		self.curRewardNum = 1
		if table.maxn(self.rewardDats) > 0 then
			l_monthCardMgr.GetAwardLimit(self.rewardDats[self.curRewardNum].AwardID)
		end
		self:SetAwardPreview()
	end
	if self.data.changeScale~=nil then
		self:SetGameObjectScale(self.data.changeScale,self.data.changeScale,self.data.changeScale)
	end
	if self.data.showItemMaskIndex~=nil then
		self:ShowItemMask(self.data.showItemMaskIndex)
	end
	if self.data.noMask then
		self.Parameter.MaskBg1.gameObject:SetActiveEx(false)
		self.Parameter.MaskBg2.gameObject:SetActiveEx(false)
		self.Parameter.MaskBg3.gameObject:SetActiveEx(false)
	end
end

function MonthCardShowItem:ShowItemMask(index)
	self.Parameter.MaskBg1.gameObject:SetActiveEx(true)
	self.Parameter.MaskBg2.gameObject:SetActiveEx(true)
	self.Parameter.MaskBg3.gameObject:SetActiveEx(true)
	if index == l_monthCardMgr.EMouthCardShowType.IosSubscribe then
		self.Parameter.MaskBg3.gameObject:SetActiveEx(false)
	elseif index == l_monthCardMgr.EMouthCardShowType.LimitedPrivilege then
		self.Parameter.MaskBg1.gameObject:SetActiveEx(false)
	elseif index == l_monthCardMgr.EMouthCardShowType.AwardPreview then
		self.Parameter.MaskBg2.gameObject:SetActiveEx(false)
	end
end

--设置限定特权界面
function MonthCardShowItem:SetPrivilege(arg1, arg2, arg3)
	self.Parameter.Item_Ios.gameObject:SetActiveEx(false)
	self.Parameter.Item_LimitedPrivilege.gameObject:SetActiveEx(true)
	self.Parameter.Item_AwardPreview.gameObject:SetActiveEx(false)
	local l_payMentId = game:GetPayMgr():GetRealProductId("MonthCardPay")
	local l_str = ""
	if l_payMentId then
		l_str = game:GetPayMgr():GetPaymentCurrencyFormatByProductId(l_payMentId)
		self.Parameter.Text_Subscribe.LabText = l_str
	end
	self.Parameter.Btn_Subscribe:AddClick(function ()
		if MgrMgr:GetMgr("OpenSystemMgr").IsSystemOpen(MgrMgr:GetMgr("OpenSystemMgr").eSystemId.PaymentTips) then
			CommonUI.Dialog.ShowDlg(CommonUI.Dialog.DialogType.PaymentConfirm,
					true, nil,
					Common.Utils.Lang("BUY_MONTH_CARD_CONFIRM",l_str),
					Common.Utils.Lang("DLG_BTN_YES"),Common.Utils.Lang("DLG_BTN_NO"),
					function()
						l_monthCardMgr.TestBuyMonthCard()
					end)
		else
			l_monthCardMgr.TestBuyMonthCard()
		end
	end)

	self.Parameter.Txt_Surplus.gameObject:SetActiveEx(l_monthCardMgr.GetIsBuyMonthCard())
	self.Parameter.Btn_Subscribe.gameObject:SetActiveEx(not l_monthCardMgr.GetIsBuyMonthCard())
	self.Parameter.Img_Activated.gameObject:SetActiveEx(l_monthCardMgr.GetIsBuyMonthCard())
	self.Parameter.FirstChargeTips.gameObject:SetActiveEx(not l_monthCardMgr.GetIsFirstCharge())
	self.Parameter.Txt_Tips.LabText = Lang("MONTH_CARD_TIPS")
end

local l_url = "https://developer.apple.com/cn/app-store/subscriptions/"
--设置Ios
function MonthCardShowItem:SetIos(arg1, arg2, arg3)
	self.Parameter.Item_Ios.gameObject:SetActiveEx(true)
	self.Parameter.Item_LimitedPrivilege.gameObject:SetActiveEx(false)
	self.Parameter.Item_AwardPreview.gameObject:SetActiveEx(false)
	self.Parameter.item1:AddClick(function ()
		Application.OpenURL(l_url)
	end)
	self.Parameter.item2:AddClick(function ()
		Application.OpenURL(l_url)
	end)
	self.Parameter.item3:AddClick(function ()
		Application.OpenURL(l_url)
	end)
	self.Parameter.Bth_ServiceAgreement:AddClick(function ()
		Application.OpenURL(l_url)
	end)
	self.Parameter.Bth_SubscriptionClause:AddClick(function ()
		Application.OpenURL(l_url)
	end)
	self.Parameter.Bth_ResumeSubscription:AddClick(function ()
		Application.OpenURL(l_url)
	end)
	self.Parameter.Btn_IOSSubscribe:AddClick(function ()
		
	end)
end

-----------------------------------------奖励预览相关---------------------------------------

function MonthCardShowItem:SetAwardPreview(arg1, arg2, arg3)
	self.Parameter.Item_Ios.gameObject:SetActiveEx(false)
	self.Parameter.Item_LimitedPrivilege.gameObject:SetActiveEx(false)
	self.Parameter.Item_AwardPreview.gameObject:SetActiveEx(true)
	self:RefreshLeftAndRightBtn()
end

--显示奖励预览
function MonthCardShowItem:RefreshPreviewAwards(...)
	if ... == nil then
		return
	end
    local l_awardPreviewRes = ...
    local l_awardList = l_awardPreviewRes and l_awardPreviewRes.award_list
    local l_previewCount = l_awardPreviewRes.preview_count == -1 and #l_awardList or l_awardPreviewRes.preview_count
	local l_previewnum = l_awardPreviewRes.preview_num
	local l_ClothesItem = nil
	local l_itemData = {} --存储奖励的道具
    if l_awardList then
        for i = 1, #l_awardList do
            local l_itemRow = TableUtil.GetItemTable().GetRowByItemID(l_awardList[i].item_id)
			if l_itemRow then
				l_itemData[i]={
					ID = l_awardList[i].item_id,
					Count = l_awardList[i].count,
				}
				if Common.CommonUIFunc.GetItemIsOrnament(l_itemRow) then
					l_ClothesItem = l_itemRow
				end
			end
        end
	end
	self.giftTableData = self.rewardDats[self.curRewardNum]
	if self.rewardDats then
		if self.giftTableData.PackageShow == 0 then
			self.Parameter.ModelImage.gameObject:SetActiveEx(false)
			self.Parameter.ItemIcon.gameObject:SetActiveEx(true)
			self.Parameter.ItemIcon:SetSpriteAsync(self.giftTableData.GiftPackageAtlas, self.giftTableData.GiftPackageIcon,nil,true)
		else
			self.Parameter.ItemIcon.gameObject:SetActiveEx(false)
			self.Parameter.ModelImage.gameObject:SetActiveEx(true)
			if l_ClothesItem then
				self:DestoryModel()
				self.model = Common.CommonUIFunc.CreatePlayerModel({l_ClothesItem.ItemID},{l_ClothesItem},self.Parameter.ModelImage,false,true,false,false)
				self:SaveModelData(self.model)
			else
				self.Parameter.ModelImage.gameObject:SetActiveEx(false)
			end
		end
	end
	self.itemPool:ShowTemplates({Datas = l_itemData,Parent = self.Parameter.Reward.transform})
	-- 设置界面预览
	local l_cost = Common.Functions.VectorSequenceToTable(self.giftTableData.Cost)
	self.Parameter.CoinNum.LabText = tostring(l_cost[1][2])
	local l_coinItemData = TableUtil.GetItemTable().GetRowByItemID(tonumber(l_cost[1][1]))
	if l_coinItemData then
		self.Parameter.Coin:SetSpriteAsync(l_coinItemData.ItemAtlas,l_coinItemData.ItemIcon)
	end
	self.Parameter.Txt_PName.LabText = self.giftTableData.GiftPackageName
	self:SetAwardShowInfo()
	self:RefreshLeftAndRightBtn()
end

function MonthCardShowItem:SetAwardShowInfo()
	self.giftTableData = self.rewardDats[self.curRewardNum]
	--激活状态和剩余次数
	self.Parameter.Txt_State.LabText = l_monthCardMgr.GetIsBuyMonthCard() and Lang("STICKER_ACTIVE_TXT") or Lang("STICKER_DEACTIVE_TXT")
	local l_total = MgrMgr:GetMgr("LimitBuyMgr").GetLimitByKey(MgrMgr:GetMgr("LimitBuyMgr").g_limitType.MONTH_CARD, tostring(self.giftTableData.MajorID))
	local l_left,l_refreshType = self:GetCountInfo(MgrMgr:GetMgr("LimitBuyMgr").g_limitType.MONTH_CARD, tostring(self.giftTableData.MajorID))
	self.Parameter.Txt_Limited.LabText = l_left.."/"..l_total
	self.Parameter.Txt_LimitedTitle.LabText = self:GetRefreshText(l_refreshType)
	self.Parameter.Btn_Buy:AddClick(function ()
		if not l_monthCardMgr.GetIsBuyMonthCard() then
			MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("PLEASE_BUY_MONTHCARD_FIRST"))
			return
		end
		local giftPackCfg = TableUtil.GetGiftPackageTable().GetRowByMajorID(self.giftTableData.MajorID)
		local costItem = TableUtil.GetItemTable().GetRowByItemID(giftPackCfg.Cost[0][0])
		str = Common.Utils.Lang("PAY_BUY_CONFIRM",GetImageText(costItem.ItemIcon,costItem.ItemAtlas),giftPackCfg.Cost[0][1],giftPackCfg.GiftPackageName)
		if MgrMgr:GetMgr("OpenSystemMgr").IsSystemOpen(MgrMgr:GetMgr("OpenSystemMgr").eSystemId.PaymentTips) then
			CommonUI.Dialog.ShowDlg(CommonUI.Dialog.DialogType.PaymentConfirm,
					true, nil,
					str,
					Common.Utils.Lang("DLG_BTN_YES"),Common.Utils.Lang("DLG_BTN_NO"),
					function()
						l_monthCardMgr.RequestBuyQualifiedPack(self.giftTableData.MajorID)
					end)
		else
			l_monthCardMgr.RequestBuyQualifiedPack(self.giftTableData.MajorID)
		end
	end)
	self.Parameter.Btn_FreeReward:AddClick(function ()
		l_monthCardMgr.RequestPickFreeGiftPack()
	end)
	self.Parameter.Already_Get.gameObject:SetActiveEx(not l_monthCardMgr.GetIsCanGetSmallGift())
	self.Parameter.Btn_Buy.gameObject:SetActiveEx(l_left>0)
	self.Parameter.Btn_AlreadyBought.gameObject:SetActiveEx(l_left<=0)
end

--获取Count表的数值 剩余数额 如果总量5000 返回剩余的值1000 5000-1000 则为使用了4000
function MonthCardShowItem:GetCountInfo(type, key)
    if MgrMgr:GetMgr("LimitBuyMgr").g_allInfo[type] then
		if MgrMgr:GetMgr("LimitBuyMgr").g_allInfo[type][key] then
            return MgrMgr:GetMgr("LimitBuyMgr").g_allInfo[type][key].count,MgrMgr:GetMgr("LimitBuyMgr").g_allInfo[type][key].RefreshType
        else
            return 0,0
        end
    else
        return 0,0
    end
end

function MonthCardShowItem:GetRefreshText(refreshType)
	if refreshType == 2 then 
		return Lang("MONTH_CARD_LIMIT_1")
	elseif refreshType == 4 then
		return Lang("MONTH_CARD_LIMIT_2")
	elseif refreshType == 6 then
		return Lang("MONTH_CARD_LIMIT_3")
	else
		return Lang("MONTH_CARD_LIMIT_4")
	end
	return Lang("MONTH_CARD_LIMIT_4")
end

function MonthCardShowItem:DestoryModel()
	if self.model then
		self:DestroyUIModel(self.model)
		self.model = nil
	end
end

function MonthCardShowItem:RefreshLeftAndRightBtn(arg1, arg2, arg3)
	if self.curRewardNum == #self.rewardDats and  #self.rewardDats ~= 1 then
		self.Parameter.Btn_ItemLeft.gameObject:SetActiveEx(true)
		self.Parameter.Btn_ItemRight.gameObject:SetActiveEx(false)
	elseif #self.rewardDats == 1 then
		self.Parameter.Btn_ItemLeft.gameObject:SetActiveEx(false)
		self.Parameter.Btn_ItemRight.gameObject:SetActiveEx(false)
	elseif self.curRewardNum == 1 then
		self.Parameter.Btn_ItemLeft.gameObject:SetActiveEx(false)
		self.Parameter.Btn_ItemRight.gameObject:SetActiveEx(true)
	else
		self.Parameter.Btn_ItemLeft.gameObject:SetActiveEx(true)
		self.Parameter.Btn_ItemRight.gameObject:SetActiveEx(true)
	end
	self.Parameter.Btn_ItemLeft:AddClick(function ()
		self.curRewardNum = self.curRewardNum - 1
		l_monthCardMgr.GetAwardLimit(self.rewardDats[self.curRewardNum].AwardID)
	end)
	self.Parameter.Btn_ItemRight:AddClick(function ()
		self.curRewardNum = self.curRewardNum + 1
		l_monthCardMgr.GetAwardLimit(self.rewardDats[self.curRewardNum].AwardID)
    end)
end
-----------------------------------------奖励预览相关---------------------------------------

--lua custom scripts end
return MonthCardShowItem