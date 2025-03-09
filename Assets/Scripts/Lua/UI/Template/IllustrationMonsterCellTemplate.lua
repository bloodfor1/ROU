--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/BaseUITemplate"
require "UI/Template/MonsterInfoPartTemplate"
--lua requires end

--lua model
module("UITemplate", package.seeall)

--lua model end

--lua fields
local super = UITemplate.BaseUITemplate
--lua fields end

--lua class define
---@class IllustrationMonsterCellTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field TypeIcon MoonClient.MLuaUICom
---@field SelectPanel MoonClient.MLuaUICom
---@field RedSign MoonClient.MLuaUICom
---@field RawImg MoonClient.MLuaUICom
---@field MonsterInfo MoonClient.MLuaUICom
---@field MonsterImage MoonClient.MLuaUICom
---@field MonsterButton MoonClient.MLuaUICom
---@field LevelBg MoonClient.MLuaUICom
---@field heidi MoonClient.MLuaUICom

---@class IllustrationMonsterCellTemplate : BaseUITemplate
---@field Parameter IllustrationMonsterCellTemplateParameter

IllustrationMonsterCellTemplate = class("IllustrationMonsterCellTemplate", super)
--lua class define end

--lua functions
function IllustrationMonsterCellTemplate:Init()

    super.Init(self)
    self.infoPart = nil
    self.isRewardPanel = false
    self.EffectId = nil
    self.monsterID = 0
end --func end
--next--
function IllustrationMonsterCellTemplate:OnDestroy()

    self.infoPart = nil
    self.EffectId = nil
    self.isRewardPanel = false
    self:DestroyEffect()
    self.monsterID = 0

end --func end
--next--
function IllustrationMonsterCellTemplate:OnSetData(data)

    self:ShowMonsterCellInfo(data)

end --func end
--next--
function IllustrationMonsterCellTemplate:BindEvents()

    self:BindEvent(MgrMgr:GetMgr("IllustrationMonsterMgr").EventDispatcher, DataMgr:GetData("IllustrationMonsterData").ILLUSTRATION_MONSTER_REWARD, self.RefreshRedSign)

end --func end
--next--
function IllustrationMonsterCellTemplate:OnDeActive()

    -- do nothing

end --func end
--next--
--lua functions end

--lua custom scripts
local IllustrationMonsterMgr = MgrMgr:GetMgr("IllustrationMonsterMgr")
local IllustrationMonsterData = DataMgr:GetData("IllustrationMonsterData")
function IllustrationMonsterCellTemplate:ShowMonsterCellInfo(monsterData)
    self.monsterID = monsterData.Id or 0
    self:DestroyEffect()
    monsterData.showIndex = self.ShowIndex
    if monsterData.needNil then
        self.Parameter.MonsterInfo:SetActiveEx(false)
        self.Parameter.LevelBg:SetActiveEx(false)
        return
    end

    if monsterData.isRewardPanel then
        self.isRewardPanel = true
        local show = MgrMgr:GetMgr("IllustrationMonsterMgr").CheckSingle(self.monsterID)
        self.Parameter.RedSign:SetActiveEx(show)
    else
        self.Parameter.RedSign:SetActiveEx(false)
    end

    self.Parameter.MonsterInfo:SetActiveEx(true)
    self.Parameter.LevelBg:SetActiveEx(true)
    --魔物图片
    local monsterPresentData = TableUtil.GetPresentTable().GetRowById(monsterData.PresentID)
    if monsterPresentData then
        self.Parameter.MonsterImage:SetSprite(monsterPresentData.Atlas, monsterPresentData.Icon)
    else
        logError("魔物图鉴 没有这个模型ID=>" .. monsterData.PresentID)
    end
    --类型图片
    if self.infoPart then
        self:UninitTemplate(self.infoPart)
        self.infoPart = nil
    end
    if self:IsNeedInfoPart(monsterData) then
        self.infoPart = self:NewTemplate("MonsterInfoPartTemplate", {
            TemplateParent = self:transform(),
        })
    end
    self.Parameter.TypeIcon:SetActiveEx(true)
    if monsterData.UnitTypeLevel == 4 then
        --MINI
        self.Parameter.TypeIcon:SetSprite("Common", "UI_Common_Identification_MiniBoss.png")
    elseif monsterData.UnitTypeLevel == 5 then
        --MVP
        self.Parameter.TypeIcon:SetSprite("Common", "UI_Common_Identification_Mvp.png")
    else
        --NORMAL
        self.Parameter.TypeIcon:SetActiveEx(false)
    end
    --解锁状态
    self:SetMonsterCellUnlockState(monsterData.Id, monsterData.isRewardPanel)
    --点击状态
    local clickState = (monsterData.tableIndex == IllustrationMonsterData.GetMonsterListTemplateIndex()) and (self.ShowIndex == IllustrationMonsterData.GetMonsterCellTemplateIndex()) and not self.isRewardPanel
    self:SetMonsterSelectState(clickState)

    --点击事件
    self.Parameter.MonsterButton:AddClick(function()
        --改变选中状态
        monsterData.showIndex = self.ShowIndex
        IllustrationMonsterMgr.EventDispatcher:Dispatch(IllustrationMonsterData.ILLUSTRATION_SELECT_MONSTER, monsterData)
        self:SetMonsterSelectState(true)
        --记录位置
        if not self.isRewardPanel then

            IllustrationMonsterData.SetMonsterListTemplateIndex(monsterData.tableIndex)
            IllustrationMonsterData.SetMonsterCellTemplateIndex(self.ShowIndex)
        end
        --解锁
        if IllustrationMonsterData.GetMonsterStateById(monsterData.Id) == IllustrationMonsterData.ILLUSTRATION_STATE.First then
            IllustrationMonsterMgr.RequestUnLockRoleIllustration(1, monsterData.Id)
        end
    end)
    --魔物等级框显示
    --local lvl = IllustrationMgr.GetMonsterRewardLevelById(monsterData.Id) + 1
    --self.Parameter.LevelBg:SetSprite("Monster", "UI_Monster_IconDI_0" .. lvl .. ".png", true)
end

function IllustrationMonsterCellTemplate:SetMonsterSelectState(isSelect)
    self.Parameter.SelectPanel.gameObject:SetActiveEx(isSelect)
end

--处理魔物解锁状态
function IllustrationMonsterCellTemplate:SetMonsterCellUnlockState(monsterId, isAwardPanel)
    --图片
    local state = IllustrationMonsterData.GetMonsterStateById(monsterId)
    local lvl = IllustrationMonsterData.GetMonsterRewardLevelById(monsterId)
    if state == IllustrationMonsterData.ILLUSTRATION_STATE.First then
        --待解锁
        local l_color = Color.New(0, 0, 0, 0.5) -- 正常
        self.Parameter.MonsterImage.Img.color = l_color
        self.Parameter.TypeIcon.Img.color = l_color
        self.Parameter.LevelBg:SetSprite("Monster", "UI_Monster_IconDI_01.png", true)
    elseif state == IllustrationMonsterData.ILLUSTRATION_STATE.Already then
        --已解锁
        local l_color = Color.New(1, 1, 1, 1) -- 正常
        self.Parameter.MonsterImage.Img.color = l_color
        self.Parameter.TypeIcon.Img.color = l_color

        self.Parameter.LevelBg:SetSprite("Monster", DataMgr:GetData("IllustrationMonsterData").GetSpriteName(lvl), true)
    else
        --未解锁
        local l_color = Color.New(0, 0, 0, 0.5) -- 灰态
        self.Parameter.MonsterImage.Img.color = l_color
        self.Parameter.TypeIcon.Img.color = l_color
        self.Parameter.LevelBg:SetSprite("Monster", "UI_Monster_IconDI_01.png", true)
    end

    --特效
    if self.infoPart then
        self.infoPart:AddLoadCallback(function(tmp)
            local l_showHalo = state == IllustrationMonsterData.ILLUSTRATION_STATE.First
            tmp.Parameter.Halo.gameObject:SetActiveEx(l_showHalo and not isAwardPanel)
            local l_fxHalo = tmp.Parameter.Halo.gameObject:GetComponent("FxAnimationHelper")
            if l_showHalo then
                l_fxHalo:PlayAll()
            else
                l_fxHalo:StopAll()
            end
        end)
    end
end

function IllustrationMonsterCellTemplate:IsNeedInfoPart(monsterData)
    local ret = false
    if monsterData then
        ret = monsterData.UnitTypeLevel == 4 or monsterData.UnitTypeLevel == 5
        if not ret then
            ret = IllustrationMonsterData.GetMonsterStateById(monsterData.Id)
        end
    end

    return ret
end

function IllustrationMonsterCellTemplate:PlayEffect()
    local l_fxData = {}
    l_fxData.rawImage = self.Parameter.RawImg.RawImg
    l_fxData.scaleFac = Vector3.New(12, 12, 12)
    if self.EffectId then
        self:DestroyUIEffect(self.EffectId)
    end

    self.EffectId = self:CreateUIEffect("Effects/Prefabs/Creature/Ui/Fx_ui_mwdj", l_fxData)
    self.Parameter.RawImg:SetActiveEx(true)
end

function IllustrationMonsterCellTemplate:DestroyEffect()
    self.Parameter.RawImg:SetActiveEx(false)
    if self.EffectId then
        self:DestroyUIEffect(self.EffectId)
        self.EffectId = nil
    end
end

function IllustrationMonsterCellTemplate:RefreshRedSign()
    if self.isRewardPanel and self.monsterID and self.monsterID ~= 0 then
        local show = MgrMgr:GetMgr("IllustrationMonsterMgr").CheckSingle(self.monsterID)
        self.Parameter.RedSign:SetActiveEx(show)
    else
        self.Parameter.RedSign:SetActiveEx(false)
    end
end

--lua custom scripts end
return IllustrationMonsterCellTemplate