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
---@class MultiAttributeTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field DropAttrParent MoonClient.MLuaUICom
---@field AttrTpl MoonClient.MLuaUICom
---@field AttrName MoonClient.MLuaUICom
---@field AttrIcon MoonClient.MLuaUICom

---@class MultiAttributeTemplate : BaseUITemplate
---@field Parameter MultiAttributeTemplateParameter

MultiAttributeTemplate = class("MultiAttributeTemplate", super)
--lua class define end

--lua functions
function MultiAttributeTemplate:Init()
	
	    super.Init(self)
	    self:InitPanel()
	
end --func end
--next--
function MultiAttributeTemplate:BindEvents()
	
	    self:BindEvent(MgrMgr:GetMgr("MultiTalentMgr").EventDispatcher,MgrMgr:GetMgr("MultiTalentMgr").ReceiveOpenMultiTalentEvent, function()
	        self:RefreshPage()
	    end)
	    self:BindEvent(MgrMgr:GetMgr("MultiTalentMgr").EventDispatcher,MgrMgr:GetMgr("MultiTalentMgr").ReceiveRenameMultiTalentEvent, function()
	        self:RefreshPage()
	    end)
	    self:BindEvent(MgrMgr:GetMgr("MultiTalentMgr").EventDispatcher,MgrMgr:GetMgr("MultiTalentMgr").ReceiveChangeMultiTalentEvent, function()
	        self:RefreshPage()
	    end)
	
end --func end
--next--
function MultiAttributeTemplate:OnDestroy()
	
	    self:DestoryAttrObj()

	
end --func end
--next--
function MultiAttributeTemplate:OnDeActive()
	
	
end --func end
--next--
function MultiAttributeTemplate:OnSetData(data)
	
	
end --func end
--next--
--lua functions end

--lua custom scripts
local roleInfoMgr = MgrMgr:GetMgr("RoleInfoMgr")

function MultiAttributeTemplate:ctor(itemData)
    itemData.Data = {}
    itemData.TemplatePath = "UI/Prefabs/MultiAttributeTemplate"
    super.ctor(self, itemData)
end

function MultiAttributeTemplate:RefreshPage()
    local attrList = roleInfoMgr.GetSortTable()
    for i = 1, table.maxn(attrList) do
        self:SetAttrData(self.firstLevelAttr[i], attrList[i])
    end
end --func end

function MultiAttributeTemplate:InitPanel(...)
    local openSystemMgr=MgrMgr:GetMgr("OpenSystemMgr")
    local functionId=openSystemMgr.eSystemId.AttrMultiTalent
    --初始选择Templete
    if self.multiTalentsSelectTemplate == nil then
        if openSystemMgr.IsSystemOpen(functionId) then
            self.multiTalentsSelectTemplate = self:NewTemplate("MultiTalentsSelectTemplate", {
                TemplateParent = self.Parameter.DropAttrParent.transform
            })
        end
    end
    if self.multiTalentsSelectTemplate then
        self.multiTalentsSelectTemplate:SetData(functionId, { IsOnlyShowSelect = true })
    end
    self.firstLevelAttr = self.firstLevelAttr or {}
    local attrList = roleInfoMgr.GetSortTable()
    --初始化右面板
    self.Parameter.AttrTpl.gameObject:SetActiveEx(true)
    for i = 1, table.maxn(attrList) do
        --创建UI
        self.firstLevelAttr[i] = {}
        self.firstLevelAttr[i].ui = self:CloneObj(self.Parameter.AttrTpl.gameObject)
        self.firstLevelAttr[i].ui.transform:SetParent(self.Parameter.AttrTpl.transform.parent)
        self.firstLevelAttr[i].ui.transform:SetLocalScaleOne()
        self:ExportFirstLevelElement(self.firstLevelAttr[i])
        --初始化
        local name = attrList[i].name
        self.firstLevelAttr[i].name.LabText = name
        self.firstLevelAttr[i].attrIcon:SetSprite(attrList[i].atlas, attrList[i].icon, true)
        self:SetAttrData(self.firstLevelAttr[i], attrList[i])
    end
    self.Parameter.AttrTpl.gameObject:SetActiveEx(false)
end

function MultiAttributeTemplate:ExportFirstLevelElement(element)
    element.baseAttr = MLuaClientHelper.GetOrCreateMLuaUICom(element.ui.transform:Find("Txt_Base"))
    element.equipAttr = MLuaClientHelper.GetOrCreateMLuaUICom(element.ui.transform:Find("Txt_Equip"))
    element.name = MLuaClientHelper.GetOrCreateMLuaUICom(element.ui.transform:Find("AttrName"))
    element.attrIcon = element.ui.transform:Find("AttrIcon"):GetComponent("MLuaUICom")
    element.attrImg = element.ui.transform:Find("AttrIcon"):GetComponent("Image")
end

function MultiAttributeTemplate:SetAttrData(element, attrInfo)
    if element and element.ui then
        local baseAttr = roleInfoMgr.l_qualityPointPageInfo[roleInfoMgr.l_curPage] and roleInfoMgr.l_qualityPointPageInfo[roleInfoMgr.l_curPage].point_list[attrInfo.base] or 0
        local equipAttr = MEntityMgr:GetMyPlayerAttr(attrInfo.equip)
        element.baseAttr.LabText = baseAttr
        element.equipAttr.LabText = "+" .. equipAttr
    end
end

function MultiAttributeTemplate:DestoryAttrObj(...)
    if self.firstLevelAttr == nil then
        return
    end
    for i = 1, #self.firstLevelAttr do
        if self.firstLevelAttr[i].ui then
            MResLoader:DestroyObj(self.firstLevelAttr[i].ui)
        end
        self.firstLevelAttr[i] = nil
    end
    self.firstLevelAttr = nil
    self.multiTalentsSelectTemplate=nil
end
--lua custom scripts end
return MultiAttributeTemplate