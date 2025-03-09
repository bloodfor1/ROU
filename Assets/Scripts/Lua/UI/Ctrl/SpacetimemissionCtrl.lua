--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/SpacetimemissionPanel"
--lua requires end

--lua model
module("UI", package.seeall)

--lua model end

--lua fields
local super = UI.UIBaseCtrl
--lua fields end

--lua class define
SpacetimemissionCtrl = class("SpacetimemissionCtrl", super)
--lua class define end

--lua functions
function SpacetimemissionCtrl:ctor()
	
	super.ctor(self, CtrlNames.Spacetimemission, UILayer.Function, nil, ActiveType.Exclusive)
	
end --func end
--next--
function SpacetimemissionCtrl:Init()
	
	self.panel = UI.SpacetimemissionPanel.Bind(self)
	super.Init(self)
	self._awardItemTemplatePool = self:NewTemplatePool({
			TemplateClassName = "ItemTemplate",
	        TemplateParent = self.panel.Rewarditems.transform
	    })
	
end --func end
--next--
function SpacetimemissionCtrl:Uninit()
	
	super.Uninit(self)
	self.panel = nil
	
end --func end
--next--
function SpacetimemissionCtrl:OnActive()
	UIMgr:DeActiveUI(CtrlNames.Guild)
	local l_mgr = MgrMgr:GetMgr("WorldPveMgr")
	self.panel.ButtonClose:AddClick(function( ... )
		UIMgr:DeActiveUI(CtrlNames.Spacetimemission)
	end)
	local l_data = TableUtil.GetDailyActivitiesTable().GetRowById(12)
	if l_data == nil then
		return
	end
	self.panel.Photo:SetRawTexAsync(string.format("%s/%s",l_data.ContentPicAtlas, l_data.ContentPicName))
	self.panel.BtnHowToPlay:AddClick(function( ... )
		self:Howtoplay(l_data.HelpTextId)
	end)
	self.panel.ActivityDesc.LabText = l_data.AcitiveText
	self.panel.LimitedText.LabText = StringEx.Format(Common.Utils.Lang("SPACE_TIME_LIMITED_TIPS"),l_data.LevelTextDisplay,MGlobalConfig:GetInt("EventAcceptTeamNum"))
	self.panel.TimeText.LabText = tostring(l_data.TimeTextDisplay)
	self.panel.CountText.LabText = StringEx.Format("<color=$$Yellow$$>{0}/{1}</color>",l_mgr.todayCount,l_mgr.todayMax)
	self.panel.RemarkText.LabText = tostring(l_data.CustomTextDisplay)
	local l_previewAwards = Common.Functions.VectorToTable(l_data.RewardDisplay)
	local l_awardDatas = {}
	for i= 1,#l_previewAwards do
		local l_award = {}
		l_award.ID = l_previewAwards[i]
		l_award.Count = 1
		l_award.IsShowCount = false
		table.insert(l_awardDatas,l_award)
	end
	self._awardItemTemplatePool:ShowTemplates({Datas = l_awardDatas})
	self.panel.Btn_Go:AddClick(function( ... )
		UIMgr:DeActiveUI(CtrlNames.Spacetimemission)
		l_mgr.NavigateToNpc()
	end)
end --func end
--next--
function SpacetimemissionCtrl:OnDeActive()
	
	
end --func end
--next--
function SpacetimemissionCtrl:Update()
	
	
end --func end
--next--
function SpacetimemissionCtrl:BindEvents()
	
	
end --func end
--next--
--lua functions end

--lua custom scripts

function SpacetimemissionCtrl:Howtoplay(helpTextId)
    if helpTextId == nil or helpTextId.Length < 2 then
        return
    end
    local l_textType = tonumber(helpTextId[0])
    if l_textType == 1 then  --文本说明
        local l_content = Common.Utils.Lang(helpTextId[1])
        l_content = MgrMgr:GetMgr("RichTextFormatMgr").FormatRichTextContent(l_content)
        local l_position = MUIManager.UICamera:WorldToScreenPoint(self.panel.BtnHowToPlay.Transform.position)
        MgrMgr:GetMgr("TipsMgr").ShowExplainPanelTips({
            content = l_content,
            alignment = UnityEngine.TextAnchor.UpperLeft,
            relativeLeftPos=
            {
                screenPos = Vector2.New(l_position.x + 400,l_position.y)
            },
            width = 400,
        })
    else   --图文说明
        UIMgr:ActiveUI(CtrlNames.Howtoplay, function(ctrl)
            ctrl:ShowPanel(tonumber(helpTextId[1]))
        end)
    end
end

--lua custom scripts end
return SpacetimemissionCtrl