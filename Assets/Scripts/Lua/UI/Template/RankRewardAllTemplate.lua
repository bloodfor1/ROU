--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/BaseUITemplate"
require "UI/Template/ItemTemplate"
--lua requires end

--lua model
module("UITemplate", package.seeall)

--lua model end

--lua fields
local super = UITemplate.BaseUITemplate
--lua fields end

--lua class define
---@class RankRewardAllTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field ScrollRect MoonClient.MLuaUICom
---@field Rank MoonClient.MLuaUICom
---@field Content MoonClient.MLuaUICom

---@class RankRewardAllTemplate : BaseUITemplate
---@field Parameter RankRewardAllTemplateParameter

RankRewardAllTemplate = class("RankRewardAllTemplate", super)
--lua class define end

--lua functions
function RankRewardAllTemplate:Init()
	
	super.Init(self)
	self.itemPool = self:NewTemplatePool({
        UITemplateClass = UITemplate.ItemTemplate,
        ScrollRect = self.Parameter.ScrollRect.LoopScroll,
    })
	
end --func end
--next--
function RankRewardAllTemplate:BindEvents()
	
	
end --func end
--next--
function RankRewardAllTemplate:OnDestroy()
	
	
end --func end
--next--
function RankRewardAllTemplate:OnDeActive()
	
	
end --func end
--next--
function RankRewardAllTemplate:OnSetData(data)

	self.Parameter.Rank.LabText = Lang("RANK_NUM", data.down, data.up)
	if data.down == data.up then
		self.Parameter.Rank.LabText = Lang("RANK_NUM_2", data.down)
	end
    self.Parameter.Rank.LabColor = RoColor.Hex2Color(data.color)
	local l_mail = TableUtil.GetMailTable().GetRowById(data.mail)
	if l_mail then
		local l_costDatas = {}
		local l_costs = Common.Functions.VectorSequenceToTable(l_mail.MailGroupContent)
		for i, v in ipairs(l_costs) do
			table.insert(l_costDatas, { ID = v[1], Count = v[2], IsShowCount = true, })
		end
		self.itemPool:ShowTemplates({ Datas = l_costDatas })
	end
	
end --func end
--next--
--lua functions end

--lua custom scripts

--lua custom scripts end
return RankRewardAllTemplate