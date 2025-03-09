--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/FarmPromptPanel"
require "UI/Template/FarmPromptItem"

--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua class define
local super = UI.UIBaseCtrl
FarmPromptCtrl = class("FarmPromptCtrl", super)
--lua class define end

--lua functions
function FarmPromptCtrl:ctor()

	super.ctor(self, CtrlNames.FarmPrompt, UILayer.Function, UITweenType.UpAlpha, ActiveType.Standalone)
	self.overrideSortLayer = UILayerSort.Function + 4
	--self.InsertPanelName=UI.CtrlNames.DailyTask
    --self:SetParent(UI.CtrlNames.DailyTask)
end --func end
--next--
function FarmPromptCtrl:Init()

	self.panel = UI.FarmPromptPanel.Bind(self)
	super.Init(self)
	self.promptItemPool = self:NewTemplatePool({
	        UITemplateClass = UITemplate.FarmPromptItem,
	        TemplatePrefab = self.panel.FarmPromptItem.LuaUIGroup.gameObject,
	        ScrollRect = self.panel.itemScroll.LoopScroll,
		})
end --func end
--next--
function FarmPromptCtrl:Uninit()

	self.promptItemPool = nil

	super.Uninit(self)
	self.panel = nil

end --func end
--next--
function FarmPromptCtrl:OnActive()
    self.panel.BG:AddClick(function ()
        self:Close()
    end)
    self.panel.closeBtn:AddClick(function()
        self:Close()
    end)
	local datas = MgrMgr:GetMgr("DailyTaskMgr").GetPromptInfoByJobAndLv()
    datas = array.map(datas, function(v) return { id = v.ID } end)
	self.promptItemPool:ShowTemplates({Datas = datas})
	LayoutRebuilder.ForceRebuildLayoutImmediate(self.panel.Content.RectTransform)
end --func end
--next--
function FarmPromptCtrl:OnDeActive()


end --func end
--next--
function FarmPromptCtrl:Update()


end --func end



--next--
function FarmPromptCtrl:BindEvents()

	--dont override this function

end --func end

--next--
--lua functions end

--lua custom scripts
function FarmPromptCtrl:Close()
	UIMgr:DeActiveUI(UI.CtrlNames.FarmPrompt)
    if self.uiPanelData and self.uiPanelData.openCtrlOnClose then
        UIMgr:ActiveUI(self.uiPanelData.openCtrlOnClose)
    end
end
--lua custom scripts end
