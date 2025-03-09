	--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/BeiluzSkillPreviewPanel"
require "UI/Template/BeiluzSkillPreviewItemTemplate"
--lua requires end

--lua model
module("UI", package.seeall)

--lua model end

--lua fields
local super = UI.UIBaseCtrl
--lua fields end

--lua class define
BeiluzSkillPreviewCtrl = class("BeiluzSkillPreviewCtrl", super)
local l_mgr = MgrMgr:GetMgr("BeiluzCoreMgr")
local attrMgr = MgrMgr:GetMgr("AttrDescUtil")
local openTime = 0.000001			-- 展开关闭的时间
local frameTime = 0.0333334
--lua class define end

--lua functions
function BeiluzSkillPreviewCtrl:ctor()
	
	super.ctor(self, CtrlNames.BeiluzSkillPreview, UILayer.Function, nil, ActiveType.Standalone)
	
end --func end
--next--
function BeiluzSkillPreviewCtrl:Init()

	self.panel = UI.BeiluzSkillPreviewPanel.Bind(self)
	super.Init(self)
	self.arrowStep = frameTime * 2 / openTime
	self.skillContentStep = frameTime / openTime
	self.skill1Open = true
	self.skill2Open = true

	self.panel.CloseBtn:AddClick(function()
		UIMgr:DeActiveUI(UI.CtrlNames.BeiluzSkillPreview)
	end)

	self.panel.Skill1Btn:AddClick(function()
		self:OnBtnSkill(1)
	end)

	self.panel.Skill2Btn:AddClick(function()
		self:OnBtnSkill(2)
	end)

	self.panel.ProfessionOnly:OnToggleChanged(function(value)
		self:OnToggleChanged(value)
	end)

	self.primaryAttrTemplatePool = self:NewTemplatePool({
		UITemplateClass = UITemplate.BeiluzSkillPreviewItemTemplate,
		TemplateParent = self.panel.Skill1Root.transform,
	})

	self.seniorAttrTemplatePool = self:NewTemplatePool({
		UITemplateClass = UITemplate.BeiluzSkillPreviewItemTemplate,
		TemplateParent = self.panel.Skill2Root.transform,
	})

end --func end
--next--
function BeiluzSkillPreviewCtrl:Uninit()
	
	super.Uninit(self)
	self.panel = nil
	
end --func end
--next--
function BeiluzSkillPreviewCtrl:OnActive()
	if self.uiPanelData then
		self.data = self.uiPanelData
		--self.panel.ProfessionOnly.Tog.isOn = true
		self.showProfessionOnly = true
		self:RefreshUI()
	end
end --func end
--next--
function BeiluzSkillPreviewCtrl:OnDeActive()
	if self.skill1Timer then
		self.skill1Timer:Stop()
		self.skill1Timer = nil
	end
	if self.skill2Timer then
		self.skill2Timer:Stop()
		self.skill2Timer = nil
	end
	
end --func end
--next--
function BeiluzSkillPreviewCtrl:Update()
	
	
end --func end
--next--
function BeiluzSkillPreviewCtrl:BindEvents()
	
	
end --func end
--next--
--lua functions end

--lua custom scripts
function BeiluzSkillPreviewCtrl:RefreshUI()
	if self.data then
		local primaryAttr, seniorAttr = self:GetAttrData()
		self.primaryAttrTemplatePool:ShowTemplates({ Datas = primaryAttr })
		self.seniorAttrTemplatePool:ShowTemplates({ Datas = seniorAttr })
	end
end

function BeiluzSkillPreviewCtrl:GetAttrData()
	local attrPoolIDs = self:GetAttrPoolIDs()
	local professionAttr = self:GetProfessionAttr(attrPoolIDs)
	local primaryAttr = {}
	local seniorAttr = {}
	local skillTableSize = TableUtil.GetWheelSkillTable().GetTableSize()
	for i = 1,skillTableSize do
		repeat
			local row = TableUtil.GetWheelSkillTable().GetRow(i)
			if self.showProfessionOnly and not professionAttr[row.BuffId] then
				break
			end
			if attrPoolIDs[row.SkillLibId] and row.Weight ~= 0 then
				---@type ItemAttrData
				local simulateData = Data.ItemAttrData.new(GameEnum.EItemAttrType.Buff,row.BuffId, 0, 0)
				local attrData = attrMgr.GetAttrStr(simulateData, nil)
				local cData = {}
				cData.AttrID = row.BuffId
				cData.Name = attrData.Name
				--cData.Recommend = (professionAttr[row.BuffId] ~= nil )
				if row.Type == 1 then
					if not (primaryAttr[cData.AttrID]) then
						primaryAttr[cData.AttrID] = cData
					end
				elseif row.Type == 2 then
					if not (seniorAttr[cData.AttrID]) then
						seniorAttr[cData.AttrID] = cData
					end
				else
					logError("@策划WheelSkillTable.Type值配错了 ID："..row.Id)
				end
			end
		until true
	end

	local resPrimaryAttr = {}
	local resSeniorAttr = {}
	for k,v in pairs(primaryAttr) do
		table.insert(resPrimaryAttr,v)
	end
	for k,v in pairs(seniorAttr) do
		table.insert(resSeniorAttr,v)
	end

	local sortFunc = function(a,b)
		if a.AttrID >= b.AttrID then
			return false
		else
			return true
		end
	end
	table.sort(resPrimaryAttr,sortFunc)
	table.sort(resSeniorAttr,sortFunc)
	return resPrimaryAttr, resSeniorAttr
end

function BeiluzSkillPreviewCtrl:GetAttrPoolIDs()
	local attrPoolIDs = {}
	local attrTableSize = TableUtil.GetWheelAttrTable().GetTableSize()
	for i=1,attrTableSize do
		local row = TableUtil.GetWheelAttrTable().GetRow(i)
		if row.WheelId == self.data.TID then
			if row.SkillOne ~= 0 and attrPoolIDs[row.SkillOne] == nil then
				attrPoolIDs[row.SkillOne] = true
			end
			if row.SkillTwo ~= 0 and attrPoolIDs[row.SkillTwo] == nil then
				attrPoolIDs[row.SkillTwo] = true
			end
		end
	end
	return attrPoolIDs
end

function BeiluzSkillPreviewCtrl:GetProfessionAttr()
	if not l_mgr.professionAttrConfig then
		l_mgr.professionAttrConfig = l_mgr.GetProfessionAttrConfig()
	end
	local professions = {}
	local recommend = {}
	l_mgr.GetProIdHash(MPlayerInfo.ProfessionId,professions)
	for k1,v1 in pairs(professions) do
		if l_mgr.professionAttrConfig[k1] then
			for k2,v2 in pairs(l_mgr.professionAttrConfig[k1]) do
				if v2 and recommend[k2]==nil then
					recommend[k2] = true
				end
			end
		end
	end
	return recommend
end

function BeiluzSkillPreviewCtrl:OnBtnSkill(index)
	local ctrlVarName = StringEx.Format("skill{0}Open",index)
	local timerName = StringEx.Format("skill{0}Timer",index)
	local arrowName = StringEx.Format("Skill{0}Arrow",index)
	local rootName = StringEx.Format("Skill{0}Root",index)

	self[ctrlVarName] = not self[ctrlVarName]
	if self[ctrlVarName] then
		self.panel[rootName]:SetActiveEx(true)
	end
	if self[timerName] ~= nil then
		self[timerName]:Stop()
		self[timerName] = nil
	end
	self[timerName] = Timer.New(function()
		local finished = true
		local arrowScaleY = self.panel[arrowName].transform.localScale.y
		local skillScaleY = self.panel[rootName].transform.localScale.y
		if self[ctrlVarName] then
			if arrowScaleY < 1 then
				arrowScaleY = arrowScaleY + self.arrowStep
				if arrowScaleY > 1 then
					arrowScaleY = 1
				end
				MLuaCommonHelper.SetLocalScale(self.panel[arrowName].gameObject, 1, arrowScaleY, 1)
				finished = false
			end
			if skillScaleY < 1 then
				skillScaleY = skillScaleY + self.skillContentStep
				if skillScaleY > 1 then
					skillScaleY = 1
				end
				MLuaCommonHelper.SetLocalScale(self.panel[rootName].gameObject, 1, skillScaleY, 1)
				finished = false
			end
			if finished then
				self[timerName]:Stop()
				self[timerName] = nil
			end
		else
			if arrowScaleY > -1 then
				arrowScaleY = arrowScaleY - self.arrowStep
				if arrowScaleY < -1 then
					arrowScaleY = -1
				end
				MLuaCommonHelper.SetLocalScale(self.panel[arrowName].gameObject, 1, arrowScaleY, 1)
				finished = false
			end
			if skillScaleY > 0 then
				skillScaleY = skillScaleY - self.skillContentStep
				if skillScaleY < 0 then
					skillScaleY = 0
				end
				MLuaCommonHelper.SetLocalScale(self.panel[rootName].gameObject, 1, skillScaleY, 1)
				finished = false
			end
			if finished then
				self[timerName]:Stop()
				self[timerName] = nil
				self.panel[rootName]:SetActiveEx(false)
			end
		end
	end,0.03334,-1,true)
	self[timerName]:Start()
end

function BeiluzSkillPreviewCtrl:OnToggleChanged(value)
	self.showProfessionOnly = value
	self:RefreshUI()
end

--lua custom scripts end
return BeiluzSkillPreviewCtrl