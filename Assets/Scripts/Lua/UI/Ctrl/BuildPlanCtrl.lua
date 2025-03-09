--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/BuildPlanPanel"
require "UI/Template/MultiSkillEmptyLineTemplate"
require "UI/Template/MultiSkillLineTemplate"
require "UI/Template/MultiSkillTitleLineTemplate"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua fields
local super = UI.UIBaseCtrl
local ContentType = {
    Title = 0,
    Empty = 1,
    Skill = 2
}
--next--
--lua fields end

--lua class define
BuildPlanCtrl = class("BuildPlanCtrl", super)
--lua class define end

--lua functions
function BuildPlanCtrl:ctor()
	
	super.ctor(self, CtrlNames.BuildPlan, UILayer.Function, nil, ActiveType.Standalone)

    self.GroupMaskType = GroupMaskType.Show
    self.MaskColor=BlockColor.Transparent
    self.ClosePanelNameOnClickMask=UI.CtrlNames.BuildPlan
	
end --func end
--next--
function BuildPlanCtrl:Init()
	
	self.panel = UI.BuildPlanPanel.Bind(self)
	super.Init(self)

    --遮罩设置
    --self:SetBlockOpt(BlockColor.Transparent, function()
    --    UIMgr:DeActiveUI(self.name)
    --end)
	
end --func end
--next--
function BuildPlanCtrl:Uninit()
	
	super.Uninit(self)
	self.panel = nil
    self.skillLinePool = nil
end --func end
--next--
function BuildPlanCtrl:OnActive()
    if self.uiPanelData~=nil then
        if self.uiPanelData.planId~=nil then
            local l_isLocalPlan=self.uiPanelData.isLocalPlan
            if self.uiPanelData.showSkillPlan then
                if l_isLocalPlan then
                    self:ShowSkillPlan(true, self.uiPanelData.planId)
                else
                    self:ShowSkillPlan(false, self.uiPanelData.planId, self.uiPanelData.memberBaseInfo, self.uiPanelData.shareData)
                end
            else
                if l_isLocalPlan then
                    self:ShowAttrPlan(nil,nil,self.uiPanelData.planId)
                else
                    self:ShowAttrPlan(self.uiPanelData.memberBaseInfo, self.uiPanelData.shareData, nil)
                end
            end
        end
    end
	
end --func end
--next--
function BuildPlanCtrl:OnDeActive()
	self:DestoryAttrObj()
end --func end
--next--
function BuildPlanCtrl:Update()
	
	
end --func end





--next--
function BuildPlanCtrl:BindEvents()
	
	
end --func end

--next--
--lua functions end

--lua custom scripts
---isLocalPlan 是否是本地方案
---planId 方案索引
---MemberBaseInfo 不需要
---skillPlan 方案数据
function BuildPlanCtrl:ShowSkillPlan(isLocalPlan, planId, MemberBaseInfo, skillPlanShare)
    self:RefreshSkillHead(isLocalPlan, planId, MemberBaseInfo, skillPlanShare)
    self:RefreshPlanSkills(skillPlanShare, planId, MemberBaseInfo)
end

function BuildPlanCtrl:RefreshSkillHead(isLocalPlan, planId, MemberBaseInfo, skillPlanShare)
    local jobLevel = MemberBaseInfo and tonumber(MemberBaseInfo.data.job_level) or MPlayerInfo.JobLv
    local pageNum = skillPlanShare and skillPlanShare.plan_id or planId
    if skillPlanShare then
        pageNum = skillPlanShare.plan_id
    else
        pageNum = StringEx.Format("ATTR_PLAN_{0}",planId)
    end
    local proId = MemberBaseInfo and MemberBaseInfo.data.type or MPlayerInfo.ProfessionId
    local data = DataMgr:GetData("SkillData")
    self.panel.SkillPlanName.LabText = Lang("CHAT_SHARE_SKILL_PLAN_NAME",MemberBaseInfo and MemberBaseInfo.data.name or MPlayerInfo.Name,Lang(pageNum))
    local professionRow = TableUtil.GetProfessionTable().GetRowById(proId)
    self.panel.Job:SetSpriteAsync("Common", professionRow.ProfessionIcon)
    self.panel.JobName.LabText = professionRow.Name
    self.panel.JobLevel.LabText = jobLevel
    if skillPlanShare then
        self.panel.AddPoints.LabText = skillPlanShare and skillPlanShare.used_point
        self.panel.LeftPoints.LabText = skillPlanShare and skillPlanShare.unused_point
    else
        local addPoint, leftPoint = data.GetLocalSKillPlanSkillPointInfo(planId)
        self.panel.AddPoints.LabText = addPoint
        self.panel.LeftPoints.LabText = leftPoint
    end
end

function BuildPlanCtrl:RefreshPlanSkills(skillPlanShare, planId, MemberBaseInfo)
    local proId = MemberBaseInfo and MemberBaseInfo.data.type or MPlayerInfo.ProfessionId
    local mgr = MgrMgr:GetMgr("SkillLearningMgr")
    local data = DataMgr:GetData("SkillData")
    skillPlan = skillPlanShare and skillPlanShare.skill_plan
    local skillInfos = {}
    if skillPlan then
        skillInfos = mgr.GetSkillPlanLearnSkillInfos(skillPlan, proId)
    else
        skillPlan = data.GetCurSkillPlan(planId)
        if not skillPlan then return logError("未获取到本地技能方案 ", planId) end
        skillInfos = data.GetLocalSkillPlanLearnSkillInfos(skillPlan, planId)
    end

    self.panel.Skill.gameObject:SetActiveEx(true)
    self.panel.Attr.gameObject:SetActiveEx(false)
    self.panel.MultiSkillTitleLineTemplate.LuaUIGroup.gameObject:SetActiveEx(false)
    self.panel.MultiSkillEmptyLineTemplate.LuaUIGroup.gameObject:SetActiveEx(false)
    self.panel.MultiSkillLineTemplate.LuaUIGroup.gameObject:SetActiveEx(false)

    local harmSkills, assistantSkills = {}, {}
    for i, v in ipairs(skillInfos) do
        local skillId, skillLv = v.skillId, v.skillLv
        local skillSdata = data.GetDataFromTable("SkillTable", skillId)
        if skillSdata then
            if skillSdata.SkillTypeIcon == 0 or skillSdata.SkillTypeIcon == 1 then
                table.insert(harmSkills, { id = skillId, sdata = skillSdata, lv = skillLv })
            elseif skillSdata.SkillTypeIcon == 2 then
                table.insert(assistantSkills, { id = skillSdata.Id, sdata = skillSdata, lv = skillLv })
            end
        end
    end

    local datas = {}
    table.insert(datas, { type = ContentType.Title, name = Lang("MULTI_SKILL_HARMSKILL") })
    if #harmSkills > 0 then
        table.insert(datas, { type = ContentType.Skill, skills = harmSkills })
    else
        table.insert(datas, { type = ContentType.Empty, text = Lang("MULTI_SKILL_EMPTY_LINE") })
    end
    table.insert(datas, { type = ContentType.Title, name = Lang("MULTI_SKILL_ASSISTANTSKILL") })
    if #assistantSkills > 0 then
        table.insert(datas, { type = ContentType.Skill, skills = assistantSkills})
    else
        table.insert(datas, { type = ContentType.Empty, text = Lang("MULTI_SKILL_EMPTY_LINE") })
    end

    if not self.skillLinePool then
        self.skillLinePool = self:NewTemplatePool({
            PreloadPaths = {},
            ScrollRect=self.panel.SkillScroll.LoopScroll,
            GetTemplateAndPrefabMethod=function(data) return self:GetTemplate(data) end,
        })
    end
    self.skillLinePool:ShowTemplates({
        Datas = datas
    })
end

function BuildPlanCtrl:GetTemplate(data)
    local class, prefab
    if data.type == ContentType.Title then
        class, prefab = UITemplate.MultiSkillTitleLineTemplate, self.panel.MultiSkillTitleLineTemplate.LuaUIGroup.gameObject
    elseif data.type == ContentType.Empty then
        class, prefab = UITemplate.MultiSkillEmptyLineTemplate, self.panel.MultiSkillEmptyLineTemplate.LuaUIGroup.gameObject
    elseif data.type == ContentType.Skill then
        class, prefab = UITemplate.MultiSkillLineTemplate, self.panel.MultiSkillLineTemplate.LuaUIGroup.gameObject
    end
    return class, prefab
end


---以下为属性相关----------------------------------------------
--如果显示玩家自己的属性 参数1 发送者的信息数据 nil 参数 2 为nil 参数 3 填写方案 Id 数字 1 2 3
--如果显示别人的属性 参数1 发送者的信息数据 参数2 为QualityPointPageInfo 这个数据结构 后面参数为nil
function BuildPlanCtrl:ShowAttrPlan(MemberBaseInfo,QualityPointPageInfo,playerPageNum)
    self:RefreshAttrHead(QualityPointPageInfo,MemberBaseInfo,playerPageNum)
    self:ShowAttrByData(QualityPointPageInfo,playerPageNum)
end

function BuildPlanCtrl:RefreshAttrHead(QualityPointPageInfo,MemberBaseInfo,playerPageNum)
    local jobLevel = MemberBaseInfo and tonumber(MemberBaseInfo.data.job_level) or MPlayerInfo.JobLv
    local baseLevel = MemberBaseInfo and tonumber(MemberBaseInfo.level) or MPlayerInfo.Lv
    local pageNum = QualityPointPageInfo and QualityPointPageInfo.id or playerPageNum
    if QualityPointPageInfo then
        pageNum = QualityPointPageInfo.id
    else
        pageNum = StringEx.Format("ATTR_PLAN_{0}",playerPageNum)
    end
    local totalQualityPoint,nowCostPoint,leftPoint = MgrMgr:GetMgr("RoleInfoMgr").CalculateQualityPoint(MemberBaseInfo == nil,baseLevel,QualityPointPageInfo)
    self.panel.SkillPlanName.LabText =Lang("PLAYER_ATTR_PLAN",MemberBaseInfo and MemberBaseInfo.data.name or MPlayerInfo.Name,Lang(pageNum))
    local professionRow = TableUtil.GetProfessionTable().GetRowById(MemberBaseInfo and MemberBaseInfo.data.type or MPlayerInfo.ProfessionId)
    self.panel.Job:SetSpriteAsync("Common", professionRow.ProfessionIcon)
    self.panel.JobName.LabText = professionRow.Name
    self.panel.JobLevel.LabText = jobLevel

    self.panel.AddPoints.LabText = nowCostPoint
    self.panel.LeftPoints.LabText = leftPoint
end

function BuildPlanCtrl:ShowAttrByData(QualityPointPageInfo,playerPageNum)
    self.panel.Skill.gameObject:SetActiveEx(false)
    self.panel.Attr.gameObject:SetActiveEx(true)
    self:DestoryAttrObj()

    self.attrTable = self.attrTable or {}
	local attrList = MgrMgr:GetMgr("RoleInfoMgr").GetSortTable()
	--初始化右面板
	self.panel.AttrTpl.gameObject:SetActiveEx(true)
    for i = 1, table.maxn(attrList) do
        --创建UI
        self.attrTable[i] = {}
        self.attrTable[i].ui = self:CloneObj(self.panel.AttrTpl.gameObject)
        self.attrTable[i].ui.transform:SetParent(self.panel.AttrTpl.transform.parent)
        self.attrTable[i].ui.transform:SetLocalScaleOne()
        self:ExportFirstLevelElement(self.attrTable[i])
        --初始化
        local name = attrList[i].name
        self.attrTable[i].name.LabText = name
		self.attrTable[i].attrIcon:SetSprite(attrList[i].atlas,attrList[i].icon, true)
        self:SetAttrData(self.attrTable[i],attrList[i],QualityPointPageInfo,playerPageNum)
	end
	self.panel.AttrTpl.gameObject:SetActiveEx(false)
end

function BuildPlanCtrl:ExportFirstLevelElement(element)
    element.baseAttr = MLuaClientHelper.GetOrCreateMLuaUICom(element.ui.transform:Find("Txt_Base"))
    element.equipAttr = MLuaClientHelper.GetOrCreateMLuaUICom(element.ui.transform:Find("Txt_Equip"))
    element.name = MLuaClientHelper.GetOrCreateMLuaUICom(element.ui.transform:Find("AttrName"))
	element.attrIcon = element.ui.transform:Find("AttrIcon"):GetComponent("MLuaUICom")
	element.attrImg = element.ui.transform:Find("AttrIcon"):GetComponent("Image")
end

function BuildPlanCtrl:SetAttrData( element,attrInfo,QualityPointPageInfo,playerPageNum)
    local roleInfoMgr = MgrMgr:GetMgr("RoleInfoMgr")
    if element and element.ui then
        if playerPageNum == nil then
            local pageInfo,pageId = roleInfoMgr.CalculateQualityPointPageInfo( QualityPointPageInfo )
            local baseAttr = pageInfo[pageId] and pageInfo[pageId].point_list[attrInfo.base] or 0
            element.baseAttr.LabText = baseAttr or "nil"
        else
            local baseAttr = roleInfoMgr.l_qualityPointPageInfo[playerPageNum] and roleInfoMgr.l_qualityPointPageInfo[playerPageNum].point_list[attrInfo.base] or 0
            element.baseAttr.LabText = baseAttr
        end
	end
end

function BuildPlanCtrl:DestoryAttrObj( ... )
	if self.attrTable == nil then return end
	for i=1,#self.attrTable do
		if self.attrTable[i].ui then
			MResLoader:DestroyObj(self.attrTable[i].ui)
		end
		self.attrTable[i] = nil
	end
	self.attrTable = nil
end
--------------------------------------------------------------

--lua custom scripts end
return BuildPlanCtrl