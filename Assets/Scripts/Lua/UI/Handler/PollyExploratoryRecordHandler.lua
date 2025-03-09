--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseHandler"
require "UI/Panel/PollyExploratoryRecordPanel"
--lua requires end

--lua model
module("UI", package.seeall)

--lua model end

--lua fields
local super = UI.UIBaseHandler
--lua fields end

--lua class define
PollyExploratoryRecordHandler = class("PollyExploratoryRecordHandler", super)
--lua class define end

--lua functions
function PollyExploratoryRecordHandler:ctor()
	
	super.ctor(self, HandlerNames.PollyExploratoryRecord, 0)
	
end --func end
--next--
function PollyExploratoryRecordHandler:Init()
	
	self.panel = UI.PollyExploratoryRecordPanel.Bind(self)
	super.Init(self)
	self.regionData = MgrMgr:GetMgr("BoliGroupMgr").GetRegionData()
	self._regionTemplatePool = self:NewTemplatePool({
        TemplateClassName = "RegionTemplate",
        TemplateParent = self.panel.Content.transform,
        TemplatePrefab = self.panel.Region.gameObject,
        Method = function(pollyHead)
        	self:onSelectOne(pollyHead)
    	end
    })
    self.currentSelectPolly = nil
end --func end

--next--
function PollyExploratoryRecordHandler:Uninit()
	super.Uninit(self)
	self.panel = nil
	
end --func end
--next--
function PollyExploratoryRecordHandler:OnActive()
	self:UpdateRegion()	
end --func end


function PollyExploratoryRecordHandler:UpdateRegion( ... )
	if self.regionData == nil then
		return
	end
	local l_datas = {}
	for k,v in pairs(self.regionData) do
		table.insert(l_datas,v)
	end
	table.sort(l_datas,function(a,b)
		return a.level < b.level
	end)
	self._regionTemplatePool:ShowTemplates({
        Datas = l_datas
    })
end

--next--
function PollyExploratoryRecordHandler:OnDeActive()
end --func end
--next--
function PollyExploratoryRecordHandler:Update()
	
	
end --func end
--next--
function PollyExploratoryRecordHandler:BindEvents()
    self:BindEvent(GlobalEventBus,EventConst.Names.OnDiscoverPolly,
        function(self, isClick)
            self:UpdateRegion(isClick)
        end)
end --func end
--next--
--lua functions end

--lua custom scripts

function PollyExploratoryRecordHandler:SelectRegion(regionId)
    self:UpdateRegion()
    GlobalEventBus:Dispatch(EventConst.Names.OnDiscoverPollyToRegion,regionId)       

end --func end

function PollyExploratoryRecordHandler:onSelectOne(pollyHead)
	if self.currentSelectPolly ~= nil then
		self.currentSelectPolly:OnDeselect()
	end
	self.currentSelectPolly = pollyHead
	self.currentSelectPolly:OnSelect()
end --func end
--lua custom scripts end
return PollyExploratoryRecordHandler