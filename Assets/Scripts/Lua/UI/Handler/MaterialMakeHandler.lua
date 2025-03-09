--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseHandler"
require "UI/Panel/MaterialMakePanel"
require "UI/Template/MaterialMakeItemTemplate"
require "UI/Template/ItemTemplate"
require "Data/Model/BagModel"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua fields
local super = UI.UIBaseHandler
--next--
--lua fields end

--lua class define
MaterialMakeHandler = class("MaterialMakeHandler", super)
--lua class define end

local l_makeMgr = nil
local l_datas = nil --可制造的材料总列表
local l_curMakeData = nil --当前那选中的材料制造数据
local l_costState = 0  --背包中制造需要的消耗物品的状态  0 全部都是绑定的 1 全部都是不绑定的 2 绑定和不绑定都有
local l_costItemList = nil  --背包中制造需要的消耗物品的列表

--lua functions
function MaterialMakeHandler:ctor()

    super.ctor(self, HandlerNames.MaterialMake, 0)

end --func end
--next--
function MaterialMakeHandler:Init()

    self.panel = UI.MaterialMakePanel.Bind(self)
    super.Init(self)

    l_makeMgr = MgrMgr:GetMgr("MaterialMakeMgr")

    --材料制作选项池
    self.materialMakeTemplatePool = self:NewTemplatePool({
        UITemplateClass = UITemplate.MaterialMakeItemTemplate,
        TemplatePrefab = self.panel.MaterialMakeItemPrefab.Prefab.gameObject,
        ScrollRect = self.panel.ItemScroll.LoopScroll
    })
    --制造所需材料池
    self.materialNeedTemplatePool = self:NewTemplatePool({
        UITemplateClass = UITemplate.ItemTemplate,
        TemplateParent = self.panel.CostContent.transform
    })
    --下拉筛选框选择事件
    local l_selectType = { Lang("AllText"), Lang("UNLOCKED"), Lang("LOCKED") }
    self.panel.SelectDrop.DropDown:ClearOptions()
    self.panel.SelectDrop:SetDropdownOptions(l_selectType)
    self.panel.SelectDrop.DropDown.onValueChanged:AddListener(function(index)
        self:ShowMaterialMakeType(index)
    end)
    --制造按钮点击事件
    self.panel.BtnMake:AddClick(function()
        self:BtnMakeClick()
    end)

end --func end
--next--
function MaterialMakeHandler:Uninit()

    self.materialMakeTemplatePool = nil
    self.materialNeedTemplatePool = nil
    l_makeMgr = nil

    super.Uninit(self)
    self.panel = nil

end --func end
--next--
function MaterialMakeHandler:OnActive()

    --总数据获取
    l_datas = TableUtil.GetMerchantMakeMaterialsTable().GetTable()
    --初始展示全部可制造列表内容
    self:ShowMaterialMakeType(0)
    --特效加载
    if not self._equipElevateEffect then
        local l_fxData = {}
        l_fxData.parent = self.panel.EffectParent.Transform
        l_fxData.scaleFac = Vector3.New(0.75, 0.75, 1)
        self._equipElevateEffect = self:CreateEffect("UI/Prefabs/EquipElevateEffect", l_fxData)
    end

end --func end

function MaterialMakeHandler:_onHandlerSwitch()
    self.panel.SelectDrop.DropDown:Hide()
end

--next--
function MaterialMakeHandler:OnDeActive()

    --清除原列表选中项
    if self.curSelectedItem ~= nil then
        self.curSelectedItem:SetSelect(false)
    end
    self.curSelectedItem = nil
    l_curMakeData = nil
    l_costItemList = nil
    --特效关闭
    if self._equipElevateEffect then
        self:DestroyUIEffect(self._equipElevateEffect)
        self._equipElevateEffect = nil
    end
    --数据清理
    l_datas = nil

end --func end
--next--
function MaterialMakeHandler:Update()

end --func end

--next--
function MaterialMakeHandler:BindEvents()
    local gameEventMgr = MgrMgr:GetMgr("GameEventMgr")
    self:BindEvent(gameEventMgr.l_eventDispatcher, gameEventMgr.OnCompoundHandlerSwitch, self._onHandlerSwitch)
    --制造成功返回
    self:BindEvent(l_makeMgr.EventDispatcher, l_makeMgr.ON_MATERIAL_MAKE_SUCCESS, function(self)
        self:OnSelectMaterialMakeItem(l_curMakeData)
        self.materialMakeTemplatePool:RefreshCells()
        self.panel.SucceedEffect.UObj:SetActiveEx(false)
        self.panel.SucceedEffect.UObj:SetActiveEx(true)
    end)

end --func end
--next--
function MaterialMakeHandler:OnShow()

    --进入商会买材料回来时刷新
    self:OnSelectMaterialMakeItem(l_curMakeData)
    self.materialMakeTemplatePool:RefreshCells()

end --func end

--next--
--lua functions end

--lua custom scripts
--展示可制作的材料列表
--index 展示类型 0全部 1已解锁 2未解锁
function MaterialMakeHandler:ShowMaterialMakeType(index)
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
            if l_makeMgr.CheckIsUnlock(l_datas[i].Unlock) then
                table.insert(l_showDatas, l_datas[i])
            end
        end
    elseif index == 2 then
        --显示未解锁
        l_showDatas = {}
        for i = 1, #l_datas do
            if not l_makeMgr.CheckIsUnlock(l_datas[i].Unlock) then
                table.insert(l_showDatas, l_datas[i])
            end
        end
    else
        --显示全部
        l_showDatas = l_datas
    end
    --列表展示
    self.materialMakeTemplatePool:ShowTemplates({ Datas = l_showDatas, Method = function(makeItem)
        self:OnSelectMaterialMakeItem(makeItem.data)
        -- 如果之前存在选中项则清除原有选中效果
        if self.curSelectedItem ~= nil then
            self.curSelectedItem:SetSelect(false)
        end
        -- 更新当前选中项 且 设置选中效果
        self.curSelectedItem = makeItem
        self.curSelectedItem:SetSelect(true)
    end })
    --详细内容显示默认第一个制造项
    self:OnSelectMaterialMakeItem(l_showDatas[1])
end

--点击左侧制造列表项事件
function MaterialMakeHandler:OnSelectMaterialMakeItem(data)

    l_curMakeData = data
    if l_curMakeData then
        local l_itemData = TableUtil.GetItemTable().GetRowByItemID(l_curMakeData.ID)

        self.panel.IconButton:AddClick(function()
            MgrMgr:GetMgr("ItemTipsMgr").ShowTipsDisplayWithId(l_curMakeData.ID, nil, nil, nil, true)
        end)
        self.panel.AimStuffIcon.UObj:SetActiveEx(true)
        self.panel.AimStuffIcon:SetSprite(l_itemData.ItemAtlas, l_itemData.ItemIcon)
        self.panel.AimStuffName.LabText = l_itemData.ItemName

        --概率计算
        local l_probability = l_curMakeData.BaseProbability
        local l_skillId = l_curMakeData.Unlock[0]
        local l_skillData = TableUtil.GetSkillTable().GetRowById(l_skillId)
        local l_skillLv = MPlayerInfo:GetCurrentSkillInfo(l_skillId).lv
        if l_skillLv > 0 then
            local l_effectId = l_skillData.EffectIDs[l_skillLv - 1]
            local l_effectNumStr = TableUtil.GetPassivitySkillEffectTable().GetRowById(l_effectId).ExtraNum
            local l_effectNumDic = string.ro_split(l_effectNumStr, "=")
            l_probability = l_probability + tonumber(l_effectNumDic[2])
        end
        self.panel.ProbabilityNum.LabText = tostring(l_probability / 100) .. "%"

        --消耗材料展示
        self.materialNeedTemplatePool:ShowTemplates({ Datas = self:GetCostMaterialDatas(1) })

        --是否使用绑定物品的Toggle 当同时含有绑定和未绑定物时才显示
        l_costState, l_costItemList = self:CheckCostMaterialBindState()
        self.panel.TogIsBindFirst.UObj:SetActiveEx(l_costState == 2)
        self.panel.TogIsBindFirst.Tog.isOn = false

        --数量输入框
        local l_inpuntNumber = self.panel.InputCount.InputNumber
        l_inpuntNumber.OnValueChange = (function(value)
            self.materialNeedTemplatePool:ShowTemplates({ Datas = self:GetCostMaterialDatas(value) })
            self.panel.RedPrompt.UObj:SetActiveEx(l_makeMgr.CheckCanMake(l_curMakeData.Cost, value))
        end)
        l_inpuntNumber.MaxValue = self:GetMaxCanMakeNum()
        l_inpuntNumber.MinValue = 1
        l_inpuntNumber:SetValue(1)

        --制造按钮的红点显示控制  可制造的时候显示 不可时不显示
        self.panel.RedPrompt.UObj:SetActiveEx(l_makeMgr.CheckCanMake(l_curMakeData.Cost, 1))
    else
        self.panel.IconButton:AddClick(function()
        end)
        self.panel.AimStuffIcon.UObj:SetActiveEx(false)
        self.panel.AimStuffName.LabText = ""
        self.panel.ProbabilityNum.LabText = "0%"
        self.materialNeedTemplatePool:ShowTemplates({ Datas = {} })
        self.panel.TogIsBindFirst.UObj:SetActiveEx(false)
        local l_inpuntNumber = self.panel.InputCount.InputNumber
        l_inpuntNumber.OnValueChange = (function(value)
        end)
        l_inpuntNumber.MaxValue = 0
        l_inpuntNumber.MinValue = 0
        l_inpuntNumber:SetValue(0)
        self.panel.RedPrompt.UObj:SetActiveEx(false)
    end
end

--制造按钮点击
function MaterialMakeHandler:BtnMakeClick()

    --判断是否有选中内容
    if l_curMakeData == nil then
        return
    end

    --判断是否解锁
    if not l_makeMgr.CheckIsUnlock(l_curMakeData.Unlock) then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("NOT_UNLOCK"))
        return
    end

    --判断材料是否足够
    local l_makeNum = self.panel.InputCount.InputNumber:GetValue()
    local l_costGroup = l_curMakeData.Cost
    for i = 0, l_costGroup.Count - 1 do
        local l_costId = l_costGroup:get_Item(i, 0)
        local l_curNum = Data.BagModel:GetCoinOrPropNumById(l_costId)
        if l_curNum < l_costGroup:get_Item(i, 1) * l_makeNum then
            MgrMgr:GetMgr("ItemTipsMgr").ShowTipsDisplayWithId(l_costId, nil, nil, nil, true)
            return
        end
    end

    --判断是否会同时使用绑定和非绑定材料
    local l_isBindFirst = self.panel.TogIsBindFirst.Tog.isOn
    for i = 0, l_costGroup.Count - 1 do
        local l_costId = l_costGroup[i][0]
        local l_costNum = l_costGroup[i][1] * l_makeNum
        for i = 1, #l_costItemList do
            local l_tempCostData = l_costItemList[i]
            if l_tempCostData.id == l_costId then
                if (l_isBindFirst and l_tempCostData.is_bind) or (not l_isBindFirst and not l_tempCostData.is_bind) then
                    if MLuaCommonHelper.Long(l_tempCostData.num) < MLuaCommonHelper.Long(l_costNum) then
                        CommonUI.Dialog.ShowYesNoDlg(true, nil, Lang("MATERIAL_MAKE_CHECK_BIND"), function()
                            l_makeMgr.ReqMakeMaterial(l_curMakeData.ID, l_makeNum, l_isBindFirst)
                        end, nil, nil, 2, "MaterialMakeCheckBind", nil)
                        return
                    end
                    break
                end
            end
        end
    end

    --请求服务器制造
    l_makeMgr.ReqMakeMaterial(l_curMakeData.ID, l_makeNum, l_isBindFirst)
end

--获取消耗材料数据表
--makeNum 制作数量
function MaterialMakeHandler:GetCostMaterialDatas(MakeNum)
    local l_materialNeedDatas = {}
    local l_costGroup = l_curMakeData.Cost
    for i = 0, l_costGroup.Count - 1 do
        local l_tempData = {}
        l_tempData.ID = l_costGroup:get_Item(i, 0)
        l_tempData.IsShowCount = false
        l_tempData.IsShowRequire = true
        l_tempData.RequireCount = l_costGroup:get_Item(i, 1) * MakeNum
        table.insert(l_materialNeedDatas, l_tempData)
    end
    return l_materialNeedDatas
end

--确认制造所需材料的绑定状态
--返回值 0 全部都是绑定的 1 全部都是不绑定的 2 绑定和不绑定都有
function MaterialMakeHandler:CheckCostMaterialBindState()
    --消耗物品数据初始化
    local l_resultArg = {}
    for i = 0, l_curMakeData.Cost.Count - 1 do
        l_resultArg[l_curMakeData.Cost:get_Item(i, 0)] = 1
    end
    local l_bagItems = Data.BagModel:getPropList(l_resultArg)
    local l_allBind = true
    local l_allNoBind = true
    for i = 1, #l_bagItems do
        if l_bagItems[i].is_bind then
            l_allNoBind = false
        else
            l_allBind = false
        end
    end
    --返回绑定状况
    if l_allBind then
        return 0, l_bagItems
    elseif l_allNoBind then
        return 1, l_bagItems
    else
        return 2, l_bagItems
    end
end

--获取最大可制造数量
function MaterialMakeHandler:GetMaxCanMakeNum()
    local l_maxValue = MGlobalConfig:GetInt("OnceMakeMaterialsNumber")
    local l_costGroup = l_curMakeData.Cost
    for i = 0, l_costGroup.Count - 1 do
        local l_curNum = Data.BagModel:GetCoinOrPropNumById(l_costGroup:get_Item(i, 0))
        local l_onceCostNum = MLuaCommonHelper.Long(l_costGroup:get_Item(i, 1))
        local l_canMakeNum = math.floor(l_curNum / l_onceCostNum)  --这里long类型的0 tonumber会变成nil
        l_maxValue = l_canMakeNum < l_maxValue and l_canMakeNum or l_maxValue
    end

    return l_maxValue > 1 and l_maxValue or 1
end
--lua custom scripts end
return MaterialMakeHandler