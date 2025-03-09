--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/PollyPanel"
--lua requires end

--lua model
module("UI", package.seeall)

--lua model end

--lua fields
local super = UI.UIBaseCtrl
--lua fields end

--lua class define
PollyCtrl = class("PollyCtrl", super)
--lua class define end

--lua functions
function PollyCtrl:ctor()
    
    super.ctor(self, CtrlNames.Polly, UILayer.Function, nil, ActiveType.Exclusive)
    
end --func end
--next--
function PollyCtrl:Init()
    
    self.panel = UI.PollyPanel.Bind(self)
    super.Init(self)
    self.RedSignProcessorRecord = nil
    self.RedSignProcessorNote = nil
    self.RedSignParentRecord = nil
    self.RedSignParentNote = nil
end --func end

--next--
function PollyCtrl:Uninit() 
    super.Uninit(self)
    self.panel = nil
    self.RedSignParentRecord = nil
    self.RedSignParentNote = nil
end --func end
--next--
function PollyCtrl:OnActive()
    self.panel.HowToPlay:AddClick(function( ... )
        UIMgr:ActiveUI(UI.CtrlNames.Howtoplay, function(ctrl)
            ctrl:ShowPanel(MGlobalConfig:GetInt("ElfGameTips"))
        end)
    end)
    self.panel.ButtonClose:AddClick(function ( ... )
        UIMgr:DeActiveUI(UI.CtrlNames.Polly)
    end)
    if self.uiPanelData ~= nil and self.uiPanelData.RegionId ~= nil then
        self:SelectOneHandler(HandlerNames.PollyExploratoryRecord,function(handler)
            handler:SelectRegion(self.uiPanelData.RegionId)
        end)
    end

    self.RedSignParentRecord = self:GetHandlerByName(HandlerNames.PollyExploratoryRecord).toggle.transform:Find("RedSign"):GetComponent("MLuaUICom")
    if self.RedSignProcessorRecord==nil then
        self.RedSignProcessorRecord = self:NewRedSign({
            Key = eRedSignKey.PollyRecord,
            ClickButton = self.RedSignParentRecord
        })
    end
    self.RedSignParentNote = self:GetHandlerByName(HandlerNames.PollyMyNote).toggle.transform:Find("RedSign"):GetComponent("MLuaUICom")
    if self.RedSignProcessorNote==nil then
        self.RedSignProcessorNote=self:NewRedSign({
            Key = eRedSignKey.PollyNote,
            ClickButton = self.RedSignParentNote
        })
    end

    --新手指引相关 玩法说明关闭后的
    local l_beginnerGuideChecks = {"Elf1", "Elf2"}
    MgrMgr:GetMgr("BeginnerGuideMgr").CheckShowBeginnerGuide(l_beginnerGuideChecks, self:GetPanelName())
end --func end

function PollyCtrl:SetupHandlers()
    local l_handlerTb = {
        {HandlerNames.PollyExploratoryRecord,Common.Utils.Lang("POLLY_TOGGLE_TEXT_EXPLORE"),"Polly","UI_Polly_Icon_ExploratoryRecord_01.png","UI_Polly_Icon_ExploratoryRecord_01.png"},
        {HandlerNames.PollyMyNote,Common.Utils.Lang("POLLY_TOGGLE_TEXT_NOTE"),"Polly","UI_Polly_Icon_MyNote_01.png","UI_Polly_Icon_MyNote_01.png"}
    }
    self:InitHandler(l_handlerTb, self.panel.Toggle, nil, HandlerNames.PollyExploratoryRecord)

    -- if self.uiPanelData ~= nil and self.uiPanelData.RegionId ~= nil then
    --  self:InitHandler(l_handlerTb, self.panel.Toggle, nil, HandlerNames.PollyMyNote)
    --  return
    -- end
end


--next--
function PollyCtrl:OnDeActive()
        
end --func end

--next--
function PollyCtrl:BindEvents()
    
    --玩法说明界面关闭回调事件绑定
    self:BindEvent(MgrMgr:GetMgr("BeginnerGuideMgr").EventDispatcher,MgrMgr:GetMgr("BeginnerGuideMgr").HOW_TO_PLAY_PANEL_CLOSE,function(object)
        --新手指引相关 玩法说明关闭后的
        local l_beginnerGuideChecks = {"Elf2"}
        MgrMgr:GetMgr("BeginnerGuideMgr").CheckShowBeginnerGuide(l_beginnerGuideChecks, self:GetPanelName())
    end)
    
end --func end
--next--
--lua functions end

--lua custom scripts
function PollyCtrl:OnHandlerSwitch(handlerName,lastHandlerName)
    if self.RedSignParentRecord == nil or self.RedSignParentNote == nil then
        return
    end
    if handlerName == HandlerNames.PollyExploratoryRecord then
        self.RedSignParentRecord:SetActiveEx(false)
        self.RedSignParentNote:SetActiveEx(true)
    end
    if handlerName == HandlerNames.PollyMyNote then
        self.RedSignParentRecord:SetActiveEx(true)
        self.RedSignParentNote:SetActiveEx(false)
    end
end

--lua custom scripts end
return PollyCtrl