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
---@class MercenaryAttrCellTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field BackBtn MoonClient.MLuaUICom
---@field AttrName MoonClient.MLuaUICom
---@field BaseText MoonClient.MLuaUICom
---@field PlusText MoonClient.MLuaUICom

---@class MercenaryAttrCellTemplate : BaseUITemplate
---@field Parameter MercenaryAttrCellTemplateParameter

MercenaryAttrCellTemplate = class("MercenaryAttrCellTemplate", super)
--lua class define end

--lua functions
function MercenaryAttrCellTemplate:Init()
	
	    super.Init(self)
	    self.Parameter.BackBtn:AddClick(function ()
	        if self.attrInfo then
	            local l_pointEventData=PointerEventData.New(EventSystem.current)
	            l_pointEventData.position = Input.mousePosition
	            MgrMgr:GetMgr("TipsMgr").ShowQuestionTip(self.attrInfo.tableInfo.AttrTips, l_pointEventData, Vector2(0.5,0),false,nil,MUIManager.UICamera,true)
	        end
	    end)
	
end --func end
--next--
function MercenaryAttrCellTemplate:OnDestroy()
	
	
end --func end
--next--
function MercenaryAttrCellTemplate:OnDeActive()
	
	
end --func end
--next--
function MercenaryAttrCellTemplate:OnSetData(data)
	
	    self.attrInfo = data.attrInfo
	    self.Parameter.PlusText:SetActiveEx(false)
	    if data.isAdvance then
	        self.Parameter.AttrName.LabText = data.name
	        self.Parameter.BaseText.LabText = data.value
	        return
	    end
	    self.Parameter.AttrName.LabText = self.attrInfo.tableInfo.AttrName
	    --if data.isRecruited then
	        --控制显示格式
	        local l_attrValue = MgrMgr:GetMgr("MercenaryMgr").GetMercenaryAttrStr(self.attrInfo.tableInfo.Id, self.attrInfo.finalValue)
	        self.Parameter.BaseText.LabText = l_attrValue
	        --log(self.attrInfo.tableInfo.AttrName,self.attrInfo.finalValue,l_attrValue,self.attrInfo.tableInfo.Id)
	    --else
	    --    self.Parameter.BaseText.LabText = "?"
	    --end
	
end --func end
--next--
function MercenaryAttrCellTemplate:BindEvents()
	
	
end --func end
--next--
--lua functions end

--lua custom scripts

--lua custom scripts end
return MercenaryAttrCellTemplate