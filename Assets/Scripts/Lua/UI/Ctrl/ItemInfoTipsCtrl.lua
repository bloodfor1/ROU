--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/ItemInfoTipsPanel"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua class define
local super = UI.UIBaseCtrl
ItemInfoTipsCtrl = class("ItemInfoTipsCtrl", super)
--lua class define end

--lua functions
function ItemInfoTipsCtrl:ctor()

	super.ctor(self, CtrlNames.ItemInfoTips, UILayer.Function, nil, ActiveType.Exclusive)

end --func end
--next--
function ItemInfoTipsCtrl:Init()

	self.panel = UI.ItemInfoTipsPanel.Bind(self)
	super.Init(self)

end --func end
--next--
function ItemInfoTipsCtrl:Uninit()

	super.Uninit(self)
	self.panel = nil

end --func end
--next--
function ItemInfoTipsCtrl:OnActive()


end --func end
--next--
function ItemInfoTipsCtrl:OnDeActive()


end --func end
--next--
function ItemInfoTipsCtrl:Update()


end --func end



--next--
function ItemInfoTipsCtrl:BindEvents()

	--dont override this function

end --func end

--next--
--lua functions end

--lua custom scripts

--lua custom scripts end
