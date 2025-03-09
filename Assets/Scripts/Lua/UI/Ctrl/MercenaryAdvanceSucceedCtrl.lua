--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/MercenaryAdvanceSucceedPanel"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua fields
local super = UI.UIBaseCtrl
--next--
--lua fields end

--lua class define
MercenaryAdvanceSucceedCtrl = class("MercenaryAdvanceSucceedCtrl", super)
--lua class define end

--lua functions
function MercenaryAdvanceSucceedCtrl:ctor()
	
	super.ctor(self, CtrlNames.MercenaryAdvanceSucceed, UILayer.Top, nil, ActiveType.Standalone)
	
end --func end
--next--
function MercenaryAdvanceSucceedCtrl:Init()
	
	self.panel = UI.MercenaryAdvanceSucceedPanel.Bind(self)
	super.Init(self)
	
end --func end
--next--
function MercenaryAdvanceSucceedCtrl:Uninit()
	
	super.Uninit(self)
	self.panel = nil
	
end --func end
--next--
function MercenaryAdvanceSucceedCtrl:OnActive()

    self:PlayAdvanceEffect()
end --func end
--next--
function MercenaryAdvanceSucceedCtrl:OnDeActive()

    if self.advanceEffectId then
        self:DestroyUIEffect(self.advanceEffectId)
        self.advanceEffectId = nil
    end
end --func end
--next--
function MercenaryAdvanceSucceedCtrl:Update()
	
	
end --func end





--next--
function MercenaryAdvanceSucceedCtrl:BindEvents()
	
	
end --func end

--next--
--lua functions end

--lua custom scripts

function MercenaryAdvanceSucceedCtrl:PlayAdvanceEffect()
    local l_fxData = {}
    l_fxData.rawImage = self.panel.AdvanceEffect.RawImg
    l_fxData.scaleFac = Vector3.New(1,1,1)
    l_fxData.destroyHandler = function()
        UIMgr:DeActiveUI(UI.CtrlNames.MercenaryAdvanceSucceed)
    end
    if self.advanceEffectId then
        self:DestroyUIEffect(self.advanceEffectId)
    end
    self.advanceEffectId = self:CreateUIEffect("Effects/Prefabs/Creature/Ui/Fx_Ui_YongBing_YongBingJinJie_01", l_fxData)
    
end

--lua custom scripts end
return MercenaryAdvanceSucceedCtrl