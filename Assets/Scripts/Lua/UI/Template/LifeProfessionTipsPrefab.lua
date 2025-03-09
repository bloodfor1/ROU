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
local Mgr = MgrMgr:GetMgr("LifeProfessionMgr")
--lua fields end

--lua class define
---@class LifeProfessionTipsPrefabParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field Star MoonClient.MLuaUICom
---@field Name MoonClient.MLuaUICom
---@field Light MoonClient.MLuaUICom
---@field Icon MoonClient.MLuaUICom
---@field Desc MoonClient.MLuaUICom
---@field Count MoonClient.MLuaUICom
---@field Condition MoonClient.MLuaUICom
---@field Btn MoonClient.MLuaUICom

---@class LifeProfessionTipsPrefab : BaseUITemplate
---@field Parameter LifeProfessionTipsPrefabParameter

LifeProfessionTipsPrefab = class("LifeProfessionTipsPrefab", super)
--lua class define end

--lua functions
function LifeProfessionTipsPrefab:Init()
	
	    super.Init(self)
	
end --func end
--next--
function LifeProfessionTipsPrefab:OnDeActive()
	
	
end --func end
--next--
function LifeProfessionTipsPrefab:OnSetData(data)
	
	    self.data = data.data
	    self.Ctrl = data.ctrl
	    self:ActiveLight(false)
	    self.InSelect = false
	    self.MainItem = nil
	    self.Parameter.Btn:AddClick(function()
	        for i = 1, #self.Ctrl.MenuPool.Datas do
	            local l_item = self.Ctrl.MenuPool.Items[i]
	            if l_item == self then
	                l_item:OnSelect()
	            else
	                l_item:OnDeSelect()
	            end
	        end
	    end, true)
	    --星级范围
	    local l_minStar = 10
	    local l_maxStar = 0
	    local l_awardData = TableUtil.GetAwardTable().GetRowByAwardId(self.data.ResultID)
	    if l_awardData ~= nil then
	        for i = 0, l_awardData.PackIds.Length-1 do
	            local l_packData = TableUtil.GetAwardPackTable().GetRowByPackId(l_awardData.PackIds[i])
	            if l_packData ~= nil then
	                for j = 0, l_packData.GroupContent.Count-1 do
	                    local l_itemData = l_packData.GroupContent:get_Item(j, 0)
	                    l_itemData = TableUtil.GetItemTable().GetRowByItemID(l_itemData)
	                    if l_itemData ~= nil then
	                        if l_itemData.Star < l_minStar then
	                            l_minStar = l_itemData.Star
	                        end
	                        if l_itemData.Star > l_maxStar then
	                            l_maxStar = l_itemData.Star
	                        end
	                        if self.MainItem == nil then
	                            self.MainItem = l_itemData
	                        end
	                    else
	                        logError("ItemTable缺少数据 => "..tostring(l_packData.GroupContent:get_Item(j,0)))
	                    end
	                end
	            else
	                logError("AwardPackTable缺少数据 => "..tostring(l_awardData.PackIds[i]))
	            end
	        end
	    else
	        logError("AwardTable缺少数据 => "..tostring(self.data.ResultID))
	    end
	    self.Parameter.Star.gameObject:SetActiveEx(l_minStar <= l_maxStar and l_minStar > 0)
	    if l_minStar <= l_maxStar then
	        if l_minStar == l_maxStar then
	            self.Parameter.Count.LabText = tostring(l_minStar)
	        else
	            self.Parameter.Count.LabText = StringEx.Format("{0} ~ {1}", l_minStar, l_maxStar)
	        end
	    end
	    self.Parameter.Icon:SetSprite(self.data.Atlas, self.data.Icon)
	    self.Parameter.Name.LabText = self.data.Name
	    --条件
	    self.Parameter.Condition.gameObject:SetActiveEx(false)
	    self.Parameter.Condition.LabText = ""--"解锁等级"
	    if self.data.RecipeType == Mgr.ClassID.Smelt or
	        self.data.RecipeType == Mgr.ClassID.Armor or
	        self.data.RecipeType == Mgr.ClassID.Acces then
	        self.Parameter.Desc.LabText = self.data.DescShort
	    else
	        self.Parameter.Desc.LabText = ""
	    end
	
end --func end
--next--
function LifeProfessionTipsPrefab:BindEvents()
	
	
end --func end
--next--
function LifeProfessionTipsPrefab:OnDestroy()
	
	
end --func end
--next--
--lua functions end

--lua custom scripts
function LifeProfessionTipsPrefab:ActiveLight(b)
    self.Parameter.Light.gameObject:SetActiveEx(b)
end
function LifeProfessionTipsPrefab:OnSelect()

    if self.InSelect then
        return
    end
    self.InSelect = true
    self:ActiveLight(true)
    self.MethodCallback(self.Ctrl, self.data)

end

function LifeProfessionTipsPrefab:OnDeSelect()

    if not self.InSelect then
        return
    end
    self.InSelect = false
    self:ActiveLight(false)

end
--lua custom scripts end
return LifeProfessionTipsPrefab