--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/GuildDepositoryPanel"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua fields
local super = UI.UIBaseCtrl
local l_guildDepositoryMgr = nil
local l_guildData = nil
--next--
--lua fields end

--lua class define
GuildDepositoryCtrl = class("GuildDepositoryCtrl", super)
--lua class define end

--lua functions
function GuildDepositoryCtrl:ctor()
    
    super.ctor(self, CtrlNames.GuildDepository, UILayer.Function, nil, ActiveType.Exclusive)

end --func end
--next--
function GuildDepositoryCtrl:Init()
    
    self.panel = UI.GuildDepositoryPanel.Bind(self)
    super.Init(self)
    l_guildData = DataMgr:GetData("GuildData")
    l_guildDepositoryMgr = MgrMgr:GetMgr("GuildDepositoryMgr")

    --关闭按钮点击
    self.panel.BtnClose:AddClick(function()
        UIMgr:DeActiveUI(UI.CtrlNames.GuildDepository)
    end)

end --func end
--next--
function GuildDepositoryCtrl:Uninit()

    --仓库界面关闭时释放掉缓存的记录
    if l_guildData then
        l_guildData.ReleaseGuildDepositoryInfo()
    end

    super.Uninit(self)
    l_guildDepositoryMgr = nil
    l_guildData = nil
    self.panel = nil
    
end --func end

------------------------- Handler加载重写 ---------------------------------
function GuildDepositoryCtrl:SetupHandlers()
    local l_handlerTb = {
        {HandlerNames.GuildDepositoryAll, Lang("DEPOSITORY_MANAGE"), "CommonIcon", "UI_CommonIcon_BagTab_Material_01.png", "UI_CommonIcon_BagTab_Material_02.png"},
        {HandlerNames.GuildDepositorySale, Lang("SALE_LIST"), "CommonIcon", "UI_CommonIcon_Tab_paimai_01.png", "UI_CommonIcon_Tab_paimai_02.png", 
            function()
                return self:SaleToggleCheckMethod()
            end,
            function()
                return self:SaleToggleClickCheckMethod()
            end},
        {HandlerNames.GuildDepositoryRecord, Lang("SALE_RECORD"), "CommonIcon", "UI_CommonIcon_Tab_shuxing_01.png", "UI_CommonIcon_Tab_shuxing_02.png"}
    }
    self:InitHandler(l_handlerTb, self.panel.ToggleTpl)
end
-------------------------  END Handler加载重写 ---------------------------------

--next--
function GuildDepositoryCtrl:OnActive()
    
    if self.uiPanelData ~= nil then
        if self.uiPanelData.selectHandlerName then
            self:SelectOneHandler(self.uiPanelData.selectHandlerName)
        end
    end
    
end --func end
--next--
function GuildDepositoryCtrl:OnDeActive()
    
    l_guildDepositoryMgr.ReleaseTimer()
    
end --func end
--next--
function GuildDepositoryCtrl:Update()
    
    
end --func end

--next--
function GuildDepositoryCtrl:BindEvents()
    
    --被踢出回调
    self:BindEvent(MgrMgr:GetMgr("GuildMgr").EventDispatcher,MgrMgr:GetMgr("GuildMgr").ON_GUILD_KICKOUT,
    function(self)
        UIMgr:DeActiveUI(UI.CtrlNames.Guild)
        CommonUI.Dialog.CloseDlgByTopic(CommonUI.Dialog.DialogTopic.GUILD_DEPOSITORY_MGR)
        CommonUI.Dialog.CloseDlgByTopic(CommonUI.Dialog.DialogTopic.GUILD_DEPOSITORY_SALE)
    end)
    --公会仓库数据
    self:BindEvent(l_guildDepositoryMgr.EventDispatcher,l_guildDepositoryMgr.ON_GET_GUILD_DEPOSITORY_DATA,function(self)
        --刷新标签样式
        self:RefreshToggleStyle()
        --拍卖结束时还在拍卖界面跳转记录界面
        if not l_guildDepositoryMgr.IsSaling() then
            --非拍卖期间如果还在拍卖界面直接跳转记录界面
            local l_saleHandler = self:GetHandlerByName(HandlerNames.GuildDepositorySale)
            if l_saleHandler and l_saleHandler.isShowing then
                self:SelectOneHandler(HandlerNames.GuildDepositoryRecord)
                MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("GUILD_SALE_OVER"))
                --跳转时关闭所有拍卖相关对话框
                CommonUI.Dialog.CloseDlgByTopic(CommonUI.Dialog.DialogTopic.GUILD_DEPOSITORY_SALE)
            end
        end
    end)
end --func end
--next--
--lua functions end

--lua custom scripts

function GuildDepositoryCtrl:SaleToggleCheckMethod()
    --这里Mgr的获取 必去自己取 因为setHandler在 子类的init之前
    if MgrMgr:GetMgr("GuildDepositoryMgr").IsSaling() then
        return true
    end
    return false
end

function GuildDepositoryCtrl:SaleToggleClickCheckMethod()
    if l_guildDepositoryMgr.IsSaling() then
        return true
    end

    --道具不足未开启 判断由下次时间判断 正常结束是周六20点到周日22点 中间间隔时间为5天22小时 合计511200秒
    if l_guildDepositoryMgr.NextTime > 511200 then
        if #l_guildData.guildDepositoryInfo.itemList < 
            tonumber(TableUtil.GetGuildSettingTable().GetRowBySetting("AuctionMinQuantity").Value) then

            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("GUILD_SALE_NOT_ENOUGH_ITEMS"))
        else
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("GUILD_SALE_NOT_OPEN"))
        end
    else
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("GUILD_SALE_NOT_TIME"))
    end
    return false
end
--lua custom scripts end
return GuildDepositoryCtrl