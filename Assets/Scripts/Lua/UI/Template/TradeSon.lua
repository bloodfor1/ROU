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
---@class TradeSonParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field sonON MoonClient.MLuaUICom
---@field sonOff MoonClient.MLuaUICom

---@class TradeSon : BaseUITemplate
---@field Parameter TradeSonParameter

TradeSon = class("TradeSon", super)
--lua class define end

--lua functions
function TradeSon:Init()
	
	    super.Init(self)
	
end --func end
--next--
function TradeSon:OnDeActive()
	
	
end --func end
--next--
function TradeSon:OnSetData(data)
	
	    self:InitSon(data)
	    self:SetState(false)
	
end --func end
--next--
function TradeSon:BindEvents()
	
	
end --func end
--next--
function TradeSon:OnDestroy()
	
	
end --func end
--next--
--lua functions end

--lua custom scripts
local l_tradeMgr = MgrMgr:GetMgr("TradeMgr")

function TradeSon:InitSon(info)
    ---MerchantGuildTable
    self.l_info = info
    self.l_id = info.info.ClassificationID
    self.Parameter.sonOff:AddClick(function()
        self:SetState(true)
        l_tradeMgr.EventDispatcher:Dispatch(l_tradeMgr.ON_TYPE_CLICK, self.l_id)
    end)

    local l_lab1 = MLuaClientHelper.GetOrCreateMLuaUICom(self.Parameter.sonON.gameObject.transform:Find("Text").gameObject)
    local l_lab2 = MLuaClientHelper.GetOrCreateMLuaUICom(self.Parameter.sonOff.gameObject.transform:Find("Text").gameObject)
    l_lab1.LabText = info.info.ClassificationName
    l_lab2.LabText = info.info.ClassificationName

    self:SetState(false)
end

function TradeSon:SetState(isOn)
    self.Parameter.sonON.gameObject:SetActiveEx(isOn)
    self.Parameter.sonOff.gameObject:SetActiveEx(not isOn)
end
--lua custom scripts end
return TradeSon