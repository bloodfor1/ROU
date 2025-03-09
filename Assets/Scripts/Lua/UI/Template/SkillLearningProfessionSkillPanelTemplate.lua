--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/BaseUITemplate"
require "UI/Template/SkillLearningSkillBtnTemplate"
--lua requires end

--lua model
module("UITemplate", package.seeall)

--lua model end

--lua fields
local lineOffset = 170 * 0.88
local rightOffset = 150 * 0.88
local super = UITemplate.BaseUITemplate
local maxLine, maxRow = 0, 1
--lua fields end

--lua class define
---@class SkillLearningProfessionSkillPanelTemplateParameter.BtnLearnSkillInstance
---@field PanelRef MoonClient.MLuaUIPanel
---@field TxtSkillName5 MoonClient.MLuaUICom
---@field TxtSkillName3 MoonClient.MLuaUICom
---@field TxtSkillLv MoonClient.MLuaUICom
---@field SkillName5 MoonClient.MLuaUICom
---@field SkillName3 MoonClient.MLuaUICom
---@field SkillLvBg MoonClient.MLuaUICom
---@field PlusTxt MoonClient.MLuaUICom
---@field PlusLab MoonClient.MLuaUICom
---@field learnEff MoonClient.MLuaUICom
---@field ImgBG2 MoonClient.MLuaUICom
---@field ImgBG MoonClient.MLuaUICom
---@field BtnSelectSkill MoonClient.MLuaUICom
---@field BtnReduceSkillPoint MoonClient.MLuaUICom
---@field BtnPlusSkillPoint MoonClient.MLuaUICom

---@class SkillLearningProfessionSkillPanelTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field LineContainter MoonClient.MLuaUICom
---@field FrontSkillLineInstance MoonClient.MLuaUICom
---@field BG MoonClient.MLuaUICom
---@field BtnLearnSkillInstance SkillLearningProfessionSkillPanelTemplateParameter.BtnLearnSkillInstance

---@class SkillLearningProfessionSkillPanelTemplate : BaseUITemplate
---@field Parameter SkillLearningProfessionSkillPanelTemplateParameter

SkillLearningProfessionSkillPanelTemplate = class("SkillLearningProfessionSkillPanelTemplate", super)
--lua class define end

--lua functions
function SkillLearningProfessionSkillPanelTemplate:Init()
	
	super.Init(self)
	self.data = DataMgr:GetData("SkillData")
	self.mgr = MgrMgr:GetMgr("SkillLearningMgr")
	self.skillBtnTable = {}
	self.preSkillLineTable = {}
	self.Parameter.BtnLearnSkillInstance.LuaUIGroup.gameObject:SetActiveEx(false)

	self.SQueue = {}
	self.addFinish = false
	self.L, self.R = 1, 0
	
end --func end
--next--
function SkillLearningProfessionSkillPanelTemplate:OnDestroy()
	
	self.skillBtnTable = {}
	self.preSkillLineTable = {}
	self.skillLearningCtrl = nil
	
end --func end
--next--
function SkillLearningProfessionSkillPanelTemplate:OnSetData(data)
	
	self.skillLearningCtrl = data.skillLearningCtrl
	self.proId = data.proId
	self.proType = data.proType
	self.professionRow = TableUtil.GetProfessionTable().GetRowById(self.proId)
	if self.proType == self.data.ProfessionList.BASE_SKILL then
		self.skillIdList = {}
		self.commonSkillIds = self.data.GetCommonSkillIds()
		self.buffSkillIds = self.data.GetBuffSkillIds()
	else
		self.skillIdList = {}
		self.commonSkillIds = {}
		local skillIdsVectorSeq = self.professionRow.SkillIds
		local skillIdListSeq = Common.Functions.VectorSequenceToTable(skillIdsVectorSeq)
		for i, v in ipairs(skillIdListSeq) do
			table.insert(self.skillIdList, v[1])
		end
		self.buffSkillIds = {}
	end
	self.Parameter.LuaUIGroup.RectTransform.sizeDelta = Vector2.New(self.Parameter.BG.RectTransform.sizeDelta.x, lineOffset * self.professionRow.SkillLineNum)
	self.Parameter.LineContainter.RectTransform.sizeDelta = Vector2.New(self.Parameter.BG.RectTransform.sizeDelta.x, lineOffset * self.professionRow.SkillLineNum)
	self:InitAllSkillBtn()
	
end --func end
--next--
function SkillLearningProfessionSkillPanelTemplate:OnDeActive()
	
	
end --func end
--next--
function SkillLearningProfessionSkillPanelTemplate:BindEvents()
	
	
end --func end
--next--
--lua functions end

--lua custom scripts
-------------------------- ↓↓↓ UI队列 ↓↓↓ --------------------------

function SkillLearningProfessionSkillPanelTemplate:QueueClear()
	self.SQueue = {}
	self.L, self.R = 1, 0
end

function SkillLearningProfessionSkillPanelTemplate:QueuePush(value)
	self.R = self.R + 1
	self.SQueue[self.R] = value
end

function SkillLearningProfessionSkillPanelTemplate:QueuePop()
	if self.R < self.L then
		QueueClear()
		return nil
	end
	local value = self.SQueue[self.L]
	self.L = self.L + 1
	return value
end

function SkillLearningProfessionSkillPanelTemplate:IsQueueEmpty()
	return self.R < self.L
end

-------------------------- ↑↑↑ UI队列 ↑↑↑ --------------------------
---
function SkillLearningProfessionSkillPanelTemplate:Update()

	local btn
	maxLine, maxRow = 0, 1
	if not self:IsQueueEmpty() then
		local skillId = self:QueuePop()
		if skillId ~= 1 then
			btn = self:CreateSkillBtn(skillId, true)
			if btn.row > maxRow then maxRow = btn.row end
			if btn.line > maxLine then maxLine = btn.line end
		else
			self.addFinish = true
			self:QueueClear()
			self:BtnAddFinish()
		end
	end

end

function SkillLearningProfessionSkillPanelTemplate:InitAllSkillBtn()

	self:QueueClear()
	for _, skillId in ipairs(self.skillIdList) do
		self:QueuePush(skillId)
	end
	self:QueuePush(1)		--技能按钮生成完毕标记

end

function SkillLearningProfessionSkillPanelTemplate:BtnAddFinish()

	if self.proType == self.data.ProfessionList.BASE_SKILL and self.data.SkillQueueId ~= 0 then
		local l_openSysMgr = MgrMgr:GetMgr("OpenSystemMgr")
		if l_openSysMgr.IsSystemOpen(l_openSysMgr.eSystemId.QueueSkillFuncId) then
			self:CreateSkillBtn(self.data.SkillQueueId, true)
		end
	end
	local skillIds = table.mergeArray(table.ro_clone(self.buffSkillIds), self.commonSkillIds)
	if #skillIds > 0 then
		table.sort(skillIds, function(a, b)
			return a < b
		end)
		for i, v in ipairs(skillIds) do
			if maxLine >= 5 then
				maxRow = maxRow + 1
				maxLine = 1
			else
				maxLine = maxLine + 1
			end
			local pos = self:GetButtonPos(maxLine, maxRow)
			local skillBtn = self:CreateSkillBtn(v, false)
			skillBtn:gameObject():SetLocalPos(pos[1], pos[2], 0)
			skillBtn.line = maxLine
			skillBtn.row = maxRow
		end
	end
	self.Parameter.BG.RectTransform.sizeDelta = Vector2.New(self.Parameter.BG.RectTransform.sizeDelta.x, lineOffset * self.professionRow.SkillLineNum)
	self.Parameter.BG.transform:SetParent(self.skillLearningCtrl.panel.BGContainter.transform)
	--self.Parameter.LineContainter.RectTransform.sizeDelta = Vector2.New(self.Parameter.LineContainter.RectTransform.sizeDelta.x, lineOffset * self.professionRow.SkillLineNum)

end

function SkillLearningProfessionSkillPanelTemplate:GetButtonPos(line, row)

	local ret = Vector2.zero
	local startPos = {75, -100 * 0.9}
	ret = {startPos[1] + rightOffset * (line - 1), startPos[2] - lineOffset * (row - 1)}
	return ret

end

function SkillLearningProfessionSkillPanelTemplate:CreateSkillBtn(skillId, isLearn)

	local rawid = skillId
	local l_rootId = MPlayerInfo:GetRootSkillId(rawid)
	local skillInfo = TableUtil.GetSkillTable().GetRowById(l_rootId)
	if skillInfo == nil then
		logError("SkillTable不存在技能id: ", l_rootId)
		return
	end

	local finalPos = self:GetButtonPos(skillInfo.SkillPanelPos[1], skillInfo.SkillPanelPos[0])
	local l_instance = self:NewTemplate("SkillLearningSkillBtnTemplate", {
		Data = {
			professionPanel = self,
			skillLearningCtrl = self.skillLearningCtrl,
			skillId = rawid,
			row = skillInfo.SkillPanelPos[0],
			line = skillInfo.SkillPanelPos[1],
			isLearn = isLearn
		},
		TemplatePrefab = self.Parameter.BtnLearnSkillInstance.LuaUIGroup.gameObject,
		TemplateParent = self.Parameter.LuaUIGroup.transform,
		IsActive = true
	})
	table.insert(self.skillBtnTable, l_instance)
	self.skillLearningCtrl.skillBtnDic[rawid] = l_instance

	l_instance:gameObject():SetLocalPos(finalPos[1], finalPos[2], 0)
	if isLearn then
		self.skillLearningCtrl.skillBtnTempTable[l_rootId] = l_instance
	end
	return l_instance

end

function SkillLearningProfessionSkillPanelTemplate:UpdateAllBtn()

	local btns = {}
	array.veach(self.skillBtnTable, function(v) table.insert(btns, v) end)
	table.sort(btns, function(a, b)
		if not a.skillInfo or b.skillInfo then return false end
		return a.skillInfo.SkillPanelPos[1] < b.skillInfo.SkillPanelPos[1]
	end)
	for _,btn in ipairs(btns) do
		btn:UpdateAll()
		btn:UpdateSkillLearningBtn()
	end

end

function SkillLearningProfessionSkillPanelTemplate:ShowApplyEff()

	for i, v in ipairs(self.skillBtnTable) do
		if self.data.GetAddedSkillPoint(v.skillId, true) > 0 then
			v:ShowApplyEff()
		end
	end

end

function SkillLearningProfessionSkillPanelTemplate:ShowEffBatch(recommandLvs, effType)

	for i, v in ipairs(self.skillBtnTable) do
		local skillId = v:GetSkillId()
		if v:NeedSkillPointToLearn(skillId) and recommandLvs[skillId] then
			v:ShowEff(effType)
		end
	end

end

function SkillLearningProfessionSkillPanelTemplate:ConnectSkillBtns()

	local sizeUI = MUIManager:GetUIScreenSize()
	local l_lineContainer = self.skillLearningCtrl.panel.LineContainter
	local proType, proId = self.data.CurrentProTypeAndId()
	for _, v in ipairs(self.skillIdList) do
		local rawid = v
		local l_rootId = MPlayerInfo:GetRootSkillId(rawid)
		local l_currentSkillInstance = self.skillLearningCtrl.skillBtnTempTable[l_rootId]
		local l_skillInfo = TableUtil.GetSkillTable().GetRowById(l_rootId)
		local l_preSkill = l_skillInfo.PreSkillRequired
		local l_localLineContainer = self.Parameter.LineContainter
		local connectLineLen = 180
		local screenParameter = 1.586 * (sizeUI.x / sizeUI.y)
		for i = 0, l_preSkill.Count-1 do
			if l_preSkill:get_Item(i, 2) ~= 0 then
				local l_preSkillId = l_preSkill:get_Item(i, 0)

				local l_preSkillInstance = self.skillLearningCtrl.skillBtnTempTable[l_preSkillId]
				if not l_preSkillInstance then
					logYellow("技能{0}暂未实装", l_preSkillId)
				else
					local l_currentSkillBtn = l_currentSkillInstance.Parameter.BtnSelectSkill
					local l_preSkillBtn = l_preSkillInstance.Parameter.BtnSelectSkill

					local l_currentSkillBtnPos = l_currentSkillBtn.transform.position
					local l_preSkillBtnPos = l_preSkillBtn.transform.position
					if l_preSkillInstance.line == l_currentSkillInstance.line then
						local newLine = self:CloneObj(self.Parameter.FrontSkillLineInstance.gameObject)
						newLine.transform:SetParent(l_currentSkillBtn.transform)
						newLine.transform:SetLocalPos(0, 0, 0)
						newLine.transform:SetLocalScaleOne()
						newLine.transform:SetParent(l_localLineContainer.transform)
						local l_length = MLuaCommonHelper.GetDistance(l_currentSkillBtnPos, l_preSkillBtnPos)
						local l_rectTransform = newLine.gameObject:GetComponent("RectTransform")
						l_rectTransform.sizeDelta = Vector2.New(4, l_length / screenParameter * connectLineLen)
						newLine.gameObject:SetActiveEx(true)

						--记录以备之后删除
						self.preSkillLineTable[#self.preSkillLineTable+1] = newLine
					else
						local l_lengthY = l_preSkillBtnPos.y - l_currentSkillBtnPos.y
						local l_lengthX = math.abs(l_preSkillBtnPos.x - l_currentSkillBtnPos.x)
						local l_rectTransform

						--Line1
						local newLine1 = MResLoader:CloneObj(self.Parameter.FrontSkillLineInstance.gameObject)
						newLine1.transform:SetParent(l_currentSkillBtn.transform)
						newLine1.transform:SetLocalPos(0, 0, 0)
						newLine1.transform:SetLocalScaleOne()

						--记录以备之后删除
						self.preSkillLineTable[#self.preSkillLineTable+1] = newLine1
						newLine1.transform:SetParent(l_localLineContainer.transform)
						l_rectTransform = newLine1.gameObject:GetComponent("RectTransform")
						l_rectTransform.sizeDelta = Vector2.New(4, l_lengthY / screenParameter * connectLineLen / 2)
						newLine1.gameObject:SetActiveEx(true)

						--Line2
						local newLine2 = MResLoader:CloneObj(self.Parameter.FrontSkillLineInstance.gameObject)
						newLine2.transform:SetParent(l_currentSkillBtn.transform)
						newLine2.transform:SetLocalPos(0, l_lengthY / screenParameter * connectLineLen / 2, 0)
						newLine2.transform:SetLocalScaleOne()

						if l_preSkillInstance.line > l_currentSkillInstance.line then
							newLine2.transform:SetRotEulerZ(-90)
						else
							newLine2.transform:SetRotEulerZ(90)
						end

						--记录以备之后删除
						self.preSkillLineTable[#self.preSkillLineTable+1] = newLine2
						newLine2.transform:SetParent(l_localLineContainer.transform)
						l_rectTransform = newLine2.gameObject:GetComponent("RectTransform")
						l_rectTransform.sizeDelta = Vector2.New(4, math.abs(l_lengthX / screenParameter * connectLineLen))
						newLine2.gameObject:SetActiveEx(true)

						--Line3
						local newLine3 = MResLoader:CloneObj(self.Parameter.FrontSkillLineInstance.gameObject)
						newLine3.transform:SetParent(l_currentSkillBtn.transform)
						newLine3.transform:SetLocalPos(0, l_lengthY / screenParameter * connectLineLen / 2, 0)

						if l_preSkillInstance.line > l_currentSkillInstance.line then
							newLine3.transform:SetLocalPos(l_lengthX / screenParameter * connectLineLen, l_lengthY / screenParameter * connectLineLen / 2, 0)
						else
							newLine3.transform:SetLocalPos(-l_lengthX / screenParameter * connectLineLen, l_lengthY / screenParameter * connectLineLen / 2, 0)
						end
						newLine3.transform:SetLocalScaleOne()

						--记录以备之后删除
						self.preSkillLineTable[#self.preSkillLineTable+1] = newLine3
						newLine3.transform:SetParent(l_localLineContainer.transform)
						l_rectTransform = newLine3.gameObject:GetComponent("RectTransform")
						l_rectTransform.sizeDelta = Vector2.New(4, l_lengthY / screenParameter * connectLineLen / 2)
						newLine3.gameObject:SetActiveEx(true)
					end
				end
			end
		end
	end
	self.Parameter.LineContainter.transform:SetParent(l_lineContainer.transform)
	self.Parameter.LineContainter:GetComponent("RectTransform").anchoredPosition = Vector2(0, -self.skillLearningCtrl:GetAddPointPanelPos(self.proType))

end
--lua custom scripts end
return SkillLearningProfessionSkillPanelTemplate