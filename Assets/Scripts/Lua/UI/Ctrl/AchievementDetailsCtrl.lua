--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/AchievementDetailsPanel"
require "UI/Template/AchievementDetailsTemplate"

--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua class define
local super = UI.UIBaseCtrl
AchievementDetailsCtrl = class("AchievementDetailsCtrl", super)
--lua class define end

--lua functions
function AchievementDetailsCtrl:ctor()

    super.ctor(self, CtrlNames.AchievementDetails, UILayer.Function, nil, ActiveType.Standalone)

    self.GroupMaskType = GroupMaskType.Show
    self.MaskColor=BlockColor.Transparent
    self.ClosePanelNameOnClickMask=UI.CtrlNames.AchievementDetails

end --func end
--next--
function AchievementDetailsCtrl:Init()

    self.panel = UI.AchievementDetailsPanel.Bind(self)
    super.Init(self)

    self.panel.AchievementDetailsPrefab.gameObject:SetActiveEx(false)

    self.achievementDetailsTemplatePool=self:NewTemplatePool({
        UITemplateClass=UITemplate.AchievementDetailsTemplate,
        TemplatePrefab=self.panel.AchievementDetailsPrefab.gameObject,
        TemplateParent=self.panel.AchievementDetailsParent.transform,
    })

    --遮罩设置
    --self:SetBlockOpt(BlockColor.Transparent, function()
    --    UIMgr:DeActiveUI(UI.CtrlNames.AchievementDetails)
    --end)

end --func end
--next--
function AchievementDetailsCtrl:Uninit()

    self.achievementDetailsTemplatePool=nil

    super.Uninit(self)
    self.panel = nil

end --func end
--next--
function AchievementDetailsCtrl:OnActive()


end --func end
--next--
function AchievementDetailsCtrl:OnDeActive()


end --func end
--next--
function AchievementDetailsCtrl:Update()


end --func end



--next--
function AchievementDetailsCtrl:BindEvents()

    --dont override this function

end --func end

--next--
--lua functions end

--lua custom scripts
function AchievementDetailsCtrl:ShowDetails(achievementId,playerUid,finishTime,isShowShare)

    local l_tableInfo= TableUtil.GetAchievementDetailTable().GetRowByID(achievementId)
    if l_tableInfo==nil then
        return
    end

    if finishTime==nil then
        logError("发过来的完成时间是空的")
        finishTime=0
    end

    local l_datas={}

    local l_data={}
    l_data.AchievementId=achievementId
    l_data.PlayerUid=playerUid
    l_data.FinishTime=finishTime
    l_data.IsShowShare=isShowShare
    l_data.IsComparison=false
    if tostring(playerUid)~=tostring(MPlayerInfo.UID) then
        l_data.IsComparison=true
    end
    table.insert(l_datas,l_data)

    if MgrMgr:GetMgr("OpenSystemMgr").IsSystemOpen(MgrMgr:GetMgr("OpenSystemMgr").eSystemId.Achievement) then
        if tostring(playerUid)~=tostring(MPlayerInfo.UID) then
            local l_data={}
            l_data.AchievementId=achievementId
            l_data.PlayerUid=MPlayerInfo.UID
            l_data.IsShowShare=true
            l_data.IsComparison=true
            table.insert(l_datas,l_data)

        end
    end


    self.achievementDetailsTemplatePool:ShowTemplates({
        Datas=l_datas,
    })

    if l_tableInfo.Award~=0 then
        MgrMgr:GetMgr("AwardPreviewMgr").GetPreviewRewards(l_tableInfo.Award)
    end

    MgrMgr:GetMgr("AchievementMgr").RequestAchievementGetFinishRateInfo(achievementId)
end
--lua custom scripts end
