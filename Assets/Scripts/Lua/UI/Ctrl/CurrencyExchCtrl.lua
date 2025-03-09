--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/CurrencyExchPanel"
require "Data/Model/PlayerInfoModel"


--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua class define
local super = UI.UIBaseCtrl
CurrencyExchCtrl = class("CurrencyExchCtrl", super)
--lua class define end

local l_quick_up_y1, l_quick_up_y2 = 73, 41
local l_quick_down_y1, l_quick_down_y2 = -148, -109
local l_normal_up_y1, l_normal_up_y2 = 39, 17
local l_normal_down_y1, l_normal_down_y2 = -164, -130

local expenditureCount
local exchangeCount
local exchangeRate
local exchangeType
--lua functions
function CurrencyExchCtrl:ctor()

    super.ctor(self, CtrlNames.CurrencyExch, UILayer.Function, UITweenType.None, ActiveType.None)
    self.overrideSortLayer = UILayerSort.Function + 3
    self.GroupMaskType = GroupMaskType.Show
    self.MaskColor = BlockColor.Dark

end --func end
--next--
function CurrencyExchCtrl:Init()

    self.panel = UI.CurrencyExchPanel.Bind(self)
    super.Init(self)

    self.m_pay_tip_show = MgrMgr:GetMgr("OpenSystemMgr").IsSystemOpen(MgrMgr:GetMgr("OpenSystemMgr").eSystemId.PaymentTips)
    -- self.m_pay_tip_show = true
    if self.m_pay_tip_show then
        local txt = Lang("Refund_Instructions_Tip")
        self.panel.PayTipContent2.LabText = txt
        self.panel.PayTipContent.LabText = txt
    end

    self.panel.ChangeNumber.InputNumber.OnValueChange = (function(value)
        expenditureCount = value
        exchangeCount = expenditureCount * exchangeRate
        self.panel.CoinText.LabText = tostring(exchangeCount)
    end)

    self.panel.ChangeNumber.InputNumber.CantChangeMethod = (function()
        local diamondInsufficient = Common.Utils.Lang("CURRENCY_DIAMONDINSUFFICIENT")
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(diamondInsufficient)
    end)

    self.panel.CloseButton:AddClick(function()
        UIMgr:DeActiveUI(UI.CtrlNames.CurrencyExch)
    end)

    self.panel.BtnChange:AddClick(function()
        local limitValue = MGlobalConfig:GetInt("ExchangePerMaxLimit")

        if expenditureCount > MLuaCommonHelper.Long(limitValue) then
            local exceedLimit = Common.Utils.Lang("CURRENCY_EXCEEDLIMIT")
            exceedLimit = StringEx.Format(exceedLimit, limitValue)
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(exceedLimit)
        elseif Data.BagModel:GetCoinOrPropNumById(GameEnum.l_virProp.Coin103) > MLuaCommonHelper.Long(0) then
            MgrMgr:GetMgr("CurrencyMgr").ExchangeMoney(exchangeType, MLuaCommonHelper.Long2Int(expenditureCount))
            UIMgr:DeActiveUI(UI.CtrlNames.CurrencyExch)
        else
            local diamondInsufficient = Common.Utils.Lang("CURRENCY_DIAMONDINSUFFICIENT")
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(diamondInsufficient)
            UIMgr:DeActiveUI(UI.CtrlNames.CurrencyExch)
        end
    end)

    self.itemAchieveTemplatePool = self:NewTemplatePool({
        TemplateClassName = "AchieveTemplate",
        TemplatePrefab = self.panel.AchieveTemplate.gameObject,
        ScrollRect = self.panel.AchieveScroll.LoopScroll,
    })

end --func end
--next--
function CurrencyExchCtrl:Uninit()

    self.panel.ChangeNumber.InputNumber.OnValueChange = nil
    self.panel.ChangeNumber.InputNumber.CantChangeMethod = nil
    self.itemAchieveTemplatePool = nil
    super.Uninit(self)
    self.panel = nil

end --func end
--next--
function CurrencyExchCtrl:OnActive()
    if Data.BagModel:GetCoinOrPropNumById(GameEnum.l_virProp.Coin103) > MLuaCommonHelper.Long(0) then
        self.panel.ChangeNumber.InputNumber.isCanChange = true
    else
        self.panel.ChangeNumber.InputNumber.isCanChange = false
    end
    local l_sysMgr = MgrMgr:GetMgr("OpenSystemMgr")
    self.itemAchieveTemplatePool:ShowTemplates({
        Datas = {
            l_sysMgr.eSystemId.MVP,
            l_sysMgr.eSystemId.Delegate,
            l_sysMgr.eSystemId.Task,
            l_sysMgr.eSystemId.Risk,
            l_sysMgr.eSystemId.LevelUp
        },
    })
end --func end

--next--
function CurrencyExchCtrl:OnDeActive()


end --func end
--next--
function CurrencyExchCtrl:Update()


end --func end


--next--
function CurrencyExchCtrl:BindEvents()

    --dont override this function
    self.panel.PayTipBtnDetail:AddClick(self.OnClickPayTipUrl)
    self.panel.PayTipBtnDetail2:AddClick(self.OnClickPayTipUrl)
end --func end

--next--
--lua functions end

--lua custom scripts
function CurrencyExchCtrl:OnClickPayTipUrl()
    Application.OpenURL(TableUtil.GetGlobalTable().GetRowByName("RefundInstructionsURL").Value)
end
function CurrencyExchCtrl:ShowCurrencyExch()

    self.panel.Obj_QuickExchange.gameObject:SetActiveEx(false)
    self.panel.Obj_RightExchange.gameObject:SetActiveEx(true)
    self.panel.PayTipRoot:SetActiveEx(self.m_pay_tip_show)
    if self.m_pay_tip_show then
        self.panel.NormalPanelUp.RectTransform.localPosition = Vector3.New(0, l_normal_up_y1, 0)
        self.panel.NormalPanelDown.RectTransform.localPosition = Vector3.New(0, l_normal_down_y1, 0)
    else
        self.panel.NormalPanelUp.RectTransform.localPosition = Vector3.New(0, l_normal_up_y2, 0)
        self.panel.NormalPanelDown.RectTransform.localPosition = Vector3.New(0, l_normal_down_y2, 0)
    end

    local getCoin = ""
    if MgrMgr:GetMgr("CurrencyMgr").CurrentCointType == MgrMgr:GetMgr("CurrencyMgr").eCurrentCointType.Coin102 then
        exchangeRate = MGlobalConfig:GetFloat("ExchangeDiamondToROMoney")
        exchangeType = MgrMgr:GetMgr("PropMgr").l_virProp.Coin102
        getCoin = Common.Utils.Lang("Currency_GetFirstCoinText")
        self.panel.CoinTitle.LabText = getCoin
        self.panel.ROImage.UObj:SetActiveEx(true)
        self.panel.ZenyImage.UObj:SetActiveEx(false)
        Common.CommonUIFunc.SetSpriteByItemId(self.panel.ShowImage, GameEnum.l_virProp.Coin102)
    else
        exchangeRate = MGlobalConfig:GetFloat("ExchangeDiamondToZeny")
        exchangeType = MgrMgr:GetMgr("PropMgr").l_virProp.Coin101
        getCoin = Common.Utils.Lang("Currency_GetSecondCoinText")
        self.panel.CoinTitle.LabText = getCoin
        self.panel.ROImage.UObj:SetActiveEx(false)
        self.panel.ZenyImage.UObj:SetActiveEx(true)
        Common.CommonUIFunc.SetSpriteByItemId(self.panel.ShowImage, GameEnum.l_virProp.Coin101)
    end

    self.panel.TextRate.LabText = exchangeRate

    local curDiamond = Data.BagModel:GetCoinOrPropNumById(GameEnum.l_virProp.Coin103)
    self.panel.DiamondText.LabText = tostring(curDiamond)

    self.panel.ChangeNumber.InputNumber.MaxValue = curDiamond

    if curDiamond == 0 then
        self.panel.ChangeNumber.InputNumber:SetValue(0)
    else
        self.panel.ChangeNumber.InputNumber:SetValue(1)
    end

    expenditureCount = self.panel.ChangeNumber.InputNumber:GetValue()
    exchangeCount = expenditureCount * exchangeRate

    self.panel.DiamondText.LabText = tostring(curDiamond)
    self.panel.CoinText.LabText = tostring(exchangeCount)
end

function CurrencyExchCtrl:ShowQuickExchange(needCoinId, needCoinNum, onSuccessFun)
    self.panel.Obj_QuickExchange.UObj:SetActiveEx(true)
    self.panel.Obj_RightExchange.UObj:SetActiveEx(false)
    self.panel.PayTipRoot2:SetActiveEx(self.m_pay_tip_show)
    if self.m_pay_tip_show then
        self.panel.QuickPanelUp.RectTransform.localPosition = Vector3.New(0, l_quick_up_y1, 0)
        self.panel.QuickPanelDown.RectTransform.localPosition = Vector3.New(0, l_quick_down_y1, 0)
    else
        self.panel.QuickPanelUp.RectTransform.localPosition = Vector3.New(0, l_quick_up_y2, 0)
        self.panel.QuickPanelDown.RectTransform.localPosition = Vector3.New(0, l_quick_down_y2, 0)
    end

    if needCoinId == nil or needCoinNum == nil then
        logError("检查传入参数")
        return
    end
    if needCoinId == GameEnum.l_virProp.Coin102 then
        exchangeRate = MGlobalConfig:GetFloat("ExchangeDiamondToROMoney")
        Common.CommonUIFunc.SetSpriteByItemId(self.panel.ShowImage, GameEnum.l_virProp.Coin102)
    elseif needCoinId == GameEnum.l_virProp.Coin101 then
        exchangeRate = MGlobalConfig:GetFloat("ExchangeDiamondToZeny")
        Common.CommonUIFunc.SetSpriteByItemId(self.panel.ShowImage, GameEnum.l_virProp.Coin101)
    else
        logError("兑换只支持101和102，详询@马鑫")
        UIMgr:DeActiveUI(UI.CtrlNames.CurrencyExch)
    end

    self.panel.TextRate.LabText = exchangeRate

    local l_itemDataCoin = TableUtil.GetItemTable().GetRowByItemID(needCoinId) --需要兑换
    local l_itemDataCoin3 = TableUtil.GetItemTable().GetRowByItemID(GameEnum.l_virProp.Coin103)  --需要兑换

    self.panel.Text_01.LabText = Lang("CURRENYCY_EXCHANGE_01", l_itemDataCoin.ItemName)
    self.panel.Text_02.LabText = Lang("CURRENYCY_EXCHANGE_02", l_itemDataCoin3.ItemName)
    self.panel.Text_03.LabText = Lang("CURRENYCY_EXCHANGE_03", l_itemDataCoin.ItemName)

    local finShowNum = math.ceil(needCoinNum / exchangeRate)
    local l_showText, _ = Common.CommonUIFunc.ShowCoinStatusText(GameEnum.l_virProp.Coin103, finShowNum)

    self.panel.Text_Left.LabText = needCoinNum
    self.panel.Text_Need.LabText = l_showText
    Common.CommonUIFunc.SetSpriteByItemId(self.panel.Image_Left, needCoinId)

    local l_haveCount = Data.BagModel:GetCoinOrPropNumById(GameEnum.l_virProp.Coin103)
    if l_haveCount >= finShowNum then
        self.panel.Btn_QuickExchange:AddClick(function()
            MgrMgr:GetMgr("CurrencyMgr").ExchangeMoneyWithFunction(needCoinId, finShowNum, onSuccessFun)
            UIMgr:DeActiveUI(UI.CtrlNames.CurrencyExch)
        end)
    else
        self.panel.Btn_QuickExchange:AddClick(function()
            CommonUI.Dialog.ShowYesNoDlg(true, Lang("EXCHANGE_COIN"), Lang("EXCHANGE_COIN_TO_PAY"), function()
                local l_opened = MgrMgr:GetMgr("OpenSystemMgr").IsSystemOpen(MgrMgr:GetMgr("OpenSystemMgr").eSystemId.MallFeeding)
                if not l_opened then
                    MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("SYSTEM_DONT_OPEN"))
                    return
                end
                --投食
                UIMgr:ActiveUI(UI.CtrlNames.Mall, {
                    Tab = MgrMgr:GetMgr("MallMgr").MallTable.Pay,
                })
                UIMgr:DeActiveUI(UI.CtrlNames.CurrencyExch)
            end, nil)
        end)
    end
end

return CurrencyExchCtrl
--lua custom scripts end
