--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/Handler/MallBaseHandler"
require "UI/Panel/MallMasterPanel"
--lua requires end

--lua model
module("UI", package.seeall)

--lua model end

--lua fields
local super = UI.MallBaseHandler
--lua fields end

--lua class define
MallMasterHandler = class("MallMasterHandler", super)
--lua class define end

--lua functions
function MallMasterHandler:ctor()
	
	super.ctor(self, HandlerNames.MallMaster, 0)
	
end --func end
--next--
function MallMasterHandler:Init()
	
	self.panel = UI.MallGoldPanel.Bind(self)
	super.Init(self)
	
end --func end
--next--
function MallMasterHandler:Uninit()
	
	super.Uninit(self)
	self.panel = nil
	
end --func end
--next--
function MallMasterHandler:OnActive()
	
	super.OnActive(self)

	self:CustomActive()
end --func end
--next--
function MallMasterHandler:OnDeActive()
	
	
end --func end
--next--
function MallMasterHandler:Update()
	self.ItemPool:OnUpdate()
end --func end
--next--
function MallMasterHandler:BindEvents()
	super.BindEvents(self)
end --func end
--next--
--lua functions end

--lua custom scripts

function MallMasterHandler:CustomActive()
    local l_tbl = {self.mallMgr.MallTable.House_Zeny, self.mallMgr.MallTable.House_Copper}
    self:BuildMallTagTbl(l_tbl)
    self:CustomSetToggle("MasterHouseZenyTag", self.mallMgr.MallTable.House_Zeny)
    self:CustomSetToggle("MasterHouseCopperTag", self.mallMgr.MallTable.House_Copper)
end


--lua custom scripts end
return MallMasterHandler