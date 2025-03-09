--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/BaseUITemplate"
require "UI/Template/ItemEquipPartTemplate"
require "UI/Template/ItemCardPartTemplate"
require "UI/Template/ItemFlagPartTemplate"
require "UI/Template/ItemCostPartTemplate"
require "UI/Template/ItemCountdownPartTemplate"
require "UI/Template/ItemMonthCardPart"
require "UI/Template/ItemCdPartTemplate"
require "UI/Template/ItemBeiluzPart"
--lua requires end

--lua model
module("UITemplate", package.seeall)

--lua model end

--lua fields
local super = UITemplate.BaseUITemplate
--lua fields end

--lua class define
---@class ItemTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field ItemName MoonClient.MLuaUICom
---@field ItemIcon MoonClient.MLuaUICom
---@field ItemCount MoonClient.MLuaUICom
---@field ItemButton MoonClient.MLuaUICom
---@field ImgMask MoonClient.MLuaUICom
---@field Img_Recommend MoonClient.MLuaUICom

---@class ItemTemplate : BaseUITemplate
---@field Parameter ItemTemplateParameter

ItemTemplate = class("ItemTemplate", super)
--lua class define end

--lua functions
function ItemTemplate:Init()

    super.Init(self)
    self.isShowCount = true
    self.count = 0
    self.propInfo = nil
    --数量有上限下限
    self.countHaveMax = nil
    self.equipPart = nil
    self.cardPart = nil
    self.flagPart = nil
    self.cdPart = nil
    self.costPart = nil
    self.countDownPart = nil
    self.monthCardPart = nil
    self.awardPreviewPart = nil
    self._destroyEquipPart = nil
    self.Parameter.ItemCount.LabText = ""
    self.Parameter.ItemName:SetActiveEx(false)
    self.Parameter.ImgMask.gameObject:SetActiveEx(false)

end --func end
--next--
function ItemTemplate:OnSetData(data)

    local mergedData = self:_mergeParams(data)
    self:showItem(mergedData)

end --func end
--next--
function ItemTemplate:OnDeActive()

    self.propInfo = nil
    self:ClearTemplate()
    self.Parameter.ItemButton:AddClick(nil)

end --func end
--next--
function ItemTemplate:OnDestroy()

    self:ClearTemplate()
    -- item大小的设置，和prefab上的值对齐
    local L_CONST_SIZE_CONFIG = {
        width = 72,
        height = 72,
    }
    self:transform().anchoredPosition = Vector2.zero
    self:transform().anchorMax = Vector2(0.5, 0.5)
    self:transform().anchorMin = Vector2(0.5, 0.5)
    MLuaCommonHelper.SetLocalScale(self:transform(), 1, 1, 1)
    MLuaCommonHelper.SetRectTransformSize(self:gameObject(), L_CONST_SIZE_CONFIG.width, L_CONST_SIZE_CONFIG.height)
    -- 如果这个地方没有置空，会出现一个按钮重用的问题
    self.Parameter.ItemButton.ConBtn.OnContinuousButton = nil
    self.Parameter.ItemButton.ConBtn.OnButtonDown = nil
    self.Parameter.ItemButton.ConBtn.OnButtonUp = nil

end --func end
--next--
function ItemTemplate:BindEvents()


end --func end
--next--
--lua functions end

--lua custom scripts
ItemTemplate.TemplatePath = "UI/Prefabs/ItemPrefab"
local _ItemEquipPartTemplate = "ItemEquipPartTemplate"
local _ItemCardPartTemplate = "ItemCardPartTemplate"
local _ItemFlagPartTemplate = "ItemFlagPartTemplate"
local _ItemCostPartTemplate = "ItemCostPartTemplate"
local _ItemCountdownPartTemplate = "ItemCountdownPartTemplate"
local _AwardPreviewItemTemplate = "AwardPreviewItemTemplate"
local _ItemMonthCardTemplate = "ItemMonthCardPart"
local _ItemDestroyEquipPartTemplate = "ItemDestroyEquipPartTemplate"
local _ItemBeiluzPartTemplate = "ItemBeiluzPart"

function ItemTemplate:ctor(itemData)
    if itemData == nil then
        itemData = {}
    end
    super.ctor(self, itemData)
end

function ItemTemplate:ShowTaskItem(data)
    self.Parameter.ItemIcon:SetSpriteAsync(data.ItemAtlas, data.ItemIcon, nil, self.Parameter.ItemIcon.Img.type == UnityEngine.UI.Image.Type.Simple)
    self.Parameter.ItemCount:SetActiveEx(false)
    local l_name = data.ItemName
    if not Common.Utils.IsNilOrEmpty(l_name) then
        self.Parameter.ItemName.gameObject:SetActiveEx(true)
        self.Parameter.ItemName.LabText = l_name
    else
        self.Parameter.ItemName.gameObject:SetActiveEx(false)
    end

    self:SetParent(data.ItemParent)
    self:SetGameObjectActive(true)

    self.Parameter.ItemButton:AddClick(nil)
end

-->PropInfo 道具数据
-->ID 道具id
-->IsShowName 是否显示名字 默认不显示
-->IsShowCount 是否显示数量，默认显示
-->IsShowTips 点击是否弹出tips，默认弹出
-->Count 显示的道具数量。不传默认为PropInfo中的数量，只传id默认为1
-->IsShowRequire 是否显示需求数量，默认不显示
-->CustomName 自定义装备名字
-->RequireCount 需求个数
-->RequireMaxCount 需求个数显示的最大个数
-->HideButton 是否隐藏按钮背景
-->ButtonMethod 点击时调用的方法
-->ContinuousButtonMethod 长按点击事件
-->ContinuousButtonUpMethod 长按点击抬起事件
-->ContinuousButtonDownMethod 长按点击按下事件
-->ItemParent 此item的父物体
-->IsActive 是否显示，默认为显示
-->IsShowEquipFlag 显示已装备标签
-->IsGray 是否置灰
-->IsLock 是否锁住
-->IsShowRequireSign 是否显示需求标记
-->RequireSignType 显示需求的类型，使用UI.CtrlNames
-->IsAssist 助战奖励标签
-->isParticular稀有掉率
-->dropRate掉率提升
-->probablyType 概率类型，0，无类型；1必得，2有概率得到
-->IsShowEquipMultiTalentFlag 是否显示装备多方案的标志
-->IsShowBagEquipCanWearFlag 背包里的可装备标记
-->IsShowDestroyEquipPart 装备破坏
--TipsRelativePos  Tips的自定义位置
--PropInfo和ID必传一个
--- 这个方法是用来显示默认值的，在这个默认值范围内的参数会被认为合法
---@param param ItemTemplateParam
---@return ItemTemplateParam
function ItemTemplate:_mergeParams(param)
    --- 这个做法是要限制参数一定在我定义的范围内，防止有人不断的添加参数，但是这个地方不知道
    --- 但是table当中如果value是nil表示删除，所以需要一个非法值填上
    local C_DEFAULT_NIL_VALUE = "NIL"

    ---@class ItemTemplateParam
    local orgParam = {
        ---@type ItemData
        PropInfo = C_DEFAULT_NIL_VALUE,
        ID = 0,
        IsShowName = false,
        CustomName = C_DEFAULT_NIL_VALUE,
        IsShowCount = true,
        IsShowTips = true,
        Count = C_DEFAULT_NIL_VALUE,
        IsShowRequire = false,
        RequireCount = 0,
        RequireMaxCount = C_DEFAULT_NIL_VALUE,
        HideButton = false,
        ButtonMethod = C_DEFAULT_NIL_VALUE,
        ContinuousButtonMethod = C_DEFAULT_NIL_VALUE,
        ContinuousButtonUpMethod = C_DEFAULT_NIL_VALUE,
        ContinuousButtonDownMethod = C_DEFAULT_NIL_VALUE,
        ItemParent = C_DEFAULT_NIL_VALUE,
        IsActive = true,
        IsShowEquipFlag = false,
        IsGray = false,
        IsLock = false,
        IsShowRequireSign = false,
        RequireSignType = C_DEFAULT_NIL_VALUE,
        IsAssist = false,
        isParticular = false,
        probablyType = 0,
        dropRate = 0,
        IsShowEquipMultiTalentFlag = false,
        IsShowBagEquipCanWearFlag = false,
        IsShowDestroyEquipPart = false,
        TipsRelativePos = C_DEFAULT_NIL_VALUE,
        NameColor = C_DEFAULT_NIL_VALUE,
        CustomBtnAtlas = C_DEFAULT_NIL_VALUE,
        CustomBtnImgType = C_DEFAULT_NIL_VALUE,
        CustomBtnSprite = C_DEFAULT_NIL_VALUE,
        IsHave = false,
        CountHaveMax = false,
        NeedRedMask = false,
        IsShowCloseButton = false,
    }

    if nil == param then
        return orgParam
    end

    for k, v in pairs(orgParam) do
        if nil ~= param[k] then
            orgParam[k] = param[k]
        end
    end

    for k, v in pairs(orgParam) do
        if C_DEFAULT_NIL_VALUE == v then
            orgParam[k] = nil
        end
    end

    return orgParam
end

---@param data ItemTemplateParam
function ItemTemplate:showItem(data)
    self.Parameter.ItemCount.LabText = ""
    self.Parameter.ItemName:SetActiveEx(false)
    self.Parameter.ImgMask.gameObject:SetActiveEx(false)
    if not data.PropInfo and 0 == data.ID then
        -- 空数据显示未空板
        self:ClearTemplate()
        return
    end
    self.propInfo = nil
    if data.PropInfo then
        self.propInfo = data.PropInfo
    elseif nil == self.propInfo and 0 ~= data.ID then
        local locItemData = Data.BagModel:CreateItemWithTid(data.ID)
        if locItemData == nil then
            logError("根据道具id创建道具数据时发现表里没有配这条数据，道具id："..tostring(data.ID))
            return
        end
        self.propInfo = locItemData
        data.PropInfo = locItemData
        if nil ~= data.Count then
            self.propInfo.ItemCount = ToInt64(data.Count)
        else
            self.propInfo.ItemCount = ToInt64(1)
        end
    end

    local itemTableInfo = self.propInfo.ItemConfig
    --默认颜色
    local nameColor = Color.New(102 / 255, 125 / 255, 177 / 255, 1)
    local customName = nil
    local isShowName = false
    local isShowTips = true
    local buttonMethod = nil
    local isActive = true
    --按钮图集
    local customBtnAtlas = nil
    --按钮sprite
    local customBtnSprite = nil
    local customBtnImgType = nil
    --默认按钮是有事件的
    local hideButton = false
    local requireSignType = nil
    self.isShowCount = data.IsShowCount
    isShowTips = data.IsShowTips
    isShowName = data.IsShowName
    if nil == data.Count then
        self.count = self.propInfo.ItemCount
    else
        self.count = data.Count
    end

    isActive = data.IsActive
    hideButton = data.HideButton
    self.countHaveMax = data.CountHaveMax

    if data.NameColor ~= nil then
        nameColor = data.NameColor
    end
    if data.CustomBtnAtlas ~= nil then
        customBtnAtlas = data.CustomBtnAtlas
    end
    if data.CustomBtnSprite ~= nil then
        customBtnSprite = data.CustomBtnSprite
    end
    if data.CustomBtnImgType ~= nil then
        customBtnImgType = data.CustomBtnImgType
    end
    if data.RequireSignType then
        requireSignType = data.RequireSignType
    end
    if data.CustomName ~= nil then
        customName = data.CustomName
    end

    buttonMethod = data.ButtonMethod
    local l_bgAtlas = "Common"
    local l_bgIcon = Data.BagModel:getItemBg(self.propInfo)
    if customBtnAtlas ~= nil and customBtnSprite ~= nil then
        l_bgAtlas = customBtnAtlas
        l_bgIcon = customBtnSprite
    end

    self.Parameter.Img_Recommend.gameObject:SetActiveEx(false)
    self.Parameter.ItemName.gameObject:SetActiveEx(isShowName)
    if isShowName then
        local l_str = itemTableInfo.ItemName
        if string.ro_len(l_str) > 10 then
            l_str = string.ro_cut(itemTableInfo.ItemName, 10) .. "..."
        end
        if customName ~= nil then
            self.Parameter.ItemName.LabText = customName
        else
            self.Parameter.ItemName.LabText = l_str
        end
        self.Parameter.ItemName.LabColor = nameColor
    end
    self.Parameter.ItemIcon:SetSpriteAsync(itemTableInfo.ItemAtlas, itemTableInfo.ItemIcon, nil, self.Parameter.ItemIcon.Img.type == UnityEngine.UI.Image.Type.Simple)
    self:RenewalCount()

    --- 如果启用了红色遮罩，就会点亮这个图片
    if data.NeedRedMask then
        ---@type RoColor
        local C_RED_MASK_COLOR = {
            r = 102 / 255,
            g = 125 / 255,
            b = 177 / 255,
            a = 100 / 255,
        }

        self.Parameter.ImgMask.gameObject:SetActiveEx(true)
        self.Parameter.ImgMask.Img.color = Color.New(C_RED_MASK_COLOR.r, C_RED_MASK_COLOR.g, C_RED_MASK_COLOR.b, C_RED_MASK_COLOR.a)
    end

    if self:IsNeedEquipPart(self.propInfo) then
        if not self.equipPart then
            self.equipPart = self:NewTemplate(_ItemEquipPartTemplate, { Data = data, TemplateParent = self:transform() })
        else
            self.equipPart:SetData(data)
        end
    else
        if self.equipPart then
            self:UninitTemplate(self.equipPart)
            self.equipPart = nil
        end
    end

    if self:IsNeedCardPart(itemTableInfo.TypeTab) then
        if not self.cardPart then
            self.cardPart = self:NewTemplate(_ItemCardPartTemplate, { Data = data, TemplateParent = self:transform() })
        else
            self.cardPart:SetData(data)
        end
        l_bgAtlas, l_bgIcon = self.cardPart.bgAtlas, self.cardPart.bgIcon
    else
        if self.cardPart then
            self:UninitTemplate(self.cardPart)
            self.cardPart = nil
        end
    end

    if self:IsNeedCostPart(data) then
        if not self.costPart then
            self.costPart = self:NewTemplate(_ItemCostPartTemplate, { Data = data, TemplateParent = self:transform() })
        else
            self.costPart:SetData(data)
        end
    else
        if self.costPart then
            self:UninitTemplate(self.costPart)
            self.costPart = nil
        end
    end

    if self:IsNeedFlagPart(data) then
        if not self.flagPart then
            self.flagPart = self:NewTemplate(_ItemFlagPartTemplate, { Data = data, TemplateParent = self:transform() })
        else
            self.flagPart:SetData(data)
        end
    else
        if self.flagPart then
            self:UninitTemplate(self.flagPart)
            self.flagPart = nil
        end
    end

    if self.propInfo:NeedShowTimer() then
        if not self.countDownPart then
            self.countDownPart = self:NewTemplate(_ItemCountdownPartTemplate, { Data = data, TemplateParent = self:transform() })
        else
            self.countDownPart:SetData(data)
        end
    else
        if self.countDownPart then
            self:UninitTemplate(self.countDownPart)
            self.countDownPart = nil
        end
    end

    local l_curDungeonId = MPlayerInfo.PlayerDungeonsInfo.DungeonID
    local l_isDelegateDungeon = MgrMgr:GetMgr("DelegateModuleMgr").ValidateDungeonIdIsDelegate(l_curDungeonId) --是否是委托副本
    local l_isMonthCard = MgrMgr:GetMgr("MonthCardMgr").GetIsBuyMonthCard() --是否购买了月卡
    local l_isNeedShow = itemTableInfo.ItemID == 201 or itemTableInfo.ItemID == 202
    if l_isDelegateDungeon and l_isMonthCard and l_isNeedShow then
        -- if true then
        if not self.monthCardPart then
            self.monthCardPart = self:NewTemplate(_ItemMonthCardTemplate, { Data = {}, TemplateParent = self:transform() })
        else
            self.monthCardPart:SetData(data)
        end
    else
        if self.monthCardPart then
            self:UninitTemplate(self.monthCardPart)
            self.monthCardPart = nil
        end
    end

    if data.dropRate ~= nil or data.isParticular ~= nil or data.probablyType ~= nil then
        if not self.awardPreviewPart then
            self.awardPreviewPart = self:NewTemplate(_AwardPreviewItemTemplate, { Data = data, TemplateParent = self:transform() })
        end
        self.awardPreviewPart:SetData(data)
    else
        if self.awardPreviewPart then
            self:UninitTemplate(self.awardPreviewPart)
            self.awardPreviewPart = nil
        end
    end

    if data.IsShowDestroyEquipPart then
        if not self._destroyEquipPart then
            self._destroyEquipPart = self:NewTemplate(_ItemDestroyEquipPartTemplate, { Data = data, TemplateParent = self:transform() })
        end

        self._destroyEquipPart:SetData(data)
    else
        if self._destroyEquipPart then
            self:UninitTemplate(self._destroyEquipPart)
            self._destroyEquipPart = nil
        end
    end

    if self:IsBeiluz(data) then
        if not self._beiluzPart then
            self._beiluzPart = self:NewTemplate(_ItemBeiluzPartTemplate, { TemplateParent = self:transform(),
                                                                           LoadCallback = function(template)
                                                                               template:transform():SetSiblingIndex(1)
                                                                           end })
        end
        self._beiluzPart:SetData(data.PropInfo)
    else
        if self._beiluzPart then
            self:UninitTemplate(self._beiluzPart)
            self._beiluzPart = nil
        end
    end

    self.Parameter.ItemButton.Img.raycastTarget = not hideButton
    self.Parameter.ItemButton:SetSprite(l_bgAtlas, l_bgIcon, self.Parameter.ItemButton.Img.type == UnityEngine.UI.Image.Type.Simple)
    if not hideButton then

        if customBtnImgType ~= nil then
            self.Parameter.ItemButton.Img.type = customBtnImgType
        end

        if not buttonMethod then
            if isShowTips then
                local isShowRequire = self.costPart and self.costPart.isShowRequire or false
                local propInfo = self.propInfo
                local requireCount = self.costPart and self.costPart.requireCount or 0
                local currentCount = Data.BagModel:GetCoinOrPropNumById(self.propInfo.TID)
                buttonMethod = function()
                    local isShowAchieve = false
                    if isShowRequire then
                        --是否显示数量
                        if MgrMgr:GetMgr("PropMgr").IsCoin(propInfo.TID) == false then
                            --是否是金币类型
                            isShowAchieve = currentCount < requireCount
                        end
                    end

                    if data.TipsRelativePos == nil then
                        MgrMgr:GetMgr("ItemTipsMgr").ShowTipsDisplay(propInfo, self:transform(), nil, { IsShowCloseButton = data.IsShowCloseButton }, isShowAchieve)
                    else
                        MgrMgr:GetMgr("ItemTipsMgr").ShowTipsDisplay(propInfo, nil, nil, { IsShowCloseButton = data.IsShowCloseButton }, isShowAchieve, data.TipsRelativePos)
                    end
                end
            end
        end

        self.Parameter.ItemButton:AddClick(buttonMethod)

        --连续点击事件处理
        if data.ContinuousButtonMethod then
            self.Parameter.ItemButton.ConBtn.OnContinuousButton = data.ContinuousButtonMethod
        end

        if data.ContinuousButtonUpMethod then
            self.Parameter.ItemButton.ConBtn.OnButtonUp = data.ContinuousButtonUpMethod
        end

        if data.ContinuousButtonDownMethod then
            self.Parameter.ItemButton.ConBtn.OnButtonDown = data.ContinuousButtonDownMethod
        end
    end

    if data.ItemParent then
        self:SetParent(data.ItemParent)
    end

    self:SetGameObjectActive(isActive)
end

function ItemTemplate:RenewalCount()
    if self.count == nil or self.count <= 0 or self.isShowCount == false then
        self.Parameter.ItemCount.LabText = ""
        return
    end
    if self.isShowCount then
        local l_count = MNumberFormat.GetNumberFormat(tostring(self.count))
        if self.countHaveMax then
            l_count = l_count .. self.countHaveMax
        end
        self.Parameter.ItemCount.LabText = l_count
    end
end

---@param propInfo ItemData
function ItemTemplate:IsNeedEquipPart(propInfo)
    if nil == propInfo then
        return false
    end

    return nil ~= propInfo.EquipConfig
end

function ItemTemplate:IsNeedCardPart(itemType)
    return itemType == Data.BagModel.PropType.Card
end

---@param data ItemTemplateParam
function ItemTemplate:IsNeedFlagPart(data)
    return data.IsGray or
            data.IsLock or
            data.IsShowRequireSign or
            data.RequireSignType or
            data.IsShowEquipFlag or
            data.IsAssist or
            data.IsShowEquipMultiTalentFlag or
            data.IsShowBagEquipCanWearFlag or
            data.IsHave or
            (data.PropInfo and data.PropInfo.ItemConfig.TypeTab == Data.BagModel.PropType.CardFragment)
end

function ItemTemplate:IsNeedCostPart(data)
    return data.IsShowRequire or data.RequireCount
end

function ItemTemplate:IsBeiluz(data)
    return data.PropInfo and data.PropInfo.ItemConfig and data.PropInfo.ItemConfig.TypeTab == Data.BagModel.PropType.Beiluz
end

function ItemTemplate:ClearTemplate()
    self.Parameter.ImgMask:SetActiveEx(false)
    self.Parameter.Img_Recommend:SetActiveEx(false)
    self.Parameter.ItemIcon:Clear()
    self.Parameter.ItemCount.LabText = ""
    self.Parameter.ItemButton:SetActiveEx(true)
    if self.equipPart then
        self:UninitTemplate(self.equipPart)
        self.equipPart = nil
    end
    if self.cardPart then
        self:UninitTemplate(self.cardPart)
        self.cardPart = nil
    end
    if self.flagPart then
        self:UninitTemplate(self.flagPart)
        self.flagPart = nil
    end
    if self.costPart then
        self:UninitTemplate(self.costPart)
        self.costPart = nil
    end
    if self.cdPart then
        self:UninitTemplate(self.cdPart)
        self.cdPart = nil
    end
    if self.countDownPart then
        self:UninitTemplate(self.countDownPart)
        self.countDownPart = nil
    end
    if self.monthCardPart then
        self:UninitTemplate(self.monthCardPart)
        self.monthCardPart = nil
    end
    if self.awardPreviewPart then
        self:UninitTemplate(self.awardPreviewPart)
        self.awardPreviewPart = nil
    end
    if self._destroyEquipPart then
        self:UninitTemplate(self._destroyEquipPart)
        self._destroyEquipPart = nil
    end
    if self._beiluzPart then
        self:UninitTemplate(self._beiluzPart)
        self._beiluzPart = nil
    end

    local l_bgAtlas = "Common"
    local l_bgIcon = Data.BagModel:getItemBg(nil)
    self.Parameter.ItemButton:SetSprite(l_bgAtlas, l_bgIcon, self.Parameter.ItemButton.Img.type == UnityEngine.UI.Image.Type.Simple)
end
--lua custom scripts end
return ItemTemplate