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
---@class TradeParentParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field parentON MoonClient.MLuaUICom
---@field parentOff MoonClient.MLuaUICom

---@class TradeParent : BaseUITemplate
---@field Parameter TradeParentParameter

TradeParent = class("TradeParent", super)
--lua class define end

--lua functions
function TradeParent:Init()
	
	    super.Init(self)
	
end --func end
--next--
function TradeParent:OnDeActive()
	
	
end --func end
--next--
function TradeParent:OnSetData(data)
	
	    self:InitParent(data)
	    self:SetState(false)
	
end --func end
--next--
function TradeParent:BindEvents()
	
	
end --func end
--next--
function TradeParent:OnDestroy()
	
	
end --func end
--next--
--lua functions end

--lua custom scripts
local l_tradeMgr = MgrMgr:GetMgr("TradeMgr")

function TradeParent:InitParent(info)
    self.l_info = info
    self.l_id = info.info.ClassificationID
    self.Parameter.parentON:AddClick(function()
        --self:SetState(false)
        l_tradeMgr.EventDispatcher:Dispatch(l_tradeMgr.ON_TYPE_CLICK, self.l_id)
    end)
    self.Parameter.parentOff:AddClick(function()
        --self:SetState(true)
        l_tradeMgr.EventDispatcher:Dispatch(l_tradeMgr.ON_TYPE_CLICK, self.l_id)
    end)

    self:SetState(false)
    local l_a1 = self.Parameter.parentON.gameObject.transform:Find("Img02").gameObject
    local l_b1 = self.Parameter.parentON.gameObject.transform:Find("Img01").gameObject
    local l_a2 = self.Parameter.parentOff.gameObject.transform:Find("Img02").gameObject
    local l_b2 = self.Parameter.parentOff.gameObject.transform:Find("Img01").gameObject

    local l_lab1 = MLuaClientHelper.GetOrCreateMLuaUICom(self.Parameter.parentON.gameObject.transform:Find("Text").gameObject)
    local l_lab2 = MLuaClientHelper.GetOrCreateMLuaUICom(self.Parameter.parentOff.gameObject.transform:Find("Text").gameObject)
    l_lab1.LabText = info.info.ClassificationName
    l_lab2.LabText = info.info.ClassificationName

    if table.ro_size(info.sonType) < 1 then
        self.haveChild = false
        l_a1:SetActiveEx(false)
        l_a2:SetActiveEx(false)
        l_b1:SetActiveEx(false)
        l_b2:SetActiveEx(false)
    else
        self.haveChild = true
        l_a1:SetActiveEx(true)
        l_a2:SetActiveEx(true)
        l_b1:SetActiveEx(true)
        l_b2:SetActiveEx(true)
    end
end

function TradeParent:GetRectTransform()
    return self.uObj:GetComponent("RectTransform")
end

function TradeParent:SetState(isOn)
    self.isOn = isOn
    self.Parameter.parentON.gameObject:SetActiveEx(isOn)
    self.Parameter.parentOff.gameObject:SetActiveEx(not isOn)
end

function TradeParent:GetState()
    return self.isOn
end

function TradeParent:GetChild()
    return self.haveChild
end
--lua custom scripts end
return TradeParent