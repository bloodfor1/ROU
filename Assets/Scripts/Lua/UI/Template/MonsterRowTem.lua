--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/BaseUITemplate"
--lua requires end

--lua model
module("UITemplate", package.seeall)

--lua model end

--lua fields
local super = UITemplate.BaseUITemplate
--lua fields end

--lua class define
---@class MonsterRowTemParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field Text_Num MoonClient.MLuaUICom
---@field RowRewardParent MoonClient.MLuaUICom
---@field RedSignPrompt MoonClient.MLuaUICom
---@field MonsterRowPar MoonClient.MLuaUICom
---@field Btn_GetReward MoonClient.MLuaUICom

---@class MonsterRowTem : BaseUITemplate
---@field Parameter MonsterRowTemParameter

MonsterRowTem = class("MonsterRowTem", super)
--lua class define end

--lua functions
function MonsterRowTem:Init()

    super.Init(self)
    self.tem = nil
    self.attr = nil
    self.group = nil
    self.minLv = 32
    self.rewardData = {}
    self.Parameter.Btn_GetReward:AddClick(function()
        local l_openData = {
            openType = MonsterAwardType.MONSTER_AWARD_GROUP,
            data = self.rewardData
        }
        UIMgr:ActiveUI(UI.CtrlNames.IllustrationMonster_Reward, l_openData)
    end)

end --func end
--next--
function MonsterRowTem:BindEvents()

    self:BindEvent(MgrMgr:GetMgr("IllustrationMonsterMgr").EventDispatcher, DataMgr:GetData("IllustrationMonsterData").ILLUSTRATION_MONSTER_REWARD, self.RefreshRedSign)

end --func end
--next--
function MonsterRowTem:OnDestroy()

    self.tem = nil
    self.attr = nil
    self.group = nil
    self.minLv = 32
    self.rewardData = {}

end --func end
--next--
function MonsterRowTem:OnDeActive()


end --func end
--next--
function MonsterRowTem:OnSetData(data)

    self.data = data
    local minLv = 32
    for _, v in ipairs(data) do
        if v.Id and v.Id ~= 0 then
            local lvl = DataMgr:GetData("IllustrationMonsterData").GetMonsterRewardLevelById(v.Id)
            if lvl < minLv then
                minLv = lvl
            end
        end
    end
    self.minLv = minLv
    self.group = data[1].rowIndex
    self.attr = data[1].UnitAttrType
    self.Parameter.Text_Num.LabText = minLv
    if self.tem == nil then
        self.tem = self:NewTemplatePool({
            TemplateClassName = "IllustrationMonsterCellTemplate",
            TemplateParent = self.Parameter.MonsterRowPar.Transform,
            TemplatePath = "UI/Prefabs/MonsterPrefab",
            SetCountPerFrame = 1,
            CreateObjPerFrame = 1,
        })
    end

    if #data < 5 then
        for i = #data, 4 do
            table.insert(data, { needNil = true })
        end
    end

    self.tem:ShowTemplates({ Datas = data })
    local rewardTable = TableUtil.GetEntityGroupTable().GetTable()
    self.rewardData = {}
    for i = 1, #rewardTable do
        if rewardTable[i].Group == self.group and rewardTable[i].UnitAttrType == self.attr then
            for j = 0, rewardTable[i].LevelAward.Length - 1 do
                local k = j + 1
                local oneTb = {}
                oneTb.awardId = rewardTable[i].LevelAward[j][1]
                oneTb.Title = StringEx.Format(Common.Utils.Lang("ILLUSTRATION_MONSTER_REWARD_GROUP"), k)
                oneTb.element = self.attr
                oneTb.group = self.group
                oneTb.lv = k
                oneTb.nowLvl = self.minLv
                oneTb.monsterAwardType = MonsterAwardType.MONSTER_AWARD_GROUP
                oneTb.level = k
                oneTb.elementType = self.attr
                oneTb.groupId = self.group
                table.insert(self.rewardData, oneTb)
            end
            break
        end
    end

    self.Parameter.Btn_GetReward:SetActiveEx(#self.rewardData > 0)
    self.Parameter.Text_Num:SetActiveEx(#self.rewardData > 0)
    if 0 >= #self.rewardData then
        self.Parameter.RedSignPrompt:SetActiveEx(false)
        return
    end

    self.Parameter.RedSignPrompt:SetActiveEx(MgrMgr:GetMgr("IllustrationMonsterMgr").CheckLineRedSign(self.attr, self.group, self.minLv))
end --func end
--next--
--lua functions end

--lua custom scripts
function MonsterRowTem:_onTemplatePoolUpdate()
    if nil ~= self.tem then
        self.tem:OnUpdate()
    end
end

function MonsterRowTem:GetTemplatePool()
    return self.tem
end

function MonsterRowTem:RefreshRedSign()
    self.Parameter.RedSignPrompt:SetActiveEx(MgrMgr:GetMgr("IllustrationMonsterMgr").CheckLineRedSign(self.attr, self.group, self.minLv))
end

--lua custom scripts end
return MonsterRowTem