--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/MonsterInfoTipsPanel"
require "UI/BaseUITemplate"
require "UI/Template/ItemTemplate"
require "Common/CommonScreenPosUtil"

--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua class define
local super = UI.UIBaseCtrl
MonsterInfoTipsCtrl = class("MonsterInfoTipsCtrl", super)

------------------------eventsystem

local l_pointEventData
local l_eventSystem
local l_pointRes
local l_awardPreviewMgr
----------------------------------

local l_rewardItem = {}

--lua class define end

--lua functions
function MonsterInfoTipsCtrl:ctor()

    super.ctor(self, CtrlNames.MonsterInfoTips, UILayer.Tips, nil, ActiveType.Standalone)
    self.cacheGrade = EUICacheLv.VeryLow
    self.findFirstScene = MScene.SceneID
    self.monsterId = 0
    self.IsCloseOnSwitchScene = true
end --func end
--next--
function MonsterInfoTipsCtrl:Init()

    self.panel = UI.MonsterInfoTipsPanel.Bind(self)
    super.Init(self)
    l_eventSystem = EventSystem.current
    l_pointEventData = PointerEventData.New(l_eventSystem)
    l_pointRes = RaycastResultList.New()
    l_awardPreviewMgr = MgrMgr:GetMgr("AwardPreviewMgr")

    self.panel.BtnGotoMonsterPos:AddClick(function()
        Common.CommonUIFunc.GoToLatestMonsterPos(self.monsterId, self.findFirstScene, nil, nil)
        UIMgr:DeActiveUI(UI.CtrlNames.MonsterInfoTips)
        MgrMgr:GetMgr("MapInfoMgr").ShowMapPanel(false)
        MgrMgr:GetMgr("WorldMapInfoMgr").HideWorldMap()
    end)
end --func end
--next--
function MonsterInfoTipsCtrl:Uninit()

    for k, v in pairs(l_rewardItem) do
        self:UninitTemplate(v)
    end
    l_rewardItem = {}

    self.head2d = nil

    super.Uninit(self)
    self.panel = nil

end --func end
--next--
function MonsterInfoTipsCtrl:OnActive()

    self.panel.Tips.gameObject:SetActiveEx(true)
    if self.uiPanelData ~= nil then
        if self.uiPanelData.openType == DataMgr:GetData("TipsData").MonsterInfoTipsOpenType.ShowEntityTips then
            self:_showEntityTips(self.uiPanelData.entity, self.uiPanelData.entityId, self.uiPanelData.pos, self.uiPanelData.isMask)
        elseif self.uiPanelData.openType == DataMgr:GetData("TipsData").MonsterInfoTipsOpenType.ShowTips then
            self:ShowTips(self.uiPanelData.entityId, self.uiPanelData.pos, self.uiPanelData.isMask, self.uiPanelData.findSceneId, self.uiPanelData.showGotoPosBtn)
            self.uObj.transform:SetAsLastSibling()
        end
    end
end --func end
--next--
function MonsterInfoTipsCtrl:OnDeActive()

    for k, v in pairs(l_rewardItem) do
        self:UninitTemplate(v)
    end
    l_rewardItem = {}

end --func end
--next--
function MonsterInfoTipsCtrl:Update()


end --func end
--next--
function MonsterInfoTipsCtrl:UpdateInput(touchItem)

    if not self.isMask then
        return
    end

    if self.panel == nil then
        return
    end

    if l_pointEventData == nil or l_eventSystem == nil then
        return
    end

    if self.panel.Tips.gameObject.activeSelf == false then
        return
    end

    if tostring(touchItem.Phase) ~= "Began" then
        return
    end

    local l_pos = touchItem.Position

    l_pointRes:Clear()
    l_pointEventData.position = l_pos
    l_eventSystem:RaycastAll(l_pointEventData, l_pointRes)
    local l_isTips = false
    for i = 0, l_pointRes.Count - 1 do
        local l_go = l_pointRes[i].gameObject
        local l_com = l_go:GetComponent("MLuaUICom")
        if l_com ~= nil and (l_com.Name == "Tips") then
            l_isTips = true
        end

    end

    if l_isTips == false then
        self:HideTips()
    end

end --func end



--next--
function MonsterInfoTipsCtrl:BindEvents()

    self:BindEvent(l_awardPreviewMgr.EventDispatcher, l_awardPreviewMgr.AWARD_PREWARD_MSG, function(object, ...)
        self:RefreshPreviewAwards(...)
    end)
    local l_playerInfoMgr = MgrMgr:GetMgr("PlayerInfoMgr")
    self:BindEvent(l_playerInfoMgr.EventDispatcher, l_playerInfoMgr.SET_MAIN_TARGET_EVENT, function(_, uid, name, lv, isRole)
        if not self.entity then
            self:HideTips()
        else
            if self.entity.UID ~= uid then
                self:HideTips()
            end
        end
    end)
end --func end
--next--
--lua functions end

--lua custom scripts

function MonsterInfoTipsCtrl:ShowEntityTips(entity, entityId, pos, isMask)
    self:ShowTips(entityId, pos, isMask)
    local l_tableData = TableUtil.GetEntityTable().GetRowById(entityId)
    local l_isEnemy = tonumber(l_tableData.DefaultGroup) ~= 10000
    if not l_isEnemy then
        --self.panel.Target:SetSprite("Common", "UI_common_BoardBase_03.png")
        self.panel.BG:SetSprite("Common", "UI_common_BoardBase_04.png")
    else
        --self.panel.Target:SetSprite("Common", "UI_common_BoardBase_03-2.png")
        self.panel.BG:SetSprite("Common", "UI_common_BoardBase_04-2.png")
    end
    if entity and entity.AttrComp then
        self.entity = entity
        self.panel.TargetName.LabText = tostring(entity.AttrComp.Name) .. " Lv." .. tostring(entity.AttrComp.Level)
    end
end

function MonsterInfoTipsCtrl:ShowTips(entityId, pos, isMask, findFirstScene, showGotoPosBtn)
    if findFirstScene == nil then
        self.findFirstScene = MScene.SceneID
    else
        self.findFirstScene = tonumber(findFirstScene)
    end
    self.monsterId = entityId
    self.panel.Relic.gameObject:SetActiveEx(false)
    self.isMask = isMask
    local l_e = TableUtil.GetEntityTable().GetRowById(entityId)
    if l_e == nil then
        self.panel.Tips.gameObject:SetActiveEx(false)
        return
    end

    self.panel.Tips.gameObject:SetActiveEx(true)
    self.panel.BtnGotoMonsterPos.Transform.parent.gameObject:SetActiveEx(showGotoPosBtn ~= nil and showGotoPosBtn)
    self.panel.TargetName.LabText = tostring(l_e.Name) .. " Lv." .. tostring(l_e.UnitLevel)

    --属性名
    local l_attr = TableUtil.GetElementAttr().GetRowByAttrId(l_e.UnitAttrType)
    self.panel.MonsterTypeAttrLab.LabText = l_attr.ColourTextDefence
    self.panel.MonsterTypeAttr.Img.color = RoColor.Hex2Color(RoBgColor[l_attr.Colour])
    local l_race_enum = TableUtil.GetRaceEnum().GetRowById(l_e.UnitRace)
    if l_race_enum then
        self.panel.MonsterTypeRaceLab.LabText = l_race_enum.Text
    else
        logError("RaceEnum找不到怪物种族配置 ID:" .. tostring(l_e.UnitRace))
    end

    --大小
    self.panel.MonsterTypeShapeLab.LabText = Common.Utils.Lang("UnitSize_" .. tostring(l_e.UnitSize))
    --描述
    local l_state, l_vStr, l_dropStr = DataMgr:GetData("IllustrationMonsterData").GetLvRateByEntityID(l_e.Id)
    self.panel.TipsDes.LabText = StringEx.Format(Common.Utils.Lang("MONSTER_INFO_TIPS_DES"), l_vStr, l_dropStr)
            .. tostring(l_e.MonsterDesc)
    self.panel.TipsDes.gameObject:SetActiveEx(l_e.IsFieldMonster)

    if not self.head2d then
        self.head2d = self:NewTemplate("HeadWrapTemplate", {
            TemplateParent = self.panel.TipsHeadIcon.transform,
            TemplatePath = "UI/Prefabs/HeadWrapTemplate"
        })
    end

    ---@type HeadTemplateParam
    local param = {
        MonsterHeadID = entityId,
        ShowFrame = false,
        ShowBg = false,
    }

    self.head2d:SetData(param)
    local l_rewardId = 0
    if l_e.Award.Length > 0 then
        local l_num = tonumber(l_e.Award[0])
        if l_num and l_num > 0 then
            l_rewardId = l_num
        end
    end

    local l_rows = TableUtil.GetMvpTable().GetTable()
    local l_rowCount = #l_rows
    for i = 1, l_rowCount do
        local l_row = l_rows[i]
        local l_entityID = l_row.EntityID
        if l_entityID == entityId then
            l_rewardId = l_row.WinAward[0]
            break
        end
    end

    if l_rewardId ~= nil and l_rewardId ~= 0 then
        MgrMgr:GetMgr("AwardPreviewMgr").GetPreviewRewards(l_rewardId)
    end

    Common.CommonUIFunc.CalculateLowLevelTipsInfo(self.panel.MonsterTypeRaceLab, nil, Vector2.New(1, 1))
    Common.CommonUIFunc.CalculateLowLevelTipsInfo(self.panel.MonsterTypeShapeLab, nil, Vector2.New(1, 1))
    Common.CommonUIFunc.CalculateLowLevelTipsInfo(self.panel.MonsterTypeAttrLab, nil, Vector2.New(1, 1))

    self._cachePos = pos
    self:_resetPos(pos)
end

function MonsterInfoTipsCtrl:HideTips()

    --self.panel.Tips.gameObject:SetActiveEx(false)
    UIMgr:DeActiveUI(UI.CtrlNames.MonsterInfoTips)

end

function MonsterInfoTipsCtrl:RefreshPreviewAwards(...)
    local awardPreviewRes = ...
    local l_reward = awardPreviewRes and awardPreviewRes.award_list
    local previewCount = awardPreviewRes.preview_count == -1 and #l_reward or awardPreviewRes.preview_count
    local previewnum = awardPreviewRes.preview_num
    self.panel.Relic.gameObject:SetActiveEx(false)
    for k, v in pairs(l_rewardItem) do
        self:UninitTemplate(v)
    end

    l_rewardItem = {}
    if #l_reward > 0 and previewCount > 0 then
        for i, v in ipairs(l_reward) do
            local l_id = v.item_id
            local l_count = v.count
            local l_showCount = MgrMgr:GetMgr("AwardPreviewMgr").IsShowAwardNum(previewnum, v.count)
            local l_index = #l_rewardItem + 1
            l_rewardItem[l_index] = self:NewTemplate("ItemTemplate", {
                TemplateParent = self.panel.Content.gameObject.transform,
            })
            l_rewardItem[l_index]:SetData({ ID = l_id, IsShowCount = l_showCount,
                                            Count = l_count, IsShowTips = true })
            if i >= previewCount then
                break
            end
        end
        self.panel.Relic.gameObject:SetActiveEx(true)
    end

    self:_resetPos(self._cachePos)
end

--- 重新调整位置
--- 根据背景大小重新调整位置，如果背景从当前位置开始，超出了屏幕位置，则向回修正，保证显示永远在屏幕内
--- 目前这个函数会被调用两次，原因是开始的时候会调用一次这个时候里面有东西被隐藏了，后面这个东西被启用了，所以还要重新计算一次
function MonsterInfoTipsCtrl:_resetPos(pos)
    if nil == pos then
        return
    end

    LayoutRebuilder.ForceRebuildLayoutImmediate(self.panel.Tips.transform)
    local bg_size = {
        x = self.panel.Tips.RectTransform.sizeDelta.x,
        y = self.panel.Tips.RectTransform.sizeDelta.y
    }

    local l_UIPos = CoordinateHelper.WorldPositionToLocalPosition(pos, self.panel.Tips.transform)
    local l_verticalOffset = bg_size.y * 0.5
    local l_horizontalOffset = bg_size.x * 0.5
    local l_pos = {
        x = l_UIPos.x + l_horizontalOffset,
        y = l_UIPos.y - l_verticalOffset,
        z = l_UIPos.z
    }

    ---@type Common.CommonScreenPosUtil
    local l_util = Common.CommonScreenPosUtil
    local l_retPos = l_util.CalcPos(l_pos, bg_size)
    self.panel.Tips.gameObject:SetRectTransformPos(l_retPos.x, l_retPos.y + l_verticalOffset)
end

function MonsterInfoTipsCtrl:_showEntityTips(entity, entityId, pos, isMask)
    self:ShowEntityTips(entity, entityId, pos, isMask)
    self.uObj.transform:SetAsLastSibling()
end

return MonsterInfoTipsCtrl
--lua custom scripts end
