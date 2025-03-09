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
---@class BoliAchieveRewardItemTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field Prefab MoonClient.MLuaUICom
---@field ItemSlot MoonClient.MLuaUICom[]
---@field ItemBox MoonClient.MLuaUICom[]
---@field IconCanGet MoonClient.MLuaUICom[]
---@field IconAlreadyGet MoonClient.MLuaUICom[]
---@field ClickEventIcon MoonClient.MLuaUICom[]
---@field Arrow MoonClient.MLuaUICom

---@class BoliAchieveRewardItemTemplate : BaseUITemplate
---@field Parameter BoliAchieveRewardItemTemplateParameter

BoliAchieveRewardItemTemplate = class("BoliAchieveRewardItemTemplate", super)
--lua class define end

--lua functions
function BoliAchieveRewardItemTemplate:Init()
	
	    super.Init(self)
	    self.itemList = {}
	
end --func end
--next--
function BoliAchieveRewardItemTemplate:OnDestroy()
	
	    self.itemList = nil
	
end --func end
--next--
function BoliAchieveRewardItemTemplate:OnDeActive()
	
	
end --func end
--next--
function BoliAchieveRewardItemTemplate:OnSetData(data)
	
	    self.data = data 
	    --最后一个不显示箭头
	    self.Parameter.Arrow.UObj:SetActiveEx(not data.isLast)
	    --奖励预览项
	    for i = 1, 5 do
	        if i > #data.awardDatas then
	            self.Parameter.ItemBox[i].UObj:SetActiveEx(false)
	            if self.itemList[i] then
	                self.itemList[i]:SetGameObjectActive(false)
	            end
	        else
	            self.Parameter.ItemBox[i].UObj:SetActiveEx(true)
	            if not self.itemList[i] then
	                self.itemList[i] = self:NewTemplate("ItemTemplate", {IsActive = false, TemplateParent = self.Parameter.ItemSlot[i].transform})
	            end
	            self.itemList[i]:SetData({
	                ID = data.awardDatas[i].ID,
	                Count = data.awardDatas[i].Count,
	                IsShowCount = data.awardDatas[i].IsShowCount
	            })
	            --蒙层
	            if data.isCanGetAward or data.isGetAward then
	                self.Parameter.ClickEventIcon[i].UObj:SetActiveEx(true)
	                --可领取 和 已领取标记
	                self.Parameter.IconCanGet[i].UObj:SetActiveEx(data.isCanGetAward)
	                self.Parameter.IconAlreadyGet[i].UObj:SetActiveEx(data.isGetAward)
	                --点击事件
	                self.Parameter.ClickEventIcon[i]:AddClick(function ()
	                    self:MethodCallback()
	                end)
	            else
	                self.Parameter.ClickEventIcon[i].UObj:SetActiveEx(false)
	            end
	        end
	    end
	
end --func end
--next--
function BoliAchieveRewardItemTemplate:BindEvents()
	
	
end --func end
--next--
--lua functions end

--lua custom scripts

--lua custom scripts end
return BoliAchieveRewardItemTemplate