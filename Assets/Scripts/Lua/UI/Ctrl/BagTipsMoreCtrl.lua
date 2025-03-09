--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/BagTipsMorePanel"

--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua class define
local super = UI.UIBaseCtrl
BagTipsMoreCtrl = class("BagTipsMoreCtrl", super)


------------------local var
local l_otherUseType={Compound=3,Split=4,Deal=5}
local l_funBtns={}
local l_funBtnOpen=false
local l_useTypes
-----------------------


--lua class define end

--lua functions
function BagTipsMoreCtrl:ctor()

	super.ctor(self, CtrlNames.BagTipsMore, UILayer.Function, nil, ActiveType.Standalone)
	self.nowPropInfo = nil

end --func end
--next--
function BagTipsMoreCtrl:Init()

	self.panel = UI.BagTipsMorePanel.Bind(self)
	super.Init(self)

end --func end
--next--
function BagTipsMoreCtrl:Uninit()

	super.Uninit(self)
	self.panel = nil

end --func end
--next--
function BagTipsMoreCtrl:OnActive()
	if self.nowPropInfo==nil then
		return
	end
	local l_itemRow = TableUtil.GetItemTable().GetRowByItemID(self.nowPropInfo.TID)
	if l_itemRow==nil then
		return
	end
	l_useTypes = Common.Functions.VectorToTable(l_itemRow.OtherUseType)
	for k,v in ipairs(l_useTypes) do
		if l_funBtns[v]==nil then
			local l_go = self:CloneObj(self.panel.BtnTipMore.gameObject)
			local l_comp=l_go:GetComponent("MLuaUICom")
			local l_text=MoonCommonLib.GameObjectEx.FindObjectInChild(l_go, "Text"):GetComponent("MLuaUICom")
			l_funBtns[v]=l_go
			l_go.transform:SetParent(self.panel.LayoutBtn.gameObject.transform)
			l_go.transform.localScale=self.panel.LayoutBtn.gameObject.transform.localScale
			if v==l_otherUseType.Compound then
				l_text.LabText=Common.Utils.Lang("BAG_TIP_COMPOUND")
				l_comp:AddClick(function()
					self:CompoundFunc()
				end)
			elseif v==l_otherUseType.Split then
				l_text.LabText=Common.Utils.Lang("BAG_TIP_SPLIT")
				l_comp:AddClick(function()
					self:SplitFunc()
				end)
			elseif v==l_otherUseType.Deal then
				l_text.LabText=Common.Utils.Lang("BAG_TIP_DEAL")
				l_comp:AddClick(function()
					self:DealFunc()
				end)
			end
			l_go:SetActiveEx(false)
		end
	end
	l_funBtnOpen=false
	for k,v in pairs(l_funBtns) do
		v:SetActiveEx(false)
	end
	if l_useTypes[1]==0 then
		--UIMgr:DeActiveUI(UI.CtrlNames.BagTipsMore)
	elseif #l_useTypes==1 then
		self.panel.BtnTipMore.gameObject:SetActiveEx(false)
		l_funBtns[l_useTypes[1]]:SetActiveEx(true)
	else
		self.panel.BtnTipMore.gameObject:SetActiveEx(true)
		self.panel.BtnTipMore.gameObject.transform:SetParent(nil)
		self.panel.BtnTipMore.gameObject.transform:SetParent(self.panel.LayoutBtn.gameObject.transform)
		self.panel.BtnTipMore:AddClick(function()
			l_funBtnOpen=(l_funBtnOpen~=true)
			for k,v in pairs(l_useTypes) do
				l_funBtns[v]:SetActiveEx(l_funBtnOpen)
			end
		end)
	end
end --func end
--next--
function BagTipsMoreCtrl:OnDeActive()
	for k,v in pairs(l_funBtns) do
		MResLoader:DestroyObj(v)
	end
	l_funBtns={}
end --func end
--next--
function BagTipsMoreCtrl:Update()

end --func end


--next--
function BagTipsMoreCtrl:BindEvents()

	--dont override this function

end --func end

--next--
--lua functions end

--lua custom scripts
function BagTipsMoreCtrl:CompoundFunc()
	MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("BAG_TIP_NO_FUNCTION"))
end

function BagTipsMoreCtrl:SplitFunc()
	MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("BAG_TIP_NO_FUNCTION"))
end

function BagTipsMoreCtrl:DealFunc()
	MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("BAG_TIP_NO_FUNCTION"))
end

--lua custom scripts end
