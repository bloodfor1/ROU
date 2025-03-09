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
local canTakeEffPath = "Effects/Prefabs/Creature/Ui/FX_ui_skillui"
--lua fields end

--lua class define
---@class JobAwardItemTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field bg MoonClient.MLuaUICom
---@field ImageBg MoonClient.MLuaUICom
---@field BG MoonClient.MLuaUICom
---@field Border MoonClient.MLuaUICom
---@field CanTakeEff MoonClient.MLuaUICom
---@field AttrBG MoonClient.MLuaUICom
---@field HasAward MoonClient.MLuaUICom
---@field RawPart MoonClient.MLuaUICom
---@field RawImage MoonClient.MLuaUICom
---@field Icon MoonClient.MLuaUICom[]
---@field Image MoonClient.MLuaUICom[]
---@field AttrTxt MoonClient.MLuaUICom[]
---@field Icon MoonClient.MLuaUICom[]
---@field Image MoonClient.MLuaUICom[]
---@field AttrTxt MoonClient.MLuaUICom[]
---@field Complete MoonClient.MLuaUICom
---@field JobNext MoonClient.MLuaUICom
---@field txtNext MoonClient.MLuaUICom
---@field Occupation MoonClient.MLuaUICom
---@field ProfessionTxt MoonClient.MLuaUICom
---@field Line MoonClient.MLuaUICom
---@field JobLv MoonClient.MLuaUICom

---@class JobAwardItemTemplate : BaseUITemplate
---@field Parameter JobAwardItemTemplateParameter

JobAwardItemTemplate = class("JobAwardItemTemplate", super)
--lua class define end

--lua functions
function JobAwardItemTemplate:Init()
	
	super.Init(self)
	self.mgr = MgrMgr:GetMgr("SkillLearningMgr")
	self.skillData = DataMgr:GetData("SkillData")
	
end --func end
--next--
function JobAwardItemTemplate:OnDestroy()
	
	self:Clear()
	self.status = nil
	
end --func end
--next--
function JobAwardItemTemplate:OnDeActive()
	
	
end --func end
--next--
function JobAwardItemTemplate:OnSetData(data)
	
	self:Clear()
	self.data = data
	local type = data.type
	local proId = data.proId
	local proSdata = self.skillData.GetDataFromTable("ProfessionTable", proId)
	local isNormal = type == GameEnum.JobAwardItemType.Normal
	local isPro = type == GameEnum.JobAwardItemType.Pro
	local isForeshow = type == GameEnum.JobAwardItemType.ForeShow
	self.proType = proSdata.ProfessionType
	self.Parameter.txtNext:SetActiveEx(false)
	self.Parameter.RawPart:SetActiveEx(isPro)
	self.Parameter.Border:SetActiveEx(isNormal)
	self.Parameter.RawImage:SetActiveEx(false)
	self.Parameter.Occupation:SetActiveEx(isPro)
	self.Parameter.BG:SetActiveEx(isNormal or isForeshow)
	self.Parameter.CanTakeEff:SetActiveEx(isNormal)
	self.Parameter.JobLv:SetActiveEx(isNormal)
	self.Parameter.ImageBg:SetActiveEx(true)
	self.Parameter.JobNext:SetActiveEx(isForeshow)
	self.Parameter.Line:SetActiveEx(not isForeshow)
	self.Parameter.AttrBG:SetActiveEx(not isForeshow)
	self.Parameter.ImageBg.FxAnim:StopAll()
	--MLuaUIListener.Get(self.Parameter.ImageBg.gameObject
	--self.Parameter.ImageBg.Listener.onClick = function(go, ed)
	--end
	local canvasGroup = self.Parameter.bg:GetComponent("CanvasGroup")
	if isNormal then
		local awardAttrsCount = data.sdata.AwardAttribute.Count
		for i, v in ipairs(self.Parameter.Icon) do
			v:SetActiveEx(isNormal and awardAttrsCount >= i)
		end
		local status = self.skillData.GetJobAwardItemStatus(data.proId, data.jobLv, self:GetRealJobLv())
		self.status = status
		self.Parameter.HasAward:SetActiveEx(status == GameEnum.JobAwardItemStatus.CanTake)
		self.Parameter.Complete:SetActiveEx(status == GameEnum.JobAwardItemStatus.Taked)
		self.Parameter.CanTakeEff:SetActiveEx(status == GameEnum.JobAwardItemStatus.CanTake)
		self.Parameter.Border:SetActiveEx(status == GameEnum.JobAwardItemStatus.CanTake)
		for i = 1, awardAttrsCount do
			self.Parameter.Image[i]:SetSpriteAsync(data.sdata.AwardIconAtlas, data.sdata.AwardIconSprite[i - 1], nil, true)
			local v = data.sdata.AwardAttribute[i - 1]
			local attr = {type = v[0], id = v[1], val = v[2]}
			self.Parameter.AttrTxt[i].LabText = MgrMgr:GetMgr("EquipMgr").GetAttrStrByData(attr)
		end
		if status == GameEnum.JobAwardItemStatus.Lock then
			local nextJobLv = self.skillData.GetNextStageJobLv()
			if self:GetRealJobLv() == nextJobLv then
				self.Parameter.txtNext:SetActiveEx(true)
			end
			self.Parameter.ImageBg:GetComponent("Animator").enabled = true
		elseif status == GameEnum.JobAwardItemStatus.CanTake then
			self.Parameter.ImageBg:PlayFx()
			self.Parameter.ImageBg:GetComponent("Animator").enabled = false
			self.effFx = self:CreateUIEffect(canTakeEffPath, {
				rawImage = self.Parameter.CanTakeEff.RawImg,
				playTime = -1,
			})
		else
			self.Parameter.ImageBg:GetComponent("Animator").enabled = true
		end
		self.Parameter.JobLv.LabText = string.ro_concat("Job ", data.jobLv)
		self.Parameter.ImageBg:AddClick(function()
			if status == GameEnum.JobAwardItemStatus.CanTake then
				self.mgr.RequestGetJobAward(proId, data.jobLv)
			elseif status == GameEnum.JobAwardItemStatus.Lock then
			elseif status == GameEnum.JobAwardItemStatus.Taked then
			end
			self.Parameter.ImageBg:GetComponent("Animator"):SetTrigger("Pressed")
		end)
		if status == GameEnum.JobAwardItemStatus.Taked then
			canvasGroup.alpha = 0.8
		else
			canvasGroup.alpha = 1
		end
	elseif isPro then
		for i, v in ipairs(self.Parameter.Icon) do
			v:SetActiveEx(false)
		end
		self.Parameter.HasAward:SetActiveEx(false)
		self.Parameter.Complete:SetActiveEx(false)
		self.model = self:CreateModelEntity(proId)
		self.Parameter.Occupation:SetSpriteAsync("Common", proSdata.ProfessionIcon)
		self.Parameter.ProfessionTxt:SetActiveEx(true)
		self.Parameter.ProfessionTxt.LabText = proSdata.Name
		canvasGroup.alpha = 1
	else
		for i, v in ipairs(self.Parameter.Icon) do
			v:SetActiveEx(false)
		end
		self.Parameter.HasAward:SetActiveEx(false)
		self.Parameter.Complete:SetActiveEx(false)
		canvasGroup.alpha = 1
		self.Parameter.ImageBg:AddClick(function()
			self.Parameter.ImageBg:GetComponent("Animator"):SetTrigger("Pressed")
		end)
	end
	
end --func end
--next--
function JobAwardItemTemplate:BindEvents()
	
	
end --func end
--next--
--lua functions end

--lua custom scripts
function JobAwardItemTemplate:CreateModelEntity(proId)

    local attr = MgrProxy:GetGarderobeMgr().GetRoleAttr(nil, proId)
    local l_fxData = {}
    l_fxData.rawImage = self.Parameter.RawImage.RawImg
    l_fxData.attr = attr
    l_fxData.defaultAnim = MgrMgr:GetMgr("GarderobeMgr").GetRoleAnim(attr)

    local model = self:CreateUIModel(l_fxData)
    model:AddLoadModelCallback(function(m)
        self.Parameter.RawImage:SetActiveEx(true)
        if self.data and self.data.temp then
            self.data.temp:ReBuildLayout()
        end
    end)

    
    return model

end

function JobAwardItemTemplate:Clear()

    if self.model then
    	self:DestroyUIModel(self.model)
        self.model = nil
    end
    if self.effFx then
        self:DestroyUIEffect(self.effFx)
        self.effFx = nil
    end

end

function JobAwardItemTemplate:GetProId()
    return self.data.proId
end

function JobAwardItemTemplate:GetJobLv()
    return self.data.jobLv
end

function JobAwardItemTemplate:GetType()
    return self.data.type
end

function JobAwardItemTemplate:GetStatus()
    return self.status
end

function JobAwardItemTemplate:SetJobLvActive(isShow)
    self.Parameter.JobLv:SetActiveEx(isShow)
end

function JobAwardItemTemplate:GetRealJobLv()

    local ret = 0
    if self.skillData.JobChangeLevel then
        ret = self.skillData.JobChangeLevel[self.proType] + (self.data.jobLv or 0)
    end
    return ret

end
--lua custom scripts end
return JobAwardItemTemplate