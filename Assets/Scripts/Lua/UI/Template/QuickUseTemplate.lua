--this file is gen by script
--you can edit this file in custom part

--lua requires
require "UI/BaseUITemplate"
require "ModuleMgr/ShortCutItemMgr"
--lua requires end

--lua model
module("UITemplate", package.seeall)

--lua model end

--lua fields
local super = UITemplate.BaseUITemplate
local slotCount = 4
--lua fields end

--lua class define
---@class QuickUseTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field TxtQuick MoonClient.MLuaUICom[]
---@field TxtCd MoonClient.MLuaUICom[]
---@field Offset MoonClient.MLuaUICom
---@field ImgQuick MoonClient.MLuaUICom[]
---@field ImgCd MoonClient.MLuaUICom[]
---@field BtnQuick MoonClient.MLuaUICom[]
---@field Add MoonClient.MLuaUICom[]

---@class QuickUseTemplate : BaseUITemplate
---@field Parameter QuickUseTemplateParameter

QuickUseTemplate = class("QuickUseTemplate", super)
--lua class define end

--lua functions
function QuickUseTemplate:Init()
    super.Init(self)
end --func end
--next--
function QuickUseTemplate:OnDeActive()
end --func end
--next--

function QuickUseTemplate:Refresh(page)
    self:SetData({ page = page })
end

function QuickUseTemplate:OnSetData(data)
    self.data = data
    local start = (data.page - 1) * slotCount
    for i = 1, slotCount do
        local l_info = MgrProxy:GetShortCutItemMgr().GetItemByIdx(start + i)
        local count = 0
        if nil ~= l_info then
            count = l_info.ItemCount
        end

        self:RefreshQuick(l_info, data.page, i, count)
    end
end --func end

---@param itemData ItemData
function QuickUseTemplate:RefreshQuick(itemData, page, i, num)
    local start = (page - 1) * slotCount
    self.Parameter.ImgCd[i].gameObject:SetActiveEx(false)
    self.Parameter.TxtCd[i].gameObject:SetActiveEx(false)
    self.Parameter.ImgQuick[i].gameObject.transform:SetLocalScale(0.4, 0.4, 1)
    self.Parameter.BtnQuick[i].gameObject:SetActiveEx(true)

    local onClick = function()
        local l_info = MgrProxy:GetShortCutItemMgr().GetItemByIdx(start + i)
        if nil == l_info then
            Data.BagModel:mdOpenModel(Data.BagModel.OpenModel.QuickItem)
            UIMgr:ActiveUI(UI.CtrlNames.Bag)
            return
        end

        --- 如果快捷使用当中点击了卡普拉贵宾卡，这个时候直接开启界面，不会触发使用协议
        --- 但是快捷栏当中的道具是重新生成的，所以需要重新找一个真实道具出来，才能有对应的一些功能
        local capraCardMgr = MgrMgr:GetMgr("CapraCardMgr")
        if capraCardMgr.IsCapraCard(l_info.TID) then
            local targetItem = nil
            local l_types = { GameEnum.EBagContainerType.Bag }
            local l_itemFuncUtil = MgrProxy:GetItemDataFuncUtil()
            local condition1 = { Cond = l_itemFuncUtil.ItemMatchesTid, Param = l_info.TID }
            local conditions = { condition1 }
            ---@return ItemData[]
            local retItemList = Data.BagApi:GetItemsByTypesAndConds(l_types, conditions)
            targetItem = retItemList[1]
            if nil ~= targetItem then
                capraCardMgr.ShowCapraCard(targetItem)
            else
                logError("[QuickUseItem] try to open capra card, but itemdata got nil, id: " .. tostring(l_info.TID))
            end

            return
        end

        MgrProxy:GetShortCutItemMgr().UseItemByItemData(l_info)
    end

    self.Parameter.BtnQuick[i]:AddClick(onClick)
    self.Parameter.ImgQuick[i].gameObject:SetActiveEx(itemData ~= nil)
    self.Parameter.Add[i].gameObject:SetActiveEx(itemData == nil)
    self.Parameter.TxtQuick[i].gameObject:SetActiveEx(itemData ~= nil and num > 1)
    self.Parameter.TxtQuick[i].LabText = tostring(num)
    local l_color = self.Parameter.ImgQuick[i].Img.color
    l_color.a = 0 >= num and 0.47 or 1
    self.Parameter.ImgQuick[i].Img.color = l_color
    if itemData then
        self.Parameter.ImgQuick[i]:SetSprite(itemData.ItemConfig.ItemAtlas, itemData.ItemConfig.ItemIcon, true)
    end
end

function QuickUseTemplate:RefreshCd()
    local start = (self.data.page - 1) * slotCount
    for i = 1, slotCount do
        local l_info = MgrProxy:GetShortCutItemMgr().GetItemByIdx(start + i)
        if l_info then
            local l_cd = MgrMgr:GetMgr("ItemCdMgr").GetCd(l_info.TID)
            l_cd = math.ceil(l_cd)
            if l_cd >= 1 then
                self.Parameter.ImgCd[i].gameObject:SetActiveEx(true)
                self.Parameter.TxtCd[i].gameObject:SetActiveEx(true)
                self.Parameter.TxtCd[i].LabText = l_cd
                local l_allCd = MgrMgr:GetMgr("ItemCdMgr").GetCdFromTable(l_info.TID)
                self.Parameter.ImgCd[i].Img.fillAmount = l_cd / l_allCd
            elseif l_cd > 0 then
                self.Parameter.TxtCd[i].gameObject:SetActiveEx(false)
                self.Parameter.ImgCd[i].gameObject:SetActiveEx(true)
                local l_allCd = MgrMgr:GetMgr("ItemCdMgr").GetCdFromTable(l_info.TID)
                self.Parameter.ImgCd[i].Img.fillAmount = l_cd / l_allCd
            else
                self.Parameter.ImgCd[i].gameObject:SetActiveEx(false)
                self.Parameter.TxtCd[i].gameObject:SetActiveEx(false)
            end
        end
    end
end

--next--
--lua functions end

--lua custom scripts

--lua custom scripts end
return QuickUseTemplate