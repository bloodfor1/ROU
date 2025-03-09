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
---@class MercenarySelectTemParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field Toggle MoonClient.MLuaUICom
---@field Prefab MoonClient.MLuaUICom
---@field MercenaryName MoonClient.MLuaUICom
---@field MercenaryLvltxt MoonClient.MLuaUICom
---@field MercenaryJob MoonClient.MLuaUICom
---@field MercenaryHead MoonClient.MLuaUICom
---@field MercenaryAttackTxt MoonClient.MLuaUICom
---@field MercenaryAttack MoonClient.MLuaUICom

---@class MercenarySelectTem : BaseUITemplate
---@field Parameter MercenarySelectTemParameter

MercenarySelectTem = class("MercenarySelectTem", super)
--lua class define end

--lua functions
function MercenarySelectTem:Init()
	
	    super.Init(self)
	
end --func end
--next--
function MercenarySelectTem:OnDestroy()
	
	
end --func end
--next--
function MercenarySelectTem:OnDeActive()
	
	
end --func end
--next--
function MercenarySelectTem:OnSetData(data)
	
	    self.Parameter.MercenaryName.LabText = data.name .. "(" .. data.ownerName .. ")"
	    self.Parameter.MercenaryAttack:SetActiveEx(data.isChoose)
	    self.Parameter.Toggle.Tog.isOn = data.isChoose
	    if data.isChoose then
	        MgrMgr:GetMgr("TeamMgr").AddSelectMercenaryTb({ ownerId = data.ownerId, mercenaryId = data.Id })
	    end
	    self.Parameter.MercenaryLvltxt.LabText = "Lv." .. data.lvl
	    self.Parameter.MercenaryHead:SetSpriteAsync("NpcIcon01", data.head)
	    self.Parameter.MercenaryJob:SetSpriteAsync("Common", data.job)
	    self.ownerId = data.ownerId
	    self.Id = data.Id
	    self.Parameter.Toggle:OnToggleChanged(function(value)
	        if value then
	            MgrMgr:GetMgr("TeamMgr").AddSelectMercenaryTb({ ownerId = self.ownerId, mercenaryId = self.Id })
	            if DataMgr:GetData("TeamData").GetCurMercenaryNum() > DataMgr:GetData("TeamData").GetMaxMercenaryNum() then
	                self.Parameter.Toggle.Tog.isOn = false
	                MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("Mercenary_Select_TipsTxt"))
	            end
	        else
	            MgrMgr:GetMgr("TeamMgr").RemoveSelectMercenaryTb({ ownerId = self.ownerId, mercenaryId = self.Id })
	            if MgrMgr:GetMgr("TeamMgr").myCurMercenary < 0 then
	                MgrMgr:GetMgr("TeamMgr").myCurMercenary = 0
	            end
	        end
	    end)
	
end --func end
--next--
function MercenarySelectTem:BindEvents()
	
	
end --func end
--next--
--lua functions end

--lua custom scripts

--lua custom scripts end
return MercenarySelectTem