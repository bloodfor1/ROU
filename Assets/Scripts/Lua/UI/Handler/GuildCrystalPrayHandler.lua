--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseHandler"
require "UI/Panel/GuildCrystalPrayPanel"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua fields
local super = UI.UIBaseHandler
--next--
--lua fields end

--lua class define
GuildCrystalPrayHandler = class("GuildCrystalPrayHandler", super)
--lua class define end

local l_guildData = nil
local l_guildCrystalMgr = nil
local l_selectCrystalInfo = nil  --当前选中的水晶信息
local l_normalCostNum = 15000  --普通消耗时消耗的Zeny
local l_contributionCostZenyNum = 3000  --贡献消耗时小号的Zeny值
local l_contributionCostContributionNum = 20   --贡献消耗时小号的贡献值
local l_assignMagnification = 3   --指定祈福的消耗倍率

--lua functions
function GuildCrystalPrayHandler:ctor()

    super.ctor(self, HandlerNames.GuildCrystalPray, 0)

end --func end
--next--
function GuildCrystalPrayHandler:Init()

    self.panel = UI.GuildCrystalPrayPanel.Bind(self)
    super.Init(self)

    l_guildData = DataMgr:GetData("GuildData")
    l_guildCrystalMgr = MgrMgr:GetMgr("GuildCrystalMgr")
    --计时器申明
    self.timerBuff = nil  --Buff剩余时间计时器
    self.timerCharge = nil  --充能剩余时间计时器
    --祈福普通消耗模式值获取
    local l_normalCostStr = TableUtil.GetGuildSettingTable().GetRowBySetting("CrystalBlessingCost").Value
    local l_normalCostStrGroup = string.ro_split(l_normalCostStr, "=")
    l_normalCostNum = tonumber(l_normalCostStrGroup[2])
    --祈福公会贡献消耗模式值获取
    local l_contributionCostStr = TableUtil.GetGuildSettingTable().GetRowBySetting("CrystalBlessingContributionCost").Value
    local l_contributionCostStrGroup = string.ro_split(l_contributionCostStr, "|")
    local l_contributionCostZenyGroup = string.ro_split(l_contributionCostStrGroup[1], "=")
    local l_contributionCostContributionGroup = string.ro_split(l_contributionCostStrGroup[2], "=")
    l_contributionCostZenyNum = l_contributionCostZenyGroup[2]
    l_contributionCostContributionNum = l_contributionCostContributionGroup[2]
    --指定祈福的消耗倍率获取
    l_assignMagnification = tonumber(TableUtil.GetGuildSettingTable().GetRowBySetting("CrystalSpecifiedBlessingCost").Value)
    --初始内容展示
    l_selectCrystalInfo = nil
    self:ShowPrayContent()
    self:InitPrayBuffContent()
    self:ShowPrayCostContent()
    self:ShowCurrencyContent()
    self:InitChargeContent()
    self.panel.BtnPrayText.LabText = Lang("RANDOM_PRAY")
    --按钮事件绑定
    self:ButtonEventBind()
    --祈福消耗类型勾选框内容变化事件
    self.panel.TogCostType:OnToggleChanged(function()
        l_guildCrystalMgr.guildCrystalPrayCostType = self.panel.TogCostType.Tog.isOn and 1 or 0
        self:ShowPrayCostContent()
    end)
    
end --func end
--next--
function GuildCrystalPrayHandler:Uninit()

    l_selectCrystalInfo = nil
    l_guildCrystalMgr = nil
    l_guildData = nil

    super.Uninit(self)
    self.panel = nil

end --func end
--next--
function GuildCrystalPrayHandler:OnActive()

    --祈福按钮防连点
    self.prayClicked = false

    --新手指引相关
    local l_beginnerGuideChecks = { "GuildCrystal" }
    MgrMgr:GetMgr("BeginnerGuideMgr").CheckShowBeginnerGuide(l_beginnerGuideChecks, self.ctrlRef:GetPanelName())

end --func end
--next--
function GuildCrystalPrayHandler:OnDeActive()

    if self.timerBuff then
        self:StopUITimer(self.timerBuff)
        self.timerBuff = nil
    end
    if self.timerCharge then
        self:StopUITimer(self.timerCharge)
        self.timerCharge = nil
    end

end --func end
--next--
function GuildCrystalPrayHandler:Update()


end --func end


--next--
function GuildCrystalPrayHandler:OnShow()

    --切换标签页事件发送
    l_guildCrystalMgr.SwitchCrystalHandler(0)
    --请求水晶信息
    l_guildCrystalMgr.ReqGetGuildCrystalInfo()
    --消耗类型的勾选框值显示
    self.panel.TogCostType.Tog.isOn = l_guildCrystalMgr.guildCrystalPrayCostType == 1
    --如果有选中的水晶则选中选中目标水晶
    if l_selectCrystalInfo then
        l_guildCrystalMgr.SelectOneCrystal(l_selectCrystalInfo.id)
    end

end --func end
--next--
function GuildCrystalPrayHandler:OnHide()


    -- 页签切换时清空选中状态
    -- l_selectCrystalInfo = nil
    -- self:ShowPrayContent()

end --func end
--next--
function GuildCrystalPrayHandler:BindEvents()

    --水晶选择事件
    self:BindEvent(l_guildCrystalMgr.EventDispatcher, l_guildCrystalMgr.ON_SELECT_CRYSTAL, function(self, crystalId)
        if l_guildCrystalMgr.curShowHandlerId == 0 then
            l_selectCrystalInfo = l_guildData.GetCrystalInfo(crystalId)
            self:ShowPrayContent()
            self:ShowPrayBuffContent()
            self:ShowPrayCostContent()
            self.panel.BtnPrayText.LabText = Lang("ASSIGN_PRAY")
        end
    end)
    --水晶祈福事件
    self:BindEvent(l_guildCrystalMgr.EventDispatcher, l_guildCrystalMgr.ON_GUILD_CRYSTAL_PARY, function(self, isSuccess)
        if isSuccess then
            --刷新BUFF属性 和 剩余的货币
            self:ShowPrayBuffContent()
            self:ShowCurrencyContent()
        end
        self.prayClicked = false
    end)
    --水晶相关信息获取事件
    self:BindEvent(l_guildCrystalMgr.EventDispatcher, l_guildCrystalMgr.ON_GET_GUILD_CRYSTAL_INFO, function(self)
        if l_guildCrystalMgr.curShowHandlerId == 0 then
            self:ShowPrayContent()
            self:ShowPrayBuffContent()
            self:ShowCurrencyContent()
            self:ShowChargeContent()
            if l_selectCrystalInfo then
                self.panel.BtnPrayText.LabText = Lang("ASSIGN_PRAY")
            else
                self.panel.BtnPrayText.LabText = Lang("RANDOM_PRAY")
            end
        end
    end)
    --断线重连事件
    self:BindEvent(MgrMgr:GetMgr("GuildMgr").EventDispatcher, MgrMgr:GetMgr("GuildMgr").ON_GUILD_RECONNECT, function(self)
        self.prayClicked = false
    end)

end --func end
--next--
--lua functions end

--lua custom scripts
--按钮事件绑定
function GuildCrystalPrayHandler:ButtonEventBind()
    --水晶指定框点击
    self.panel.CrystalIconBg:AddClick(function()
        if not l_selectCrystalInfo then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("PLEASE_SELECT_CRYSTAL_AT_LEFT_WHICH_YOU_WANT"))
        end
    end)
    --移除选中水晶按钮点击
    self.panel.BtnRemoveAssign:AddClick(function()
        l_selectCrystalInfo = nil
        self:ShowPrayContent()
        self:ShowPrayBuffContent()
        self:ShowPrayCostContent()
        self.panel.BtnPrayText.LabText = Lang("RANDOM_PRAY")
        l_guildCrystalMgr.SelectOneCrystal(0)
    end)
    --祈福帮助按钮点击
    self.panel.BtnPrayHelp:AddClick(function()
        self.panel.ExplainPanel.UObj:SetActiveEx(true)
        self.panel.ExplainText.LabText = Lang("GUILD_CRYSTAL_PRAY_HELP_TIP")
        self.panel.ExplainBubble.RectTransform.pivot = Vector2.New(1, 1)

        local l_worldPos = self.panel.BtnPrayHelp.Transform.position
        local l_viewPos = CoordinateHelper.WorldPositionToLocalPosition(l_worldPos, self.panel.ExplainPanel.Transform)
        self.panel.ExplainBubble.RectTransform.anchoredPosition = Vector2.New(l_viewPos.x - 20, l_viewPos.y + 15)
    end)
    --祈福按钮点击
    self.panel.BtnPray:AddClick(function()
        if not self.prayClicked then
            self:BtnPrayClick()
        end
    end)
    --水晶充能按钮点击
    self.panel.BtnCraystalCharge:AddClick(function()
        self:BtnCraystalChargeClick()
    end)
    --充能帮助按钮点击
    self.panel.BtnCraystalChargeHelp:AddClick(function()
        self.panel.ExplainPanel.UObj:SetActiveEx(true)
        self.panel.ExplainText.LabText = Lang("GUILD_CRYSTAL_CHARGE_HELP_TIP")
        self.panel.ExplainBubble.RectTransform.pivot = Vector2.New(0, 0)

        local l_worldPos = self.panel.BtnCraystalChargeHelp.Transform.position
        local l_viewPos = CoordinateHelper.WorldPositionToLocalPosition(l_worldPos, self.panel.ExplainPanel.Transform)
        self.panel.ExplainBubble.RectTransform.anchoredPosition = Vector2.New(l_viewPos.x + 20, l_viewPos.y - 15)
    end)
    --帮助界面关闭按钮点击
    self.panel.BtnCloseExplain:AddClick(function()
        self.panel.ExplainPanel.UObj:SetActiveEx(false)
    end)

end

--祈福方式内容展示
function GuildCrystalPrayHandler:ShowPrayContent()

    if l_selectCrystalInfo then
        --如果有选中水晶在 则 获取水晶对应参数
        local l_selectCrystalData = TableUtil.GetGuildCrystalTable().GetRowByCrystalId(l_selectCrystalInfo.id)
        --图片展示
        self.panel.CrystalIcon:SetSprite(l_selectCrystalData.CrystalIconAltas, l_selectCrystalData.CrystalIconName, true)
        self.panel.CrystalIcon.UObj:SetActiveEx(true)
        --移除按钮显示
        self.panel.BtnRemoveAssign.UObj:SetActiveEx(true)
        --指定类型名字 和 指定祈福词条
        self.panel.PrayTypeText.LabText = Lang("ASSIGN_PRAY_TYPE", Lang(l_selectCrystalData.CrystalName), l_selectCrystalInfo.level)
        self.panel.PrayTypeText.LabColor = Color.New(75 / 255.0, 108 / 255.0, 187 / 255.0)
        self.panel.CrastalSelectTip.LabText = Lang("ASSIGN_PRAY_GET_PRE_TIP", Lang(l_selectCrystalData.CrystalName))
        self.panel.CrastalSelectTip.LabColor = Color.New(102 / 255.0, 125 / 255.0, 177 / 255.0)
    else
        --如果未选中水晶
        --水晶图标图片 和 移除按钮隐藏
        self.panel.CrystalIcon.UObj:SetActiveEx(false)
        self.panel.BtnRemoveAssign.UObj:SetActiveEx(false)
        --指定类型名字 和 随机祈福词条提示
        self.panel.PrayTypeText.LabText = Lang("RANDOM_PRAY")
        self.panel.PrayTypeText.LabColor = Color.New(75 / 255.0, 108 / 255.0, 187 / 255.0)
        self.panel.CrastalSelectTip.LabText = Lang("RANDOM_PRAY_GET_PRE_TIP")
        self.panel.CrastalSelectTip.LabColor = Color.New(102 / 255.0, 125 / 255.0, 177 / 255.0)
    end

end

--祈福属性内容初始化
function GuildCrystalPrayHandler:InitPrayBuffContent()

    self.panel.BuffLastTime.UObj:SetActiveEx(false)
    self.panel.AssignFlag.UObj:SetActiveEx(false)
    for i = 1, 3 do
        self.panel.BuffPropertyBox[i].UObj:SetActiveEx(false)
    end
    
end

--祈福属性内容展示
function GuildCrystalPrayHandler:ShowPrayBuffContent()
    --初始化隐藏
    self.panel.AssignFlag.UObj:SetActiveEx(false)
    for i = 1, 3 do
        self.panel.BuffPropertyBox[i].UObj:SetActiveEx(false)
    end
    --内容刷新
    if l_guildData.guildCrystalInfo.buffLeftTime > 0 then
        --有BUFF时显示buff属性
        self.panel.BuffLastTime.UObj:SetActiveEx(true)
        --属性展示
        for i = 1, #l_guildData.guildCrystalInfo.buffAttrList do
            local l_temp = l_guildData.guildCrystalInfo.buffAttrList[i]
            --指定标记
            if i == 1 and l_temp.is_appointed then
                self.panel.AssignFlag.UObj:SetActiveEx(true)
            end
            --参数赋值
            self.panel.BuffPropertyBox[i].UObj:SetActiveEx(true)
            local l_attrRow = TableUtil.GetAttrDecision().GetRowById(l_temp.attr_type)
            if l_attrRow then
                self.panel.BuffName[i].LabText = StringEx.Format(l_attrRow.TipTemplate, "")
                local l_isPercentage = l_attrRow.TipParaEnum == 1  --是否是百分比数据
                self.panel.BuffValue[i].LabText = l_isPercentage and "+" .. tostring(l_temp.attr_value / 100) .. "%" or "+" .. tostring(l_temp.attr_value)
                if l_temp.attr_extra_value and l_temp.attr_extra_value > 0 then
                    self.panel.BuffValueEx[i].UObj:SetActiveEx(true)
                    local l_extraValueStr = l_isPercentage and "+" .. tostring(l_temp.attr_extra_value / 100) .. "%" or "+" .. tostring(l_temp.attr_extra_value)
                    self.panel.BuffValueEx[i].LabText = Lang("GUILD_CRYSTAL_CHARGE_EX_VALUE_TEXT", l_extraValueStr)
                else
                    self.panel.BuffValueEx[i].UObj:SetActiveEx(false)
                end
            end
        end
        --倒计时
        self:SetBuffTimer()
    else
        --无BUFF时 属性栏展示提示
        self.panel.BuffLastTime.UObj:SetActiveEx(false)
    end

end

--祈福消耗内容展示
function GuildCrystalPrayHandler:ShowPrayCostContent()

    local l_normalCostNumTemp = l_normalCostNum
    local l_contributionCostZenyNumTemp = l_contributionCostZenyNum
    local l_contributionCostContributionNumTemp = l_contributionCostContributionNum
    --指定祈福消耗多倍
    if l_selectCrystalInfo then
        l_normalCostNumTemp = l_normalCostNum * l_assignMagnification
        l_contributionCostZenyNumTemp = l_contributionCostZenyNum * l_assignMagnification
        l_contributionCostContributionNumTemp = l_contributionCostContributionNum * l_assignMagnification
    end

    --消耗的值显示
    if l_guildCrystalMgr.guildCrystalPrayCostType == 0 then
        --普通消耗模式
        self.panel.ContributionPrice.UObj:SetActiveEx(false)
        self.panel.ZenyPriceNum.LabText = tostring(l_normalCostNumTemp)
    else
        --公会贡献消耗模式
        self.panel.ContributionPrice.UObj:SetActiveEx(true)
        self.panel.ZenyPriceNum.LabText = tostring(l_contributionCostZenyNumTemp)
        self.panel.ContributionPriceNum.LabText = tostring(l_contributionCostContributionNumTemp)
    end

end

--当前拥有的货币显示
function GuildCrystalPrayHandler:ShowCurrencyContent()
    self.panel.ZenyHaveNum.LabText = tostring(MPlayerInfo.Coin101)
    self.panel.ContributionHaveNum.LabText = tostring(MPlayerInfo.GuildContribution)
end

--水晶充能的内容初始化
function GuildCrystalPrayHandler:InitChargeContent()
    
    self.panel.BtnCraystalCharge.UObj:SetActiveEx(false)
    self.panel.ChargeBuffText.UObj:SetActiveEx(false)

end

--水晶充能的内容展示
function GuildCrystalPrayHandler:ShowChargeContent()

    self.panel.BtnCraystalCharge.UObj:SetActiveEx(true)
    if l_guildData.guildCrystalInfo.chargeLeftTime > 0 then
        self.panel.ChargeBuffText.UObj:SetActiveEx(true)
        self.panel.BtnCraystalChargeText.LabText = Lang("REFRESH_CRYSTAL_CHARGE")
        --倒计时
        self:SetChargeTimer()
    else
        self.panel.ChargeBuffText.UObj:SetActiveEx(false)
        self.panel.BtnCraystalChargeText.LabText = Lang("CRYSTAL_CHARGE")
    end

end

--祈福按钮点击事件
function GuildCrystalPrayHandler:BtnPrayClick()
    local l_normalCostNumTemp = l_normalCostNum
    local l_contributionCostZenyNumTemp = l_contributionCostZenyNum
    local l_contributionCostContributionNumTemp = l_contributionCostContributionNum
    --指定祈福消耗多倍
    if l_selectCrystalInfo then
        l_normalCostNumTemp = l_normalCostNum * l_assignMagnification
        l_contributionCostZenyNumTemp = l_contributionCostZenyNum * l_assignMagnification
        l_contributionCostContributionNumTemp = l_contributionCostContributionNum * l_assignMagnification
    end

    if l_guildCrystalMgr.guildCrystalPrayCostType == 0 then
        --判断zeny够不够
        if MPlayerInfo.Coin101 < MLuaCommonHelper.Long(l_normalCostNumTemp) then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("NOT_ENOUGH_ZENY"))
            MgrMgr:GetMgr("ItemTipsMgr").ShowTipsDisplayWithId(101, nil, nil, nil, true)
            return
        end

    else
        --判断zeny够不够
        if MPlayerInfo.Coin101 < MLuaCommonHelper.Long(l_contributionCostZenyNumTemp) then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("NOT_ENOUGH_ZENY"))
            MgrMgr:GetMgr("ItemTipsMgr").ShowTipsDisplayWithId(101, nil, nil, nil, true)
            return
        end

        --判断公会贡献够不够
        if MPlayerInfo.GuildContribution < MLuaCommonHelper.Long(l_contributionCostContributionNumTemp) then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("GUILD_CONTRIBUTION_NOT_ENOUGH"))
            MgrMgr:GetMgr("ItemTipsMgr").ShowTipsDisplayWithId(401, nil, nil, nil, true)
            return
        end
    end

    l_guildCrystalMgr.ReqGuildCrystalPray(l_selectCrystalInfo and l_selectCrystalInfo.id or 0)
    self.prayClicked = true
end

--充能按钮点击
function GuildCrystalPrayHandler:BtnCraystalChargeClick()
    
    --钻石图标拼写
    local l_diamondItemData = TableUtil.GetItemTable().GetRowByItemID(103)
    local l_diamondIconStr = StringEx.Format(Common.Utils.Lang("RICH_IMAGE"), l_diamondItemData.ItemIcon, l_diamondItemData.ItemAtlas, 20, 1)

    --判断职位是否是理事以上
    if l_guildData.GetSelfGuildPosition() < l_guildData.EPositionType.Deacon then
        --判断是否还有免费次数
        local l_guildCrystalData = l_guildData.GetGuildBuildInfo(l_guildData.EBuildingType.Crystal)
        local l_guildCrystalLv = l_guildCrystalData and l_guildCrystalData.level or 1  --默认1级容错
        local l_chargeFreeMaxTimes = TableUtil.GetGuildUpgradingTable().GetRowById(l_guildData.EBuildingType.Crystal * 100 + l_guildCrystalLv).BlessingFreeActiveTimes
        if l_chargeFreeMaxTimes - l_guildData.guildCrystalInfo.chargeFreeTimes > 0 then
            local l_costText = Lang("GUILD_CRYSTAL_CHARGE_FREE_TIP")
            --判断是提示刷新还是充能
            if l_guildData.guildCrystalInfo.chargeLeftTime == 0 then
                l_costText = StringEx.Format(l_costText, Lang("CRYSTAL_CHARGE_TIP"))
            else
                l_costText = StringEx.Format(l_costText, Lang("REFRESH_CRYSTAL_CHARGE_TIP"))
            end
            local l_haveText = Lang("THIS_WEEK_FREE_TIMES", l_chargeFreeMaxTimes - l_guildData.guildCrystalInfo.chargeFreeTimes, l_chargeFreeMaxTimes)
            CommonUI.Dialog.ShowCostCheckDlg(true, Lang("CRYSTAL_CHARGE"), l_costText, l_haveText, function()
                l_guildCrystalMgr.ReqGuildCrystalCharge(0)  --0免费充能  1付费充能
            end, nil, nil, CommonUI.Dialog.DialogTopic.GUILD)
        else
            --理事以上 无免费次数 消耗钻石
            self:ShowCostCheckDlgForCharge(Lang("GUILD_CRYSTAL_CHARGE_FREE_OVER_TIP"), l_diamondIconStr)
        end
    else
        --非理事直接消耗钻石
        self:ShowCostCheckDlgForCharge(Lang("GUILD_CRYSTAL_CHARGE_NO_FREE_TIP"), l_diamondIconStr)
    end
end

--展示付费充能确认对话框
function GuildCrystalPrayHandler:ShowCostCheckDlgForCharge(baseText, diamondIconStr)
    --消耗量获取
    local l_diamondCost = tonumber(TableUtil.GetGuildSettingTable().GetRowBySetting("CrystalChargeCost").Value)
    --判断是提示刷新还是充能
    if l_guildData.guildCrystalInfo.chargeLeftTime == 0 then
        l_costText = StringEx.Format(baseText, diamondIconStr, l_diamondCost, Lang("CRYSTAL_CHARGE_TIP"))
    else
        l_costText = StringEx.Format(baseText, diamondIconStr, l_diamondCost, Lang("REFRESH_CRYSTAL_CHARGE_TIP"))
    end
    local l_haveText = Lang("CURRENT_HAVE", diamondIconStr .. tostring(Data.BagModel:GetCoinOrPropNumById(GameEnum.l_virProp.Coin103)))
    CommonUI.Dialog.ShowCostCheckDlg(true, Lang("CRYSTAL_CHARGE"), l_costText, l_haveText, function()
        if self:BtnCraystalChargeCostCheck() then
            l_guildCrystalMgr.ReqGuildCrystalCharge(1)  --0免费充能  1付费充能
        end
    end, nil, nil, CommonUI.Dialog.DialogTopic.GUILD, true)
end

--充能的水晶消耗确认
function GuildCrystalPrayHandler:BtnCraystalChargeCostCheck()
    --判断钻石够不够
    local l_diamondCost = tonumber(TableUtil.GetGuildSettingTable().GetRowBySetting("CrystalChargeCost").Value)
    if Data.BagModel:GetCoinOrPropNumById(GameEnum.l_virProp.Coin103) < MLuaCommonHelper.Long(l_diamondCost) then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("DIAMOND_NOT_ENOUGH"))
        MgrMgr:GetMgr("ItemTipsMgr").ShowTipsDisplayWithId(103, nil, nil, nil, true)
        return false
    end
    return true
end

--设置BUFF的倒计时
function GuildCrystalPrayHandler:SetBuffTimer()
    if not self.timerBuff and l_guildData.guildCrystalInfo.buffLeftTime > 0 then
        local l_day, l_hour, l_minuite = l_guildCrystalMgr.GetCrystalBuffTimerTime(l_guildData.guildCrystalInfo.buffLeftTime)
        self.panel.BuffLastTime.LabText = Lang("LAST_TIME_D_H_M", l_day, l_hour, l_minuite)
        self.timerBuff = self:NewUITimer(function()
            if self.panel then
                l_guildData.guildCrystalInfo.buffLeftTime = l_guildData.guildCrystalInfo.buffLeftTime - 1
                if l_guildData.guildCrystalInfo.buffLeftTime <= 0 and self.timerBuff then
                    self:StopUITimer(self.timerBuff)
                    self.timerBuff = nil
                    self.panel.BuffLastTime.UObj:SetActiveEx(false)
                    --计时时间到了之后 重新请求水晶信息获取新的经验
                    l_guildCrystalMgr.ReqGetGuildCrystalInfo()
                    return
                end
                local l_day, l_hour, l_minuite = l_guildCrystalMgr.GetCrystalBuffTimerTime(l_guildData.guildCrystalInfo.buffLeftTime)
                self.panel.BuffLastTime.LabText = Lang("LAST_TIME_D_H_M", l_day, l_hour, l_minuite)
            else
                if self.timerBuff then
                    self:StopUITimer(self.timerBuff)
                    self.timerBuff = nil
                end
            end
        end, 1, -1, true)
        self.timerBuff:Start()
    end
end

--设置充能的倒计时
function GuildCrystalPrayHandler:SetChargeTimer()
    if not self.timerCharge and l_guildData.guildCrystalInfo.chargeLeftTime > 0 then
        local l_chargeEffect = tonumber(TableUtil.GetGuildSettingTable().GetRowBySetting("CrystalChargeEffect").Value)
        local l_day, l_hour, l_minuite, l_second = Common.Functions.SecondsToDayTime(l_guildData.guildCrystalInfo.chargeLeftTime)
        self.panel.ChargeBuffText.LabText = Lang("GUILD_CRYSTAL_CHARGE_LAST_TIME_H_M", l_chargeEffect, l_minuite, l_second)
        self.timerCharge = self:NewUITimer(function()
            if self.panel then
                l_guildData.guildCrystalInfo.chargeLeftTime = l_guildData.guildCrystalInfo.chargeLeftTime - 1
                if l_guildData.guildCrystalInfo.chargeLeftTime <= 0 and self.timerCharge then
                    self:StopUITimer(self.timerCharge)
                    self.timerCharge = nil
                    self.panel.ChargeBuffText.UObj:SetActiveEx(false)
                    --计时时间到了之后 重新请求水晶信息获取新的经验
                    l_guildCrystalMgr.ReqGetGuildCrystalInfo()
                    return
                end
                local l_day, l_hour, l_minuite, l_second = Common.Functions.SecondsToDayTime(l_guildData.guildCrystalInfo.chargeLeftTime)
                self.panel.ChargeBuffText.LabText = Lang("GUILD_CRYSTAL_CHARGE_LAST_TIME_H_M", l_chargeEffect, l_minuite, l_second)
            else
                if self.timerCharge then
                    self:StopUITimer(self.timerCharge)
                    self.timerCharge = nil
                end
            end
        end, 1, -1, true)
        self.timerCharge:Start()
    end
end
--lua custom scripts end
return GuildCrystalPrayHandler