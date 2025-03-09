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
---@class CapraGiftItemParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field Txt_tagContent MoonClient.MLuaUICom
---@field Text_Name MoonClient.MLuaUICom
---@field RedPoint MoonClient.MLuaUICom
---@field PresentPriceNum MoonClient.MLuaUICom
---@field PresentCoinIcon MoonClient.MLuaUICom
---@field Panel_DynamicTag MoonClient.MLuaUICom
---@field OriginalPriceNum MoonClient.MLuaUICom
---@field OriginalCoinIcon MoonClient.MLuaUICom
---@field LimitNum MoonClient.MLuaUICom
---@field LimitBuy MoonClient.MLuaUICom
---@field GiftIcon MoonClient.MLuaUICom
---@field FreeText MoonClient.MLuaUICom
---@field BuyText MoonClient.MLuaUICom
---@field Btn_Buy MoonClient.MLuaUICom
---@field AlreadyReceive MoonClient.MLuaUICom
---@field AlreadyBuy MoonClient.MLuaUICom

---@class CapraGiftItem : BaseUITemplate
---@field Parameter CapraGiftItemParameter

CapraGiftItem = class("CapraGiftItem", super)
--lua class define end

--lua functions
function CapraGiftItem:Init()
	
	super.Init(self)
	    self.Parameter.GiftIcon:AddClick(function()
	        UIMgr:ActiveUI(UI.CtrlNames.CapraReward_Tips, {giftId = self.giftId, timeId = self.timeId})
	    end)
	    self.Parameter.Btn_Buy:AddClick(function()
	        if not self:IsOpen() then return end
	        local l_giftRow = TableUtil.GetGiftPackageTable().GetRowByMajorID(self.giftId)
	        if l_giftRow then
                local l_needCoinNum = l_giftRow.Cost[0][1]
	            local l_isFree = l_needCoinNum == 0
                local l_hasCoinNum = Data.BagModel:GetCoinNumById(l_giftRow.Cost[0][0])
	                if not l_isFree and MgrMgr:GetMgr("OpenSystemMgr").IsSystemOpen(MgrMgr:GetMgr("OpenSystemMgr").eSystemId.PaymentTips) then
	                    local l_iconStr = MgrMgr:GetMgr("ItemMgr").GetIconRichImage(l_giftRow.Cost[0][0])
	                    local l_msg = Lang("GIFT_BUY_MSG", l_iconStr, MNumberFormat.GetNumberFormat(l_giftRow.Cost[0][1]), l_giftRow.GiftPackageName)
	                    CommonUI.Dialog.ShowDlg(CommonUI.Dialog.DialogType.PaymentConfirm, true, nil, l_msg, Lang("DLG_BTN_YES"), Lang("DLG_BTN_NO"), function()
                            if l_hasCoinNum < l_needCoinNum then
                                MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("DIAMOND_NOT_ENOUGH"))
                            else
	                            MgrMgr:GetMgr("GiftPackageMgr").BuyGiftPackage(l_giftRow.MajorID, self.mainId)
	                        end
	                    end)
	                else
                        local l_hasCoinNum = Data.BagModel:GetCoinNumById(l_giftRow.Cost[0][0])
	                    if l_hasCoinNum < l_needCoinNum then
                            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("DIAMOND_NOT_ENOUGH"))
                        else
	                        MgrMgr:GetMgr("GiftPackageMgr").BuyGiftPackage(l_giftRow.MajorID, self.mainId)
	                    end
	                end
	        end
	    end)
	
end --func end
--next--
function CapraGiftItem:BindEvents()
	
	    self:BindEvent(MgrMgr:GetMgr("LimitBuyMgr").EventDispatcher,MgrMgr:GetMgr("LimitBuyMgr").LIMIT_BUY_COUNT_UPDATE, function(_, type, id)
	        id = tonumber(id)
	        if self.giftId and self.giftId == id then
	            self:RefreshDetail()
	        end
	    end)
	
end --func end
--next--
function CapraGiftItem:OnDestroy()
	
	
end --func end
--next--
function CapraGiftItem:OnDeActive()
	
	
end --func end
--next--
function CapraGiftItem:OnSetData(data)
	
	self.mainId = data.mainId
	self.giftId = data.giftId or 0
	    self.timeId = data.timeId or 0
	    self.state = data.state or 0
	self:RefreshDetail()
	
end --func end
--next--
--lua functions end

--lua custom scripts
function CapraGiftItem:RefreshDetail()
    if not self.giftId then return end
    local l_giftRow = TableUtil.GetGiftPackageTable().GetRowByMajorID(self.giftId)
    if l_giftRow then
        local l_isFree = l_giftRow.Cost[0][1] == 0
        local l_giftPackageMgr = MgrMgr:GetMgr("GiftPackageMgr")
        local l_count, l_limit = l_giftPackageMgr.GetLimitInfo(self.giftId)
        local l_isSellOut = l_count >= l_limit
        local l_isOpen = self:IsOpen()
        local l_isShowState = self.state == GameEnum.ETimeLimitState.kTLS_Show
        local l_isEnd = self.state == GameEnum.ETimeLimitState.kTLS_End
        MgrMgr:GetMgr("ItemMgr").SetItemSprite(self.Parameter.OriginalCoinIcon, l_giftRow.Value[0][0])
        MgrMgr:GetMgr("ItemMgr").SetItemSprite(self.Parameter.PresentCoinIcon, l_giftRow.Cost[0][0])
        self.Parameter.LimitNum.LabText = StringEx.Format("{0}/{1}", l_count, l_limit)
        local l_limitBuyMgr = MgrMgr:GetMgr("LimitBuyMgr")
        local l_refreshType = MgrMgr:GetMgr("LimitBuyMgr").GetRefreshTypeByKey(l_limitBuyMgr.g_limitType.GiftPackage, self.giftId)
        if l_refreshType == 0 then
            self.Parameter.LimitBuy.LabText = Lang("Activity_Buy_Limit")
        elseif l_refreshType == 1 or l_refreshType == 2 then
            self.Parameter.LimitBuy.LabText = Lang("Day_Buy_Limit")
        elseif l_refreshType == 3 or l_refreshType == 4 then
            self.Parameter.LimitBuy.LabText = Lang("Week_Buy_Limit")
        end
        self.Parameter.OriginalPriceNum.LabText = MNumberFormat.GetNumberFormat(l_giftRow.Value[0][1])
        self.Parameter.PresentPriceNum.LabText = MNumberFormat.GetNumberFormat(l_giftRow.Cost[0][1])
        self.Parameter.PresentCoinIcon:SetActiveEx(not l_isFree)
        self.Parameter.PresentPriceNum:SetActiveEx(not l_isFree)

        self.Parameter.FreeText:SetActiveEx(l_isFree)

        self.Parameter.Btn_Buy:SetActiveEx(not l_isSellOut and l_isOpen)

        self.Parameter.AlreadyBuy:SetActiveEx( not l_isFree and l_isSellOut and l_isOpen)
        self.Parameter.AlreadyReceive:SetActiveEx(l_isFree and l_isSellOut and l_isOpen)
        self.Parameter.Panel_DynamicTag:SetActiveEx(false)
        if not l_isOpen then
            local l_tagContent = nil
            if l_isShowState then
                l_tagContent = Lang("DELEGATE_EMBLEM_TEMP_WORD")
            elseif l_isEnd then
                l_tagContent = Lang("TimeOut")
            end
            local l_needShowDynamicTag = l_tagContent~=nil
            self.Parameter.Panel_DynamicTag:SetActiveEx(l_needShowDynamicTag)
            if l_needShowDynamicTag then
                self.Parameter.Txt_tagContent.LabText = l_tagContent
            end
        end

        local l_btnText = Lang("Buy")
        if l_isFree then
            l_btnText = Lang("Free_Get")
        end
        self.Parameter.RedPoint:SetActiveEx(l_isFree)
        if not l_isOpen then
            l_btnText = Lang("NotOpened")
        end
        self.Parameter.Btn_Buy:SetGray(not l_isOpen)
        self.Parameter.BuyText.LabText = l_btnText
        self.Parameter.Text_Name.LabText = l_giftRow.GiftPackageName
        self.Parameter.GiftIcon:SetSpriteAsync(l_giftRow.GiftPackageAtlas, l_giftRow.GiftPackageIcon,nil,true)
    end
end

function CapraGiftItem:IsOpen()
    return self.state == GameEnum.ETimeLimitState.kTLS_Begin
end
--lua custom scripts end
return CapraGiftItem