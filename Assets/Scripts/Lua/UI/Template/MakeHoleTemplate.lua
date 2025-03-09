--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/BaseUITemplate"
--lua requires end

--lua model
module("UITemplate", package.seeall)

--lua model end

--lua fields
local super = UITemplate.BaseUITemplate
local attrUtil = MgrMgr:GetMgr("AttrDescUtil")
--lua fields end

--lua class define
---@class MakeHoleTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field CardBg MoonClient.MLuaUICom
---@field CardImage MoonClient.MLuaUICom
---@field Lock MoonClient.MLuaUICom
---@field CardIcon MoonClient.MLuaUICom
---@field Select MoonClient.MLuaUICom
---@field Property MoonClient.MLuaUICom
---@field PropertyText MoonClient.MLuaUICom
---@field PropertyOpen MoonClient.MLuaUICom
---@field OpenText MoonClient.MLuaUICom
---@field NoProperty MoonClient.MLuaUICom
---@field CardPropertyPanel MoonClient.MLuaUICom
---@field CardName MoonClient.MLuaUICom
---@field CardProperty MoonClient.MLuaUICom
---@field RecastButton MoonClient.MLuaUICom
---@field GotoCardButton MoonClient.MLuaUICom
---@field RedSignPrompt MoonClient.MLuaUICom
---@field EffectMakeHole MoonClient.MLuaUICom

---@class MakeHoleTemplate : BaseUITemplate
---@field Parameter MakeHoleTemplateParameter

MakeHoleTemplate = class("MakeHoleTemplate", super)
--lua class define end

--lua functions
function MakeHoleTemplate:Init()
    super.Init(self)
    self._equipData = nil
    self._fxId1 = 0
    self.Parameter.EffectMakeHole:SetActiveEx(false)
    self.Parameter.RecastButton:AddClick(function()
        self.MethodCallback(self.ShowIndex)
    end)
    self.Parameter.GotoCardButton:AddClick(function()
        CommonUI.Dialog.ShowYesNoDlg(
                true, nil,
                Lang("MakeHole_GotoCardText"),
                function()
                    self:_onGotoCardButton()
                end
        )
    end)

    self._cardItem = self:NewTemplate("ItemTemplate", { IsActive = false, TemplateParent = self.Parameter.CardIcon.transform })
end --func end
--next--
function MakeHoleTemplate:OnDestroy()
    self._cardItem = nil
end --func end
--next--
function MakeHoleTemplate:OnDeActive()
    -- do nothing
end --func end
--next--
function MakeHoleTemplate:OnSetData(data, isShowEffect)
    self._equipData = data
    self:_showHoleProperty(data, isShowEffect)
end --func end

--next--
--lua functions end

--lua custom scripts
---@param itemData ItemData
function MakeHoleTemplate:_showHoleProperty(itemData, isShowEffect)
    self.Parameter.CardIcon:SetActiveEx(false)
    self.Parameter.Property:SetActiveEx(false)
    self.Parameter.NoProperty:SetActiveEx(false)
    self.Parameter.Lock:SetActiveEx(false)
    self.Parameter.Select:SetActiveEx(false)
    self.Parameter.GotoCardButton:SetActiveEx(false)
    self.Parameter.CardPropertyPanel:SetActiveEx(false)
    self.Parameter.CardBg:SetActiveEx(true)
    self.Parameter.RecastButton:SetActiveEx(false)
    self:_showFirstMakeHoleRedSign()

    local l_openHoleCount = itemData:GetOpenHoleCount()

    if self.ShowIndex > l_openHoleCount then
        self.Parameter.NoProperty:SetActiveEx(true)
        self.Parameter.Lock:SetActiveEx(true)
    else
        --- 因为每个孔只能有一张卡
        local l_currentHoleInfo = itemData.AttrSet[GameEnum.EItemAttrModuleType.Card][self.ShowIndex][1]
        if nil == l_currentHoleInfo then
            l_currentHoleInfo = itemData.AttrSet[GameEnum.EItemAttrModuleType.Hole][self.ShowIndex][1]
            self:_showRecastButton(l_currentHoleInfo.TableID)
            self.Parameter.GotoCardButton:SetActiveEx(true)
            self.Parameter.Property:SetActiveEx(true)
            self.Parameter.PropertyText.LabText = self:_getHoleAttrStr(itemData, self.ShowIndex)
            self:_showPropertyOpen(l_currentHoleInfo.TableID, itemData)
        else
            --- 如果有卡直接不显示打洞重铸按钮
            self.Parameter.RecastButton:SetActiveEx(false)
            self.Parameter.CardIcon:SetActiveEx(true)
            self.Parameter.CardBg:SetActiveEx(false)
            local locItemData = Data.BagModel:CreateItemWithTid(l_currentHoleInfo.AttrID)
            if l_currentHoleInfo.ExpireTime ~= 0 then
                if locItemData:GetExistTime() ~= 0 then
                    local expireTime = l_currentHoleInfo.ExpireTime + locItemData:GetExistTime()
                    locItemData.EffectiveTime = expireTime
                end
            end

            locItemData.UID = 1
            self._cardItem:SetData({ PropInfo = locItemData, IsShowCount = false })
            local l_itemTableInfo = TableUtil.GetItemTable().GetRowByItemID(l_currentHoleInfo.AttrID)
            self.Parameter.CardName.LabText = l_itemTableInfo.ItemName
            self.Parameter.CardPropertyPanel:SetActiveEx(true)
            local l_cardInfo = TableUtil.GetEquipCardTable().GetRowByID(l_currentHoleInfo.AttrID)
            local l_attrs = {}

            --有卡片显示卡片属性
            for i = 0, l_cardInfo.CardAttributes.Length - 1 do
                local l_attr = {}
                l_attr.type = l_cardInfo.CardAttributes[i][0]
                l_attr.id = l_cardInfo.CardAttributes[i][1]
                l_attr.val = l_cardInfo.CardAttributes[i][2]
                ---@type ItemAttrData
                local itemAttrs = Data.ItemAttrData.new(l_attr.type, l_attr.id, l_attr.val, 0, nil)
                table.insert(l_attrs, itemAttrs)
            end

            local l_attrText = self:_getAttrStr(l_attrs)
            self.Parameter.CardProperty.LabText = l_attrText
        end
    end

    if isShowEffect then
        if self.ShowIndex == l_openHoleCount then
            self:_showFx()
        end
    end
end

--- 获取属性拼接后的字符串
---@param itemData ItemData
function MakeHoleTemplate:_getHoleAttrStr(itemData, index)
    local attrSet = itemData.AttrSet[GameEnum.EItemAttrModuleType.Hole][index]
    if nil == attrSet then
        logError("[MakeHoleTemp] hole attrs got nil")
        return "[MakeHoleTemp] hole attrs got nil"
    end

    return self:_getAttrStr(attrSet)
end

---@param itemAttrDataList ItemAttrData[]
function MakeHoleTemplate:_getAttrStr(itemAttrDataList)
    if nil == itemAttrDataList then
        return "[MakeHoleTemp] attrs got nil"
    end

    local ret = ""
    for i = 1, #itemAttrDataList do
        local singleAttr = itemAttrDataList[i]
        local colorTag = nil
        if 0 == singleAttr.TableID then
            ret = ret .. attrUtil.GetAttrStr(singleAttr, colorTag).Desc .. ";"
        else
            local l_holeTableInfo = TableUtil.GetEquipHoleTable().GetRowById(singleAttr.TableID, true)
            if nil == l_holeTableInfo then
                ret = ret .. attrUtil.GetAttrStr(singleAttr, nil).Desc .. ";"
                return ret
            end

            colorTag = RoQuality.GetColorTag(l_holeTableInfo.Quality)
            ret = ret .. attrUtil.GetAttrStr(singleAttr, colorTag).Desc .. ";"
        end
    end

    return ret
end

function MakeHoleTemplate:OnSelect()
    self.Parameter.Select:SetActiveEx(true)
end

function MakeHoleTemplate:OnDeselect()
    self.Parameter.Select:SetActiveEx(false)
end

function MakeHoleTemplate:_showFx()
    if self._fxId1 > 0 then
        self:DestroyUIEffect(self._fxId1)
    end

    local l_fxData = {}
    l_fxData.rawImage = self.Parameter.EffectMakeHole.RawImg
    l_fxData.destroyHandler = function()
        self._fxId1 = 0
    end

    l_fxData.scaleFac = Vector3.New(4.316494, 3.736306, 4.316494)
    self._fxId1 = self:CreateUIEffect("Effects/Prefabs/Creature/Ui/Fx_Ui_DaDong_01", l_fxData)

end

function MakeHoleTemplate:_showRecastButton(equipHoleTableId)
    local l_holeTableInfo = TableUtil.GetEquipHoleTable().GetRowById(equipHoleTableId)
    if nil == l_holeTableInfo then
        logError("[Card] invalid attr table id: " .. tostring(equipHoleTableId))
        return
    end

    local l_holeTableInfoCount = 0
    local l_holeTableInfos = TableUtil.GetEquipHoleTable().GetTable()

    for i = 1, #l_holeTableInfos do
        if l_holeTableInfos[i].ThesaurusId == l_holeTableInfo.ThesaurusId then
            l_holeTableInfoCount = l_holeTableInfoCount + 1
        end
    end

    if l_holeTableInfoCount > 1 then
        self.Parameter.RecastButton:SetActiveEx(true)
    else
        self.Parameter.RecastButton:SetActiveEx(false)
    end
end

---@param itemData ItemData
function MakeHoleTemplate:_showPropertyOpen(equipHoleTableId, itemData)
    self.Parameter.PropertyOpen:SetActiveEx(false)
    local l_holeTableInfo = TableUtil.GetEquipHoleTable().GetRowById(equipHoleTableId)
    if nil == l_holeTableInfo then
        return
    end

    local l_id = l_holeTableInfo.Activition[0]
    local l_value = l_holeTableInfo.Activition[1]

    if l_id == 1 then
        if itemData.RefineLv >= l_value then
            return
        end
    elseif l_id == 2 then
        if MgrMgr:GetMgr("AchievementMgr").IsFinishWithId(l_value) then
            return
        end
    else
        return
    end

    local l_openText = MgrMgr:GetMgr("EquipMakeHoleMgr").GetHoleOpenText(equipHoleTableId)
    if l_openText ~= nil then
        self.Parameter.PropertyOpen:SetActiveEx(true)
        self.Parameter.OpenText.LabText = l_openText
    end
end

function MakeHoleTemplate:_onGotoCardButton()
    local l_equipBG = UIMgr:GetUI(UI.CtrlNames.EquipBG)
    if l_equipBG then
        l_equipBG:ShowCard()
        local l_key = MgrMgr:GetMgr("EquipMakeHoleMgr").FirstMakeHoleTemplateGotoCardStorageKey
        UserDataManager.SetDataFromLua(l_key, MPlayerSetting.PLAYER_SETTING_GROUP, l_key)
    end
end

function MakeHoleTemplate:_showFirstMakeHoleRedSign()
    local l_isCanShowFirstMakeHoleRedSign = self:_isCanShowFirstMakeHoleRedSign()
    self.Parameter.RedSignPrompt:SetActiveEx(l_isCanShowFirstMakeHoleRedSign)
end

function MakeHoleTemplate:_isCanShowFirstMakeHoleRedSign()
    if self._equipData == nil then
        return false
    end

    if self.ShowIndex ~= 1 then
        return false
    end

    local l_mgr = MgrMgr:GetMgr("EquipMakeHoleMgr")
    local l_key = l_mgr.FirstMakeHoleTemplateGotoCardStorageKey
    local l_localStorageData = UserDataManager.GetStringDataOrDef(l_key, MPlayerSetting.PLAYER_SETTING_GROUP, "")

    --没有点击过去插卡的按钮
    if string.ro_isEmpty(l_localStorageData) then
        local l_uidKey = l_mgr.FirstMakeHoleRedSignStorageKey .. tostring(self._equipData.UID)
        local l_localEquipUidStorageData = UserDataManager.GetStringDataOrDef(l_uidKey, MPlayerSetting.PLAYER_SETTING_GROUP, "")
        --此装备第一次打过洞
        if not string.ro_isEmpty(l_localEquipUidStorageData) then
            return true
        end
    end
end
--lua custom scripts end
return MakeHoleTemplate