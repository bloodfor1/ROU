--this file is gen by script
--you can edit this file in custom part

--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/DisplacerUsePanel"
require "UI/Template/EquipElevateEffectTemplate"
require "UI/Template/DisplacerEquipItemTemplate"
require "UI/Template/DisplacerPropertyItemTemplate"
require "UI/Template/DisplacerSelectItemTemplate"
require "UI/Template/ItemTemplate"

--lua requires end

---@class DisplacerData
---@field Item ItemData
---@field isEquiped boolean
---@field isUsedDisplacer boolean

--lua model
module("UI", package.seeall)
--lua model end

--lua class define
local super = UI.UIBaseCtrl

---@type ModuleMgr.AttrDescUtil
local attrUtil = MgrMgr:GetMgr("AttrDescUtil")
DisplacerUseCtrl = class("DisplacerUseCtrl", super)
--lua class define end

local l_displacerMgr = nil
---@type DisplacerData[]
local l_equipDatas = nil  --全部装备数据列表
---@type ItemData[]
local l_displacerDatas = nil  --全部置换器数据列表
---@type DisplacerData
local l_selectEquipData = nil  --当前选中的装备数据
---@type ItemData
local l_selectDisplacerData = nil  --当前选中置换器数据
local l_enterWeaponUid = nil  --进入时的武器UID

--lua functions
function DisplacerUseCtrl:ctor()
    super.ctor(self, CtrlNames.DisplacerUse, UILayer.Function, nil, ActiveType.Exclusive)
end --func end
--next--
function DisplacerUseCtrl:Init()
    self.panel = UI.DisplacerUsePanel.Bind(self)
    super.Init(self)
    l_displacerMgr = MgrMgr:GetMgr("DisplacerMgr")

    --特效加载
    if not self._equipElevateEffect then
        local l_fxData = {}
        l_fxData.parent = self.panel.EffectParent.Transform
        l_fxData.scaleFac = Vector3.New(0.75, 0.75, 1)
        self._equipElevateEffect = self:CreateEffect("UI/Prefabs/EquipElevateEffect", l_fxData)
    end

    --全部装备数据列表获取
    l_equipDatas = {}
    l_displacerDatas = {}

    --主手武器获取
    local l_propInfo = Data.BagApi:GetItemByTypeSlot(GameEnum.EBagContainerType.Equip, EquipPos.MAIN_WEAPON + 1)
    if l_propInfo ~= nil and Common.CommonUIFunc.IsInContainDeviceTable(l_propInfo.EquipConfig.WeaponId) then
        -- l_propInfo.isEquiped = true
        ---@type DisplacerData
        local displacerData = {
            Item = l_propInfo,
            isEquiped = true
        }

        table.insert(l_equipDatas, displacerData)
    end

    --副手武器获取
    l_propInfo = Data.BagApi:GetItemByTypeSlot(GameEnum.EBagContainerType.Equip, EquipPos.SECONDARY_WEAPON + 1)
    if l_propInfo ~= nil and Common.CommonUIFunc.IsInContainDeviceTable(l_propInfo.EquipConfig.WeaponId) then
        --副手是否是武器需要判断一下
        -- l_propInfo.isEquiped = true
        ---@type DisplacerData
        local displacerData = {
            Item = l_propInfo,
            isEquiped = true
        }

        table.insert(l_equipDatas, displacerData)
    end

    --背包中武器获取
    local items = self:_getItemsInBag()
    for k, v in pairs(items) do
        if v.ItemConfig.TypeTab == Data.BagModel.PropType.Weapon then
            local l_equipRow = v.EquipConfig
            if l_equipRow.EquipId == 1 and Common.CommonUIFunc.IsInContainDeviceTable(l_equipRow.WeaponId) then
                -- v.isEquiped = false
                ---@type DisplacerData
                local displacerData = {
                    Item = v,
                    isEquiped = false
                }

                table.insert(l_equipDatas, displacerData)
            end
        end
    end

    --下拉筛选框选择事件
    local l_selectType = { Lang("AllText"), Lang("ALREADY_USED"), Lang("NO_USED") }
    self.panel.EquipSelectDrop.DropDown:ClearOptions()
    self.panel.EquipSelectDrop:SetDropdownOptions(l_selectType)
    self.panel.EquipSelectDrop.DropDown.onValueChanged:AddListener(function(index)
        self:ShowEquipType(index)
    end)

    --按钮点击事件统一添加
    self:ButtonClickEventAdd()
    --对象池统一申明
    self:TemplatePoolInit()
    --置换器的填充容器 创建
    self.displacerSelect = self:NewTemplate("ItemTemplate", { IsActive = false, TemplateParent = self.panel.ItemBoxDisplacer.transform })
    --装备列表展示
    self:ShowEquipType(0)
    --初始化使用成功标志
    self.isUseSucc = false
end --func end
--next--
function DisplacerUseCtrl:Uninit()
    self.displacerSelect = nil
    if self._equipElevateEffect then
        self:DestroyUIEffect(self._equipElevateEffect)
        self._equipElevateEffect = nil
    end

    self.equipSelectTemplatePool = nil
    self.displacerPropertyItemPool = nil
    self.displacerChooseTemplatePool = nil
    self.curSelectedItem = nil
    self.isUseSucc = false
    l_enterWeaponUid = nil
    l_displacerMgr = nil
    super.Uninit(self)
    self.panel = nil
end --func end
--next--
function DisplacerUseCtrl:OnActive()
    if l_enterWeaponUid then
        local l_index = 1
        for i = 1, #l_equipDatas do
            if l_equipDatas[i].Item.UID == l_enterWeaponUid then
                l_index = i
            end
        end

        local l_item = self.equipSelectTemplatePool:GetItem(l_index)
        if l_item then
            l_item:SetSelect(true)
            self:OnSelectEquip(l_item.data)
        end
    end
end --func end
--next--
function DisplacerUseCtrl:OnDeActive()
    -- do nothing
end --func end
--next--
function DisplacerUseCtrl:Update()
    -- do nothing
end --func end

--next--
function DisplacerUseCtrl:BindEvents()
    --制造成功返回
    self:BindEvent(MgrMgr:GetMgr("DisplacerMgr").EventDispatcher, MgrMgr:GetMgr("DisplacerMgr").ON_DISPLACER_USE_SUCCESS, function(self)
        --设置设置成功标志 等待道具变更协议
        self.isUseSucc = true

    end)

    --道具信息变更
    self:BindEvent(MgrProxy:GetGameEventMgr().l_eventDispatcher, MgrProxy:GetGameEventMgr().OnBagUpdate, function(self)
        --如果道具使用成功 切获取到道具更新协议则刷新
        if self.isUseSucc then
            self.equipSelectTemplatePool:RefreshCells()
            l_selectDisplacerData = nil
            self.displacerSelect:SetGameObjectActive(false)
            self.panel.BtnDeleteDisplacer.UObj:SetActiveEx(false)
            self:ShowProperty()
            self.panel.SucceedEffect.UObj:SetActiveEx(false)
            self.panel.SucceedEffect.UObj:SetActiveEx(true)
            self.isUseSucc = false
        end
    end)

end --func end
--next--
--lua functions end

--lua custom scripts
--- 获取背包中的道具
---@return ItemData[]
function DisplacerUseCtrl:_getItemsInBag()
    local types = { GameEnum.EBagContainerType.Bag }
    local items = Data.BagApi:GetItemsByTypesAndConds(types, nil)
    return items
end

--由武器打开时 记录UID
function DisplacerUseCtrl:SetOpenWeapon(weaponUid)
    l_enterWeaponUid = weaponUid
end

--按钮点击事件绑定
function DisplacerUseCtrl:ButtonClickEventAdd()
    --关闭按钮点击
    self.panel.BtnClose:AddClick(function()
        UIMgr:DeActiveUI(UI.CtrlNames.DisplacerUse)
    end)
    --置换器选择按钮点击
    self.panel.BtnSelectDisplacer:AddClick(function()
        --可使用的置换器列表设置
        if l_selectEquipData then
            self.panel.DisplacerChoosePanel:SetActiveEx(true)
            self:SetDisplacerList(l_selectEquipData.Item.TID)
        else
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("PLEASR_SELECT_ONE_WEAPON"))
        end

        self:ShowProperty()
    end)
    --置换器选择界面关闭按钮
    self.panel.BtnDisplacerChooseClose:AddClick(function()
        self.panel.DisplacerChoosePanel:SetActiveEx(false)
        self:ShowProperty()
    end)
    --去除置换器按钮点击
    self.panel.BtnDeleteDisplacer:AddClick(function()
        l_selectDisplacerData = nil
        self.displacerSelect:SetGameObjectActive(false)
        self.panel.BtnDeleteDisplacer.UObj:SetActiveEx(false)
        self:ShowProperty()
    end)
    --制造按钮点击
    self.panel.BtnUse:AddClick(function()
        self:BtnUseClick()
    end)
end

--对象池初始化
function DisplacerUseCtrl:TemplatePoolInit()
    --装备选项池
    self.equipSelectTemplatePool = self:NewTemplatePool({
        UITemplateClass = UITemplate.DisplacerEquipItemTemplate,
        TemplatePrefab = self.panel.DisplacerEquipItemPrefab.Prefab.gameObject,
        ScrollRect = self.panel.EquipItemScroll.LoopScroll
    })
    --属性对象池
    self.displacerPropertyItemPool = self:NewTemplatePool({
        UITemplateClass = UITemplate.DisplacerPropertyItemTemplate,
        TemplatePrefab = self.panel.DisplacerPropertyItemPrefab.Prefab.gameObject,
        ScrollRect = self.panel.PropertyScroll.LoopScroll
    })
    --选择置换器的选项池
    self.displacerChooseTemplatePool = self:NewTemplatePool({
        UITemplateClass = UITemplate.DisplacerSelectItemTemplate,
        TemplatePrefab = self.panel.DisplacerSelectItemPrefab.Prefab.gameObject,
        ScrollRect = self.panel.DisplacerChooseScroll.LoopScroll
    })
end

--展示可制作的材料列表
--index 展示类型 0全部 1已解锁 2未解锁
function DisplacerUseCtrl:ShowEquipType(index)
    --清除原列表选中项
    if self.curSelectedItem ~= nil then
        self.curSelectedItem:SetSelect(false)
    end
    self.curSelectedItem = nil
    --新列表获取
    local l_showDatas = nil
    if index == 1 then
        --显示已使用
        l_showDatas = {}
        for i = 1, #l_equipDatas do
            if l_equipDatas[i].isUsedDisplacer then
                table.insert(l_showDatas, l_equipDatas[i])
            end
        end
    elseif index == 2 then
        --显示未使用
        l_showDatas = {}
        for i = 1, #l_equipDatas do
            if not l_equipDatas[i].isUsedDisplacer then
                table.insert(l_showDatas, l_equipDatas[i])
            end
        end
    else
        --显示全部
        l_showDatas = l_equipDatas
    end
    --列表展示
    self.equipSelectTemplatePool:ShowTemplates({ Datas = l_showDatas, Method = function(item)
        self:OnSelectEquip(item.data)
        -- 如果之前存在选中项则清除原有选中效果
        if self.curSelectedItem ~= nil then
            self.curSelectedItem:SetSelect(false)
        end
        -- 更新当前选中项 且 设置选中效果
        self.curSelectedItem = item
        self.curSelectedItem:SetSelect(true)

        --- 点击之后显示属性
        self:ShowProperty()
    end })

    --详细内容显示默认第一个制造项
    self:OnSelectEquip(l_showDatas[1])
end

--选中装备展示装备属性
---@param data DisplacerData
function DisplacerUseCtrl:OnSelectEquip(data)
    l_selectEquipData = data
    l_selectDisplacerData = nil
    self.panel.SelectItemRefineLv.gameObject:SetActiveEx(false)
    self.panel.SelectItemUnidentified.gameObject:SetActiveEx(false)
    self.panel.SelectItemDamage.gameObject:SetActiveEx(false)
    self.panel.SelectItemRare.gameObject:SetActiveEx(false)
    local l_holeList = {}
    for i = 1, 4 do
        l_holeList[i] = self.panel.SelectItemHole.transform:Find("SelectItemImgHole" .. i):GetComponent("MLuaUICom")
        l_holeList[i].gameObject:SetActiveEx(false)
    end

    self.displacerSelect:SetGameObjectActive(false)
    self.panel.BtnDeleteDisplacer.UObj:SetActiveEx(false)
    self.panel.TitleProperty.LabText = Lang("CUR_DISPLACER_ATTRIBUTE")

    if l_selectEquipData then
        self.panel.IconButton:AddClick(function()
            MgrMgr:GetMgr("ItemTipsMgr").ShowTipsDisplayWithInfo(l_selectEquipData.Item, nil, Data.BagModel.WeaponStatus.NORMAL_PROP, nil, false, nil)
        end)

        local l_itemInfo = data.Item.ItemConfig
        local l_name = l_itemInfo.ItemName
        self.panel.IconImg.UObj:SetActiveEx(true)
        self.panel.IconImg:SetSprite(l_itemInfo.ItemAtlas, l_itemInfo.ItemIcon, true)

        --精炼等级
        if data.Item.RefineLv > 0 then
            l_name = StringEx.Format("+{0}" .. l_name, data.Item.RefineLv)
            self.panel.SelectItemRefineLv.gameObject:SetActiveEx(true)
            self.panel.SelectItemRefineLv.LabText = StringEx.Format("+{0}", data.Item.RefineLv)
        end
        --洞
        if l_itemInfo.TypeTab == 1 then
            MgrMgr:GetMgr("EquipMgr").SetEquipIconHole(data.Item, l_holeList)
            self.panel.SelectItemUnidentified.gameObject:SetActiveEx(false)
        end

        if data.Item.Damaged then
            --损坏
            self.panel.SelectItemDamage.gameObject:SetActiveEx(true)
            self.panel.SelectItemDamage:SetSprite("Common", "UI_Common_IconPosun.png")
            self.panel.SelectItemRare.gameObject:SetActiveEx(false)
        elseif data.Item.RefineSealLv > 0 then
            --封印
            self.panel.SelectItemDamage.gameObject:SetActiveEx(true)
            self.panel.SelectItemDamage:SetSprite("Common", "UI_Common_IconSeal.png")
            self.panel.SelectItemRare.gameObject:SetActiveEx(false)
        else
            self.panel.SelectItemDamage.gameObject:SetActiveEx(false)
            self.panel.SelectItemRare.gameObject:SetActiveEx(MgrMgr:GetMgr("EquipMgr").IsRaity(data.Item))
        end

        self.panel.WeaponName.LabText = l_name
        --属性显示
        local l_propertyList = MgrMgr:GetMgr("PropMgr").GetAttrDeviceTipsInfo(l_selectEquipData)
        local l_propertyDatas = {}
        for i = 1, #l_propertyList do
            l_temp = {}
            l_temp.description = l_propertyList[i]
            l_temp.isBuff = true
            table.insert(l_propertyDatas, l_temp)
        end

        self.panel.IsNoUse.UObj:SetActiveEx(#l_propertyDatas == 0)
        self.displacerPropertyItemPool:ShowTemplates({ Datas = l_propertyDatas })
    else
        self.panel.IconButton:AddClick(function()
        end)
        self.panel.IconImg.UObj:SetActiveEx(false)
        self.panel.WeaponName.LabText = ""
        self.panel.IsNoUse.UObj:SetActiveEx(false)
        self.displacerPropertyItemPool:ShowTemplates({ Datas = {} })
        self.displacerChooseTemplatePool:ShowTemplates({ Datas = {} })
    end
end

--设置置换器列表
function DisplacerUseCtrl:SetDisplacerList(weaponItemId)
    local l_weaponId = TableUtil.GetEquipTable().GetRowById(weaponItemId).WeaponId
    l_displacerDatas = {}
    local targetItems = self:_getItemsInBag()
    for k, v in pairs(targetItems) do
        if v.ItemConfig.TypeTab == Data.BagModel.PropType.Displacer then
            local l_deviceInfo = TableUtil.GetDeviceTable().GetRowById(v.TID)
            for i = 0, l_deviceInfo.TypeLimit.Count - 1 do
                if l_deviceInfo.TypeLimit[i] == l_weaponId then
                    table.insert(l_displacerDatas, v)
                    break
                end
            end
        end
    end

    self.displacerChooseTemplatePool:ShowTemplates({ Datas = l_displacerDatas, Method = function(item)
        self.panel.DisplacerChoosePanel:SetActiveEx(false)
        l_selectDisplacerData = item.data
        self.displacerSelect:SetData({
            ID = l_selectDisplacerData.TID,
            IsShowCount = false,
            IsShowRequire = true,
            RequireCount = 1,
        })

        self.panel.BtnDeleteDisplacer.UObj:SetActiveEx(true)
        self.panel.TitleProperty.LabText = Lang("AFTER_CHANGE_DISPLACER_ATTRIBUTE")
        local displacerAttr = l_selectDisplacerData.AttrSet[GameEnum.EItemAttrModuleType.Device]
        local l_propertyList = attrUtil.GetAttrStr(displacerAttr[1][1]).Desc
        local l_propertyDatas = {}
        local l_temp = {}
        l_temp.description = l_propertyList
        l_temp.isBuff = true
        table.insert(l_propertyDatas, l_temp)

        self.panel.IsNoUse.UObj:SetActiveEx(false)
        self.displacerPropertyItemPool:ShowTemplates({ Datas = l_propertyDatas })
    end })
end

--属性展示
function DisplacerUseCtrl:ShowProperty()
    local l_propertyList = nil
    --- 选择的时候可能没有任何东西可以选择，这个之后直接返回
    if nil == l_selectEquipData then
        return
    end

    if l_selectDisplacerData then
        --如果选择了置换器 则显示置换器属性
        self.panel.TitleProperty.LabText = Lang("AFTER_CHANGE_DISPLACER_ATTRIBUTE")
        local displacerAttr = l_selectDisplacerData.AttrSet[GameEnum.EItemAttrModuleType.Device]
        l_propertyList = attrUtil.GetAttrStr(displacerAttr[1][1]).Desc
    else
        --如果没有选择置换器 则显示装备的置换器属性
        self.panel.TitleProperty.LabText = Lang("CUR_DISPLACER_ATTRIBUTE")
        local displacerAttr = l_selectEquipData.Item.AttrSet[GameEnum.EItemAttrModuleType.Device]
        if 0 < #l_selectEquipData.Item.AttrSet[GameEnum.EItemAttrModuleType.Device][1] then
            l_propertyList = attrUtil.GetAttrStr(displacerAttr[1][1]).Desc
        end
    end

    local l_propertyDatas = {}
    if 0 < #l_selectEquipData.Item.AttrSet[GameEnum.EItemAttrModuleType.Device][1] then
        local l_temp = {}
        l_temp.description = l_propertyList
        l_temp.isBuff = true
        table.insert(l_propertyDatas, l_temp)
    end

    self.panel.IsNoUse.UObj:SetActiveEx(#l_propertyDatas == 0)
    self.displacerPropertyItemPool:ShowTemplates({ Datas = l_propertyDatas })
end

--使用按钮点击
function DisplacerUseCtrl:BtnUseClick()
    --判断是否有选中的装备
    if l_selectEquipData == nil then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("PLEASR_SELECT_ONE_WEAPON"))
        return
    end

    --判断是否有选中的置换器
    if l_selectDisplacerData == nil then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("PLEASR_SELECT_ONE_DISPLACER"))
        return
    end

    --确认使用类型是否正确
    local l_isCheck = false
    local l_weaponId = TableUtil.GetEquipTable().GetRowById(l_selectEquipData.Item.TID).WeaponId
    local l_deviceInfo = TableUtil.GetDeviceTable().GetRowById(l_selectDisplacerData.TID)
    for i = 0, l_deviceInfo.TypeLimit.Count - 1 do
        if l_deviceInfo.TypeLimit[i] == l_weaponId then
            l_isCheck = true
            break
        end
    end

    if not l_isCheck then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("DISPLACER_TYPE_ERROR"))
        return
    end

    --请求使用置换器
    l_displacerMgr.ReqUseDisplacer(l_selectEquipData.Item.UID, l_selectDisplacerData.UID)
end
return DisplacerUseCtrl
--lua custom scripts end
