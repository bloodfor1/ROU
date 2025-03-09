--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/BattleTeamPanel"

require "Common.Functions"

--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

local l_mgr = MgrMgr:GetMgr("BattleMgr")
local l_info = {}
local l_item = {}

--lua class define
local super = UI.UIBaseCtrl
BattleTeamCtrl = class("BattleTeamCtrl", super)
--lua class define end

--lua functions
function BattleTeamCtrl:ctor()

	super.ctor(self, CtrlNames.BattleTeam, UILayer.Normal, nil, ActiveType.Normal)

end --func end
--next--
function BattleTeamCtrl:Init()

	self.panel = UI.BattleTeamPanel.Bind(self)
	super.Init(self)

	MgrMgr:GetMgr("BattleMgr").InitTeamInfo()
	self:ShowTeamPanel(MgrMgr:GetMgr("BattleMgr").g_teamInfo,true,nil)

end --func end
--next--
function BattleTeamCtrl:Uninit()

	self:ClearPanel()
	super.Uninit(self)
	self.panel = nil

end --func end
--next--
function BattleTeamCtrl:OnActive()
    self.panel.member.gameObject:SetActiveEx(false)

end --func end
--next--
function BattleTeamCtrl:OnDeActive()


end --func end
--next--
function BattleTeamCtrl:Update()


end --func end

--next--
function BattleTeamCtrl:BindEvents()
	self:BindEvent(MgrMgr:GetMgr("BattleMgr").EventDispatcher,MgrMgr:GetMgr("BattleMgr").ON_UPDATE_HP,function(self,id)
		if l_item[id] then
			l_item[id].item.hpSlider.value = MgrMgr:GetMgr("BattleMgr").g_teamInfo[id].hp
		end
	end)
end --func end
--next--
--lua functions end

--lua custom scripts

--lua custom scripts end

local l_curMask = nil

function BattleTeamCtrl:ShowTeamPanel(info,isCanDrag,clickCallBack)
	l_info = {}
	self:ClearPanel()
	l_info = info
	if table.ro_size(l_info)<1 then
		UIMgr:DeActiveUI(UI.CtrlNames.BattleTeam)
		return
	end
	for i, v in pairs(l_info) do
		local l_target = v
		local l_go = self:CloneObj(self.panel.member.gameObject)
		l_go.transform:SetParent(self.panel.member.gameObject.transform.parent)
		l_go:SetLocalScaleToOther(self.panel.member.gameObject)
		l_go:SetActiveEx(true)

		local l_id = l_target.roleId
		if l_item[l_id] == nil then
			l_item[l_id] = {}
			l_item[l_id].info = l_target
			l_item[l_id].item = {}
		end
		l_item[l_id].item.ui = l_go
		l_item[l_id].item.btn = l_go:GetComponent("MLuaUICom")
		l_item[l_id].item.checkMark = l_go.transform:Find("Checkmark").gameObject
		l_item[l_id].item.checkMark:SetActiveEx(false)
		l_item[l_id].item.nameLab = MLuaClientHelper.GetOrCreateMLuaUICom(l_go.transform:Find("Name"))
		l_item[l_id].item.jobImg = l_go.transform:Find("ImgJob"):GetComponent("MLuaUICom")
		l_item[l_id].item.hpSlider = l_go.transform:Find("SliderHP"):GetComponent("Slider")
		l_item[l_id].item.hpSlider.enabled = true

		local cnt = StringEx.Length(l_target.Name)
		if cnt > 4 then
			l_target.Name = StringEx.SubString(l_target.Name,0,4).."..."
		end

		l_item[l_id].item.nameLab.LabText = l_target.Name
		local imageName = DataMgr:GetData("TeamData").GetProfessionImageById(l_target.professionId)
		if imageName then
			l_item[l_id].item.jobImg:SetSpriteAsync("Common", imageName)
		end

		local l_e = MEntityMgr:GetEntity(l_id, true)
		l_item[l_id].item.hpSlider.value = 0
		if l_e and l_e.AttrRole then
			l_item[l_id].item.hpSlider.value = l_e.AttrRole.HPPercent
		end
		l_item[l_id].item.btn:AddClick(function ()
			if not MLuaCommonHelper.IsNull(l_curMask) then
				l_curMask:SetActiveEx(false)
			end
			l_curMask = l_item[l_id].item.checkMark
			l_curMask:SetActiveEx(true)
			MLuaClientHelper.SelectTargetById(tostring(l_id))
			if clickCallBack then
				clickCallBack(l_item[l_id])
			end
		end)
	end
end

function BattleTeamCtrl:ClearPanel()
	l_curMask = nil
	local l_num = table.ro_size(l_item)
	if l_num>0 then
		for k, v in pairs(l_item) do
			MResLoader:DestroyObj(v.item.ui)
		end
	end
	l_item = {}
end

return BattleTeamCtrl



































