--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/RunningBusinessEventTipsPanel"
require "UI/Template/MerchantEventListTemplate"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua fields
local super = UI.UIBaseCtrl
--next--
--lua fields end

--lua class define
RunningBusinessEventTipsCtrl = class("RunningBusinessEventTipsCtrl", super)
--lua class define end
local l_mgr = MgrMgr:GetMgr("MerchantMgr")
local l_data = DataMgr:GetData("MerchantData")
local l_timeMgr = Common.TimeMgr
--lua functions
function RunningBusinessEventTipsCtrl:ctor()

	super.ctor(self, CtrlNames.RunningBusinessEventTips, UILayer.Function, UITweenType.UpAlpha, ActiveType.Standalone)

	self.GroupMaskType = GroupMaskType.Show
	self.MaskColor=BlockColor.Transparent
	self.ClosePanelNameOnClickMask=UI.CtrlNames.RunningBusinessEventTips

end --func end
--next--
function RunningBusinessEventTipsCtrl:Init()

	self.panel = UI.RunningBusinessEventTipsPanel.Bind(self)
	super.Init(self)

	self.templatePool = self:NewTemplatePool({
        UITemplateClass = UITemplate.MerchantEventListTemplate,
		TemplateParent = self.panel.EventList.transform,
		TemplatePrefab = self.panel.MerchantEventListTemplate.gameObject,
	})


	--self:SetBlockOpt(BlockColor.Transparent, function()
	--	UIMgr:DeActiveUI(self.name)
	--end)

	-- 控制更新频率
    self.updateFrameCtrl = 0
end --func end
--next--
function RunningBusinessEventTipsCtrl:Uninit()

	self.templatePool = nil
	self.updateFrameCtrl = nil

	super.Uninit(self)
	self.panel = nil

end --func end
--next--
function RunningBusinessEventTipsCtrl:OnActive()
	self:CustomRefresh()
end --func end
--next--
function RunningBusinessEventTipsCtrl:OnDeActive()


end --func end
--next--
function RunningBusinessEventTipsCtrl:Update()

	-- 降低更新频率
    if self.updateFrameCtrl > 0 then
        self.updateFrameCtrl = self.updateFrameCtrl - 1
        return
    end

    self.updateFrameCtrl = 5

	self:RefreshFewFrame()
end --func end

--next--
function RunningBusinessEventTipsCtrl:BindEvents()
	self:BindEvent(l_mgr.EventDispatcher,l_mgr.MERCHANT_EVENT_UPDATE, function()
        self:CustomRefresh()
    end)
end --func end
--next--
--lua functions end

--lua custom scripts

--next--
function RunningBusinessEventTipsCtrl:RunningBusinessEventTipsPanelRefresh()
	local l_eventRumor = l_data.MerchantEventRumor or {}
	local l_eventDatas = l_data.MerchantEventDatas or {}

	local l_result = {}
    for i, v in ipairs(l_eventDatas) do
        local l_row = TableUtil.GetBusinessEventTable().GetRowByID(v.id)
        if not l_row then
            logError("RunningBusinessCtrl:ShowEventsInfo error, 找不到事件配置", v)
        else
			table.insert(l_result, l_row.EventDescription)
        end
    end

	for i, v in ipairs(l_eventRumor) do
		local l_sceneId = l_data.GetNpcSceneByNpcId(v.value)
		if l_sceneId then
			local l_sceneRow = TableUtil.GetSceneTable().GetRowByID(l_sceneId)
			if l_sceneRow then
				table.insert(l_result, Lang("BusinessHintText", i, l_sceneRow.MapEntryName))
			end
		end
	end
	self.templatePool:ShowTemplates({Datas = l_result})
end --func end

function RunningBusinessEventTipsCtrl:RefreshFewFrame()

    local l_curTime = l_timeMgr.GetNowTimestamp()
	local l_leftTime = l_data.MerchantEventRefreshTime - l_curTime
    if l_leftTime <= 0 then
        self.panel.EventRefreshTime.LabText = "0:00"
	else
		local l_min = math.floor(l_leftTime / 60)
		local l_sec = l_leftTime - l_min * 60
        self.panel.EventRefreshTime.LabText = StringEx.Format("{0:00}:{1:00}", l_min, l_sec)
    end
end
function RunningBusinessEventTipsCtrl:CustomRefresh()
	-- 刚开的时候刷新一次
	self:RefreshFewFrame()

	self:RunningBusinessEventTipsPanelRefresh()
end

--lua custom scripts end
return RunningBusinessEventTipsCtrl
