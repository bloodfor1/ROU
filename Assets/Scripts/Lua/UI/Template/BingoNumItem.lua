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
---@class BingoNumItemParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field WenhaoCorner MoonClient.MLuaUICom
---@field WenhaoCant MoonClient.MLuaUICom
---@field WenhaoCan MoonClient.MLuaUICom
---@field UnlockNum MoonClient.MLuaUICom
---@field Unlock MoonClient.MLuaUICom
---@field Time MoonClient.MLuaUICom
---@field Progress MoonClient.MLuaUICom
---@field New MoonClient.MLuaUICom
---@field MoneyIcon MoonClient.MLuaUICom
---@field LockNum MoonClient.MLuaUICom
---@field Lock MoonClient.MLuaUICom
---@field LightEffect MoonClient.MLuaUICom
---@field Countdown MoonClient.MLuaUICom
---@field BackBtn MoonClient.MLuaUICom

---@class BingoNumItem : BaseUITemplate
---@field Parameter BingoNumItemParameter

BingoNumItem = class("BingoNumItem", super)
--lua class define end

--lua functions
function BingoNumItem:Init()
	
	super.Init(self)
	    self.Parameter.BackBtn:AddClick(function()
            if self.isInCd then
                MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("BINGO_GUESS_IN_CD", self.cdTime))
                return
            end
	        if self.bingoData.state == EnmBingoGridState.kBingoGridStateCanGuess then
	            UIMgr:ActiveUI(UI.CtrlNames.Bingo_NumPad, {numIndex = self.ShowIndex})
	        elseif self.bingoData.state == EnmBingoGridState.kBingoGridStateCantGuess then
                local l_openTimeStamp = MgrMgr:GetMgr("BingoMgr").GetOpenTimeStamp(self.ShowIndex)
	            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("BINGO_NUM_OPEN", Common.TimeMgr.GetDataShowTime(l_openTimeStamp)))
	        elseif self.isNew then
	            MgrMgr:GetMgr("BingoMgr").LightBingoNum(self.ShowIndex)
	        elseif self.bingoData.state == EnmBingoGridState.kBingoGridStateCost then
	            local l_cost = MGlobalConfig:GetSequenceOrVectorInt("BingoBuyNumCost")
	            local l_iconStr = MgrMgr:GetMgr("ItemMgr").GetIconRichImage(GameEnum.l_virProp.Coin103)
	            local l_msg = Lang("BINGO_NUM_COST",  MNumberFormat.GetNumberFormat(l_cost[1]), l_iconStr, self.bingoNum)
	            CommonUI.Dialog.ShowDlg(CommonUI.Dialog.DialogType.PaymentConfirm, true, nil, l_msg, Lang("DLG_BTN_YES"), Lang("DLG_BTN_NO"), function()
	                if MgrMgr:GetMgr("ItemMgr").CheckMoney(l_cost[0], l_cost[1]) then
	                    MgrMgr:GetMgr("BingoMgr").LightBingoNum(self.ShowIndex)
	                end
	            end)
	        end
	    end)
	    -- 倒计时
	    self.cdTimer = self:NewUITimer(function ()
	            self:RefreshCDTime()
	    end , 1, -1)
	    self.cdTimer:Start()
	
end --func end
--next--
function BingoNumItem:BindEvents()
    local l_bingoMgr = MgrMgr:GetMgr("BingoMgr")
    self:BindEvent(l_bingoMgr.EventDispatcher, l_bingoMgr.EventType.RefreshNum, function(_, index)
        if self.ShowIndex == index then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("BINGO_NUM_LIGHT", self.bingoNum))
            self:PlayLightEffect()
        end
    end)
    self:BindEvent(l_bingoMgr.EventDispatcher, l_bingoMgr.EventType.GuessSucceed, function(_, index)
        if self.ShowIndex == index then
            self:PlayGuessEffect()
        end
    end)
	
end --func end
--next--
function BingoNumItem:OnDestroy()

end --func end
--next--
function BingoNumItem:OnDeActive()
	
	
end --func end
--next--
function BingoNumItem:OnSetData(data)
    if not data then return end
    self.bingoData = data
    self:RefreshDetail()
end --func end
--next--
--lua functions end

--lua custom scripts
function BingoNumItem:RefreshDetail()
    if self.isPlayingEffect then return end
    local l_existItem = Data.BagModel:GetBagItemCountByTid(self.bingoData.itemId) >= 1
    self.isNew = l_existItem and self.bingoData.state == EnmBingoGridState.kBingoGridStateGray
    self.bingoNum = self.bingoData.itemId % 100
    self.Parameter.LockNum.LabText = self.bingoNum
    self.Parameter.UnlockNum.LabText = self.bingoNum
    self.Parameter.Lock:SetActiveEx(self.bingoData.state == EnmBingoGridState.kBingoGridStateGray or self.bingoData.state == EnmBingoGridState.kBingoGridStateCost)
    self.Parameter.Unlock:SetActiveEx(self.bingoData.state == EnmBingoGridState.kBingoGridStateOwn)
    self.Parameter.New:SetActiveEx(self.isNew)
    self.Parameter.MoneyIcon:SetActiveEx(self.bingoData.state == EnmBingoGridState.kBingoGridStateCost)
    if self.bingoData.state == EnmBingoGridState.kBingoGridStateCost then
        self:PlayGoldEffect()
    elseif self.effect then
        self:DestroyUIEffect(self.effect)
    end
    self.Parameter.WenhaoCan:SetActiveEx(self.bingoData.state == EnmBingoGridState.kBingoGridStateCanGuess)
    self.Parameter.WenhaoCant:SetActiveEx(self.bingoData.state == EnmBingoGridState.kBingoGridStateCantGuess)
    local l_openTimeStamp = MgrMgr:GetMgr("BingoMgr").GetOpenTimeStamp(self.ShowIndex)
    self.Parameter.WenhaoCorner:SetActiveEx(l_openTimeStamp > 0
            and self.bingoData.state ~= EnmBingoGridState.kBingoGridStateCanGuess
            and self.bingoData.state ~= EnmBingoGridState.kBingoGridStateCantGuess)
    self:RefreshCDTime()
end

function BingoNumItem:RefreshCDTime()
    local l_lastGuessTimeStamp = self.bingoData and self.bingoData.lastGuessTimeStamp or 0
    local l_cdTime = MGlobalConfig:GetInt("BingoGuessCD") - (MServerTimeMgr.UtcSeconds_u - l_lastGuessTimeStamp)
    self.isInCd = l_cdTime > 0 and self.bingoData.state == EnmBingoGridState.kBingoGridStateCanGuess
    self.cdTime = l_cdTime
    self.Parameter.Countdown:SetActiveEx(self.isInCd)
    self.Parameter.Progress.Img.fillAmount = l_cdTime / MGlobalConfig:GetInt("BingoGuessCD")
    self.Parameter.Time.LabText = l_cdTime .. "s"

    self.Parameter.WenhaoCan:SetActiveEx(self.bingoData.state == EnmBingoGridState.kBingoGridStateCanGuess and not self.isInCd)
    self.Parameter.WenhaoCant:SetActiveEx(self.bingoData.state == EnmBingoGridState.kBingoGridStateCantGuess and not self.isInCd)
end

function BingoNumItem:PlayLightEffect()
    self.isPlayingEffect = true
    local l_timer = self:NewUITimer(function()
        self.isPlayingEffect = false
        self:RefreshDetail()
    end, 0.8)
    l_timer:Start()
    local l_fxData = {}
    l_fxData.rawImage = self.Parameter.LightEffect.RawImg
    l_fxData.scaleFac = Vector3.New(1.2, 1.2, 1.2)
    if self.effect then
        self:DestroyUIEffect(self.effect)
    end
    self.effect = self:CreateUIEffect("Effects/Prefabs/Creature/Ui/Fx_UI_BingGo_DianLiang_01", l_fxData)
end

function BingoNumItem:PlayGuessEffect()
    self.isPlayingEffect = true
    self.Parameter.LockNum:SetActiveEx(false)
    local l_timer = self:NewUITimer(function()
        self.isPlayingEffect = false
        self.Parameter.LockNum:SetActiveEx(true)
        self:RefreshDetail()

        -- 需等服务器数据过来
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("BINGO_GUESS_SUCCEED", self.bingoNum))
    end, 1.3)
    l_timer:Start()
    local l_fxData = {}
    l_fxData.rawImage = self.Parameter.LightEffect.RawImg
    l_fxData.scaleFac = Vector3.New(1, 1, 1)
    if self.effect then
        self:DestroyUIEffect(self.effect)
    end
    self.effect = self:CreateUIEffect("Effects/Prefabs/Creature/Ui/Fx_UI_BingGo_ShuZi_01", l_fxData)
end

function BingoNumItem:PlayGoldEffect()
    local l_fxData = {}
    l_fxData.rawImage = self.Parameter.LightEffect.RawImg
    l_fxData.scaleFac = Vector3.New(0.8, 0.8, 0.8)
    if self.effect then
        self:DestroyUIEffect(self.effect)
    end
    self.effect = self:CreateUIEffect("Effects/Prefabs/Creature/Ui/Fx_UI_BingGo_LiuGuang_01", l_fxData)
end

--lua custom scripts end
return BingoNumItem