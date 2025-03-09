--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/GuildConstructionPanel"

--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua class define
local super = UI.UIBaseCtrl
GuildConstructionCtrl = class("GuildConstructionCtrl", super)
--lua class define end

local l_guildData = nil
local l_guildBuildMgr = nil
local l_buildingId = 0  --升级中建筑的ID
local l_buildingLv = 0  --建筑的当前等级
local l_lastTime = 0  --剩余建设时间

--lua functions
function GuildConstructionCtrl:ctor()

    super.ctor(self, CtrlNames.GuildConstruction, UILayer.Function, nil, ActiveType.Standalone)

end --func end
--next--
function GuildConstructionCtrl:Init()

    self.panel = UI.GuildConstructionPanel.Bind(self)
    super.Init(self)

    l_guildData = DataMgr:GetData("GuildData")
    l_guildBuildMgr = MgrMgr:GetMgr("GuildBuildMgr")

    self.timer = nil --计时器

    --类型选择框
    self.panel.EffectTime01.LabText = Lang("EXPEL_MONSTER_LEFT_TIME", TableUtil.GetGuildSettingTable().GetRowBySetting("GuildUpgradingGoodsTime").Value)
    self.panel.EffectTime02.LabText = Lang("EXPEL_MONSTER_LEFT_TIME", TableUtil.GetGuildSettingTable().GetRowBySetting("GuildUpgradingDiamondTime").Value)
    --点击背景自动关闭
    self.panel.MaskBG:AddClick(function()
        UIMgr:DeActiveUI(UI.CtrlNames.GuildConstruction)
    end)
    --选项1 物资捐赠
    self.panel.BtnChoice01:AddClick(function()
        self:GoodsDonate()
    end)
    --选项2 钻石捐献
    self.panel.BtnChoice02:AddClick(function()
        self:DiamondContribute()
    end)

end --func end
--next--
function GuildConstructionCtrl:Uninit()

    if self.timer then
        self:StopUITimer(self.timer)
        self.timer = nil
    end

    l_guildBuildMgr = nil
    l_guildData = nil

    super.Uninit(self)
    self.panel = nil

end --func end
--next--
function GuildConstructionCtrl:OnActive()

    if self.uiPanelData then
        if self.uiPanelData.type == l_guildData.EUIOpenType.GuildConstruction then
            local l_buildInfo = self.uiPanelData.buildInfo
            self:SetIdAndLastTime(l_buildInfo.id, l_buildInfo.upgrade_left_time, l_buildInfo.level)
        end
    end

    self.timer = self:NewUITimer(function()
        if self.panel then
            self.panel.TimeCount.LabText = l_guildBuildMgr.GetBuildLastTimeStr(l_lastTime)
            l_lastTime = l_lastTime - 1
            if l_lastTime <= 0 then
                --倒计时结束自动关闭该界面
                UIMgr:DeActiveUI(UI.CtrlNames.GuildConstruction)
            end
        else
            if self.timer then
                self:StopUITimer(self.timer)
                self.timer = nil
            end
        end
    end, 1, -1, true)
    self.timer:Start()

end --func end
--next--
function GuildConstructionCtrl:OnDeActive()


end --func end
--next--
function GuildConstructionCtrl:Update()


end --func end

--next--
function GuildConstructionCtrl:BindEvents()
    --获取新的公会建筑信息事件
    self:BindEvent(l_guildBuildMgr.EventDispatcher, l_guildBuildMgr.ON_GUILD_BUILD_UPGRADING_OVER, function(self)
        UIMgr:DeActiveUI(UI.CtrlNames.GuildConstruction)
        UIMgr:DeActiveUI(UI.CtrlNames.ComsumeDialog)
        UIMgr:DeActiveUI(UI.CtrlNames.ConsumeChooseDialog)
        UIMgr:DeActiveUI(UI.CtrlNames.CostCheckDialog)
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("GUILD_BUILDING_BUILD_OVER"))
    end)

    --被踢出回调
    self:BindEvent(MgrMgr:GetMgr("GuildMgr").EventDispatcher, MgrMgr:GetMgr("GuildMgr").ON_GUILD_KICKOUT, function(self)
        UIMgr:DeActiveUI(UI.CtrlNames.GuildConstruction)
    end)
end --func end
--next--
--lua functions end

--lua custom scripts

--剩余建设时间
function GuildConstructionCtrl:SetIdAndLastTime(buildingId, lastTime, buildingLv)
    l_buildingId = buildingId
    l_buildingLv = buildingLv
    l_lastTime = lastTime
    self.panel.TimeCount.LabText = l_guildBuildMgr.GetBuildLastTimeStr(l_lastTime)
end

--物资捐赠
function GuildConstructionCtrl:GoodsDonate()
    --提示文本
    local l_tip = StringEx.Format(Lang("GUILD_COMPLETE_DONATE_SPEED_UP"), TableUtil.GetGuildSettingTable().GetRowBySetting("GuildUpgradingGoodsTime").Value)
    --所需物品数据
    local l_consumeDatas = {}
    local l_costGoodsStr = TableUtil.GetGuildSettingTable().GetRowBySetting("GuildUpgradingGoodsCost").Value
    local l_costGoodDetails = string.ro_split(l_costGoodsStr, "|")
    for i = 1, #l_costGoodDetails do
        local l_costGoodDetail = string.ro_split(l_costGoodDetails[i], "=")
        local l_consumeData = {}
        l_consumeData.ID = tonumber(l_costGoodDetail[1])
        l_consumeData.IsShowCount = false
        l_consumeData.IsShowRequire = true
        l_consumeData.RequireCount = tonumber(l_costGoodDetail[2])
        table.insert(l_consumeDatas, l_consumeData)
    end
    --捐赠界面打开
    CommonUI.Dialog.ShowConsumeDlg(Lang("GUILD_CONTRIBUTE"), l_tip, function()
        --确认是否已完成
        if self:CheckBuildingIsOver() then
            UIMgr:DeActiveUI(UI.CtrlNames.GuildConstruction)
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("GUILD_BUILDING_BUILD_OVER"))
            return
        end
        --判断所需物资是否足够
        for i = 1, #l_consumeDatas do
            local l_consumeData = l_consumeDatas[i]
            if Data.BagModel:GetBagItemCountByTid(l_consumeData.ID) < l_consumeData.RequireCount then
                local l_costItemInfo = TableUtil.GetItemTable().GetRowByItemID(l_consumeData.ID)
                MgrMgr:GetMgr("TipsMgr").ShowNormalTips(StringEx.Format(Lang("MATERIAL_NOT_ENOUGH"), l_costItemInfo.ItemName))
                return
            end
        end
        --请求物资捐赠
        l_guildBuildMgr.ReqMaterialDonate(l_buildingId)
    end, nil, l_consumeDatas, nil, nil, nil, CommonUI.Dialog.DialogTopic.GUILD)
end

--钻石捐献
function GuildConstructionCtrl:DiamondContribute()

    --表数据读取
    local l_diamondCostGroup = string.ro_split(TableUtil.GetGuildSettingTable().GetRowBySetting("GuildUpgradingDiamondCost").Value, "=")
    local l_diamondInfo = TableUtil.GetItemTable().GetRowByItemID(tonumber(l_diamondCostGroup[1]))
    local l_timeAddStr = TableUtil.GetGuildSettingTable().GetRowBySetting("GuildUpgradingDiamondTime").Value
    --钻石图标拼写
    local l_diamondIconStr = StringEx.Format(Common.Utils.Lang("RICH_IMAGE"), l_diamondInfo.ItemIcon, l_diamondInfo.ItemAtlas, 20, 1)
    --消耗量字符串拼接
    local l_diamondCostStr = MNumberFormat.GetNumberFormat(l_diamondCostGroup[2]) .. " " .. l_diamondIconStr
    --拥有量字符串拼接
    local l_totalHave = tostring(Data.BagModel:GetCoinOrPropNumById(tonumber(l_diamondCostGroup[1]))) .. " " .. l_diamondIconStr
    --完整字符串获取
    local l_costText = Lang("GUILD_DIAMOND_CONTRIBUTE_CHECK", l_diamondCostStr, MNumberFormat.GetNumberFormat(l_timeAddStr))
    local l_haveText = Lang("CURRENT_HAVE", l_totalHave)

    CommonUI.Dialog.ShowCostCheckDlg(true, Lang("GUILD_CONTRIBUTE"), l_costText, l_haveText, function()
        --确认是否已完成
        if self:CheckBuildingIsOver() then
            UIMgr:DeActiveUI(UI.CtrlNames.GuildConstruction)
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("GUILD_BUILDING_BUILD_OVER"))
            return
        end

        --判断钻石数量是否足够
        if Data.BagModel:GetCoinOrPropNumById(tonumber(l_diamondCostGroup[1])) < l_diamondCostGroup[2] then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(StringEx.Format(Lang("MATERIAL_NOT_ENOUGH"), l_diamondInfo.ItemName))
            return
        end

        --请求钻石捐献
        l_guildBuildMgr.ReqDiamondContribute(l_buildingId)
    end, nil, nil, CommonUI.Dialog.DialogTopic.GUILD)
end

--确认公会建筑建设是否还未完成
function GuildConstructionCtrl:CheckBuildingIsOver()

    --小概率异常 返回已完成
    if not l_guildBuildMgr or not l_guildData.guildBuildInfo then
        return true
    end

    --找到正在升级的建筑
    local l_buildInfo = nil
    for i = 1, #l_guildData.guildBuildInfo do
        if l_guildData.guildBuildInfo[i].is_upgrading then
            l_buildInfo = l_guildData.guildBuildInfo[i]
            break
        end
    end
    --如果有正在升级的建筑 判断正在升级的建筑Id和等级 是否与目标的一致
    if l_buildInfo and l_buildInfo.id == l_buildingId and l_buildInfo.level == l_buildingLv then
        return false
    else
        return true
    end
end

--lua custom scripts end
