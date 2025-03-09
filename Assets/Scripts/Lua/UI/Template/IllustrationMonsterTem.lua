--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/BaseUITemplate"
require "UI/Template/ItemTemplate"
require "UI/Template/MonsterLimitImageTemplate"
require "UI/Template/IllustrationMonsterListTemplate"
require "UI/Panel/IllustrationMonsterPanel"
--lua requires end

--lua model
module("UITemplate", package.seeall)
--lua model end

--lua fields
local super = UITemplate.BaseUITemplate
--lua fields end

--lua class define
---@class IllustrationMonsterTemParameter.MonsterLimitImageTemplate
---@field PanelRef MoonClient.MLuaUIPanel
---@field MonsterLimitText MoonClient.MLuaUICom

---@class IllustrationMonsterTemParameter.IllustrationMonsterListPrefab
---@field PanelRef MoonClient.MLuaUIPanel
---@field MonsterFivePrefab MoonClient.MLuaUICom

---@class IllustrationMonsterTemParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field Text_Level MoonClient.MLuaUICom
---@field Shuxing MoonClient.MLuaUICom
---@field ScrollMonster MoonClient.MLuaUICom
---@field QuestionBtn MoonClient.MLuaUICom
---@field MonsterVitText MoonClient.MLuaUICom
---@field MonsterTypeShapeText MoonClient.MLuaUICom
---@field MonsterTypeShape MoonClient.MLuaUICom
---@field MonsterTypeSelectText MoonClient.MLuaUICom
---@field MonsterTypeSelectButton MoonClient.MLuaUICom
---@field MonsterTypeRaceText MoonClient.MLuaUICom
---@field MonsterTypeRace MoonClient.MLuaUICom
---@field MonsterTypeAttrText MoonClient.MLuaUICom
---@field MonsterTypeAttr MoonClient.MLuaUICom
---@field MonsterType MoonClient.MLuaUICom
---@field MonsterTogDetail3 MoonClient.MLuaUICom
---@field MonsterTogDetail2 MoonClient.MLuaUICom
---@field MonsterTogDetail1 MoonClient.MLuaUICom
---@field MonsterStrText MoonClient.MLuaUICom
---@field MonsterSearchInputField MoonClient.MLuaUICom
---@field MonsterNotKillText MoonClient.MLuaUICom
---@field MonsterNotFoundText MoonClient.MLuaUICom
---@field MonsterName MoonClient.MLuaUICom
---@field MonsterMod MoonClient.MLuaUICom
---@field MonsterMDefNumText MoonClient.MLuaUICom
---@field MonsterMAtkNumText MoonClient.MLuaUICom
---@field MonsterLukText MoonClient.MLuaUICom
---@field MonsterLootContent MoonClient.MLuaUICom
---@field MonsterLiuweitu MoonClient.MLuaUICom
---@field MonsterLiubianxing MoonClient.MLuaUICom
---@field MonsterIntText MoonClient.MLuaUICom
---@field MonsterInfoPanel MoonClient.MLuaUICom
---@field MonsterInfoMap MoonClient.MLuaUICom
---@field MonsterHpNumText MoonClient.MLuaUICom
---@field MonsterHitNumText MoonClient.MLuaUICom
---@field MonsterFleeNumText MoonClient.MLuaUICom
---@field MonsterDexText MoonClient.MLuaUICom
---@field MonsterDetailInfor3 MoonClient.MLuaUICom
---@field MonsterDetailInfor2 MoonClient.MLuaUICom
---@field MonsterDetailInfor1 MoonClient.MLuaUICom
---@field MonsterDefNumText MoonClient.MLuaUICom
---@field MonsterCardButton MoonClient.MLuaUICom
---@field MonsterAtkNumText MoonClient.MLuaUICom
---@field MonsterAgiText MoonClient.MLuaUICom
---@field lvNum MoonClient.MLuaUICom
---@field IllustrationMonster MoonClient.MLuaUICom
---@field DropNum MoonClient.MLuaUICom
---@field CloseBtn MoonClient.MLuaUICom
---@field Btn_xiangxi MoonClient.MLuaUICom
---@field Btn_liuwei MoonClient.MLuaUICom
---@field Btn_Details MoonClient.MLuaUICom
---@field MonsterLimitImageTemplate IllustrationMonsterTemParameter.MonsterLimitImageTemplate
---@field IllustrationMonsterListPrefab IllustrationMonsterTemParameter.IllustrationMonsterListPrefab

---@class IllustrationMonsterTem : BaseUITemplate
---@field Parameter IllustrationMonsterTemParameter

IllustrationMonsterTem = class("IllustrationMonsterTem", super)
--lua class define end

--lua functions
function IllustrationMonsterTem:Init()
    super.Init(self)
    self.mgr = MgrMgr:GetMgr("IllustrationMonsterMgr")
    self.data = DataMgr:GetData("IllustrationMonsterData")
    self.awardMgr = MgrMgr:GetMgr("AwardPreviewMgr")
    self:_inIt()
    self.Parameter.Btn_liuwei:AddClick(function()
        self:RefreshBtn(false)
    end)
    self.Parameter.Btn_xiangxi:AddClick(function()
        self:RefreshBtn(true)
    end)
    self:ResetData()
end --func end
--next--
function IllustrationMonsterTem:BindEvents()
    --获取魔物掉落奖励数据
    self:BindEvent(self.awardMgr.EventDispatcher, self.awardMgr.AWARD_PREWARD_MSG, self.OnRefreshAward)
    --点击魔物
    self:BindEvent(self.mgr.EventDispatcher, self.data.ILLUSTRATION_SELECT_MONSTER, self.OnSelectMonster)
    --解锁魔物
    self:BindEvent(self.mgr.EventDispatcher, self.data.ILLUSTRATION_UNLOCK_MONSTER, self.UnlockMonster)
end --func end
--next--
function IllustrationMonsterTem:OnDestroy()

    self:DestroyMonster3DModel()
    self.monsterLootTemplatePool = nil
    self.monsterListTemplatePool = nil
    self.cacheAwards = {}
    for i = 1, 3 do
        self.Parameter["MonsterDetailInfor" .. i]:SetActiveEx(false)
        local togEx = self.Parameter["MonsterTogDetail" .. i].TogEx
        togEx.onValueChanged:RemoveAllListeners()
    end
end --func end
--next--
function IllustrationMonsterTem:OnDeActive()

end --func end
--next--
function IllustrationMonsterTem:OnSetData()
    self.Parameter.MonsterLimitImageTemplate.LuaUIGroup.gameObject:SetActiveEx(false)
    self.Parameter.IllustrationMonsterListPrefab.LuaUIGroup.gameObject:SetActiveEx(false)
    self.Parameter.MonsterSearchInputField.Input.text = ""
    self:OnSelectType("1")
    self:RefreshBtn(true)
    self.Parameter.MonsterTogDetail1.TogEx.isOn = true
end --func end
--next--
--lua functions end

--lua custom scripts
--详细数据枚举
local MONSTER_DETAIL_TYPE = {
    Texing = 1, --特性
    Loot = 2, --掉落
    Map = 3, --地图
}
--详细数据显示页 默认显示特性
local monsterDetailInfoType = MONSTER_DETAIL_TYPE.Texing
--当前显示的魔物的信息
local currentMonsterInfo
--当前魔物MVP数据
local currentMonsterMvpInfo
--魔物对应卡片ID
local currentMonsterCardId
--当前魔物掉落奖励表
local currentMonsterAwardTable
--请求的奖励Id
local currentRequestAwardId

function IllustrationMonsterTem:_inIt()
    -- self.mgr.InitMonsterHandBook()

    self.cacheAwards = {}
    self.monsterLootSizeFitter = self.Parameter.MonsterLootContent.Fitter

    --怪物
    self.monsterListTemplatePool = self:NewTemplatePool({
        ScrollRect = self.Parameter.ScrollMonster.LoopScroll,
        PreloadPaths = {},
        GetTemplateAndPrefabMethod = function(data)
            return self:GetTemplate(data)
        end,
        SetCountPerFrame = 1,
        CreateObjPerFrame = 1,
    })

    --掉落物
    self.monsterLootTemplatePool = self:NewTemplatePool({
        UITemplateClass = UITemplate.ItemTemplate,
        TemplateParent = self.Parameter.MonsterLootContent.transform,
        SetCountPerFrame = 1,
        CreateObjPerFrame = 1,
    })

    self:ChooseMonsterDetailInfo()
    --搜索按钮
    self.Parameter.MonsterSearchInputField:OnInputFieldChange(function(value)
        local searchStr = StringEx.DeleteEmoji(value)
        self.Parameter.MonsterSearchInputField.Input.text = searchStr
        self.Parameter.MonsterTypeSelectText.LabText = Common.Utils.Lang("ILLUSTRATION_DROPDOWN_MAIN")
        --重新定位选中位置
        self.data.SetMonsterListTemplateIndex(2)
        self.data.SetMonsterCellTemplateIndex(1)
        --创建魔物列表
        self:CreateShowMonsterScroll(self.data.GetTypeShowMonster(1, searchStr))
    end)

    --处理魔物类型二级菜单
    local moreDropdown = self.Parameter.MonsterTypeSelectButton:GetComponent("MoreDropdown")
    moreDropdown.onCreateDropdown = function()
        moreDropdown.SetAllInfo(self.data.GetDropdownMonsterStrList())
    end

    moreDropdown.onClickItem = function(str, orderStr)
        self:OnSelectType(orderStr)
    end

    --查看魔物卡片信息
    self.Parameter.MonsterCardButton:AddClick(function()
        MgrMgr:GetMgr("IllustrationMgr").SetCheckMonsterCardId(currentMonsterCardId)
        UIMgr:ActiveUI(UI.CtrlNames.IllustrationCard)
    end)

    --拖动监听
    self:AddMonsterDragListener(self.Parameter.MonsterMod.gameObject)

    --关闭按钮
    self.Parameter.CloseBtn:AddClick(function()
        UIMgr:DeActiveUI(self.name)
    end)

    self.Parameter.QuestionBtn:AddClick(function()
        UIMgr:ActiveUI(UI.CtrlNames.IllustrationMonsterTips)
    end)
    self.Parameter.Btn_Details:AddClick(function()
        local monsterData = self.data.GetMonsterRewardBookDataByID(currentMonsterInfo.Id)
        if monsterData ~= nil then
            self.MethodCallback(monsterData)
        end
    end)
end

--- 上层ctrl调用的update，因为这里实际上是一个handler，但是做法上是template，所以需要手动调用update
function IllustrationMonsterTem:OnCtrlUpdate()
    if nil ~= self.monsterListTemplatePool then
        self.monsterListTemplatePool:OnUpdate()
    end

    if nil ~= self.monsterLootTemplatePool then
        self.monsterLootTemplatePool:OnUpdate()
    end
end

function IllustrationMonsterTem:ShowMVP(...)
    self:OnSelectType("5|2")
end

function IllustrationMonsterTem:OnSelectType(arg)
    self.Parameter.MonsterSearchInputField.Input.text = ""
    self.Parameter.MonsterTypeSelectText.LabText = self.data.CreateDropdownShowStr(arg)
    --重新定位选中位置
    self.data.SetMonsterListTemplateIndex(2)
    self.data.SetMonsterCellTemplateIndex(1)
    --创建魔物列表
    self:CreateShowMonsterScroll(self.data.GetTypeShowMonster(2, arg))
end

function IllustrationMonsterTem:GetTemplate(data)
    local class, prefab
    if data.isLevelLimitTitle then
        class = UITemplate.MonsterLimitImageTemplate
        prefab = self.Parameter.MonsterLimitImageTemplate.LuaUIGroup.gameObject
    else
        class = UITemplate.IllustrationMonsterListTemplate
        prefab = self.Parameter.IllustrationMonsterListPrefab.LuaUIGroup.gameObject
    end
    return class, prefab
end

--选择详细数据项
function IllustrationMonsterTem:ChooseMonsterDetailInfo()
    for i = 1, 3 do
        self.Parameter["MonsterDetailInfor" .. i]:SetActiveEx(false)
        local togEx = self.Parameter["MonsterTogDetail" .. i].TogEx
        togEx.onValueChanged:AddListener(function(value)
            if value then
                self:RefreshMonsterDetailInfo(i)
            end
        end)
    end
end

function IllustrationMonsterTem:HasCard(awards)
    local awardList = awards
    local hasCard = false
    local itemSdata
    local monsterCardId = 0
    for k, v in ipairs(awardList) do
        itemSdata = TableUtil.GetItemTable().GetRowByItemID(v.item_id)
        if itemSdata and itemSdata.TypeTab == Data.BagModel.PropType.Card then
            monsterCardId = v.item_id
            hasCard = true
            break
        end
    end
    return hasCard, monsterCardId
end

--刷新魔物右侧数据
function IllustrationMonsterTem:RefreshMonsterInfo()
    self.Parameter.MonsterInfoPanel:SetActiveEx(true)
    --类型图片
    self.Parameter.MonsterType:SetActiveEx(true)
    if currentMonsterInfo.UnitTypeLevel == 4 then
        --MINI
        self.Parameter.MonsterType:SetSprite("Common", "UI_Common_Identification_MiniBoss.png")
    elseif currentMonsterInfo.UnitTypeLevel == 5 then
        --MVP
        self.Parameter.MonsterType:SetSprite("Common", "UI_Common_Identification_Mvp.png")
    else
        --NORMAL
        self.Parameter.MonsterType:SetActiveEx(false)
    end
    --六维图
    local attrData = self.data.GetMonsterAttrData(currentMonsterInfo)
    self:RefreshMonsterPolygon(attrData.polygonData)
    --魔物名和等级
    self.Parameter.MonsterName.LabText = currentMonsterInfo.Name .. "  Lv." .. currentMonsterInfo.UnitLevel
    --生命上限
    if currentMonsterInfo.UnitTypeLevel == 5 or currentMonsterInfo.UnitTypeLevel == 4 then
        self.Parameter.MonsterHpNumText.LabText = "????"
    else
        self.Parameter.MonsterHpNumText.LabText = attrData.hp
    end
    --物理攻击
    self.Parameter.MonsterAtkNumText.LabText = attrData.atk
    --物理防御
    self.Parameter.MonsterDefNumText.LabText = attrData.def
    --命中
    self.Parameter.MonsterHitNumText.LabText = attrData.hit
    --魔法攻击
    self.Parameter.MonsterMAtkNumText.LabText = attrData.matk
    --魔法防御
    self.Parameter.MonsterMDefNumText.LabText = attrData.mdef
    --闪避
    self.Parameter.MonsterFleeNumText.LabText = attrData.flee
    --卡片按钮
    self.Parameter.MonsterCardButton.gameObject:SetActiveEx(false)
    --魔物模型
    self:CreateMonster3DModel()
    --魔物属性Tip
    self:RefreshMonsterAttrTip()
    --击杀提示
    self.Parameter.MonsterNotKillText.gameObject:SetActiveEx(self.data.GetMonsterStateById(currentMonsterInfo.Id) == nil)
    --下部详细信息
    self:RefreshMonsterDetailInfo(monsterDetailInfoType)
    --刷新奖励信息
    self:RefreshAwards()
    --上部背景图
    local sceneId
    --地图MVP读MvpTable
    if currentMonsterMvpInfo then
        sceneId = currentMonsterMvpInfo.SceneID
    else
        sceneId = Common.CommonUIFunc.GetMonsterNormalSceneIdAndPos(currentMonsterInfo.Id)[1]
    end
    if not sceneId then
        logError("未找到对应的地图 monsterId => " .. currentMonsterInfo.Id)
    else
        local sceneData = TableUtil.GetMapTable().GetRowBySceneId(sceneId)
        if sceneData then
            self.Parameter.MonsterInfoMap:SetRawTex("MonsterIllustrated/" .. sceneData.BgIcon)
        end
    end

    local l_state, l_vStr, l_dropStr = self.data.GetLvRateByEntityID(currentMonsterInfo.Id)
    self.Parameter.lvNum.LabText = l_vStr
    self.Parameter.DropNum.LabText = l_dropStr
    self.Parameter.Text_Level.LabText = self.data.GetMonsterRewardLevelById(currentMonsterInfo.Id)
end

--魔物属性Tip
function IllustrationMonsterTem:RefreshMonsterAttrTip()
    --属性
    local l_attr = TableUtil.GetElementAttr().GetRowByAttrId(currentMonsterInfo.UnitAttrType)
    if l_attr then
        self.Parameter.MonsterTypeAttrText.LabText = l_attr.ColourTextDefence
        local color = RoColor.Hex2Color(RoBgColor[l_attr.Colour])
        if color then
            self.Parameter.MonsterTypeAttr.Img.color = color
        end
    end
    --种族
    local l_race_enum = TableUtil.GetRaceEnum().GetRowById(currentMonsterInfo.UnitRace)
    if l_race_enum then
        self.Parameter.MonsterTypeRaceText.LabText = l_race_enum.Text
    end
    --体型
    self.Parameter.MonsterTypeShapeText.LabText = Lang("UnitSize_" .. tostring(currentMonsterInfo.UnitSize))
    Common.CommonUIFunc.CalculateLowLevelTipsInfo(self.Parameter.MonsterTypeAttrText, nil, Vector2.New(1, 1))
    Common.CommonUIFunc.CalculateLowLevelTipsInfo(self.Parameter.MonsterTypeRaceText, nil, Vector2.New(1, 1))
    Common.CommonUIFunc.CalculateLowLevelTipsInfo(self.Parameter.MonsterTypeShapeText, nil, Vector2.New(1, 1))
end

--刷新详细数据
function IllustrationMonsterTem:RefreshMonsterDetailInfo(detailType)
    monsterDetailInfoType = detailType
    local detailInfor = self.Parameter["MonsterDetailInfor" .. monsterDetailInfoType]
    self.Parameter.MonsterDetailInfor1:SetActiveEx(false)
    self.Parameter.MonsterDetailInfor2:SetActiveEx(false)
    self.Parameter.MonsterDetailInfor3:SetActiveEx(false)
    detailInfor:SetActiveEx(true)
    if detailType == MONSTER_DETAIL_TYPE.Texing then
        --主/被动
        local isInitiativeStr = Lang("ILLUSTRATION_MONSTER_NOT_INITIASTIVE")
        if currentMonsterInfo.IsInitiative == 1 then
            isInitiativeStr = Lang("ILLUSTRATION_MONSTER_INITIASTIVE")
        end
        --是否无视隐匿  IgnoreHide
        local ignoreHideStr = ""
        if currentMonsterInfo.IgnoreHide == 1 then
            ignoreHideStr = Lang("ILLUSTRATION_MONSTER_IGNOREHIDE")
        end
        --特性
        local featuresDesc = string.ro_split(currentMonsterInfo.FeaturesDesc, "|")
        local featuresDescStr = ""
        for k, v in ipairs(featuresDesc) do
            featuresDescStr = featuresDescStr .. "、" .. v
        end
        --特性总文本
        local descStr = isInitiativeStr
        if ignoreHideStr ~= "" then
            descStr = descStr .. "、" .. ignoreHideStr
        end
        descStr = descStr .. featuresDescStr
        detailInfor.LabText = descStr
        Common.CommonUIFunc.CalculateLowLevelTipsInfo(detailInfor, nil)
    elseif detailType == MONSTER_DETAIL_TYPE.Loot then
        self:RefreshAwards()
    elseif detailType == MONSTER_DETAIL_TYPE.Map then
        --地图
        local sceneIdTable = {}
        --地图MVP读MvpTable
        if currentMonsterMvpInfo then
            table.insert(sceneIdTable, currentMonsterMvpInfo.SceneID)
        else
            sceneIdTable = Common.CommonUIFunc.GetMonsterNormalSceneIdAndPos(currentMonsterInfo.Id)
        end
        self:setMonsterTextHref(sceneIdTable)
        local mapStr = ""
        local sceneName = ""
        for k, v in ipairs(sceneIdTable) do
            local sceneSdata = TableUtil.GetMapTable().GetRowBySceneId(v)
            if sceneSdata then
                sceneName = sceneSdata.SceneName
                if mapStr == "" then
                    mapStr = mapStr .. "<a href=ToScene" .. k .. "><color=#46456f>" .. sceneName .. "</color></a>"
                else
                    mapStr = mapStr .. " | " .. "<a href=ToScene" .. k .. "><color=#46456f>" .. sceneName .. "</color></a>"
                end
            end
        end
        detailInfor.LabText = mapStr
    end
end

function IllustrationMonsterTem:RefreshAwards()
    local awardIds = {}
    local awardItemList = {}
    local ItemIds = {}
    if currentMonsterInfo.UnitTypeLevel == 5 then
        local mvpInfo = self.data.GetMonsterMvpTableById(currentMonsterInfo.Id)
        for i = 0, mvpInfo.WinAward.Length - 1 do
            table.insert(awardIds, mvpInfo.WinAward[i])
        end
        for i = 0 ,mvpInfo.PersonalMvpAward.Length - 1 do
            table.insert(awardIds, mvpInfo.PersonalMvpAward[i])
        end
        for i = 0 ,mvpInfo.PartsInAwardPreview.Length - 1 do
            table.insert(awardIds, mvpInfo.PartsInAwardPreview[i])
        end
    end
    for i = 0, currentMonsterInfo.Award.Length - 1 do
        table.insert(awardIds, currentMonsterInfo.Award[i])
    end
    for i = 1, #awardIds do
        local awarditems = MgrMgr:GetMgr("AwardPreviewMgr").GetAllItemByAwardId(awardIds[i])
        for k, v in pairs(awarditems) do
            if ItemIds[v.item_id] == nil then
                v.SortPoint,v.quality = self:GetAwardSortPoint(v.item_id)
                table.insert(awardItemList, v)
                ItemIds[v.item_id] = 1
            end
        end
    end
    awardItemList = table.ro_unique(awardItemList)
    table.sort(awardItemList, function(a, b)
        if a.SortPoint == b.SortPoint then
            return a.quality > b.quality
        end
        return a.SortPoint > b.SortPoint
    end)
    self:DoRefreshAwards(awardItemList)
    local isHaveCard, monsterCardId = self:HasCard(awardItemList)
    self.Parameter.MonsterCardButton.gameObject:SetActiveEx(isHaveCard)
    currentMonsterCardId = monsterCardId
end

function IllustrationMonsterTem:DoRefreshAwards(awardData)
    if nil == awardData then
        return
    end

    --掉落物
    local lootTable = {}
    for k, v in ipairs(awardData) do
        table.insert(lootTable, { ID = v.item_id, Count = 1, IsShowCount = false })
    end
    self.monsterLootTemplatePool:ShowTemplates { Datas = lootTable }
    MLuaCommonHelper.SetRectTransformOffset(self.monsterLootSizeFitter.gameObject, 0, 0, 0, 0)
    self.monsterLootSizeFitter.enabled = #lootTable > 4
end

function IllustrationMonsterTem:OnRefreshAward(awardData, customData, awardId)
    currentMonsterAwardTable = awardData and awardData.award_list or {}
    self.cacheAwards[awardId] = currentMonsterAwardTable

    --刷新奖励
    if not currentRequestAwardId or currentRequestAwardId ~= awardId then
        return
    end

    local isHaveCard, monsterCardId = self:HasCard(currentMonsterAwardTable)
    self.Parameter.MonsterCardButton.gameObject:SetActiveEx(isHaveCard)
    local sysMgr = MgrMgr:GetMgr("OpenSystemMgr")
    if not sysMgr.IsSystemOpen(sysMgr.eSystemId.IllustratorCard) then
        self.Parameter.MonsterCardButton:SetActiveEx(false)
    end
    currentMonsterCardId = monsterCardId

    if monsterDetailInfoType ~= MONSTER_DETAIL_TYPE.Loot then
        return
    end

    self:DoRefreshAwards(currentMonsterAwardTable)
end

--魔物六维图
function IllustrationMonsterTem:RefreshMonsterPolygon(polygonData)
    local lSetPolygon = self.Parameter.MonsterLiubianxing.gameObject:GetComponent("MUISetPolygon")

    for i = 1, #polygonData do
        local attr = polygonData[i]
        local value = 0.3 + attr / polygonData.maxValue / 1.2 * 0.7
        lSetPolygon:SetValueByIndex(i - 1, value)
    end
    lSetPolygon.enabled = false
    lSetPolygon.enabled = true
    --六维数值
    self.Parameter.MonsterStrText.LabText = polygonData[1]
    self.Parameter.MonsterAgiText.LabText = polygonData[2]
    self.Parameter.MonsterDexText.LabText = polygonData[3]
    self.Parameter.MonsterIntText.LabText = polygonData[4]
    self.Parameter.MonsterLukText.LabText = polygonData[5]
    self.Parameter.MonsterVitText.LabText = polygonData[6]
end


--创建魔物模型
function IllustrationMonsterTem:CreateMonster3DModel()
    self:DestroyMonster3DModel()

    self.Parameter.MonsterMod.gameObject:SetActiveEx(false)
    local entityId = currentMonsterInfo.Id
    local l_tempId = MUIModelManagerEx:GetTempUID()
    local l_attr = MAttrMgr:InitMonsterAttr(l_tempId, "MonsterMod", entityId)
    local l_fxData = {}
    l_fxData.rawImage = self.Parameter.MonsterMod.RawImg
    self.Parameter.MonsterMod.RectTransform.sizeDelta = Vector2(300, 420)
    l_fxData.attr = l_attr
    l_fxData.defaultAnim = l_attr.CommonIdleAnimPath
    self.monsterEntity = self:CreateUIModel(l_fxData)
    self.monsterEntity:AddLoadModelCallback(function(m)
        --特殊魔物模型缩放
        local modelScale = self.data.GetMonsterModelScaleTableById(currentMonsterInfo.Id)
        local defineScale = 0.7
        self.monsterEntity.Trans:SetLocalScale(defineScale, defineScale, defineScale)
        if modelScale then
            self.monsterEntity.Trans:SetLocalScale(defineScale * modelScale, defineScale * modelScale, defineScale * modelScale)
        end
        --因为魔物属性条挡住 所以往上放一点
        self.monsterEntity.Trans:SetLocalPos(0, 0.3, 0)
        self.monsterEntity.Trans:Rotate(Vector3.New(0, 20, 0))
        self.Parameter.MonsterMod.gameObject:SetActiveEx(true)
    end)

end

--移除魔物模型
function IllustrationMonsterTem:DestroyMonster3DModel()
    if self.monsterEntity then
        if self.monsterEntity.Trans then
            --可能模型异步加载没有加载完成
            self.monsterEntity.Trans:SetLocalScale(1, 1, 1)
        end
        self:DestroyUIModel(self.monsterEntity)
        self.monsterEntity = nil
        self.Parameter.MonsterMod.gameObject:SetActiveEx(false)
    end
end

--添加拖动旋转监听
function IllustrationMonsterTem:AddMonsterDragListener(go)
    local l_listener = MUIEventListener.Get(go)
    l_listener.onDrag = function(uobj, event)
        self.monsterEntity.Trans:Rotate(Vector3.New(0, -event.delta.x, 0))
    end
end

--设置信息超链接
function IllustrationMonsterTem:setMonsterTextHref(sceneIdTable)
    local l_richText = self.Parameter.MonsterDetailInfor3:GetRichText()
    l_richText.raycastTarget = true
    --先清理再绑定
    l_richText.onHrefClick:RemoveAllListeners()
    l_richText.onHrefClick:AddListener(function(hrefName)
        for k, v in ipairs(sceneIdTable) do
            if hrefName == "ToScene" .. k then
                --场景 怪物 寻路
                game:ShowMainPanel()
                if currentMonsterMvpInfo then
                    MTransferMgr:GotoScene(currentMonsterMvpInfo.SceneID)
                    UIMgr:DeActiveUI(self.name)
                    UIMgr:DeActiveUI(UI.CtrlNames.IllustrationPandect)
                else
                    local posNum = MonsterDataTable[currentMonsterInfo.Id][v]
                    if posNum then
                        local pos = Vector3.New(posNum[1], posNum[2], posNum[3])

                        MTransferMgr:GotoPosition(v, pos, function()
                        end)
                        UIMgr:DeActiveUI(self.name)
                        UIMgr:DeActiveUI(UI.CtrlNames.IllustrationPandect)
                    else
                        logError("MonsterDataTable离线表找不到数据 monsterId => " .. currentMonsterInfo.Id .. " sceneId => " .. v)
                        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("TIP_ERROR_FINDWAY_DATA"))
                    end
                end
            end
        end
    end)
end

--点击怪物
function IllustrationMonsterTem:OnSelectMonster(monsterData)
    currentMonsterInfo = monsterData
    currentMonsterMvpInfo = nil
    currentMonsterAwardTable = nil
    currentRequestAwardId = nil
    self.Parameter.MonsterCardButton:SetActiveEx(false)
    --清除原来的选择
    local monsterList = self.monsterListTemplatePool:GetItem(self.data.GetMonsterListTemplateIndex())
    if monsterList and "IllustrationMonsterListTemplate" == monsterList.__cname then
        local monsterCell = monsterList:GetTemplatePool():GetItem(self.data.GetMonsterCellTemplateIndex())
        if monsterCell then
            monsterCell:SetMonsterSelectState(false)
        end
    end
    if monsterData == nil then
        return
    end
    if currentMonsterInfo.UnitTypeLevel == 5 then
        currentMonsterMvpInfo = self.data.GetMonsterMvpTableById(currentMonsterInfo.Id)
    end
    if currentMonsterMvpInfo and currentMonsterMvpInfo.WinAward.Length > 0 then
        currentRequestAwardId = currentMonsterMvpInfo and currentMonsterMvpInfo.WinAward[0]
    elseif currentMonsterInfo and currentMonsterInfo.Award.Length > 0 then
        currentRequestAwardId = currentMonsterInfo and currentMonsterInfo.Award[0]
    end

    self:RefreshMonsterInfo()
    local sysMgr = MgrMgr:GetMgr("OpenSystemMgr")
    if not sysMgr.IsSystemOpen(sysMgr.eSystemId.IllustratorCard) then
        self.Parameter.MonsterCardButton:SetActiveEx(false)
    end
end

function IllustrationMonsterTem:UnlockMonster(monsterId)
    --解锁魔物
    local monsterList = self.monsterListTemplatePool:GetItem(self.data.GetMonsterListTemplateIndex())
    if monsterList then
        local monsterCell = monsterList:GetTemplatePool():GetItem(self.data.GetMonsterCellTemplateIndex())
        if monsterCell then
            monsterCell:SetMonsterCellUnlockState(monsterId)
            monsterCell:PlayEffect()
        end
    end
end

--创建魔物图鉴滚动条
function IllustrationMonsterTem:CreateShowMonsterScroll(monsterTable)
    self.monsterListTemplatePool:DeActiveAll()
    self.monsterListTemplatePool:ShowTemplates({ Datas = monsterTable })
    --未找到
    self.Parameter.MonsterNotFoundText.gameObject:SetActiveEx(#monsterTable == 0)
    --显示记录位置的魔物的信息
    if #monsterTable > 0 then
        self:OnSelectMonster(monsterTable[self.data.GetMonsterListTemplateIndex()][self.data.GetMonsterCellTemplateIndex()])
    else
        self.Parameter.MonsterNotKillText.gameObject:SetActiveEx(false)
    end
end

function IllustrationMonsterTem:ResetData()
    currentMonsterInfo = nil
    currentMonsterMvpInfo = nil
    currentMonsterAwardTable = nil
    currentRequestAwardId = nil
    currentMonsterCardId = nil
    monsterDetailInfoType = MONSTER_DETAIL_TYPE.Texing
    self.data.ResetMonsterValues()
end

function IllustrationMonsterTem:RefreshBtn(flag)
    self.Parameter.Btn_liuwei:SetActiveEx(flag)
    self.Parameter.Shuxing:SetActiveEx(flag)
    self.Parameter.Btn_xiangxi:SetActiveEx(not flag)
    self.Parameter.MonsterLiuweitu:SetActiveEx(not flag)
end

function IllustrationMonsterTem:ShowMini(...)
    self:OnSelectType("5|3")
end
function IllustrationMonsterTem:SearchMonsterNameById(EntityId)
    local name = TableUtil.GetEntityTable().GetRowById(tonumber(EntityId)).Name
    self.Parameter.MonsterSearchInputField.Input.text = name
end
function IllustrationMonsterTem:GetAwardSortPoint(itemId)
    local itemInfo = TableUtil.GetItemTable().GetRowByItemID(itemId)
    if itemInfo.TypeTab == GameEnum.EItemType.Card then
        return 3,itemInfo.ItemQuality
    end
    if itemInfo.TypeTab == GameEnum.EItemType.Equip then
        return 2,itemInfo.ItemQuality
    end
    if itemInfo.TypeTab == GameEnum.EItemType.BluePrint then
        return 1,itemInfo.ItemQuality
    end
    return 0,itemInfo.ItemQuality
end
--lua custom scripts end
return IllustrationMonsterTem