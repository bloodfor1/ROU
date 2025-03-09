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
local NormalColor = Color(113/255, 114/255, 168/255, 1)
local ChooseColor = Color(239/255, 141/255, 75/255, 1)
--lua fields end

--lua class define
---@class FashionRankTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field Score MoonClient.MLuaUICom
---@field RankPrefab MoonClient.MLuaUICom
---@field Rank MoonClient.MLuaUICom
---@field Name MoonClient.MLuaUICom

---@class FashionRankTemplate : BaseUITemplate
---@field Parameter FashionRankTemplateParameter

FashionRankTemplate = class("FashionRankTemplate", super)
--lua class define end

--lua functions
function FashionRankTemplate:Init()
	
	super.Init(self)
    self.data = DataMgr:GetData("FashionData")
    self.mgr = MgrMgr:GetMgr("FashionRatingMgr")
    self.rankmgr = MgrMgr:GetMgr("RankMgr")
	
end --func end
--next--
function FashionRankTemplate:BindEvents()
	
	
end --func end
--next--
function FashionRankTemplate:OnDestroy()
	
	
end --func end
--next--
function FashionRankTemplate:OnDeActive()
	
	
end --func end
--next--
function FashionRankTemplate:OnSetData(data)

    self.Parameter.Name.LabText = data.rowValue[3].value
    self.Parameter.Rank.LabText = data.rowValue[1].value
    self.Parameter.Score.LabText = tostring(data.rowValue[2].value)
    local l_nowPage = math.ceil(self.data.TotalNum / self.mgr.RankPageLimit)
    if self.ShowIndex == self.data.TotalNum then
        DataMgr:GetData("RankData").isGetNextPage = true
        self.rankmgr.RequestLeaderBoardInfo(self.mgr.FashionTableID, self.mgr.RankKey, 0, l_nowPage, true)
    end
    self.Parameter.RankPrefab:AddClick(function()
        self.MethodCallback(self.ShowIndex, data.rowValue[3].membersInfo[1].id)
    end)

end --func end
--next--
--lua functions end

--lua custom scripts
function FashionRankTemplate:OnSelect()

    self.Parameter.Name.LabColor = ChooseColor
    self.Parameter.Rank.LabColor = ChooseColor
    self.Parameter.Score.LabColor = ChooseColor

end

function FashionRankTemplate:OnDeselect()

    self.Parameter.Name.LabColor = NormalColor
    self.Parameter.Rank.LabColor = NormalColor
    self.Parameter.Score.LabColor = NormalColor

end
--lua custom scripts end
return FashionRankTemplate