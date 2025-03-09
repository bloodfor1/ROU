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
---@class RankTimeStampTemParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field Txt_TimeStampTogON MoonClient.MLuaUICom
---@field Txt_TimeStampTogOFF MoonClient.MLuaUICom
---@field Tog_TimeStamp_Tpl MoonClient.MLuaUICom
---@field TimeStampTogON MoonClient.MLuaUICom
---@field TimeStampTogOFF MoonClient.MLuaUICom
---@field Img_Current MoonClient.MLuaUICom

---@class RankTimeStampTem : BaseUITemplate
---@field Parameter RankTimeStampTemParameter

RankTimeStampTem = class("RankTimeStampTem", super)
--lua class define end

--lua functions
function RankTimeStampTem:Init()
	
	    super.Init(self)
	    self.Parameter.TimeStampTogOFF:AddClick(function()
	        self.MethodCallback(self.ShowIndex, self.timeStamp)
	    end)
	
end --func end
--next--
function RankTimeStampTem:BindEvents()
	
	
end --func end
--next--
function RankTimeStampTem:OnDestroy()
	
	
end --func end
--next--
function RankTimeStampTem:OnDeActive()
	
	
end --func end
--next--
function RankTimeStampTem:OnSetData(data)
	
	    self.Parameter.Txt_TimeStampTogOFF.LabText = data.name
	    self.Parameter.Txt_TimeStampTogON.LabText = data.name
	    self.Parameter.Img_Current:SetActiveEx(data.isCurrent)
	    if self.ShowIndex == 1 then
	        self.Parameter.Txt_TimeStampTogOFF.LabText = Common.Utils.Lang("RANK_CURRENT")
	        self.Parameter.Txt_TimeStampTogON.LabText = Common.Utils.Lang("RANK_CURRENT")
	    end
	    self.timeStamp = data.timeStamp
	
end --func end
--next--
--lua functions end

--lua custom scripts
function RankTimeStampTem:OnSelect()
    self.Parameter.TimeStampTogON:SetActiveEx(true)
    self.Parameter.TimeStampTogOFF:SetActiveEx(false)
end

function RankTimeStampTem:OnDeselect()
    self.Parameter.TimeStampTogON:SetActiveEx(false)
    self.Parameter.TimeStampTogOFF:SetActiveEx(true)
end
--lua custom scripts end
return RankTimeStampTem