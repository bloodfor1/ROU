--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/BaseUITemplate"
--lua requires end

--lua model
module("UITemplate", package.seeall)

--lua model end

--lua fields
local super = UITemplate.BaseUITemplate
--lua fields end

--lua class define
---@class PollyHeadTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field ReceivePollyHead MoonClient.MLuaUICom
---@field PollyHeadIcon MoonClient.MLuaUICom
---@field PollyHead MoonClient.MLuaUICom
---@field NomalPollyHead MoonClient.MLuaUICom
---@field Name MoonClient.MLuaUICom
---@field DiscoverScene MoonClient.MLuaUICom
---@field Choice MoonClient.MLuaUICom

---@class PollyHeadTemplate : BaseUITemplate
---@field Parameter PollyHeadTemplateParameter
PollyHeadTemplate = class("PollyHeadTemplate", super)
--lua class define end

--lua functions
function PollyHeadTemplate:Init()
	
	super.Init(self)
	
end --func end
--next--
function PollyHeadTemplate:BindEvents()
	
	
end --func end
--next--
function PollyHeadTemplate:OnDestroy()
	
	
end --func end
--next--
function PollyHeadTemplate:OnDeActive()
	
	
end --func end
--next--
function PollyHeadTemplate:OnSetData(data)
	local l_pollyData = TableUtil.GetElfTable().GetRowByID(data.id)
	if l_pollyData == nil then
		return
	end
	local l_pollyType = l_pollyData.ElfTypeID
	local l_typeData = TableUtil.GetElfTypeTable().GetRowByID(l_pollyType)
	if l_typeData == nil then
		return
	end
	self.Parameter.Name.LabText = l_typeData.Name
	self.Parameter.NomalPollyHead.gameObject:SetActiveEx(data.gotAward)
	self.Parameter.ReceivePollyHead.gameObject:SetActiveEx(not data.gotAward)
	self.Parameter.Choice:SetActiveEx(false)
	if data.gotAward then
		local l_sceneData = TableUtil.GetSceneTable().GetRowByID(data.sceneId)
		if l_sceneData ~= nil then
			self.Parameter.DiscoverScene.LabText = StringEx.Format(Common.Utils.Lang("POLLY_DISCOVER_SCENE_TIP"),l_sceneData.Comment)
		end
		self.Parameter.PollyHeadIcon:SetSprite(l_pollyData.Atlas, l_pollyData.Icon,true)
		self.Parameter.PollyHeadIcon:AddClick(function()
			self.MethodCallback(self.ShowIndex,l_pollyType,self)
		end)
		self.Parameter.NomalPollyHead:AddClick(function( ... )
			self.MethodCallback(self.ShowIndex,0,self)
			local l_timeData =  Common.TimeMgr.GetTimeTable(data.time)
			local l_timeStr = StringEx.Format(Common.Utils.Lang("DATE_YY_MM_DD"),l_timeData.year,l_timeData.month,l_timeData.day)
			local l_discoverTips = StringEx.Format(Common.Utils.Lang("POLLY_DISCOVER_SCNENE_SHOW_TIPS"),l_timeStr,l_sceneData.Comment)
			MgrMgr:GetMgr("TipsMgr").ShowNormalTips(l_discoverTips)
		end)
	else
		self.Parameter.ReceivePollyHead:AddClick(function(...)
			local l_mgr = MgrMgr:GetMgr("BoliGroupMgr")
			l_mgr.RequestGetPollyAward(l_mgr.EPollyAwardType.Single,data.id,1)
			self.MethodCallback(self.ShowIndex,0,self)
		end)

	end
end --func end
--next--
--lua functions end

--lua custom scripts
function PollyHeadTemplate:OnSelect()
	self.Parameter.Choice:SetActiveEx(true)
end

function PollyHeadTemplate:OnDeselect()
	self.Parameter.Choice:SetActiveEx(false)
end
--lua custom scripts end
return PollyHeadTemplate