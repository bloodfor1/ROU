--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/WatchWarBGPanel"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua fields
local super = UI.UIBaseCtrl
--next--
--lua fields end

--lua class define
WatchWarBGCtrl = class("WatchWarBGCtrl", super)
--lua class define end

--lua functions
function WatchWarBGCtrl:ctor()
	
	super.ctor(self, CtrlNames.WatchWarBG, UILayer.Function, UITweenType.UpAlpha, ActiveType.Exclusive)
	
end --func end
--next--
function WatchWarBGCtrl:Init()
	
	self.panel = UI.WatchWarBGPanel.Bind(self)
	super.Init(self)
    
    self.panel.ButtonClose:AddClick(function()
        self:CloseUI()
    end)

    self.panel.WatchPVPMultipleTemplate.gameObject:SetActiveEx(false)
    self.panel.WatchProTemplate.gameObject:SetActiveEx(false)
    self.panel.WatchSingleTemplate.gameObject:SetActiveEx(false)
    self.panel.WatchPVPTemplate.gameObject:SetActiveEx(false)
    self.panel.WatchTemplate.gameObject:SetActiveEx(false)

    self.handlerTable = {}
    table.insert(self.handlerTable, {UI.HandlerNames.WatchWar, Lang("WATCHWAR")})
    table.insert(self.handlerTable, {UI.HandlerNames.WatchWarRecord, Lang("MINE")})
    self:InitHandler(self.handlerTable, self.panel.ToggleTpl, self.panel.PanelRef, UI.HandlerNames.WatchWar)
end --func end
--next--
function WatchWarBGCtrl:Uninit()
    
    self.handlerTable = {}
    
    MgrMgr:GetMgr("WatchWarMgr").ResetSelectClassifyTypeID()
    MgrMgr:GetMgr("WatchWarMgr").ClearRoomListInfo()

	super.Uninit(self)
	self.panel = nil
	
end --func end
--next--
function WatchWarBGCtrl:OnActive()
	
	
end --func end
--next--
function WatchWarBGCtrl:OnDeActive()
	
	
end --func end
--next--
function WatchWarBGCtrl:Update()
	
	
end --func end





--next--
function WatchWarBGCtrl:BindEvents()
	
	
end --func end

--next--
--lua functions end

--lua custom scripts

function WatchWarBGCtrl:CloseUI()

    UIMgr:DeActiveUI(self.name)
end

function WatchWarBGCtrl:GetCommonTemplateGO(name)

    return self.panel[name].gameObject
end

--lua custom scripts end
return WatchWarBGCtrl