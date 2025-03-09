--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/TipsCommonPanel"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua class define
local super = UI.UIBaseCtrl
TipsCommonCtrl = class("TipsCommonCtrl", super)
--lua class define end

--lua functions
function TipsCommonCtrl:ctor()

	super.ctor(self, CtrlNames.TipsCommon, UILayer.Normal, UITweenType.Up, ActiveType.Normal)
end --func end
--next--
function TipsCommonCtrl:Init()

	self.panel = UI.TipsCommonPanel.Bind(self)
	super.Init(self)

end --func end
--next--
function TipsCommonCtrl:Uninit()

	super.Uninit(self)
	self.panel = nil

end --func end
--next--
function TipsCommonCtrl:OnActive()

	self:CustomActive()
end --func end
--next--
function TipsCommonCtrl:OnDeActive()


end --func end
--next--
function TipsCommonCtrl:Update()


end --func end

--next--
function TipsCommonCtrl:BindEvents()

	--dont override this function

end --func end

--next--
--lua functions end

--lua custom scripts

--Common tips Ctrl
local m_info
local m_title

function TipsCommonCtrl:CustomActive()
	self.panel.cancelBtn:AddClick(function()
		if self.m_cancelCallBack~=nil then
			self.m_cancelCallBack()
		end
		UIMgr:DeActiveUI(UI.CtrlNames.TipsCommon)
	end)
	self.panel.sureBtn:AddClick(function()
		if self.m_sureCallBack~=nil then
			self.m_sureCallBack()
		end
		UIMgr:DeActiveUI(UI.CtrlNames.TipsCommon)
	end)
	MLuaClientHelper.GetOrCreateMLuaUICom(self.panel.tipsInfoLab.gameObject).LabText = m_info
	MLuaClientHelper.GetOrCreateMLuaUICom(self.panel.tipsTitleLab.gameObject).LabText = m_title
end

function TipsCommonCtrl:SetCommonTips(info,title,sureCallBack,cancelCallBack)
	self.m_sureCallBack = nil
	self.m_sureCallBack = sureCallBack
	self.m_cancelCallBack = nil
	self.m_cancelCallBack = cancelCallBack
	m_info = info
	m_title = title
end

--lua custom scripts end
