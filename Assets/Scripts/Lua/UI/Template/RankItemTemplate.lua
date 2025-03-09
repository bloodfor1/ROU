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
---@class RankItemTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field ScoreNormal MoonClient.MLuaUICom
---@field ScoreHard MoonClient.MLuaUICom
---@field ScoreEasy MoonClient.MLuaUICom
---@field Score MoonClient.MLuaUICom
---@field RankText MoonClient.MLuaUICom
---@field RankItemPrefab MoonClient.MLuaUICom
---@field RankImg MoonClient.MLuaUICom
---@field PlayerName MoonClient.MLuaUICom
---@field LvAndJob MoonClient.MLuaUICom
---@field IsSelect MoonClient.MLuaUICom
---@field HeadDummy MoonClient.MLuaUICom

---@class RankItemTemplate : BaseUITemplate
---@field Parameter RankItemTemplateParameter

RankItemTemplate = class("RankItemTemplate", super)
--lua class define end

--lua functions
function RankItemTemplate:Init()
	
	super.Init(self)
	
end --func end
--next--
function RankItemTemplate:OnDestroy()
	
	
end --func end
--next--
function RankItemTemplate:OnDeActive()
	
	
end --func end
--next--
function RankItemTemplate:OnSetData(data)
	self.data = data  -- 记录数据 点击回调用
	--初始化选中
	self:SetSelect(data.isSelect or false)
	--头像显示
	self._head = self:NewTemplate("HeadWrapTemplate", {
		TemplateParent = self.Parameter.HeadDummy.transform,
		TemplatePath = "UI/Prefabs/HeadWrapTemplate"
	})

	---@type HeadTemplateParam
	local param = {}
	param.EquipData = MgrMgr:GetMgr("PlayerInfoMgr").GetEquipData(data.member_info)
	self._head:SetData(param)
	--姓名 职业 等级 得分
	self.Parameter.PlayerName.LabText = data.member_info.name
	local l_jobName = DataMgr:GetData("TeamData").GetProfessionNameById(data.member_info.type)
	self.Parameter.LvAndJob.LabText = StringEx.Format("Lv.{0} {1}", data.member_info.base_level, l_jobName)
	self.Parameter.Score.LabText = data.score
	self.Parameter.ScoreEasy.LabText = data.diffScore[3]
	self.Parameter.ScoreNormal.LabText = data.diffScore[2]
	self.Parameter.ScoreHard.LabText = data.diffScore[1]
	--排名显示
	if data.rank < 4 then
		self.Parameter.RankImg.UObj:SetActiveEx(true)
		self.Parameter.RankText.UObj:SetActiveEx(false)
		self.Parameter.RankImg:SetSprite("CommonIcon", "UI_CommonIcon_Icon_Rank_0"..data.rank..".png")
	else
		self.Parameter.RankImg.UObj:SetActiveEx(false)
		self.Parameter.RankText.UObj:SetActiveEx(true)
		self.Parameter.RankText.LabText = data.rank
	end
	--点击事件
	self.Parameter.RankItemPrefab:AddClick(function()
		self:MethodCallback()
	end)
	
end --func end
--next--
function RankItemTemplate:BindEvents()
	
	
end --func end
--next--
--lua functions end

--lua custom scripts
--选中效果设置
function RankItemTemplate:SetSelect(isSelect)

    self.data.isSelect = isSelect
    self.Parameter.IsSelect.UObj:SetActiveEx(isSelect)

end
--lua custom scripts end
return RankItemTemplate