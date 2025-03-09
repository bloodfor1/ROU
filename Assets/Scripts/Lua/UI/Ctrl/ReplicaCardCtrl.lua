--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/ReplicaCardPanel"
--lua requires end

--lua model
module("UI", package.seeall)

--lua model end

--lua fields
local super = UI.UIBaseCtrl
--lua fields end

--lua class define
ReplicaCardCtrl = class("ReplicaCardCtrl", super)
--lua class define end

--lua functions
function ReplicaCardCtrl:ctor()

	super.ctor(self, CtrlNames.ReplicaCard, UILayer.Tips, nil, ActiveType.Standalone)

end --func end
--next--
function ReplicaCardCtrl:Init()
	---@type ReplicaCardPanel
	self.panel = UI.ReplicaCardPanel.Bind(self)
	super.Init(self)
	---@type ItemData
	self.replicaCardPropInfo = nil
	---@type ModuleMgr.CapraCardMgr
	self.capraMgr = MgrMgr:GetMgr("CapraCardMgr")

	self.panel.Btn_Bg:AddClickWithLuaSelf(self.Close,self,true)
	self.panel.Btn_ChangeCardState:AddClickWithLuaSelf(self.onBtnChangeCardState,self,true)
	self.panel.Btn_explain:AddClickWithLuaSelf(self.onBtnExplain,self,true)
	self.panel.Btn_Compound:AddClickWithLuaSelf(self.onBtnCompound,self,true)
end --func end
--next--
function ReplicaCardCtrl:Uninit()

	super.Uninit(self)
	self.panel = nil

end --func end
--next--
function ReplicaCardCtrl:OnActive()
	if self.uiPanelData~=nil then
		if self.uiPanelData.propInfo then
			self.replicaCardPropInfo = self.uiPanelData.propInfo
		end
	end

	self:refreshCardInfo()
end --func end
--next--
function ReplicaCardCtrl:OnDeActive()
	self.replicaCardPropInfo = nil

end --func end
--next--
function ReplicaCardCtrl:Update()

end --func end
--next--
function ReplicaCardCtrl:BindEvents()
	local gameEventMgr = MgrMgr:GetMgr("GameEventMgr")
	self:BindEvent(gameEventMgr.l_eventDispatcher, gameEventMgr.OnBagUpdate, self.refreshCardInfo)
end --func end
--next--
--lua functions end

--lua custom scripts
function ReplicaCardCtrl:refreshCardInfo()
	if self.replicaCardPropInfo==nil then
		return
	end
	local l_composeItem = TableUtil.GetComposeTable().GetRowByConsumableID(self.replicaCardPropInfo.TID, true)
	self.panel.Btn_Compound:SetActiveEx(l_composeItem~=nil)
	self.panel.TogEx_Start.TogEx.isOn = self.replicaCardPropInfo.IsUsing
	self.panel.Txt_Name.LabText = self.replicaCardPropInfo.ItemConfig.ItemName
	self.panel.Txt_RemainNum.LabText = self.replicaCardPropInfo:GetRemainUseCount()
end

function ReplicaCardCtrl:onBtnChangeCardState()
	self.capraMgr.TryChangeReplicaCardState(self.replicaCardPropInfo)
end

function ReplicaCardCtrl:onBtnExplain()
	if self.replicaCardPropInfo==nil then
		return
	end
	local l_content = self.replicaCardPropInfo.ItemConfig.ItemDescription
	MgrMgr:GetMgr("TipsMgr").ShowExplainPanelTips({
		content = l_content,
		alignment = UnityEngine.TextAnchor.UpperLeft,
		pivot = Vector2.New(0,1),
		anchoreMin=Vector2.New(0.5,0.5),
		anchoreMax=Vector2.New(0.5,0.5),
		downwardAdapt = true,
		overideSort =UI.UILayerSort.Tips+1,
		relativeLeftPos=
		{
			canOffset = false,
			screenPos=MUIManager.UICamera:WorldToScreenPoint(self.panel.Obj_ExplainPosMark.Transform.position)
		},
		width = 200,
	})
end

function ReplicaCardCtrl:onBtnCompound()
	--- uid为0说明道具未获得，功能不可用
	if self.replicaCardPropInfo==nil or self.replicaCardPropInfo.UID==0 then
		return
	end
	local l_openSysMgr = MgrMgr:GetMgr("OpenSystemMgr")
	if not l_openSysMgr.IsSystemOpen(l_openSysMgr.eSystemId.Forge) then
		MgrMgr:GetMgr("TipsMgr").ShowNormalTips(l_openSysMgr.GetOpenSystemTipsInfo(l_openSysMgr.eSystemId.Forge))
		return
	end

	local l_itemFuncUtil = MgrProxy:GetItemDataFuncUtil()
	local l_canCompound = l_itemFuncUtil.IsItemCanCompound(self.replicaCardPropInfo)
	if not l_canCompound then
		MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("CANNOT_COMPOUND_REPLICA_CARD"))
		return
	end

	local l_needSelectItemID = self.replicaCardPropInfo.TID
	UIMgr:ActiveUI(UI.CtrlNames.EquipElevate, function(ctrl)
		ctrl:SelectOneHandler(UI.HandlerNames.Compound, function(hander)
			hander:SelectTargetMaterials(l_needSelectItemID)
		end)
	end)
	self:Close()
end
--lua custom scripts end
return ReplicaCardCtrl