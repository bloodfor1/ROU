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
---@class BeginnerRewardTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field Text MoonClient.MLuaUICom
---@field Reward01 MoonClient.MLuaUICom
---@field Number MoonClient.MLuaUICom
---@field Image MoonClient.MLuaUICom

---@class BeginnerRewardTemplate : BaseUITemplate
---@field Parameter BeginnerRewardTemplateParameter

BeginnerRewardTemplate = class("BeginnerRewardTemplate", super)
--lua class define end

--lua functions
function BeginnerRewardTemplate:Init()
	
	    super.Init(self)
	
end --func end
--next--
function BeginnerRewardTemplate:OnDestroy()
	
	
end --func end
--next--
function BeginnerRewardTemplate:OnSetData(data)
	
	local l_itemRow = TableUtil.GetItemTable().GetRowByItemID(data.id)
	self.Parameter.Number.LabText = StringEx.Format("×{0}", data.count)
	local l_nameChars = string.ro_toChars(l_itemRow.ItemName)
	local l_result = {}
	local l_byteCount = 0
	for i, v in ipairs(l_nameChars) do
		l_byteCount = l_byteCount + v.charSize
		if l_byteCount > 18 then
			break
		end
		table.insert(l_result, v.char)
	end
	if l_byteCount > 18 then
		self.Parameter.Text.LabText = StringEx.Format("{0}...", table.concat(l_result, "")) 
	else
		self.Parameter.Text.LabText = l_itemRow.ItemName
	end
	self.Parameter.Image:SetSpriteAsync(l_itemRow.ItemAtlas, l_itemRow.ItemIcon, nil, true)
	
end --func end
--next--
function BeginnerRewardTemplate:BindEvents()
	
	
end --func end
--next--
function BeginnerRewardTemplate:OnDeActive()
	
	
end --func end
--next--
--lua functions end

--lua custom scripts

--lua custom scripts end
return BeginnerRewardTemplate