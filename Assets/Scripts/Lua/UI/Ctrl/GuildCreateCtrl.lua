--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/GuildCreatePanel"
require "Data/Model/BagModel"

--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua class define
local super = UI.UIBaseCtrl
GuildCreateCtrl = class("GuildCreateCtrl", super)
--lua class define end

local l_guildMgr = nil
local l_createCost = {}  --创建消耗的数据
local l_conId = 1 --公会图标编号
local l_guildNameLengthMinLimit = 2  --公会名长度最短限制
local l_guildNameLengthMaxLimit = 7  --公会名长度最长限制  中文长度算1
local l_guildNoticeLengthMaxLimit = 80  --公会公告/招募宣言最大长度限制
local l_createClicked = false  --创建按钮防连点

--lua functions
function GuildCreateCtrl:ctor()

    super.ctor(self, CtrlNames.GuildCreate, UILayer.Function, UITweenType.UpAlpha, ActiveType.Standalone)

end --func end
--next--
function GuildCreateCtrl:Init()

    self.panel = UI.GuildCreatePanel.Bind(self)
    super.Init(self)

    l_guildMgr = MgrMgr:GetMgr("GuildMgr")

    --公会名长度最短限制  中文长度算1
    l_guildNameLengthMinLimit = tonumber(TableUtil.GetGuildSettingTable().GetRowBySetting("NameLengthMinLimit").Value)
    --公会名长度最长限制  中文长度算1
    l_guildNameLengthMaxLimit = tonumber(TableUtil.GetGuildSettingTable().GetRowBySetting("NameLengthMaxLimit").Value)
    --公会公告/招募宣言最大长度限制
    l_guildNoticeLengthMaxLimit = tonumber(TableUtil.GetGuildSettingTable().GetRowBySetting("NoticeLengthMaxLimit").Value)

    --表数据获取
    local l_createCostSequence = MGlobalConfig:GetVectorSequence("CreateCost")
    l_createCost = {}
    l_createCost["priceId"] = tonumber(l_createCostSequence[0][0])
    l_createCost["price"] = l_createCostSequence[0][1]
    l_createCost["costTypeId"] = tonumber(l_createCostSequence[1][0])
    l_createCost["cost"] = tonumber(l_createCostSequence[1][1])

    local l_iconData = TableUtil.GetGuildIconTable().GetRowByGuildIconID(l_conId)
    self.panel.IconImg:SetSprite(l_iconData.GuildIconAltas, l_iconData.GuildIconName)

    --消耗物品的图标设置
    local l_row = TableUtil.GetItemTable().GetRowByItemID(l_createCost["priceId"])
    if l_row then
        self.panel.PriceIcon:SetSprite(l_row.ItemAtlas, l_row.ItemIcon)
    end
    l_row = TableUtil.GetItemTable().GetRowByItemID(l_createCost["costTypeId"])
    if l_row then
        self.panel.CostIcon:SetSprite(l_row.ItemAtlas, l_row.ItemIcon)
    end
    --消耗物品的数量与颜色设置
    local priceTxt = self.panel.PriceCount
    local costTxt = self.panel.CostCount

    priceTxt.LabText = l_createCost["price"]
    costTxt.LabText = l_createCost["cost"]

    if MPlayerInfo.Coin101 < MLuaCommonHelper.Long(l_createCost["price"]) then
        priceTxt.LabColor = Color.New(1, 0, 0)
    end

    if Data.BagModel:GetBagItemCountByTid(l_createCost["costTypeId"]) < tonumber(l_createCost["cost"]) then
        costTxt.LabColor = Color.New(1, 0, 0)
    end

    --输入框长度限制
    self.panel.NameInput.Input.characterLimit = l_guildNameLengthMaxLimit
    self.panel.WordsInput.Input.characterLimit = l_guildNoticeLengthMaxLimit
    --公会名字去除手机输入法表情 和 富文本
    self.panel.NameInput:OnInputFieldChange(function(value)
        value = StringEx.DeleteEmoji(value)
        value = StringEx.DeleteRichText(value)
        self.panel.NameInput.Input.text = value
    end)
    --招募宣言去除手机输入法表情 
    self.panel.WordsInput:OnInputFieldChange(function(value)
        value = StringEx.DeleteEmoji(value)
        self.panel.WordsInput.Input.text = value
    end)

    --关闭按钮点击
    self.panel.BtnClose:AddClick(function()
        UIMgr:DeActiveUI(UI.CtrlNames.GuildCreate)
    end)
    --公会图标点击
    self.panel.IconImg:AddClick(function()
        if not l_createClicked then
            local l_openData = {
                type = DataMgr:GetData("GuildData").EUIOpenType.GuildIconSelect,
                iconId = l_conId,
                openType = 0
            }
            UIMgr:ActiveUI(UI.CtrlNames.GuildIconSelect, l_openData)
        end
    end)
    --创建公会按钮点击
    self.panel.BtnCreate:AddClick(function()
        if not l_createClicked then
            self:BtnCreateGuildSureClick()
        end
    end)
    --消耗物品图标点击
    self.panel.BtnCost:AddClick(function()
        MgrMgr:GetMgr("ItemTipsMgr").ShowTipsDisplayWithId(l_createCost["costTypeId"])
    end)
    --Zeny物品图标点击
    self.panel.BtnZeny:AddClick(function()
        MgrMgr:GetMgr("ItemTipsMgr").ShowTipsDisplayWithId(101)
    end)

end --func end
--next--
function GuildCreateCtrl:Uninit()

    l_guildMgr = nil
    super.Uninit(self)
    self.panel = nil

end --func end
--next--
function GuildCreateCtrl:OnActive()

    l_createClicked = false

end --func end
--next--
function GuildCreateCtrl:OnDeActive()


end --func end
--next--
function GuildCreateCtrl:Update()


end --func end

--next--
function GuildCreateCtrl:BindEvents()
    --创建失败事件 重置按钮点击
    self:BindEvent(l_guildMgr.EventDispatcher, l_guildMgr.ON_GUILD_CREATE_FAILED, function(self)
        l_createClicked = false
    end)
    --断线重连事件
    self:BindEvent(l_guildMgr.EventDispatcher, l_guildMgr.ON_GUILD_RECONNECT, function(self)
        l_createClicked = false
    end)
end --func end
--next--
--lua functions end

--lua custom scripts
--创建公会面板中确定按钮点击
function GuildCreateCtrl:BtnCreateGuildSureClick()
    local l_guildName = self.panel.NameInput.Input.text
    local l_recruitWords = self.panel.WordsInput.Input.text
    local l_nameLength = string.ro_len_normalize(l_guildName)
    local l_wordsLength = string.ro_len_normalize(l_recruitWords)

    --判断是否有公会
    if l_guildMgr.IsSelfHasGuild() then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("GUILD_ALREADY_HAVE_NO_CREATE"))
        return
    end

    --判断zeny够不够
    if MPlayerInfo.Coin101 < MLuaCommonHelper.Long(l_createCost["price"]) then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("NOT_ENOUGH_ZENY"))
        MgrMgr:GetMgr("ItemTipsMgr").ShowTipsDisplayWithId(101, nil, nil, nil, true)
        return
    end

    --判断消耗材料是否足够
    if Data.BagModel:GetBagItemCountByTid(l_createCost["costTypeId"]) < tonumber(l_createCost["cost"]) then
        local l_costItemInfo = TableUtil.GetItemTable().GetRowByItemID(l_createCost["costTypeId"])
        MgrMgr:GetMgr("ItemTipsMgr").ShowTipsDisplayWithId(l_createCost["costTypeId"], nil, nil, nil, true)
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(StringEx.Format(Lang("MATERIAL_NOT_ENOUGH"), l_costItemInfo.ItemName))
        return
    end

    if l_nameLength == 0 or l_wordsLength == 0 then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("GUILD_CREATE_MESSAGE_INCOMPLETE"))
        return
    end

    if l_nameLength > l_guildNameLengthMaxLimit or l_nameLength < l_guildNameLengthMinLimit then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("GUILD_NAME_LENGTH_ERROR"))
        return
    end

    if l_wordsLength > l_guildNoticeLengthMaxLimit then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("GUILD_RECRUITWORDS_TOO_LONG"))
        return
    end

    --判断是否是全数字
    local l_numName = tonumber(l_guildName)
    if l_numName then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("GUILD_NAME_CAN_NOT_ALL_NUM"))
        return
    end

    --判断是否有非法字符
    if string.ro_isLegal(l_guildName) then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("GUILD_NAME_INPUT_ILLEGAL"))
        return
    end

    l_guildMgr.ReqCreateGuild(l_conId, l_guildName, l_recruitWords)
    l_createClicked = true
end

--设置公会图标
function GuildCreateCtrl:SetIcon(iconId)
    l_conId = iconId
    local l_iconData = TableUtil.GetGuildIconTable().GetRowByGuildIconID(l_conId)
    self.panel.IconImg:SetSprite(l_iconData.GuildIconAltas, l_iconData.GuildIconName)
end
--lua custom scripts end
