--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseHandler"
require "UI/Panel/SelectElementShowBorderPanel"


--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua class define
local super = UI.UIBaseHandler
SelectElementShowBorderHandler = class("SelectElementShowBorderHandler", super)
--lua class define end

--lua functions
function SelectElementShowBorderHandler:ctor()

	super.ctor(self, HandlerNames.SelectElementShowBorder, 0)

end --func end
--next--
function SelectElementShowBorderHandler:Init()

	self.panel = UI.SelectElementShowBorderPanel.Bind(self)
	super.Init(self)
	self.panel.BtnClear:AddClick(function()
		local l_photographUI = UIMgr:GetUI(UI.CtrlNames.Photograph)
		if l_photographUI == nil or l_photographUI.borderObj == nil then
			return
		end
		Object.Destroy(l_photographUI.borderObj)

		l_photographUI:SetBorder()
	end)

end --func end
--next--
function SelectElementShowBorderHandler:Uninit()

	super.Uninit(self)
	self.panel = nil

end --func end
--next--
function SelectElementShowBorderHandler:OnActive()

	local l_borderTable = TableUtil.GetShowBorderTable().GetTable()
	for _,row in pairs(l_borderTable) do
		self:CreateElement(row)
	end

end --func end
--next--
function SelectElementShowBorderHandler:OnDeActive()

	local l_content = self.panel.Content.transform
	for i=l_content.childCount-1, 1, -1 do
		MResLoader:DestroyObj(l_content:GetChild(i).gameObject)
	end

end --func end
--next--
function SelectElementShowBorderHandler:Update()


end --func end


--next--
function SelectElementShowBorderHandler:BindEvents()

	--dont override this function

end --func end
--next--
--lua functions end

--lua custom scripts
function SelectElementShowBorderHandler:CreateElement(row)

	local l_element = {}
	local l_elementInstance = self.panel.BtnSingleInstance

	local l_elementObj = self:CloneObj(l_elementInstance.gameObject):GetComponent("MLuaUICom")
	l_elementObj.gameObject:SetActiveEx(true)
	local l_elementTran = l_elementObj.transform
	l_elementObj:SetSprite("PhotoIndividualization01", row.Icon)
	l_elementTran:SetParent(self.panel.Content.transform)
	l_elementTran:SetLocalScaleOne()

	l_element.com = l_elementObj
	l_element.gameObject = l_elementObj.gameObject
	l_element.transform = l_elementTran
	l_element.com:AddClick(function()
		local l_photographCtrl = UIMgr:GetUI(UI.CtrlNames.Photograph)
		if l_photographCtrl ~= nil then
			local l_newDecal = l_photographCtrl:ShowBorder(row.Border)
			l_photographCtrl:SetBorder(row.ID)
		end
	end)

	return l_element

end
--lua custom scripts end
