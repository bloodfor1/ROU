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
---@class RedEnvelopeLevelItemTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field TotalText MoonClient.MLuaUICom
---@field SelectIcon MoonClient.MLuaUICom
---@field SelectCellButton MoonClient.MLuaUICom
---@field CostText MoonClient.MLuaUICom

---@class RedEnvelopeLevelItemTemplate : BaseUITemplate
---@field Parameter RedEnvelopeLevelItemTemplateParameter

RedEnvelopeLevelItemTemplate = class("RedEnvelopeLevelItemTemplate", super)
--lua class define end

--lua functions
function RedEnvelopeLevelItemTemplate:Init()
	
	    super.Init(self)
	
end --func end
--next--
function RedEnvelopeLevelItemTemplate:OnDestroy()
	
	
end --func end
--next--
function RedEnvelopeLevelItemTemplate:OnDeActive()
	
	
end --func end
--next--
function RedEnvelopeLevelItemTemplate:OnSetData(data)
	
	    self.data = data
	    self.Parameter.SelectIcon.UObj:SetActiveEx(false)
	    --发红包消耗物品数据获取
	    local l_costItem = TableUtil.GetItemTable().GetRowByItemID(data.RedPacketSendType)
	    local l_costIconStr = " "
	    if l_costItem then
	        l_costIconStr = Lang("RICH_IMAGE", l_costItem.ItemIcon, l_costItem.ItemAtlas, 20, 1.5)..l_costIconStr
	    end
	    self.Parameter.CostText.LabText = l_costIconStr..data.SpendDiamond
	    --发红包 红包内容物品数据获取
	    local l_sendItem = TableUtil.GetItemTable().GetRowByItemID(data.RedPacketGetType)
	    local l_sendIconStr = " "
	    if l_sendItem then
	        l_sendIconStr = Lang("RICH_IMAGE", l_sendItem.ItemIcon, l_sendItem.ItemAtlas, 20, 1.5)..l_sendIconStr
	    end
	    self.Parameter.TotalText.LabText = l_sendIconStr..data.GetCoin
	    self.Parameter.SelectCellButton:AddClick(function()
	        self.MethodCallback(self.ShowIndex)
	    end)
	
end --func end
--next--
function RedEnvelopeLevelItemTemplate:BindEvents()
	
	
end --func end
--next--
--lua functions end

--lua custom scripts
function RedEnvelopeLevelItemTemplate:OnSelect()
    self.Parameter.SelectIcon.gameObject:SetActiveEx(true)
end

function RedEnvelopeLevelItemTemplate:OnDeselect()
    self.Parameter.SelectIcon.gameObject:SetActiveEx(false)
end
--lua custom scripts end
return RedEnvelopeLevelItemTemplate