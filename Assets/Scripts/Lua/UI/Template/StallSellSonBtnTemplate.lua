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
---@class StallSellSonBtnTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field Text2 MoonClient.MLuaUICom
---@field Text1 MoonClient.MLuaUICom
---@field sonON MoonClient.MLuaUICom
---@field sonOff MoonClient.MLuaUICom
---@field SellOut2 MoonClient.MLuaUICom
---@field SellOut MoonClient.MLuaUICom

---@class StallSellSonBtnTemplate : BaseUITemplate
---@field Parameter StallSellSonBtnTemplateParameter

StallSellSonBtnTemplate = class("StallSellSonBtnTemplate", super)
--lua class define end

--lua functions
function StallSellSonBtnTemplate:Init()
	
	    super.Init(self)
	    self.id = nil
	    self.need = true
	
end --func end
--next--
function StallSellSonBtnTemplate:OnDeActive()
	
	
end --func end
--next--
function StallSellSonBtnTemplate:OnSetData(data)
	
	    self:InitButton(data)
	    self:SetState(false)
	
end --func end
--next--
function StallSellSonBtnTemplate:BindEvents()
	
	
end --func end
--next--
function StallSellSonBtnTemplate:OnDestroy()
	
	
end --func end
--next--
--lua functions end

--lua custom scripts
l_mgr = MgrMgr:GetMgr("StallMgr")
l_event = MgrMgr:GetMgr("StallMgr").EventDispatcher

function StallSellSonBtnTemplate:InitButton(info)
    self.id = info
    self.l_info = TableUtil.GetStallIndexTable().GetRowByID(self.id)
    self.Parameter.Text1.LabText = self.l_info.Name
    self.Parameter.Text2.LabText = self.l_info.Name
    --self.Parameter.Img_Icon:SetSprite(self.l_info.Atlas, self.l_info.Icon, true)
    --self.Parameter.Img_Icon2:SetSprite(self.l_info.Atlas, self.l_info.Icon, true)
    self.Parameter.sonON:AddClick(function()
        l_event:Dispatch(l_mgr.ON_CLICK_STALL_BUY_BTN, self.l_info.ID)
        l_mgr.SendStallGetMarkInfoReq(self.l_info.ID)
    end)
    self.Parameter.sonOff:AddClick(function()
        l_event:Dispatch(l_mgr.ON_CLICK_STALL_BUY_BTN, self.l_info.ID)
        l_mgr.SendStallGetMarkInfoReq(self.l_info.ID)
    end)
end

function StallSellSonBtnTemplate:SetState(state)
    self.Parameter.sonON.gameObject:SetActiveEx(state)
    self.Parameter.sonOff.gameObject:SetActiveEx(not state)
end

function StallSellSonBtnTemplate:RefrashNeedTag()
    self.Parameter.SellOut.gameObject:SetActiveEx(false)
    self.Parameter.SellOut2.gameObject:SetActiveEx(false)
    if not self.need then
        return
    end
    if self.id then
        local l_indexList = l_mgr.GetAllIndex(self.id)
        if #l_indexList > 0 then
            for i = 1, #l_indexList do
                local l_secIndex = l_indexList[i]
                if l_mgr.g_secIndex2ItemId[l_secIndex] then
                    local l_itemId = l_mgr.g_secIndex2ItemId[l_secIndex].itemId
                    local l_needCount = MgrMgr:GetMgr("RequireItemMgr").GetNeedItemCountByID(l_itemId)
                    if l_needCount > Data.BagModel:GetBagItemCountByTid(l_itemId) then
                        self.Parameter.SellOut.gameObject:SetActiveEx(true)
                        self.Parameter.SellOut2.gameObject:SetActiveEx(true)
                        return true
                    end
                end
                --for k, v in pairs(requireItem) do
                --    local l_id = v.ID
                --    local l_num = v.Count
                --    if l_itemId == l_id then
                --        local l_need = Data.BagModel:GetBagItemCountByTid(l_itemId) < l_num
                --        if l_need then
                --            self.Parameter.SellOut.gameObject:SetActiveEx(true)
                --            self.Parameter.SellOut2.gameObject:SetActiveEx(true)
                --            return true
                --        end
                --    end
                --end
            end
        end
    end
    return false
end
--lua custom scripts end
return StallSellSonBtnTemplate