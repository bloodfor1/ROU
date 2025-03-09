--this file is gen by script
--you can edit this file in custom part

--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/BagPanel"
require "Data/Model/BagModel"
require "ModuleMgr/ShortCutItemMgr"
require "UI/Template/PotPageTemplate"
require "UI/Template/ItemTemplate"
require "UI/Template/ItemBagTemplate"
require "UI/Template/ItemPotTemplate"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua class define
local super = UI.UIBaseCtrl
BagCtrl = class("BagCtrl", super)
local quickPageCount = 2
local quickSlotCount = 4

-- 道具tog TogProp
-- 仓库tog TogPot
-- 快捷栏 PanelQuick
-- 仓库按钮 BtnPot
-- 装备按钮 BtnWeapon
-- 仓库 PanelPot
-- 装备 PanelWeapon
-- 道具滚条 ScrollProp

local l_showWeapon = false --是否左侧是有人物的装备界面
local l_showPot = false    --是否左侧是仓库
local l_showQuick = false  --是否打开了快捷栏
-------------------------------prop
local l_propSelected = -1
local l_prop2doTime = 0
local l_2doGapTime = 0.3
local l_propLongPos
local l_propLongId = -1
local l_propLongTime = 0
local l_propLongMax = 0.4
local l_propDragGo
local l_propPoint = -1
local l_btnSorts
----------------------pot
local l_potSelected = -1
local l_pot2doTime = 0
local l_potLongPos
local l_potLongId = -1
local l_potLongTime = 0
local l_potLongMax = 0.4
local l_potDragGo
local l_potPoint = -1
-----------------------weapon
local l_specialTogs = {}
local l_weaponImg = {}
local l_weaponImgOrg = {}
local l_weaponPoint = -1
-----------------------quick
local l_quickEnter = -1
local l_quickLongId = -1
local l_quickLongTime = 0
local l_quickLongMax = 0.4
local l_quickLongPos
local l_quickDragGo
----------------------cd
local l_preCdTime = 0
local l_cdInterval = 1
------------------------eventsystem
local l_pointEventData
local l_eventSystem
local l_pointRes
------------------------model
local l_model = nil
local attr = nil
-----------------------------------

--lua class define end

--lua functions
function BagCtrl:ctor()
    super.ctor(self, CtrlNames.Bag, UILayer.Function, UITweenType.UpAlpha, ActiveType.Exclusive)
    self.cacheGrade = EUICacheLv.VeryLow
    self.IsGroup = true
    self._currentSelectPage = GameEnum.EBagPageIdxType.None
end --func end

--next--
function BagCtrl:Init()
    self.panel = UI.BagPanel.Bind(self)
    super.Init(self)
    --- 3渲2 延迟的帧数
    self._renderNextFrame = 0
    --- 每一帧为装备位setData的数量
    self._setEquipDataPerFrame = 3
    --- 每一帧创建装备槽位的数量
    self._createEquipSlotPerFrame = 2
    --- 装备位进行setData操作的时候出现的问题
    ---@type table<number, EquipSlotUICache>
    self._equipSlotDataCache = {}
    --- 装备页上的ItemTemplate所对应的类型和父节点transform的映射关系
    self._equipSlotTypeTransFormMap = {
        [Data.BagModel.WeapType.Head] = self.panel.ImgHead.Transform,
        [Data.BagModel.WeapType.Mouth] = self.panel.ImgMouth.Transform,
        [Data.BagModel.WeapType.MainWeapon] = self.panel.ImgMainWeap.Transform,
        [Data.BagModel.WeapType.Cloak] = self.panel.ImgCloak.Transform,
        [Data.BagModel.WeapType.OrnaL] = self.panel.ImgOrnaL.Transform,
        [Data.BagModel.WeapType.Face] = self.panel.ImgFace.Transform,
        [Data.BagModel.WeapType.Cloth] = self.panel.ImgCloth.Transform,
        [Data.BagModel.WeapType.Assist] = self.panel.ImgAssist.Transform,
        [Data.BagModel.WeapType.Shoe] = self.panel.ImgShoe.Transform,
        [Data.BagModel.WeapType.OrnaR] = self.panel.ImgOrnaR.Transform,
        [Data.BagModel.WeapType.Back] = self.panel.ImgBack.Transform,
        [Data.BagModel.WeapType.Ride] = self.panel.ImgRide.Transform,
        [Data.BagModel.WeapType.TROLLEY] = self.panel.ImgBarrow.Transform,
        [Data.BagModel.WeapType.BattleHorse] = self.panel.ImgBattleVehicle.Transform,
        [Data.BagModel.WeapType.BattleBird] = self.panel.ImgBattleBird.Transform,
        [Data.BagModel.WeapType.Fashion] = self.panel.ImgFashion.Transform,
    }

    --- 会引起模型刷新的槽位类型
    self.C_VALID_MODEL_UPDATE_SLOT_TYPE = {
        [GameEnum.EEquipSlotIdxType.MainWeapon] = 1,
        [GameEnum.EEquipSlotIdxType.Helmet] = 1,
        [GameEnum.EEquipSlotIdxType.MouthGear] = 1,
        [GameEnum.EEquipSlotIdxType.FaceGear] = 1,
        [GameEnum.EEquipSlotIdxType.BackGear] = 1,
    }

    self._bagSlotCount = MGlobalConfig:GetInt("BagMaxBlank")
    l_eventSystem = EventSystem.current
    l_pointEventData = PointerEventData.New(l_eventSystem)
    l_pointRes = RaycastResultList.New()
    self._multiTalentsSelectTemplate = self:NewTemplate("MultiTalentsSelectTemplate", {
        TemplateParent = self.panel.MultiTalentsSelectButtonParent.transform
    })

    self.propTemplatePool = self:NewTemplatePool({
        UITemplateClass = UITemplate.ItemBagTemplate,
        ScrollRect = self.panel.ScrollProp.LoopScroll,
        SetCountPerFrame = 5,
        CreateObjPerFrame = 2,
        GetDatasMethod = MgrProxy:GetBagMgr().GetFiltrateItemsInBag,
    })

    self.potTemplatePool = self:NewTemplatePool({
        UITemplateClass = UITemplate.ItemPotTemplate,
        ScrollRect = self.panel.ScrollPot.LoopScroll,
        SetCountPerFrame = 3,
        CreateObjPerFrame = 2,
        GetDatasMethod = MgrProxy:GetBagMgr().GetWareHousePageItemList,
    })

    self.potPageTemplatePool = self:NewTemplatePool({
        UITemplateClass = UITemplate.PotPageTemplate,
        ScrollRect = self.panel.PanelPotPage.LoopScroll,
        TemplatePrefab = self.panel.PotPagePrefab.PrefabPotPage.gameObject
    })

    self.panel.BtnPot:AddClickWithLuaSelf(self.ShowPotPanel, self)
    self.panel.BtnWeapon:AddClickWithLuaSelf(self.ShowWeaponPanel, self)
    self.panel.BtnQuickClose:AddClickWithLuaSelf(self.HidePanelQuick, self)
    self.panel.BtnQuickOpen:AddClickWithLuaSelf(self._onQuickBtnClick, self)
    self.panel.RecycleItemsButton:AddClickWithLuaSelf(self._onRecycleItemClick, self)
    self.panel.BtnNowPage:AddClickWithLuaSelf(self._onBtnNowClick, self)
    self.panel.BtnSort3:AddClickWithLuaSelf(self._onWareHousePageSortClick, self)
    self.panel.ClosePotButton:AddClickWithLuaSelf(self._onCloseWareHousePageClick, self)

    --整理按钮监听
    l_btnSorts = {}
    l_btnSorts[1] = self.panel.BtnSort1
    l_btnSorts[2] = self.panel.BtnSort2

    for i = 1, #l_btnSorts do
        l_btnSorts[i]:AddClickWithLuaSelf(self._onBtnSortClick, self)
    end

    --托盘
    local l_dscale = Data.BagModel:getDragScale()
    MLuaCommonHelper.SetLocalScale(self.panel.PanelDrag.gameObject, l_dscale.x, l_dscale.y, l_dscale.z)

    l_weaponImgOrg[Data.BagModel.WeapType.Head] = self.panel.ImgHeadOrg
    l_weaponImgOrg[Data.BagModel.WeapType.Mouth] = self.panel.ImgMouthOrg
    l_weaponImgOrg[Data.BagModel.WeapType.MainWeapon] = self.panel.ImgMainWeapOrg
    l_weaponImgOrg[Data.BagModel.WeapType.Cloak] = self.panel.ImgCloakOrg
    l_weaponImgOrg[Data.BagModel.WeapType.OrnaL] = self.panel.ImgOrnaLOrg
    l_weaponImgOrg[Data.BagModel.WeapType.Face] = self.panel.ImgFaceOrg
    l_weaponImgOrg[Data.BagModel.WeapType.Cloth] = self.panel.ImgClothOrg
    l_weaponImgOrg[Data.BagModel.WeapType.Assist] = self.panel.ImgAssistOrg
    l_weaponImgOrg[Data.BagModel.WeapType.Shoe] = self.panel.ImgShoeOrg
    l_weaponImgOrg[Data.BagModel.WeapType.OrnaR] = self.panel.ImgOrnaROrg
    l_weaponImgOrg[Data.BagModel.WeapType.Back] = self.panel.ImgBackOrg
    l_weaponImgOrg[Data.BagModel.WeapType.Ride] = self.panel.ImgRideOrg
    l_weaponImgOrg[Data.BagModel.WeapType.TROLLEY] = self.panel.ImgBarrowOrg
    l_weaponImgOrg[Data.BagModel.WeapType.BattleHorse] = self.panel.ImgBattleVehicleOrg
    l_weaponImgOrg[Data.BagModel.WeapType.BattleBird] = self.panel.ImgBattleBirdOrg
    l_weaponImgOrg[Data.BagModel.WeapType.Fashion] = self.panel.ImgFashionOrg

    --几种根据职业特性显示的Tog定义
    l_specialTogs[Data.BagModel.WeapType.Ride] = self.panel.TogRide
    l_specialTogs[Data.BagModel.WeapType.TROLLEY] = self.panel.TogBarrow
    l_specialTogs[Data.BagModel.WeapType.BattleHorse] = self.panel.TogBattleVehicle
    l_specialTogs[Data.BagModel.WeapType.BattleBird] = self.panel.TogBattleBird

    self.panel.TogHead:OnToggleChanged(function(value)
        if value == true then
            l_weaponPoint = Data.BagModel.WeapType.Head
            local l_info = Data.BagApi:GetItemByTypeSlot(GameEnum.EBagContainerType.Equip, l_weaponPoint + 1)
            self:_gotoShowOtherEquip(l_weaponPoint)
            self:ShowWeaponPropTip(l_info)
        end
    end)

    self.panel.TogMouth:OnToggleChanged(function(value)
        if value == true then
            l_weaponPoint = Data.BagModel.WeapType.Mouth
            local l_info = Data.BagApi:GetItemByTypeSlot(GameEnum.EBagContainerType.Equip, l_weaponPoint + 1)
            self:_gotoShowOtherEquip(l_weaponPoint)
            self:ShowWeaponPropTip(l_info)
        end
    end)

    self.panel.TogMainWeap:OnToggleChanged(function(value)
        if value == true then
            l_weaponPoint = Data.BagModel.WeapType.MainWeapon
            local l_info = Data.BagApi:GetItemByTypeSlot(GameEnum.EBagContainerType.Equip, l_weaponPoint + 1)
            self:_gotoShowOtherEquip(l_weaponPoint)
            self:ShowWeaponPropTip(l_info)
        end
    end)

    self.panel.TogCloak:OnToggleChanged(function(value)
        if value == true then
            l_weaponPoint = Data.BagModel.WeapType.Cloak
            local l_info = Data.BagApi:GetItemByTypeSlot(GameEnum.EBagContainerType.Equip, l_weaponPoint + 1)
            self:_gotoShowOtherEquip(l_weaponPoint)
            self:ShowWeaponPropTip(l_info)
        end
    end)

    self.panel.TogOrnaL:OnToggleChanged(function(value)
        if value == true then
            l_weaponPoint = Data.BagModel.WeapType.OrnaL
            local l_info = Data.BagApi:GetItemByTypeSlot(GameEnum.EBagContainerType.Equip, l_weaponPoint + 1)
            self:_gotoShowOtherEquip(l_weaponPoint)
            self:ShowWeaponPropTip(l_info)
        end
    end)

    self.panel.TogFace:OnToggleChanged(function(value)
        if value == true then
            l_weaponPoint = Data.BagModel.WeapType.Face
            local l_info = Data.BagApi:GetItemByTypeSlot(GameEnum.EBagContainerType.Equip, l_weaponPoint + 1)
            self:_gotoShowOtherEquip(l_weaponPoint)
            self:ShowWeaponPropTip(l_info)
        end
    end)

    self.panel.TogCloth:OnToggleChanged(function(value)
        if value == true then
            l_weaponPoint = Data.BagModel.WeapType.Cloth
            local l_info = Data.BagApi:GetItemByTypeSlot(GameEnum.EBagContainerType.Equip, l_weaponPoint + 1)
            self:_gotoShowOtherEquip(l_weaponPoint)
            self:ShowWeaponPropTip(l_info)
        end
    end)

    self.panel.TogAssist:OnToggleChanged(function(value)
        if value == true then
            l_weaponPoint = Data.BagModel.WeapType.Assist
            local l_info = Data.BagApi:GetItemByTypeSlot(GameEnum.EBagContainerType.Equip, l_weaponPoint + 1)
            self:_gotoShowOtherEquip(l_weaponPoint)
            if l_info then
                self:ShowWeaponPropTip(l_info)
            else
                local l_mainInfo = Data.BagApi:GetItemByTypeSlot(GameEnum.EBagContainerType.Equip, Data.BagModel.WeapType.MainWeapon + 1)
                if l_mainInfo then
                    local l_HoldingMode = MgrMgr:GetMgr("EquipMgr").GetEquipHoldingModeById(l_mainInfo.TID)
                    if l_HoldingMode == MgrMgr:GetMgr("EquipMgr").HoldingModeDoubleHand then
                        l_weaponPoint = Data.BagModel.WeapType.MainWeapon
                        self:ShowWeaponPropTip(l_mainInfo)
                    end
                end
            end
        end
    end)

    self.panel.TogShoe:OnToggleChanged(function(value)
        if value == true then
            l_weaponPoint = Data.BagModel.WeapType.Shoe
            local l_info = Data.BagApi:GetItemByTypeSlot(GameEnum.EBagContainerType.Equip, l_weaponPoint + 1)
            self:_gotoShowOtherEquip(l_weaponPoint)
            self:ShowWeaponPropTip(l_info)
        end
    end)

    self.panel.TogOrnaR:OnToggleChanged(function(value)
        if value == true then
            l_weaponPoint = Data.BagModel.WeapType.OrnaR
            local l_info = Data.BagApi:GetItemByTypeSlot(GameEnum.EBagContainerType.Equip, l_weaponPoint + 1)
            self:_gotoShowOtherEquip(l_weaponPoint)
            self:ShowWeaponPropTip(l_info)
        end
    end)

    self.panel.TogBack:OnToggleChanged(function(value)
        if value == true then
            l_weaponPoint = Data.BagModel.WeapType.Back
            local l_info = Data.BagApi:GetItemByTypeSlot(GameEnum.EBagContainerType.Equip, l_weaponPoint + 1)
            self:_gotoShowOtherEquip(l_weaponPoint)
            self:ShowWeaponPropTip(l_info)
        end
    end)

    self.panel.TogFashion:OnToggleChanged(function(value)
        if value == true then
            l_weaponPoint = Data.BagModel.WeapType.Fashion
            local l_info = Data.BagApi:GetItemByTypeSlot(GameEnum.EBagContainerType.Equip, l_weaponPoint + 1)
            self:_gotoShowOtherEquip(l_weaponPoint)
            self:ShowWeaponPropTip(l_info)
        end
    end)

    self.panel.TogRide:OnToggleChanged(function(value)
        if value == true then
            l_weaponPoint = Data.BagModel.WeapType.Ride
            local l_info = Data.BagApi:GetItemByTypeSlot(GameEnum.EBagContainerType.Equip, l_weaponPoint + 1)
            self:ShowWeaponPropTip(l_info)
        end
    end)

    self.panel.TogBeiluz:OnToggleChanged(function(value)
        if value == true then
            local openSysMgr = MgrMgr:GetMgr("OpenSystemMgr")
            if openSysMgr.IsSystemOpen(openSysMgr.eSystemId.Beiluz) then
                UIMgr:ActiveUI(UI.CtrlNames.BeiluzCore)
            elseif openSysMgr.IsCanPreview(openSysMgr.eSystemId.Beiluz) then
                MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("WHEEL_FUNC_LOCK", openSysMgr.GetSystemOpenBaseLv(openSysMgr.eSystemId.Beiluz)))
            end
        end
    end, false)

    --一个通用的判断装载的逻辑
    --参数1 tog的Value
    --参数2 装备的位置
    --参数3 需要学习的前置技能
    --参数4 跳转的FuncId
    --参数4 跳转前二次确认框的文本
    local CheckFunc = function(togValue, weaponPoint, needLearnSkillID, funcId, goToTitle)
        if togValue == true then
            l_weaponPoint = weaponPoint
            local l_info = Data.BagApi:GetItemByTypeSlot(GameEnum.EBagContainerType.Equip, l_weaponPoint + 1)
            if l_info then
                -- self:ShowWeaponPropTip(l_info)
                MgrMgr:GetMgr("ItemTipsMgr").ShowTipsDisplayWithInfo(
                        l_info,
                        nil,
                        Data.BagModel.WeaponStatus.ON_BODY,
                        nil)
            else
                local isLearnSkill = MPlayerInfo:GetCurrentSkillInfo(needLearnSkillID).lv > 0
                if isLearnSkill then
                    --学习前置技能但没有这个道具
                    local confirmFunc = function()
                        --寻路成功才关闭对应界面
                        local l_result = Common.CommonUIFunc.InvokeFunctionByFuncId(funcId, nil, true)
                        if l_result then
                            UIMgr:DeActiveUI(UI.CtrlNames.Bag)
                        end
                    end

                    CommonUI.Dialog.ShowYesNoDlg(true, nil, goToTitle, confirmFunc, nil)
                else
                    --没有学习技能 提示并打开界面
                    l_skill = TableUtil.GetSkillTable().GetRowById(needLearnSkillID)
                    if l_skill == nil then
                        logError("SkillTable not have" .. needLearnSkillID)
                        return
                    end

                    MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("NEED_LEARNSKILL", l_skill.Name))
                    UIMgr:ActiveUI(UI.CtrlNames.SkillLearning)
                end
            end
        end
    end

    --手推车特殊处理
    self.panel.TogBarrow:OnToggleChanged(function(value)
        CheckFunc(value,
                Data.BagModel.WeapType.TROLLEY,
                600012,
                MgrMgr:GetMgr("OpenSystemMgr").eSystemId.TrolleyFuncId,
                Common.Utils.Lang("NONE_BARROW"))
    end)

    --战斗坐骑特殊处理
    self.panel.TogBattleVehicle:OnToggleChanged(function(value)
        CheckFunc(value,
                Data.BagModel.WeapType.BattleHorse,
                210106,
                MgrMgr:GetMgr("OpenSystemMgr").eSystemId.BattleVehicleFuncId,
                Common.Utils.Lang("NONE_BATTLEVEHICLE"))
    end)

    --猎人的鸟特殊处理
    self.panel.TogBattleBird:OnToggleChanged(function(value)
        CheckFunc(value,
                Data.BagModel.WeapType.BattleBird,
                710106,
                MgrMgr:GetMgr("OpenSystemMgr").eSystemId.BattleBirdFuncId,
                Common.Utils.Lang("NONE_BATTLEBIRD"))
    end)

    --处理快捷栏
    local objs = GameObjectList.New()
    for i, v in ipairs(self.panel.PageItems) do
        objs:Add(v.UObj)
    end

    self.panel.PageView.PageView.OnPageChanged = function(idx)
        idx = idx + 1
        for i, v in ipairs(self.panel.PageMark) do
            if i == idx then
                v.Img.color = Color.New(255 / 255.0, 255 / 255.0, 255 / 255.0, 1)
            else
                v.Img.color = Color.New(195 / 255.0, 214 / 255.0, 250 / 255.0, 1)
            end

            v:SetSprite("Common1", i == idx and "UI_Common_Switch_Foot_01.png" or "UI_Common_Switch_Foot_02.png", true)
        end
    end

    self.panel.PageView.PageView:InitWithTemplates(objs, handler(self, self.OnUpdateItem))
    for i = 1, quickPageCount * quickSlotCount do
        self.panel.BtnQuickKill[i]:AddClick(function()
            local l_info = MgrProxy:GetShortCutItemMgr().GetItemByIdx(i)
            Data.BagApi:ReqSwapItem(l_info.UID, GameEnum.EBagContainerType.Bag, -1, -1)
        end)

        self.panel.TogQuick[i].Listener.onDown = (function(go, eventData)
            if not l_showQuick then
                return
            end

            local l_info = MgrProxy:GetShortCutItemMgr().GetItemByIdx(i)
            if nil == l_info then
                return
            end

            local l_num = Data.BagModel:GetBagItemCountByTid(l_info.TID)
            if 0 >= l_num then
                return
            end

            l_quickLongId = i
            local l_cgPos = MUIManager.UICamera:ScreenToWorldPoint(eventData.position)
            l_cgPos.z = 0
            l_quickLongPos = l_cgPos
        end)

        self.panel.TogQuick[i].Listener.onEnter = (function()
            l_quickEnter = i
            self.panel.TogQuick[i].Tog.isOn = true
        end)

        self.panel.TogQuick[i].Listener.onExit = (function()
            if i == l_quickEnter then
                l_quickEnter = -1
            end
        end)

        MLuaCommonHelper.SetLocalScale(self.panel.ImgQuickItem[i].gameObject, 0.5, 0.5, 1)

        self.panel.TogQuick[i].Listener:SetActionOnDrag(self._onToggleQuickDrag, self)
        self.panel.TogQuick[i].Listener:SetActionEndDrag(self.InitQuickLong, self)
        self.panel.TogQuick[i].Listener:SetActionClick(self.InitQuickLong, self)
    end

    --负重
    self.panel.BtnWeight:AddClickWithLuaSelf(self._onWeightBtnClick, self)
    self.panel.BtnCloseAll:AddClickWithLuaSelf(self._onBagCloseClick, self)
    self.panel.ImgBgWeight.Listener:SetActionButtonDown(self._onWeightBtnDown, self)

    --道具分类
    for i = 1, 5 do
        self.panel.TogBagCly[i]:OnToggleExChanged(function(value)
            if value then
                self:InitPropClf(i - 1)
            end
        end)
    end

    --红点
    self.RedSignProcessor = self:NewRedSign({
        Key = eRedSignKey.BeiluzBag,
        ClickTog = self.panel.TogBeiluz
    })
end --func end

--next--
function BagCtrl:Uninit()
    self.propTemplatePool = nil
    self.potTemplatePool = nil
    self.potPageTemplatePool = nil
    self._multiTalentsSelectTemplate = nil

    super.Uninit(self)
    self.panel = nil
end --func end
--next--
function BagCtrl:_onWeightBtnDown(go, eventData)
    local l_s = Lang("WEIGHT_TIPS")
    if MgrMgr:GetMgr("ItemWeightMgr").IsWeightRed(GameEnum.EBagContainerType.Bag) then
        l_s = l_s .. "\n\n" .. Lang("BEYOND_WEIGHT_TIPS")
    end

    MgrMgr:GetMgr("TipsMgr").ShowQuestionTip(l_s, eventData, Vector2(0.5, 0))
end

function BagCtrl:_onToggleQuickDrag(go, eventData)
    if l_quickDragGo then
        local l_cgPos = MUIManager.UICamera:ScreenToWorldPoint(eventData.position)
        l_cgPos.z = 0
        l_quickDragGo.transform.position = l_cgPos
    end
end

function BagCtrl:_onBagCloseClick()
    self.panel.TogBagCly[1].TogEx.isOn = true
    UIMgr:DeActiveUI(UI.CtrlNames.Bag)
    UIMgr:DeActiveUI(UI.CtrlNames.CommonItemTips)
end

function BagCtrl:_onWeightBtnClick()
    CommonUI.Dialog.ShowConsumeDlg("", Data.BagModel:getAddWeightTipsInfo(),
            function()
                MgrMgr:GetMgr("PropMgr").RequestUnlockBlank(BagType.BAG)
            end, nil, Data.BagModel:getAddWeightConsume())
end

function BagCtrl:_onCloseWareHousePageClick()
    --- 有个坑，这个地方因为先关掉仓库界面的时候，再关掉整个背包页，重新打开，仓库页的高度一瞬间不会被重置
    self.potTemplatePool:DeActiveAll()
    LayoutRebuilder.ForceRebuildLayoutImmediate(self.panel.ScrollPot.LoopScroll.content)
    self:ShowWeaponPanel()
end

function BagCtrl:_onWareHousePageSortClick()
    local currentPage = Data.BagModel:getPotId()
    local targetContType = Data.BagTypeClientSvrMap:GetWareHouseContTypeByIdx(currentPage)
    if Data.BagTypeClientSvrMap:GetInvalidSvrType() == targetContType then
        logError("[BagCtrl] invalid idx: " .. tostring(currentPage))
        return
    end

    Data.BagApi:Sort(targetContType)
    MgrMgr:GetMgr("BagMgr").ForceSetDirty()
    self:FreshPot()
end

function BagCtrl:_onBtnSortClick()
    Data.BagApi:Sort(GameEnum.EBagContainerType.Bag)
    MgrMgr:GetMgr("BagMgr").ForceSetDirty()
    self:FreshProp()
    local l_opM = Data.BagModel:getOpenModel()
    if l_opM == Data.BagModel.OpenModel.Car then
        Data.BagApi:Sort(GameEnum.EBagContainerType.Cart)
        self:FreshPot()
    end
end

function BagCtrl:_onBtnNowClick()
    local pageSwitch = not self.panel.PanelPotPage.gameObject.activeSelf
    self.panel.StorgechangeBg.gameObject:SetActiveEx(pageSwitch)
    self.panel.PanelPotPage.gameObject:SetActiveEx(pageSwitch)
    if self.panel.PanelPotPage.gameObject.activeSelf == true then
        self.potPageTemplatePool:ShowTemplates({
            Datas = {},
            ShowMinCount = Data.BagModel:getPotPageCellNum(),
            StartScrollIndex = 1,
            IsNeedShowCellWithStartIndex = true,
            IsToStartPosition = true,
        })
    end
end

function BagCtrl:_onQuickBtnClick()
    if l_showPot == false then
        self:ShowPanelQuick()
    end
end

function BagCtrl:_onRecycleItemClick()
    MgrMgr:GetMgr("ShopMgr").EventDispatcher:Dispatch(MgrMgr:GetMgr("ShopMgr").RecycleItemsEvent)
end

function BagCtrl:ShowSortBtn(id)
    for i = 1, #l_btnSorts do
        l_btnSorts[i].gameObject:SetActiveEx(false)
    end

    if l_btnSorts[id] ~= nil then
        l_btnSorts[id].gameObject:SetActiveEx(true)
    end
end

function BagCtrl:OnActive()

    MgrMgr:GetMgr("CardExchangeShopMgr").ShowCardDestroyDisplay()
    self.panel.StorgechangeBg.gameObject:SetActiveEx(false)
    self.panel.AssistMask:SetActiveEx(false)
    self.panel.BtnEdiClf.gameObject:SetActiveEx(false)
    self.panel.RecycleItemsButton.gameObject:SetActiveEx(false)
    Data.BagModel:mdPropType(0)
    Data.BagModel:mdPotId(1)
    self.propTemplatePool:ShowTemplates({
        ShowMinCount = self._bagSlotCount
    })

    --初始化显示的item数量
    self:_updateQuickItems()
    self.panel.TogBagCly[1].TogEx.isOn = true

    --最近点中item
    self.propLastPoint = -1
    self:ShowWeaponPanel()
    self:InitSpecialProfessionSlot()
    self.panel.PanelLeft.gameObject:SetActiveEx(true)
    local l_openModel = Data.BagModel:getOpenModel()
    self.panel.BtnSort3.gameObject:SetActiveEx(false)
    self.panel.PanelLeftBg.gameObject:SetActiveEx(false)
    if l_openModel == Data.BagModel.OpenModel.Normal then
        self.panel.BtnPot.gameObject:SetActiveEx(false)
        self:HidePanelQuick()
        self:ShowSortBtn(1)
        self.panel.PanelLeftBg.gameObject:SetActiveEx(true)
        self:ShowBeiluzGuild()
    elseif l_openModel == Data.BagModel.OpenModel.QuickItem then
        self.panel.BtnPot.gameObject:SetActiveEx(false)
        self:ShowPanelQuick()
        self.panel.PanelLeftBg.gameObject:SetActiveEx(true)
    elseif l_openModel == Data.BagModel.OpenModel.Shop or l_openModel == Data.BagModel.OpenModel.Sale then
        MgrProxy:GetBagMgr().ForceSetDirty()
        MgrProxy:GetBagMgr().GetCopies(false)
        self:HideWeaponPanel()
        self:HidePotPanel()
        self.panel.PanelLeft.gameObject:SetActiveEx(false)
        self.panel.BtnQuickOpen.gameObject:SetActiveEx(false)
        self:HidePanelQuick()
        self:ShowSortBtn(0)
        self.panel.BtnQuickOpen.gameObject:SetActiveEx(false)
        if l_openModel == Data.BagModel.OpenModel.Sale then
            self.panel.RecycleItemsButton.gameObject:SetActiveEx(true)
        end
    elseif l_openModel == Data.BagModel.OpenModel.Pot then
        self.potTemplatePool:ShowTemplates({
            ShowMinCount = Data.BagModel:getPotCellNum()
        })
        self:OpenNormalPot()
        self:ShowPotPanel()
        self:HideWeaponPanel()
        self.panel.BtnWeapon.gameObject:SetActiveEx(false)
        self:ShowSortBtn(2)
        self.panel.BtnSort3.gameObject:SetActiveEx(true)
        self.panel.PanelLeftBg.gameObject:SetActiveEx(true)
    elseif l_openModel == Data.BagModel.OpenModel.Car then
        self.potTemplatePool:ShowTemplates({
            ShowMinCount = Data.BagModel:getPotCellNum()
        })
        self:FreshCarWeight()
        self:FreshCarItemNum()
        self:OpenCarPot()
        self:ShowPotPanel()
        self.panel.PanelLeftBg.gameObject:SetActiveEx(true)
    end

    self.potLastPoint = -1
    self:InitPropLong()
    self:InitPotLong()
    self:FreshWeapon()
    self:FreshQuick()
    self:FreshWeight()
    self.panel.PanelDrag.gameObject:SetActiveEx(false)

    --关闭模板
    self.panel.PotPagePrefab.PrefabPotPage.gameObject:SetActiveEx(false)
    self.panel.StorgechangeBg.gameObject:SetActiveEx(false)
    self.panel.PanelPotPage.gameObject:SetActiveEx(false)
    --刷新
    self:CustomRefresh()

    -- 新手引导，全自动守护装置
    if Data.BagModel:GetBagItemCountByTid(MgrMgr:GetMgr("PropMgr").PotionSettingItemId) > 0 then
        MgrMgr:GetMgr("BeginnerGuideMgr").CheckShowBeginnerGuide({ "GetAutoDevOpenBag" }, self:GetPanelName())
        -- 取消红点
        local l_onceSystemMgr = MgrMgr:GetMgr("OnceSystemMgr")
        l_onceSystemMgr.SetOnceState(l_onceSystemMgr.EClientOnceType.PotionSettingItem, nil, true)
        MgrMgr:GetMgr("RedSignMgr").UpdateRedSign(eRedSignKey.BagPotionSetting)
    end

    --新手引导 协同之证
    if MPlayerInfo.AssistCoin > 0 then
        local l_currencyCtrl = UIMgr:GetUI(UI.CtrlNames.Currency)
        if l_currencyCtrl then
            MgrMgr:GetMgr("BeginnerGuideMgr").CheckShowBeginnerGuide({ "AssistGuild1" }, self:GetPanelName(), l_currencyCtrl.overrideSortLayer + 1)
        end
    end
end --func end

function BagCtrl:_updateQuickItems()
    for i = 1, quickPageCount * quickSlotCount do
        local l_qInfo = MgrProxy:GetShortCutItemMgr().GetItemByIdx(i)
        if l_qInfo ~= nil then
            self:ShowQuickItem(i, l_qInfo)
        else
            self:HideQuickItem(i)
        end
    end
end

function BagCtrl:CustomRefresh()
    self._renderNextFrame = 2
end

--next--
function BagCtrl:OnDeActive()
    self.propTemplatePool:StopMovement()
    self.potTemplatePool:StopMovement()

    Data.BagModel:mdOpenModel(Data.BagModel.OpenModel.Normal)

    local gameEventMgr = MgrMgr:GetMgr("GameEventMgr")
    gameEventMgr.RaiseEvent(gameEventMgr.OnShortCutItemUpdate)
end --func end

function BagCtrl:CopyImg(imgOrg, imgDes)
    imgDes.sprite = imgOrg.sprite
    imgDes.material = imgOrg.material
    imgDes.rectTransform.sizeDelta = imgOrg.rectTransform.sizeDelta
    imgDes.transform.localScale = imgOrg.transform.localScale
end

function BagCtrl:InitDrag(itemImg, bg, pg)
    if itemImg == nil then
        self.panel.ImgDrag.gameObject:SetActiveEx(false)
    else
        self:CopyImg(itemImg, self.panel.ImgDrag.Img)
        self.panel.ImgDrag.Img.type = UnityEngine.UI.Image.Type.Simple
        self.panel.ImgDrag.Img.preserveAspect = true
        self.panel.ImgDrag.gameObject:SetActiveEx(true)
    end

    if bg == nil then
        self.panel.ImgDragBg.gameObject:SetActiveEx(false)
    else
        self:CopyImg(bg, self.panel.ImgDragBg.Img)
        self.panel.ImgDragBg.gameObject:SetActiveEx(true)
    end

    if pg == nil then
        self.panel.ImgDragEps.gameObject:SetActiveEx(false)
    else
        self:CopyImg(pg, self.panel.ImgDragEps.Img)
        self.panel.ImgDragEps.gameObject:SetActiveEx(true)
    end
end

--- 分帧给装备位setData
function BagCtrl:_setEquipSlotDataByFrame()
    local setDataCount = 0
    for key, cacheData in pairs(self._equipSlotDataCache) do
        if nil ~= l_weaponImg[cacheData.slotType] then
            setDataCount = setDataCount + 1
            self:_setEquipSlotState(cacheData.slotType, cacheData.itemData, cacheData.showSlot)
            self._equipSlotDataCache[key] = nil
            if setDataCount >= self._setEquipDataPerFrame then
                break
            end
        end
    end
end

--- 分帧创建装备位
function BagCtrl:_createEquipSlotByFrame()
    local createCount = 0
    for key, transform in pairs(self._equipSlotTypeTransFormMap) do
        if nil == l_weaponImg[key] then
            createCount = createCount + 1
            local templateParam = { TemplateParent = transform, IsActive = false }
            l_weaponImg[key] = self:NewTemplate("ItemTemplate", templateParam)
            if createCount >= self._createEquipSlotPerFrame then
                break
            end
        end
    end
end

--- 延迟一帧渲染
function BagCtrl:_delayFrameRender()
    if MPlayerInfo and MPlayerInfo.ProID and MPlayerInfo.ProID ~= 0 and l_showWeapon == true then
        self:InitShowRole()
    end
end

--- 根据延迟帧数来刷新角色三渲二
function BagCtrl:_refreshRenderOnUpdate()
    if 0 < self._renderNextFrame then
        self._renderNextFrame = self._renderNextFrame - 1
        if 0 >= self._renderNextFrame then
            self:_delayFrameRender()
        end
    end
end

function BagCtrl:Update()
    if self.panel == nil then
        return
    end

    if self._multiTalentsSelectTemplate then
        self._multiTalentsSelectTemplate:UpdateSingleTemplate()
    end

    self.propTemplatePool:OnUpdate()
    self.potTemplatePool:OnUpdate()
    self:_refreshRenderOnUpdate()
    self:_createEquipSlotByFrame()
    self:_setEquipSlotDataByFrame()

    if l_propSelected ~= -1 then
        l_prop2doTime = l_prop2doTime + Time.deltaTime
        if l_prop2doTime > l_2doGapTime then
            InitProp2do()
        end
    end

    if l_showQuick == true or l_showPot == true then
        if l_propLongId ~= -1 then
            l_propLongTime = l_propLongTime + Time.deltaTime
            if l_propLongTime > l_propLongMax then
                if l_propDragGo == nil then
                    l_propDragGo = self.panel.PanelDrag.gameObject
                    -- todo 这个做法有问题，不应该获取UI类上的数据，这里可能存在无法获取到的情况，所以要做个保护
                    local l_it = self.propTemplatePool:GetItem(l_propLongId)
                    if nil ~= l_it then
                        if l_it.ShowData ~= nil and l_it.ShowData.ItemConfig.TypeTab == Data.BagModel.PropType.Card then
                            self:InitDrag(l_it.Parameter.ItemIcon.Img,
                                    l_it.Parameter.ItemButton.Img,
                                    l_it.cardPart and l_it.cardPart.Parameter.EquipPositionIcon.Img)
                        else
                            self:InitDrag(l_it.Parameter.ItemIcon.Img,
                                    l_it.Parameter.ItemButton.Img)
                        end
                    end

                    l_propDragGo.transform.position = l_propLongPos
                    l_propDragGo:SetActiveEx(true)
                    self:SetAlphaProp(l_propLongId, 0.5)
                end
            end
        end

        if l_showQuick == true and l_quickLongId ~= -1 then
            l_quickLongTime = l_quickLongTime + Time.deltaTime
            if l_quickLongTime > l_quickLongMax then
                if not l_quickDragGo then
                    l_quickDragGo = self.panel.PanelDrag.gameObject
                    self.panel.ImgDrag.Img.sprite = self.panel.ImgQuickItem[l_quickLongId].Img.sprite
                    self.panel.ImgDrag.Img.material = self.panel.ImgQuickItem[l_quickLongId].Img.material
                    self.panel.ImgDrag.Img:SetNativeSize()
                    l_quickDragGo.transform.position = l_quickLongPos
                    l_quickDragGo:SetActiveEx(true)
                    self:SetAlphaQuick(l_quickLongId, 1)
                end
            end
        end

    end

    if l_potSelected ~= -1 then
        l_pot2doTime = l_pot2doTime + Time.deltaTime
        if l_pot2doTime > l_2doGapTime then
            InitPot2do()
        end
    end

    if l_potLongId ~= -1 then
        l_potLongTime = l_potLongTime + Time.deltaTime
        if l_potLongTime > l_potLongMax then
            if l_potDragGo == nil then
                l_potDragGo = self.panel.PanelDrag.gameObject
                local l_it = self.potTemplatePool:GetItem(l_potLongId)

                if l_it.ShowData ~= nil and l_it.ShowData.ItemConfig.TypeTab == Data.BagModel.PropType.Card then
                    self:InitDrag(l_it.Parameter.ItemIcon.Img,
                            l_it.Parameter.ItemButton.Img,
                            l_it.cardPart and l_it.cardPart.Parameter.EquipPositionIcon.Img)
                else
                    self:InitDrag(l_it.Parameter.ItemIcon.Img,
                            l_it.Parameter.ItemButton.Img)
                end

                l_potDragGo.transform.position = l_potLongPos
                l_potDragGo:SetActiveEx(true)
                self:SetAlphaPot(l_potLongId, 0.5)
            end
        end
    end

    l_preCdTime = l_preCdTime + Time.deltaTime
    if l_preCdTime > l_cdInterval then
        l_preCdTime = 0
        self:FreshPropCd()
    end

end --func end

--next--
function BagCtrl:BindEvents()
    local eventDispatcher = MgrMgr:GetMgr("ShopMgr").EventDispatcher
    local addMsg = MgrMgr:GetMgr("ShopMgr").SellCommodityChangeAdd
    local reduceMsg = MgrMgr:GetMgr("ShopMgr").SellCommodityChangeSubtract
    local bagUpdateMsg = MgrProxy:GetGameEventMgr().OnBagUpdate
    local quickUseItemUpdate = MgrProxy:GetGameEventMgr().OnShortCutItemUpdate
    local bagWeightChanged = MgrProxy:GetGameEventMgr().OnW8ChangeConfirm
    local eventNameOpenWareHousePage = MgrProxy:GetGameEventMgr().OnOpenWareHousePage
    local beiluzEffect = MgrProxy:GetGameEventMgr().OnBeiluzEffectChange
    self:BindEvent(eventDispatcher, addMsg, self._onSellAdd, self)
    self:BindEvent(eventDispatcher, reduceMsg, self._onSellReduce, self)
    self:BindEvent(MgrProxy:GetGameEventMgr().l_eventDispatcher, bagUpdateMsg, self._onBagUpdate, self)
    self:BindEvent(MgrProxy:GetGameEventMgr().l_eventDispatcher, quickUseItemUpdate, self.FreshQuick, self)
    self:BindEvent(MgrProxy:GetGameEventMgr().l_eventDispatcher, bagWeightChanged, self._onWeightChanged, self)
    self:BindEvent(MgrProxy:GetGameEventMgr().l_eventDispatcher, eventNameOpenWareHousePage, self._setToWareHousePage, self)
    self:BindEvent(MgrProxy:GetGameEventMgr().l_eventDispatcher, beiluzEffect, self.InitShowRole, self)
end --func end

---@param itemUpdateDataList ItemUpdateData[]
function BagCtrl:_onBagUpdate(itemUpdateDataList)
    self:FreshProp()
    self:FreshPropCd()
    self:FreshPot()
    self:FreshWeapon()
    self:FreshCarWeight()
    self:FreshCarItemNum()
    local refreshModel = false
    for i = 1, #itemUpdateDataList do
        local singleUpdateData = itemUpdateDataList[i]
        if GameEnum.EBagContainerType.Equip == singleUpdateData.OldContType and self:_isItemRefreshModelType(singleUpdateData.OldItem) then
            refreshModel = true
            break
        end

        if GameEnum.EBagContainerType.Equip == singleUpdateData.NewContType and self:_isItemRefreshModelType(singleUpdateData.NewItem) then
            refreshModel = true
            break
        end
    end

    if refreshModel then
        self:CustomRefresh()
    end
end

---@param itemData ItemData
function BagCtrl:_isItemRefreshModelType(itemData)
    if nil == itemData then
        logError("[BagCtrl] invalid param")
        return false
    end

    local itemSlot = Data.BagTypeClientSvrMap:GetClientEquipSlot(itemData.SvrSlot)
    if nil ~= self.C_VALID_MODEL_UPDATE_SLOT_TYPE[itemSlot] then
        return true
    end

    return false
end

function BagCtrl:_onWeightChanged()
    self:FreshWeight()
    self:FreshCarWeight()
    self:FreshCarItemNum()
end

--next--
--lua functions end

--lua custom scripts
--- 道具从背包到商店
---@param sellData SellData
function BagCtrl:_onSellAdd(sellData)
    local itemData = sellData.propInfo
    local count = sellData.count
    local idx = MgrProxy:GetBagMgr().GetIdxByUID(itemData.UID)
    if count >= itemData.ItemCount then
        MgrProxy:GetBagMgr().SetCopyByIdx(idx, nil, -1)
    else
        ---@type SellData
        local copyItemData = MgrProxy:GetBagMgr().GetCopyByIdx(idx)
        copyItemData.count = copyItemData.count - count
        copyItemData.propInfo.ItemCount = copyItemData.count
    end

    self:FreshProp()
end

--- 道具从商店到背包
---@param sellData SellData
function BagCtrl:_onSellReduce(sellData)
    local itemData = sellData.propInfo
    local count = sellData.count
    local idx = MgrProxy:GetBagMgr().GetIdxByUID(itemData.UID)
    if MgrProxy:GetBagMgr().C_INVALID_IDX == idx then
        local copies = MgrProxy:GetBagMgr().GetCopies(true)
        local sellCount = count
        MgrProxy:GetBagMgr().SetCopyByIdx(#copies + 1, itemData, sellCount)
    else
        ---@type SellData
        local copyItemData = MgrProxy:GetBagMgr().GetCopyByIdx(idx)
        copyItemData.count = copyItemData.count + count
        copyItemData.propInfo.ItemCount = copyItemData.count
    end

    self:FreshProp()
end

-- todo UI会创建一个模型，如果UI 3渲2被关掉了，重新打开，是不会渲染上去的。
-- todo 所以这个时候要强行画一次
-- todo 这个模型应该选择什么时候需要画出来，什么时候不需要
function BagCtrl:InitShowRole()
    -- 试穿模型
    attr = MgrMgr:GetMgr("GarderobeMgr").GetRoleAttr(self.name)

    local l_fxData = {}
    l_fxData.rawImage = self.panel.ModelImage.RawImg
    l_fxData.attr = attr
    l_fxData.useShadow = false
    l_fxData.width = self.panel.ModelImage.RectTransform.sizeDelta.x * 2
    l_fxData.height = self.panel.ModelImage.RectTransform.sizeDelta.y * 2
    l_fxData.enablePostEffect = true
    l_fxData.isCameraPosRotCustom = true
    l_fxData.cameraPos = Vector3.New(0.0, 1.1, -3.10)
    l_fxData.cameraRot = Quaternion.Euler(0.0, 2.0, 0.0)
    l_fxData.scale = Vector3.New(0.9, 0.9, 0.9)
    l_fxData.defaultAnim = self:GetAnimationByWeapon(MPlayerInfo.WeaponFromBag)

    if l_model ~= nil then
        self:DestroyUIModel(l_model)
        l_model = nil
    end

    l_model = self:CreateUIModel(l_fxData)
    l_model:AddLoadModelCallback(function(m)
        self.panel.ModelImage.gameObject:SetActiveEx(true)
    end)

    local listener = self.panel.ModelTouchArea:GetComponent("MLuaUIListener")
    listener.onDrag = function(uobj, event)
        --todo 事件未注销 生命周期问题 修改后可删此判断
        if l_model and l_model.Trans then
            l_model.Trans:Rotate(Vector3.New(0, -event.delta.x, 0))
        end
    end
end

--商人显示手推车格子
function BagCtrl:InitBussinessManPanel()
    --商人判定
    if Common.CommonUIFunc.GetProfessionBelongState(MPlayerInfo.ProID, MgrMgr:GetMgr("ShopMgr").BussinessManProfessionId) then
        self.panel.TogBarrow.UObj:SetActiveEx(true)
    else
        self.panel.TogBarrow.UObj:SetActiveEx(false)
    end
end

--根据职业来显示特性格子 如骑士的大嘴鸟格子 等
function BagCtrl:InitSpecialProfessionSlot()
    local l_professionTableInfo = TableUtil.GetProfessionTable().GetRowById(MPlayerInfo.ProfessionId)
    if l_professionTableInfo == nil then
        logError("ProfessionTable表没有配，id：" .. tostring(MPlayerInfo.ProfessionId))
        return false
    end

    for k, v in pairs(l_specialTogs) do
        v.gameObject:SetActiveEx(false)
    end

    local showSkillSlots = string.ro_split(l_professionTableInfo.BagShowSkillSlot, "|")
    for i = 1, table.maxn(showSkillSlots) do
        local singleKey = tonumber(showSkillSlots[i])
        local isActive = nil ~= l_specialTogs[singleKey] and Data.BagModel.WeapType.Ride ~= singleKey
        l_specialTogs[singleKey]:SetActiveEx(isActive)
    end
end

function BagCtrl:ShowBeiluz()
    if MgrMgr:GetMgr("OpenSystemMgr").IsSystemOpen(MgrMgr:GetMgr("OpenSystemMgr").eSystemId.Beiluz) then
        self.panel.ImgBeiluzOrg:SetSprite("Icon_ItemMaterial05", "UI_icon_item_beiluzhexin.png")
        self.panel.TogBeiluz.gameObject:SetActiveEx(true)
    elseif MgrMgr:GetMgr("OpenSystemMgr").IsCanPreview(MgrMgr:GetMgr("OpenSystemMgr").eSystemId.Beiluz) then
        self.panel.ImgBeiluzOrg:SetSprite("Bag", "UI_Bag_Equip_15.png")
        self.panel.TogBeiluz.gameObject:SetActiveEx(true)
    else
        self.panel.TogBeiluz.gameObject:SetActiveEx(false)
    end
end

function BagCtrl:ShowBeiluzGuild()
    if MgrMgr:GetMgr("OpenSystemMgr").IsSystemOpen(MgrMgr:GetMgr("OpenSystemMgr").eSystemId.Beiluz) then
        local l_beginnerGuideChecks = { "WheelGuide2" }
        MgrMgr:GetMgr("BeginnerGuideMgr").CheckShowBeginnerGuide(l_beginnerGuideChecks, self:GetPanelName())
    end
end

--- 在背包页开启的情况下，打开仓库页
function BagCtrl:_setToWareHousePage()
    Data.BagModel:mdOpenModel(Data.BagModel.OpenModel.Pot)
    Data.BagModel:mdPropType(0)
    Data.BagModel:mdPotId(1)
    self.potTemplatePool:ShowTemplates({
        ShowMinCount = Data.BagModel:getPotCellNum()
    })

    self:OpenNormalPot()
    self:ShowPotPanel()
    self:HideWeaponPanel()
    self.panel.BtnWeapon.gameObject:SetActiveEx(false)
    self:ShowSortBtn(2)
    self.panel.BtnSort3.gameObject:SetActiveEx(true)
    self.panel.PanelLeftBg.gameObject:SetActiveEx(true)
    self.panel.PotPagePrefab.PrefabPotPage.gameObject:SetActiveEx(false)
    self:HidePotPage()
end

--设置界面到手推车
function BagCtrl:SetToBarrowCar()
    Data.BagModel:mdOpenModel(Data.BagModel.OpenModel.Car)
    self.potTemplatePool:ShowTemplates({
        ShowMinCount = Data.BagModel:getPotCellNum()
    })
    self:FreshCarWeight()
    self:FreshCarItemNum()
    self:OpenCarPot()
    self:ShowPotPanel()
    self.panel.PanelLeftBg.gameObject:SetActiveEx(true)
end

--根据装备的武器切换待机动画
function BagCtrl:GetAnimationByWeapon(equipId)

    local l_pro = TableUtil.GetProfessionTable().GetRowById(MPlayerInfo.ProID)
    local l_PresentId = 0
    if MPlayerInfo.IsMale then
        l_PresentId = l_pro.PresentM
    else
        l_PresentId = l_pro.PresentF
    end
    local l_PresentTable = TableUtil.GetPresentTable().GetRowById(l_PresentId)
    if not l_PresentTable then
        logError("l_PresentTable is nil")
        return
    end

    local l_idleAnimPath = nil
    if MPlayerInfo.ProID == 1000 then
        l_idleAnimPath = l_PresentTable.IdleAnim
    else
        -- 不是初心者的话用战斗待机
        local l_equip = TableUtil.GetEquipTable().GetRowById(equipId, true)
        local l_weaponId = 0
        if l_equip then
            l_weaponId = l_equip.WeaponId
            for i = 0, l_PresentTable.IdleFAnim.Length - 1 do
                if tonumber(l_PresentTable.IdleFAnim:get_Item(i, 0)) == l_weaponId then
                    l_idleAnimPath = l_PresentTable.IdleFAnim:get_Item(i, 1)
                    break
                end
            end
            --没有动画用默认的
            if not l_idleAnimPath then
                l_idleAnimPath = l_PresentTable.IdleFAnim:get_Item(0, 1)
            end
        else
            --身上没有装备则显示时装动画
            l_idleAnimPath = MgrMgr:GetMgr("GarderobeMgr").GetRoleAnim(attr)
            return l_idleAnimPath
        end
    end
    local l_clipPath = MAnimationMgr:GetClipPath(l_idleAnimPath)
    return l_clipPath

end

function InitProp2do()
    l_propSelected = -1
    l_prop2doTime = 0
end

function InitPot2do()
    l_potSelected = -1
    l_pot2doTime = 0
end

function BagCtrl:InitQuickLong()
    if l_quickDragGo then
        l_quickDragGo:SetActiveEx(false)
    end

    if l_quickLongId ~= -1 then
        self:SetAlphaQuick(l_quickLongId, 1)
    end

    l_quickLongId = -1
    l_quickLongTime = 0
    l_quickDragGo = nil
end

function BagCtrl:InitPropLong()
    if not MLuaCommonHelper.IsNull(l_propDragGo) then
        l_propDragGo:SetActiveEx(false)
    end

    if l_propLongId ~= -1 then
        self:SetAlphaProp(l_propLongId, 1)
    end

    l_propLongId = -1
    l_propLongTime = 0
    l_propDragGo = nil
end

function BagCtrl:InitPotLong()
    if not MLuaCommonHelper.IsNull(l_potDragGo) then
        l_potDragGo:SetActiveEx(false)
    end

    if l_potLongId ~= -1 then
        self:SetAlphaPot(l_potLongId, 1)
    end

    l_potLongId = -1
    l_potLongTime = 0
    l_potDragGo = nil
end

function BagCtrl:ShowPotPage()
    self.panel.PanelPotPage.gameObject:SetActiveEx(true)
end

function BagCtrl:HideWeaponTip()
    self.panel.PanelTip.gameObject:SetActiveEx(false)
end

function BagCtrl:ShowWeaponTip(propInfo)
    self.panel.PanelTip.gameObject:SetActiveEx(true)
    local l_pos = self.panel.ImgTipBg.gameObject.transform.localPosition
    l_pos.x = self.panel.ImgTipBg:GetComponent("RectTransform").sizeDelta.x + 20
    self.panel.ImgTipBg.gameObject.transform.localPosition = l_pos
end

function BagCtrl:ShowQuickTip()
    self.panel.PanelTip.gameObject:SetActiveEx(true)
    local l_pos = self.panel.ImgTipBg.gameObject.transform.localPosition
    l_pos.x = 0
    self.panel.ImgTipBg.gameObject.transform.localPosition = l_pos
end

function BagCtrl:HideQuickTip()
    self.panel.PanelTip.gameObject:SetActiveEx(false)
end

function BagCtrl:HidePropWeaponTip()
    self.panel.PanelTip.gameObject:SetActiveEx(false)
end

function BagCtrl:HidePotPage()
    self.panel.StorgechangeBg.gameObject:SetActiveEx(false)
    self.panel.PanelPotPage.gameObject:SetActiveEx(false)
end

function BagCtrl:HidePotPropTip()
    self.panel.PanelTip.gameObject:SetActiveEx(false)
end

function BagCtrl:ShowPropDlg(propInfo)
    local l_openModel = Data.BagModel:getOpenModel()
    if l_openModel == Data.BagModel.OpenModel.Shop or l_openModel == Data.BagModel.OpenModel.Sale then
        MgrMgr:GetMgr("ShopMgr").OnBagItem(propInfo)
    else
        if l_showPot == true then
            self:ShowPropPotTip(propInfo)
        else
            self:ShowPropWeaponTip(propInfo)
        end
    end
end

function BagCtrl:ShowPotPanel()
    self:FreshPot()
    self:FreshPotPage()
    self:HidePanelQuick()
    self.panel.PanelPot.gameObject:SetActiveEx(true)
    self.panel.PanelWeapon.gameObject:SetActiveEx(false)
    l_showPot = true
    l_showWeapon = false
    self.panel.BtnQuickOpen.gameObject:SetActiveEx(false)
    self.panel.ModelImage.gameObject:SetActiveEx(false)
end

function BagCtrl:HidePotPanel()
    self.panel.PanelPot.gameObject:SetActiveEx(false)
    l_showPot = false
end

function BagCtrl:ShowWeaponPanel()
    self.panel.PanelPot.gameObject:SetActiveEx(false)
    self.panel.PanelWeapon.gameObject:SetActiveEx(true)
    l_showPot = false
    l_showWeapon = true
    self.panel.BtnQuickOpen.gameObject:SetActiveEx(true)
    self.panel.ModelImage.gameObject:SetActiveEx(true)
    self.panel.BtnSort3.gameObject:SetActiveEx(false)

    -- todo  这个按钮应该移除，在背包优化中处理
    self.panel.BtnPot.gameObject:SetActiveEx(false)

    -- todo 这里有一个问题，3渲2被隐藏之后再重新打开不会画上去，我们要重新画一下
    self:CustomRefresh()

    if MgrMgr:GetMgr("OpenSystemMgr").IsSystemOpen(MgrMgr:GetMgr("OpenSystemMgr").eSystemId.EquipMultiTalent) then
        self.panel.MultiTalentsSelectButtonParent.gameObject:SetActiveEx(true)
        self._multiTalentsSelectTemplate:SetData(MgrMgr:GetMgr("OpenSystemMgr").eSystemId.EquipMultiTalent, { IsNeedSetFrame = true })
    else
        self.panel.MultiTalentsSelectButtonParent.gameObject:SetActiveEx(false)
    end

    self:ShowBeiluz()
end

function BagCtrl:HideWeaponPanel()
    self.panel.PanelWeapon.gameObject:SetActiveEx(false)
    l_showWeapon = false
    self.panel.ModelImage.gameObject:SetActiveEx(false)
end

function BagCtrl:ShowPanelQuick()
    l_showQuick = true
    self.panel.PanelQuick.gameObject:SetActiveEx(true)
    self:FreshQuick()
    self:ShowSortBtn(0)
    self.panel.PanelWeight.gameObject:SetActiveEx(false)
end

function BagCtrl:HidePanelQuick()
    l_showQuick = false
    self.panel.PanelQuick.gameObject:SetActiveEx(false)
    self:ShowSortBtn(1)
    self.panel.PanelWeight.gameObject:SetActiveEx(true)
end

---@param itemData ItemData
function BagCtrl:ShowQuickItem(index, itemData)
    self.panel.ImgQuickItem[index].gameObject:SetActiveEx(true)
    self.panel.BtnQuickKill[index].gameObject:SetActiveEx(true)
    self.panel.AddQuick[index].gameObject:SetActiveEx(false)
    self.panel.ImgQuickItem[index]:SetSprite(itemData.ItemConfig.ItemAtlas, itemData.ItemConfig.ItemIcon, true)
    local l_num = itemData.ItemCount
    self.panel.TxtQuickNum[index].gameObject:SetActiveEx(l_num > 1)
    self.panel.TxtQuickNum[index].LabText = tostring(l_num)
    local l_color = self.panel.ImgQuickItem[index].Img.color
    if 0 >= l_num then
        l_color.a = 0.47
    else
        l_color.a = 1
    end

    self.panel.ImgQuickItem[index].Img.color = l_color
end

function BagCtrl:HideQuickItem(index)
    self.panel.AddQuick[index].gameObject:SetActiveEx(true)
    self.panel.ImgQuickItem[index].gameObject:SetActiveEx(false)
    self.panel.TxtQuickNum[index].gameObject:SetActiveEx(false)
    self.panel.BtnQuickKill[index].gameObject:SetActiveEx(false)
end

function BagCtrl:_getBagItemByIdx(idx)
    if GameEnum.ELuaBaseType.Number ~= type(idx) then
        logError("[BagCtrl] invalid param")
        return nil
    end

    local items = MgrProxy:GetBagMgr().GetFiltrateItemsInBag()
    local item = items[idx]
    return item
end

function BagCtrl:AddQuickFromDrag(propIndex, quickIndex)
    local l_propInfo = self:_getBagItemByIdx(propIndex)
    Data.BagApi:ReqSwapItem(l_propInfo.UID, GameEnum.EBagContainerType.ShortCut, quickIndex, -1)
end

function BagCtrl:AddPropFromPot(uid, num)
    Data.BagApi:ReqSwapItem(uid, GameEnum.EBagContainerType.Bag, nil, num)
end

--- 设置装备位显示状态
function BagCtrl:_setEquipSlotState(pos, propInfo, showSlot)
    if showSlot then
        l_weaponImg[pos]:SetData({ PropInfo = propInfo, HideButton = true, IsShowCount = false, IsShowDestroyEquipPart = true })
    end

    l_weaponImg[pos]:SetGameObjectActive(showSlot)
    l_weaponImgOrg[pos].gameObject:SetActiveEx(not showSlot)
    l_weaponImg[pos].TemplateParent.gameObject:SetActiveEx(showSlot)
end

--- 缓存需要SetData的数据
function BagCtrl:_cacheSetEquipSlotData(pos, propInfo, showSlot)
    local cacheData = {
        slotType = pos,
        itemData = propInfo,
        showSlot = showSlot,
    }

    self._equipSlotDataCache[pos] = cacheData
end

function BagCtrl:SetOrnament(type, itemId, isFromBag)
    if attr then
        attr:SetOrnamentByIntType(type, itemId, isFromBag)
    end

    if l_model then
        l_model:RefreshEquipData(attr.EquipData)
    end
end
function BagCtrl:SetFashion(itemId)
    if attr then
        attr:SetFashion(itemId)
    end

    if l_model then
        l_model:RefreshEquipData(attr.EquipData)
    end
end
function BagCtrl:SetWeaponEx(itemId, isFromBag)
    if attr then
        attr:SetWeaponEx(itemId, isFromBag)
    end

    if l_model then
        l_model:RefreshEquipData(attr.EquipData)
    end
end

function BagCtrl:SetWeapon(itemId, isFromBag)
    if attr then
        attr:SetWeapon(itemId, isFromBag)
    end

    if l_model then
        l_model:RefreshEquipData(attr.EquipData)
        local l_animationPath = self:GetAnimationByWeapon(itemId)
        l_model.Ator:OverrideAnim("Idle", l_animationPath)
    end
end

function BagCtrl:SetAlphaQuick(index, alpha)
    local l_col = self.panel.ImgQuickItem[index].Img.color
    l_col.a = alpha
    self.panel.ImgQuickItem[index].Img.color = l_col
end

function BagCtrl:SetAlphaProp(index, alpha)
    local l_it = self.propTemplatePool:GetItem(index)
    if l_it ~= nil then
        local l_col = l_it.Parameter.ItemIcon.Img.color
        l_col.a = alpha
        l_it.Parameter.ItemIcon.Img.color = l_col
    end
end

function BagCtrl:SetAlphaPot(index, alpha)
    local l_it = self.potTemplatePool:GetItem(index)
    if l_it ~= nil then
        local l_col = l_it.Parameter.ItemIcon.Img.color
        l_col.a = alpha
        l_it.Parameter.ItemIcon.Img.color = l_col
    end
end

function BagCtrl:InitPropClf(type)
    Data.BagModel:mdPropType(type)
    self._currentSelectPage = type
    self:FreshProp()
    self.panel.ScrollProp.LoopScroll:ScrollToCell(0)
end

---@param value int64
function BagCtrl:ChangeToTenThousand(value)
    if value < 10000 then
        return value
    end

    --- 标注一下，这个重量的值是int64，所以这边计算的时候需要先把位数降下来
    local l_res = tostring(StringEx.Format("{0:F1}", tonumber(value / 1000) * 0.1)) .. Lang("TenThousand")
    return l_res
end

function BagCtrl:FreshWeight()
    local l_nowWstr = MgrMgr:GetMgr("ItemWeightMgr").GetCurrentWeightByType(GameEnum.EBagContainerType.Bag)
    l_nowWstr = self:ChangeToTenThousand(l_nowWstr)
    local l_maxWstr = MgrMgr:GetMgr("ItemWeightMgr").GetMaxWeightByType(GameEnum.EBagContainerType.Bag)
    l_maxWstr = self:ChangeToTenThousand(l_maxWstr)
    if MgrMgr:GetMgr("ItemWeightMgr").IsWeightRed(GameEnum.EBagContainerType.Bag) then
        self.panel.TxtWeight.LabText = GetColorText(tostring(l_nowWstr), RoColorTag.Red) .. "/" .. tostring(l_maxWstr)
    else
        self.panel.TxtWeight.LabText = tostring(l_nowWstr) .. "/" .. tostring(l_maxWstr)
    end
end

function BagCtrl:FreshProp()
    self.propTemplatePool:RefreshCells()
end

function BagCtrl:FreshPot()
    self.potTemplatePool:RefreshCells()
end

function BagCtrl:FreshPotPage()
    self.panel.TxtNowPgName.LabText = Data.BagModel:getPotName(Data.BagModel:getPotId())
end

function BagCtrl:FreshQuick()
    for i = 1, quickPageCount * quickSlotCount do
        self:HideQuickItem(i)
        local l_info = MgrProxy:GetShortCutItemMgr().GetItemByIdx(i)
        if l_info ~= nil then
            self:ShowQuickItem(i, l_info)
        end
    end

    self:SetQuickBgReceiveRaycastTarget(false)
end

function BagCtrl:FreshPropCd()
    for i = self.propTemplatePool:GetCellStartIndex(), self.propTemplatePool:GetCellEndIndex() do
        local l_tp = self.propTemplatePool:GetItem(i)
        if l_tp ~= nil then
            l_tp:FreshCd()
        end
    end
end

function BagCtrl:FreshWeapon()
    local l_typeTable = Data.BagModel.WeapType
    for k, v in pairs(l_typeTable) do
        local l_info = Data.BagApi:GetItemByTypeSlot(GameEnum.EBagContainerType.Equip, v + 1)
        if l_info ~= nil then
            self:_cacheSetEquipSlotData(v, l_info, true)
        else
            self:_cacheSetEquipSlotData(v, nil, false)
        end
    end

    local mainWeapon = Data.BagApi:GetItemByTypeSlot(GameEnum.EBagContainerType.Equip, Data.BagModel.WeapType.MainWeapon + 1)
    if nil == mainWeapon then
        self.panel.AssistMask:SetActiveEx(false)
        return
    end

    local l_HoldingMode = MgrMgr:GetMgr("EquipMgr").GetEquipHoldingModeById(mainWeapon.TID)
    if l_HoldingMode == MgrMgr:GetMgr("EquipMgr").HoldingModeDouble
            or l_HoldingMode == MgrMgr:GetMgr("EquipMgr").HoldingModeDoubleHand
    then
        self:_cacheSetEquipSlotData(Data.BagModel.WeapType.Assist, mainWeapon, true)
        self.panel.AssistMask:SetActiveEx(true)
    else
        self.panel.AssistMask:SetActiveEx(false)
    end
end

function BagCtrl:GetPointProp()
    return l_propPoint
end

function BagCtrl:GetPointPot()
    return l_potPoint
end

function BagCtrl:GetPointWeap()
    return l_weaponPoint
end

function BagCtrl:ShowWeaponPropTip(propInfo)
    MgrMgr:GetMgr("ItemTipsMgr").ShowTipsDisplayWithInfo(
            propInfo,
            nil,
            Data.BagModel.WeaponStatus.ON_BODY,
            nil)
end

function BagCtrl:_gotoShowOtherEquip(weaponPoint)
    if MgrMgr:GetMgr("BagEquipMgr").GetCurrentSelectEquipPart() then
        MgrMgr:GetMgr("BagEquipMgr").SetCurrentSelectEquipPart(nil)
        self:FreshProp()
    end

    local l_info = Data.BagApi:GetItemByTypeSlot(GameEnum.EBagContainerType.Equip, weaponPoint + 1)
    if l_info then
        return
    end

    local l_equipPart = MgrMgr:GetMgr("BodyEquipMgr").GetEquipPartWithServerEnum(weaponPoint)
    if MgrMgr:GetMgr("BagEquipMgr").IsHaveEquipWithEquipPart(l_equipPart) then
        self:_gotoBagEquipTag(l_equipPart)
    else
        self:_gotoIllustrator(l_equipPart)
    end
end

function BagCtrl:_gotoBagEquipTag(equipPart)
    local _gotoBagEquipTagName = "_gotoBagEquipTagName"
    local l_dateStrSave = UserDataManager.GetStringDataOrDef(_gotoBagEquipTagName, MPlayerSetting.PLAYER_SETTING_GROUP, "")
    if string.ro_isEmpty(tostring(l_dateStrSave)) then
        UserDataManager.SetDataFromLua(_gotoBagEquipTagName, MPlayerSetting.PLAYER_SETTING_GROUP, _gotoBagEquipTagName)
        CommonUI.Dialog.ShowYesNoDlg(
                true, nil,
                Lang("Bag_GotoBagEquipTagText"),
                function()
                    self:_showBagEquipTag(equipPart)
                end
        )
    else
        self:_showBagEquipTag(equipPart)
    end
end

function BagCtrl:_showBagEquipTag(equipPart)
    local l_index = 2
    MgrMgr:GetMgr("BagEquipMgr").SetCurrentSelectEquipPart(equipPart)
    if self.panel.TogBagCly[l_index].TogEx.isOn then
        self:InitPropClf(l_index - 1)
    else
        self.panel.TogBagCly[l_index].TogEx.isOn = true
    end
end

function BagCtrl:_gotoIllustrator(equipPart)

    local illusMgr = MgrMgr:GetMgr("IllustrationMgr")
    if illusMgr.IsIllustrationEquipCanShow(equipPart, MPlayerInfo.ProfessionId) == false then
        return
    end

    local openMgr = MgrMgr:GetMgr("OpenSystemMgr")
    if not openMgr.IsSystemOpen(openMgr.eSystemId.IllustratorEquip) then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(openMgr.GetOpenSystemTipsInfo(openMgr.eSystemId.IllustratorEquip))
        return
    end

    local _gotoIllustratorTipsName = "GotoIllustratorTipsName"
    local l_dateStrSave = UserDataManager.GetStringDataOrDef(_gotoIllustratorTipsName, MPlayerSetting.PLAYER_SETTING_GROUP, "")
    if string.ro_isEmpty(tostring(l_dateStrSave)) then
        UserDataManager.SetDataFromLua(_gotoIllustratorTipsName, MPlayerSetting.PLAYER_SETTING_GROUP, _gotoIllustratorTipsName)
        CommonUI.Dialog.ShowYesNoDlg(
                true, nil,
                Lang("Bag_GotoIllustratorTipsText"),
                function()
                    self:_showIllustrator(equipPart)
                end
        )
    else
        self:_showIllustrator(equipPart)
    end
end

function BagCtrl:_showIllustrator(equipPart)
    MgrMgr:GetMgr("SystemFunctionEventMgr").OpenIllustrationByEquip(equipPart, MPlayerInfo.ProfessionId)
end

---@param propInfo ItemData
function BagCtrl:ShowPropWeaponTip(propInfo)
    if not propInfo then
        return
    end

    if propInfo and propInfo.ItemConfig.TypeTab == Data.BagModel.PropType.Weapon then
        MgrMgr:GetMgr("ItemTipsMgr").ShowTipsDisplayWithInfo(propInfo, nil, Data.BagModel.WeaponStatus.JUST_COMPARE)
    else
        MgrMgr:GetMgr("ItemTipsMgr").ShowTipsDisplayWithInfo(propInfo, nil, Data.BagModel.WeaponStatus.TO_USE, nil)
    end
end

function BagCtrl:ShowPotPropTip(propInfo)
    MgrMgr:GetMgr("ItemTipsMgr").ShowTipsDisplayWithInfo(propInfo, nil, Data.BagModel.WeaponStatus.TO_PROP, nil)
end

function BagCtrl:ShowPropPotTip(propInfo)
    MgrMgr:GetMgr("ItemTipsMgr").ShowTipsDisplayWithInfo(propInfo, nil, Data.BagModel.WeaponStatus.TO_POT)
end

function BagCtrl:DeActive(isPlayTween)
    self:InitPropLong()
    if self.panel ~= nil then
        self.panel.ModelImage.gameObject:SetActiveEx(false)
    end

    if l_model ~= nil then
        self:DestroyUIModel(l_model)
        l_model = nil
    end

    super.DeActive(self, isPlayTween)
end

--长按进入
function BagCtrl:PropLongPointEnter(eventData, idx)
    if l_showQuick == true or l_showPot == true then
        UIMgr:DeActiveUI(UI.CtrlNames.CommonItemTips)
        l_propLongId = idx
        local l_cgPos = MUIManager.UICamera:ScreenToWorldPoint(eventData.position)
        l_cgPos.z = 0
        l_propLongPos = l_cgPos
    end
end

function BagCtrl:PotLongPointEnter(eventData, idx)
    l_potLongId = idx
    local l_cgPos = MUIManager.UICamera:ScreenToWorldPoint(eventData.position)
    l_cgPos.z = 0
    l_potLongPos = l_cgPos
end

function BagCtrl:SetQuickBgReceiveRaycastTarget(flag)
    for i = 1, quickPageCount * quickSlotCount do
        self.panel.QuickBack[i].Img.raycastTarget = flag
    end
end

--长q按开始
function BagCtrl:PropLongPointBegin(eventData)
    self:SetQuickBgReceiveRaycastTarget(true)
end

--长按退出
function BagCtrl:PropLongPointQuit(eventData)
    self:SetQuickBgReceiveRaycastTarget(false)
    if l_showQuick == true or l_showPot == true then
        if not MLuaCommonHelper.IsNull(l_propDragGo) then
            if l_showPot == true then
                if eventData.position.x <= UnityEngine.Screen.width * 0.5 then
                    local l_info = self:_getBagItemByIdx(l_propLongId)
                    if l_info ~= nil then
                        local l_openModel = Data.BagModel:getOpenModel()
                        if l_openModel == Data.BagModel.OpenModel.Car then
                            Data.BagApi:ReqSwapItem(l_info.UID, GameEnum.EBagContainerType.Cart, nil, -1)
                        else
                            MgrMgr:GetMgr("ItemContainerMgr").TryPutItemToWareHouse(l_info, -1)
                        end
                    end
                end
            end

            if l_showQuick == true then
                if l_quickEnter ~= -1 then
                    local l_info = self:_getBagItemByIdx(l_propLongId)
                    if l_info ~= nil then
                        local l_pos = l_quickEnter
                        if l_pos ~= nil then
                            Data.BagApi:ReqSwapItem(l_info.UID, GameEnum.EBagContainerType.ShortCut, l_pos, -1)
                        end
                    end
                end
            end

            self:InitPropLong()
        end
    end
end

function BagCtrl:PotLongPointQuit(eventData)
    if nil == l_potDragGo then
        return
    end

    if eventData.position.x > UnityEngine.Screen.width * 0.5 then
        local l_info = nil
        local l_openModel = Data.BagModel:getOpenModel()
        if l_openModel == Data.BagModel.OpenModel.Car then
            l_info = Data.BagApi:GetItemByTypeSlot(GameEnum.EBagContainerType.Cart, l_potLongId)
            Data.BagApi:ReqSwapItem(l_info.UID, GameEnum.EBagContainerType.Bag, nil, nil)
        else
            local currentPage = Data.BagModel:getPotId()
            local targetContType = Data.BagTypeClientSvrMap:GetWareHouseContTypeByIdx(currentPage)
            if Data.BagTypeClientSvrMap:GetInvalidSvrType() == targetContType then
                logError("[BagCtrl] invalid idx: " .. tostring(targetContType))
                return
            end

            l_info = Data.BagApi:GetItemByTypeSlot(targetContType, l_potLongId)
            Data.BagApi:ReqSwapItem(l_info.UID, GameEnum.EBagContainerType.Bag, nil, nil)
        end
    end

    self:InitPotLong()
end

--拖动物体
function BagCtrl:PropDragItem(eventData)
    if self.panel == nil then
        return
    end

    if l_showQuick == true or l_showPot == true then
        if l_propDragGo ~= nil then
            local l_cgPos = MUIManager.UICamera:ScreenToWorldPoint(eventData.position)
            l_cgPos.z = 0
            l_propDragGo.transform.position = l_cgPos
        else
            self:InitPropLong()
            self.panel.ScrollProp.LoopScroll:OnDrag(eventData)
        end
    else
        self:InitPropLong()
        self.panel.ScrollProp.LoopScroll:OnDrag(eventData)
    end
end

function BagCtrl:PotDragItem(eventData)
    if self.panel == nil then
        return
    end

    if l_potDragGo ~= nil then
        local l_cgPos = MUIManager.UICamera:ScreenToWorldPoint(eventData.position)
        l_cgPos.z = 0
        l_potDragGo.transform.position = l_cgPos
    else
        self:InitPotLong()
        self.panel.ScrollPot.LoopScroll:OnDrag(eventData)
    end
end

--离开item
function BagCtrl:PropExit()
    if l_showQuick == true or l_showPot == true then
        if l_propDragGo == nil then
            self:InitPropLong()
        end
    end
end

function BagCtrl:PotExit()
    if l_potDragGo == nil then
        self:InitPotLong()
    end
end

--双击进入
function BagCtrl:Prop2doEnter(idx)
    if l_propSelected == -1 then
        l_propSelected = idx
    elseif l_propSelected ~= idx then
        InitProp2do()
        l_propSelected = idx
    else
        if l_prop2doTime <= l_2doGapTime then
            local tips = UIMgr:ActiveUI(UI.CtrlNames.CommonItemTips)
            local buttonData = {}
            if tips then
                --存储Tips按钮里的所有数据结构 CommonItemTipsCtrl:AddButtonData 查看数据结构
                buttonData = table.ro_deepCopy(tips.buttonstatus)
            end

            UIMgr:DeActiveUI(UI.CtrlNames.CommonItemTips)
            if l_showQuick == true then
                local l_info = self:_getBagItemByIdx(idx)
                local l_pos = MgrProxy:GetShortCutItemMgr().GetFirstEmptySlot()
                if l_pos ~= MgrProxy:GetShortCutItemMgr().C_INVALID_SLOT_IDX then
                    Data.BagApi:ReqSwapItem(l_info.UID, GameEnum.EBagContainerType.ShortCut, l_pos, -1)
                end
            elseif l_showPot == true then
                local l_info = self:_getBagItemByIdx(idx)
                local l_openModel = Data.BagModel:getOpenModel()
                local l_isTalentEquip, l_name, l_c = MgrProxy:GetMultiTalentEquipMgr().IsInMultiTalentEquip(l_info)
                if l_openModel == Data.BagModel.OpenModel.Car then
                    if l_isTalentEquip then
                        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(StringEx.Format(Common.Utils.Lang("MultiTalent_EquipCantChangeWithCar"), l_name))
                    else
                        Data.BagApi:ReqSwapItem(l_info.UID, GameEnum.EBagContainerType.Cart, nil, nil)
                    end
                else
                    if l_isTalentEquip then
                        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(StringEx.Format(Common.Utils.Lang("MultiTalent_EquipCantChangeWithWareHouse"), l_name))
                    else
                        MgrMgr:GetMgr("ItemContainerMgr").TryPutItemToWareHouse(l_info, -1)
                    end
                end
            elseif l_showWeapon == true then
                if buttonData ~= nil and #buttonData > 0 then
                    buttonData[1].method()
                end
            end

            InitProp2do()
        end
    end
end

function BagCtrl:Pot2doEnter(idx)
    if l_potSelected == -1 then
        l_potSelected = idx
    elseif l_potSelected ~= idx then
        InitPot2do()
        l_potSelected = idx
    else
        if l_pot2doTime <= l_2doGapTime then
            UIMgr:DeActiveUI(UI.CtrlNames.CommonItemTips)
            ---@type ItemData
            local l_info = nil
            local l_openModel = Data.BagModel:getOpenModel()
            if l_openModel == Data.BagModel.OpenModel.Car then
                l_info = Data.BagApi:GetItemByTypeSlot(GameEnum.EBagContainerType.Cart, idx)
            else
                local currentPage = Data.BagModel:getPotId()
                local targetContType = Data.BagTypeClientSvrMap:GetWareHouseContTypeByIdx(currentPage)
                if Data.BagTypeClientSvrMap:GetInvalidSvrType() == targetContType then
                    logError("[BagCtrl] invalid idx: " .. currentPage)
                    return
                end

                l_info = Data.BagApi:GetItemByTypeSlot(targetContType, idx)
            end

            if nil ~= l_info then
                self:AddPropFromPot(l_info.UID, l_info.ItemCount)
                InitPot2do()
            else
                logError("[BagCtrl] invalid type: " .. tostring(l_openModel) .. " invalid idx: " .. tostring(idx))
            end
        end
    end

    self:InitPotLong()
end

--切仓库页
function BagCtrl:ChangePotPage()
    self.potTemplatePool:ShowTemplates({ ShowMinCount = Data.BagModel:getPotCellNum() })
end

function BagCtrl:AddPotPageLockCellCount()
    local l_bcn = Data.BagModel:getPotPageCellNum()
    if l_bcn > self.potPageTemplatePool.CellCount then
        self.potPageTemplatePool:AddTotalCount(l_bcn - self.potPageTemplatePool.CellCount)
    end
end

function BagCtrl:OnUpdateItem(obj, idx)
    -- do nothing
end

local _carPotPositionY = 42.5

--仓库
function BagCtrl:OpenNormalPot()
    MLuaCommonHelper.SetRectTransformPosY(self.panel.StorageScrollParent.UObj, 0)
    self.panel.TitleCarPot.gameObject:SetActiveEx(false)
    self.panel.TitleNormalPot.gameObject:SetActiveEx(true)
end

function BagCtrl:OpenCarPot()
    MLuaCommonHelper.SetRectTransformPosY(self.panel.StorageScrollParent.UObj, _carPotPositionY)
    self.panel.TitleCarPot.gameObject:SetActiveEx(true)
    self.panel.TitleNormalPot.gameObject:SetActiveEx(false)
end

--手推车
function BagCtrl:FreshCarItemNum()
    local cartItems = MgrProxy:GetBagMgr().GetCartItemCount()
    local cartItemCount = cartItems
    self.panel.TxtCarItemNum.LabText = cartItemCount .. "/" .. Data.BagModel:getMaxCarItemNum()
end

function BagCtrl:FreshCarWeight()
    local trolleyCurrentWeight = MgrMgr:GetMgr("ItemWeightMgr").GetCurrentWeightByType(GameEnum.EBagContainerType.Cart)
    local trolleyMaxWeight = MgrMgr:GetMgr("ItemWeightMgr").GetMaxWeightByType(GameEnum.EBagContainerType.Cart)
    self.panel.TxtCarItemWeight.LabText = tostring(trolleyCurrentWeight) .. "/" .. tostring(trolleyMaxWeight)
end

return BagCtrl
--lua custom scripts end