--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/SkillSelectBossPanel"
require "UI/Template/TargetGroupTemplate"
--lua requires end

--lua model
module("UI", package.seeall)

--lua model end

--lua fields
local super = UI.UIBaseCtrl
local MonsterType = {
    [0] = "",
    [1] = "",
    [4] = "MINI",
    [5] = "MVP",
    [2] = "BOSS"
}

local MonsterNameToUnitTypeLevel =
{
    BOSS = 2,
    MINI = 4,
    MVP = 5
}

local UnitTypeLevelList = {
    2,4,5
}

-- Prefab上GameObject的MLuaUIPanel名
local UnitTypeLevelToBtnGOName = {
    [2] = "SelectBoss",
    [4] = "SelectMini",
    [5] = "SelectMVP"
}

local UnitTypeLevelToHeadGOName = {
    [2] = "SelectBossHead",
    [4] = "SelectMiniHead",
    [5] = "SelectMVPHead"
}

local UnitTypeLevelToHPGOName = {
    [2] = "SelectBossHP",
    [4] = "SelectMiniHP",
    [5] = "SelectMVPHP"
}

local UnitTypeLevelToAnimHelperGOName = {
    [2] = "SelectBossAnimHelper",
    [4] = "SelectMiniAnimHelper",
    [5] = "SelectMVPAnimHelper"
}

local SortType = {
    [2] = 1,
    [5] = 2,
    [4] = 3,
    [1] = 4,
    [0] = 5
}
local MAX_TYPE_COUNT = 2      -- 每种类型BOSS最多显示几个

local EMonster = {
    Normal = 1,
    Elite = 2,
    Boss = 4,
    Summon = 8,
    Mini = 16,
    Mvp = 32
}
local MAX_AIMCOUNT = 4

local KEY_SKILL_SELECT_BOSS_HEAD = "SkillSelectBossMgr.KEY_SKILL_SELECT_BOSS_HEAD{0}"

--lua fields end

--lua class define
SkillSelectBossCtrl = class("SkillSelectBossCtrl", super)
--lua class define end

--lua functions
function SkillSelectBossCtrl:ctor()
    
    super.ctor(self, CtrlNames.SkillSelectBoss, UILayer.Normal, nil, ActiveType.Normal)
    self.overrideSortLayer = UILayerSort.Normal + 2
    
end --func end
--next--
function SkillSelectBossCtrl:Init()
    self.panel = UI.SkillSelectBossPanel.Bind(self)
    super.Init(self)

    self.TargetsPool = self:NewTemplatePool({
        UITemplateClass = UITemplate.TargetGroupTemplate,
        ScrollRect = self.panel.AimPanel.LoopScroll,
        TemplatePrefab = self.panel.TargetGroup.gameObject
    })

    self.panel.TargetGroup.gameObject:SetActiveEx(false)
    self.panel.AimPanel.gameObject:SetActiveEx(false)

    self.curRangeMonsterList = {}       -- 当前范围内的所有boss,mvp,mini列表
    self.curRangeMonsterList[MonsterNameToUnitTypeLevel["BOSS"]] = {}
    self.curRangeMonsterList[MonsterNameToUnitTypeLevel["MVP"]] = {}
    self.curRangeMonsterList[MonsterNameToUnitTypeLevel["MINI"]] = {}

    self.curShowMonsterList = {}        -- 当前显示的boss,mvp,mini，同一类型最多显示2个
    self.curShowMonsterList[MonsterNameToUnitTypeLevel["BOSS"]] = {}
    self.curShowMonsterList[MonsterNameToUnitTypeLevel["MVP"]] = {}
    self.curShowMonsterList[MonsterNameToUnitTypeLevel["MINI"]] = {}

    self.bossHead = {}
    self.bossHead[MonsterNameToUnitTypeLevel["BOSS"]] = {}
    self.bossHead[MonsterNameToUnitTypeLevel["MVP"]] = {}
    self.bossHead[MonsterNameToUnitTypeLevel["MINI"]] = {}

    local rangRect = self.panel.RangeRect.RectTransform
    local width = rangRect.rect.width
    local height = rangRect.rect.height
    local pos = self.panel.RangeRect.transform.localPosition
    local leftBottomPos = self.panel.RangeRect.transform.parent:TransformPoint(pos.x - width/2,pos.y - height/2,0)
    local rightTopPos = self.panel.RangeRect.transform.parent:TransformPoint(pos.x + width/2,pos.y + height/2,0)
    self.SelectBtnLeave = {
        xMin = leftBottomPos.x,
        xMax = rightTopPos.x,
        yMin = leftBottomPos.y,
        yMax = rightTopPos.y,
    }

    for _,v in ipairs(UnitTypeLevelList) do
        for i = 1,MAX_TYPE_COUNT do
            self.panel[UnitTypeLevelToBtnGOName[v]][i].gameObject:SetActiveEx(false)

            self.panel[UnitTypeLevelToBtnGOName[v]][i].Listener.onLongPress = function(uobj, event)
                self._longPressBegin = true
            end

            self.panel[UnitTypeLevelToBtnGOName[v]][i].Listener.onDrag = function(uobj, event)
                if self._longPressBegin then
                    local l_cgPos = MUIManager.UICamera:ScreenToWorldPoint(event.position)
                    l_cgPos = self:CorrectPosition(l_cgPos)
                    l_cgPos.z = 0
                    self.panel[UnitTypeLevelToBtnGOName[v]][i].transform.position = l_cgPos
                end
            end
            self.panel[UnitTypeLevelToBtnGOName[v]][i].Listener.endDrag = function(uobj, event)
                if self._longPressBegin then
                    self._longPressBegin = false
                    local pos = self.panel[UnitTypeLevelToBtnGOName[v]][i].transform.position
                    local x,y = pos.x,pos.y
                    UserDataManager.SetDataFromLua( StringEx.Format(KEY_SKILL_SELECT_BOSS_HEAD,v*100+i), MPlayerSetting.PLAYER_SETTING_GROUP, StringEx.Format("{0}|{1}",x,y))
                end
            end
            self.panel[UnitTypeLevelToBtnGOName[v]][i].Listener.onClick = function(uobj, event)
                if self.curShowMonsterList[v][i] then
                    MSkillTargetMgr.singleton:FindTargetById(self.curShowMonsterList[v][i])
                end
            end

            local settingData = UserDataManager.GetStringDataOrDef(StringEx.Format(KEY_SKILL_SELECT_BOSS_HEAD,v*100+i), MPlayerSetting.PLAYER_SETTING_GROUP, "")
            if settingData ~= "" then
                local data = string.ro_split(settingData,'|')
                local x,y = tonumber(data[1]),tonumber(data[2])
                local pos = self:CorrectPosition(Vector3.New(x,y,0))
                self.panel[UnitTypeLevelToBtnGOName[v]][i].transform.position = pos
            end
        end
    end
    --[[
    self.panel.AimSelect[1].gameObject:SetActiveEx(false)
    self.panel.SelectName[1].LabText = "MINI"
    self.panel.AimSelect[2].gameObject:SetActiveEx(false)
    self.panel.SelectName[2].LabText = "MVP"
    self.panel.AimSelect[1]:AddClick(function()
        if self.curMVPList[1] then
            MSkillTargetMgr.singleton:FindTargetById(self.curMVPList[1].UID)
        end
    end)
    self.panel.AimSelect[2]:AddClick(function()
        if self.curMVPList[2] then
            MSkillTargetMgr.singleton:FindTargetById(self.curMVPList[2].UID)
        end
    end)
    ]]
end --func end
--next--
function SkillSelectBossCtrl:Uninit()
    
    super.Uninit(self)
    self.panel = nil
    self.TargetsPool = nil

    self.curRangeMonsterList = nil
    self.curShowMonsterList = nil
    self.bossHead = nil
    self.curTargetUID = nil
end --func end
--next--
function SkillSelectBossCtrl:OnActive()
    
end --func end
--next--
function SkillSelectBossCtrl:OnDeActive()
    
end --func end
--next--
function SkillSelectBossCtrl:Update()

    if MoonClient.MRaycastTouchUtils.IsNoTouchedForLua(self.panel.AimPanel.UObj, true, UnityEngine.TouchPhase.Began) then
        self.panel.AimPanel.gameObject:SetActiveEx(false)
    end
    
end --func end
--next--
function SkillSelectBossCtrl:Refresh()
    
    
end --func end
--next--
function SkillSelectBossCtrl:OnLogout()
    
    
end --func end
--next--
function SkillSelectBossCtrl:OnReconnected(roleData)
    
    
end --func end
--next--
function SkillSelectBossCtrl:OnShow()

end --func end
--next--
function SkillSelectBossCtrl:OnHide()
    
end --func end
--next--
function SkillSelectBossCtrl:BindEvents()

    self:BindEvent(GlobalEventBus, EventConst.Names.SendAimTarget, function(self, targets)
        local targetData = {}
        for z = 0, targets.Count - 1 do
            if MonsterType[targets[z]:GetUnitTypeLevel()] then
                local attr = {}
                attr.name = targets[z].Name
                attr.typeName =  MonsterType[targets[z]:GetUnitTypeLevel()]
                attr.type = targets[z]:GetUnitTypeLevel()
                attr.id = targets[z].UID
                table.insert(targetData, attr)
            end
        end
        if #targetData > 0 then
            self:SetData(targetData)
        else
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("NOT_AIM_TARGET"))
        end
    end)
    self:BindEvent(GlobalEventBus, EventConst.Names.BossAimOut, function(self, uid, type)
        self:UpdateRangeData(type,uid, false)
    end)
    self:BindEvent(GlobalEventBus, EventConst.Names.BossAimIn, function(self, uid, type)
        self:UpdateRangeData(type,uid, true)
    end)
    self:BindEvent(GlobalEventBus, EventConst.Names.BossHPUpdate, function(self,uid,type,hp,maxHp)
        self:UpdateHp(uid,type,hp,maxHp)
    end)

    self:BindEvent(GlobalEventBus, EventConst.Names.BossAimSettingChange, function(self)
        self:UpdateAllByTypeList()
    end)

    self:BindEvent(MgrMgr:GetMgr("PlayerInfoMgr").EventDispatcher, MgrMgr:GetMgr("PlayerInfoMgr").SET_MAIN_TARGET_EVENT,function(_, uid, name, lv, isRole)
        --if not MPlayerSetting.AssistMvpShow then return end
        if uint64.equals(self.curTargetUID, uid) then return end
        self.curTargetUID = uid
        self:UpdateAllByTypeList()
    end)

end --func end
--next--
--lua functions end

--lua custom scripts
function SortFunc(a, b)
    return SortType[a.type] < SortType[b.type];
end

function SkillSelectBossCtrl:AimSelect(id)

    self.panel.AimPanel.gameObject:SetActiveEx(false)
    --策划说选中了任意目标后就关闭UI，这样就根本不需要高亮选中边框了
    --[[for k, v in pairs(self.TargetsPool.Items) do
        if v.id == id then
            v:ShowFrame(true)
        else
            v:ShowFrame(false)
        end
    end]]

end

function SkillSelectBossCtrl:SetData(data)

    table.sort(data, SortFunc);
    local limitData = {}
    for i = 1, math.min(#data, MAX_AIMCOUNT) do
        table.insert(limitData, data[i])
    end
    self.panel.AimPanel.gameObject:SetActiveEx(true)
    self.TargetsPool:ShowTemplates({ Datas = limitData, Method = function(id, index)
        self:AimSelect(id)
    end})
    LayoutRebuilder.ForceRebuildLayoutImmediate(self.panel.AimContent.transform)

end

-- 有BOSS进出范围内时更新
function SkillSelectBossCtrl:UpdateRangeData(type,uid, isIn)
    if not type or not uid then return end
    if isIn then
        if self.curRangeMonsterList[type] then
            table.insert(self.curRangeMonsterList[type],uid)
        end
    else
        if self.curRangeMonsterList[type] then
            table.ro_removeOneSameValue(self.curRangeMonsterList[type],uid)
        end
    end
    self:UpdateAllByTypeList({type})
end

function SkillSelectBossCtrl:UpdateAllByTypeList(typeList)
    self:UpdateDataByTypeList(typeList)
    self:UpdateUIByTypeList(typeList)
end

function SkillSelectBossCtrl:UpdateDataByTypeList(typeList)
    local types = typeList
    if types == nil  then
        types = UnitTypeLevelList
    end
    for _,type in ipairs(types) do
        if not self.curRangeMonsterList[type] or not self.curShowMonsterList[type] then return end

        local rangeCount = #self.curRangeMonsterList[type]      -- 范围内类型为type的boss总数
        local showCount = 0                                     -- 当前显示快捷选择的类型为type的boss总数，总数最大为 MAX_TYPE_COUNT 个
        for i=1,MAX_TYPE_COUNT do
            if self.curShowMonsterList[type][i] then
                if uint64.equals(self.curShowMonsterList[type][i],self.curTargetUID) or not self:InRange(type,self.curShowMonsterList[type][i]) then        -- 左上角显示头像时这里不显示快捷选中
                    self.curShowMonsterList[type][i] = nil
                else
                    showCount = showCount + 1
                end
            end
        end
        if showCount < MAX_TYPE_COUNT and rangeCount > showCount then
            for _,v in ipairs(self.curRangeMonsterList[type]) do
                if not uint64.equals(self.curTargetUID,v) then
                    if not self.curShowMonsterList[type][1] then
                        if not uint64.equals(self.curShowMonsterList[type][2],v) then
                            self.curShowMonsterList[type][1] = v
                        end
                    elseif not self.curShowMonsterList[type][2] then
                        if not uint64.equals(self.curShowMonsterList[type][1],v) then
                            self.curShowMonsterList[type][2] = v
                        end
                    end
                end
            end
        end
    end
end

function SkillSelectBossCtrl:InRange(type,uid)
    local tTable = self.curRangeMonsterList[type]
    for i = #tTable, 1, -1 do
        if uint64.equals(tTable[i],uid)then
            return true
        end
    end
    return false
end

function SkillSelectBossCtrl:UpdateUIByTypeList(typeList)
    local types = typeList
    if types == nil then
        types = UnitTypeLevelList
    end
    if not MPlayerSetting.AssistMvpShow then
        for _,v in ipairs(types) do
            for i = 1,MAX_TYPE_COUNT do
                self.panel[UnitTypeLevelToBtnGOName[v]][i].gameObject:SetActiveEx(false)
            end
        end
        return
    end
    for _,type in ipairs(types) do
        -- 刷新头像、血量
        for i = 1,MAX_TYPE_COUNT do
            repeat
                if self.curShowMonsterList[type][i] then
                    self.panel[UnitTypeLevelToBtnGOName[type]][i].gameObject:SetActiveEx(true)
                    self.panel[UnitTypeLevelToAnimHelperGOName[type]][i].FxAnim:PlayAll()
                    local curEntity = MEntityMgr:GetEntity(self.curShowMonsterList[type][i],true)
                    if curEntity == nil or curEntity:Equals(nil) then
                        logError("找不到Entity，UID=="..tostring(self.curShowMonsterList[type][i]))
                        break
                    end
                    -- 头像
                    if not self.bossHead[type][i] then
                        self.bossHead[type][i] = self:CreateHead2D(self.panel[UnitTypeLevelToHeadGOName[type]][i].transform)
                    end
                    self.bossHead[type][i]:SetHead(curEntity)
                    self.bossHead[type][i]:UseMask(true)

                    local attrCom = curEntity.AttrComp
                    if not attrCom then
                        logError("Entity.AttrComp==null,UID=="..tostring(self.curShowMonsterList[type][i]))
                        break
                    end
                    -- 刷新血量
                    local hp = attrCom.HP
                    local maxHp = attrCom.MaxHP
                    self.panel[UnitTypeLevelToHPGOName[type]][i].Img.fillAmount = hp/maxHp
                else
                    self.panel[UnitTypeLevelToBtnGOName[type]][i].gameObject:SetActiveEx(false)
                end
            until true
        end
    end
end

function SkillSelectBossCtrl:UpdateHp(uid,type,hp,maxHp)
    if not self.curShowMonsterList[type] then return end
    for i=1,MAX_TYPE_COUNT do
        if uint64.equals(self.curShowMonsterList[type][i],uid) then
            self.panel[UnitTypeLevelToHPGOName[type]][i].Img.fillAmount = hp/maxHp
            break
        end
    end
end

-- 坐标限制在一个矩形范围内
function SkillSelectBossCtrl:CorrectPosition(position)
    local tPos = position
    if tPos.x < self.SelectBtnLeave.xMin then
        tPos.x = self.SelectBtnLeave.xMin
    end
    if tPos.x > self.SelectBtnLeave.xMax then
        tPos.x = self.SelectBtnLeave.xMax
    end
    if tPos.y < self.SelectBtnLeave.yMin then
        tPos.y = self.SelectBtnLeave.yMin
    end
    if tPos.y > self.SelectBtnLeave.yMax then
        tPos.y = self.SelectBtnLeave.yMax
    end
    return tPos
end
--lua custom scripts end
return SkillSelectBossCtrl