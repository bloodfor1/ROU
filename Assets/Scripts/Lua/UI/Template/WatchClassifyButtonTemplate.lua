--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/BaseUITemplate"
require "UI/Template/WatchDetailsButtonTemplate"
--lua requires end

--lua model
module("UITemplate", package.seeall)

--lua model end

--lua fields
local super = UITemplate.BaseUITemplate
--lua fields end

--lua class define
---@class WatchClassifyButtonTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field WatchDetailsButtonParent MoonClient.MLuaUICom
---@field Root MoonClient.MLuaUICom
---@field ON MoonClient.MLuaUICom
---@field Off MoonClient.MLuaUICom
---@field ButtonName2 MoonClient.MLuaUICom
---@field ButtonName1 MoonClient.MLuaUICom
---@field Arrow2 MoonClient.MLuaUICom
---@field Arrow1 MoonClient.MLuaUICom

---@class WatchClassifyButtonTemplate : BaseUITemplate
---@field Parameter WatchClassifyButtonTemplateParameter

WatchClassifyButtonTemplate = class("WatchClassifyButtonTemplate", super)
--lua class define end

--lua functions
function WatchClassifyButtonTemplate:Init()
	
	super.Init(self)
	self.detailTemplatePool = nil
	self.childActive = false
	self.isSelected = nil
	self.isExpand = false
	self.mgr = MgrMgr:GetMgr("WatchWarMgr")
	self.dataMgr = DataMgr:GetData("WatchWarData")
	self:BindingEvents()
	
end --func end
--next--
function WatchClassifyButtonTemplate:OnDestroy()
	
	self.detailTemplatePool = nil
	self.childActive = nil
	self.isSelected = nil
	self.mgr = nil
	self.dataMgr = nil
	self.isExpand = nil
	
end --func end
--next--
function WatchClassifyButtonTemplate:OnDeActive()
	
	
end --func end
--next--
function WatchClassifyButtonTemplate:OnSetData(data)
	
	self:CustomSetData(data)
	
end --func end
--next--
function WatchClassifyButtonTemplate:BindEvents()
	
	
end --func end
--next--
--lua functions end

--lua custom scripts
function WatchClassifyButtonTemplate:CustomSetData(data)

	self.id = 0
	local l_row = TableUtil.GetSpectatorTypeTable().GetRowByID(data.ID, true)
	local l_title
	if not l_row then
		logError("WatchClassifyButtonTemplate:CustomSetData error, SpectatorTypeTable cannot find", data.ID)
		return
	else
		l_title = l_row.Name
	end

	self.id = data.ID
	self.childActive = false
	self.Parameter.ButtonName1.LabText = l_title
	self.Parameter.ButtonName2.LabText = l_title
	if data.childs then
		self:ProcessMultiple(data, l_row)
	else
		self:ProcessSingle(data, l_row)
	end

	self:UpdateSelectState()
end

function WatchClassifyButtonTemplate:ProcessSingle(data, row)
	
	self.Parameter.WatchDetailsButtonParent.gameObject:SetActiveEx(false)
	self.Parameter.Arrow1.gameObject:SetActiveEx(false)
	self.Parameter.Arrow2.gameObject:SetActiveEx(false)
end

function WatchClassifyButtonTemplate:ProcessMultiple(data, row)

	self.childActive = true
	self.isExpand = false

	self.Parameter.Arrow1.gameObject:SetActiveEx(true)
	self.Parameter.Arrow2.gameObject:SetActiveEx(true)

	if not self.detailTemplatePool then
		self.detailTemplatePool = self:NewTemplatePool({
			TemplatePrefab = data.childTemplateGo,
			UITemplateClass = UITemplate.WatchDetailsButtonTemplate,
			TemplateParent = self.Parameter.WatchDetailsButtonParent.transform,
		})
	end

	self.detailTemplatePool:ShowTemplates({Datas = data.childs})

	self:TryExpand(false)
end

function WatchClassifyButtonTemplate:IsSelected()
	-- 数据非法
	if self.id == self.dataMgr.ESelectClassifyType.UnDefined then
		return false
	end
	-- id一致则被选中
	if self.mgr.GetSelectClassifyTypeID() == self.id then
		return true
	end
	-- 如果没有子节点，则未被选中
	if not self.childActive then
		return false
	end
	-- 子节点未初始化
	if not self.detailTemplatePool then
		return false
	end

	-- 某个子节点被选中
	local l_childTemplates = self.detailTemplatePool:GetItems()
	for i, v in pairs(l_childTemplates) do
		if v:IsSelected() then
			return true, true
		end
	end

	return false
end

function WatchClassifyButtonTemplate:UpdateSelectState()

	local l_selected, l_childSelected = self:IsSelected()
	if l_selected ~= self.isSelected or l_childSelected then
		self.isSelected = l_selected
		self.Parameter.Off.gameObject:SetActiveEx(not l_selected)
		self.Parameter.ON.gameObject:SetActiveEx(l_selected)

		if not l_selected then
			self:TryExpand(false)
		elseif l_childSelected then
			self:TryExpand(true)
		end
	end

	if l_selected then
		if self.detailTemplatePool then
			local l_childTemplates = self.detailTemplatePool:GetItems()
			for i, v in pairs(l_childTemplates) do
				v:UpdateSelectState()
			end
		end
		return true
	end
end

function WatchClassifyButtonTemplate:BindingEvents()
	
	local l_function = function()
		local l_limit = self.mgr.IsSpectatorRefreshLimit(self.id, true)
		self.mgr.SetSelectClassifyTypeID(self.id, not l_limit)
		self:TryExpand(not self.isExpand)
	end

	self.Parameter.ON:AddClick(l_function)
	self.Parameter.Off:AddClick(l_function)
end

function WatchClassifyButtonTemplate:TryExpand(expand)

	if not self.childActive then
		return
	end

	self.isExpand = expand
	self.Parameter.Arrow1.transform:DOLocalRotate(Vector3.New(0, 0, self.isExpand and -0.1 or -179.9), 0.5)

	self.Parameter.WatchDetailsButtonParent.gameObject:SetActiveEx(self.isExpand)
end
--lua custom scripts end
return WatchClassifyButtonTemplate