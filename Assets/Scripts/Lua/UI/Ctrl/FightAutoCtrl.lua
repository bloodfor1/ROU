--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/FightAutoPanel"
require "Event/EventConst"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua class define
local super = UI.UIBaseCtrl
FightAutoCtrl = class("FightAutoCtrl", super)

local l_gameEventMgr = MgrProxy:GetGameEventMgr()
local l_fightMgr = MgrMgr:GetMgr("FightAutoMgr")
--lua class define end

--lua functions
function FightAutoCtrl:ctor()

    super.ctor(self, CtrlNames.FightAuto, UILayer.Function, nil, ActiveType.Normal)
    self.cacheGrade = EUICacheLv.VeryLow
    self.monsterList = {}

end --func end
--next--
function FightAutoCtrl:Init()

    self.panel = UI.FightAutoPanel.Bind(self)
    super.Init(self)
    self:CustomInit()

end --func end
--next--
function FightAutoCtrl:Uninit()

    self:CustomUnInit()

    super.Uninit(self)
    self.panel = nil

end --func end
--next--
function FightAutoCtrl:OnActive()

    self:CustomActive()

    self:ShowRangeFx()

    -- 新手引导
    MgrMgr:GetMgr("BeginnerGuideMgr").CheckShowBeginnerGuide({"AutoBattleMainUI"})

end --func end
--next--
function FightAutoCtrl:OnDeActive()

    self:CustomDeActive()

    self:HideRangeFx()

    -- 新手引导
    if MPlayerInfo.IsAutoBattle then
        MgrMgr:GetMgr("BeginnerGuideMgr").CheckShowBeginnerGuide({"AutoBattleOnceClose"})
    end

end --func end
--next--
function FightAutoCtrl:Update()


end --func end

--next--
function FightAutoCtrl:BindEvents()
    --死亡时关闭界面
    self:BindEvent(GlobalEventBus,EventConst.Names.PlayerDead,function(self)
        UIMgr:DeActiveUI(UI.CtrlNames.FightAuto)
    end)
    self:BindEvent(GlobalEventBus,EventConst.Names.RefreshFightAutoPanel, function(self)
        self:UpdateMonsterList()
    end)
    self:BindEvent(l_gameEventMgr.l_eventDispatcher,l_gameEventMgr.OnAutoBattleSettingsConfirmed,self._updateDescLab)
end --func end
--next--
--lua functions end

--lua custom scripts
function FightAutoCtrl:OnShow()
    self:ShowRangeFx()
end

function FightAutoCtrl:OnHide()
    self:HideRangeFx()
end

function FightAutoCtrl:ShowRangeFx()
    if MPlayerInfo.AutoFightRange > 0
            and MPlayerInfo.AutoFightRangeType ~= MoonClient.EAutoFightRangeType.FullMap
            and MPlayerInfo.AutoFightType == MoonClient.EAutoFightType.FullAuto then
        MPlayerInfo:PlayerAutoBattleRangeFx(1, MPlayerInfo.AutoFightRange, true)
    end
end

function FightAutoCtrl:HideRangeFx()
    MPlayerInfo:PlayerAutoBattleRangeFx(1, MPlayerInfo.AutoFightRange, false)
end

--生命周期
function FightAutoCtrl:CustomInit()
    self.panel.BtnClose:AddClick(function()
        UIMgr:DeActiveUI(UI.CtrlNames.FightAuto)
    end)
    self.panel.ClosePanel:AddClick(function()
        if not MVirtualTab.IsMoving then
            UIMgr:DeActiveUI(UI.CtrlNames.FightAuto)
        end
    end)
    self.panel.BtnSetting:AddClick(function()
        MgrMgr:GetMgr("SettingMgr").OpenAutoHandler()
    end)

    local l_onceSystemMgr = MgrMgr:GetMgr("OnceSystemMgr")
    if not l_onceSystemMgr.GetAndSetState(l_onceSystemMgr.EClientOnceType.FightAutoCtrlFirst, nil, true) then
        MgrMgr:GetMgr("CommonDataMgr").SetClientCommonData(CommondataId.kCDT_AUTO_BATTLE_STATUS, 1)
    end
    local l_AutoBattleInTask = MgrMgr:GetMgr("CommonDataMgr").GetClientCommonData(CommondataId.kCDT_AUTO_BATTLE_STATUS) == 1
    self.panel.TogAutoBattleInTask.Tog.isOn = l_AutoBattleInTask
    self.panel.TogAutoBattleInTask:OnToggleChanged(function(on)
        local l_value = on and 1 or 0
        MgrMgr:GetMgr("CommonDataMgr").SetClientCommonData(CommondataId.kCDT_AUTO_BATTLE_STATUS, l_value)
    end)

    self:_updateDescLab()
end

function FightAutoCtrl:CustomUnInit()

end

function FightAutoCtrl:CustomActive()

    --local l_isOpen = MgrMgr:GetMgr("OpenSystemMgr").IsSystemOpen(1204)
    self.panel.BtnSetting.gameObject:SetActiveEx(true)
    self:InitMonsterList(self:FindEnemy())
    self.TouchVirtualTab = false

    self.panel.MonsterItemScrollView:OnScrollRectChange(function()
        self:RefreshArrow()
    end)

    self:_updateDescLab()
    local playerLv = MPlayerInfo.Lv
    self.panel.BtnDrinkMedicine.gameObject:SetActiveEx(playerLv < 55)
    self.panel.BtnDrinkMedicine:AddClick(function ()
        local tuid = TableUtil.GetTutorialIndexTable().GetRowByID("GetAutoDevOpenBag")
        MgrMgr:GetMgr("BeginnerGuideMgr").l_guideData.guideState[tuid.Condition[0][0]] = false
        tuid = TableUtil.GetTutorialIndexTable().GetRowByID("GetAutoDev")
        MgrMgr:GetMgr("BeginnerGuideMgr").l_guideData.guideState[tuid.Condition[0][0]] = false
        tuid = TableUtil.GetTutorialIndexTable().GetRowByID("GetAutoDevOpenPanel")
        MgrMgr:GetMgr("BeginnerGuideMgr").l_guideData.guideState[tuid.Condition[0][0]] = false
        tuid = TableUtil.GetTutorialIndexTable().GetRowByID("GetAutoDevOpenTip")
        MgrMgr:GetMgr("BeginnerGuideMgr").l_guideData.guideState[tuid.Condition[0][0]] = false
        UIMgr:DeActiveUI(UI.CtrlNames.FightAuto)
        local l_beginnerGuideChecks = { "GetAutoDev" }
        MgrMgr:GetMgr("BeginnerGuideMgr").CheckShowBeginnerGuide(l_beginnerGuideChecks, UI.CtrlNames.Main)
    end)
end

function FightAutoCtrl:CustomDeActive()
    self:UnInitMonsterList()
end
--生命周期

--初始化界面

--当单个Toggle进行改变的时候会改变全部魔物Toggle这时候不能让全部魔物Toggle再次修改下面的单个Toggle
local enableSelectAll = true

function FightAutoCtrl:RefreshArrow()
    local l_viewPortHeight = self.panel.MonsterItemViewPort.RectTransform.rect.height
    local l_contentHeight = self.panel.Content.RectTransform.rect.height
    local l_contentY = self.panel.Content.RectTransform.localPosition.y
    if l_viewPortHeight < l_contentHeight - l_contentY then
        self.panel.ShowMoreArrow:SetActiveEx(true)
    else
        self.panel.ShowMoreArrow:SetActiveEx(false)
    end
end

function FightAutoCtrl:InitMonsterList(monsterList)

    self.monsterList = monsterList
    self.selectTogTable = {}
    self.selectAllTog = nil

    -- 对怪物进行排序

    local instance = self.panel.TogSelectInstance.gameObject
    instance:SetActiveEx(true)
    for index = 1, #monsterList do

        local monsterInfoTable = monsterList[index]
        local monsterId = monsterInfoTable.Id

        local newTog = self:CloneObj(instance)

        newTog.transform:SetParent(self.panel.Content.transform)
        newTog.transform:SetLocalScaleOne()

        local com = newTog:GetComponent("MLuaUICom")
        self.selectTogTable[monsterId] = self:GetSelectToggle(com, monsterInfoTable.Name, monsterInfoTable.Lv, monsterId,function(on)
            -- 变身状态无法进入自动战斗
            local l_player = MEntityMgr.PlayerEntity
            if on and l_player and l_player.IsTransfigured then
                MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("AUTO_BATTLE_TRANSFITURATION"))
                com.Tog.isOn = false
                return
            end

            if on then
                MPlayerInfo:AddMonsterTarget(monsterId)
            else
                MPlayerInfo:RemoveMonsterTarget(monsterId)
                if self.selectAllTog ~= nil then
                    enableSelectAll = false
                    self.selectAllTog.com.Tog.isOn = false
                    enableSelectAll = true
                end
            end
            self:UpdateAutoBattleState()
        end)
        self.selectTogTable[monsterId].com.Tog.isOn = MPlayerInfo:HasMonsterTarget(monsterId)
    end
    instance:SetActiveEx(false)
    self.selectAllTog = self:GetSelectToggle(self.panel.TogSelectAll, Common.Utils.Lang("FIGHTAUTO_ALL_MONSTER"), nil, nil, function(on)
        -- 变身状态无法进入自动战斗
        local l_player = MEntityMgr.PlayerEntity
        if on and l_player and l_player.IsTransfigured then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("AUTO_BATTLE_TRANSFITURATION"))
            self.panel.TogSelectAll.Tog.isOn = false
            return
        end
        MPlayerInfo.AutoBattleAttackAll = on
        if enableSelectAll then
            for k, v in pairs(self.selectTogTable) do
                v.com.Tog.isOn = on
            end
        end
        self:UpdateAutoBattleState()
    end)
    self.selectAllTog.com.Tog.isOn = MPlayerInfo.AutoBattleAttackAll
    self:UpdateAutoBattleState()

    LayoutRebuilder.ForceRebuildLayoutImmediate(self.panel.Content.RectTransform)

    self:RefreshArrow()
end

function FightAutoCtrl:UnInitMonsterList()
    if self.panel == nil then
        return
    end

    for k, v in pairs(self.selectTogTable) do
        if not MLuaCommonHelper.IsNull(v) then
            v.com:OnToggleChanged(nil)
            v.com.Tog.isOn = false
        end

    end
    self.selectTogTable = {}
    if not MLuaCommonHelper.IsNull(self.selectAllTog) then
        self.selectAllTog.com:OnToggleChanged(nil)
        self.selectAllTog.com.Tog.isOn = false
    end
    self.selectAllTog = nil
    local content = self.panel.Content
    local childCount = content.transform.childCount
    if childCount > 0 then
        for i = childCount - 1, 0, -1 do
            local child = content.transform:GetChild(i)
            MResLoader:DestroyObj(child.gameObject)
        end
    end
end

function FightAutoCtrl:UpdateMonsterList()
    local monsterList = self:FindEnemy()

    local needUpdate = false
    if #monsterList == 0 then
        needUpdate = true
    else
        for i = 1, #monsterList do
            if self.monsterList == nil or self.monsterList[i] == nil or monsterList[i] == nil or self.monsterList[i].Name ~= monsterList[i].Name then
                needUpdate = true
                break
            end
        end
    end

    if needUpdate then
        self:UnInitMonsterList()
        self:InitMonsterList(monsterList)
    end
end

--初始化界面

--通用方法

--找到敌人
function FightAutoCtrl:FindEnemy()
    local l_entityList = MEntityMgr:GetOpponentByLua(MEntityMgr.PlayerEntity, true, -1)
    local l_enemyList = {}
    local  l_exist = {}
    for i = 0, l_entityList.Count - 1 do
        local l_entity = l_entityList[i]
        if l_entity.IsMonster and not l_exist[l_entity.AttrComp.EntityID] then
            l_exist[l_entity.AttrComp.EntityID] = true
            local l_entityRow = TableUtil.GetEntityTable().GetRowById(l_entity.AttrComp.EntityID)
            if l_entityRow then
                table.insert(l_enemyList, {Id = l_entity.AttrComp.EntityID,
                                           Name = l_entity.Name,
                                           Entity = l_entity,
                                           Lv = l_entity.AttrComp.Level,
                                           EntityRow = l_entityRow
                })
            end
        end
    end
    local l_priority = {
        [2] = -9,
        [5] = -8,
        [4] = -7
    }
    table.sort(l_enemyList, function(enemy1, enemy2)
        local l_p1 = l_priority[enemy1.EntityRow.UnitTypeLevel] or enemy1.EntityRow.UnitTypeLevel
        local l_p2 = l_priority[enemy2.EntityRow.UnitTypeLevel] or enemy2.EntityRow.UnitTypeLevel
        if l_p1 ~= l_p2 then return l_p1 < l_p2 end
        return enemy1.Lv > enemy2.Lv
    end)
    return l_enemyList
end

--获得Toggle并且进行初始化
function FightAutoCtrl:GetSelectToggle(com, name, lv, entityId, onTogChanged)
    local toggleTable = {}
    toggleTable.com = com
    toggleTable.name = MLuaClientHelper.GetOrCreateMLuaUICom(com.transform:Find("Name").gameObject)
    toggleTable.monsterIcon = com.transform:Find("MonsterIcon")
    if toggleTable.monsterIcon then
        toggleTable.monsterIcon = toggleTable.monsterIcon:GetComponent("MLuaUICom")
    end
    toggleTable.selectedBG = com.transform:Find("Background/Checkmark").gameObject
    if lv then
        toggleTable.lv = MLuaClientHelper.GetOrCreateMLuaUICom(com.transform:Find("Lv").gameObject)
        toggleTable.lv.LabText = string.ro_concat("Lv.", lv)
    end
    toggleTable.name.LabText = name
    if com.Tog.isOn then
        toggleTable.selectedBG:SetActiveEx(true)
        -- toggleTable.name.color = Color.New(71 / 255.0, 92 / 255.0, 112 / 255.0)
    else
        toggleTable.selectedBG:SetActiveEx(false)
        -- toggleTable.name.color = Color.New(176 / 255.0, 174 / 255.0, 174 / 255.0)
    end

    -- icon设置
    if toggleTable.monsterIcon then
        toggleTable.monsterIcon:SetActiveEx(false)
        if not self.monsterIcons then
            self.monsterIcons = {
                [2] = {altas = "Common", icon = "UI_Common_Identification_Mvp.png"},       -- boss
                [4] = {altas = "Common", icon = "UI_Common_Identification_MiniBoss.png"},       -- mini
                [5] = {altas = "Common", icon = "UI_Common_Identification_Mvp.png"},       -- mvp
            }
        end
        if entityId then
            local l_entityRow = TableUtil.GetEntityTable().GetRowById(entityId)
            if l_entityRow and self.monsterIcons[l_entityRow.UnitTypeLevel] then
                toggleTable.monsterIcon:SetActiveEx(true)
                toggleTable.monsterIcon:SetSprite(self.monsterIcons[l_entityRow.UnitTypeLevel].altas, self.monsterIcons[l_entityRow.UnitTypeLevel].icon)
            end
        end
    end
    com:OnToggleChanged(function(on)
        if on then
            toggleTable.selectedBG:SetActiveEx(true)
            --toggleTable.name.color = Color.New(71 / 255.0, 92 / 255.0, 112 / 255.0)
        else
            toggleTable.selectedBG:SetActiveEx(false)
            --toggleTable.name.color = Color.New(176 / 255.0, 174 / 255.0, 174 / 255.0)
        end
        onTogChanged(on)
    end)
    return toggleTable
end

function FightAutoCtrl:UpdateAutoBattleState()
    if MPlayerInfo.AutoBattleAttackAll == true then
        MPlayerInfo.IsAutoBattle = true
        GlobalEventBus:Dispatch(EventConst.Names.UpdateAutoBattleState, true)
        return
    end

    if MPlayerInfo.AutoBattleList.Count == 0 then
        MPlayerInfo.IsAutoBattle = false
        GlobalEventBus:Dispatch(EventConst.Names.UpdateAutoBattleState, false)
    else
        MPlayerInfo.IsAutoBattle = true
        GlobalEventBus:Dispatch(EventConst.Names.UpdateAutoBattleState, true)
    end
end

function FightAutoCtrl:UpdateInput(touchItem)
    if self.panel == nil then
        return
    end

    MVirtualTab:Feed(touchItem)
end

-- 更新描述
-- 描述更新只有在功能解锁和玩家选项变化的时候会更新
function FightAutoCtrl:_updateDescLab()
    if MPlayerInfo.AutoFightType == MoonClient.EAutoFightType.FullAuto then
        self.panel.AutoText.LabText = Lang("FULL_AUTO")
        if MPlayerInfo.AutoFightRangeType == MoonClient.EAutoFightRangeType.FullMap then      -- 全地图
            self.panel.RangeText.LabText = Lang("AUTO_FIGHT_FULL_MAP")
        else
            if MPlayerInfo.AutoFightRange == 0 then
                self.panel.RangeText.LabText = Lang("AUTO_FIGHT_HOLD")
            else
                self.panel.RangeText.LabText = MPlayerInfo.AutoFightRange .. "m"
            end
        end
    elseif MPlayerInfo.AutoFightType == MoonClient.EAutoFightType.SemiAuto then
        self.panel.AutoText.LabText = Lang("SEMI_AUTO")
        self.panel.RangeText.LabText = Lang("NOT_IN_EFFECT")
    end
    --self.panel.Text_Auto_Range.LabText = l_fightMgr.GetAutoFightRangeDesc()
    --self.panel.Text_Auto_Dose.LabText = l_fightMgr.GetAutoDoseDesc()
end

return FightAutoCtrl

--通用方法
--lua custom scripts end
