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
---@class GuildRankTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field Txt_Score MoonClient.MLuaUICom
---@field Txt_RankSpecial MoonClient.MLuaUICom
---@field Txt_RankNormal MoonClient.MLuaUICom
---@field Txt_Member2 MoonClient.MLuaUICom
---@field Txt_Member1 MoonClient.MLuaUICom
---@field Txt_GuildName MoonClient.MLuaUICom
---@field Img_Touch MoonClient.MLuaUICom

---@class GuildRankTemplate : BaseUITemplate
---@field Parameter GuildRankTemplateParameter

GuildRankTemplate = class("GuildRankTemplate", super)
--lua class define end

--lua functions
function GuildRankTemplate:Init()
	
	super.Init(self)
	
end --func end
--next--
function GuildRankTemplate:BindEvents()
	
	
end --func end
--next--
function GuildRankTemplate:OnDestroy()
	
	
end --func end
--next--
function GuildRankTemplate:OnDeActive()
	
	
end --func end
--next--
function GuildRankTemplate:OnSetData(data)
	
	if data==nil then
		return
	end
	local l_isRankBefore3 = data.rank<4
	if l_isRankBefore3 then
		self.Parameter.Txt_RankNormal.LabText = data.rank
	else
		self.Parameter.Txt_RankSpecial.LabText = data.rank
	end
	self.Parameter.Txt_RankNormal:SetActiveEx(l_isRankBefore3)
	self.Parameter.Txt_RankSpecial:SetActiveEx(not l_isRankBefore3)
	self.Parameter.Txt_Member1.LabText = data.member1Name
	self.Parameter.Txt_Member2.LabText = data.member2Name
	self.Parameter.Txt_GuildName.LabText = data.guildName
	self.Parameter.Txt_Score.LabText = data.score
	self.Parameter.Img_Touch.Listener.onClick=function(go,eventData)
		local l_timeSec=data.useTime/1000
		local l_useMin = math.floor(l_timeSec/60)
		local l_useSec = l_timeSec%60
		MgrMgr:GetMgr("TipsMgr").ShowQuestionTip(Lang("PERSIONAL_COOK_TIP",data.cookNum, l_useMin,l_useSec),
				eventData, Vector2(0.5,0),true,nil,MUIManager.UICamera,true)
	end
end --func end
--next--
--lua functions end

--lua custom scripts

--lua custom scripts end
return GuildRankTemplate