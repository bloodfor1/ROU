--this file is gen by script
--you can edit this file in custom part


-- todo obsolete 已经废弃

--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/ThemeArroundPanel"
require "UI/Template/ItemTemplate"
require "UI/Template/ThemeDungeonAffixTemplate"
require "UI/Template/ThemeDungeonAffixItemTemplate"
require "UI/Template/ThemeDungeonHardItemTemplate"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua fields
local super = UI.UIBaseCtrl
--next--
--lua fields end

--lua class define
ThemeArroundCtrl = class("ThemeArroundCtrl", super)
--lua class define end

local l_AWARD_PREVIEW_EVENT_NAME = "THEME_ARROUND_AWARD_PREVIEW"
local l_mgr = MgrMgr:GetMgr("ThemeDungeonMgr")
local l_data = DataMgr:GetData("ThemeDungeonData")
local l_commonFxPath = "Effects/Prefabs/Creature/Ui/"
--lua functions
function ThemeArroundCtrl:ctor()
    super.ctor(self, CtrlNames.ThemeArround, UILayer.Function, nil, ActiveType.Standalone)
end --func end
--next--
function ThemeArroundCtrl:Init()

    self.panel = UI.ThemeArroundPanel.Bind(self)
    super.Init(self)

    self.init = false
    self.selectNormalDungeon = true
    self.selectDungeonId = nil
    self.hardDungeonExpandFlag = true
    self.selectKey = nil
    self.previewAwardId = nil
    self.affixPanelShow = false
    self.lastSelectHardTemplate = nil
    self.hardKeyId = nil
    self.teamTargetId = nil

    self.cachedPassDungeonMap = {}
    for i, v in ipairs(l_data.PassedDungeons) do
        self.cachedPassDungeonMap[v] = true
    end

    self.serverLevel = MPlayerInfo.ServerLevel or 0

    self.hardModel = nil

    self.fxRecords = {}
    self.lastHardPanelFx = nil
    self.putKeyTimer = nil

    self.panel.PushKeyPanel.gameObject:SetActiveEx(false)
    self.panel.PanelMain.gameObject:SetActiveEx(true)

    self:BindingClickEvents()
    self:InitTemplatePools()

    self.panel.ScrollView:SetScrollRectGameObjListener(self.panel.ImageUp.gameObject, self.panel.ImageDown.gameObject, nil, nil)
end --func end
--next--
function ThemeArroundCtrl:Uninit()

    self.init = nil
    self.selectNormalDungeon = nil

    self.normalDungeonId = nil
    self.hardDungeonsData = nil
    self.selectDungeonId = nil
    self.hardDungeonExpandFlag = nil
    self.hardItemTemplatePool = nil
    self.selectKey = nil
    self.previewAwardId = nil
    self.cachedPassDungeonMap = nil
    self.affixPanelShow = nil
    self.affixItemTemplatePool = nil
    self.lastSelectHardTemplate = nil
    self.hardKeyId = nil
    self.teamTargetId = nil
    self.lastHardPanelFx = nil
    self.serverLevel = nil
    self.rewardItemTemplatePool = nil
    self.affixTemplatePool = nil

    if self.fxRecords then
        for k, v in pairs(self.fxRecords) do
            self:DestroyUIEffect(v.fx)
        end
        self.fxRecords = nil
    end

    if self.showKeyEnterTimer then
        self:StopUITimer(self.showKeyEnterTimer)
        self.showKeyEnterTimer = nil
    end

    if self.hardModel then
        self:DestroyUIModel(self.hardModel)
        self.hardModel = nil
    end

    if self.putKeySuccessModel then
        self:DestroyUIModel(self.putKeySuccessModel)
        self.putKeySuccessModel = nil
    end

    if self.arrowTweenId then
        MUITweenHelper.KillTween(self.arrowTweenId)
        self.arrowTweenId = nil
    end

    if self.hardItemExpandTweenId then
        MUITweenHelper.KillTween(self.hardItemExpandTweenId)
        self.hardItemExpandTweenId = nil
    end

    if self.affixPanelTweenId then
        MUITweenHelper.KillTween(self.affixPanelTweenId)
        self.affixPanelTweenId = nil
    end

    if self.hardSelectFx1 then
        self:DestroyUIEffect(self.hardSelectFx1)
        self.hardSelectFx1 = nil
    end

    if self.hardSelectFx2 then
        self:DestroyUIEffect(self.hardSelectFx2)
        self.hardSelectFx2 = nil
    end

    if self.putKeyTimer ~= nil then
        self:StopUITimer(self.putKeyTimer)
        self.putKeyTimer = nil
    end

    l_data.ClearDungeonAffixs()

    super.Uninit(self)
    self.panel = nil
end --func end
--next--
function ThemeArroundCtrl:OnActive()

    MPlayerInfo:ApproachFocus2Entity(Vector3.New(unpack(l_data.CamConfig[3])), Vector3.New(unpack(l_data.CamConfig[5])),
            Vector3.New(unpack(l_data.CamConfig[4])), Vector3.New(unpack(l_data.CamConfig[6])), DG.Tweening.Ease.Linear, 0)

    --self:SetParent(UI.CtrlNames.ThemeDungeonArround)

    self.InsertPanelName = UI.CtrlNames.ThemeDungeonArround
    self:CustomRefresh()
end --func end
--next--
function ThemeArroundCtrl:OnDeActive()

    l_mgr.EventDispatcher:Dispatch(l_mgr.CLOSE_THEME_DETAIL_EVENT)
end --func end
--next--
function ThemeArroundCtrl:Update()


end --func end

--next--
function ThemeArroundCtrl:BindEvents()
    self:BindEvent(MgrMgr:GetMgr("AwardPreviewMgr").EventDispatcher, l_AWARD_PREVIEW_EVENT_NAME, function(_, ...)
        self:RefreshReward(...)
    end)
end --func end
--next--
--lua functions end

--lua custom scripts

function ThemeArroundCtrl:CloseUI()
    UIMgr:DeActiveUI(self.name)
end

function ThemeArroundCtrl:SetSelectInfo(themeDungeonID)

    self.themeDungeonID = themeDungeonID

    local l_themeRow = TableUtil.GetThemeDungeonTable().GetRowByThemeDungeonID(self.themeDungeonID)
    if not l_themeRow then
        logError("ThemeArroundCtrl:SetSelectInfo fail, 传参错误，找不到主题副本", self.themeDungeonID)
        return
    end

    self.normalDungeonId = l_themeRow.DungeonID
    self.teamTargetId = l_themeRow.TeamTargetID

    local l_normalLock = self:CheckNormalLocked(true)
    local l_normalDungeonPassed = l_mgr.IsDungeonPassed(self.normalDungeonId)

    local l_hardLocked = l_normalLock or (not l_normalDungeonPassed)
    self.hardDungeonsData = {}
    local l_tmpTblDatas = {}
    for i, v in pairs(TableUtil.GetGreatSecretTable().GetTable()) do
        if l_themeRow.ThemeID == v.ThemeID then
            table.insert(l_tmpTblDatas, v)
        end
    end

    table.sort(l_tmpTblDatas, function(m, n)
        return m.Difficulty < n.Difficulty
    end)

    local l_tmpMark = {}
    for i, v in ipairs(l_tmpTblDatas) do
        local l_accept = false
        if v.ServerOpeningLevel <= self.serverLevel then
            l_accept = true
            l_tmpMark[v.Difficulty] = true
        elseif v.Difficulty == 1 then
            l_accept = true
        end
        if l_accept or (l_tmpTblDatas[i - 1] and l_tmpMark[l_tmpTblDatas[i - 1].Difficulty]) then
            table.insert(self.hardDungeonsData, {
                id = v.GreatSecretID,
                themeId = self.themeDungeonID,
                normalLock = l_hardLocked,
            })
        end
    end

    table.sort(self.hardDungeonsData, function(m, n)
        return m.id < n.id
    end)

    -- 赋予index
    for i, v in ipairs(self.hardDungeonsData) do
        v.index = i
    end

    if #self.hardDungeonsData > 0 then
        local l_row = TableUtil.GetGreatSecretTable().GetRowByGreatSecretID(self.hardDungeonsData[1].id)
        self.hardKeyId = l_row.GreatSecretLimit
    end

    self.panel.Locked.gameObject:SetActiveEx(l_hardLocked)

    self.panel.NormalLocked.gameObject:SetActiveEx(self:CheckNormalLocked(true))

    self.init = true
end

function ThemeArroundCtrl:CustomRefresh()

    if not self.init then
        self:CloseUI()
        return
    end

    -- 标题
    local l_themeDungeonRow = TableUtil.TableUtil.GetThemeDungeonTable().GetRowByThemeDungeonID(self.themeDungeonID)
    self.panel.TextTitle.LabText = l_themeDungeonRow.ChapterName
    self.panel.TextLv.LabText = StringEx.Format("Lv.{0}", l_themeDungeonRow.ChapterLevel)

    self.selectDungeonId = self.selectDungeonId or self.normalDungeonId

    -- 列表
    self:RefreshList()

    self:RefreshSelectDungeonInfo()

end

-- 刷新列表
function ThemeArroundCtrl:RefreshList()

    if #self.hardDungeonsData <= 0 then
        self.panel.ButtonArrow.gameObject:SetActiveEx(false)
        -- self.panel.Hard:SetGray(true)
    else
        self.panel.ButtonArrow.gameObject:SetActiveEx(true)
        -- self.panel.Hard:SetGray(false)
        self.hardItemTemplatePool:ShowTemplates({ Datas = self.hardDungeonsData, Method = function(id, index)

            if self.selectDungeonId == id then
                log("select same dungeon")
                return
            end

            if self.selectNormalDungeon then
                self.selectNormalDungeon = false
            end

            self.selectDungeonId = id
            self:RefreshSelectDungeonInfo()
        end })
    end
end

function ThemeArroundCtrl:RefreshSelectDungeonInfo()

    local l_dungeon = TableUtil.GetDungeonsTable().GetRowByDungeonsID(self.selectDungeonId)
    if not l_dungeon then
        logError("ThemeArroundCtrl:RefreshSelectDungeonInfo fail, 找不到选择的副本", self.selectDungeonId)
    else
        local l_awardId = 0
        if l_mgr.IsDungeonPassed(self.selectDungeonId) then
            if l_dungeon.AwardDrop.Count > 0 then
                l_awardId = l_dungeon.AwardDrop[0] or 0
            end
            self.panel.RewardTextTitle.LabText = Lang("THEME_DUNGEON_NORMAL_AWARD")
            self.panel.RewardTextDesc.LabText = Lang("THEME_DUNGEON_NORMAL_AWARD_DESC")
            self.panel.ImageRewardTitle.Img.color = CommonUI.Color.Hex2Color(RoBgColor.Blue)
        else
            if l_dungeon.FirstAward.Length > 0 then
                local l_num = tonumber(l_dungeon.FirstAward[0])
                if l_num and l_num > 0 then
                    l_awardId = l_num
                end
            end
            self.panel.RewardTextTitle.LabText = Lang("THEME_DUNGEON_FIRST_AWARD")
            self.panel.RewardTextDesc.LabText = Lang("THEME_DUNGEON_FIRST_AWARD_DESC")
            self.panel.ImageRewardTitle.Img.color = CommonUI.Color.Hex2Color(RoBgColor.Yellow)
        end

        if l_awardId > 0 then
            self.previewAwardId = l_awardId
            MgrMgr:GetMgr("AwardPreviewMgr").GetPreviewRewards(l_awardId, l_AWARD_PREVIEW_EVENT_NAME)
            self.panel.RewardScrollview.gameObject:SetActiveEx(true)
        else
            log("副本无奖励")
            self.panel.RewardScrollview.gameObject:SetActiveEx(false)
        end
    end

    self:UpdateSelectState()

    self:RefreshDetailPanel()
end

function ThemeArroundCtrl:RefreshReward(awardInfo, _, awardId)

    if awardId ~= self.previewAwardId then
        log("RefreshReward fail，可能网络延迟导致")
        return
    end

    if awardInfo then
        local l_datas = {}
        for i, v in ipairs(awardInfo.award_list) do
            local l_itemRow = TableUtil.GetItemTable().GetRowByItemID(v.item_id)
            if l_itemRow then
                table.insert(l_datas, {
                    ID = v.item_id,
                    count = v.count,
                    dropRate = v.drop_rate,
                    isParticular = v.is_particular,
                    IsShowCount = false,
                })
            else
                logError("ThemeArroundCtrl:RefreshReward fail, 奖励预览道具id客户端找不到")
            end
        end

        self.rewardItemTemplatePool:ShowTemplates({ Datas = l_datas })
        self.panel.RewardScrollview.gameObject:SetActiveEx(true)
    else
        self.panel.RewardScrollview.gameObject:SetActiveEx(false)
    end
end

function ThemeArroundCtrl:RefreshDetailPanel()

    if self.selectNormalDungeon then
        self.selectKey = nil
        self.panel.NormalPanel.gameObject:SetActiveEx(true)
        self.panel.HardPanel.gameObject:SetActiveEx(false)
        self:RefreshNormal()
        self.selectKey = nil
        self.panel.LabelLocked.gameObject:SetActive(false)
        self.panel.ButtonTeam.gameObject:SetActiveEx(true)
        self.panel.ButtonForward.gameObject:SetActiveEx(true)
        self.panel.ButtonTeam:SetGray(false)
    else
        self.panel.NormalPanel.gameObject:SetActiveEx(false)
        self.panel.HardPanel.gameObject:SetActiveEx(true)
        self.panel.ButtonTeam:SetGray(true)
        self:RefreshHard()
    end
end

-- 刷新普通模式特有面板
function ThemeArroundCtrl:RefreshNormal()

    local l_themeRow = TableUtil.GetThemeDungeonTable().GetRowByThemeDungeonID(self.themeDungeonID)
    self.panel.NormalTextDesc.LabText = "　　" .. l_themeRow.ChapterContent
    MLuaCommonHelper.SetLocalPosY(self.panel.NormalTextDesc.gameObject, 0)
    local l_overflowFlag = self.panel.NormalTextDesc:GetText().preferredHeight > 300
    self.panel.Notice.gameObject:SetActiveEx(l_overflowFlag)
    self.panel.NormalTextDesc.LabRayCastTarget = l_overflowFlag
    self.panel.ScrollView:SetScrollRectDownAndUpState(self.panel.ImageUp.gameObject, self.panel.ImageDown.gameObject)
end

-- 刷新困难模式特有面板
function ThemeArroundCtrl:RefreshHard()

    local l_affixDatas = l_data.GetDungeonAffixs(self.selectDungeonId) or {}

    self.affixTemplatePool:ShowTemplates({ Datas = l_affixDatas })

    self:RefreshHardModel()

    if #l_affixDatas <= 0 then
        -- self.panel.TextAffix.LabText = Lang("AFFIX") .. ":" .. Lang("NONE")
        self.panel.Collider.gameObject:SetActiveEx(false)
        self.panel.ButtonAffix.gameObject:SetActiveEx(false)
    else
        -- self.panel.TextAffix.LabText = Lang("AFFIX") .. ":"
        self.panel.Collider.gameObject:SetActiveEx(true)
        self.panel.ButtonAffix.gameObject:SetActiveEx(true)
    end

    if self.selectKey then
        self.panel.TextKey.LabText = Lang("THEME_DUNGEON_ALREADY_KEY")
        self:CreateFxForRT("Fx_Ui_ZhuTiFuBen_QianRuHou_01", "HardKey", self.panel.ImageRT, Vector3.New(-0.005, 0.07, 0), Vector3.New(1.06, 1.06, 1.06))
    else
        self.panel.TextKey.LabText = Lang("THEME_DUNGEON_NEED_KEY")
        self:CreateFxForRT("Fx_Ui_ZhuTiFuBen_QianRuQian_01", "HardKey", self.panel.ImageRT, Vector3.New(0, 0.06, 0), Vector3.New(1.06, 1.06, 1.06))
    end

    local l_unlock, l_text = self:IsDungeonUnlock(self.selectDungeonId)
    if l_unlock then
        self.panel.LabelLocked.gameObject:SetActive(false)
        self.panel.ButtonTeam.gameObject:SetActiveEx(true)
        self.panel.ButtonForward.gameObject:SetActiveEx(true)
    else
        self.panel.LabelLocked.LabText = l_text
        self.panel.LabelLocked.gameObject:SetActive(true)
        self.panel.ButtonTeam.gameObject:SetActiveEx(false)
        self.panel.ButtonForward.gameObject:SetActiveEx(false)
    end
end

function ThemeArroundCtrl:PlayArrowTween()

    -- 箭头动画
    if self.arrowTweenId then
        MUITweenHelper.KillTween(self.arrowTweenId)
        self.arrowTweenId = nil
    end
    self.arrowTweenId = MUITweenHelper.TweenRotationByEuler(
            self.panel.ButtonArrow.gameObject,
            self.panel.ButtonArrow.Transform.localEulerAngles,
            (self.hardDungeonExpandFlag and Vector3.New(0, 0, 0) or Vector3.New(0, 0, 180)),
            0.3,
            function()
                self.arrowTweenId = nil
            end)

    -- 列表展开动画
    if self.hardItemExpandTweenId then
        MUITweenHelper.KillTween(self.hardItemExpandTweenId)
        self.hardItemExpandTweenId = nil
    end

    if self.hardDungeonExpandFlag then
        local l_pos = self.panel.HardItemParent.transform.localPosition
        self.hardItemExpandTweenId = MUITweenHelper.TweenPos(
                self.panel.HardItemParent.gameObject,
                Vector3.New(l_pos.x, #self.hardDungeonsData * (80), 0),
                Vector3.New(l_pos.x, 0, 0),
                0.3,
                function()
                    self.hardItemExpandTweenId = nil
                end)

        self.panel.HardItemParent.gameObject:SetActiveEx(true)
    else
        self.panel.HardItemParent.gameObject:SetActiveEx(false)
    end
end

function ThemeArroundCtrl:UpdateSelectState()

    if self.lastSelectHardTemplate then
        self.lastSelectHardTemplate:UpdateSelectState(false)
        self.lastSelectHardTemplate = nil
    end
    if self.selectDungeonId == self.normalDungeonId then
        self.panel.HardSelected.gameObject:SetActiveEx(false)
        self.panel.NormalSelected.gameObject:SetActiveEx(true)
        self:CreateFxForRT("Fx_Ui_ZhuTiFuBen_JiChu", "normalSelectFx", self.panel.NormalSelected, Vector3.New(0, 0.05, 0), Vector3.New(5.15, 5.15, 5.15))
    else
        self.panel.HardSelected.gameObject:SetActiveEx(true)
        self:CreateFxForRT("Fx_Ui_ZhuTiFuBen_JinJie", "hardSelectFx", self.panel.HardSelected, Vector3.New(0, 0.05, 0), Vector3.New(5.15, 5.15, 5.15))
        self.panel.NormalSelected.gameObject:SetActiveEx(false)
        for i, v in ipairs(self.hardDungeonsData) do
            if v.id == self.selectDungeonId then
                self.lastSelectHardTemplate = self.hardItemTemplatePool:GetItem(i)
                self.lastSelectHardTemplate:UpdateSelectState(true)
                break
            end
        end
    end
end

-- 判断困难是否解锁
function ThemeArroundCtrl:IsDungeonUnlock(dungeonId)

    if self.cachedPassDungeonMap[dungeonId] then
        return true
    end

    -- 普通章节是否已经解锁
    if not self.cachedPassDungeonMap[self.normalDungeonId] then
        return false, Lang("THEMEDUNGEON_LOCKED")
    end

    local l_row = TableUtil.GetGreatSecretTable().GetRowByGreatSecretID(dungeonId)
    if not l_row then
        return false, "", logError("找不到大秘境配置 id:", dungeonId)
    end

    if l_row.ServerOpeningLevel <= self.serverLevel then
        return true
    end

    return false, Lang("THEME_DUNGEON_LOCKOF_SERVER1", l_row.ServerOpeningLevel)
end

function ThemeArroundCtrl:BindingClickEvents()

    self.panel.ButtonClose:AddClick(function()
        self:CloseUI()
    end)

    self.panel.ButtonTeam:AddClick(function()
        if self:CheckNormalLocked() then
            return
        end

        if not self.selectNormalDungeon then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("THEME_DUNGEON_HARD_TEAM_LIMIT"))
            return
        end

        local l_inTeam = DataMgr:GetData("TeamData").GetPlayerTeamInfo()
        if l_inTeam then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("ALREADY_HAVE_A_TEAM"))
        else
            UIMgr:ActiveUI(UI.CtrlNames.TeamSearch, function(ctrl)
                ctrl:SetTeamTargetPre(2000)
            end)
        end
    end)

    self.panel.ButtonForward:AddClick(function()
        if self:CheckNormalLocked() then
            return
        end
        self:ClickForward()
    end)

    self.panel.ButtonArrow.transform.localEulerAngles = Vector3.New(0, 0, 0)
    self.panel.ButtonArrow:AddClick(function()
        self.hardDungeonExpandFlag = not self.hardDungeonExpandFlag
        self:PlayArrowTween()
    end)

    self.panel.Normal:AddClick(function()
        if self.selectNormalDungeon then
            return
        end

        self.selectNormalDungeon = true
        self.selectDungeonId = self.normalDungeonId
        self:RefreshSelectDungeonInfo()
    end)

    self.panel.Hard:AddClick(function()
        if not self.selectNormalDungeon then
            self.hardDungeonExpandFlag = not self.hardDungeonExpandFlag
            self:PlayArrowTween()
            return
        end

        if #self.hardDungeonsData <= 0 then
            log("没有困难模式的关卡数据！")
            return
        end

        self.selectNormalDungeon = false
        -- 选中第一个
        self.selectDungeonId = self.hardDungeonsData[1].id
        self:RefreshSelectDungeonInfo()

        if not self.hardDungeonExpandFlag then
            self.hardDungeonExpandFlag = true
            self:PlayArrowTween()
        end
    end)

    self.panel.Collider:AddClick(function()
        self:ShowAffixPanel(true)
    end)

    self.panel.AffixPanelMask:AddClick(function()
        self:ShowAffixPanel(false)
    end)

    self.panel.HardKeyCollider:AddClick(function()
        self:AutoPutKey()
    end)

    self.panel.ButtonAffix:AddClick(function()
        self:ShowAffixPanel(true)
    end)
end

function ThemeArroundCtrl:InitTemplatePools()

    self.hardItemTemplatePool = self:NewTemplatePool({
        UITemplateClass = UITemplate.ThemeDungeonHardItemTemplate,
        TemplatePrefab = self.panel.ThemeDungeonHardItem.gameObject,
        TemplateParent = self.panel.HardItemParent.transform,
        ScrollRect = self.panel.ScrollviewHard.LoopScroll,
    })

    self.rewardItemTemplatePool = self:NewTemplatePool({
        UITemplateClass = UITemplate.ItemTemplate,
        TemplateParent = self.panel.RewardContent.transform,
    })

    self.affixTemplatePool = self:NewTemplatePool({
        UITemplateClass = UITemplate.ThemeDungeonAffixTemplate,
        TemplatePrefab = self.panel.ThemeDungeonAffix.gameObject,
        TemplateParent = self.panel.AffixContent.transform,
    })

    self.affixItemTemplatePool = self:NewTemplatePool({
        UITemplateClass = UITemplate.ThemeDungeonAffixItemTemplate,
        TemplatePrefab = self.panel.ThemeDungeonAffixItem.gameObject,
        TemplateParent = self.panel.AffixDetailContent.transform,
    })
end

function ThemeArroundCtrl:ShowAffixPanel(show)

    if show ~= nil then
        self.affixPanelShow = show
    else
        self.affixPanelShow = not self.affixPanelShow
    end

    if self.affixPanelTweenId then
        MUITweenHelper.KillTween(self.affixPanelTweenId)
        self.affixPanelTweenId = nil
    end

    self.panel.AffixPanelMask.gameObject:SetActiveEx(self.affixPanelShow)
    if self.affixPanelShow then
        local l_datas = l_data.GetDungeonAffixs(self.selectDungeonId) or {}
        self.affixItemTemplatePool:ShowTemplates({ Datas = table.ro_reverse(l_datas) })

        local l_count = #l_datas
        if l_count > 4 then
            l_count = 4
        end

        local l_height = (78 * l_count) - (l_count - 1) * 9
        MLuaCommonHelper.SetRectTransformHeight(self.panel.affixPanelBg.gameObject, l_height + 10)
        MLuaCommonHelper.SetRectTransformHeight(self.panel.ScrollViewAffix.gameObject, l_height)

        self.panel.AnimPoint.gameObject:SetActiveEx(true)
        self.panel.AffixPanel.gameObject:SetActiveEx(true)
    end

    local l_from_pos, l_desc_pos = Vector3(406, 83, 0), Vector3(406, 103, 0)
    local l_from_alpha, l_to_alpha = 0, 1

    if self.affixPanelShow then
    else
        l_from_pos, l_desc_pos = l_desc_pos, l_from_pos
        l_from_alpha, l_to_alpha = l_to_alpha, l_from_alpha
    end
    local l_show = self.affixPanelShow
    self.affixPanelTweenId = MUITweenHelper.TweenPosAlpha(self.panel.AnimPoint.gameObject, l_from_pos, l_desc_pos, l_from_alpha, l_to_alpha, 0.3, function()
        self.affixPanelTweenId = nil
        if not l_show then
            self.panel.AnimPoint.gameObject:SetActiveEx(false)
            self.panel.AffixPanel.gameObject:SetActiveEx(false)
        end
    end)
end

---@return ItemData
function ThemeArroundCtrl:_getBagItemByUID(uid)
    if nil == uid then
        logError("[ItemMgr] uid got nil")
        return nil
    end

    local types = { GameEnum.EBagContainerType.Bag }
    local itemFuncUtil = MgrProxy:GetItemDataFuncUtil()
    ---@type FiltrateCond
    local condition = { Cond = itemFuncUtil.IsItemUID, Param = uid }
    local conditions = { condition }
    local ret = Data.BagApi:GetItemsByTypesAndConds(types, conditions)
    return ret[1]
end

function ThemeArroundCtrl:AutoPutKey()
    if self.selectKey then
        log("已经选择key了")
        return
    end

    local l_inTeam, l_isCaptain = DataMgr:GetData("TeamData").GetPlayerTeamInfo()
    if not l_isCaptain then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("THEME_DUNGEON_HARD_CAPTAIN"))
        return
    end

    local l_propList = {}
    l_propList[self.hardKeyId] = 1
    local l_result = Data.BagModel:getPropList(l_propList)
    if not l_result or #l_result <= 0 then
        MgrMgr:GetMgr("ItemTipsMgr").ShowTipsDisplayWithId(self.hardKeyId, nil, nil, nil, true)
        return
    end

    -- 筛选一个最近到期的
    local l_prop
    local l_remainningTime = 1000000000
    for i, v in ipairs(l_result) do
        local l_propInfo = self:_getBagItemByUID(v.UID)
        if l_propInfo then
            local l_itemRow = TableUtil.GetItemTable().GetRowByItemID(l_propInfo.TID)
            if l_itemRow then
                if not l_prop then
                    l_prop = v
                    l_remainningTime = l_propInfo:GetRemainingTime()
                else
                    local l_time = l_propInfo:GetRemainingTime()
                    if l_time < l_remainningTime then
                        l_remainningTime = l_time
                        l_prop = v
                    end
                end
            end
        end
    end

    self.selectKey = l_prop
    if l_prop == nil then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("THEME_DUNGEON_HARD_LACK_KEY"))
    else
        self:PlayPutKeyAnim()
        self.putKeyTimer = self:NewUITimer(function()
            self.panel.PushKeyPanel.gameObject:SetActiveEx(false)
            self.panel.PanelMain.gameObject:SetActiveEx(true)

            if self.fxRecords["PlayPutKeyAnimFollow"] then
                self:DestroyUIEffect(self.fxRecords["PlayPutKeyAnimFollow"].fx)
                self.fxRecords["PlayPutKeyAnimFollow"] = nil
            end

            if self.fxRecords["PlayPutKeyAnimAfter"] then
                self:DestroyUIEffect(self.fxRecords["PlayPutKeyAnimAfter"].fx)
                self.fxRecords["PlayPutKeyAnimAfter"] = nil
            end

            if self.putKeySuccessModel then
                self:DestroyUIModel(self.putKeySuccessModel)
                self.putKeySuccessModel = nil
            end

            self:RefreshDetailPanel()
        end, 4)
        self.putKeyTimer:Start()
    end
end

function ThemeArroundCtrl:ClickForward()
    if not self.selectNormalDungeon then
        if not self.selectKey then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("THEME_DUNGEON_HARD_KEY"))
            return
        end
    end
    -- 主题副本解锁
    local l_themeRow = TableUtil.GetThemeDungeonTable().GetRowByThemeDungeonID(self.themeDungeonID)
    if MPlayerInfo.Lv < l_themeRow.ChapterLevel then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("THEME_DUNGEOM_UNLOCK_FORMAT", l_themeRow.ChapterLevel, l_themeRow.ThemeName))
        return
    end
    if self.selectDungeonId ~= self.normalDungeonId then
        -- 判断是否解锁
        if not self:IsDungeonUnlock(self.selectDungeonId) then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("NOT_UNLOCK"))
            return
        end
        -- 判断服务器等级是不是够
        local l_row = TableUtil.GetGreatSecretTable().GetRowByGreatSecretID(self.selectDungeonId)
        if not l_row then
            logError("Unexpected error, 配置不存在", self.selectDungeonId)
            return
        end

        if l_row.ServerOpeningLevel > self.serverLevel then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("THEME_DUNGEON_HARD_OPEN_FORMAT", l_row.ServerOpeningLevel))
            return
        end
    end

    MgrMgr:GetMgr("DungeonMgr").EnterDungeons(self.selectDungeonId, 0, 0)
end

function ThemeArroundCtrl:CreateFxForRT(path, name, com, pos, scale, parent)

    if self.fxRecords[name] then
        if self.fxRecords[name].path == path then
            return
        end
        self:DestroyUIEffect(self.fxRecords[name].fx)
        self.fxRecords[name] = nil
    end

    local l_effectFxData = {}
    l_effectFxData.rawImage = com.RawImg
    l_effectFxData.rotation = Quaternion.Euler(0, 0, 0)

    if pos then
        l_effectFxData.position = pos
    end

    if scale then
        l_effectFxData.scaleFac = scale
    end

    if parent then
        l_effectFxData.parent = parent
    end

    com.gameObject:SetActiveEx(false)
    l_effectFxData.loadedCallback = function(a)
        com.gameObject:SetActiveEx(true)
    end
    l_effectFxData.destroyHandler = function()
        self.fxRecords[name] = nil
    end
    self.fxRecords[name] = {
        fx = self:CreateUIEffect(l_commonFxPath .. path, l_effectFxData),
        path = path,
    }
end

function ThemeArroundCtrl:PlayPutKeyAnim()
    self.panel.PushKeyPanel.gameObject:SetActiveEx(true)
    self.panel.PanelMain.gameObject:SetActiveEx(false)
    if self.fxRecords["PlayPutKeyAnimFollow"] then
        self:DestroyUIEffect(self.fxRecords["PlayPutKeyAnimFollow"].fx)
        self.fxRecords["PlayPutKeyAnimFollow"] = nil
    end

    if self.fxRecords["PlayPutKeyAnimAfter"] then
        self:DestroyUIEffect(self.fxRecords["PlayPutKeyAnimAfter"].fx)
        self.fxRecords["PlayPutKeyAnimAfter"] = nil
    end

    if self.showKeyEnterTimer then
        self:StopUITimer(self.showKeyEnterTimer)
        self.showKeyEnterTimer = nil
    end

    if self.putKeySuccessModel then
        self:DestroyUIModel(self.putKeySuccessModel)
        self.putKeySuccessModel = nil
    end

    self.panel.ModelImg.RawImg.gameObject:SetActive(false)
    self.panel.ModelFxImg.gameObject:SetActiveEx(false)
    self.panel.ModelTailFxImg.gameObject:SetActiveEx(false)
    local l_modelData = {
        prefabPath = "Prefabs/Item_Collect_BaoShiXiangQie",
        rawImage = self.panel.ModelImg.RawImg,
        defaultAnim = "Anims/Collection/Item_Collect_BaoShiXiangQie/Item_Collect_BaoShiXiangQie_Idle",
    }
    self.putKeySuccessModel = self:CreateUIModelByPrefabPath(l_modelData)
    self.putKeySuccessModel:AddLoadModelCallback(function(m)
        self.panel.ModelImg.RawImg.gameObject:SetActive(true)
        self.putKeySuccessModel.Trans:SetLocalScale(0.087, 0.087, 0.087)
        self.putKeySuccessModel.UObj:SetRotEuler(0, 180, 0)

        local l_effectFxData = {}
        l_effectFxData.position = Vector3.New(0, 0, -12.52)
        l_effectFxData.scaleFac = Vector3.New(1 / 0.087, 1 / 0.087, 1 / 0.087)
        l_effectFxData.rawImage = self.panel.ModelTailFxImg.RawImg
        l_effectFxData.parent = self.putKeySuccessModel.Trans:Find("Item_Collect_BaoShiXiangQie_02")
        l_effectFxData.loadedCallback = function()
            self.panel.ModelTailFxImg.gameObject:SetActiveEx(true)
        end
        l_effectFxData.destroyHandler = function()
            self.fxRecords["PlayPutKeyAnimFollow"] = nil
        end
        local l_fx = self:CreateUIEffect(l_commonFxPath .. "Fx_Ui_ZhuTiFuBen_QianRuGenSui_01", l_effectFxData)
        self.fxRecords["PlayPutKeyAnimFollow"] = {
            fx = l_fx,
        }

        self.showKeyEnterTimer = self:NewUITimer(function()
            self:CreateFxForRT("Fx_Ui_ZhuTiFuBen_QianRuHou_01", "PlayPutKeyAnimAfter", self.panel.ModelFxImg, Vector3.New(-0.005, 0.13, 0), Vector3.New(1.06, 1.06, 1.06))
        end, 2.8)
        self.showKeyEnterTimer:Start()
    end)
end

function ThemeArroundCtrl:RefreshHardModel()

    if self.hardModel then
        self:RefreshHardAnim()
        return
    end
    self.panel.ModelImageRT.RawImg.gameObject:SetActive(false)
    local l_modelData = {
        prefabPath = "Prefabs/Item_Collect_BaoShiXiangQie",
        rawImage = self.panel.ModelImageRT.RawImg,
        defaultAnim = "Anims/Collection/Item_Collect_BaoShiXiangQie/Item_Collect_BaoShiXiangQie_Idle",
    }
    self.hardModel = self:CreateUIModelByPrefabPath(l_modelData)
    self.hardModel:AddLoadModelCallback(function(m)
        self.panel.ModelImageRT.RawImg.gameObject:SetActive(true)
        self.hardModel.Trans:SetPos(0, 0.2, 0)
        self.hardModel.Trans:SetLocalScale(0.087, 0.087, 0.087)
        self.hardModel.UObj:SetRotEuler(0, 180, 0)
        self:RefreshHardAnim()
    end)
end

function ThemeArroundCtrl:RefreshHardAnim()
    if not self.hardModel then
        return
    end
    if self.selectKey then
        self.hardModel.Ator.Speed = 1
        self.hardModel.Ator:Play("Idle", 1)
    else
        self.hardModel.Ator.Speed = -1
        self.hardModel.Ator:Play("Idle", 0)
    end
end

function ThemeArroundCtrl:CheckNormalLocked(notShowTips)

    return l_mgr.IsThemeDungeonLocked(self.themeDungeonID, notShowTips)
end

--lua custom scripts end
return ThemeArroundCtrl