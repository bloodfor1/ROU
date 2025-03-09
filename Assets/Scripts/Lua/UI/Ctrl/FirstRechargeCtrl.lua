--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/FirstRechargePanel"
require "UI/Template/ItemTemplate"
--lua requires end

--lua model
module("UI", package.seeall)

--lua model end

--lua fields
local super = UI.UIBaseCtrl
--lua fields end

--lua class define
FirstRechargeCtrl = class("FirstRechargeCtrl", super)
--lua class define end

--lua functions
function FirstRechargeCtrl:ctor()
	
	super.ctor(self, CtrlNames.FirstRecharge, UILayer.Function, nil, ActiveType.Exclusive)
	
end --func end
--next--
function FirstRechargeCtrl:Init()
	
	self.panel = UI.FirstRechargePanel.Bind(self)
	super.Init(self)

    self.panel.CloseBg:AddClick(function()
        --UIMgr:DeActiveUI(UI.CtrlNames.FirstRecharge)
    end)

    self.panel.CloseBtn:AddClick(function()
        UIMgr:DeActiveUI(UI.CtrlNames.FirstRecharge)
    end)

    -- 打开
    self.panel.OpenBtn:AddClick(function()
        self:OpenCard()
    end)

    self.panel.ReceiveBtn:SetActiveEx(false)
    -- 领取
    self.panel.ReceiveBtn:AddClick(function()
        MgrMgr:GetMgr("GiftPackageMgr").BuyGiftPackage(MgrMgr:GetMgr("GiftPackageMgr").FirstRechargeAwardId)
        UIMgr:DeActiveUI(UI.CtrlNames.FirstRecharge)
    end)

    -- 前往加入
    self.panel.GotoBtn:AddClick(function()
        local l_openSystem = MgrMgr:GetMgr("OpenSystemMgr")
        if not l_openSystem.IsSystemOpen(l_openSystem.eSystemId.MallFeeding) then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("NotOpened"))
            return
        end
        UIMgr:DeActiveUI(UI.CtrlNames.FirstRecharge)
        UIMgr:ActiveUI(UI.CtrlNames.Mall, {selectHandlerName = UI.HandlerNames.MallFeeding})
    end)

    self.rewardPool = self:NewTemplatePool({
        UITemplateClass = UITemplate.ItemTemplate,
        TemplateParent = self.panel.ItemScrollContent.transform
    })

    self:NewRedSign({
        Key = eRedSignKey.FirstRechargeInner,
        ClickButton = self.panel.ReceiveBtn
    })

    -- 显示首充礼包物品信息
    local l_giftRow = TableUtil.GetGiftPackageTable().GetRowByMajorID(MgrMgr:GetMgr("GiftPackageMgr").FirstRechargeAwardId)
    if l_giftRow then
        MgrMgr:GetMgr("AwardPreviewMgr").GetPreviewRewards(l_giftRow.AwardID, "FirstRechargeAward")
    end

    local l_openSystem = MgrMgr:GetMgr("OpenSystemMgr")
    local l_paymentTipsOpen = l_openSystem.IsSystemOpen(l_openSystem.eSystemId.PaymentTips)
    if l_paymentTipsOpen then
        local paymentTips = self:NewTemplate("PaymentInstructionsTemplate",
                {
                    TemplateInstanceGo = self.panel.PaymentInstructions.gameObject,
                    TemplateParent = self.panel.PaymentInstructions.transform.parent
                }
        )
        paymentTips:SetData({})
        self.panel.PaymentInstructions.gameObject:SetActiveEx(true)
    else
        self.panel.PaymentInstructions.gameObject:SetActiveEx(false)
    end
    self:RefreshBtnState()

    -- 一段时间后自动打开
    self.openTimer = self:NewUITimer(function()
        self:OpenCard()
    end, MGlobalConfig:GetInt("FirstRechargeTime"))
    self.openTimer:Start()

end --func end
--next--
function FirstRechargeCtrl:Uninit()
	
	super.Uninit(self)
	self.panel = nil
	
end --func end
--next--
function FirstRechargeCtrl:OnActive()
	
	
end --func end
--next--
function FirstRechargeCtrl:OnDeActive()
	
	
end --func end
--next--
function FirstRechargeCtrl:Update()
	
	
end --func end
--next--
function FirstRechargeCtrl:BindEvents()

    self:BindEvent(MgrMgr:GetMgr("AwardPreviewMgr").EventDispatcher, "FirstRechargeAward",function(object, ...)
        self:RefreshAward(...)
    end)
    self:BindEvent(MgrMgr:GetMgr("LimitBuyMgr").EventDispatcher,MgrMgr:GetMgr("LimitBuyMgr").LIMIT_BUY_COUNT_UPDATE, function(_, type, id)
        self:RefreshBtnState()
    end)

end --func end
--next--
--lua functions end

--lua custom scripts

function FirstRechargeCtrl:RefreshBtnState()

    local l_giftPackageMgr = MgrMgr:GetMgr("GiftPackageMgr")
    local l_canReceive = MgrMgr:GetMgr("MonthCardMgr").GetIsFirstCharge()
    local l_count, l_limit = l_giftPackageMgr.GetLimitInfo(l_giftPackageMgr.FirstRechargeAwardId)
    local l_isReceived = l_count > 0
    self.panel.GotoBtn:SetActiveEx(not l_canReceive)
    self.panel.ReceiveBtn:SetActiveEx(l_canReceive and not l_isReceived)
    self.panel.Received:SetActiveEx(l_isReceived)

end

function FirstRechargeCtrl:RefreshAward(awardInfo, eventName, id)

    if awardInfo and eventName == "FirstRechargeAward" then
        local l_datas = MgrMgr:GetMgr("AwardPreviewMgr").HandleAwardRes(awardInfo)
        self.rewardPool:ShowTemplates({ Datas = l_datas })
    end

end

function FirstRechargeCtrl:OpenCard()

    if self.isOpen then return end
    self.isOpen = true

    self.panel.OpenBtn:SetActiveEx(false)
    self.panel.animation:GetComponent("Animator"):SetTrigger("Open")
    self.flipTimer = self:NewUITimer(function()
        self.panel.Panel_Cover.transform:SetAsFirstSibling()
    end, 0.5)
    self.flipTimer:Start()

end

--lua custom scripts end
return FirstRechargeCtrl