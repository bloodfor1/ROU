--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/Handler/MallBaseHandler"
require "UI/Panel/MallMysteryPanel"
--lua requires end

--lua model
module("UI", package.seeall)

--lua model end

--lua fields
local super = UI.MallBaseHandler
--lua fields end

--lua class define
MallMysteryHandler = class("MallMysteryHandler", super)
--lua class define end

--lua functions
function MallMysteryHandler:ctor()
	
	super.ctor(self, HandlerNames.MallMystery, 0)
	
end --func end
--next--
function MallMysteryHandler:Init()
	
	self.panel = UI.MallGoldPanel.Bind(self)
	super.Init(self)

end --func end
--next--
function MallMysteryHandler:Uninit()
	
	super.Uninit(self)
	self.panel = nil
	
end --func end
--next--
function MallMysteryHandler:OnActive()
	
	super.OnActive(self)

	self:CustomActive()
end --func end
--next--
function MallMysteryHandler:OnDeActive()
	
	
end --func end
--next--
function MallMysteryHandler:Update()
	self.ItemPool:OnUpdate()
end --func end
--next--
function MallMysteryHandler:BindEvents()
	
	super.BindEvents(self)
end --func end
--next--
--lua functions end

--lua custom scripts

function MallMysteryHandler:CustomActive()
    
    self:SetTable(self.mallMgr.MallTable.Mystery)
end


--lua custom scripts end
return MallMysteryHandler