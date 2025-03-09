--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/CreateCharPanel"
--lua requires end

--lua model
module("UI", package.seeall)

--lua model end

--lua fields
local super = UI.UIBaseCtrl
--lua fields end

--lua class define
---@class CreateCharCtrl : UIBaseCtrl
CreateCharCtrl = class("CreateCharCtrl", super)
--lua class define end

local l_nowEyeID = 0
local l_nowEyeColorID = 0
local l_nowHairID = 0
local l_nowHairColorID = 0
local l_mgr = MgrMgr:GetMgr("SelectRoleMgr")
local l_data = DataMgr:GetData("SelectRoleData")
local l_beautyMgr = MgrMgr:GetMgr("BeautyShopMgr")
--lua functions
function CreateCharCtrl:ctor()
	
	super.ctor(self, CtrlNames.CreateChar, UILayer.Function, nil, ActiveType.Exclusive)
	
end --func end
--next--
function CreateCharCtrl:Init()
	
	self.panel = UI.CreateCharPanel.Bind(self)
	super.Init(self)

	l_beautyMgr.SynEyeInfo()
	self.g_hairInfo = MPlayerInfo.HairStyle
	l_nowEyeID = l_beautyMgr.g_eyeInfo.eyeID
	l_nowEyeColorID = l_beautyMgr.g_eyeInfo.eyeColorID
	local l_table = TableUtil.GetBarberStyleTable().GetTable()
	self.hairIndexTable = {}
	for k, v in ipairs(l_table) do
		local l_styleId = v.BarberStyleID
		local l_barberId = v.BarberID
		local l_colorIdx = v.Colour
		if self.hairIndexTable[l_barberId] == nil then
			self.hairIndexTable[l_barberId] = {}
		end
		self.hairIndexTable[l_barberId][l_colorIdx] = l_styleId
	end

	self.panel.BtnReturnGender:AddClick(function()
		UIMgr:DeActiveUI(UI.CtrlNames.CreateChar)
	end)
    self.panel.Enter:AddClick(function()
        local l_hair = self:GetHairTableID(l_nowHairID, l_nowHairColorID)
        if l_hair ~= -1 then
            l_mgr.ChangeStyle(l_hair, l_nowEyeID, l_nowEyeColorID)
        end
    end)
	self:UpdateColorSelect()

	self.panel.PanelEditHair:SetActiveEx(true)
	self.panel.PanelEditEye:SetActiveEx(true)
	self.eyeTogTemplatePool = self:NewTemplatePool({
		UITemplateClass = UITemplate.CreateCharTogTemplate,
		TemplateParent = self.panel.EyeTogs.transform,
		TemplatePrefab = self.panel.CreateCharTogTemplate.gameObject,
	})
	self.hairTogTemplatePool = self:NewTemplatePool({
		UITemplateClass = UITemplate.CreateCharTogTemplate,
		TemplateParent = self.panel.HairTogs.transform,
		TemplatePrefab = self.panel.CreateCharTogTemplate.gameObject,
	})
	self:ResetEyeEditor()
	self:ResetHairEditor()
	self.panel.EyeScrolls:SetScrollRectGameObjListener(self.panel.ImageUp1.gameObject, self.panel.ImageDown1.gameObject, nil, nil)
	self.panel.HairScrolls:SetScrollRectGameObjListener(self.panel.ImageUp2.gameObject, self.panel.ImageDown2.gameObject, nil, nil)
	
end --func end
--next--
function CreateCharCtrl:Uninit()
	
	if self.panel.HairColors and self.panel.HairColors.gameObject then
		local l_scroll = self.panel.HairColors.gameObject:GetComponent("UIBarberScroll")
		if l_scroll then
			l_scroll.OnValueChanged = nil
		end
	end


	super.Uninit(self)
	self.panel = nil

	self.eyeTogTemplatePool = nil
	self.hairTogTemplatePool = nil
	self.hairColorTemplatePool = nil
	self.eyeColorTemplatePool = nil
	self.hairIndexTable = nil

end --func end
--next--
function CreateCharCtrl:OnActive()

	MEntityMgr.HideNpcAndRole = true
	MPlayerInfo:FocusOffSetView(4)
	MgrMgr:GetMgr("BeautyShopMgr").AddDragListener(self.panel.BGbtn.gameObject,
		function(data)
			if self.lastPoint == nil then
				self.lastPoint = data.position.x
				return
			end
			local l_dis = self.lastPoint - data.position.x
			self.lastPoint = data.position.x
			MgrMgr:GetMgr("BeautyShopMgr").UpdatePlayerRotation(l_dis)
		end,
		function()
			self.lastPoint = nil
		end)

end --func end
--next--
function CreateCharCtrl:OnDeActive()

	MPlayerInfo:FocusToMyPlayer()
	MEntityMgr.HideNpcAndRole = false
	self:UpdatePlayer(false)

end --func end
--next--
function CreateCharCtrl:Update()
	
	
end --func end
--next--
function CreateCharCtrl:BindEvents()
	
	
end --func end
--next--
--lua functions end

--lua custom scripts
function CreateCharCtrl:ResetEyeEditor()

	local l_sex = MPlayerInfo.IsMale and 0 or 1
	local l_allBarberInfo = MgrMgr:GetMgr("BeautyShopMgr").GetAllEyeData()

	local l_group = self.panel.EyeTogs.TogGroup
	local l_count = 0
	local l_data = {}
	local l_selectIndex = 0
	for i, v in ipairs(l_allBarberInfo) do
		if v.SexLimit == l_sex and v.UsedForCreate then
			l_count = l_count + 1
			local l_selected = v.EyeID == l_beautyMgr.g_eyeInfo.eyeID
			table.insert(l_data, {
				id = v.EyeID,
				index = l_count,
				selected = l_selected,
				atlas = v.EyeAtlas,
				icon = v.EyeIcon,
				name = v.EyeName,
				group = l_group,
			})
			if l_selected then
				l_selectIndex = l_count
			end
		end
	end

	self.eyeTogTemplatePool:ShowTemplates({ Datas = l_data, Method = function(eyeId, idx)
		l_nowEyeID = eyeId
		self:UpdatePlayer(true)
	end })

	local l_scroll = self.panel.EyeColorBar.gameObject:GetComponent("UIBarberScroll")
	l_scroll.OnValueChanged = function(idx)
		l_nowEyeColorID = idx + 1
		self:UpdatePlayer(true)
	end
	self.panel.Notice2.gameObject:SetActiveEx(#l_data > 6)

end

function CreateCharCtrl:ResetHairEditor()

	local l_sex = MPlayerInfo.IsMale and 0 or 1
	local l_barberTables = TableUtil.GetBarberTable().GetTable()
	local l_curStyleRow = TableUtil.GetBarberStyleTable().GetRowByBarberStyleID(self.g_hairInfo)
	local l_group = self.panel.HairTogs.TogGroup

	local l_index = 0
	local l_data = {}
	local l_selectIndex = 0
	for i, v in ipairs(l_barberTables) do
		if v.SexLimit == l_sex and v.UsedForCreate then
			l_index = l_index + 1
			local l_selected = v.BarberID == l_curStyleRow.BarberID
			table.insert(l_data, {
				id = v.BarberID,
				index = l_index,
				selected = l_selected,
				atlas = v.BarberAtlas,
				icon = v.BarberIcon,
				name = v.BarberName,
				group = l_group,
			})
			if l_selected then
				l_selectIndex = l_index
			end
		end
	end

	self.hairTogTemplatePool:ShowTemplates({ Datas = l_data, Method = function(barberId, idx)
		l_nowHairID = barberId
		self:UpdatePlayer(true, true)
	end })

	local l_scroll = self.panel.HairColors.gameObject:GetComponent("UIBarberScroll")
	l_scroll.OnValueChanged = function(idx)
		l_nowHairColorID = idx + 1
		self:UpdatePlayer(true, true)
	end
	self.panel.Notice1.gameObject:SetActiveEx(#l_data > 6)

end

function CreateCharCtrl:UpdatePlayer(state, isHair)

    if state then
		if isHair then
			MEntityMgr.PlayerEntity.AttrComp:SetHair(self:GetHairTableID(l_nowHairID, l_nowHairColorID))
		else
			MEntityMgr.PlayerEntity.AttrComp:SetEyeColor(l_nowEyeColorID)
			MEntityMgr.PlayerEntity.AttrComp:SetEye(l_nowEyeID)
		end
    else
        MEntityMgr.PlayerEntity.AttrComp:SetEyeColor(l_beautyMgr.g_eyeInfo.eyeColorID)
        MEntityMgr.PlayerEntity.AttrComp:SetEye(l_beautyMgr.g_eyeInfo.eyeID)
		MEntityMgr.PlayerEntity.AttrComp:SetHair(self.g_hairInfo)
    end

end

function CreateCharCtrl:GetHairTableID(hairId, hairColorId)

    local l_tmp = self.hairIndexTable[hairId]
    if l_tmp == nil then
        logError("不存在对应头发类型：", hairId)
        return -1
    end
    if l_tmp[hairColorId] == nil then
        logError("对应头发类型不存在对应颜色：", hairId, hairColorId)
        return -1
    end
    return l_tmp[hairColorId]

end

function CreateCharCtrl:UpdateColorSelect()

	if not self.eyeColorTemplatePool then
		self.eyeColorTemplatePool = self:NewTemplatePool({
			UITemplateClass = UITemplate.BarberColorTemplate,
			TemplateParent = self.panel.EyeColorBar.transform,
			TemplatePrefab = self.panel.BarberColorTemplate.gameObject,
		})
		local l_datas = { 1, 2, 3, 10, 6, 7, 11, 5, 15, 16 }
		local l_result = {}
		for i, v in ipairs(l_datas) do
			table.insert(l_result, {
				index = i,
				colorIndex = v,
			})
		end
		local l_scroll = self.panel.EyeColorBar.gameObject:GetComponent("UIBarberScroll")
		l_scroll.CurrentIndex = l_beautyMgr.g_eyeInfo.eyeColorID - 1
		self.eyeColorTemplatePool:ShowTemplates({ Datas = l_result })
	end
	if not self.hairColorTemplatePool then
		self.hairColorTemplatePool = self:NewTemplatePool({
			UITemplateClass = UITemplate.BarberColorTemplate,
			TemplateParent = self.panel.HairColors.transform,
			TemplatePrefab = self.panel.BarberColorTemplate.gameObject,
		})
		local l_datas = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16 }
		local l_result = {}
		for i, v in ipairs(l_datas) do
			table.insert(l_result, {
				index = i,
				colorIndex = v,
			})
		end
		local l_curStyleRow = TableUtil.GetBarberStyleTable().GetRowByBarberStyleID(self.g_hairInfo)
		local l_scroll = self.panel.HairColors.gameObject:GetComponent("UIBarberScroll")
		l_nowHairColorID = l_curStyleRow.Colour
		l_nowHairID = l_curStyleRow.BarberID
		l_scroll.CurrentIndex = l_curStyleRow.Colour - 1
		self.hairColorTemplatePool:ShowTemplates({ Datas = l_result })
	end

end

--lua custom scripts end
return CreateCharCtrl