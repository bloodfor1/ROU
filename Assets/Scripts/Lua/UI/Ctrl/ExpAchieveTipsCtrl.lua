--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/ExpAchieveTipsPanel"

--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua class define
local super = UI.UIBaseCtrl
ExpAchieveTipsCtrl = class("ExpAchieveTipsCtrl", super)
--lua class define end

--lua functions
function ExpAchieveTipsCtrl:ctor()

	super.ctor(self, CtrlNames.ExpAchieveTips, UILayer.Function, UITweenType.UpAlpha, ActiveType.Standalone)

end --func end
--next--
function ExpAchieveTipsCtrl:Init()
	self.achieveData = {}
	self.achieveData[1] = MgrMgr:GetMgr("OpenSystemMgr").eSystemId.Delegate
	self.achieveData[2] = MgrMgr:GetMgr("OpenSystemMgr").eSystemId.LevelUp
	self.achieveData[3] = MgrMgr:GetMgr("OpenSystemMgr").eSystemId.Task
	self.achieveData[4] = MgrMgr:GetMgr("OpenSystemMgr").eSystemId.Risk
	self.achieveDataUI = {}
	self.panel = UI.ExpAchieveTipsPanel.Bind(self)
	super.Init(self)
	self.panel.CloseButton:AddClick(function()
		UIMgr:DeActiveUI(UI.CtrlNames.ExpAchieveTips)
	end)

end --func end
--next--
function ExpAchieveTipsCtrl:Uninit()
	super.Uninit(self)
	self.panel = nil
end --func end
--next--
function ExpAchieveTipsCtrl:OnActive()


end --func end
--next--
function ExpAchieveTipsCtrl:OnDeActive()
	self:DestoryExpObject()
	self.achieveData = {}
end --func end
--next--
function ExpAchieveTipsCtrl:Update()


end --func end



--next--
function ExpAchieveTipsCtrl:BindEvents()

	--dont override this function

end --func end

--next--
--lua functions end

--lua custom scripts
function ExpAchieveTipsCtrl:ShowExpAchieve(minLevel)
	self:DestoryExpObject()
	self.panel.Text.LabText = StringEx.Format(Common.Utils.Lang("EXP_ACHIEVETIPS"), minLevel)
	for i = 1, #self.achieveData do
		local l_tableData = TableUtil.GetOpenSystemTable().GetRowById(self.achieveData[i])
		if not l_tableData then
			logError("GetOpenSystemTable not have id "..self.achieveData[i])
			break
		end
		local l_isSysOpen = MgrMgr:GetMgr("OpenSystemMgr").IsSystemOpen(self.achieveData[i])
		self.achieveDataUI[i] = {}
		self.achieveDataUI[i].ui = self:CloneObj(self.panel.AchieveTpl.gameObject).gameObject
		self.achieveDataUI[i].ui.gameObject:SetActiveEx(true)
		self.achieveDataUI[i].ui.transform:SetParent(self.panel.Obj.transform)
		self.achieveDataUI[i].ui.transform:SetLocalScaleOne()
		self.achieveDataUI[i].ui.transform:Find("AchieveButton"):GetComponent("MLuaUICom"):AddClick(function()
			if l_tableData.BaseLevel > MPlayerInfo.Lv then
				MgrMgr:GetMgr("TipsMgr").ShowNormalTips(StringEx.Format(Common.Utils.Lang("ACTIVITY_OPENLEVEL"), l_tableData.BaseLevel))
				return
			end
			if not l_isSysOpen then
				MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("DELEGATE_UN_OPEN"))
				return
			end
			local l_method = MgrMgr:GetMgr("SystemFunctionEventMgr").GetSystemFunctionEvent(self.achieveData[i])
			--野外练级特殊处理 只打开界面 不打开冒险
			if self.achieveData[i] == MgrMgr:GetMgr("OpenSystemMgr").eSystemId.LevelUp then
				UIMgr:ActiveUI(UI.CtrlNames.FarmPrompt)
			else
				if l_method and type(l_method) == "function" then
					l_method()
				end
			end
			UIMgr:DeActiveUI(UI.CtrlNames.ExpAchieveTips)
		end)
		local l_level = self.achieveDataUI[i].ui.transform:Find("Title_02"):GetComponent("MLuaUICom")
		if l_tableData.BaseLevel > MPlayerInfo.Lv then
			self.achieveDataUI[i].ui.transform:Find("IconBg/LvImage").gameObject:SetActiveEx(true)
			l_level.gameObject:SetActiveEx(true)
			l_level.LabText = StringEx.Format(Common.Utils.Lang("LEVEL_NOTENOUGH"), l_tableData.BaseLevel)
		end
		self.achieveDataUI[i].ui.transform:Find("Title_01"):GetComponent("MLuaUICom").LabText = l_tableData.Title
		self.achieveDataUI[i].ui.transform:Find("IconBg/LvImage/TxtLv"):GetComponent("MLuaUICom").LabText = l_tableData.BaseLevel
		self.achieveDataUI[i].ui.transform:Find("IconBg/ItemIcon"):GetComponent("MLuaUICom"):SetSprite(l_tableData.SystemAtlas, l_tableData.SystemIcon)
	end

end

function ExpAchieveTipsCtrl:DestoryExpObject()
	for i = 1, #self.achieveDataUI do
		if self.achieveDataUI[i].ui then
			MResLoader:DestroyObj(self.achieveDataUI[i].ui)
			self.achieveDataUI[i].ui = nil
		end
	end
	self.achieveDataUI = {}
end

return ExpAchieveTipsCtrl
--lua custom scripts end
