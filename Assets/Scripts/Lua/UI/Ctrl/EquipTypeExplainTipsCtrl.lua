--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/EquipTypeExplainTipsPanel"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua fields
local super = UI.UIBaseCtrl
--next--
--lua fields end

--lua class define
EquipTypeExplainTipsCtrl = class("EquipTypeExplainTipsCtrl", super)
--lua class define end

--lua functions
function EquipTypeExplainTipsCtrl:ctor()
	
	super.ctor(self, CtrlNames.EquipTypeExplainTips, UILayer.Function, nil, ActiveType.Standalone)
	
end --func end
--next--
function EquipTypeExplainTipsCtrl:Init()
	
	self.panel = UI.EquipTypeExplainTipsPanel.Bind(self)
	super.Init(self)

	self.panel.CloseExplainPanelButton:AddClick(function()
		UIMgr:DeActiveUI(UI.CtrlNames.EquipTypeExplainTips)
	end)

    self._tipsTemplatePool = self:NewTemplatePool(
    {
        TemplateClassName = "EquipTypeExplainTipsItemTemplate",
        TemplatePrefab=self.panel.EquipTypeExplainTipsItemPrefab.gameObject,
        TemplateParent=self.panel.EquipTypeExplainTipsItemParent.Transform,
        --Method = function(index)
        --    self:_showEquipMakeHoleRecastPanel(index)
        --
        --end
    })

	
end --func end
--next--
function EquipTypeExplainTipsCtrl:Uninit()
	
	super.Uninit(self)
	self.panel = nil

	self._tipsTemplatePool=nil
	
end --func end
--next--
function EquipTypeExplainTipsCtrl:OnActive()
	
	
end --func end
--next--
function EquipTypeExplainTipsCtrl:OnDeActive()
	
	
end --func end
--next--
function EquipTypeExplainTipsCtrl:Update()
	
	
end --func end





--next--
function EquipTypeExplainTipsCtrl:BindEvents()
	
	
end --func end

--next--
--lua functions end

--lua custom scripts
function EquipTypeExplainTipsCtrl:ShowExplainTips(equipWeaponId)
	--self.panel.ExplainText.LabText=string.gsub(text, "\\n", "\n")

	--if position~=nil then
     --   self.panel.TipsTextPosition.gameObject:SetRectTransformPos(position.x,position.y)
	--end

    local l_equipTipsTable = TableUtil.GetEquipTipsTable().GetTable()

    self._tipsTemplatePool:ShowTemplates({
        Datas = l_equipTipsTable,
        AdditionalData=equipWeaponId,
    })
end
--lua custom scripts end
return EquipTypeExplainTipsCtrl