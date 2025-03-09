--this file is gen by script
--you can edit this file in custom part

--lua requires
require "UI/Template/ItemTemplate"
require "UI/BaseUITemplate"
require "Data/Model/BagModel"
require "UI/Template/ItemCdPartTemplate"
--lua requires end

--lua modelItemButton
module("UITemplate", package.seeall)
--lua model end

--lua class define
local super = UITemplate.ItemTemplate
ItemBagTemplate = class("ItemBagTemplate", super)
--lua class define end
local BUSINESS_CERTIFICATE_ID -- 跑商凭证ID
--lua functions
function ItemBagTemplate:Init()
    super.Init(self)
    --全部逻辑写在init里
    self:init()

    --- 是不是拖拽过程，鼠标抬起的触发顺序是onPressUp, OnClick, OnDragEnd
    --- 所以开始拖拽的时候进行一个记录，onDragEnd的时候重置这个记录，这样保证没有触发过拖拽
    self._dragging = false
end --func end
--next--

---@param data ItemData
function ItemBagTemplate:OnSetData(data)
    local l_info = data
    local count = nil
    if nil ~= l_info then
        count = l_info.ItemCount
    end

    self.ShowData = l_info
    self.baseDataInfo.PropInfo = l_info
    self.baseDataInfo.IsShowTips = false
    self.baseDataInfo.IsShowEquipMultiTalentFlag = true
    self.baseDataInfo.IsShowBagEquipCanWearFlag = true

    --- 出售界面已经调整成了复制数据的模式，所以这里一定是能获取到数据量的
    if nil ~= count then
        self.baseDataInfo.Count = count
        self.baseDataInfo.IsShowCount = true
        if 1 == count then
            self.baseDataInfo.IsShowCount = false
        end
    end

    --数量
    if l_info then
        self.baseDataInfo.IsShowCount = l_info.ItemCount > 1
    end

    self.baseDataInfo.IsGray = false
    if l_info ~= nil then
        local l_openModel = Data.BagModel:getOpenModel()
        if l_openModel == Data.BagModel.OpenModel.Sale then
            local l_isTalentEquip, l_b, l_c = MgrProxy:GetMultiTalentEquipMgr().IsInMultiTalentEquip(l_info)
            if l_isTalentEquip then
                self.baseDataInfo.IsGray = true
            end
        end
    end

    self:SetPotItemCountIfNeeded(self.baseDataInfo)
    super.OnSetData(self, self.baseDataInfo)
    if not self.cdPart then
        self.cdPart = self:NewTemplate("ItemCdPartTemplate", {
            TemplateParent = self:transform(),
            Data = l_info,
        })
    else
        self.cdPart:SetData(l_info)
    end

    --item显示
    if l_info == nil then
        self.Parameter.ItemButton:SetSprite(Data.BagModel:getItemBgAtlas(), Data.BagModel:getItemBg())
        self:SetActiveEx(self.Parameter.ItemButton, true)
        self:SetActiveEx(self.cdPart.Parameter.ImgSelect, false)
        return
    end

    -- CD组件
    self.cdHelper = UICDImgHelper.Get(self.cdPart.Parameter.ImgCd.gameObject)
    --cd
    self:FreshCd()
    --选中框
    self:FreshSelect()
    --红点
    self:FreshRed()
end --func end
--next--
function ItemBagTemplate:OnDestroy()
    super.OnDestroy(self)
    MLuaUIListener.Destroy(self.Parameter.ItemButton.gameObject)
    if self.cdPart then
        UICDImgHelper.Destroy(self.cdPart.Parameter.ImgCd.gameObject)
    end
end --func end
--next--
--lua functions end

--lua custom scripts
ItemBagTemplate.TemplatePath = "UI/Prefabs/ItemPrefab"
function ItemBagTemplate:ctor(itemData)
    if itemData == nil then
        itemData = {}
    end

    super.ctor(self, itemData)
    BUSINESS_CERTIFICATE_ID = tonumber(TableUtil.GetBusinessGlobalTable().GetRowByName("BusinessCertificate").Value)
end

function ItemBagTemplate:init()
    --数据初始化
    self.bagCtrl = UIMgr:GetUI(UI.CtrlNames.Bag)
    self.baseDataInfo = {}
    if not self.bagCtrl then
        return
    end

    self.bagPanel = self.bagCtrl.panel
    MLuaUIListener.Get(self.Parameter.ItemButton.gameObject)
    self.Parameter.ItemButton.Listener:SetActionBeginDrag(self._beginDrag, self)
    self.Parameter.ItemButton.Listener:SetActionEndDrag(self._endDrag, self)
    self.Parameter.ItemButton.Listener:SetActionOnDrag(self._onDrag, self)
    self.Parameter.ItemButton.Listener:SetActionButtonUp(self._onButtonUp, self)
    self.Parameter.ItemButton.Listener:SetActionButtonDown(self._onButtonDown, self)
    self.Parameter.ItemButton.Listener:SetActionClick(self._onClickCb, self)
    self.Parameter.ItemButton.Listener:SetActionButtonExit(self._onExitCb, self)
end

function ItemBagTemplate:_beginDrag(go, eventData)
    self._dragging = true
    self.bagCtrl:PropLongPointBegin(eventData)
    self.bagPanel.ScrollProp.LoopScroll:OnBeginDrag(eventData)
end

function ItemBagTemplate:_endDrag(go, eventData)
    self._dragging = false
    self.bagCtrl:PropLongPointQuit(eventData)
    self.bagCtrl:InitPropLong()
    self.bagPanel.ScrollProp.LoopScroll:OnEndDrag(eventData)
end

function ItemBagTemplate:_onDrag(go, eventData)
    self.bagCtrl:PropDragItem(eventData)
end

function ItemBagTemplate:_onButtonUp(go, eventData)
    if self._dragging then
        return
    end

    --处理选中框
    local l_t = self.bagCtrl.propLastPoint
    if self.ShowData ~= nil then
        self.bagCtrl.propLastPoint = self.ShowData.UID
        if l_t ~= self.ShowData.UID then
            self.bagCtrl.propTemplatePool:RefreshCells()
        end
    end

    UIMgr:DeActiveUI(UI.CtrlNames.CommonItemTips)
end

function ItemBagTemplate:_onButtonDown(go, eventData)
    --长按
    self.bagCtrl:InitPropLong()
    if self.ShowData ~= nil then
        local l_isTalentEquip, l_name, l_c = MgrProxy:GetMultiTalentEquipMgr().IsInMultiTalentEquip(self.ShowData)
        if not l_isTalentEquip then
            self.bagCtrl:PropLongPointEnter(eventData, self.ShowIndex)
        end
    end
end

function ItemBagTemplate:_onExitCb(go, eventData)
    --长按
    self.bagCtrl:PropExit()
end

function ItemBagTemplate:_onClickCb(go, eventData)
    self.bagCtrl:InitPropLong()

    --tips
    if self.ShowData == nil then
        MgrMgr:GetMgr("ItemTipsMgr").CloseCommonTips()
    else
        self.bagCtrl:ShowPropDlg(self.ShowData)
    end

    --红点
    if self.ShowData ~= nil then
        Data.BagModel:deleteRed(self.ShowData.UID)
        self:FreshRed()
    end

    --双击
    if self.ShowData and self.ShowData.ItemConfig.TypeTab ~= Data.BagModel.PropType.Task then
        --有一些特殊判定的道具 不需要双击使用
        local isUnUseObj = false
        local UnUseIdTb = MGlobalConfig:GetSequenceOrVectorInt("ItemsWithoutUseButton")
        for i = 1, UnUseIdTb.Length do
            if UnUseIdTb[i - 1] == self.ShowData.TID then
                isUnUseObj = true
                break
            end
        end

        if not isUnUseObj then
            self.bagCtrl:Prop2doEnter(self.ShowIndex)
        end
    end
end

function ItemBagTemplate:SetActiveEx(uicom, isActive)
    if uicom.gameObject.activeSelf ~= isActive then
        uicom.gameObject:SetActiveEx(isActive)
    end
end

function ItemBagTemplate:FreshSelect()
    if nil == self.bagCtrl then
        self.bagCtrl = UIMgr:GetUI(UI.CtrlNames.Bag)
    end

    if nil == self.bagCtrl then
        return
    end

    if self.cdPart then
        self:SetActiveEx(self.cdPart.Parameter.ImgSelect, self.ShowData.UID == self.bagCtrl.propLastPoint)
    end
end

function ItemBagTemplate:FreshRed()
    if nil == self.cdPart then
        return
    end

    if Data.BagModel:isRed(self.ShowData.UID) == true then
        self:SetActiveEx(self.cdPart.Parameter.ImgRed, true)
    else
        self:SetActiveEx(self.cdPart.Parameter.ImgRed, false)
    end
end

function ItemBagTemplate:FreshCd()
    local data = self.ShowData
    if data == nil or nil == self.cdPart then
        return
    end

    local l_openModel = Data.BagModel:getOpenModel()
    if l_openModel == Data.BagModel.OpenModel.Shop or l_openModel == Data.BagModel.OpenModel.Sale then
        self:SetActiveEx(self.cdPart.Parameter.ImgCd, false)
        self:SetActiveEx(self.cdPart.Parameter.TxtCd, false)
        if l_openModel == Data.BagModel.OpenModel.Sale then
            self:SetActiveEx(self.cdPart.Parameter.ImgCd, not MgrMgr:GetMgr("ShopMgr").IsBagItemCanSell(data))
        end
    else
        local l_cd = MgrMgr:GetMgr("ItemCdMgr").GetCd(data.TID)
        if l_cd > 0 then
            local l_allCd = MgrMgr:GetMgr("ItemCdMgr").GetCdFromTable(data.TID)
            local l_cdRate = l_cd / l_allCd
            self.cdPart.Parameter.ImgCd.Img.type = UnityEngine.UI.Image.Type.Filled
            if self.cdHelper ~= nil then
                self.cdHelper:SetCD(l_allCd - l_cd, l_allCd)
            else
                self.cdPart.Parameter.ImgCd.Img.fillAmount = l_cdRate
            end

            self:SetActiveEx(self.cdPart.Parameter.ImgCd, true)
            local l_cdInt = math.floor(l_cd)
            if l_cdInt > 0 then
                self.cdPart.Parameter.TxtCd.LabText = l_cdInt
                self:SetActiveEx(self.cdPart.Parameter.TxtCd, true)
            else
                self:SetActiveEx(self.cdPart.Parameter.TxtCd, false)
            end
        else
            self:SetActiveEx(self.cdPart.Parameter.ImgCd, false)
            self:SetActiveEx(self.cdPart.Parameter.TxtCd, false)
        end
    end
end

function ItemBagTemplate:SetPotItemCountIfNeeded(data)
    local l_propId = data.PropInfo and data.PropInfo.TID
    if l_propId == BUSINESS_CERTIFICATE_ID then
        data.IsShowCount = true
    end
end

--lua custom scripts end

return ItemBagTemplate