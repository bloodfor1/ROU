--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/MultipleActionOfferPanel"


--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua class define
local super = UI.UIBaseCtrl
MultipleActionOfferCtrl = class("MultipleActionOfferCtrl", super)
--lua class define end

--lua functions
function MultipleActionOfferCtrl:ctor()

    super.ctor(self, CtrlNames.MultipleActionOffer, UILayer.Tips, nil, ActiveType.Standalone)

end --func end
--next--
function MultipleActionOfferCtrl:Init()

    self.panel = UI.MultipleActionOfferPanel.Bind(self)
	super.Init(self)

    self.panel.BtClose:AddClick(function()
        if self.config and self.config.cancel_callback then
            self.config.cancel_callback()
        end
        self:CloseUI()
    end, true, 0.2)

    self.panel.BtYes:AddClick(function()
        if self.config and self.config.confirm_callback then
            self.config.confirm_callback()
        end
        self:CloseUI()
    end, true, 0.2)

    self.config = nil
end --func end
--next--
function MultipleActionOfferCtrl:Uninit()
    self.config = nil

    super.Uninit(self)
    self.panel = nil

end --func end
--next--
function MultipleActionOfferCtrl:OnActive()

    self.config = MgrMgr:GetMgr("MultipleActionMgr").GetCacheConfigData()

    self:CustomRefresh()
end --func end

--next--
function MultipleActionOfferCtrl:OnDeActive()

end --func end

--next--
function MultipleActionOfferCtrl:Update()
    if not self.config or not self.panel then
        return
    end

    if self.config.finishTime == nil then
        return
    end

    local l_remain_time = self.config.finishTime - Time.realtimeSinceStartup
    if l_remain_time <= 0 then
        self:CloseUI()
    else
        self.panel.Slider.Slider.value = l_remain_time / self.config.totalTime
    end
end --func end




--next--
function MultipleActionOfferCtrl:BindEvents()

    self:BindEvent(MgrMgr:GetMgr("MultipleActionMgr").EventDispatcher,MgrMgr:GetMgr("MultipleActionMgr").ON_MULTIPLE_ACTION_EVENT,function(self, config)
        self:OnMultipleActionEvent(config)
    end)

    self:BindEvent(MgrMgr:GetMgr("MultipleActionMgr").EventDispatcher,MgrMgr:GetMgr("MultipleActionMgr").ON_REQUEST_MULTIPLE_ACTION_PUSH_EVENT,function(self, config, id)
        self:OnMultipleActionPushEvent(config)
    end)

    self:BindEvent(MgrMgr:GetMgr("MultipleActionMgr").EventDispatcher,MgrMgr:GetMgr("MultipleActionMgr").ON_MULTIPLE_ACTION_REFUSED_EVENT,function(self)
        self:CloseUI()
    end)

    self:BindEvent(MgrMgr:GetMgr("MultipleActionMgr").EventDispatcher,MgrMgr:GetMgr("MultipleActionMgr").ON_MULTIPLE_ACTION_REVOKED_EVENT,function(self, _, id)
        self:OnMultipleActionRevoked(_, id)
    end)
end --func end
--next--
--lua functions end

--lua custom scripts

function MultipleActionOfferCtrl:CloseUI()
    UIMgr:DeActiveUI(CtrlNames.MultipleActionOffer)

    MgrMgr:GetMgr("MultipleActionMgr").ClearCacheConfigData()
end

function MultipleActionOfferCtrl:SetConfig(config)

    self.config = config
end

function MultipleActionOfferCtrl:CustomRefresh()

    if not self.config then
        logError("MultipleActionOfferCtrl初始化失败")
        self:CloseUI()
        return
    end

    local l_row = TableUtil.GetShowActionTable().GetRowByID(self.config.action_id)
    if not l_row then
        logError("找不到动作id")
        self:CloseUI()
        return
    end

    local l_name, l_level

    if not self.config.member_info then
        local l_flag = false
        if self.config.target_id then
            local l_target_entity = MEntityMgr:GetEntity(self.config.target_id)
            if l_target_entity then
                l_flag = true
                l_name = l_target_entity.Name
                l_level = l_target_entity.AttrComp.Level
            end
        end

        if not l_flag then
            logError("无玩家信息")
            self:CloseUI()
            return
        end
    else
        l_name = self.config.member_info.name
        l_level = self.config.member_info.base_level
    end

    self.panel.Action:SetSprite("Pose", l_row.Icon)
    self.panel.Level.LabText = StringEx.Format("Lv.{0}", l_level)
    self.panel.TxName.LabText = Common.Utils.PlayerName(l_name)
    if self.config.content then
        self.panel.TxAsk.LabText = self.config.content
    else
        self.panel.TxAsk.LabText = Lang("MULTIPLE_ACTION_INVITE_FORMAT", l_row.Name)
    end

    if self.config.confirm_text then
        self.panel.TxComfirm.LabText = self.config.confirm_text
    else
        self.panel.TxComfirm.LabText = Lang("MULTIPLE_ACTION_CONFRIM")
    end
end

function MultipleActionOfferCtrl:OnMultipleActionEvent(config, not_close)

    if not self.panel then
        return
    end

    if self.config and self.config.cancel_callback then
        self.config.cancel_callback(not_close)
    end

    self:SetConfig(config)
    self:CustomRefresh()
end

function MultipleActionOfferCtrl:OnMultipleActionPushEvent(config)

    self:OnMultipleActionEvent(config, true)
end

function MultipleActionOfferCtrl:OnMultipleActionRevoked(_, id)

    if self.config then
        if self.config.member_info and tostring(self.config.member_info.role_uid) == tostring(id) then
            self:CloseUI()
            return
        end
    end
end

--lua custom scripts end
