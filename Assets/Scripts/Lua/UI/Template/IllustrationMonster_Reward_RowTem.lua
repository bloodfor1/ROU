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
---@class IllustrationMonster_Reward_RowTemParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field Text_title MoonClient.MLuaUICom
---@field RedSign MoonClient.MLuaUICom
---@field List MoonClient.MLuaUICom
---@field HaveReceive MoonClient.MLuaUICom
---@field Btn_Receive MoonClient.MLuaUICom

---@class IllustrationMonster_Reward_RowTem : BaseUITemplate
---@field Parameter IllustrationMonster_Reward_RowTemParameter

IllustrationMonster_Reward_RowTem = class("IllustrationMonster_Reward_RowTem", super)
--lua class define end

--lua functions
function IllustrationMonster_Reward_RowTem:Init()

    super.Init(self)
    self.ItemPool = nil

end --func end
--next--
function IllustrationMonster_Reward_RowTem:BindEvents()

    self:BindEvent(MgrMgr:GetMgr("IllustrationMonsterMgr").EventDispatcher, DataMgr:GetData("IllustrationMonsterData").ILLUSTRATION_MONSTER_REWARD, self.RefreshReceiveState)

end --func end
--next--
function IllustrationMonster_Reward_RowTem:OnDestroy()

    self.ItemPool = nil

end --func end
--next--
function IllustrationMonster_Reward_RowTem:OnDeActive()


end --func end
--next--
function IllustrationMonster_Reward_RowTem:OnSetData(data)

    local l_awardData = TableUtil.GetAwardTable().GetRowByAwardId(data.awardId)
    local itemDatas = {}
    if l_awardData ~= nil then
        for i = 0, l_awardData.PackIds.Length - 1 do
            local l_packData = TableUtil.GetAwardPackTable().GetRowByPackId(l_awardData.PackIds[i])
            if l_packData ~= nil then
                for j = 0, l_packData.GroupContent.Count - 1 do
                    table.insert(itemDatas, { ID = tonumber(l_packData.GroupContent:get_Item(j, 0)), Count = tonumber(l_packData.GroupContent:get_Item(j, 1)) })
                end
            end
        end
    end
    if self.ItemPool == nil then
        self.ItemPool = self:NewTemplatePool({
            TemplateClassName = "ItemTemplate",
            TemplateParent = self.Parameter.List.Transform,
            TemplatePath = "UI/Prefabs/ItemPrefab",
        })
    end
    self.Parameter.Text_title.LabText = data.Title
    self.ItemPool:ShowTemplates({ Datas = itemDatas })
    if data.monsterAwardType == MonsterAwardType.MONSTER_AWARD_GROUP then
        self.element = data.element
        self.group = data.group
    end
    self.lv = data.lv
    self.type = data.monsterAwardType
    self:RefreshReceiveState()
    self.Parameter.Btn_Receive:SetGray(data.nowLvl < data.level)
    self.Parameter.RedSign:SetActiveEx(data.nowLvl >= data.level)
    self.Parameter.Btn_Receive:AddClick(function()
        if data.nowLvl >= data.level then
            MgrMgr:GetMgr("IllustrationMonsterMgr").GetMonsterAward(data.monsterAwardType, data.level, data.elementType, data.groupId)
        end
    end)

end --func end
--next--
--lua functions end

--lua custom scripts
function IllustrationMonster_Reward_RowTem:RefreshReceiveState()
    local haveReceive = false
    if self.type == MonsterAwardType.MONSTER_AWARD_RSEARCH then
        haveReceive = DataMgr:GetData("IllustrationMonsterData").CheckMonsterMainRewardCanPick(self.lv)
    else
        haveReceive = DataMgr:GetData("IllustrationMonsterData").CheckMonsterGroupRewardCanPick(self.element, self.group, self.lv)
    end
    self.Parameter.Btn_Receive:SetActiveEx(not haveReceive)
    self.Parameter.HaveReceive:SetActiveEx(haveReceive)
end
--lua custom scripts end
return IllustrationMonster_Reward_RowTem