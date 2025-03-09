--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/FestivalPanel"
require "UI/Template/LeftActivityTemplate"
--lua requires end

--lua model
module("UI", package.seeall)

--lua model end

--lua fields
local super = UI.UIBaseCtrl
--lua fields end

--lua class define
FestivalCtrl = class("FestivalCtrl", super)
--lua class define end

--lua functions
function FestivalCtrl:ctor()
	
	super.ctor(self, CtrlNames.Festival, UILayer.Function, nil, ActiveType.Exclusive)
	
end --func end
--next--
function FestivalCtrl:Init()
	
	self.panel = UI.FestivalPanel.Bind(self)
	super.Init(self)

	self.mgr = MgrMgr:GetMgr("FestivalMgr")
	self.data = DataMgr:GetData("FestivalData")

	self.panel.BtnClose:AddClick(function()
		UIMgr:DeActiveUI(UI.CtrlNames.Festival)
	end)
	self.rightTemplate = self:NewTemplate("SakuraTemplate", {
		TemplateParent = self.panel.FestivalPanel.Transform,
		TemplatePath = "UI/Prefabs/Sakura",
	})
	self.leftTemplate = self:NewTemplatePool({
		UITemplateClass = UITemplate.LeftActivityTemplate,
		ScrollRect = self.panel.ScrollView.LoopScroll,
		TemplatePrefab = self.panel.LeftActivity.gameObject,
		Method = function(id)
			self:SelectFestival(id)
		end
	})
	self.tweenId = 0
	self:Refresh()
	
end --func end
--next--
function FestivalCtrl:Uninit()
	
	super.Uninit(self)
	self.panel = nil
	
end --func end
--next--
function FestivalCtrl:OnActive()
	
	
end --func end
--next--
function FestivalCtrl:OnDeActive()
	self.data.nowChoose = 0
	if self.tweenId > 0 then
		MUITweenHelper.KillTween(self.tweenId)
		self.tweenId = 0
	end
end --func end
--next--
function FestivalCtrl:Update()
	
	
end --func end
--next--
function FestivalCtrl:BindEvents()

	--刷新所有数据
	self:BindEvent(self.mgr.EventDispatcher, self.mgr.Event.RefreshFestival, function(self)
		self:Refresh()
	end)
	
end --func end
--next--
--lua functions end

--lua custom scripts
function FestivalCtrl:Refresh()

	self.panel.AllText.LabText = Lang(self.data.FestivalFa.name)
	if self.data.FestivalFa.icon and self.data.FestivalFa.icon ~= "" then
		self.panel.AllBackGround:SetRawTex("PrefabBg/" .. self.data.FestivalFa.icon)
	end
	if self.data.Festival and #self.data.Festival > 0 then
		self:SelectFestival()
		local l_data = self.data.Festival
		table.sort(l_data, function(a, b)
			local l_openA = self.mgr.CheckActivityOpen(a.actual_time.first, a.actual_time.second, a.day_times)
			local l_openB = self.mgr.CheckActivityOpen(b.actual_time.first, b.actual_time.second, b.day_times)
			if l_openA == l_openB then
				return a.sort < b.sort
			elseif l_openA then
				return true
			else
				return false
			end
		end)
		self.leftTemplate:ShowTemplates({ Datas = l_data })
	else
		logError("可以打开节日活动界面，但是并没有任何活动！")
	end

end

function FestivalCtrl:SelectFestival(id)

	local l_lastChoose, l_data = self.data.nowChoose, nil
	for i = 1, #self.data.Festival do
		if self.data.Festival[i].id == id then
			l_data = self.data.Festival[i]
			self.data.nowChoose = self.data.Festival[i].sort
		end
	end
	if id == nil or l_data == nil then
		l_data = self.data.Festival[1]
		self.data.nowChoose = self.data.Festival[1].sort
	end

	if self.tweenId > 0 then
		MUITweenHelper.KillTween(self.tweenId)
		self.tweenId = 0
	end
	if self.data.nowChoose ~= l_lastChoose and l_lastChoose ~= 0 then
		self.tweenId = MUITweenHelper.TweenAlpha(self.panel.FestivalPanel.gameObject, 1, 0, 0.5, function()
			self.rightTemplate:SetData(l_data)
			self.tweenId = MUITweenHelper.TweenAlpha(self.panel.FestivalPanel.gameObject, 0, 1, 0.5, function()
				self.tweenId = 0
			end)
		end)
	elseif l_lastChoose == 0 then
		self.rightTemplate:SetData(l_data)
		self.tweenId = MUITweenHelper.TweenAlpha(self.panel.FestivalPanel.gameObject, 0, 1, 0.5, function()
			self.tweenId = 0
		end)
	end

end
--lua custom scripts end
return FestivalCtrl