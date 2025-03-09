--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseHandler"
require "UI/Panel/SelectElementShowDecalPanel"

--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua class define
local super = UI.UIBaseHandler
SelectElementShowDecalHandler = class("SelectElementShowDecalHandler", super)
--lua class define end

--lua functions
function SelectElementShowDecalHandler:ctor()

	super.ctor(self, HandlerNames.SelectElementShowDecal, 0)

end --func end
--next--
function SelectElementShowDecalHandler:Init()

	self.panel = UI.SelectElementShowDecalPanel.Bind(self)
	super.Init(self)

end --func end
--next--
function SelectElementShowDecalHandler:Uninit()

	super.Uninit(self)
	self.panel = nil

end --func end
--next--
function SelectElementShowDecalHandler:OnActive()

	local l_decalTable = TableUtil.GetShowDecalTable().GetTable()
	for _,row in pairs(l_decalTable) do
		self:CreateElement(row)
	end

end --func end
--next--
function SelectElementShowDecalHandler:OnDeActive()
    if self.panel == nil then
        return
    end
	local l_content = self.panel.Content.transform
	for i=l_content.childCount-1, 0, -1 do
		MResLoader:DestroyObj(l_content:GetChild(i).gameObject)
	end

end --func end
--next--
function SelectElementShowDecalHandler:Update()


end --func end


--next--
function SelectElementShowDecalHandler:BindEvents()

	--dont override this function

end --func end
--next--
--lua functions end

--lua custom scripts
function SelectElementShowDecalHandler:CreateElement(row)

	local l_element = {}
	local l_elementInstance = self.panel.BtnSingleInstance
	local l_elementObj = self:CloneObj(l_elementInstance.gameObject)
	l_elementObj:SetActiveEx(true)
	local l_elementTran = l_elementObj.transform

	l_element.com = l_elementObj:GetComponent("MLuaUICom")
	l_element.com:SetSprite("PhotoIndividualization01", row.Icon)
	l_element.gameObject = l_elementObj
	l_element.transform = l_elementTran
	l_elementTran:SetParent(self.panel.Content.transform)
	l_elementTran:SetLocalScaleOne()
	l_element.com:AddClick(function()
		local l_photographCtrl = UIMgr:GetUI(UI.CtrlNames.Photograph)
		if l_photographCtrl ~= nil then
			local l_newDecal = l_photographCtrl:ShowDecal(row.Atlas, row.Decal, row.ID)
		end
	end)

	return l_element

end
--lua custom scripts end
