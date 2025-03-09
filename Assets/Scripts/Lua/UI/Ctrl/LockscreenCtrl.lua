--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/LockscreenPanel"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua fields
local super = UI.UIBaseCtrl
--next--
--lua fields end

--lua class define
LockscreenCtrl = class("LockscreenCtrl", super)
--lua class define end

--lua functions
function LockscreenCtrl:ctor()
	
	super.ctor(self, CtrlNames.Lockscreen, UILayer.Top, nil, ActiveType.Standalone)
    self.overrideSortLayer = UILayerSort.Top - 2
    self.IsKeepShowOnAllScene=true
	
end --func end
--next--
function LockscreenCtrl:Init()
	
	self.panel = UI.LockscreenPanel.Bind(self)
	super.Init(self)

    self.settingMgr = MgrMgr:GetMgr("SettingMgr")
    self:InitPanel()
	
end --func end
--next--
function LockscreenCtrl:Uninit()
	
	super.Uninit(self)
	self.panel = nil
	
end --func end
--next--
function LockscreenCtrl:OnActive()
	
	
end --func end
--next--
function LockscreenCtrl:OnDeActive()
    self.settingMgr.ExistPowerSaving()
    if self.closeTimer then
        self:StopUITimer(self.closeTimer)
        self.closeTimer = nil
    end
end --func end
--next--
function LockscreenCtrl:Update()
	
	--更新时间
    self.panel.Txt_Time.LabText = os.date("!%H:%M",Common.TimeMgr.GetLocalNowTimestamp())
	
end --func end





--next--
function LockscreenCtrl:BindEvents()
	
	
end --func end

--next--
--lua functions end

--lua custom scripts
function LockscreenCtrl:InitPanel()
    self.panel.Img_Mask:AddClick(function()
        self.settingMgr.ExistPowerSaving()
    end)

    self.panel.Btn.Listener.beginDrag = function()

    end
    self.panel.Btn.Listener.onDrag = function(go, eventData)
        local _, l_pos = RectTransformUtility.ScreenPointToLocalPointInRectangle(self.panel.Btn.transform.parent, eventData.position, MUIManager.UICamera, nil)
        local l_x = 0
        if l_pos.x - self.panel.Btn.RectTransform.rect.width/2 < 0 then
            l_x = 0
        elseif l_pos.x > self.panel.Btn.transform.parent.rect.width - self.panel.Btn.RectTransform.rect.width/2 then
            l_x = self.panel.Btn.transform.parent.rect.width - self.panel.Btn.RectTransform.rect.width
        else
            l_x = l_pos.x - self.panel.Btn.RectTransform.rect.width/2
        end
        self.panel.Btn.RectTransform.anchoredPosition = Vector2(l_x, 0)
        if self.panel.Btn.RectTransform.anchoredPosition.x >= self.panel.Img_Lock.RectTransform.anchoredPosition.x then
            self:OnUnlock()
        end
    end
    self.panel.Btn.Listener.endDrag = function()
        self.panel.Btn.RectTransform.anchoredPosition = Vector2(0, 0)
    end
end


function LockscreenCtrl:OnUnlock()
    --加入0.1秒延迟，防止滑动过快按钮位置得不到刷新界面就已关闭
    if not self.closeTimer then
        self.closeTimer = self:NewUITimer(function()
            self.settingMgr.ExistPowerSaving()
            self.settingMgr.ExistLockScreen()
        end, 0.1)
        self.closeTimer:Start()
    end
end

function LockscreenCtrl:EnterPoweringSaving()
    self.panel.Txt_Powersaving:SetActiveEx(true)
end

function LockscreenCtrl:ExistPowerSaving()
    self.panel.Txt_Powersaving:SetActiveEx(false)
end

--lua custom scripts end
return LockscreenCtrl