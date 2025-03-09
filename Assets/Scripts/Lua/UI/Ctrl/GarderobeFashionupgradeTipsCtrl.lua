--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/GarderobeFashionupgradeTipsPanel"
--lua requires end

--lua model
module("UI", package.seeall)

--lua model end

--lua fields
local super = UI.UIBaseCtrl
--lua fields end

--lua class define
---@class GarderobeFashionupgradeTipsCtrl : UIBaseCtrl
GarderobeFashionupgradeTipsCtrl = class("GarderobeFashionupgradeTipsCtrl", super)
--lua class define end

--lua functions
function GarderobeFashionupgradeTipsCtrl:ctor()
	
	super.ctor(self, CtrlNames.GarderobeFashionupgradeTips, UILayer.Function, nil, ActiveType.None)
	self.GroupMaskType = GroupMaskType.Show
	self.MaskColor=BlockColor.Dark
	self.ClosePanelNameOnClickMask=UI.CtrlNames.GarderobeFashionupgradeTips

end --func end
--next--
function GarderobeFashionupgradeTipsCtrl:Init()
	
	self.panel = UI.GarderobeFashionupgradeTipsPanel.Bind(self)
	super.Init(self)
	self.ID = 0
	MgrMgr:GetMgr("RedSignMgr").UpdateRedSign(eRedSignKey.FashionAward)
end --func end
--next--
function GarderobeFashionupgradeTipsCtrl:Uninit()
	
	super.Uninit(self)
	self.panel = nil
	
end --func end
--next--
function GarderobeFashionupgradeTipsCtrl:OnActive()


	local row = TableUtil.GetGarderobeAwardTable().GetRowByID(self.ID,true)
	if row.AwardId  > 0 then
		self.panel.Tips.gameObject:SetActiveEx(true)
	else
		self.panel.Tips.gameObject:SetActiveEx(false)
	end
	self.panel.LV.LabText = row.ID
	local attrs = Common.Functions.VectorSequenceToTable(row.AddAttr)
	local ret = ""
	for i, v in ipairs(attrs) do
		local attr = {type = v[1], id = v[2], val = v[3]}
		if attr.type and attr.id and attr.val then
			ret = ret .. (i > 1 and "\n" or "") .. MgrMgr:GetMgr("EquipMgr").GetAttrStrByData(attr)
		end
	end
	self.panel.Bonus.LabText = ret

	local str = "Effects/Prefabs/Creature/Ui/Fx_UI_MoWuTuJian_DengJiTiShen"
	if not IsEmptyOrNil(str) then
		local rawImg = self.panel.bg.transform:GetComponent("RawImage")
		self:CreateUIEffect(str, {
			rawImage = rawImg,
			ScaleFac = Vector3.New(2, 2, 2)
		})
	end

	self.panel.bg:AddClick(function()

		UIMgr:DeActiveUI(UI.CtrlNames.GarderobeFashionupgradeTips)
	end)
end --func end
--next--
function GarderobeFashionupgradeTipsCtrl:OnDeActive()
	
	
end --func end
--next--
function GarderobeFashionupgradeTipsCtrl:Update()
	
	
end --func end
--next--
function GarderobeFashionupgradeTipsCtrl:BindEvents()

	
end --func end

--next--
function GarderobeFashionupgradeTipsCtrl:SetInfo(ID)
	self.ID = ID

end --func end

--next--
--lua functions end

--lua custom scripts

--lua custom scripts end
return GarderobeFashionupgradeTipsCtrl