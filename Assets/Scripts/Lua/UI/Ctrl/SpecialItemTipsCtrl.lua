--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/SpecialItemTipsPanel"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua fields
local super = UI.UIBaseCtrl
local showTime = 1.5
--next--
--lua fields end

--lua class define
SpecialItemTipsCtrl = class("SpecialItemTipsCtrl", super)
--lua class define end

--lua functions
function SpecialItemTipsCtrl:ctor()
	
	super.ctor(self, CtrlNames.SpecialItemTips, UILayer.Function, UITweenType.UpAlpha, ActiveType.Standalone)
	
end --func end
--next--
function SpecialItemTipsCtrl:Init()
	
	self.panel = UI.SpecialItemTipsPanel.Bind(self)
	super.Init(self)
	self.panel.OBJ.gameObject:SetActiveEx(false)
	self.panel.CloseBtn:AddClick(function()
        GlobalEventBus:Dispatch(EventConst.Names.ShowNextSpecialTip)
    end)

end --func end
--next--
function SpecialItemTipsCtrl:Uninit()
	
	super.Uninit(self)
	self.panel = nil
	
end --func end
--next--
function SpecialItemTipsCtrl:OnActive()
	
	
end --func end
--next--
function SpecialItemTipsCtrl:OnDeActive()
	
	
end --func end
--next--
function SpecialItemTipsCtrl:Update()

	if self.startTime then
		if Time.realtimeSinceStartup - self.startTime > showTime then
			self.startTime = nil
			UIMgr:DeActiveUI(UI.CtrlNames.SpecialItemTips)
		end
	end
	
end --func end





--next--
function SpecialItemTipsCtrl:BindEvents()
	
	
end --func end

--next--
--lua functions end

--lua custom scripts

function SpecialItemTipsCtrl:ShowTips(atlas,icon,name,des)
	self.panel.OBJ.gameObject:SetActiveEx(true)
	self.panel.Icon:SetSprite(atlas, icon, true)
	self.panel.Name.LabText=name
	self.panel.Desc.LabText=des
	self.startTime = Time.realtimeSinceStartup
end

--lua custom scripts end
return SpecialItemTipsCtrl