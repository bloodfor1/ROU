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
---@class RankRowTemParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field RankRowBg2 MoonClient.MLuaUICom
---@field RankRowBg1 MoonClient.MLuaUICom
---@field RankRow MoonClient.MLuaUICom

---@class RankRowTem : BaseUITemplate
---@field Parameter RankRowTemParameter

RankRowTem = class("RankRowTem", super)
--lua class define end

--lua functions
function RankRowTem:Init()
	
	    super.Init(self)
	    self.myTems = {}
	
end --func end
--next--
function RankRowTem:BindEvents()
	
	
end --func end
--next--
function RankRowTem:OnDestroy()
	
	
end --func end
--next--
function RankRowTem:OnDeActive()
	
	
end --func end
--next--
function RankRowTem:OnSetData(data)
	
	    --log(self.ShowIndex,ToString(data))
	    self.Parameter.RankRowBg1:SetActiveEx(data.index % 2 == 1)
	    self.Parameter.RankRowBg2:SetActiveEx(data.index % 2 == 0)
	    local count = 0
	    local maxCount = #data.rowName
	    if self.myTems then
	        for k, v in pairs(self.myTems) do
	            self:UninitTemplate(v)
	        end
	    end
	    self.myTems = {}
	    for k, v in pairs(data.rowName) do
	        ---@class RankRowInfoData
	        local l_data = { value = data.rowValue[k].value, color = v.textColor, columnWidth = v.columnWidth, membersInfo = data.rowValue[k].membersInfo, showMemberType = data.rowValue[k].showMemberType }
	        local l_tem = self:NewTemplate(tostring(v.templateName), {
	            TemplatePath = "UI/Prefabs/" .. tostring(v.templateName),
	            TemplateParent = self.Parameter.RankRow.Transform,
	            Data = l_data
	        })
	        l_tem:AddLoadCallback(function()
	            count = count + 1
	            if count == maxCount then
	                self:SortTem()
	            end
	        end)
	        table.insert(self.myTems, l_tem)
	    end
	    if self.ShowIndex == DataMgr:GetData("RankData").TotalNum then
	        MgrMgr:GetMgr("RankMgr").GetNextPage()
	    end
	
end --func end
--next--
--lua functions end

--lua custom scripts
function RankRowTem:SortTem()
    for i = 1, #self.myTems do
        self.myTems[i]:transform():SetSiblingIndex(i + 1)
    end
end
--lua custom scripts end
return RankRowTem