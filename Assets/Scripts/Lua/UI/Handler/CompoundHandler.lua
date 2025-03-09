--this file is gen by script
--you can edit this file in custom part

--lua requires
require "UI/UIBaseHandler"
require "UI/Panel/CompoundPanel"
require "Common/UI_TemplatePool"
require "UI/Template/CompoundTem"
require "UI/Template/ItemTemplate"
require "Data/Model/BagModel"

--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua class define
local super = UI.UIBaseHandler
---@class CompoundHandler:UIBaseHandler
---@field Mgr CompoundMgr
---@field ComposeRow ComposeTable
CompoundHandler = class("CompoundHandler", super)
--lua class define end

--lua functions
function CompoundHandler:ctor()

    super.ctor(self, HandlerNames.Compound, 0)
    self.Mgr = MgrMgr:GetMgr("CompoundMgr")
end --func end
--next--
function CompoundHandler:Init()

    self.panel = UI.CompoundPanel.Bind(self)
    super.Init(self)
    self.panel.Main.gameObject:SetActiveEx(false)
    self.panel.NoSelectEquip.gameObject:SetActiveEx(true)
    self.panel.Prefab.LuaUIGroup.gameObject:SetActiveEx(false)
    local l_equipItemConfig = { IsActive = false, TemplateParent = self.panel.IconButton.transform }
    self._equipItem = self:NewTemplate("ItemTemplate", l_equipItemConfig)
    self.SelectPool = self:NewTemplatePool({
        UITemplateClass = UITemplate.CompoundTem,
        TemplatePrefab = self.panel.Prefab.LuaUIGroup.gameObject,
        ScrollRect = self.panel.EquipItemScroll.LoopScroll,
        Method = function(tem, data, index)
            self:OnSelectItem(tem, data, index)
        end,
    })

    local l_itemPoolConfig = {
        UITemplateClass = UITemplate.ItemTemplate,
        TemplateParent = self.panel.ConsumeParent.transform,
    }

    self.ItemPool = self:NewTemplatePool(l_itemPoolConfig)
    self.panel.SelectButton.DropDown:ClearOptions()
    self.panel.SelectButton:SetDropdownOptions(self.Mgr.ShowTypes)
    self.panel.SelectButton.DropDown.onValueChanged:AddListener(function(index)
        self:OnSelectType(index)
    end)

    --仅显示可合成的物品
    self.OnlyCompleteTogValue = self.OnlyCompleteTogValue or false
    self.panel.OnlyCompleteTog.Tog.isOn = self.OnlyCompleteTogValue
    self.panel.OnlyCompleteTog:OnToggleChanged(function(b)
        local l_index = self.SelectClassIndex
        self.SelectClassIndex = -1
        local l_oldSelectItemID = nil
        if self.ItemData ~= nil then
            l_oldSelectItemID = self.ItemData.ItemID
        end

        self:OnSelectType(l_index)

        if l_oldSelectItemID ~= nil then
            self:SelectTargetID(l_oldSelectItemID)
        end
    end, true)

    --优先使用绑定材料
    self.BindTogValue = self.BindTogValue or true
    self.panel.BindTog.Tog.isOn = self.BindTogValue

    --数量输入限制
    self.panel.NumberInput.InputNumber.OnValueChange = function(value)
        --数量变化刷新显示
        local l_curCount = MLuaCommonHelper.Long2Int(value)
        for i = 1, #self.ItemPool.Datas do
            local l_data = self.ItemPool.Datas[i]
            l_data.RequireCount = l_curCount * l_data.l_RequireCount
        end
        self.ItemPool:ShowTemplates({ Datas = self.ItemPool.Datas })
    end

    --确定合成
    self.panel.ForgeEquipButton:AddClick(function()
        self:TryCompound()
    end, true)

end --func end
--next--
function CompoundHandler:Uninit()

    self.SelectPool = nil
    self.ItemPool = nil
    super.Uninit(self)
    self.panel = nil
    self._equipItem = nil

end --func end
--next--
function CompoundHandler:OnActive()
    if self.SelectClassIndex == -1 or self.SelectClassIndex == nil then
        self:OnSelectType(0)
    else
        local l_value = self.SelectClassIndex
        self.SelectClassIndex = -1
        self:OnSelectType(l_value)
    end
    --特效加载
    if not self._equipElevateEffect then
        local l_fxData = {}
        l_fxData.parent = self.panel.ForgeEffectParent.Transform
        l_fxData.scaleFac = Vector3.New(0.75, 0.75, 1)
        self._equipElevateEffect = self:CreateEffect("UI/Prefabs/EquipElevateEffect", l_fxData)
    end
end --func end
--next--
function CompoundHandler:OnDeActive()
    self.Mgr.CurIndex = 0
    self.SelectClassIndex = -1
    self.OnlyCompleteTogValue = self.panel and self.panel.OnlyCompleteTog.Tog.isOn or false
    self.BindTogValue = self.panel and self.panel.BindTog.Tog.isOn or false
    --特效关闭
    if self._equipElevateEffect then
        self:DestroyUIEffect(self._equipElevateEffect)
        self._equipElevateEffect = nil
    end
end --func end
--next--
function CompoundHandler:Update()
    -- do nothing
end --func end

--next--
function CompoundHandler:BindEvents()
    --道具变化
    local gameEventMgr = MgrMgr:GetMgr("GameEventMgr")
    self:BindEvent(gameEventMgr.l_eventDispatcher, gameEventMgr.OnBagUpdate, self._onItemChange)
    self:BindEvent(gameEventMgr.l_eventDispatcher, gameEventMgr.OnCompoundHandlerSwitch, self._onHandlerSwitch)
end --func end
--next--
--lua functions end

--lua custom scripts
---@param itemInfo ItemUpdateData[]
function CompoundHandler:_onItemChange(itemInfo)
    if self.panel == nil or self.ItemPool == nil or self.SelectPool == nil then
        logError("[Compound] prefab has fault data")
        return
    end

    --包含新增项目

    for i = 1, #itemInfo do
        local singleUpdateData = itemInfo[i]
        if nil == singleUpdateData.OldItem and nil ~= singleUpdateData.NewItem then
            local l_item = singleUpdateData.NewItem.TID
            l_item = TableUtil.GetComposeTable().GetRowByConsumableID(l_item, true)
            if l_item ~= nil then
                local l_index = self.SelectClassIndex
                self.SelectClassIndex = -1
                local l_oldSelectItemID = nil
                if self.ItemData ~= nil then
                    l_oldSelectItemID = self.ItemData.ItemID
                end

                self:OnSelectType(l_index)
                if l_oldSelectItemID ~= nil then
                    self:SelectTargetID(l_oldSelectItemID)
                end

                return
            end
        end
    end

    self:_refreshAllData()
    self:ResetInputMinMax(true)
    local l_hasRemove = false
    for i = #self.SelectPool.Datas, 1, -1 do
        local l_data = self.SelectPool.Datas[i]
        local l_count = self.Mgr.GetCanCompoundPropCount(l_data.ConsumableID)
        l_data.Count = l_count
        if l_count <= 0 then
            table.remove(self.SelectPool.Datas, i)
            l_hasRemove = true
        end
    end

    self.SelectPool:ShowTemplates({ Datas = self.SelectPool.Datas })
    if not l_hasRemove then
        return
    end

    --默认选择第一个
    local l_showFristTem = self.SelectPool:GetItem(1)
    if l_showFristTem ~= nil then
        self:OnSelectItem(l_showFristTem, l_showFristTem.Data, l_showFristTem.ShowIndex)
    else
        self:OnSelectItem(nil)
    end
end

function CompoundHandler:_onHandlerSwitch()
    self.panel.SelectButton.DropDown:Hide()
end

--选择左上角下拉分类
function CompoundHandler:OnSelectType(index)
    if self.SelectClassIndex == index then
        return
    end
    self.SelectClassIndex = index
    --清理当前的选择
    --self.panel.ForgeIcon:SetActiveEx(false)
    self._equipItem:SetGameObjectActive(false)
    self:OnSelectItem(nil)
    if index < 0 then
        return
    end
    local l_type = self.Mgr.GetTypeForShowIndex(index)
    local l_showRows = {}
    local l_composeRows = TableUtil.GetComposeTable().GetTable()
    local l_composeCount = #l_composeRows
    for i = 1, l_composeCount do
        local l_row = l_composeRows[i]
        if l_row.ComposeClassify == l_type or l_type == self.Mgr.Type.All then
            local l_itemCount = self.Mgr.GetCanCompoundPropCount(l_row.ConsumableID)

            l_row.Count = l_itemCount
            if l_itemCount > 0 then
                if self.panel.OnlyCompleteTog.Tog.isOn then
                    if l_itemCount >= l_row.quantity and self.Mgr.CheckCanCompoundByCost(l_row) then
                        l_showRows[#l_showRows + 1] = l_row
                    end
                else
                    l_showRows[#l_showRows + 1] = l_row
                end
            end
        end
    end

    --可合成道具优先显示
    if #l_showRows > 0 then
        local l_showSort = {}
        for i = 1, #l_showRows do
            local l_RequireCount = l_showRows[i].quantity
            local l_HasCount = self.Mgr.GetCanCompoundPropCount(l_showRows[i].ConsumableID)
            local l_CanCompound = l_HasCount >= l_RequireCount and self.Mgr.CheckCanCompoundByCost(l_showRows[i])
            if l_CanCompound then
                l_showSort[l_showRows[i]] = 1
            else
                l_showSort[l_showRows[i]] = 0
            end
        end
        table.sort(l_showRows, function(a, b)
            if l_showSort[a] ~= l_showSort[b] then
                return l_showSort[a] > l_showSort[b]
            end
            return b.ConsumableID > a.ConsumableID
        end)
    end

    self.SelectPool:ShowTemplates({ Datas = l_showRows })
    self.panel.NoneEquipText.gameObject:SetActiveEx(#l_showRows == 0)
    self.panel.Main.gameObject:SetActiveEx(false)
    self.panel.NoSelectEquip.gameObject:SetActiveEx(true)

    --默认选择第一个
    local l_showFristTem = self.SelectPool:GetItem(1)
    if l_showFristTem ~= nil then
        self:OnSelectItem(l_showFristTem, l_showFristTem.Data, l_showFristTem.ShowIndex)
    else
        self:OnSelectItem(nil)
    end
end

--选择左侧材料列表
function CompoundHandler:OnSelectItem(tem, data, index)
    if self.ComposeRow ~= nil and data ~= nil then
        if self.ComposeRow.ConsumableID == data.ConsumableID then
            return
        end
    end
    if self.SelectTem ~= nil then
        self.SelectTem:SetLightActive(false)
    end
    if tem == nil then
        self.ComposeRow = nil
        self.ItemData = nil
        self.TargetItemData = nil
        self.SelectTem = nil
        self.Mgr.CurIndex = 0
        --self.panel.ForgeIcon:SetActiveEx(false)
        self._equipItem:SetGameObjectActive(false)
        self.panel.Main:SetActiveEx(false)
        return
    end
    self.Mgr.CurIndex = index
    self.SelectTem = tem
    self.SelectTem:SetLightActive(true)
    self.ComposeRow = data
    self.ItemData = TableUtil.GetItemTable().GetRowByItemID(self.ComposeRow.ConsumableID)
    self.TargetItemData = TableUtil.GetItemTable().GetRowByItemID(self.ComposeRow.ObtainID)
    if self.ItemData == nil or self.TargetItemData == nil then
        logError(StringEx.Format("无法找到的道具 => ConsumableID={0}; ObtainID={1}", self.ComposeRow.ConsumableID, self.ComposeRow.ObtainID))
        return
    end
    self.panel.Main.gameObject:SetActiveEx(true)
    self.panel.NoSelectEquip.gameObject:SetActiveEx(false)
    self.panel.ItemName.LabText = self.TargetItemData.ItemName
    --self.panel.ForgeIcon:SetActiveEx(true)
    local l_hasCanCompoundPropCount = self.Mgr.GetCanCompoundPropCount(self.ComposeRow.ConsumableID)
    self._equipItem:SetData({
        ID = self.ComposeRow.ObtainID,
        IsShowCount = false,
        Count = l_hasCanCompoundPropCount,
    })
    self._equipItem:SetGameObjectActive(true)
    --self.panel.ForgeIcon:SetSprite(self.TargetItemData.ItemAtlas,self.TargetItemData.ItemIcon, true)

    --消耗的道具
    local l_items = {}
    local l_hasCanCompoundPropCount = self.Mgr.GetCanCompoundPropCount(self.ComposeRow.ConsumableID)
    table.insert(l_items, {
        ID = self.ComposeRow.ConsumableID,
        IsShowRequire = true,
        RequireCount = self.ComposeRow.quantity,
        IsShowCount = false,
        l_RequireCount = self.ComposeRow.quantity,
        Count = l_hasCanCompoundPropCount,
        l_HasCount = l_hasCanCompoundPropCount,
    })
    -- 其他
    for i = 0, self.ComposeRow.Cost.Count-1 do
        v = self.ComposeRow.Cost[i]
        local id = v[0]
        local num = v[1]
        -- 策划要配置成0，无奈
        if num > 0 then
            local has = tonumber(Data.BagModel:GetCoinOrPropNumById(id))
            table.insert(l_items, {
                ID = id,
                IsShowRequire = true,
                RequireCount = num,
                IsShowCount = false,
                l_RequireCount = num,
                Count = has,
                l_HasCount = has,
                l_is_other = true,
            })
        end
    end
    self.ItemPool:ShowTemplates({ Datas = l_items })
    self:ResetInputMinMax()

    --不存在绑定道具不现实优先Tog
    local l_hasBindItem = false
    local l_resultArg = {}
    for i = 1, #l_items do
        local l_data = l_items[i]
        l_resultArg[l_data.ID] = 1
    end
    local l_bagItems = self.Mgr.GetCanCompoundPropList(l_resultArg)
    for i = 1, #l_bagItems do
        local l_item = l_bagItems[i]
        if l_item.is_bind then
            l_hasBindItem = true
            break
        end
    end
    self.panel.BindTog:SetActiveEx(l_hasBindItem)
end

--- 合成界面只有一个道具材料，这里会强i选哪个刷新材料
function CompoundHandler:_refreshAllData()
    --- 如果这个界面没东西，制造界面触发了道具更新协议，也会触发这个函数
    --- 所以做个防御，没有东西可以制造，则返回
    local config = self.ComposeRow
    if nil == config then
        return
    end

    local itemID = self.ComposeRow.ConsumableID
    local itemRequireCount = self.ComposeRow.quantity
    local itemCount = self.Mgr.GetCanCompoundPropCount(itemID)
    local singleItemData = {
        ID = itemID,
        IsShowRequire = true,
        RequireCount = itemRequireCount,
        IsShowCount = false,
        l_RequireCount = itemRequireCount,
        l_HasCount = itemCount,
        Count = itemCount,
    }

    local l_items = { singleItemData }
    -- 其他
    for i = 0, self.ComposeRow.Cost.Count-1 do
        v = self.ComposeRow.Cost[i]
        local id = v[0]
        local num = v[1]
        if num > 0 then
            local has = tonumber(Data.BagModel:GetCoinOrPropNumById(id))
            table.insert(l_items, {
                ID = id,
                IsShowRequire = true,
                RequireCount = num,
                IsShowCount = false,
                l_RequireCount = num,
                Count = has,
                l_HasCount = has,
                l_is_other = true,
            })
        end
    end

    self.ItemPool:ShowTemplates({ Datas = l_items })
end

--选中目标合成材料
function CompoundHandler:SelectTargetMaterials(targetID)
    if self.panel == nil then
        return
    end
    if self:SelectTargetID(targetID) then
        return
    end
    self.panel.OnlyCompleteTog.Tog.isOn = false
    self:OnSelectType(self.Mgr.Type.All)

    if self:SelectTargetID(targetID) then
        return
    end
end

--选中当前SelectPool的目标ID材料
function CompoundHandler:SelectTargetID(targetID)
    --当前能找到
    local l_selectTem = self.SelectPool:FindShowTem(function(tem)
        return tem.Data.ConsumableID == targetID
    end)
    if l_selectTem ~= nil then
        self:OnSelectItem(l_selectTem, l_selectTem.Data, l_selectTem.ShowIndex)
        return true
    end
    --不能找到则滑到目标位置
    local l_allCount = #self.SelectPool.Datas
    for i = 1, l_allCount do
        local l_data = self.SelectPool.Datas[i]
        if l_data.ConsumableID == targetID then
            self.SelectPool:ShowTemplates({
                Datas = self.SelectPool.Datas,
                StartScrollIndex = i - 1,
            })
            local l_selectTem = self.SelectPool:FindShowTem(function(tem)
                return tem.Data.ConsumableID == targetID
            end)
            if l_selectTem ~= nil then
                self:OnSelectItem(l_selectTem, l_selectTem.Data, l_selectTem.ShowIndex)
                return true
            end
            break
        end
    end
    return false
end

--材料输入量上限
function CompoundHandler:ResetInputMinMax(clempValue)
    local l_maxNum = -1 --可以制作的数量
    for i = 1, #self.ItemPool.Datas do
        local l_data = self.ItemPool.Datas[i]
        local l_count = math.floor(l_data.l_HasCount / l_data.l_RequireCount)
        if l_maxNum >= 0 then
            l_maxNum = math.min(l_maxNum, l_count)
        else
            l_maxNum = l_count
        end
    end
    if l_maxNum <= 1 then
        l_maxNum = 1
    end

    self.panel.NumberInput.InputNumber.MinValue = 1
    self.panel.NumberInput.InputNumber.MaxValue = l_maxNum
    if clempValue then
        local Value = MLuaCommonHelper.Long2Int(self.panel.NumberInput.InputNumber:GetValue())
        if Value < 1 then
            Value = 1
        elseif Value > l_maxNum then
            Value = l_maxNum
        end
        self.panel.NumberInput.InputNumber:SetValue(Value)
    else
        self.panel.NumberInput.InputNumber:SetValue(1)
    end
end

--尝试合成
function CompoundHandler:TryCompound()
    if self.ComposeRow == nil then
        return
    end
    local l_maxNum = -1 --可以制作的数量
    for i = 1, #self.ItemPool.Datas do
        local l_data = self.ItemPool.Datas[i]
        local l_count = math.floor(l_data.l_HasCount / l_data.l_RequireCount)
        if l_maxNum >= 0 then
            l_maxNum = math.min(l_maxNum, l_count)
        else
            l_maxNum = l_count
        end
    end
    local l_outputCount = MLuaCommonHelper.Long2Int(self.panel.NumberInput.InputNumber:GetValue())
    if l_outputCount <= 0 then
        return
    end
    if l_outputCount > l_maxNum then
        for i = 1, #self.ItemPool.Datas do
            local l_data = self.ItemPool.Datas[i]
            if l_data.l_HasCount < l_data.l_RequireCount then
                MgrMgr:GetMgr("ItemTipsMgr").ShowTipsDisplayWithId(l_data.ID, nil, nil, nil, true)
                break
            end
        end
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("Compound_Materials"))--合成消耗材料不足哦~
        return
    end

    self:Compound(l_outputCount, true)
end

--确认合成
function CompoundHandler:Compound(num, hint)
    if self.panel == nil or num <= 0 then
        return
    end

    --选择合适的道具
    local l_resultArg = {}
    for i = 1, #self.ItemPool.Datas do
        local l_data = self.ItemPool.Datas[i]
        if not l_data.l_is_other and not table.ro_contains(l_resultArg,l_data.ID) then
            table.insert(l_resultArg,l_data.ID)
        end
    end
    local l_bagItems = self.Mgr.GetCanCompoundPropList(l_resultArg)
    local l_item = {}
    for i = 1, #self.ItemPool.Datas do
        local l_data = self.ItemPool.Datas[i]
        if not l_data.l_is_other then
	        local l_RequireAllCount = num * l_data.l_RequireCount
	        local l_residueNum = self:FindBindItem(l_data.ID, l_item, l_bagItems, l_RequireAllCount, self.panel.BindTog.Tog.isOn)
	        if l_residueNum > 0 then
	            if hint and self.ItemData ~= nil and l_RequireAllCount ~= l_residueNum then
	                --通用消耗提示框
	                --MPlayerSetting.CompoundTitle = false  --用于测试
	                local l_dateStr = tostring(os.date("!%Y%m%d",Common.TimeMgr.GetLocalNowTimestamp()))
	                local l_dateStrSave = UserDataManager.GetStringDataOrDef("COMPOUND_TODAY_NO_SHOW", MPlayerSetting.PLAYER_SETTING_GROUP, "")
	                if l_dateStr ~= l_dateStrSave then
	                    local l_itemData = TableUtil.GetItemTable().GetRowByItemID(self.ComposeRow.ObtainID)
	                    local l_bindCount = num
	                    if self.panel.BindTog.Tog.isOn then
	                        l_bindCount = math.ceil((l_RequireAllCount - l_residueNum) / l_data.l_RequireCount)
	                    else
	                        l_bindCount = math.ceil(l_residueNum / l_data.l_RequireCount)
	                    end
	                    local l_content = Lang("Compound_Hint")
	                    if l_bindCount > 0 then
	                        l_content = l_content .. StringEx.Format("\n{0}[{1}] × {2}",
	                                l_itemData.ItemName, GetColorText(Lang("Compound_Bind"), RoColorTag.Yellow), l_bindCount)
	                    end
	                    if num - l_bindCount > 0 then
	                        l_content = l_content .. StringEx.Format("\n{0} × {1}", l_itemData.ItemName, num - l_bindCount)
	                    end
	                    CommonUI.Dialog.ShowYesNoDlg(true, nil, l_content, function()
	                        self:Compound(num, false)
	                    end, nil, nil, 2, "COMPOUND_TODAY_NO_SHOW")
	                    return
	                end
	            end

	            l_residueNum = self:FindBindItem(l_data.ID, l_item, l_bagItems, l_residueNum, not self.panel.BindTog.Tog.isOn)
	            if l_residueNum > 0 then
	                logError("不能拿到对应数量的道具")
	                return
	            end
	        end
	    end
    end

    self.Mgr.SendCompound(l_item)
end


function CompoundHandler:FindBindItem(id, getItems, bagItems, getNum, bind)
    for i = 1, #bagItems do
        ---@type ItemData
        local l_item = bagItems[i]
        if l_item.IsBind == bind and id == l_item.TID and l_item.ItemCount > 0 then
            local l_num = l_item.ItemCount
            if l_item.ItemCount >= getNum then
                l_num = getNum
            end

            getItems[#getItems + 1] = {
                uid = l_item.UID,
                num = l_num,
                bind = l_item.IsBind,
            }

            getNum = getNum - l_num
            if getNum <= 0 then
                return 0
            end
        end
    end
    return getNum
end
--lua custom scripts end
return CompoundHandler