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
---@class MapInfoTitleTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field Txt_NpcShortName MoonClient.MLuaUICom
---@field Img_NpcUnfold MoonClient.MLuaUICom
---@field Btn_OpenNpcInfo MoonClient.MLuaUICom

---@class MapInfoTitleTemplate : BaseUITemplate
---@field Parameter MapInfoTitleTemplateParameter

MapInfoTitleTemplate = class("MapInfoTitleTemplate", super)
--lua class define end

--lua functions
function MapInfoTitleTemplate:Init()
	
	super.Init(self)
	
end --func end
--next--
function MapInfoTitleTemplate:OnDestroy()
	
	
end --func end
--next--
function MapInfoTitleTemplate:OnDeActive()
	
	
end --func end
--next--
function MapInfoTitleTemplate:OnSetData(data)
	
	if not data.isTitle then
		return
	end
	if data.setToFirstPos then
		self:transform():SetAsFirstSibling()
	end
	self:ChangeFoldShow(data.isFold)
	self.Parameter.Txt_NpcShortName.LabText=data.mapName
	self.Parameter.Btn_OpenNpcInfo:AddClick(function()
		if data.buttonMethod~=nil then
			data.isFold= not data.isFold
			self:ChangeFoldShow(data.isFold)
			data.buttonMethod()
		else
			local l_mapInfoMgr=MgrMgr:GetMgr("MapInfoMgr")
			l_mapInfoMgr.EventDispatcher:Dispatch(l_mapInfoMgr.EventType.UpdateNpcInfoFoldState,data.titleId,not data.isFold)
		end
	end,true)
	
end --func end
--next--
function MapInfoTitleTemplate:BindEvents()
	
	
end --func end
--next--
--lua functions end

--lua custom scripts
function MapInfoTitleTemplate:ChangeFoldShow(fold)
	local l_angles=Vector3.zero
	if fold then
		l_angles.z = 90
	end
	self.Parameter.Img_NpcUnfold.Transform.localEulerAngles=l_angles
end
--lua custom scripts end
return MapInfoTitleTemplate