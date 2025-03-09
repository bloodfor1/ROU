--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/RefitshopPanel"
require "UI/Template/RefitTrolleyItemTemplate"
require "Data/Model/BagModel"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua class define
local super = UI.UIBaseCtrl
RefitshopCtrl = class("RefitshopCtrl", super)
--lua class define end

--lua functions
function RefitshopCtrl:ctor()

    super.ctor(self, CtrlNames.Refitshop, UILayer.Function, nil, ActiveType.Exclusive)

end --func end
--next--
function RefitshopCtrl:Init()

    self.panel = UI.RefitshopPanel.Bind(self)
    super.Init(self)

    self.refitMgr = MgrMgr:GetMgr("RefitTrolleyMgr")

    self.itemDatas = nil        -- 特殊装备数据列表
    self.selectItemData = nil   -- 当前选中的特殊装备数据
    self.itemModel = nil        -- 特殊装备模型
    self.curEquipData = nil     -- 当前装备的特殊装备数据

    --商店类型信息获取
    self.shopTypeInfo = self.refitMgr.GetRefitShopTypeInfo()
    --商店名字设置
    self.panel.ShopTitle.LabText = self.shopTypeInfo.shopName
    --租赁相关数据设置
    self:SetRentState()
    
    --选择列表项的池创建
    self.trolleyTemplatePool = self:NewTemplatePool({
        UITemplateClass = UITemplate.RefitTrolleyItemTemplate,
        TemplatePrefab = self.panel.RefitTrolleyItemPrefab.Prefab.gameObject,
        ScrollRect = self.panel.ScrollView.LoopScroll
    })

    --初始化选择列表
    self:InitSelectListShow()

    --按钮点击事件绑定
    self:ButtonClickEventAdd()

end --func end
--next--
function RefitshopCtrl:Uninit()

    --手推车模型销毁
    if self.itemModel ~= nil then
        self:DestroyUIModel(self.itemModel)
        self.itemModel = nil
    end

    if self.tween then
        self.tween:Kill()
        self.tween = nil
    end

    self.curSelectedItem = nil
    self.curEquipData = nil

    MSceneWallTriggerMgr:SetTriggerEnableMask(TriggerHudEnableEnum.NPC_TALK, true)
    MPlayerInfo:FocusToMyPlayer()

    self.trolleyTemplatePool = nil

    self.curEquipData = nil
    self.selectItemData = nil
    self.itemDatas = nil
    self.refitMgr = nil

    super.Uninit(self)
    self.panel = nil

end --func end
--next--
function RefitshopCtrl:OnActive()

    MSceneWallTriggerMgr:SetTriggerEnableMask(TriggerHudEnableEnum.NPC_TALK, false)
    if l_npcId then
        self:FocusToNpc()
    end

end --func end
--next--
function RefitshopCtrl:OnDeActive()


end --func end
--next--
function RefitshopCtrl:Update()


end --func end

--next--
function RefitshopCtrl:BindEvents()
    
    --背包数据（装备情况）更新事件注册
    self:BindEvent(MgrMgr:GetMgr("GameEventMgr").l_eventDispatcher, MgrMgr:GetMgr("GameEventMgr").OnBagUpdate, function ()
        self:SetRentState()
        --更新列表
        if not self.itemDatas then return end
        for i = 1, #self.itemDatas do
            local l_temp = self.itemDatas[i]
            l_temp.isUsing = self.curEquipData and self.curEquipData.TID == l_temp.configData.CartID or false
        end
        self.trolleyTemplatePool:RefreshCells()
    end)

end --func end
--next--
--lua functions end

--lua custom scripts
--设置NPC的ID
function RefitshopCtrl:SetNpc(npcId)
    l_npcId = npcId
end

--NPC模型展示
function RefitshopCtrl:FocusToNpc()

    if not l_npcId then
        return
    end

    local l_npc_entity = MNpcMgr:FindNpcInViewport(l_npcId)
    if l_npc_entity then
        local l_right_vec = l_npc_entity.Model.Rotation * Vector3.right
        local l_temp2 = -0.8
        MPlayerInfo:FocusToOrnamentBarter(l_npcId, l_right_vec.x * l_temp2, 1, l_right_vec.z * l_temp2, 4, 10, 5)
    else
        logError(StringEx.Format("找不到场景中的npc npc_id:{0}", l_npcId))
        return
    end

    if MEntityMgr.PlayerEntity ~= nil then
        MEntityMgr.PlayerEntity.Target = nil
    end
end

--按钮点击事件绑定
function RefitshopCtrl:ButtonClickEventAdd()
    --关闭按钮事件绑定
    self.panel.BtnClose:AddClick(function()
        UIMgr:DeActiveUI(UI.CtrlNames.Refitshop)
    end)
    --右箭头按钮
    self.panel.BtnArrowRight:AddClick(function()
        -- body
    end)
    --左箭头按钮
    self.panel.BtnArrowLeft:AddClick(function()
        -- body
    end)
    --租赁/取消租赁 按钮
    self.panel.BtnRent:AddClick(function()
        if self.curEquipData then
            --租赁中则去除原有的装备
            self.refitMgr.ReqUseTrolley(0, MPlayerInfo.ProfessionId)
        else
            --非租赁中则请求装备
            if not self.selectItemData then return end
            if self.selectItemData.isUnlocked then
                --如果当前选中的是已解锁的 直接请求租赁
                self.refitMgr.ReqUseTrolley(self.selectItemData.configData.CartID, self.selectItemData.configData.ProfessionID)
            else
                --如果选中的是未解锁的 遍历获取第一个解锁的租赁
                if not self.itemDatas then return end
                for i = 1, #self.itemDatas do
                    if self.itemDatas[i].isUnlocked then
                        self.refitMgr.ReqUseTrolley(self.itemDatas[i].configData.CartID, self.itemDatas[i].configData.ProfessionID)
                        return
                    end
                end
            end
        end
    end)
end

--设置租赁相关状态
function RefitshopCtrl:SetRentState()
    --获取当前装备的特殊装备数据 
    self.curEquipData = Data.BagApi:GetItemByTypeSlot(GameEnum.EBagContainerType.Equip, self.shopTypeInfo.equipPos)
    --是否租赁中
    self.panel.IsUsing.UObj:SetActiveEx(self.curEquipData ~= nil)
    --租赁/取消租赁按钮文字显示
    self.panel.BtnRentText.LabText = self.curEquipData and Lang("CANCEL_RENT") or Lang("RENT")
end

--初始化手推车、战斗坐骑、战斗宠物选择列表
function RefitshopCtrl:InitSelectListShow()
    --手推车数据列表获取选项显示
    local l_rows = TableUtil.GetCartRemouldTable().GetTable()
    self.itemDatas = {}
    for i = 1, #l_rows do
        local l_temp = {}
        l_temp.configData = l_rows[i]
        --判断是否是自己职业可使用的类型
        if self:CheckProfession(l_temp.configData.ProfessionID) then
            --是否解锁判断 技能等级解锁在大嘴鸟商店不判断 20200429  cmd
            -- l_temp.isCondition01Check = true
            -- for i = 0, l_temp.configData.UnlockSkillID.Count - 1 do
            --     if MPlayerInfo:GetCurrentSkillInfo(l_temp.configData.UnlockSkillID[i][0]).lv < l_temp.configData.UnlockSkillID[i][1] then
            --         l_temp.isCondition01Check = false
            --         break
            --     end
            -- end
            l_temp.isCondition02Check = l_temp.configData.UnlockBaseLv == 0 or MPlayerInfo.Lv >= l_temp.configData.UnlockBaseLv

            --l_temp.isUnlocked = l_temp.isCondition01Check and l_temp.isCondition02Check  --技能等级解锁在大嘴鸟商店不判断 20200429  cmd

            l_temp.isUnlocked = l_temp.isCondition02Check
            l_temp.isUsing = self.curEquipData and self.curEquipData.TID == l_temp.configData.CartID or false

            table.insert(self.itemDatas, l_temp)
            l_temp.index = #self.itemDatas
        end

    end
    --展示手推车选择列表
    self.trolleyTemplatePool:ShowTemplates({ Datas = self.itemDatas, Method = function(item)
        self:OnSelectTrolley(item.data)
        -- 如果之前存在选中项则清除原有选中效果
        if self.curSelectedItem ~= nil then
            self.curSelectedItem:SetSelect(false)
        end
        -- 更新当前选中项 且 设置选中效果
        self.curSelectedItem = item
        self.curSelectedItem:SetSelect(true)
        --滑动到点中的项
        self.trolleyTemplatePool:ScrollToCell(item.data.index, 2000)
    end })
    --显示列表第一个手推车的数据
    if #self.itemDatas > 0 then
        self:OnSelectTrolley(self.itemDatas[1])
    end
end

--确认职业
function RefitshopCtrl:CheckProfession(professionId)
    for i = 0, MPlayerInfo.ProfessionIdList.Count - 1 do
        if MPlayerInfo.ProfessionIdList[i] == professionId then
            return true
        end
    end
    return false
end

--选中手推车事件
function RefitshopCtrl:OnSelectTrolley(data)
    --记录当前选中的数据
    self.selectItemData = data  
    --获取装备表数据
    local l_equipData = TableUtil.GetEquipTable().GetRowById(data.configData.CartID)
    self.panel.TrolleyName.LabText = l_equipData and l_equipData.Name or ""
    --介绍面板的文字
    self.panel.Introduction.LabText = data.configData.Desc
    --解锁条件面板的显示
    self.panel.UnlockPanel.UObj:SetActiveEx(not data.isUnlocked)
    if not data.isUnlocked then
        self:UnlockConditionShow(data.configData)
    end
    --模型加载
    self:ModelShow(l_equipData.Model)

end

--解锁条件显示
function RefitshopCtrl:UnlockConditionShow(configData)
    --条件1 configData.UnlockSkillID  技能等级解锁在大嘴鸟商店不判断 20200429  cmd
    -- local l_condition01Str = ""
    -- for i = 0, configData.UnlockSkillID.Count - 1 do
    --     if i > 0 then
    --         l_condition01Str = l_condition01Str .. " "
    --     end
    --     local l_limitSkillId = configData.UnlockSkillID[i][0]
    --     local l_skillLv = MPlayerInfo:GetCurrentSkillInfo(l_limitSkillId).lv
    --     local l_skillConfig = TableUtil.GetSkillTable().GetRowById(l_limitSkillId)
    --     local l_skillName = l_skillConfig and l_skillConfig.Name or ""

    --     local l_limitSkillLv = configData.UnlockSkillID[i][1]
    --     local l_limitStr = StringEx.Format(Lang("TROLLEY_REFIT_SKILL_LIMIT"), l_skillName, l_limitSkillLv)

    --     local l_condition01Color = l_skillLv >= l_limitSkillLv and RoColorTag.None or RoColorTag.Gray
    --     l_condition01Str = l_condition01Str .. GetColorText(l_limitStr, l_condition01Color)
    -- end
    -- self.panel.Condition01.LabText = l_condition01Str
    self.panel.Condition01.UObj:SetActiveEx(false)

    --条件2 configData.UnlockBaseLv
    if configData.UnlockBaseLv == 0 then
        self.panel.Condition02.UObj:SetActiveEx(false)
    else
        self.panel.Condition02.UObj:SetActiveEx(true)
        local l_condition02Str = StringEx.Format(Lang("BASE_LEVEL_LIMIT2"), configData.UnlockBaseLv)
        local l_condition02Color = MPlayerInfo.Lv >= configData.UnlockBaseLv and RoColorTag.None or RoColorTag.Gray
        self.panel.Condition02.LabText = GetColorText(l_condition02Str, l_condition02Color)
    end
end

--模型加载展示
function RefitshopCtrl:ModelShow(path)

    --原模型清理
    if self.itemModel ~= nil then
        self:DestroyUIModel(self.itemModel)
        self.itemModel = nil
    end

    if self.tween then
        self.tween:Kill()
        self.tween = nil
    end

    --加载手推车模型
    local l_attr = nil
    if self.selectItemData.configData.EntityID ~= 0 then
        local l_tempId = MUIModelManagerEx:GetTempUID()
        l_attr = MAttrMgr:InitMonsterAttr(l_tempId, "petShow", self.selectItemData.configData.EntityID)
    end

    local l_fxData = {}
    l_fxData.rawImage = self.panel.ModelImg.RawImg
    l_fxData.prefabPath = "Prefabs/" .. path
    if l_attr then
        l_fxData.attr = l_attr
        l_fxData.defaultAnim = l_attr.CommonIdleAnimPath
    end

    self.panel.ModelImg.UObj:SetActiveEx(false)
    self.itemModel = self:CreateUIModel(l_fxData)
    self.itemModel:AddLoadModelCallback(function(m)
        self.panel.ModelImg.gameObject:SetActiveEx(true)
        self.itemModel.Trans:SetPos(0, 0.4, 0)
        self.tween = self.itemModel.Trans:DOLocalRotate(Vector3.New(self.itemModel.Trans.localEulerAngles.x, 360, 0), 4)
        self.tween:SetLoops(-1, DG.Tweening.LoopType.Incremental)
        self.tween:SetEase(DG.Tweening.Ease.Linear)
    end)
    
end

--lua custom scripts end
