--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/CurrencyDescPanel"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua class define
local super = UI.UIBaseCtrl
CurrencyDescCtrl = class("CurrencyDescCtrl", super)
--lua class define end

--lua functions
function CurrencyDescCtrl:ctor()

	super.ctor(self, CtrlNames.CurrencyDesc, UILayer.Function, UITweenType.UpAlpha, ActiveType.Standalone)

end --func end
--next--
function CurrencyDescCtrl:Init()

	self.panel = UI.CurrencyDescPanel.Bind(self)
	super.Init(self)
    self.panel.Floor.Listener.onClick=function(obj,data)
        self.panel.Floor.gameObject:SetActiveEx(false)
        MLuaClientHelper.ExecuteClickEvents(data.position,CtrlNames.CurrencyDesc)
        self.panel.Floor.gameObject:SetActiveEx(true)
        self.panel.Floor.Listener.onClick = nil
        UIMgr:DeActiveUI(CtrlNames.CurrencyDesc)
    end
end --func end
--next--
function CurrencyDescCtrl:Uninit()

	super.Uninit(self)
	self.panel = nil

end --func end
--next--
function CurrencyDescCtrl:OnActive()


end --func end
--next--
function CurrencyDescCtrl:OnDeActive()


end --func end
--next--
function CurrencyDescCtrl:Update()


end --func end



--next--
function CurrencyDescCtrl:BindEvents()

	--dont override this function

end --func end

--next--
--lua functions end

--lua custom scripts
function CurrencyDescCtrl:SetID(id)--货币id
    if id == 402 then --声望
        self.panel.Title.LabText = Lang("CurrencyDesc_Title402")--"声望"
        self.panel.Details.LabText = Lang("CurrencyDesc_Desc402")--"受卢恩皇室认证的，冒险者们在卢恩的一种荣誉和名声，可用来激活卢恩各种勋章的等级"
    end
end
--lua custom scripts end
return CurrencyDescCtrl