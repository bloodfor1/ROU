--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/ItemAchieveTipsNewPanel"
require "TableEx/ItemSearchTable"
require "TableEx/MonsterDataTable"
require "TableEx/NpcDataTable"
--lua requires end

--lua model
module("UI", package.seeall)

--lua model end

--lua fields
local super = UI.UIBaseCtrl
--lua fields end

--lua class define
---@class ItemAchieveTipsNewCtrl : UIBaseCtrl
local l_openSystemMgr = MgrMgr:GetMgr("OpenSystemMgr")
local l_dungeonMgr = MgrMgr:GetMgr("DungeonMgr")
ItemAchieveTipsNewCtrl = class("ItemAchieveTipsNewCtrl", super)
--lua class define end

--lua functions
function ItemAchieveTipsNewCtrl:ctor()
	
	super.ctor(self, CtrlNames.ItemAchieveTipsNew, UILayer.Tips, nil, ActiveType.Standalone)
	
end --func end
--next--
function ItemAchieveTipsNewCtrl:Init()
	
	self.panel = UI.ItemAchieveTipsNewPanel.Bind(self)
	super.Init(self)
	
	self.ItemAchieveTplPool =self:NewTemplatePool({
        TemplateClassName = "ItemAchieveTpl",
        TemplatePrefab=self.panel.ItemAchieveTpl.gameObject,
        ScrollRect=self.panel.ItemAchieveScrollRect.LoopScroll,
	})

	self.ItemTargetTplPool =self:NewTemplatePool({
        TemplateClassName = "ItemAchieveTargetTpl",
        TemplatePrefab=self.panel.ItemAchieveTargetTpl.gameObject,
        ScrollRect=self.panel.TargetScrollRect.LoopScroll,
	})
    
	self.panel.CloseButton.Listener.onClick=function(obj,data)
        self:CloseReleateTips()
        MLuaClientHelper.ExecuteClickEvents(data.position,UI.CtrlNames.ItemAchieveTipsNew)
    end

    self.panel.CloseTip:AddClick(function()
        self:CloseReleateTips()
	end)

	self.achieveTplDataTb = {}
	
	self.targetPlaceDataTb = {}
end --func end
--next--
function ItemAchieveTipsNewCtrl:Uninit()
	
	self.ItemAchieveTplPool=nil
	self.ItemTargetTplPool=nil

	super.Uninit(self)
	self.panel = nil
	
end --func end
--next--
function ItemAchieveTipsNewCtrl:OnActive()
    self:SetCloseButtonState()
	MgrMgr:GetMgr("ItemTipsMgr").SortCommonTipsAndItemSearchPath()
end --func end
--next--
function ItemAchieveTipsNewCtrl:OnDeActive()
	if MEntityMgr.PlayerEntity ~= nil and MEntityMgr.PlayerEntity.AttrComp ~= nil then
        MEntityMgr.PlayerEntity.AttrComp:SetHair(MPlayerInfo.HairStyle)
        MEntityMgr.PlayerEntity.AttrComp:SetEyeColor(MPlayerInfo.EyeColorID)
        MEntityMgr.PlayerEntity.AttrComp:SetEye(MPlayerInfo.EyeID)
    end
	self.initAchieve = false
    self.initTargetPlace = false
end --func end
--next--
function ItemAchieveTipsNewCtrl:Update()
	
	
end --func end
--next--
function ItemAchieveTipsNewCtrl:BindEvents()
	
	
end --func end
--next--
--lua functions end

--lua custom scripts

function ItemAchieveTipsNewCtrl:SetCloseButtonState()
    local l_state = UIMgr:IsActiveUI(UI.CtrlNames.CommonItemTips)
    self.panel.CloseButton.gameObject:SetActiveEx(not l_state)
end

function ItemAchieveTipsNewCtrl:InsertDataToAchievement(functionId, name, placeName, lv, atlas, icon, isMvp, isShowLv, btnFunc, isElite)
    local insertData = {}
    insertData.functionId = functionId or -1
    insertData.name = name or ""
    insertData.place = placeName or ""
    insertData.lv = lv or 0
    insertData.atlas = atlas or ""
    insertData.icon = icon or ""
    insertData.isMvp = isMvp or false
    insertData.isElite = isElite or false
    insertData.isShowLv = isShowLv or false
    insertData.btnFunc = btnFunc or function()
    end
    --策划需求 OpenSystemTable的IsOpen是否开启字段配置为0（关闭）的功能，不显示在获取途径列表中 @韩艺名
    local l_tableData = TableUtil.GetOpenSystemTable().GetRowById(functionId,true)
    if l_tableData and l_tableData.IsOpen == 0 then
        return
    end
    table.insert(self.achieveTplDataTb, insertData)
end

function ItemAchieveTipsNewCtrl:InsertDataToTargetPlace(name, btnFunc)
    local l_insertData = {}
    l_insertData.text = name or ""
    l_insertData.btnFunc = btnFunc or function()
    end
    table.insert(self.targetPlaceDataTb, l_insertData)
end

function ItemAchieveTipsNewCtrl:CheckItemSearchData(cItemId)
    local l_Data = ItemSearchTable[tonumber(cItemId)]
    local l_DataTable = {}
    local l_Search = false
    if l_Data then
        for k, v in pairs(l_Data) do
            if table.ro_size(l_Data[k]) > 0 then
                l_DataTable[k] = v
                l_Search = true
            else
                l_DataTable[k] = {}
            end
        end
    end
    return l_Search, l_DataTable
end

function ItemAchieveTipsNewCtrl:SetRelativePosition(baseRect)
    if not baseRect then
        return
    end

    local l_baseCorners = System.Array.CreateInstance(System.Type.GetType("UnityEngine.Vector3, UnityEngine.CoreModule"), 4)
    baseRect:GetWorldCorners(l_baseCorners)
    local l_baseTopLeft = MUIManager.UICamera:WorldToScreenPoint(l_baseCorners[1])
    local l_baseTopRight = MUIManager.UICamera:WorldToScreenPoint(l_baseCorners[2])
    local l_panelCorners = System.Array.CreateInstance(System.Type.GetType("UnityEngine.Vector3, UnityEngine.CoreModule"), 4)
    self.panel.ItemAchievePanel.RectTransform:GetWorldCorners(l_panelCorners)
    local l_panelTopLeft = MUIManager.UICamera:WorldToScreenPoint(l_panelCorners[1])
    local l_panelTopRight = MUIManager.UICamera:WorldToScreenPoint(l_panelCorners[2])
    local l_baseScreenPos = l_baseTopRight
    local l_offsetX = self.panel.ItemAchievePanel.RectTransform.rect.width / 2
    local l_offsetY = self.panel.ItemAchievePanel.RectTransform.rect.height / 2
    if l_baseTopRight.x + l_panelTopRight.x - l_panelTopLeft.x > Screen.width then
        l_baseScreenPos = l_baseTopLeft
        l_offsetX = -l_offsetX
    end
    local _, l_pos = RectTransformUtility.ScreenPointToLocalPointInRectangle(self.panel.ItemAchievePanel.RectTransform.parent, l_baseScreenPos, MUIManager.UICamera, nil)
    self.panel.ItemAchievePanel.RectTransform.anchoredPosition = Vector2.New(l_pos.x + l_offsetX, l_pos.y - l_offsetY)
end

function ItemAchieveTipsNewCtrl:InitItemAchievePanelByItemId(ItemId)
    self:SetCloseButtonState()
    local l_Search, l_DataTable = self:CheckItemSearchData(ItemId)
    self.achieveTplDataTb = {}
    self.ItemId = ItemId
    if l_Search then
        --k 是类型 v 是数据
        for k, v in ipairs(l_DataTable) do
            if table.ro_size(v) > 0 then
                self:SetPanelByType(k, v)
            end
        end
        
        table.sort(self.achieveTplDataTb,function (a,b)
            local l_itemAchievingTypeTb_a = TableUtil.GetItemAchievingTypeTable().GetRowByID(a.functionId,true)
            local l_itemAchievingTypeTb_b = TableUtil.GetItemAchievingTypeTable().GetRowByID(b.functionId,true)
            if l_itemAchievingTypeTb_a == nil then
                logError("别慌 ItemAchievingTypeTable 没有找到这个数据~@艺鸣 添加配置，添加功能Id  "..a.functionId)
                return false
            end
            if l_itemAchievingTypeTb_b == nil then
                logError("别慌 ItemAchievingTypeTable 没有找到这个数据~@艺鸣 添加配置，添加功能Id  "..b.functionId)
                return false
            end
            return l_itemAchievingTypeTb_a.SortID < l_itemAchievingTypeTb_b.SortID
        end)

        -----------------------------------------以下的目的 排序怪物-----------------------------
        local l_monsterStartIndex = 0
        local l_monsterCount = 0
        local l_monsterTb = {}
        for i = table.ro_size(self.achieveTplDataTb), 1, -1 do
            local l_value = self.achieveTplDataTb[i]
            local l_isMonster = l_value.functionId == l_openSystemMgr.eSystemId.MonsterDrap or 
            l_value.functionId == l_openSystemMgr.eSystemId.MVP or l_value.functionId == l_openSystemMgr.eSystemId.EliteDrap 
            if l_isMonster then
                l_monsterStartIndex = i
                l_monsterCount = l_monsterCount + 1
                table.insert(l_monsterTb,l_value)
                table.remove(self.achieveTplDataTb,i)
            end
        end
        --怪物排序
        table.sort(l_monsterTb,function (a,b)
            return a.lv < b.lv
        end)

        table.ro_insertIndexRange(self.achieveTplDataTb,l_monsterTb,l_monsterStartIndex)
        -------------------------------------------------------------------------------------------

        --屏蔽黑名单的产出
        local l_itemBlackListData = TableUtil.GetItemAchieveBlackList().GetRowByItemID(ItemId,true)
        if l_itemBlackListData then
            local l_blackList = Common.Functions.VectorToTable(l_itemBlackListData.ItemBlackList)
            for i = table.maxn(self.achieveTplDataTb), 1, -1 do
                local value = self.achieveTplDataTb[i]
                for key_1, value_1 in pairs(l_blackList) do
                    if value.functionId == value_1 then
                        table.remove(self.achieveTplDataTb,i)
                    end
                end
            end
        end
        self.ItemAchieveTplPool:ShowTemplates({Datas = self.achieveTplDataTb})
    end
end

function ItemAchieveTipsNewCtrl:SetPanelByType(ItemSearchType, ItemSearchData)
    if ItemSearchType == GameEnum.ItemSearchType.MonsterDrop then
        self:SetMonster(ItemSearchData)
    end
    if ItemSearchType == GameEnum.ItemSearchType.NpcShopGet then
        self:SetNpcShop(ItemSearchData)
    end
    if ItemSearchType == GameEnum.ItemSearchType.SystemPanel then
        self:SetSystemGet(ItemSearchData)
    end
    if ItemSearchType == GameEnum.ItemSearchType.DungeonsGet then
        self:SetDungeonsGet(ItemSearchData)
    end
    if ItemSearchType == GameEnum.ItemSearchType.CollectGet then
        self:SetCollectionGet(ItemSearchData)
    end
    if ItemSearchType == GameEnum.ItemSearchType.RecipeGet then
        self:SetReceipGet(ItemSearchData)
    end
    if ItemSearchType == GameEnum.ItemSearchType.Achievement then
        self:SetAchievement(ItemSearchData)
    end
    if ItemSearchType == GameEnum.ItemSearchType.AchievementBadge then
        self:SetAchievementBadgeTable(ItemSearchData)
    end
    if ItemSearchType == GameEnum.ItemSearchType.GarderobeAward then
        self:SetGarderobeAward(ItemSearchData)
    end
    if ItemSearchType == GameEnum.ItemSearchType.AwardPack then
        self:SetAwardPack(ItemSearchData)
    end
end

--设置怪物的获取途径 数据为怪物的Id的Table
function ItemAchieveTipsNewCtrl:SetMonster(monsterDataTable)
    for i = 1, table.ro_size(monsterDataTable) do
        local l_isMvp, l_mvpPlace = Common.CommonUIFunc.CheckMonsterIsMvp(monsterDataTable[i])
        local l_isElite = Common.CommonUIFunc.CheckMonsterIsElite(monsterDataTable[i])
        local l_atlas, l_icon = Common.CommonUIFunc.GetMonsterAtlasAndIcon(monsterDataTable[i])
        local l_entityInfo = TableUtil.GetEntityTable().GetRowById(monsterDataTable[i])
        local l_sceneIdTb, l_posTb = Common.CommonUIFunc.GetMonsterNormalSceneIdAndPos(monsterDataTable[i])
        local l_placeName = ""
        for z = 1, table.maxn(l_sceneIdTb) do
            if Common.CommonUIFunc.IsDungonBySceneId(l_sceneIdTb[z]) == false then
                l_placeName = l_placeName .. " " .. Common.CommonUIFunc.GetSceneNameBySceneId(l_sceneIdTb[z])
            end
        end
        local mvpClickFunc = function()
            local l_funcName = Common.CommonUIFunc.GetFuncNameByFuncId(l_openSystemMgr.eSystemId.MVP)
            local l_isOpen, l_openBaseLv,l_showStr,l_tipsStr = Common.CommonUIFunc.GetFunctionIsOpenAndOpenLevelByFuncId(l_openSystemMgr.eSystemId.MVP)
            if not l_isOpen then
                MgrMgr:GetMgr("TipsMgr").ShowNormalTips(l_tipsStr)
                return
            end
            self:CloseReleateTips()
            if Common.CommonUIFunc.CheckScene() then
                local l_openParam = {
                    distinationActivityId = MgrMgr:GetMgr("DailyTaskMgr").g_ActivityType.activity_Mvp,
                }
                UIMgr:ActiveUI(UI.CtrlNames.DailyTask, l_openParam)
            end
        end
        local normalMonsterClickFunc = function()
            if table.maxn(l_sceneIdTb) == 1 or l_isMvp then
                self:NormalClick(l_sceneIdTb[1], l_posTb[1], onArriveFunc)
            else
                self:SetPlacePanle(l_sceneIdTb, l_posTb)
            end
        end

        --只显示场景中有配置的怪物
        if table.maxn(l_sceneIdTb) > 0 or l_isMvp then
            local l_funcId = l_openSystemMgr.eSystemId.MonsterDrap --魔物掉落
            if l_isMvp then l_funcId = l_openSystemMgr.eSystemId.MVP end
            if l_isElite then l_funcId = l_openSystemMgr.eSystemId.EliteDrap end
            self:InsertDataToAchievement(
                    l_funcId,
                    l_isMvp and l_entityInfo.Name .. "MVP" or l_entityInfo.Name,
                    l_isMvp and l_mvpPlace or l_placeName,
                    l_entityInfo.UnitLevel,
                    l_atlas,
                    l_icon,
                    l_isMvp,
                    true,
                    l_isMvp and mvpClickFunc or normalMonsterClickFunc,
                    l_isElite)
        end
    end
end

-- 商店产出
function ItemAchieveTipsNewCtrl:SetNpcShop(shopTableData)
    for i = 1, table.ro_size(shopTableData) do
        local l_npcTb = Common.CommonUIFunc.GetNpcIdByShopId(shopTableData[i])
        local l_funcId = Common.CommonUIFunc.GetFuncIdByShopId(shopTableData[i])
        local l_openType = Common.CommonUIFunc.GetFunctionTypeByFuncId(l_funcId)
        local l_atlas, l_icon = Common.CommonUIFunc.GetFuncAtlasAndIconByFuncId(l_funcId)
        local l_funcName = Common.CommonUIFunc.GetFuncNameByFuncId(l_funcId)
        local l_isOpen, l_openBaseLv,l_showStr,l_tipsStr = Common.CommonUIFunc.GetFunctionIsOpenAndOpenLevelByFuncId(l_funcId)
        local l_placeName = ""
        local l_sceneIdTb = {}
		local l_posTb = {}
        for x = 1, table.maxn(l_npcTb) do
            local sceneIdTb, posTb = Common.CommonUIFunc.GetNpcSceneIdAndPos(l_npcTb[x])
            for z = 1, table.maxn(sceneIdTb) do
                l_placeName = l_placeName .. " " .. Common.CommonUIFunc.GetSceneNameBySceneId(sceneIdTb[z])
            end
            table.mergeArray(l_sceneIdTb, sceneIdTb)
            table.mergeArray(l_posTb, posTb)
        end
		local l_showBtnFunc = nil
		if not l_isOpen then
			l_placeName = l_showStr
		end
        --如果是需要走到Npc的商店 需要判断下Npc的数量
        if l_openType == Common.CommonUIFunc.FuncOpenType.Npc then
            local onArriveFunc = function()
                MgrMgr:GetMgr("ShopMgr").OpenBuyShop(shopTableData[i], self.ItemId)
            end
            local onCancelFunc = function()
            end
            l_showBtnFunc = function()
                if not l_isOpen then
                    MgrMgr:GetMgr("TipsMgr").ShowNormalTips(l_tipsStr)
                    return
                end

                if l_funcId == MgrMgr:GetMgr("OpenSystemMgr").eSystemId.GuildShop then
                    MgrMgr:GetMgr("GuildMgr").GuildFindPath_FuncId(l_funcId)
                    return
                end

                if table.maxn(l_sceneIdTb) == 1 then
                    self:NormalClick(l_sceneIdTb[1], l_posTb[1], onArriveFunc, onCancelFunc)
                else
                    self:SetPlacePanle(l_sceneIdTb, l_posTb, onArriveFunc, onCancelFunc)
                end
            end
            if table.maxn(l_sceneIdTb) > 0 then
                self:InsertDataToAchievement(l_funcId,l_funcName, l_placeName, nil, l_atlas, l_icon, false, false, l_showBtnFunc)
            end
        else
            l_showBtnFunc = function()
                if not l_isOpen then
                    MgrMgr:GetMgr("TipsMgr").ShowNormalTips(l_tipsStr)
                    return
                end
                --委托商店 直接打开委托界面
                if l_funcId == MgrMgr:GetMgr("OpenSystemMgr").eSystemId.DelegateExchange then
                    Common.CommonUIFunc.OpenWheel()
                else
                    MgrMgr:GetMgr("ShopMgr").OpenBuyShop(shopTableData[i], self.ItemId)
                end
                self:CloseReleateTips()
            end
            self:InsertDataToAchievement(l_funcId,l_funcName, l_placeName, nil, l_atlas, l_icon, false, false, l_showBtnFunc)
        end
    end
end

--存在多个Npc 但是单独处理多个页签 是否都显示的逻辑
mulitNpcNormalSet = {
    l_openSystemMgr.eSystemId.Barber, --头饰商店
}

--检测是不是一个FuncId对应多个Npc
function ItemAchieveTipsNewCtrl:CheckIsInMulitNpcNormalSet(funcId)
    local isContain = false
    for i = 1, table.maxn(mulitNpcNormalSet) do
        if mulitNpcNormalSet[i] == funcId then
            isContain = true
            return isContain
        end
    end
    return isContain
end

--头饰商店 需要特殊判断当前的ItemId 属于哪一个Npc
function ItemAchieveTipsNewCtrl:GetNewNpcTbByItemId(NpcTb, ItemId)
    local l_NpcTb = {}
    local l_row = TableUtil.GetOrnamentBarterTable().GetRowByOrnamentID(ItemId)
    if not l_row then
        logError(StringEx.Format("找不到头饰ID,理论上不可能 ID:{0}", tostring(ItemId)))
        return NpcTb
    end

    for i = 1, table.maxn(NpcTb) do
        if l_row.NpcID == NpcTb[i] then
            table.insert(l_NpcTb, l_row.NpcID)
        end
    end
    return l_NpcTb
end

--设置由各个系统功能获得
function ItemAchieveTipsNewCtrl:SetSystemGet(itemSystemDataTable)
    for i = 1, table.ro_size(itemSystemDataTable) do
        local l_npcTb = Common.CommonUIFunc.GetNpcIdTbByFuncId(itemSystemDataTable[i])
        local l_atlas, l_icon = Common.CommonUIFunc.GetFuncAtlasAndIconByFuncId(itemSystemDataTable[i])
        local l_openType = Common.CommonUIFunc.GetFunctionTypeByFuncId(itemSystemDataTable[i])
        local l_isOpen, l_openBaseLv,l_showStr,l_tipsStr = Common.CommonUIFunc.GetFunctionIsOpenAndOpenLevelByFuncId(itemSystemDataTable[i])
        local l_funcName = Common.CommonUIFunc.GetFuncNameByFuncId(itemSystemDataTable[i])
        if self:CheckIsInMulitNpcNormalSet(itemSystemDataTable[i]) then
            l_npcTb = self:GetNewNpcTbByItemId(l_npcTb, self.ItemId)
        end
        local l_placeName = ""
        local l_sceneIdTb = {}
        local l_posTb = {}
        local l_allTb = {}
        for x = 1, table.maxn(l_npcTb) do
            local sceneIdTb, posTb = Common.CommonUIFunc.GetNpcSceneIdAndPos(l_npcTb[x])
            for z = 1, table.maxn(sceneIdTb) do
                l_placeName = l_placeName .. " " .. Common.CommonUIFunc.GetSceneNameBySceneId(sceneIdTb[z])
            end
            l_allTb[l_npcTb[x]] = {}
            l_allTb[l_npcTb[x]].sceneTb = sceneIdTb
            l_allTb[l_npcTb[x]].posTb = posTb
            l_allTb[l_npcTb[x]].preCheckTb = MgrMgr:GetMgr("SystemFunctionEventMgr").PreCheckFunction(itemSystemDataTable[i])
            table.mergeArray(l_sceneIdTb, sceneIdTb)
            table.mergeArray(l_posTb, posTb)
        end

        --进击的小恶魔采集需要特殊处理 数据来源走委托
        --之前进击的恶魔南门有配Npc 现在没有配了@韩艺名
        local wabaoFuncId = l_openSystemMgr.eSystemId.Wabao
        if itemSystemDataTable[i] == wabaoFuncId then
            local l_sceneTb, l_posTb = Common.CommonUIFunc.GetFightMonsterId(itemSystemDataTable[i])
            l_npcTb = { wabaoFuncId }
            l_allTb[wabaoFuncId] = {}
            l_allTb[wabaoFuncId].sceneTb = l_sceneTb
            l_allTb[wabaoFuncId].posTb = l_posTb
            l_allTb[wabaoFuncId].noFunc = function()
            end
            for z = 1, table.maxn(l_sceneTb) do
                l_placeName = l_placeName .. " " .. Common.CommonUIFunc.GetSceneNameBySceneId(l_sceneTb[z])
            end
        end

        --有Npc的功能处理
        local l_showBtnFunc = nil
        local l_showName = Common.CommonUIFunc.GetFunctionNameByFuncId(itemSystemDataTable[i])
        local l_showPlaceName = ""
        if table.maxn(l_npcTb) > 0 then
            if l_isOpen then
                l_showPlaceName = l_placeName
            else
                l_showPlaceName = l_showStr
            end
            l_showBtnFunc = function()
                if not l_isOpen then
                    MgrMgr:GetMgr("TipsMgr").ShowNormalTips(l_tipsStr)
                    return
                end
                if table.maxn(l_sceneIdTb) == 1 then
                    self:SetNormalArriveFunc(l_allTb, self.ItemId, l_openType, itemSystemDataTable[i])
                else
                    self:SetPlaceGetArriveFunc(l_allTb, self.ItemId, itemSystemDataTable[i])
                end
            end
        else
            --没有Npc的功能 直接打开相应面板
            if l_isOpen then
                l_showPlaceName = ""
                --韩艺鸣需求 神秘商店显示 每日随机刷新概率出现
                if itemSystemDataTable[i] == l_openSystemMgr.eSystemId.MallMysteryShop then
                    l_showPlaceName = Lang("RANDOM_CAME_IN")
                end
            else
                l_showPlaceName = l_showStr
            end
            l_showBtnFunc = function()
                if not l_isOpen then
                    MgrMgr:GetMgr("TipsMgr").ShowNormalTips(l_tipsStr)
                    return
                end
                self:SetNoNpcFunc(self.ItemId, l_openType, itemSystemDataTable[i])
            end
        end
        self:InsertDataToAchievement(itemSystemDataTable[i],l_showName, l_showPlaceName, nil, l_atlas, l_icon, false, false, l_showBtnFunc)
    end
end

--副本产出设置
function ItemAchieveTipsNewCtrl:SetDungeonsGet(c_DataTable)

    local l_haveThemeDungon = false
    local l_haveTowerDungon = false
    local l_haveFight = true --cbt 关掉战场
    local l_haveDungonPVP = false
    local l_haveChallenge = false
    local l_haveDoubleCook = false
    local l_haveGuildHunter = false
    local l_haveFogForest = false
    local l_haveTypeThemeStory = false
    local l_haveTowerDefenseSingle = false
    local l_haveTowerDefenseDouble = false
    local l_haveDungeonHymn = false

    for i = 1, table.ro_size(c_DataTable) do
        local l_curDungonType = Common.CommonUIFunc.GetDungonTypeByDungonID(c_DataTable[i])
        --这里进行特殊判断 如果是主题副本或者无限塔产出 统一一条 镜像副本不显示
        if (l_curDungonType ~= l_dungeonMgr.DungeonType.DungeonMirror)
                and ((l_curDungonType == l_dungeonMgr.DungeonType.DungeonThemeStory and l_haveThemeDungon == false)
                or (l_curDungonType == l_dungeonMgr.DungeonType.DungeonTower and l_haveTowerDungon == false)
                or (l_curDungonType == l_dungeonMgr.DungeonType.DungeonBattle and l_haveFight == false)
                or (l_curDungonType == l_dungeonMgr.DungeonType.DungeonArena and l_haveDungonPVP == false)
                or (l_curDungonType == l_dungeonMgr.DungeonType.DungeonHero and l_haveChallenge == false)
                or (l_curDungonType == l_dungeonMgr.DungeonType.DungeonDoubleCook and l_haveDoubleCook == false)
                or (l_curDungonType == l_dungeonMgr.DungeonType.DungeonGuildHunt and l_haveGuildHunter == false)
                or (l_curDungonType == l_dungeonMgr.DungeonType.DungeonMaze and l_haveFogForest == false)
                or (l_curDungonType == l_dungeonMgr.DungeonType.DungeonTypeThemeStory and l_haveTypeThemeStory == false)
                or (l_curDungonType == l_dungeonMgr.DungeonType.TowerDefenseSingle and l_haveTowerDefenseSingle == false)
                or (l_curDungonType == l_dungeonMgr.DungeonType.TowerDefenseDouble and l_haveTowerDefenseDouble == false)
                or (l_curDungonType == l_dungeonMgr.DungeonType.DungeonHymn and l_haveDungeonHymn == false)
                or (Common.CommonUIFunc.IsStandAloneDungeons(l_curDungonType))) then

            local l_npcTb, l_funId = Common.CommonUIFunc.GetNpcIdAndFuncIDByDungonId(c_DataTable[i])
            if l_curDungonType == l_dungeonMgr.DungeonType.DungeonTower then
                --无线塔特殊处理
                l_npcTb = Common.CommonUIFunc.GetNpcIdTbByFuncId(l_openSystemMgr.eSystemId.Tower)
            end
            local l_atlas, l_icon = Common.CommonUIFunc.GetFuncAtlasAndIconByFuncId(l_funId)
            local l_funcName = Common.CommonUIFunc.GetFuncNameByFuncId(l_funId)
            local l_isOpen, l_openBaseLv,l_showStr,l_tipsStr = Common.CommonUIFunc.GetFunctionIsOpenAndOpenLevelByFuncId(l_funId)

            --工会狩猎特殊处理 直接打开活动界面
            if l_curDungonType == l_dungeonMgr.DungeonType.DungeonGuildHunt then
                local l_showPlaceName = ""
                if l_isOpen then
                    l_showPlaceName = ""
                else
                    l_showPlaceName = l_showStr
                end
                local showBtnFunc = function()
                    MgrMgr:GetMgr("GuildHuntMgr").OpenGuildHuntInfo()
                end
                l_haveGuildHunter = true
                l_npcTb = {}
                self:InsertDataToAchievement(l_funId,l_funcName, l_showPlaceName, nil, l_atlas, l_icon, false, false, showBtnFunc)
            end

            for x = 1, table.maxn(l_npcTb) do
                local sceneIdTb, posTb = Common.CommonUIFunc.GetNpcSceneIdAndPos(l_npcTb[x])
                local showPlaceName = ""
                for z = 1, table.maxn(sceneIdTb) do
                    showPlaceName = showPlaceName .. " " .. Common.CommonUIFunc.GetSceneNameBySceneId(sceneIdTb[z])
                end

                if not l_isOpen then
                    showPlaceName = l_showStr
                end

                if showPlaceName ~= "" then
                    if l_curDungonType == l_dungeonMgr.DungeonType.DungeonThemeStory then
                        l_haveThemeDungon = true
                    elseif l_curDungonType == l_dungeonMgr.DungeonType.DungeonTower then
                        l_haveTowerDungon = true
                    elseif l_curDungonType == l_dungeonMgr.DungeonType.DungeonBattle then
                        l_haveFight = true
                    elseif l_curDungonType == l_dungeonMgr.DungeonType.DungeonArena then
                        l_haveDungonPVP = true
                    elseif l_curDungonType == l_dungeonMgr.DungeonType.DungeonHero then
                        l_haveChallenge = true
                    elseif l_curDungonType == l_dungeonMgr.DungeonType.DungeonDoubleCook then
                        l_haveDoubleCook = true
                    elseif l_curDungonType == l_dungeonMgr.DungeonType.DungeonGuildHunt then
                        l_haveGuildHunter = true
                    elseif l_curDungonType == l_dungeonMgr.DungeonType.DungeonMaze then
                        l_haveFogForest = true
                    elseif l_curDungonType == l_dungeonMgr.DungeonType.DungeonTypeThemeStory then
                        l_haveTypeThemeStory = true
                    elseif l_curDungonType == l_dungeonMgr.DungeonType.TowerDefenseSingle then
                        l_haveTowerDefenseSingle = true
                    elseif l_curDungonType == l_dungeonMgr.DungeonType.TowerDefenseDouble then
                        l_haveTowerDefenseDouble = true
                    elseif l_curDungonType == l_dungeonMgr.DungeonType.DungeonHymn then
                        l_haveDungeonHymn = true
                    end
                    local showBtnFunc = function()
                        if not l_isOpen then
                            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(l_tipsStr)
                            return
                        end
                        if table.maxn(sceneIdTb) == 1 then
                            local cFunc = function()
                                MgrMgr:GetMgr("NpcMgr").TalkWithNpc(sceneIdTb[1], l_npcTb[1])
                            end
                            self:NormalClick(sceneIdTb[1], posTb[1], cFunc)
                        else
                            self:SetDungonPlacePanle(sceneIdTb, posTb, l_npcTb[1])
                        end
                    end
                    self:InsertDataToAchievement(l_funId,l_funcName, showPlaceName, nil, l_atlas, l_icon, false, false, showBtnFunc)
                end
            end
        end
    end
end

--采集产出设置
function ItemAchieveTipsNewCtrl:SetCollectionGet(c_DataTable)
    local l_funcIdTb = {} --保存产出的FuncIdTb
    for i = 1, table.ro_size(c_DataTable) do
        local l_collectData = TableUtil.GetCollectTable().GetRowById(c_DataTable[i])
        if l_collectData == nil then
            logError("collectId:<" .. c_DataTable[i] .. "> not exists in CollectTable !")
            return
        else
            local isContain = false
            for z = 1, table.maxn(l_funcIdTb) do
                if l_funcIdTb[z] == l_collectData.Type then
                    isContain = true
                    break
                end
            end
            if not isContain then
                table.insert(l_funcIdTb, l_collectData.Type)
            end
        end
    end
    for i = 1, table.maxn(l_funcIdTb) do
        local l_atlas, l_icon = Common.CommonUIFunc.GetFuncAtlasAndIconByFuncId(l_funcIdTb[i])
        local l_isOpen, l_openBaseLv,l_showStr,l_tipsStr = Common.CommonUIFunc.GetFunctionIsOpenAndOpenLevelByFuncId(l_funcIdTb[i])
        local l_funcName = Common.CommonUIFunc.GetFuncNameByFuncId(l_funcIdTb[i])
        local l_showPlaceName = ""
        if not l_isOpen then
            l_showPlaceName = l_showStr
        end
        local l_showBtnFunc = function()
            if not l_isOpen then
                MgrMgr:GetMgr("TipsMgr").ShowNormalTips(l_tipsStr)
                return
            end
            self:CloseReleateTips()
            MgrMgr:GetMgr("LifeProfessionMgr").OpenLifeProfessionWnd(l_funcIdTb[i], self.ItemId)
        end
        self:InsertDataToAchievement(l_funcIdTb[i],l_funcName, l_showPlaceName, nil, l_atlas, l_icon, false, false, l_showBtnFunc)
    end
end

--生活技能产出设置
function ItemAchieveTipsNewCtrl:SetReceipGet(c_DataTable)
    local l_funcIdTb = {} --保存产出的FuncIdTb
    for i = 1, table.ro_size(c_DataTable) do
        local l_Data = TableUtil.GetRecipeTable().GetRowByID(c_DataTable[i])
        if l_Data == nil then
            logError("RecipeTable:<" .. c_DataTable[i] .. "> not exists in RecipeTable !")
            return
        else
            local isContain = false
            for z = 1, table.maxn(l_funcIdTb) do
                if l_funcIdTb[z] == l_Data.RecipeType then
                    isContain = true
                    break
                end
            end
            if not isContain then
                table.insert(l_funcIdTb, l_Data.RecipeType)
            end
        end
    end

    for i = 1, table.ro_size(l_funcIdTb) do
        local l_atlas, l_icon = Common.CommonUIFunc.GetFuncAtlasAndIconByFuncId(l_funcIdTb[i])
        local l_openType = Common.CommonUIFunc.GetFunctionTypeByFuncId(l_funcIdTb[i])
        local l_isOpen, l_openBaseLv,l_showStr,l_tipsStr = Common.CommonUIFunc.GetFunctionIsOpenAndOpenLevelByFuncId(l_funcIdTb[i])
        local l_funcName = Common.CommonUIFunc.GetFuncNameByFuncId(l_funcIdTb[i])
        local l_showPlaceName = ""
        if not l_isOpen then
            l_showPlaceName = l_showStr
        end
        local showBtnFunc = function()
            if not l_isOpen then
                MgrMgr:GetMgr("TipsMgr").ShowNormalTips(l_tipsStr)
                return
            end
            if l_openType ~= Common.CommonUIFunc.FuncOpenType.Npc then
                self:CloseReleateTips()
                MgrMgr:GetMgr("LifeProfessionMgr").OpenLifeProfessionWnd(l_funcIdTb[i], self.ItemId)
            end
        end
        self:InsertDataToAchievement(l_funcIdTb[i],l_funcName, l_showPlaceName, nil, l_atlas, l_icon, false, false, showBtnFunc)
    end
end

--设置成就获得
function ItemAchieveTipsNewCtrl:SetAchievement(achieveDataTable)
    local l_achieveMentFuncId = MgrMgr:GetMgr("OpenSystemMgr").eSystemId.Achievement
    local l_atlas, l_icon = Common.CommonUIFunc.GetFuncAtlasAndIconByFuncId(l_achieveMentFuncId)
    local l_isOpen, l_openBaseLv,l_showStr,l_tipsStr = Common.CommonUIFunc.GetFunctionIsOpenAndOpenLevelByFuncId(l_achieveMentFuncId)
    local l_funcName = Common.CommonUIFunc.GetFuncNameByFuncId(l_achieveMentFuncId)
    local l_showPlaceName = ""
    local l_showBtnFunc = nil
    if not l_isOpen then
        l_showPlaceName = l_showStr
    end
    if table.maxn(achieveDataTable) == 1 then
        l_showBtnFunc = function()
            if not l_isOpen then
                MgrMgr:GetMgr("TipsMgr").ShowNormalTips(l_tipsStr)
                return
            end
            self:CloseReleateTips()
            MgrMgr:GetMgr("AchievementMgr").OpenAchievementPanel(achieveDataTable[1])
        end
    else
        local finStr = ""
        local dataTable = {}
        for i = 1, table.maxn(achieveDataTable) do
            local achievementTableInfo = TableUtil.GetAchievementDetailTable().GetRowByID(achieveDataTable[i])
            finStr = finStr .. " " .. achievementTableInfo.Name
            local tempAchievementTb = { Id = achieveDataTable[i], Name = achievementTableInfo.Name }
            table.insert(dataTable, tempAchievementTb)
        end
        l_showPlaceName = finStr
        l_showBtnFunc = function()
            if not l_isOpen then
                MgrMgr:GetMgr("TipsMgr").ShowNormalTips(l_tipsStr)
                return
            end
            self:SetOnlyWordsPanle(dataTable, function(Id)
                self:CloseReleateTips()
                MgrMgr:GetMgr("AchievementMgr").OpenAchievementPanel(Id)
            end)
        end
    end
    self:InsertDataToAchievement(l_achieveMentFuncId,l_funcName, l_showPlaceName, nil, l_atlas, l_icon, false, false, l_showBtnFunc)
end

--典藏值
function ItemAchieveTipsNewCtrl:SetGarderobeAward(GargerobeIdData)
    local l_garderobeFuncId = MgrMgr:GetMgr("OpenSystemMgr").eSystemId.GarderobeAward
    local l_atlas, l_icon = Common.CommonUIFunc.GetFuncAtlasAndIconByFuncId(l_garderobeFuncId)
    local l_isOpen, l_openBaseLv,l_showStr,l_tipsStr = Common.CommonUIFunc.GetFunctionIsOpenAndOpenLevelByFuncId(l_garderobeFuncId)
    local l_funcName = Common.CommonUIFunc.GetFuncNameByFuncId(l_garderobeFuncId)
    local l_showPlaceName = ""
    local l_showBtnFunc = nil
    if not l_isOpen then
        l_showPlaceName = l_showStr
    end
    l_showBtnFunc = function()
        if not l_isOpen then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(l_tipsStr)
            return
        end
        self:CloseReleateTips()
        UIMgr:ActiveUI(UI.CtrlNames.Garderobe, { gardeorbeAwardId = GargerobeIdData[1] })
    end
    self:InsertDataToAchievement(l_garderobeFuncId,l_funcName, l_showPlaceName, nil, l_atlas, l_icon, false, false, l_showBtnFunc)
end

--设置礼包奖励获得
function ItemAchieveTipsNewCtrl:SetAwardPack(ItemIdData)
    for key, value in pairs(ItemIdData) do
        local l_itemData = TableUtil.GetItemTable().GetRowByItemID(value)
        l_showBtnFunc = function()
            --self:CloseReleateTips()
            MgrMgr:GetMgr("ItemTipsMgr").ShowTipsDisplayWithId(value,nil,nil,nil,true)
        end
        self:InsertDataToAchievement(l_openSystemMgr.eSystemId.PackageDrap,l_itemData.ItemName, "", nil, l_itemData.ItemAtlas, l_itemData.ItemIcon, false, false, l_showBtnFunc)
    end
end

--成就等级奖励
function ItemAchieveTipsNewCtrl:SetAchievementBadgeTable(AchievementBadgeDataTable)
    local l_achieveMentFuncId = MgrMgr:GetMgr("OpenSystemMgr").eSystemId.AchievementLevel
    local l_atlas, l_icon = Common.CommonUIFunc.GetFuncAtlasAndIconByFuncId(l_achieveMentFuncId)
    local l_isOpen, l_openBaseLv,l_showStr,l_tipsStr = Common.CommonUIFunc.GetFunctionIsOpenAndOpenLevelByFuncId(l_achieveMentFuncId)
    local l_funcName = Common.CommonUIFunc.GetFuncNameByFuncId(l_achieveMentFuncId)
    local l_showPlaceName = ""
    local l_showBtnFunc = nil
    if not l_isOpen then
        l_showPlaceName = l_showStr
    end
    if table.maxn(AchievementBadgeDataTable) == 1 then
        l_showBtnFunc = function()
            if not l_isOpen then
                MgrMgr:GetMgr("TipsMgr").ShowNormalTips(l_tipsStr)
                return
            end
            self:CloseReleateTips()
            MgrMgr:GetMgr("AchievementMgr").OpenAchievementPanel(nil, true, AchievementBadgeDataTable[1])
        end
    else
        local finStr = ""
        local dataTable = {}
        for i = 1, table.maxn(AchievementBadgeDataTable) do
            local l_achievementBadgeInfo = TableUtil.GetAchievementBadgeTable().GetRowByLevel(AchievementBadgeDataTable[i])
            finStr = finStr .. " " .. l_achievementBadgeInfo.Name
            local tempAchievementTb = { Id = AchievementBadgeDataTable[i], Name = l_achievementBadgeInfo.Name }
            table.insert(dataTable, tempAchievementTb)
        end
        l_showPlaceName = finStr
        l_showBtnFunc = function()
            if not l_isOpen then
                MgrMgr:GetMgr("TipsMgr").ShowNormalTips(l_tipsStr)
                return
            end
            self:SetOnlyWordsPanle(dataTable, function(Id)
                self:CloseReleateTips()
                MgrMgr:GetMgr("AchievementMgr").OpenAchievementPanel(nil, true, Id)
            end)
        end
    end
    self:InsertDataToAchievement(l_achieveMentFuncId,l_funcName, l_showPlaceName, nil, l_atlas, l_icon, false, false, l_showBtnFunc)
end

function ItemAchieveTipsNewCtrl:SetToTargetpanel()
    self.panel.ItemAchievePanel.gameObject:SetActiveEx(false)
    self.panel.TargetPanel.gameObject:SetActiveEx(true)
end

function ItemAchieveTipsNewCtrl:NormalClick(sceneID, pos, arriveFun, cancelFunc, dataTb)
    if pos == nil or sceneID == nil then
        logError("SceneID or Pos == nil @maxin")
        self:ClosePanel()
        return
    end

    if Common.CommonUIFunc.CheckScene(sceneID) then
        game:ShowMainPanel()
        if dataTb and dataTb.preCheckTb and dataTb.preCheckTb.state then
            local func = dataTb.preCheckTb.func(dataTb.itemId)
            if dataTb.preCheckTb.func(dataTb.itemId) then
                MTransferMgr:GotoPosition(sceneID, pos, arriveFun, cancelFunc)
            end
        else
            MTransferMgr:GotoPosition(sceneID, pos, arriveFun, cancelFunc)
		end
	end
	self:ClosePanel()
end

function ItemAchieveTipsNewCtrl:SetPlacePanle(SceneTb, PosTb, ArriveFun, CancelFunc, dataTb)
    self.targetPlaceDataTb = {}
    self:SetToTargetpanel()
	for i = 1, table.maxn(SceneTb) do
		local l_isDungeon = Common.CommonUIFunc.IsDungonBySceneId(SceneTb[i])
        if not l_isDungeon then
            local l_btnFunc = function()
                local l_GotoPosFunc = function ()
                    MTransferMgr:GotoPosition(SceneTb[i], PosTb[i],
                    function()
                        if ArriveFun then
                            ArriveFun()
                        end
                    end,
                    function()
                        if CancelFunc then
                            CancelFunc()
                        end
                    end)
                end
                if Common.CommonUIFunc.CheckScene(SceneTb[i]) then
                    if dataTb and dataTb.preCheckTb and dataTb.preCheckTb.state then
                        if dataTb.preCheckTb.func and dataTb.preCheckTb.func(dataTb.itemId) then
							l_GotoPosFunc()
                        end
					else
						l_GotoPosFunc()
                    end
                    game:ShowMainPanel()
				end
				self:ClosePanel()
            end
            self:InsertDataToTargetPlace(Common.CommonUIFunc.GetSceneNameBySceneId(SceneTb[i]), l_btnFunc)
        end
    end
	self.ItemTargetTplPool:ShowTemplates({Datas = self.targetPlaceDataTb})
end

--设置只有文本的点击面板
function ItemAchieveTipsNewCtrl:SetOnlyWordsPanle(DataTb, ClickFunc)
    self.targetPlaceDataTb = {}
    self:SetToTargetpanel()
    for i = 1, table.maxn(DataTb) do
        local l_btnFunc = function()
            self:ClosePanel()
            ClickFunc(DataTb[i].Id)
        end
        self:InsertDataToTargetPlace(DataTb[i].Name, l_btnFunc)
    end
    self.ItemTargetTplPool:ShowTemplates({Datas = self.targetPlaceDataTb})
end

--设置副本地址
function ItemAchieveTipsNewCtrl:SetDungonPlacePanle(SceneTb, PosTb, NpcId)
    self:SetToTargetpanel()
    for i = 1, table.maxn(SceneTb) do
        if Common.CommonUIFunc.IsDungonBySceneId(SceneTb[i]) == false then
            local btnFunc = function()
                if Common.CommonUIFunc.CheckScene(SceneTb[i]) then
                    local l_Func = function()
                        MgrMgr:GetMgr("NpcMgr").TalkWithNpc(SceneTb[i], NpcId)
                    end
                    MTransferMgr:GotoPosition(SceneTb[i], PosTb[i], l_Func)
                    game:ShowMainPanel()
                    self:ClosePanel()
                else
                    self:ClosePanel()
                end
            end
            self:InsertDataToTargetPlace(Common.CommonUIFunc.GetSceneNameBySceneId(SceneTb[i]), btnFunc)
        end
    end
    self.ItemTargetTplPool:ShowTemplates({Datas = self.targetPlaceDataTb})
end

--处理没有Npc的功能的点击回调
function ItemAchieveTipsNewCtrl:SetNoNpcFunc(itemId, openType, functionId)
    local l_method = MgrMgr:GetMgr("SystemFunctionEventMgr").GetItemAchieveMethod(functionId)
    local l_dataTb = {}
    l_dataTb.npcId = nil
    l_dataTb.itemId = itemId
    l_dataTb.functionId = functionId
    if openType ~= Common.CommonUIFunc.FuncOpenType.Npc then
        if l_method ~= nil then
            self:CloseReleateTips()
            l_method(l_dataTb)
        end
    end
end

--这个是一个该功能只存在于一个独立场景的处理
function ItemAchieveTipsNewCtrl:SetNormalArriveFunc(tableData, itemId, openType, functionId)
    local l_method = MgrMgr:GetMgr("SystemFunctionEventMgr").GetItemAchieveMethod(functionId)
    for i, v in pairs(tableData) do
        local l_dataTb = {}
        l_dataTb.npcId = i
        l_dataTb.itemId = itemId
        l_dataTb.sceneId = v.sceneTb[1]
        l_dataTb.preCheckTb = v.preCheckTb --保存是否需要预先判断 例如 锻造在点击前要判断 能不能精炼
        local l_onArriveFunc = v.noFunc or function()
            l_method(l_dataTb)
        end
		local l_onCancelFunc = function()
			
        end
        if v.sceneTb[1] ~= nil then
            if openType == Common.CommonUIFunc.FuncOpenType.Npc then
                self:NormalClick(v.sceneTb[1], v.posTb[1], l_onArriveFunc, l_onCancelFunc, l_dataTb)
            else
                if l_method ~= nil then
                    self:CloseReleateTips()
                    l_method(l_dataTb)
                end
            end
            break
        end
    end
end

--这个是一个该功能存在于多个独立场景的处理
function ItemAchieveTipsNewCtrl:SetPlaceGetArriveFunc(tableData, itemId, functionId)
    local l_method = MgrMgr:GetMgr("SystemFunctionEventMgr").GetItemAchieveMethod(functionId)
    for i, v in pairs(tableData) do
        local l_dataTb = {}
        l_dataTb.npcId = i
        l_dataTb.itemId = itemId
        l_dataTb.sceneId = v.sceneTb[1]
        l_dataTb.preCheckTb = v.preCheckTb
        local l_onArriveFunc = v.noFunc or function()
            l_method(l_dataTb)
        end
        local l_onCancelFunc = function()
        end
        self:SetPlacePanle(v.sceneTb, v.posTb, l_onArriveFunc, l_onCancelFunc, l_dataTb)
    end
end

function ItemAchieveTipsNewCtrl:ClosePanel()
    UIMgr:DeActiveUI(UI.CtrlNames.ItemAchieveTipsNew)
end

function ItemAchieveTipsNewCtrl:CloseReleateTips()
    UIMgr:DeActiveUI(UI.CtrlNames.ItemAchieveTipsNew)
    UIMgr:DeActiveUI(UI.CtrlNames.CommonItemTips)
    UIMgr:DeActiveUI(UI.CtrlNames.ComsumeDialog)
    UIMgr:DeActiveUI(UI.CtrlNames.ConsumeChooseDialog)
    UIMgr:DeActiveUI(UI.CtrlNames.AdventureDiaryTask)
end

function ItemAchieveTipsNewCtrl:SetSelfPos(pos)
    if self.panel.ItemAchievePanel ~= nil and pos ~= nil then
        self.panel.ItemAchievePanel.RectTransform.localPosition = pos
    end
end

--lua custom scripts end
return ItemAchieveTipsNewCtrl