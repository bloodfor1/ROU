--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/Handler/MallBaseHandler"
require "UI/Panel/MallGoldPanel"
--lua requires end

--lua model
module("UI", package.seeall)

--lua model end

--lua fields
local super = UI.MallBaseHandler
--lua fields end

--lua class define
MallGoldHandler = class("MallGoldHandler", super)
--lua class define end

--lua functions
function MallGoldHandler:ctor()
	
	super.ctor(self, HandlerNames.MallGold, 0)
	
end --func end
--next--
function MallGoldHandler:Init()
	
	self.panel = UI.MallGoldPanel.Bind(self)
	super.Init(self)

end --func end
--next--
function MallGoldHandler:Uninit()
	
	super.Uninit(self)
	self.panel = nil
	
end --func end
--next--
function MallGoldHandler:OnActive()
	
	super.OnActive(self)

	self:CustomActive()
end --func end
--next--
function MallGoldHandler:OnDeActive()
	
    super.OnDeActive(self)
end --func end
--next--
function MallGoldHandler:Update()
	self.ItemPool:OnUpdate()
end --func end
--next--
function MallGoldHandler:BindEvents()
	
	super.BindEvents(self)
end --func end
--next--
--lua functions end

--lua custom scripts

function MallGoldHandler:CustomActive()


    local l_tbl = {self.mallMgr.MallTable.Glod_Gift, self.mallMgr.MallTable.Glod_Hot, self.mallMgr.MallTable.Glod_Appearance}
	self:BuildMallTagTbl(l_tbl)

    self:CustomSetToggle("GoldGiftTag", self.mallMgr.MallTable.Glod_Gift)
    self:CustomSetToggle("GoldHotTag", self.mallMgr.MallTable.Glod_Hot)
    self:CustomSetToggle("GoldAppearanceTag", self.mallMgr.MallTable.Glod_Appearance)
    	
	self:NewRedSign({
        Key = eRedSignKey.RedSignMallGoldGift,
        ClickTogEx = self.panel.GoldGiftTag,
    })
end


--lua custom scripts end
return MallGoldHandler