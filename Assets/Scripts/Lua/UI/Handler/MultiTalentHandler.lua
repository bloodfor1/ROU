--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseHandler"
require "UI/Panel/MultiTalentPanel"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua fields
local super = UI.UIBaseHandler
l_multiTalentMgr = MgrMgr:GetMgr("MultiTalentMgr")
l_defaultOpenId = l_multiTalentMgr.l_equipMultiTalent
l_defaultPlanId = 1
--next--
--lua fields end

--lua class define
MultiTalentHandler = class("MultiTalentHandler", super)
--lua class define end

--lua functions
function MultiTalentHandler:ctor()
	
	super.ctor(self, HandlerNames.MultiTalent, 0)
	
end --func end
--next--
function MultiTalentHandler:Init()
	
	self.panel = UI.MultiTalentPanel.Bind(self)
	super.Init(self)

	self.currentToggle=nil

	self:InitMultiFuncButton()
	
end --func end
--next--
function MultiTalentHandler:Uninit()
	
	super.Uninit(self)
	self:UnInitAllData()
	self.panel = nil
	
end --func end
--next--
function MultiTalentHandler:OnActive()

end --func end
--next--
function MultiTalentHandler:OnDeActive()
	self.currentToggle=nil
end --func end
--next--
function MultiTalentHandler:Update()
	
	
end --func end


--next--
function MultiTalentHandler:OnShow()
	if self.currentToggle then
		self.currentToggle.Tog.isOn = false
		self.currentToggle.Tog.isOn = true
	end
end --func end

--next--
function MultiTalentHandler:BindEvents()
	self:BindEvent(MgrMgr:GetMgr("MultiTalentMgr").EventDispatcher,MgrMgr:GetMgr("MultiTalentMgr").ReceiveOpenMultiTalentEvent, self.RefreshBtnInfo)
	self:BindEvent(MgrMgr:GetMgr("MultiTalentMgr").EventDispatcher,MgrMgr:GetMgr("MultiTalentMgr").ReceiveRenameMultiTalentEvent, self.RefreshBtnInfo)
	self:BindEvent(MgrMgr:GetMgr("MultiTalentMgr").EventDispatcher,MgrMgr:GetMgr("MultiTalentMgr").ReceiveChangeMultiTalentEvent, self.RefreshBtnInfo)
end --func end
--next--
--lua functions end

--lua custom scripts
--初始化功能按钮
function MultiTalentHandler:InitMultiFuncButton( ... )
	self.MultiFuncButtons = self.MultiFuncButtons or {}
	for i=1,#l_multiTalentMgr.l_multiTalentIdTable do
		local cSysId = l_multiTalentMgr.l_multiTalentIdTable[i]
		local multiTableData = l_multiTalentMgr.l_multiTalentTableData[cSysId][l_defaultPlanId]
		self.MultiFuncButtons[i] = {}
        self.MultiFuncButtons[i].ui = self:CloneObj(self.panel.ButtonTem.gameObject)
        self.MultiFuncButtons[i].ui.transform:SetParent(self.panel.ButtonTem.transform.parent)
        self.MultiFuncButtons[i].ui.transform:SetLocalScaleOne()
		self.MultiFuncButtons[i].ui:SetActiveEx(true)
		self.MultiFuncButtons[i].data = multiTableData

        local l_parent
        if cSysId==l_multiTalentMgr.l_equipMultiTalent then
            l_parent=self.panel.BodyEquipParent.transform
        else
            l_parent=self.panel.MultiTalent.transform
        end

		self.MultiFuncButtons[i].template = self:NewTemplate(multiTableData.Template,{TemplateParent=l_parent})
		self:ExportElement(self.MultiFuncButtons[i])
		self:SetButtonInfoByData(self.MultiFuncButtons[i])
		self.MultiFuncButtons[i].template:AddLoadCallback(function()
			self:SerTemplate(self.MultiFuncButtons[i])
        end)

	end
	self.panel.ButtonTem.gameObject:SetActiveEx(false)
end

function MultiTalentHandler:ExportElement( element )
	element.MultiTog = element.ui.transform:GetComponent("MLuaUICom")
	element.MultiSelect = element.ui.transform:Find("SelectImg"):GetComponent("MLuaUICom")
	element.MultiIcon = element.ui.transform:Find("MultiIcon"):GetComponent("MLuaUICom")
	element.MultiText = element.ui.transform:Find("MultiText"):GetComponent("MLuaUICom")
end

function MultiTalentHandler:SetButtonInfoByData( element )
	local preName = self:GetPreTxt(element.data.SystemId)
	element.MultiText.LabText = preName..l_multiTalentMgr.GetTalentNameWithFunction(element.data.SystemId) or preName..Lang(element.data.Name)
	element.MultiIcon:SetSpriteAsync(element.data.Atlas,element.data.Icon)
	element.MultiSelect.gameObject:SetActiveEx(false)
end

function MultiTalentHandler:SerTemplate( element )
	element.template:SetGameObjectActive(false)
	element.MultiTog:OnToggleChanged(function(state)
		element.template:SetGameObjectActive(state)
		element.MultiSelect.gameObject:SetActiveEx(state)
		if element.template.RefreshPage then
			element.template:RefreshPage() 
		end
		if state then
			self.currentToggle = element.MultiTog
		end
	end)
	if tonumber(element.data.SystemId) == l_defaultOpenId then
		element.MultiTog.Tog.isOn = true
		self.currentToggle = element.MultiTog
	end
end

function MultiTalentHandler:SetBtnInfo( element )
	local preName = self:GetPreTxt(element.data.SystemId)
	element.MultiText.LabText = preName..l_multiTalentMgr.GetTalentNameWithFunction(element.data.SystemId) or preName..Lang(element.data.Name)
	element.MultiIcon:SetSpriteAsync(element.data.Atlas,element.data.Icon)
end

function MultiTalentHandler:GetPreTxt( SystemId )
	if SystemId == l_multiTalentMgr.l_skillMultiTalent then
        return Lang("MULTI_SKILL_NAME")..": "
    end
    if SystemId == l_multiTalentMgr.l_attrMultiTalent then
		return Lang("MULTI_ATTR_NAME")..": "
    end
    if SystemId == l_multiTalentMgr.l_equipMultiTalent then
		return Lang("ATTR_EQUIP_NAME")..": "
	end
	return ""
end

--右侧切换逻辑
function MultiTalentHandler:InitMultiObject( ... )
	self.MultiGameObject = self.MultiGameObject
end

function MultiTalentHandler:UnInitAllData( ... )
	for i=1,#self.MultiFuncButtons do
		if self.MultiFuncButtons[i].ui then
			MResLoader:DestroyObj(self.MultiFuncButtons[i].ui)
		end
		if self.MultiFuncButtons[i].template then
			--self:UninitTemplate(self.MultiFuncButtons[i].template)
		end
		self.MultiFuncButtons[i] = nil
	end
	self.MultiFuncButtons = nil
end

function MultiTalentHandler:RefreshBtnInfo( ... )
	if self.MultiFuncButtons and table.ro_size(self.MultiFuncButtons) >0 then
		for i=1,#l_multiTalentMgr.l_multiTalentIdTable do
			self:SetBtnInfo(self.MultiFuncButtons[i])
		end
	end
end
--lua custom scripts end
return MultiTalentHandler