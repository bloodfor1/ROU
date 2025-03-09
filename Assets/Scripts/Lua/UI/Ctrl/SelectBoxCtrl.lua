--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/SelectBoxPanel"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua fields
local super = UI.UIBaseCtrl
--next--
--lua fields end

--lua class define
SelectBoxCtrl = class("SelectBoxCtrl", super)
--lua class define end

--lua functions
function SelectBoxCtrl:ctor()

	super.ctor(self, CtrlNames.SelectBox, UILayer.Function, nil, ActiveType.Standalone)

end --func end
--next--
function SelectBoxCtrl:Init()

	self.panel = UI.SelectBoxPanel.Bind(self)
	super.Init(self)

	self._yesMethod=nil
	self._currentSelectData=nil

	self._selectBoxCellTemplatePool = self:NewTemplatePool(
	{
		TemplateClassName = "SelectBoxCellTemplate",
		TemplatePrefab=self.panel.SelectBoxCellPrefab.LuaUIGroup.gameObject,
		TemplateParent=self.panel.SelectBoxCellParent.Transform,
		Method = function(index)
			self:_onBoxCellTemplate(index)
		end
	})

	self.panel.CloseButton:AddClick(function()
		self:_closePanel()
	end)
	self.panel.CloseBgButton:AddClick(function()
		self:_closePanel()
	end)
	self.panel.NoButton:AddClick(function()
		self:_closePanel()
	end)
	self.panel.YesButton:AddClick(function()
		if self._yesMethod then
			self._yesMethod(self._currentSelectData)
		end
		self:_closePanel()
	end)

end --func end
--next--
function SelectBoxCtrl:Uninit()

	super.Uninit(self)
	self.panel = nil

end --func end
--next--
function SelectBoxCtrl:OnActive()


end --func end
--next--
function SelectBoxCtrl:OnDeActive()
	self._currentSelectData=nil
	self._yesMethod=nil

end --func end
--next--
function SelectBoxCtrl:Update()


end --func end





--next--
function SelectBoxCtrl:BindEvents()


end --func end

--next--
--lua functions end

--lua custom scripts
function SelectBoxCtrl:ShowSelectBox(datas,yesMethod)

	self._yesMethod=yesMethod

	if #datas==0 then
		return
	end
	self._selectBoxCellTemplatePool:ShowTemplates({Datas = datas})
	self._selectBoxCellTemplatePool:SelectTemplate(1)
	self._currentSelectData=datas[1]

end

function SelectBoxCtrl:_onBoxCellTemplate(index)

	self._currentSelectData= self._selectBoxCellTemplatePool:getData(index)
	self._selectBoxCellTemplatePool:SelectTemplate(index)
end

function SelectBoxCtrl:_closePanel()
	UIMgr:DeActiveUI(UI.CtrlNames.SelectBox)
end
--lua custom scripts end
