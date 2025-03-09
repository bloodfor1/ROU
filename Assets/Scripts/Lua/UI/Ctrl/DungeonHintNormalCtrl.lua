--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/DungeonHintNormalPanel"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua fields
local super = UI.UIBaseCtrl
--next--
--lua fields end

--lua class define
DungeonHintNormalCtrl = class("DungeonHintNormalCtrl", super)
--lua class define end

--lua functions
function DungeonHintNormalCtrl:ctor()
	
	super.ctor(self, CtrlNames.DungeonHintNormal, UILayer.Normal, nil, ActiveType.Standalone)
	
end --func end
--next--
function DungeonHintNormalCtrl:Init()
	
	self.panel = UI.DungeonHintNormalPanel.Bind(self)
	super.Init(self)
	
end --func end
--next--
function DungeonHintNormalCtrl:Uninit()
	
	super.Uninit(self)
	self.panel = nil
	
end --func end
--next--
function DungeonHintNormalCtrl:OnActive()
	
	
end --func end
--next--
function DungeonHintNormalCtrl:OnDeActive()
    if self.rightHintTimer then
        self:StopUITimer(self.rightHintTimer)
        self.rightHintTimer = nil
    end
    if self.alphaTweenId then
        MUITweenHelper.KillTween(self.alphaTweenId)
        self.alphaTweenId = nil
    end
end --func end
--next--
function DungeonHintNormalCtrl:Update()
	
	
end --func end
--next--
function DungeonHintNormalCtrl:BindEvents()
	
	
end --func end

--next--
--lua functions end

--lua custom scripts

function DungeonHintNormalCtrl:ShowDungeonHints(id, msgType, content, isClose)
    if not self.mrMgr then self.mrMgr = MgrMgr:GetMgr("MessageRouterMgr") end

    if not self:IsDungeonHintsCanShow(msgType) then return end

    local l_row = TableUtil.GetMessageTable().GetRowByID(id)
    if not l_row then return end

    self:ShowDungeonHintsRight(id, msgType, content, l_row.Duration, isClose)
end

--持续副本提示
function DungeonHintNormalCtrl:ShowDungeonHintsRight(id, msgType, content, duration, isClose)
    if not self.panel then return end

    if isClose then
        --是否关闭正在显示的面板
        if self.rightMsgId == id then
            self:ClosePanel()
        end
        return
    end
    self.rightMsgType = msgType
    self.rightMsgId = id             --保存id，用于关闭使用

    self.panel.DangerBG:SetActiveEx(msgType == self.mrMgr.EMessageRouterType.DungeonHintLastWarning)
    self.panel.HintBG:SetActiveEx(msgType == self.mrMgr.EMessageRouterType.DungeonHintLastAuxiliary)
    self.panel.Text.LabText = content

    MLuaClientHelper.PlayFxHelper(self.panel.TipsRight.gameObject)

    if self.rightHintTimer then
        self:StopUITimer(self.rightHintTimer)
        self.rightHintTimer = nil
    end

    if duration ~= -1 then
        self.rightHintTimer = self:NewUITimer(function()
            if self.rightHintTimer then
                self:StopUITimer(self.rightHintTimer)
                self.rightHintTimer = nil
            end
            self:ClosePanel()
        end, duration)
        self.rightHintTimer:Start()
    end
end

function DungeonHintNormalCtrl:ClosePanel()
    if self.panel == nil then
        return
    end
    self.rightMsgType = nil
    if self.alphaTweenId then
        MUITweenHelper.KillTween(self.alphaTweenId)
    end
    self.alphaTweenId = MUITweenHelper.TweenAlpha(self.panel.TipsRight.gameObject, 1, 0, 0.5, function()
        self.panel.TipsRight:GetComponent("CanvasGroup").alpha = 1
        UIMgr:DeActiveUI(UI.CtrlNames.DungeonHintNormal)
    end)
end

--副本提示的互斥规则
function DungeonHintNormalCtrl:IsDungeonHintsCanShow(msgType)
    return not(msgType == self.mrMgr.EMessageRouterType.DungeonHintLastAuxiliary and self.rightMsgType == self.mrMgr.EMessageRouterType.DungeonHintLastWarning)
end


--lua custom scripts end
return DungeonHintNormalCtrl