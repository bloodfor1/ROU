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
---@class DisplacerMakeItemTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field UnlockText MoonClient.MLuaUICom
---@field Selected MoonClient.MLuaUICom
---@field Prefab MoonClient.MLuaUICom
---@field Name MoonClient.MLuaUICom
---@field ItemButton MoonClient.MLuaUICom
---@field DisplacerIcon MoonClient.MLuaUICom
---@field CanMakeFlag MoonClient.MLuaUICom

---@class DisplacerMakeItemTemplate : BaseUITemplate
---@field Parameter DisplacerMakeItemTemplateParameter

DisplacerMakeItemTemplate = class("DisplacerMakeItemTemplate", super)
--lua class define end

--lua functions
function DisplacerMakeItemTemplate:Init()

    super.Init(self)

end --func end
--next--
function DisplacerMakeItemTemplate:OnDeActive()


end --func end
--next--
function DisplacerMakeItemTemplate:OnSetData(data)

    self.data = data
    local l_skillLv = MPlayerInfo:GetCurrentSkillInfo(data.UnlockSkillID[0]).lv
    local l_itemIndex = l_skillLv > data.ItemGroup.Count and data.ItemGroup.Count - 1 or l_skillLv - 1
    l_itemIndex = l_skillLv == 0 and l_skillLv or l_skillLv - 1
    local l_itemId = data.ItemGroup[l_itemIndex]
    local l_itemData = TableUtil.GetItemTable().GetRowByItemID(l_itemId)
    --设置当前等级的产出物品Id 和 使用附加材料后的物品ID
    self.data.curItemId = l_itemId
    self.data.curItemId2 = data.ItemGroup2[l_itemIndex]
    self.Parameter.DisplacerIcon:SetSprite(l_itemData.ItemAtlas, l_itemData.ItemIcon, true)
    self.Parameter.Name.LabText = l_itemData.ItemName
    --解锁条件显示
    if self.data.isUnlock then
        self.Parameter.UnlockText.UObj:SetActiveEx(false)
    else
        self.Parameter.UnlockText.UObj:SetActiveEx(true)
        local l_skillData = TableUtil.GetSkillTable().GetRowById(data.UnlockSkillID[0])
        self.Parameter.UnlockText.LabText = StringEx.Format(Lang("LIMIT_SKILL_LEVEL_UNLOCK"), l_skillData.Name, data.UnlockSkillID[1])
    end
    --可制造标志显示控制
    local l_isCanMake, l_childItemFirstShowIndex = self:CheckCanMake(data.BaseCost, data.ChoosableType1)
    self.Parameter.CanMakeFlag.UObj:SetActiveEx(l_isCanMake and self.data.isUnlock)
    --设置第一个显示的子项索引
    self.data.childItemFirstShowIndex = l_childItemFirstShowIndex
    --点击事件
    self.Parameter.ItemButton:AddClick(function()
        self:MethodCallback(self)
    end)

end --func end
--next--
function DisplacerMakeItemTemplate:BindEvents()


end --func end
--next--
function DisplacerMakeItemTemplate:OnDestroy()


end --func end
--next--
--lua functions end

--lua custom scripts
--确认是否制造
--baseCostGroup  基础消耗材料的数据组
--choseCostGroup  选择项消耗材料数据组
function DisplacerMakeItemTemplate:CheckCanMake(baseCostGroup, choseCostGroup)
    local l_isCanMake = true
    local l_childItemFirstShowIndex = 0  -- 点击项后默认显示的详细数据索引
    for i = 0, baseCostGroup.Count - 1 do
        local l_curNum = Data.BagModel:GetCoinOrPropNumById(baseCostGroup:get_Item(i, 0))
        if l_curNum < baseCostGroup:get_Item(i, 1) then
            l_isCanMake = false
            break
        end
    end
    --如果基础不满足 则不判断选择消耗项 这类消耗项 只需要满足任何一个即可
    if l_isCanMake then
        l_isCanMake = false
        for i = 0, choseCostGroup.Count - 1 do
            local l_curNum = Data.BagModel:GetCoinOrPropNumById(choseCostGroup[i][0])
            if l_curNum >= choseCostGroup[i][1] then
                l_childItemFirstShowIndex = i
                l_isCanMake = true
                break
            end
        end
    end

    return l_isCanMake, l_childItemFirstShowIndex
end

--设置被选中框是否显示
function DisplacerMakeItemTemplate:SetSelect(isSelected)
    self.Parameter.Selected.UObj:SetActiveEx(isSelected)
end
--lua custom scripts end
return DisplacerMakeItemTemplate