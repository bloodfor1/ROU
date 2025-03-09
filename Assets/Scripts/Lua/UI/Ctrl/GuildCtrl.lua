--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/GuildPanel"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua fields
local super = UI.UIBaseCtrl
--next--
--lua fields end

--lua class define
GuildCtrl = class("GuildCtrl", super)
--lua class define end

local l_guildMgr = nil

--lua functions
function GuildCtrl:ctor()

    super.ctor(self, CtrlNames.Guild, UILayer.Function, UITweenType.UpAlpha, ActiveType.Exclusive)

end --func end
--next--
function GuildCtrl:Init()

    self.panel = UI.GuildPanel.Bind(self)
    super.Init(self)
    l_guildMgr = MgrMgr:GetMgr("GuildMgr")
    --关闭按钮点击
    self.panel.BtnClose:AddClick(function()
        UIMgr:DeActiveUI(UI.CtrlNames.Guild)
    end)

end --func end
--next--
function GuildCtrl:Uninit()

    self.RedSignProcessorWelfare = nil
    self.RedSignProcessorMember = nil
    self.RedSignProcessorActivity = nil
    l_guildMgr = nil
    super.Uninit(self)
    self.panel = nil

end --func end

------------------------- Handler加载重写 ---------------------------------
function GuildCtrl:SetupHandlers()
    local l_handlerTb = {
        {HandlerNames.GuildInfor, Lang("INFORMATION"),"CommonIcon","UI_CommonIcon_Tab_gonghuixinxi_01.png","UI_CommonIcon_Tab_gonghuixinxi_02.png"},
        {HandlerNames.GuildMember, Lang("MEMBER"),"CommonIcon","UI_CommonIcon_Tab_gonghuichengyuan_01.png","UI_CommonIcon_Tab_gonghuichengyuan_02.png"},
        {HandlerNames.GuildWelfare, Lang("GUILD_WELFARE"),"CommonIcon","UI_CommonIcon_Tab_gonghuifuli_01.png","UI_CommonIcon_Tab_gonghuifuli_02.png"},
        {HandlerNames.GuildActivity, Lang("ACTIVITY"),"CommonIcon","UI_CommonIcon_Tab_gonghuihuodong_01.png","UI_CommonIcon_Tab_gonghuihuodong_02.png"}
    }
    self:InitHandler(l_handlerTb, self.panel.ToggleTpl)
end
-------------------------  END Handler加载重写 ---------------------------------

--next--
function GuildCtrl:OnActive()

    local redSignMgr = MgrMgr:GetMgr("RedSignMgr")
    if self.RedSignProcessorWelfare == nil then
        self.RedSignProcessorWelfare = self:NewRedSign({
            Key = eRedSignKey.GuildWelfareTog,
            RedSignParent = self:GetHandlerByName(HandlerNames.GuildWelfare).toggle.transform,
        })
    end
    if self.RedSignProcessorMember == nil then
        self.RedSignProcessorMember = self:NewRedSign({
            Key = eRedSignKey.GuildMember,
            ClickTogEx = self:GetHandlerByName(HandlerNames.GuildMember).toggle,
        })
    end
    if self.RedSignProcessorActivity == nil then
        self.RedSignProcessorActivity = self:NewRedSign({
            Key = eRedSignKey.GuildActivity,
            ClickTogEx = self:GetHandlerByName(HandlerNames.GuildActivity).toggle,
        })
    end

    if self.uiPanelData ~= nil then
        if self.uiPanelData.selectHandlerName then
            self:SelectOneHandler(self.uiPanelData.selectHandlerName)
        end
    end
    
end --func end
--next--
function GuildCtrl:OnDeActive()


end --func end
--next--
function GuildCtrl:Update()


end --func end

--next--
function GuildCtrl:BindEvents()

    if l_guildMgr == nil then
        l_guildMgr = MgrMgr:GetMgr("GuildMgr")
    end
    
    --被踢出回调
    self:BindEvent(l_guildMgr.EventDispatcher,l_guildMgr.ON_GUILD_KICKOUT,function(self)
        UIMgr:DeActiveUI(UI.CtrlNames.Guild)
    end)

    --确认无公会事件 （弱网需要）
    self:BindEvent(l_guildMgr.EventDispatcher,l_guildMgr.ON_CHECK_NO_GUILD,function(self)
        UIMgr:DeActiveUI(UI.CtrlNames.Guild)
        UIMgr:ActiveUI(UI.CtrlNames.GuildList)
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("ORIGIN_GUILD_IS_DISBAND"))
    end)

end --func end

--next--
--lua functions end

--lua custom scripts
function GuildCtrl:OnHandlerActive(handlerName)
    if handlerName == HandlerNames.GuildWelfare then
        if self.RedSignProcessorWelfare ~= nil then
            self:UninitRedSign(self.RedSignProcessorWelfare)
            self.RedSignProcessorWelfare = nil
        end
    end

    if handlerName == HandlerNames.GuildMember then
        if self.RedSignProcessorMember ~= nil then
            self:UninitRedSign(self.RedSignProcessorMember)
            self.RedSignProcessorMember = nil
        end
    end
end
--lua custom scripts end
return GuildCtrl