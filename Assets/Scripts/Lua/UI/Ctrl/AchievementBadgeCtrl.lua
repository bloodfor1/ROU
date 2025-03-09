--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/AchievementBadgePanel"

require "UI/Template/BadgeItemTemplate"


--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua class define
local super = UI.UIBaseCtrl
AchievementBadgeCtrl = class("AchievementBadgeCtrl", super)
--lua class define end

--lua functions
function AchievementBadgeCtrl:ctor()

    super.ctor(self, CtrlNames.AchievementBadge, UILayer.Function, nil, ActiveType.Standalone)

    self.GroupMaskType = GroupMaskType.Show
    self.MaskColor=BlockColor.Dark
    self.ClosePanelNameOnClickMask=UI.CtrlNames.AchievementBadge

end --func end
--next--
function AchievementBadgeCtrl:Init()

    self.panel = UI.AchievementBadgePanel.Bind(self)
    super.Init(self)

    self.panel.BadgeItemPrefab.gameObject:SetActiveEx(false)

    self.achievementBadgeTemplatePool = self:NewTemplatePool({
        UITemplateClass = UITemplate.BadgeItemTemplate,
        TemplatePrefab = self.panel.BadgeItemPrefab.gameObject,
        TemplateParent = self.panel.BadgeItemParent.transform,
    })

    --遮罩设置
    --self:SetBlockOpt(BlockColor.Dark, function()
    --    UIMgr:DeActiveUI(UI.CtrlNames.AchievementBadge)
    --end)

end --func end
--next--
function AchievementBadgeCtrl:Uninit()

    self.achievementBadgeTemplatePool = nil

    super.Uninit(self)
    self.panel = nil

end --func end
--next--
function AchievementBadgeCtrl:OnActive()


end --func end
--next--
function AchievementBadgeCtrl:OnDeActive()


end --func end
--next--
function AchievementBadgeCtrl:Update()


end --func end



--next--
function AchievementBadgeCtrl:BindEvents()

    --dont override this function

end --func end

--next--
--lua functions end

--lua custom scripts
function AchievementBadgeCtrl:ShowBadge(point, level, playerUid, isShowShare)

    local l_datas = {}
    local l_data = {}
    l_data.Point = point
    l_data.PlayerUid = playerUid
    l_data.IsShowShare = isShowShare
    l_data.Level = level
    table.insert(l_datas, l_data)
    if MgrMgr:GetMgr("OpenSystemMgr").IsSystemOpen(MgrMgr:GetMgr("OpenSystemMgr").eSystemId.Achievement) then
        if tostring(playerUid) ~= tostring(MPlayerInfo.UID) then
            local l_data = {}
            l_data.Point = MgrMgr:GetMgr("AchievementMgr").TotalAchievementPoint
            l_data.PlayerUid = MPlayerInfo.UID
            l_data.IsShowShare = true
            l_data.Level = MgrMgr:GetMgr("AchievementMgr").BadgeLevel
            table.insert(l_datas, l_data)

        end
    end

    self.achievementBadgeTemplatePool:ShowTemplates({
        Datas = l_datas,
    })


end

return AchievementBadgeCtrl
--lua custom scripts end
