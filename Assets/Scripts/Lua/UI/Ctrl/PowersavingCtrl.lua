--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/PowersavingPanel"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua fields
local super = UI.UIBaseCtrl
--next--
--lua fields end

--lua class define
PowersavingCtrl = class("PowersavingCtrl", super)
--lua class define end

--lua functions
function PowersavingCtrl:ctor()
	
	super.ctor(self, CtrlNames.Powersaving, UILayer.Top, nil, ActiveType.Standalone)
	
end --func end
--next--
function PowersavingCtrl:Init()
	
	self.panel = UI.PowersavingPanel.Bind(self)
	super.Init(self)

    self.settingMgr = MgrMgr:GetMgr("SettingMgr")
    self:InitPanel()
	
end --func end
--next--
function PowersavingCtrl:Uninit()
	
	super.Uninit(self)
	self.panel = nil

    if self.animTimer then
        self:StopUITimer(self.animTimer)
        self.animTimer = nil
    end
	
end --func end
--next--
function PowersavingCtrl:OnActive()
	
	
end --func end
--next--
function PowersavingCtrl:OnDeActive()
    self.settingMgr.ExistPowerSaving()
	
end --func end
--next--
function PowersavingCtrl:Update()
	
	
end --func end





--next--
function PowersavingCtrl:BindEvents()
	
	
end --func end

--next--
--lua functions end

--lua custom scripts

function PowersavingCtrl:InitPanel()
    self.panel.Img_Mask:AddClick(function()
        self.settingMgr.ExistPowerSaving()
    end)
    local l_str = Lang("POWER_SAVING_MODE")
    self.animTexts = {l_str .. " .", l_str .. " ..", l_str .. " ..."}
    local l_count = 0
    self.panel.Txt_Powersaving.LabText = self.animTexts[l_count + 1]
    self.animTimer = self:NewUITimer(function()
        self.panel.Txt_Powersaving.LabText = self.animTexts[l_count + 1]
        l_count = (l_count + 1) % 3
    end, 0.7, -1, true)
    self.animTimer:Start()
end

--lua custom scripts end
return PowersavingCtrl