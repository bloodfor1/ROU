--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/MainTargetInfoPanel"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua class define
local super = UI.UIBaseCtrl
MainTargetInfoCtrl = class("MainTargetInfoCtrl", super)
--lua class define end

local NEED_TARGET_NAME_BOSS_TYPE = {
    [ROGameLibs.UnitTypeLevel.kUnitTypeLevel_BOSS:ToInt()] = "BOSS",
    [ROGameLibs.UnitTypeLevel.kUnitTypeLevel_Mini:ToInt()] = "MINI",
    [ROGameLibs.UnitTypeLevel.kUnitTypeLevel_MVP:ToInt()] = "MVP"
}

local m_prevHP = -1
local m_needBlin = false        -- 是否在播放boss血条blin特效
local blinSpeed = 0.06
local blinOriAlpha = 0.6

--lua functions
function MainTargetInfoCtrl:ctor()

    super.ctor(self, CtrlNames.MainTargetInfo, UILayer.Normal, nil, ActiveType.Normal)
    self.cacheGrade = EUICacheLv.VeryLow
    self:ResetTargetInfo()

end --func end
--next--
function MainTargetInfoCtrl:Init()

    self.panel = UI.MainTargetInfoPanel.Bind(self)
    super.Init(self)

    self.panel.RoleTarget.gameObject:SetActiveEx(false)
    self.panel.MonsterTarget.gameObject:SetActiveEx(false)
    self.panel.BossTarget.gameObject:SetActiveEx(false)
    self.panel.EnemyTarget.gameObject:SetActiveEx(false)
    self.panel.NpcTarget.gameObject:SetActiveEx(false)
    self.go = nil
    self.tempTargetName = ""
    self.panel.BtnKillWithoutMercy:AddClickWithLuaSelf(self._killWithGM, self)
    self:OnBuffInit()
end --func end
--next--
function MainTargetInfoCtrl:Uninit()
    self.headRole = nil
    self.headMonster = nil
    self.headBoss = nil
    self.headNpc = nil
    self.headEnemy = nil
    self:OnBuffUnInit()
    super.Uninit(self)
    self.panel = nil
end --func end
--next--
function MainTargetInfoCtrl:OnActive()
    self:ShowPanel()
    if self.uiPanelData ~= nil then
        local opType = DataMgr:GetData("TipsData").MainTargetInfoOpenType
        if self.uiPanelData.openType == opType.RefreshTargetInfo then
            self:RefreshTargetInfo(self.uiPanelData.targetUid, self.uiPanelData.targetName, self.uiPanelData.targetLv, self.uiPanelData.targetIsRole, self.uiPanelData.targetIsEnemy, self.uiPanelData.targetIsNpc, self.uiPanelData.targetIsCollection, self.uiPanelData.targetIsMercenary)
            MgrMgr:GetMgr("PlayerInfoMgr").DisPatchSetTarget(self.uiPanelData.targetUid, self.uiPanelData.targetName, self.uiPanelData.targetLv, self.uiPanelData.targetIsRole, self.uiPanelData.targetIsEnemy, self.uiPanelData.targetIsNpc, self.uiPanelData.targetIsCollection, self.uiPanelData.targetIsMercenary)
        elseif self.uiPanelData.openType == opType.RefreshTargetHP then
            self:RefreshTargetHP(self.uiPanelData.uid, self.uiPanelData.hp, self.uiPanelData.maxhP)
        elseif self.uiPanelData.openType == opType.RefreshTargetSP then
            self:RefreshTargetSP(self.uiPanelData.uid, self.uiPanelData.sp, self.uiPanelData.maxSP)
        elseif self.uiPanelData.openType == opType.RefreshTargetTargetName then
            self:RefreshTargetTargetName(self.uiPanelData.uid, self.uiPanelData.targetUID)
        end
    end
end --func end
--next--
function MainTargetInfoCtrl:OnDeActive()


end --func end
--next--
function MainTargetInfoCtrl:Update()


    if m_needBlin then
        local newAlpha = self.panel.Blin.CanvasGroup.alpha
        newAlpha = newAlpha + blinSpeed
        if newAlpha >= 1 then
            m_needBlin = false
            self.panel.Blin.CanvasGroup.alpha = 0
        else
            self.panel.Blin.CanvasGroup.alpha = newAlpha
        end
    end

end --func end

--next--
function MainTargetInfoCtrl:OnLogout()

    self:StopTimer()
    self:HideTargetGo(nil)

end --func end

--next--
function MainTargetInfoCtrl:BindEvents()

    --dont override this function
    local l_mgr = MgrMgr:GetMgr("HeadSelectMgr")
    self:BindEvent(l_mgr.EventDispatcher, l_mgr.UPDATE_HEAD_TARGET, function(self, uid)
        if tostring(uid) == tostring(self.targetUid) then
            self:ShowPanel()
        end
    end)
    local l_buffMgr = MgrMgr:GetMgr("BuffMgr")
    ----buff 显示初始化
    self:BindEvent(l_buffMgr.EventDispatcher, l_buffMgr.BUFF_UPDATE_EVENT, function(self, roleId)
        if tostring(roleId) == tostring(self.targetUid) then
            self.panel.buffList.gameObject:SetActiveEx(true)
            self:ShowBuff()
        end
    end)

    local l_logoutMgr = MgrMgr:GetMgr("LogoutMgr")
    self:BindEvent(l_logoutMgr.EventDispatcher, l_logoutMgr.OnLogoutEvent, self.OnLogout)
end --func end
--next--
--lua functions end

--lua custom scripts
---类型枚举
local m_targetType = {
    Non = "0",
    Role = "1",
    Enemy = "2",
    Npc = "3",
    Collection = "4",
    MonsterWithSmallTargetTip = "5", --目标显示为小怪物Tips
    MonsterWithMidTargetTip = "6", --目标显示为中怪物Tips
    MonsterWithBigTargetTip = "7", --目标显示为大怪物Tips
    Mercenary = "8", --佣兵
}

--固定时间为1s
--local m_times = 30
--local m_minSpeed = 1500
--local m_maxSpeed = 2500
--local m_timer = nil

---初始化
function MainTargetInfoCtrl:OnInit()

end

---销毁
function MainTargetInfoCtrl:OnDestroy()

end

---隐藏所有面板
function MainTargetInfoCtrl:StopTimer()
    if m_timer then
        self:StopUITimer(m_timer)
        m_timer = nil
    end
end

function MainTargetInfoCtrl:HideTargetGo(nextGo)
    if MGameContext.IsOpenGM then
        self.panel.GMMonsterInfo:SetActiveEx(nil ~= nextGo)
        self:_setGmData()
    else
        self.panel.GMMonsterInfo:SetActiveEx(false)
    end

    if self.go then
        if self.go ~= nextGo then
            self.go:SetActiveEx(false)
            self.go = nextGo
            if self.go == nil then

                return
            end
            self.go:SetActiveEx(true)
        end
    else
        self.go = nextGo
        if self.go == nil then
            return
        end

        self.go:SetActiveEx(true)
    end
end

---显示target
function MainTargetInfoCtrl:RefreshTargetInfo(targetUid, targetName, targetLv, targetIsRole, targetIsEnemy, targetIsNpc, targetIsCollection, isMercenary)
    ---坑:之前写了个self.name,和基类冲突2333333
    ---添加佣兵特判继承monsterattr但是走npc显示策划陈阳战斗包海前端曾祥硕
    self.targetUid = targetUid
    self.tempTargetName = targetName
    self.targetName = targetName
    if self.targetName ~= nil then
        local cnt = StringEx.Length(self.targetName)
        --其他Entity名字大于4 则显示前三个字加.. 怪物大的Tips显示全称 会自己处理
        if cnt > 4 then
            self.targetName = StringEx.SubString(self.targetName, 0, 3) .. "..."
        end
    end
    self.targetLv = targetLv
    self.targetIsRole = targetIsRole
    self.targetIsEnemy = targetIsEnemy
    self.targetIsNpc = targetIsNpc
    self.targetIsCollection = targetIsCollection
    self.targetIsMonster = not targetIsRole
    self.targetIsMercenary = isMercenary
    self.targetTargetUID = nil
    self:ShowPanel()
end

function MainTargetInfoCtrl:ResetTargetInfo()
    self.targetUid = -1
    self.targetName = ""
    self.targetLv = 0
    self.targetIsRole = false
    self.targetIsEnemy = false
    self.targetIsNpc = false
    self.targetIsCollection = false
    self.targetIsMonster = false
    self.targetEntity = nil
    self.targetHPPercent = 0
    self.targetSPPercent = 0
    self.targetHPSlider = nil
    self.targetSPSlider = nil
    self.targetType = m_targetType.Non
    --self.targetTweenSlider = nil
    m_prevHP = -1
    m_needBlin = false

    if m_timer then
        self:StopUITimer(m_timer)
        m_timer = nil
    end
end

---显示面板
function MainTargetInfoCtrl:ShowPanel()
    if self.panel then
        self:StopTimer()
        if self.targetUid == nil or self.targetUid == 0 then
            self:HideTargetGo(nil)
            self:ResetTargetInfo()
            return
        end

        self.targetEntity = MEntityMgr:GetEntity(self.targetUid)
        if not self.targetEntity or not self.targetEntity.AttrComp or not MEntity.ValideEntityIncludeDead(self.targetEntity) then
            self:HideTargetGo(nil)
            self:ResetTargetInfo()
            return
        end

        if self.targetIsCollection then
            self.targetType = m_targetType.Collection
            self:ShowTarget(m_targetType.Collection)
            return
        end
        local l_hp = self.targetEntity and self.targetEntity.AttrComp.HPPercent or 0
        local l_sp = self.targetEntity and self.targetEntity.AttrComp.SPPercent or 0
        self.targetHPPercent = l_hp
        self.targetSPPercent = l_sp
        if self.targetIsMercenary then
            self.targetType = m_targetType.Mercenary
            self:ShowTarget(m_targetType.Mercenary)
            return
        end
        if self.targetIsNpc then
            self.targetType = m_targetType.Npc
            self:ShowTarget(m_targetType.Npc)
            return
        end
        if self.targetIsRole then
            if self.targetIsEnemy then
                self.targetType = m_targetType.Enemy
                self:ShowTarget(m_targetType.Enemy)
                return
            else
                self.targetType = m_targetType.Role
                self:ShowTarget(m_targetType.Role)
                return
            end
        else
            if self.targetEntity.AttrMonster then
                MgrMgr:GetMgr("BuffMgr").UpdateBuffInfo(self.targetUid)
                self.targetType = self:GetTypeByMonsterUnitTypeLevel(self.targetEntity.AttrMonster:GetMonsterUnitTypeLevel())
                self:ShowTarget(self.targetType)
                return
            end
        end
    end
end

--(0.普通怪，1.精英怪，2.Boss怪，3.召唤物,4.MINI,5,MVP）
--根据怪物的Type类型返回一个TargetType的类型 UnitTypeLevel == Entitytable的配置
function MainTargetInfoCtrl:GetTypeByMonsterUnitTypeLevel(monsterUnityTypeLevel)
    if monsterUnityTypeLevel == 0 or monsterUnityTypeLevel == 9 or monsterUnityTypeLevel == 10 then
        return m_targetType.MonsterWithSmallTargetTip
    elseif monsterUnityTypeLevel == 1 or monsterUnityTypeLevel == 2 or monsterUnityTypeLevel == 3 or monsterUnityTypeLevel == 4 or monsterUnityTypeLevel == 5 then
        return m_targetType.MonsterWithMidTargetTip
    else
        return m_targetType.MonsterWithBigTargetTip
    end
    return m_targetType.MonsterWithSmallTargetTip
end

function MainTargetInfoCtrl:_setGmData()
    if MGameContext.IsOpenGM and self.panel.GMMonsterInfo.gameObject.activeSelf and self.panel ~= nil and self.targetEntity ~= nil and self.panel.GMMonsterInfo ~= nil then
        if self.targetEntity.IsMonster then
            local str = self:GMGetMonsterAttriText()
            if nil ~= str then
                self.panel.GMMonsterInfo.LabText = " " .. str
            end
        elseif self.targetEntity.IsNpc then
            if self.targetEntity.AttrComp == nil then
                return
            end

            self.panel.GMMonsterInfo.LabText = "ID=" .. self.targetEntity.AttrComp.NpcID
        end
    end
end

---显示目标
function MainTargetInfoCtrl:ShowTarget(type)
    self:StopTimer()
    if type == m_targetType.Role then
        self:ShowRoleTarget()
        return
    end
    if type == m_targetType.MonsterWithSmallTargetTip then
        self:ShowSmallMonsterTarget()
        return
    end
    if type == m_targetType.MonsterWithMidTargetTip then
        self.targetName = self.tempTargetName
        self:ShowMidMonsterTarget()
        return
    end
    if type == m_targetType.MonsterWithBigTargetTip then
        self.targetName = self.tempTargetName
        return
    end
    if type == m_targetType.Enemy then
        self:ShowEnemyTarget()
        return
    end
    if type == m_targetType.Npc then
        self:ShowNpcTarget()
        return
    end
    if type == m_targetType.Collection then
        self:ShowCollectionTarget()
    end
    if type == m_targetType.Mercenary then
        self:ShowMercenaryTarget()
    end
end

function MainTargetInfoCtrl:_refreshMainTargetIcon(headTemplate, pro, lv, onClick, onClickEvent)
    if nil == headTemplate then
        return
    end

    ---@type HeadTemplateParam
    local param = {
        Entity = self.targetEntity,
        ShowFrame = true,
        ShowBg = false,
        OnClick = onClick,
        OnClickEvent = onClickEvent,
        OnClickSelf = self,
    }

    if nil ~= pro then
        param.ShowProfession = true
        param.Profession = pro
    end

    if nil ~= lv then
        param.ShowLv = true
        param.Level = lv
    end

    headTemplate:SetData(param)
end

--- 初始化头像
function MainTargetInfoCtrl:_createHeadTemplate(parent)
    local ret = self:NewTemplate("HeadWrapTemplate", {
        TemplateParent = parent,
        TemplatePath = "UI/Prefabs/HeadWrapTemplate"
    })

    return ret
end

---显示角色
function MainTargetInfoCtrl:ShowRoleTarget()
    self:HideTargetGo(self.panel.RoleTarget.gameObject)
    self.panel.RoleInfoCloseBtn:AddClickWithLuaSelf(self.CloseBtnClick, self)
    local profession = self.targetEntity and self.targetEntity.AttrComp.ProfessionID or 1000
    if not self.headRole then
        self.headRole = self:_createHeadTemplate(self.panel.RoleHeadIcon.transform)
    end

    local entity = MEntityMgr:GetEntity(self.targetUid, true)
    self.panel.RoleNameLab.LabText = tostring(self.targetName)
    local onClick = function()
        if self.targetUid ~= 0 and self.targetIsRole then
            local l_uid = self.targetUid
            --获取镜像的本体的uuid
            if entity ~= nil and entity.IsMirrorRole then
                l_uid = entity.MirrorOwnerUID
            end
            MgrMgr:GetMgr("TeamMgr").OnSelectPlayer(l_uid)
        end
    end

    self:_refreshMainTargetIcon(self.headRole, profession, self.targetLv, onClick)
    self.targetHPSlider = self.panel.RoleSlider.gameObject:GetComponent("Slider")
    self.targetHPSlider.enabled = true
    self.targetHPSlider.value = self.targetHPPercent

    --默认不显示点赞按钮
    self.panel.BtnLake.gameObject:SetActiveEx(MgrMgr:GetMgr("ThemePartyMgr").IsShowLakeBtn() and
            self.targetUid ~= 0 and
            self.targetIsRole and
            (entity ~= nil and entity.MirrorOwnerUID ~= MPlayerInfo.UID))

    --点赞按钮
    self.panel.BtnLake:AddClick(function()
        if self.targetUid ~= 0 and self.targetIsRole then
            if entity ~= nil and entity.IsMirrorRole then
                MgrMgr:GetMgr("ThemePartyMgr").ThemePartySendLove(entity.MirrorOwnerUID)
            else
                MgrMgr:GetMgr("ThemePartyMgr").ThemePartySendLove(self.targetUid)
            end
        end
    end)
end

---显示小怪
function MainTargetInfoCtrl:ShowSmallMonsterTarget()
    self:HideTargetGo(self.panel.MonsterTarget.gameObject)
    self.panel.MonsterCloseBtn:AddClick(function()
        self:CloseBtnClick()
    end)

    if not self.headMonster then
        self.headMonster = self:_createHeadTemplate(self.panel.MonsterHeadInfo.transform)
    end

    self:_refreshMainTargetIcon(self.headMonster, nil, nil, nil, self.OnPressDown)
    self.panel.MonsterNameLab.LabText = tostring(self.targetName)
    self.panel.MonsterLvLab.LabText = tostring(self.targetLv)
    self.targetHPSlider = self.panel.MonsterSlider.gameObject:GetComponent("Slider")
    self.targetHPSlider.enabled = true
    self.targetHPSlider.value = self.targetHPPercent
    if self.targetEntity == nil or self.targetEntity.AttrComp == nil then
        return
    end

    local l_id = self.targetEntity.AttrComp.EntityID
    local l_tableData = TableUtil.GetEntityTable().GetRowById(l_id)
    local l_isEnemy = tonumber(l_tableData.DefaultGroup) ~= 10000
    if not l_isEnemy then
        self.panel.Fill:SetSprite("Common", "UI_common_BoardBase_HP2.png")
        self.panel.MonsterTarget:SetSprite("Common", "UI_common_BoardBase_03.png")
        self.panel.HeadBG:SetSprite("Common", "UI_common_BoardBase_04.png")
        self.panel.LevelImage:SetSprite("Common", "UI_Common_LevelBG02.png")
        self.panel.MonsterLvLab:SetOutLineColor(Color.New(59 / 255, 75 / 255, 231 / 255, 1))
        self.panel.MonsterNameLab:SetOutLineColor(Color.New(59 / 255, 75 / 255, 231 / 255, 1))
    else
        self.panel.Fill:SetSprite("Common", "UI_common_BoardBase_HP.png")
        self.panel.MonsterTarget:SetSprite("Common", "UI_common_BoardBase_03-2.png")
        self.panel.HeadBG:SetSprite("Common", "UI_common_BoardBase_04-2.png")
        self.panel.MonsterNameLab:SetOutLineColor(Color.New(165 / 255, 30 / 255, 30 / 255, 1))
        if l_tableData.IsInitiative == 1 then
            --主动
            self.panel.MonsterLvLab:SetOutLineColor(Color.New(170 / 255.0, 58 / 255.0, 71 / 255.0, 1))
            self.panel.LevelImage:SetSprite("Common", "UI_Common_Shuzijiaobiao2.png")
        else
            self.panel.MonsterLvLab:SetOutLineColor(Color.New(65 / 255.0, 110 / 255.0, 194 / 255.0, 1))
            self.panel.LevelImage:SetSprite("Common", "UI_Common_Shuzijiaobiao.png")
        end
    end
end

function MainTargetInfoCtrl:GMGetMonsterAttriText()
    if self.targetEntity == nil or self.targetEntity.AttrComp == nil then
        return
    end

    local l_id = self.targetEntity.AttrComp.EntityID
    local l_e = TableUtil.GetEntityTable().GetRowById(l_id)
    if l_e == nil then
        return
    end

    local l_maxhp = tostring(self.targetEntity.AttrComp.MaxHP)
    local l_hp = tostring(self.targetEntity.AttrComp.HP)
    --属性名
    local l_attr = TableUtil.GetElementAttr().GetRowByAttrId(l_e.UnitAttrType)
    local l_attrText = ""
    local l_raceText = ""
    if l_attr then
        l_attrText = l_attr.ColourTextDefence
    end

    --种族
    local l_race_enum = TableUtil.GetRaceEnum().GetRowById(l_e.UnitRace)
    if l_race_enum then
        l_raceText = l_race_enum.Text
    end

    local l_sizeText = Common.Utils.Lang("UnitSize_" .. tostring(l_e.UnitSize))
    local ret = l_e.Name .. ":" .. l_id .. " -> " .. l_hp .. "/" .. l_maxhp .. "\n" .. l_attrText .. " * " .. l_raceText .. " * " .. l_sizeText
    return ret
end

---显示中等目标的UI框
function MainTargetInfoCtrl:ShowMidMonsterTarget()
    self:HideTargetGo(self.panel.BossTarget.gameObject)
    self.panel.BossCloseBtn:AddClick(function()
        self:CloseBtnClick()
    end)

    local unitTypeLevel = self.targetEntity.AttrMonster:GetMonsterUnitTypeLevel()

    --显示MvpFlag
    local l_mvp = (unitTypeLevel == ROGameLibs.UnitTypeLevel.kUnitTypeLevel_MVP:ToInt())
    self.panel.mvpFlag.gameObject:SetActiveEx(l_mvp)
    local l_mini = (unitTypeLevel == ROGameLibs.UnitTypeLevel.kUnitTypeLevel_Mini:ToInt())
    self.panel.miniFlag.gameObject:SetActiveEx(l_mini)
    if not self.headBoss then
        self.headBoss = self:_createHeadTemplate(self.panel.BossHeadIcon.transform)
    end

    self:_refreshMainTargetIcon(self.headBoss, nil, nil, nil, self.OnPressDown)
    if l_mvp then
        self.panel.BossNameLab.LabText = tostring(self.targetName)
        self.panel.BossNameLab.gameObject:SetActiveEx(true)
        self.panel.BossNameLab2.gameObject:SetActiveEx(false)
    else
        self.panel.BossNameLab2.LabText = tostring(self.targetName)
        self.panel.BossNameLab2.gameObject:SetActiveEx(true)
        self.panel.BossNameLab.gameObject:SetActiveEx(false)
    end

    self.panel.BossLvLab.LabText = tostring(self.targetLv)
    self.targetSPSlider = self.panel.BossSpSlider.gameObject:GetComponent("Slider")
    self.targetSPSlider.enabled = true
    self.targetSPSlider.value = 1---self.targetSPPercent
    self.targetHPSlider = self.panel.BossHpSlider.gameObject:GetComponent("Slider")
    self.targetHPSlider.enabled = true
    local l_hp = self.targetEntity and self.targetEntity.AttrComp.HP or 0
    local l_maxHp = self.targetEntity and self.targetEntity.AttrComp.MaxHP or 1

    local l_id = self.targetEntity.AttrComp.EntityID
    local l_tableData = TableUtil.GetEntityTable().GetRowById(l_id)
    local l_isEnemy = tonumber(l_tableData.DefaultGroup) ~= 10000
    if not l_isEnemy then
        self.panel.BossLine:SetSprite("Common", "UI_common_BoardBase_03-2.png")
        self.panel.BossLine.Img.color = Color.New(1, 1, 1, 1)
        self.panel.BossBG:SetSprite("Common", "UI_common_BoardBase_04.png")
        self.panel.TargetIconBG.gameObject:SetActiveEx(false)
        self.panel.BossLvlImage.gameObject:SetActiveEx(true)
        self.panel.BossLvlImage:SetSprite("Common", "UI_Common_LevelBG02.png")
        self.panel.BossLvLab:SetOutLineColor(Color.New(59 / 255, 75 / 255, 231 / 255, 1))
        self.panel.BossNameLab:SetOutLineColor(Color.New(59 / 255, 75 / 255, 231 / 255, 1))
    else
        --self.panel.Fill:SetSprite("main", "UI_main_infor_guaiwuhp.png")
        self.panel.BossLine:SetSprite("Common", "UI_common_BoardBase_bg.png")
        self.panel.BossLine.Img.color = Color.New(1, 1, 1, 100 / 255)
        self.panel.BossBG:SetSprite("Common", "UI_common_BoardBase_04-4bg.png")
        self.panel.TargetIconBG.gameObject:SetActiveEx(true)
        self.panel.BossLvlImage.gameObject:SetActiveEx(false)
        self.panel.BossLvLab:SetOutLineColor(Color.New(165 / 255, 30 / 255, 30 / 255, 1))
        self.panel.BossNameLab:SetOutLineColor(Color.New(46 / 255, 32 / 255, 32 / 255, 1))
    end

    if NEED_TARGET_NAME_BOSS_TYPE[unitTypeLevel] then
        -- 客户端缓存的boss目标。每次boss更换目标或进出视野会通知客户端，选择boss时会到缓存里寻找
        self.targetTargetUID = MgrMgr:GetMgr("PlayerInfoMgr").g_bossAndTargetCache[tostring(self.targetEntity.UID)] or "0"      -- 没有目标传"0"
        self:SetTargetTargetInfo(self.targetTargetUID)
    else
        self.panel.BossTargetName.gameObject:SetActiveEx(false)
    end
    self.panel.Blin.CanvasGroup.alpha = 0
    self:UpdateBossBloodBar(l_hp, l_maxHp)
end

function MainTargetInfoCtrl:SetTargetTargetInfo(targetUID)
    local targetEntity = self:GetFinalTargetEntity(targetUID)
    if (nil ~= targetEntity) and (not targetEntity:Equals(nil)) then
        self.panel.BossTargetName.LabText = targetEntity.Name
        --策划要求去掉职业图标的显示
        --local imageName = nil
        --if targetEntity.AttrRole then
        --    imageName = DataMgr:GetData("TeamData").GetProfessionImageById(targetEntity.AttrRole.ProfessionID)
        --end
        --if imageName then
        --    self.panel.BossTargetPro:SetSpriteAsync("Common", imageName)
        --    self.panel.BossTargetPro.gameObject:SetActiveEx(true)
        --else
        --    self.panel.BossTargetPro.gameObject:SetActiveEx(false)
        --end

        self.panel.BossTargetName.gameObject:SetActiveEx(true)
    else
        self.panel.BossTargetName.gameObject:SetActiveEx(false)
    end
end

-- 如果是佣兵，返回拥有者
function MainTargetInfoCtrl:GetFinalTargetEntity(targetUID)
    local targetEntity = MEntityMgr:GetEntity(targetUID)
    if targetEntity ~= nil and not targetEntity:Equals(nil) then
        if targetEntity.IsMercenary and targetEntity.AttrMonster then
            local ownerEntity = MEntityMgr:GetEntity(targetEntity.AttrMonster.OwnerUID)
            if ownerEntity then
                return ownerEntity
            else
                return targetEntity
            end
        else
            return targetEntity
        end
    end
    return nil
end

function MainTargetInfoCtrl:OnBtnTargetTarget()
    if not self.targetTargetUID or self.targetTargetUID == "0" then
        return
    end
    local tempTargetEntity = self:GetFinalTargetEntity(self.targetTargetUID)
    MSkillTargetMgr.singleton:FindTargetById(tempTargetEntity.UID)
end

---显示npc
function MainTargetInfoCtrl:ShowNpcTarget()
    if self.targetEntity == nil and self.targetEntity.AttrComp == nil then
        return
    end

    if not self.targetEntity.IsNpc then
        return
    end
    local l_attr = self.targetEntity.AttrComp

    if not l_attr.IsNormalType then
        return
    end
    self:HideTargetGo(self.panel.NpcTarget.gameObject)
    self.panel.NpcCloseBtn:AddClickWithLuaSelf(self.CloseBtnClick, self)

    if not self.headNpc then
        self.headNpc = self:_createHeadTemplate(self.panel.NpcHeadInfo.transform)
    end

    self:_refreshMainTargetIcon(self.headNpc)
    self.panel.NpcNameLab.LabText = tostring(self.targetEntity and self.targetEntity.AttrComp.Name or "")
end

---显示佣兵
function MainTargetInfoCtrl:ShowMercenaryTarget()
    if self.targetEntity == nil and self.targetEntity.AttrComp == nil then
        return
    end

    local l_attr = self.targetEntity.AttrComp
    self:HideTargetGo(self.panel.RoleTarget.gameObject)
    self.panel.RoleInfoCloseBtn:AddClickWithLuaSelf(self.CloseBtnClick, self)
    --佣兵和人物走一个头像
    if not self.headRole then
        self.headRole = self:_createHeadTemplate(self.panel.RoleHeadIcon.transform)
    end

    self:_refreshMainTargetIcon(self.headRole, l_attr.Profession, self.targetLv)
    local l_strs = string.ro_split(self.targetName, "=")
    self.panel.RoleNameLab.LabText = l_strs[1]
    self.targetHPSlider = self.panel.RoleSlider.gameObject:GetComponent("Slider")
    self.targetHPSlider.enabled = true
    self.targetHPSlider.value = self.targetHPPercent
    self.panel.BtnLake.gameObject:SetActiveEx(false)
end

--显示采集物
function MainTargetInfoCtrl:ShowCollectionTarget()
    self:HideTargetGo(self.panel.NpcTarget.gameObject)

    self.panel.NpcCloseBtn:AddClickWithLuaSelf(self.CloseBtnClick, self)

    --采集物和NPC走一个头像
    if not self.headNpc then
        self.headNpc = self:_createHeadTemplate(self.panel.NpcHeadInfo.transform)
    end

    self:_refreshMainTargetIcon(self.headNpc)
    self.panel.NpcNameLab.LabText = tostring(self.targetEntity and self.targetEntity.AttrComp.Name or "")
end

---显示敌人
function MainTargetInfoCtrl:ShowEnemyTarget()
    self:HideTargetGo(self.panel.EnemyTarget.gameObject)
    self.panel.EnemyCloseBtn:AddClickWithLuaSelf(self.CloseBtnClick, self)

    if not self.headEnemy then
        self.headEnemy = self:_createHeadTemplate(self.panel.EnemyHeadIcon.transform)
    end

    self:_refreshMainTargetIcon(self.headEnemy)
    self.panel.EnemyNameLab.LabText = tostring(self.targetName)
    self.targetSPSlider = self.panel.EnemySpSlider.gameObject:GetComponent("Slider")
    self.targetSPSlider.enabled = true
    self.targetSPSlider.value = self.targetSPPercent
    self.targetHPSlider = self.panel.EnemyHpSlider.gameObject:GetComponent("Slider")
    self.targetHPSlider.enabled = true
    self.targetHPSlider.value = self.targetHPPercent
end

function MainTargetInfoCtrl:RefreshTargetHP(uid, hp, maxhP)
    if self.panel then
        if (tostring(self.targetUid) ~= tostring(uid)) or self.targetHPSlider == nil or self.targetType == m_targetType.Non then
            return
        end
        local l_Percent = 0
        if maxhP > 0 then
            l_Percent = hp / maxhP
        end
        if self.targetType == m_targetType.MonsterWithMidTargetTip or self.targetType == m_targetType.MonsterWithBigTargetTip then
            if maxhP == 0 then
                return
            end
            self:UpdateBossBloodBar(hp, maxhP)
        else
            self.targetHPSlider.value = l_Percent
        end

    end
end

function MainTargetInfoCtrl:RefreshTargetSP(uid, sp, maxSP)
    --boss have sp bar
    if self.panel then
        if (tostring(self.targetUid) ~= tostring(uid)) or self.targetSPSlider == nil or self.targetType ~= m_targetType.Boss then
            return
        end
        local l_Percent = 0
        if maxSP > 0 then
            l_Percent = sp / maxSP
        end
        self.targetSPSlider.value = l_Percent
    end
end

function MainTargetInfoCtrl:RefreshTargetTargetName(uid, targetUID)
    if self.panel then
        if tostring(self.targetTargetUID) == tostring(targetUID) or tostring(self.targetUid) ~= tostring(uid)
                or not self.targetEntity.AttrMonster or not NEED_TARGET_NAME_BOSS_TYPE[self.targetEntity.AttrMonster:GetMonsterUnitTypeLevel()] then
            return
        end
        self.targetTargetUID = targetUID
        self:SetTargetTargetInfo(self.targetTargetUID)
    end
end

function MainTargetInfoCtrl:UpdateBossBloodBar(hp, maxhP)
    if maxhP <= 0 then
        logError("MainTargetInfo:UpdateBossBloodBar 传进来的 maxhp == 0")
        return
    end

    local value = hp / maxhP
    local percent = math.ceil(value * 100)
    self.panel.CombNumLab.LabText = StringEx.Format("{0}%", percent)
    self.targetHPSlider.value = value
    self.panel.Blin.transform.localPosition = Vector3.New((value - 0.5) * 110, 0, 0)

    if m_prevHP > 0 and hp ~= m_prevHP and hp > 0 then
        m_needBlin = true
        self.panel.Blin.CanvasGroup.alpha = blinOriAlpha
    end
    m_prevHP = hp
end

function MainTargetInfoCtrl:OnPressDown(data, eventData)

    if not self.targetEntity or not self.targetEntity.AttrComp then
        return
    end

    local clickWorldPos = MUIManager.UICamera:ScreenToWorldPoint(Vector3(eventData.position.x, eventData.position.y, 0))
    local l_openData = {
        openType = DataMgr:GetData("TipsData").MonsterInfoTipsOpenType.ShowEntityTips,
        entity = self.targetEntity,
        entityId = self.targetEntity.AttrComp.EntityID,
        pos = clickWorldPos,
        isMask = true,
    }

    UIMgr:ActiveUI(CtrlNames.MonsterInfoTips, l_openData)
end

----====================buff============================================================================================
local l_buffMgr = MgrMgr:GetMgr("BuffMgr")
local l_buffAddNum = 6
local l_buffReduce = 12

local l_buffAddItem = {}  ----7个增益buff
local l_buffIdAffixTbItem = {} ----词缀Buff
local l_buffReduceItem = {}  ----14个减益buff

local l_refreshItem = {}   ----需要刷新计时的buff item

local l_itemTimer = nil

local l_curBuff = {}

function MainTargetInfoCtrl:OnBuffInit()
    l_buffAddItem = {}
    l_buffIdAffixTbItem = {}
    l_buffReduceItem = {}
    self:ClearEffect()

    self.panel.buffList:AddClick(function()
        l_buffMgr.EventDispatcher:Dispatch(l_buffMgr.TARGET_BUFF_TIPS_OPEN)
        l_buffMgr.UpdateBuffInfo(self.targetUid)
    end)

    self.panel.buffList.gameObject:SetActiveEx(false)
    if self.targetIsMonster then
        l_buffMgr.UpdateBuffInfo(self.targetUid)
    end
end

function MainTargetInfoCtrl:OnBuffUnInit()
    l_buffAddItem = {}
    l_buffIdAffixTbItem = {}
    l_buffReduceItem = {}

    self:ClearEffect()

    if l_itemTimer ~= nil then
        self:StopUITimer(l_itemTimer)
        l_itemTimer = nil
    end
    l_curBuff = {}
end

function MainTargetInfoCtrl:ShowBuff()
    -----接口:打开buff显示
    self:InitItemView()
    if l_itemTimer ~= nil then
        self:StopUITimer(l_itemTimer)
        l_itemTimer = nil
    end
    if table.ro_size(l_refreshItem) > 0 then
        l_itemTimer = self:NewUITimer(function()
            for k, v in pairs(l_refreshItem) do
                v.remainTime = v.remainTime - 0.2
                if v.remainTime < 0 then
                    v.remainTime = 0
                end
                if not v.endfx and v.remainTime < 1 then
                    v.endfx = true
                    if v.fx ~= nil then
                        self:DestroyUIEffect(v.fx)
                        v.fx = nil
                    end
                    local l_fxData = {}
                    l_fxData.rawImage = v.effectImg.RawImg
                    v.fx = self:CreateUIEffect(v.effect, l_fxData)

                end
                v.item.fillImg.fillAmount = 1 - v.remainTime / v.l_timeLimit
            end
        end, 0.2, -1, true)
        l_itemTimer:Start()
    end
end

function MainTargetInfoCtrl:DestroyItem(list)
    ----回收
    if #list == 0 then
        return
    end
    for i = 1, #list do
        MResLoader:DestroyObj(list[i].ui)
    end
end

function MainTargetInfoCtrl:ExportItem(obj, item)
    item.ui = obj
    item.icon = item.ui.transform:Find("icon"):GetComponent("MLuaUICom")
    item.fillImg = item.ui.transform:Find("Image"):GetComponent("Image")
    item.timeLab = MLuaClientHelper.GetOrCreateMLuaUICom(item.ui.transform:Find("timeLab"))
    item.effectImg = item.ui.transform:Find("Effect"):GetComponent("MLuaUICom")
end

function MainTargetInfoCtrl:InitItem(item, info, effect, diseffect)
    item.ui:SetActiveEx(true)
    local l_state = false
    for k, v in pairs(l_curBuff) do
        l_state = (v == info.tableInfo.Id)
        if l_state then
            break
        end
    end
    local l_fx = nil
    if not l_state then
        local l_anim = item.ui:GetComponent("DOTweenAnimation")
        l_anim:DORestart()
        l_anim:DOPlayForward()

        local l_fxData = {}
        l_fxData.rawImage = item.effectImg.RawImg
        l_fx = self:CreateUIEffect(effect, l_fxData)

    end
    item.icon:SetSpriteAsync(info.tableInfo.IconAtlas, info.tableInfo.Icon)
    local l_timeInfo = Common.Functions.VectorSequenceToTable(info.tableInfo.DestroyTiming)
    local l_timeLimit = -1
    for i, v in ipairs(l_timeInfo) do
        if v[1] == 1 then
            l_timeLimit = v[2]
        end
    end
    if l_timeLimit > 0 then
        item.fillImg.fillAmount = 1 - info.remainTime / l_timeLimit
        local l_index = #l_refreshItem + 1
        l_refreshItem[l_index] = {}
        l_refreshItem[l_index].item = item
        l_refreshItem[l_index].remainTime = info.remainTime
        l_refreshItem[l_index].l_timeLimit = l_timeLimit
        l_refreshItem[l_index].fx = l_fx
        l_refreshItem[l_index].effectImg = item.effectImg
        l_refreshItem[l_index].effect = diseffect
    else
        item.fillImg.fillAmount = 0
    end
    item.timeLab.gameObject:SetActiveEx(info.appendCount > 1)
    item.timeLab.LabText = info.appendCount
end

function MainTargetInfoCtrl:ClearEffect()
    if table.ro_size(l_refreshItem) > 0 then
        for k, v in pairs(l_refreshItem) do
            if v.fx ~= nil then
                self:DestroyUIEffect(v.fx)
                v.fx = nil
            end
        end
    end
    l_refreshItem = {}
end

function MainTargetInfoCtrl:InitItemView()
    ----初始化item面板
    self:ClearEffect()
    for i = 1, #l_buffAddItem do
        l_buffAddItem[i].ui:SetActiveEx(false)
        l_buffAddItem[i].ui.transform:SetParent(self.panel.PanelRef.gameObject.transform)
    end
    for i = 1, #l_buffIdAffixTbItem do
        l_buffIdAffixTbItem[i].ui:SetActiveEx(false)
        l_buffIdAffixTbItem[i].ui.transform:SetParent(self.panel.PanelRef.gameObject.transform)
    end
    for i = 1, #l_buffReduceItem do
        l_buffReduceItem[i].ui:SetActiveEx(false)
        l_buffReduceItem[i].ui.transform:SetParent(self.panel.PanelRef.gameObject.transform)
    end
    local l_addInfo = l_buffMgr.g_targetAddBuffInfo
    local l_reduce = l_buffMgr.g_targetReduceBuffInfo
    local l_affixBuffTb = l_buffMgr.g_tragetAffixBuffIdTb
    local l_curCount = 0
    local l_nowBuff = {}
    --如果有词条Buff 优先初始化词条Buff
    if #l_affixBuffTb > 0 then
        for i = 1, #l_affixBuffTb do
            if l_curCount < l_buffAddNum then
                l_curCount = l_curCount + 1
                if l_buffIdAffixTbItem[i] == nil then
                    self:CreateAddAffixItem(i)
                end
                self:InitItem(l_buffIdAffixTbItem[i], l_affixBuffTb[i], l_buffMgr.AddStatrEffect, l_buffMgr.AddEndEffect)
                l_buffIdAffixTbItem[i].ui.transform:SetParent(self.panel.buffList.gameObject.transform)
                l_buffIdAffixTbItem[i].ui.transform.localScale = self.panel.addBuff.gameObject.transform.localScale
                local l_index = #l_nowBuff
                l_nowBuff[l_index + 1] = l_affixBuffTb[i].tableInfo.Id
            end
        end
    end
    --初始化增益Buff
    if #l_addInfo > 0 then
        for i = 1, #l_addInfo do
            if l_curCount < l_buffAddNum then
                l_curCount = l_curCount + 1
                if l_buffAddItem[i] == nil then
                    self:CreateAddItem(i)
                end
                self:InitItem(l_buffAddItem[i], l_addInfo[i], l_buffMgr.AddStatrEffect, l_buffMgr.AddEndEffect)
                l_buffAddItem[i].ui.transform:SetParent(self.panel.buffList.gameObject.transform)
                l_buffAddItem[i].ui.transform.localScale = self.panel.addBuff.gameObject.transform.localScale
                local l_index = #l_nowBuff
                l_nowBuff[l_index + 1] = l_addInfo[i].tableInfo.Id
            end
        end
    end
    --初始化减益Buff
    if #l_reduce > 0 then
        for i = 1, #l_reduce do
            if l_curCount < l_buffReduce then
                l_curCount = l_curCount + 1
                if l_buffReduceItem[i] == nil then
                    self:CreateReduceItem(i)
                end
                self:InitItem(l_buffReduceItem[i], l_reduce[i], l_buffMgr.AddStatrEffect, l_buffMgr.AddEndEffect)
                l_buffReduceItem[i].ui.transform:SetParent(self.panel.buffList.gameObject.transform)
                l_buffReduceItem[i].ui.transform.transform.localScale = self.panel.reduceBuff.gameObject.transform.localScale
                local l_index = #l_nowBuff
                l_nowBuff[l_index + 1] = l_reduce[i].tableInfo.Id
            end
        end
    end
    l_curBuff = l_nowBuff
end

function MainTargetInfoCtrl:CreateAddItem(i)
    l_buffAddItem[i] = {}
    local l_item = self:CloneObj(self.panel.addBuff.gameObject)
    local l_trans = l_item.transform
    --l_item.transform:SetParent(self.panel.buffList.gameObject.transform)
    l_trans:SetParent(self.panel.PanelRef.gameObject.transform)
    l_trans.localScale = self.panel.addBuff.gameObject.transform.localScale
    l_item:SetActiveEx(false)
    self:ExportItem(l_item, l_buffAddItem[i])
end

function MainTargetInfoCtrl:CreateAddAffixItem(i)
    l_buffIdAffixTbItem[i] = {}
    local l_item = self:CloneObj(self.panel.addBuff.gameObject)
    local l_trans = l_item.transform
    --l_item.transform:SetParent(self.panel.buffList.gameObject.transform)
    l_trans:SetParent(self.panel.PanelRef.gameObject.transform)
    l_trans.localScale = self.panel.addBuff.gameObject.transform.localScale
    l_item:SetActiveEx(false)
    self:ExportItem(l_item, l_buffIdAffixTbItem[i])
end

function MainTargetInfoCtrl:CreateReduceItem(i)
    l_buffReduceItem[i] = {}
    local l_item = self:CloneObj(self.panel.reduceBuff.gameObject)
    local l_trans = l_item.transform
    --l_item.transform:SetParent(self.panel.buffList.gameObject.transform)
    l_trans:SetParent(self.panel.PanelRef.gameObject.transform)
    l_trans.localScale = self.panel.reduceBuff.gameObject.transform.localScale
    l_item:SetActiveEx(false)
    self:ExportItem(l_item, l_buffReduceItem[i])
end

function MainTargetInfoCtrl:CloseBtnClick()
    self:StopTimer()
    self:HideTargetGo(nil)
    if MEntityMgr.PlayerEntity ~= nil then
        MEntityMgr.PlayerEntity.Target = nil
    end
end

--- 使用GM对NPC进行无情的杀害
function MainTargetInfoCtrl:_killWithGM()
    MgrMgr:GetMgr("GmMgr").SendCommand("killmonster " .. tostring(self.targetEntity.UID))
end

--lua custom scripts end
return MainTargetInfoCtrl