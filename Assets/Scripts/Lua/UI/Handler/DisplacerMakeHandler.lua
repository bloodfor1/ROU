--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseHandler"
require "UI/Panel/DisplacerMakePanel"
require "UI/Template/DisplacerMakeItemTemplate"
require "UI/Template/DisplacerPropertyItemTemplate"
require "UI/Template/ItemTemplate"
require "UI/Template/DisplacerMaterialSelectItemTemplate"
require "UI/Template/EquipElevateEffectTemplate"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua fields
local super = UI.UIBaseHandler
--next--
--lua fields end

--lua class define
DisplacerMakeHandler = class("DisplacerMakeHandler", super)
--lua class define end

local l_displacerMgr = nil
local l_datas = nil  --全制造项数据列表
local l_curSelectData = nil  --当前选中项的数据
local l_curChildItemIndex = 0  --当前选中项展示的子项的索引
local l_isUseChoosable2 = false  --是否是用第二可选材料
local l_indexChoose2 = 0  --选中的可选材料2 的索引

--lua functions
function DisplacerMakeHandler:ctor()
    super.ctor(self, HandlerNames.DisplacerMake, 0)
end --func end
--next--
function DisplacerMakeHandler:Init()
    self.panel = UI.DisplacerMakePanel.Bind(self)
    super.Init(self)
    l_displacerMgr = MgrMgr:GetMgr("DisplacerMgr")
    --下拉筛选框选择事件
    local l_selectType = { Lang("AllText"), Lang("UNLOCKED"), Lang("LOCKED") }
    self.panel.SelectDrop.DropDown:ClearOptions()
    self.panel.SelectDrop:SetDropdownOptions(l_selectType)
    self.panel.SelectDrop.DropDown.onValueChanged:AddListener(function(index)
        self:ShowDisplacerMakeType(index)
    end)
    --按钮点击事件统一添加
    self:ButtonClickEventAdd()
    --对象池统一申明
    self:TemplatePoolInit()
    --可选材料2 的填充容器 创建
    self.materialChoose2 = self:NewTemplate("ItemTemplate", { IsActive = false, TemplateParent = self.panel.ItemBoxChoose2.transform })
    --提示文字赋值
    self.panel.TipDescribe.LabText = Lang("MAKE_DEVICE_TIPS")
end --func end
--next--
function DisplacerMakeHandler:Uninit()
    self.materialChoose2 = nil
    self.displacerMakeTemplatePool = nil
    self.displacerPropertyItemPool = nil
    self.materialNeedTemplatePool = nil
    self.materialChooseTemplatePool = nil
    l_displacerMgr = nil
    super.Uninit(self)
    self.panel = nil
end --func end
--next--
function DisplacerMakeHandler:OnActive()
    --全制造项数据获取
    l_datas = {}
    local l_rows = TableUtil.GetMerchantMakeEnchantTable().GetTable()
    for i = 1, #l_rows do
        local l_temp = l_rows[i]
        --默认技能等级制造的物品的Id设定
        l_temp.curItemId = 0
        --默认选中时显示的第一个子项索引设置
        l_temp.childItemFirstShowIndex = 0
        --是否已解锁
        local l_skillLv = MPlayerInfo:GetCurrentSkillInfo(l_temp.UnlockSkillID[0]).lv
        l_temp.isUnlock = l_skillLv >= l_temp.UnlockSkillID[1]
        --插入数据表
        table.insert(l_datas, l_temp)
    end

    --初始展示全部可制造列表内容
    self:ShowDisplacerMakeType(0)

    --特效加载
    if not self._equipElevateEffect then
        local l_fxData = {}
        l_fxData.parent = self.panel.EffectParent.Transform
        l_fxData.scaleFac = Vector3.New(0.75, 0.75, 1)
        self._equipElevateEffect = self:CreateEffect("UI/Prefabs/EquipElevateEffect", l_fxData)
    end
end --func end
--next--
function DisplacerMakeHandler:OnDeActive()

    --清除原列表选中项
    if self.curSelectedItem ~= nil then
        self.curSelectedItem:SetSelect(false)
    end
    self.curSelectedItem = nil
    l_curSelectData = nil
    --特效关闭
    if self._equipElevateEffect then
        self:DestroyUIEffect(self._equipElevateEffect)
        self._equipElevateEffect = nil
    end
    --数据清理
    l_datas = nil
end --func end

--next--
function DisplacerMakeHandler:Update()


end --func end

function DisplacerMakeHandler:_onHandlerSwitch()
    self.panel.SelectDrop.DropDown:Hide()
end

--next--
function DisplacerMakeHandler:BindEvents()
    --制造成功返回
    local gameEventMgr = MgrMgr:GetMgr("GameEventMgr")
    self:BindEvent(gameEventMgr.l_eventDispatcher, gameEventMgr.OnCompoundHandlerSwitch, self._onHandlerSwitch)
    self:BindEvent(l_displacerMgr.EventDispatcher, l_displacerMgr.ON_DISPLACER_MAKE_SUCCESS, function(self)
        self.displacerMakeTemplatePool:RefreshCells()
        self:ShowMaterial()
        self.panel.RedPrompt.UObj:SetActiveEx(self:CheckItemCanMake())
        self.panel.SucceedEffect.UObj:SetActiveEx(false)
        self.panel.SucceedEffect.UObj:SetActiveEx(true)
    end)
end --func end

--next--
function DisplacerMakeHandler:OnShow()


    --进入商会买材料回来时刷新
    self.displacerMakeTemplatePool:RefreshCells()
    self:ShowMaterial()
    self.panel.RedPrompt.UObj:SetActiveEx(self:CheckItemCanMake())

end --func end
--next--
function DisplacerMakeHandler:OnHide()


end --func end
--next--
--lua functions end

--lua custom scripts
--按钮点击事件绑定
function DisplacerMakeHandler:ButtonClickEventAdd()
    --向左切换按钮点击
    self.panel.BtnArrowLeft:AddClick(function()
        self:SwitchChildItem(0)
    end)
    --向右切换按钮点击
    self.panel.BtnArrowRight:AddClick(function()
        self:SwitchChildItem(1)
    end)
    --可选材料2 选择按钮点击
    self.panel.BtnSelectChoose2:AddClick(function()
        self.panel.MaterialChoosePanel:SetActiveEx(true)
    end)
    --材料选择界面关闭按钮
    self.panel.BtnMaterialChooseClose:AddClick(function()
        self.panel.MaterialChoosePanel:SetActiveEx(false)
    end)
    --去除可选材料2按钮点击
    self.panel.BtnDeleteChoose2:AddClick(function()
        l_isUseChoosable2 = false
        l_indexChoose2 = 0

        self.materialChoose2:SetGameObjectActive(false)
        self.panel.BtnDeleteChoose2.UObj:SetActiveEx(false)
        self:SetIconAndName()
        self:ShowProperty()
        self:CalculateSuccessRate()
        --判断是否可制造 展示红点
        self.panel.RedPrompt.UObj:SetActiveEx(self:CheckItemCanMake())
    end)
    --制造按钮点击
    self.panel.BtnMake:AddClick(function()
        self:BtnMakeClick()
    end)
    --提示展示按钮点击
    self.panel.BtnTipShow:AddClick(function()
        self.panel.TipsPanel.UObj:SetActiveEx(true)
    end)
    --提示关闭空白点击
    self.panel.BtnTipClose:AddClick(function()
        self.panel.TipsPanel.UObj:SetActiveEx(false)
    end)

end

--对象池初始化
function DisplacerMakeHandler:TemplatePoolInit()
    --置换器制作选项池
    self.displacerMakeTemplatePool = self:NewTemplatePool({
        UITemplateClass = UITemplate.DisplacerMakeItemTemplate,
        TemplatePrefab = self.panel.DisplacerMakeItemPrefab.Prefab.gameObject,
        ScrollRect = self.panel.ItemScroll.LoopScroll
    })
    --属性对象池
    self.displacerPropertyItemPool = self:NewTemplatePool({
        UITemplateClass = UITemplate.DisplacerPropertyItemTemplate,
        TemplatePrefab = self.panel.DisplacerPropertyItemPrefab.Prefab.gameObject,
        ScrollRect = self.panel.PropertyScroll.LoopScroll
    })
    --制造所需材料池
    self.materialNeedTemplatePool = self:NewTemplatePool({
        UITemplateClass = UITemplate.ItemTemplate,
        TemplateParent = self.panel.CostBaseBox.transform
    })
    --可选材料2 的选项池
    self.materialChooseTemplatePool = self:NewTemplatePool({
        UITemplateClass = UITemplate.DisplacerMaterialSelectItemTemplate,
        TemplatePrefab = self.panel.DisplacerMaterialSelectItemPrefab.Prefab.gameObject,
        ScrollRect = self.panel.MaterialChooseScroll.LoopScroll
    })
end


--确认是否制造  (红点判断)
function DisplacerMakeHandler:CheckItemCanMake()
    local l_isCanMake = true
    for i = 0, l_curSelectData.BaseCost.Count - 1 do
        local l_curNum = Data.BagModel:GetCoinOrPropNumById(l_curSelectData.BaseCost[i][0])
        if l_curNum < l_curSelectData.BaseCost[i][1] then
            l_isCanMake = false
            break
        end
    end

    --如果基础不满足 则不判断选择消耗项
    if l_isCanMake then
        local l_curNum = Data.BagModel:GetCoinOrPropNumById(l_curSelectData.ChoosableType1[l_curChildItemIndex][0])
        if l_curNum < l_curSelectData.ChoosableType1[l_curChildItemIndex][1] then
            l_isCanMake = false
        end
    end

    --如果基础不满足 则不判断选择消耗项
    if l_isCanMake and l_isUseChoosable2 then
        --如果使用了可选材料2 则检查是否数量足够
        local l_curNum = Data.BagModel:GetCoinOrPropNumById(l_curSelectData.ChoosableType2[l_indexChoose2][0])
        if l_curNum < l_curSelectData.ChoosableType2[l_indexChoose2][1] then
            l_isCanMake = false
        end
    end

    return l_isCanMake
end

--展示可制作的材料列表
--index 展示类型 0全部 1已解锁 2未解锁
function DisplacerMakeHandler:ShowDisplacerMakeType(index)
    --清除原列表选中项
    if self.curSelectedItem ~= nil then
        self.curSelectedItem:SetSelect(false)
    end
    self.curSelectedItem = nil
    --新列表获取
    local l_showDatas = nil
    if index == 1 then
        --显示已解锁
        l_showDatas = {}
        for i = 1, #l_datas do
            if l_datas[i].isUnlock then
                table.insert(l_showDatas, l_datas[i])
            end
        end
    elseif index == 2 then
        --显示未解锁
        l_showDatas = {}
        for i = 1, #l_datas do
            if not l_datas[i].isUnlock then
                table.insert(l_showDatas, l_datas[i])
            end
        end
    else
        --显示全部
        l_showDatas = l_datas
    end
    --列表展示
    self.displacerMakeTemplatePool:ShowTemplates({ Datas = l_showDatas, Method = function(makeItem)
        self:OnSelectDisplacerMakeItem(makeItem.data)
        -- 如果之前存在选中项则清除原有选中效果
        if self.curSelectedItem ~= nil then
            self.curSelectedItem:SetSelect(false)
        end
        -- 更新当前选中项 且 设置选中效果
        self.curSelectedItem = makeItem
        self.curSelectedItem:SetSelect(true)
    end })
    --详细内容显示默认第一个制造项
    self:OnSelectDisplacerMakeItem(l_showDatas[1])
end

--列表选选中后展示详细内容
function DisplacerMakeHandler:OnSelectDisplacerMakeItem(data)
    l_curSelectData = data
    if l_curSelectData then
        l_curChildItemIndex = data.childItemFirstShowIndex
        --可选材料2 栏位重置
        l_isUseChoosable2 = false
        l_indexChoose2 = 0
        self.materialChoose2:SetGameObjectActive(false)
        self.panel.BtnDeleteChoose2.UObj:SetActiveEx(false)

        self.panel.BtnArrowLeft.UObj:SetActiveEx(true)
        self.panel.BtnArrowRight.UObj:SetActiveEx(true)
        self.panel.IconImg.UObj:SetActiveEx(true)
        self.panel.CostBoxChoose2.UObj:SetActiveEx(false) --【【915版本计划内功能】【置换器】前端-改动需求汇总】 https://www.tapd.cn/20332331/prong/stories/view/1120332331001039744

        self:SetIconAndName()
        self:ShowProperty()
        self:ShowMaterial()
        self:CalculateSuccessRate()

        --判断是否可制造 展示红点
        self.panel.RedPrompt.UObj:SetActiveEx(self:CheckItemCanMake())
    else
        self.panel.IconButton:AddClick(function()
        end)
        self.panel.BtnArrowLeft.UObj:SetActiveEx(false)
        self.panel.BtnArrowRight.UObj:SetActiveEx(false)
        self.panel.IconImg.UObj:SetActiveEx(false)
        self.panel.DisplacerName.LabText = ""
        self.panel.SuccessRateText.LabText = "0%"
        self.displacerPropertyItemPool:ShowTemplates({ Datas = {} })
        self.materialNeedTemplatePool:ShowTemplates({ Datas = {} })
        self.materialChooseTemplatePool:ShowTemplates({ Datas = {} })
        self.panel.CostBoxChoose2.UObj:SetActiveEx(false)
        self.panel.RedPrompt.UObj:SetActiveEx(false)
    end
end

--详细界面切换制造子项
--switchType 0向左(前一个) 1向右(后一个)
function DisplacerMakeHandler:SwitchChildItem(switchType)

    --可选材料2 栏位重置
    l_isUseChoosable2 = false
    l_indexChoose2 = 0
    self.materialChoose2:SetGameObjectActive(false)
    self.panel.BtnDeleteChoose2.UObj:SetActiveEx(false)

    --索引计算
    if switchType == 0 then
        l_curChildItemIndex = l_curChildItemIndex - 1
    else
        l_curChildItemIndex = l_curChildItemIndex + 1
    end
    --出界判断
    local l_childItemCount = l_curSelectData.ChoosableType1.Count
    if l_curChildItemIndex > l_childItemCount - 1 then
        l_curChildItemIndex = 0
    end
    if l_curChildItemIndex < 0 then
        l_curChildItemIndex = l_childItemCount - 1
    end

    self:SetIconAndName()
    self:ShowProperty()
    self:ShowMaterial()
    self:CalculateSuccessRate()

    --判断是否可制造 展示红点
    self.panel.RedPrompt.UObj:SetActiveEx(self:CheckItemCanMake())
end


--设置产物图标和名字  使用额外材料时itemId不同
function DisplacerMakeHandler:SetIconAndName()

    local l_showItemId = l_isUseChoosable2 and l_curSelectData.curItemId2 or l_curSelectData.curItemId
    local l_itemData = TableUtil.GetItemTable().GetRowByItemID(l_showItemId)
    self.panel.IconButton:AddClick(function()
        MgrMgr:GetMgr("ItemTipsMgr").ShowTipsDisplayWithId(l_showItemId, nil, nil, nil, true)
    end)
    self.panel.IconImg:SetSprite(l_itemData.ItemAtlas, l_itemData.ItemIcon, true)
    self.panel.DisplacerName.LabText = l_itemData.ItemName

end

--属性展示
function DisplacerMakeHandler:ShowProperty()

    local l_propertyDatas = {}
    local l_temp = {}
    l_temp.description = TableUtil.GetBuffTable().GetRowById(l_curSelectData.BuffGroup1[l_curChildItemIndex]).Description
    l_temp.isBuff = true
    table.insert(l_propertyDatas, l_temp)

    if l_isUseChoosable2 then
        for i = 0, l_curSelectData.BuffGroup2.Count - 1 do
            l_temp = {}
            l_temp.description = TableUtil.GetBuffTable().GetRowById(l_curSelectData.BuffGroup2[i]).Description
            l_temp.isBuff = true
            table.insert(l_propertyDatas, l_temp)
        end
    else
        l_temp = {}
        l_temp.description = Lang("DIAPLACER_CHOOSE2_PRE_TEXT")
        l_temp.isBuff = false
    end

    self.displacerPropertyItemPool:ShowTemplates({ Datas = l_propertyDatas })
end

--消耗材料展示
function DisplacerMakeHandler:ShowMaterial()
    local l_costDatas = {}
    --基础消耗品添加
    local l_baseCostGroup = l_curSelectData.BaseCost
    for i = 0, l_baseCostGroup.Count - 1 do
        local l_tempData = {}
        l_tempData.ID = l_baseCostGroup[i][0]
        l_tempData.IsShowCount = false
        l_tempData.IsShowRequire = true
        l_tempData.RequireCount = l_baseCostGroup[i][1]
        table.insert(l_costDatas, l_tempData)
    end
    --选择项1消耗品添加
    local l_costGroup_choosable1 = l_curSelectData.ChoosableType1
    local l_tempData = {}
    l_tempData.ID = l_costGroup_choosable1[l_curChildItemIndex][0]
    l_tempData.IsShowCount = false
    l_tempData.IsShowRequire = true
    l_tempData.RequireCount = l_costGroup_choosable1[l_curChildItemIndex][1]
    table.insert(l_costDatas, l_tempData)
    --消耗材料列表显示
    self.materialNeedTemplatePool:ShowTemplates({ Datas = l_costDatas })

    --可选材料2 的选择内容设置
    local l_costDatas2 = {}
    local l_costGroup_choosable2 = l_curSelectData.ChoosableType2
    for i = 0, l_costGroup_choosable2.Count - 1 do
        local l_tempData = {}
        l_tempData.itemId = l_costGroup_choosable2[i][0]
        l_tempData.requireNum = l_costGroup_choosable2[i][1]
        l_tempData.index = i
        table.insert(l_costDatas2, l_tempData)
    end
    --列表展示
    self.materialChooseTemplatePool:ShowTemplates({ Datas = l_costDatas2, Method = function(item)
        self:SelectMaterialChoose2(item.data)
    end })

    --如果材料2已选择 刷新材料2数据
    if l_isUseChoosable2 then
        self.materialChoose2:SetData({
            ID = l_curSelectData.ChoosableType2[l_indexChoose2][0],
            IsShowCount = false,
            IsShowRequire = true,
            RequireCount = l_curSelectData.ChoosableType2[l_indexChoose2][1],
        })
        self.panel.BtnDeleteChoose2.UObj:SetActiveEx(true)
    else
        self.materialChoose2:SetGameObjectActive(false)
        self.panel.BtnDeleteChoose2.UObj:SetActiveEx(false)
    end
end

--可选材料2 选择
function DisplacerMakeHandler:SelectMaterialChoose2(data)

    --可选材料2 展示
    self.materialChoose2:SetData({
        ID = data.itemId,
        IsShowCount = false,
        IsShowRequire = true,
        RequireCount = data.requireNum,
    })
    self.panel.BtnDeleteChoose2.UObj:SetActiveEx(true)
    l_isUseChoosable2 = true
    l_indexChoose2 = data.index

    self.panel.MaterialChoosePanel:SetActiveEx(false)
    self:SetIconAndName()
    self:ShowProperty()
    self:CalculateSuccessRate()

    --判断是否可制造展示红点
    self.panel.RedPrompt.UObj:SetActiveEx(self:CheckItemCanMake())
end

--计算成功率
function DisplacerMakeHandler:CalculateSuccessRate()

    local l_roleInfoMgr = MgrMgr:GetMgr("RoleInfoMgr")
    local l_successRate = 0

    local l_dex = l_roleInfoMgr.GetAttrPointById(l_roleInfoMgr.ATTR_BASIC_DEX)
    l_successRate = l_successRate + l_dex / MGlobalConfig:GetFloat("MakeEnchantDexPara")

    local l_luk = l_roleInfoMgr.GetAttrPointById(l_roleInfoMgr.ATTR_BASIC_LUK)
    l_successRate = l_successRate + l_luk / MGlobalConfig:GetFloat("MakeEnchantLukPara")

    l_successRate = l_successRate + MPlayerInfo.JobLv / MGlobalConfig:GetFloat("MakeEnchantJoblvPara")

    local l_skillLv = MPlayerInfo:GetCurrentSkillInfo(l_curSelectData.UnlockSkillID[0]).lv
    l_successRate = l_successRate + l_skillLv * MGlobalConfig:GetFloat("MakeEnchantSkilllvPara")

    l_successRate = l_successRate + l_curSelectData.ExpandProbability1[l_curChildItemIndex]
    if l_isUseChoosable2 then
        l_successRate = l_successRate + l_curSelectData.ExpandProbability2
    end

    local l_extraSkillIdStr = TableUtil.GetGlobalTable().GetRowByName("MakeEnchantExtraSkillID").Value
    local l_extraSkillIdGroup = string.ro_split(l_extraSkillIdStr, "|")
    for i = 1, #l_extraSkillIdGroup do
        local l_skillData = TableUtil.GetSkillTable().GetRowById(tonumber(l_extraSkillIdGroup[i]))
        local l_skillLv = MPlayerInfo:GetCurrentSkillInfo(tonumber(l_extraSkillIdGroup[i])).lv
        if l_skillLv > 0 then
            local l_effectId = l_skillData.EffectIDs[l_skillLv - 1]
            local l_effectNumStr = TableUtil.GetPassivitySkillEffectTable().GetRowById(l_effectId).ExtraNum
            local l_effectNumDic = string.ro_split(l_effectNumStr, "=")
            l_successRate = l_successRate + tonumber(l_effectNumDic[2]) / 10000
        end
    end

    --成功率有上下限 配置为万分比
    local l_minRate = MGlobalConfig:GetInt("MakeEnchantProLowerLimit") / 100
    local l_maxRate = MGlobalConfig:GetInt("MakeEnchantProUpperLimit") / 100
    l_successRate = math.floor(l_successRate * 10000) / 100
    l_successRate = l_successRate < l_minRate and l_minRate or l_successRate
    l_successRate = l_successRate > l_maxRate and l_maxRate or l_successRate

    self.panel.SuccessRateText.LabText = l_successRate .. "%"
end

--制造按钮点击
function DisplacerMakeHandler:BtnMakeClick()
    if l_curSelectData == nil then
        return
    end
    --判断是否解锁
    if MPlayerInfo:GetCurrentSkillInfo(l_curSelectData.UnlockSkillID[0]).lv < l_curSelectData.UnlockSkillID[1] then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("NOT_UNLOCK"))
        return
    end
    --判断材料是否充足
    for i = 0, l_curSelectData.BaseCost.Count - 1 do
        local l_curNum = Data.BagModel:GetCoinOrPropNumById(l_curSelectData.BaseCost[i][0])
        if l_curNum < l_curSelectData.BaseCost[i][1] then
            MgrMgr:GetMgr("ItemTipsMgr").ShowTipsDisplayWithId(l_curSelectData.BaseCost[i][0], nil, nil, nil, true)
            return
        end
    end

    --如果基础不满足 则不判断选择消耗项
    local l_curNum = Data.BagModel:GetCoinOrPropNumById(l_curSelectData.ChoosableType1[l_curChildItemIndex][0])
    if l_curNum < l_curSelectData.ChoosableType1[l_curChildItemIndex][1] then
        MgrMgr:GetMgr("ItemTipsMgr").ShowTipsDisplayWithId(l_curSelectData.ChoosableType1[l_curChildItemIndex][0], nil, nil, nil, true)
        return
    end

    --如果基础不满足 则不判断选择消耗项
    if l_isUseChoosable2 then
        --如果使用了可选材料2 则检查是否数量足够
        local l_curNum = Data.BagModel:GetCoinOrPropNumById(l_curSelectData.ChoosableType2[l_indexChoose2][0])
        if l_curNum < l_curSelectData.ChoosableType2[l_indexChoose2][1] then
            MgrMgr:GetMgr("ItemTipsMgr").ShowTipsDisplayWithId(l_curSelectData.ChoosableType2[l_indexChoose2][0], nil, nil, nil, true)
            return
        end
    end

    --请求制造
    l_displacerMgr.ReqDisplacerMake(l_curSelectData.ID, l_curChildItemIndex, l_isUseChoosable2)
end
--lua custom scripts end
return DisplacerMakeHandler