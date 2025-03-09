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
---@class StallButtonTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field Text2 MoonClient.MLuaUICom
---@field Text MoonClient.MLuaUICom
---@field SellOut2 MoonClient.MLuaUICom
---@field SellOut MoonClient.MLuaUICom
---@field parentON MoonClient.MLuaUICom
---@field parentOff MoonClient.MLuaUICom
---@field Img_Icon2 MoonClient.MLuaUICom
---@field Img_Icon MoonClient.MLuaUICom

---@class StallButtonTemplate : BaseUITemplate
---@field Parameter StallButtonTemplateParameter

StallButtonTemplate = class("StallButtonTemplate", super)
--lua class define end

--lua functions
function StallButtonTemplate:Init()
	
	    super.Init(self)
	    self.id = nil
	    self.need = true
	
end --func end
--next--
function StallButtonTemplate:OnDeActive()
	
	
end --func end
--next--
function StallButtonTemplate:OnSetData(data)
	
	    self:InitButton(data)
	    self:SetState(false)
	
end --func end
--next--
function StallButtonTemplate:BindEvents()
	
	
end --func end
--next--
function StallButtonTemplate:OnDestroy()
	
	
end --func end
--next--
--lua functions end

--lua custom scripts
l_mgr = MgrMgr:GetMgr("StallMgr")
l_event = MgrMgr:GetMgr("StallMgr").EventDispatcher

function StallButtonTemplate:InitButton(info)
    self.id = info.id
    self.sonInfo = info.son
    self.l_info = TableUtil.GetStallIndexTable().GetRowByID(self.id)

    self:SetUIInfo()

    local l_arror1 = self.Parameter.parentON.gameObject.transform:Find("Arror").gameObject
    local l_arror2 = self.Parameter.parentOff.gameObject.transform:Find("Arror").gameObject
    if self.sonInfo == nil or #self.sonInfo == 0 then
        l_arror1:SetActiveEx(false)
        l_arror2:SetActiveEx(false)
    else
        l_arror1:SetActiveEx(true)
        l_arror2:SetActiveEx(true)
    end
    self.Parameter.parentON:AddClick(function()
        if self.sonInfo == nil or #self.sonInfo == 0 then
            l_event:Dispatch(l_mgr.ON_CLICK_STALL_BUY_BTN, self.l_info.ID)
            l_mgr.SendStallGetMarkInfoReq(self.l_info.ID)
        else
            l_event:Dispatch(l_mgr.ON_CLICK_STALL_PARENT_BTN, self.l_info.ID)
        end
    end)
    self.Parameter.parentOff:AddClick(function()
        if self.sonInfo == nil or #self.sonInfo == 0 then
            l_event:Dispatch(l_mgr.ON_CLICK_STALL_BUY_BTN, self.l_info.ID)
            l_mgr.SendStallGetMarkInfoReq(self.l_info.ID)
        else
            l_event:Dispatch(l_mgr.ON_CLICK_STALL_PARENT_BTN, self.l_info.ID)
        end
    end)
end

function StallButtonTemplate:SetUIInfo()
    if self.l_info then
        self.Parameter.Text.LabText = self.l_info.Name
        self.Parameter.Text2.LabText = self.l_info.Name
        if self.color1 then
            self.Parameter.Img_Icon.Img.color = self.color1
        else
            self.color1 = self.Parameter.Img_Icon.Img.color
        end
        if self.color2 then
            self.Parameter.Img_Icon2.Img.color = self.color2
        else
            self.color2 = self.Parameter.Img_Icon2.Img.color
        end
        self.Parameter.Img_Icon:SetSprite(self.l_info.Atlas, self.l_info.Icon, true)
        self.Parameter.Img_Icon2:SetSprite(self.l_info.Atlas, self.l_info.Icon, true)
    end
end

function StallButtonTemplate:SetState(state)
    self.Parameter.parentON.gameObject:SetActiveEx(state)
    self.Parameter.parentOff.gameObject:SetActiveEx(not state)
end

function StallButtonTemplate:RefrashNeedTag(requireItem)
    self:SetNeedTag(false)
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
                    if Data.BagModel:GetBagItemCountByTid(l_itemId) < l_needCount then
                        self:SetNeedTag(true)
                        return
                    end
                end
                --for k, v in pairs(requireItem) do
                --    local l_id = v.ID
                --    local l_num = v.Count
                --    if l_itemId == l_id then
                --        local l_need = Data.BagModel:GetBagItemCountByTid(l_itemId) < l_num
                --        if l_need then
                --            self:SetNeedTag(true)
                --            return
                --        end
                --    end
                --end
            end
        end
    end
end

function StallButtonTemplate:SetNeedTag(state)
    self.Parameter.SellOut.gameObject:SetActiveEx(state)
    self.Parameter.SellOut2.gameObject:SetActiveEx(state)
end
--lua custom scripts end
return StallButtonTemplate