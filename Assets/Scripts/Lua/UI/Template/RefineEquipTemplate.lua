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
--lua fields end

--lua class define
---@class RefineEquipTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field Unidentified MoonClient.MLuaUICom
---@field Selected MoonClient.MLuaUICom
---@field RefineLv MoonClient.MLuaUICom
---@field Rare MoonClient.MLuaUICom
---@field Name MoonClient.MLuaUICom
---@field ItemPrompt MoonClient.MLuaUICom
---@field ItemHole MoonClient.MLuaUICom
---@field ItemButton MoonClient.MLuaUICom
---@field ImgHole4 MoonClient.MLuaUICom
---@field ImgHole3 MoonClient.MLuaUICom
---@field ImgHole2 MoonClient.MLuaUICom
---@field ImgHole1 MoonClient.MLuaUICom
---@field ImageEquipFlag MoonClient.MLuaUICom
---@field GenreText MoonClient.MLuaUICom
---@field EquipIconBg MoonClient.MLuaUICom
---@field EquipIcon MoonClient.MLuaUICom
---@field Damage MoonClient.MLuaUICom

---@class RefineEquipTemplate : BaseUITemplate
---@field Parameter RefineEquipTemplateParameter

RefineEquipTemplate = class("RefineEquipTemplate", super)
--lua class define end

--lua functions
function RefineEquipTemplate:Init()
    super.Init(self)


end --func end
--next--
function RefineEquipTemplate:OnDeActive()

    self.data = nil

end --func end
--next--
function RefineEquipTemplate:OnSetData(data)

    self:showEquipItem(data)

end --func end

--next--
--lua functions end

--lua custom scripts
---@param equipData ItemData
function RefineEquipTemplate:showEquipItem(equipData)
    self.data = equipData
    self:SetSelect(MgrMgr:GetMgr("SelectEquipMgr").g_currentSelectIndex == self.ShowIndex)
    local itemTableInfo = equipData.ItemConfig
    self.Parameter.EquipIcon:SetSprite(itemTableInfo.ItemAtlas, itemTableInfo.ItemIcon, true)
    local l_text = itemTableInfo.ItemName
    self.Parameter.RefineLv.gameObject:SetActiveEx(false)
    self.Parameter.Unidentified.gameObject:SetActiveEx(false)
    self.Parameter.Damage.gameObject:SetActiveEx(false)
    self.Parameter.Rare.gameObject:SetActiveEx(false)
    local l_holeList = {}
    for i = 1, 4 do
        l_holeList[i] = self.Parameter.ItemHole.transform:Find("ImgHole" .. i):GetComponent("MLuaUICom")
        l_holeList[i].gameObject:SetActiveEx(false)
    end
    if MgrMgr:GetMgr("SelectEquipMgr").g_equipSystem ~= MgrMgr:GetMgr("SelectEquipMgr").EquipSystem.Forge then
        --精炼等级
        if equipData.RefineLv > 0 then
            l_text = StringEx.Format("+{0}" .. l_text, equipData.RefineLv)
            self.Parameter.RefineLv.gameObject:SetActiveEx(true)
            self.Parameter.RefineLv.LabText = StringEx.Format("+{0}", equipData.RefineLv)
        end
        --洞
        if itemTableInfo.TypeTab == 1 then
            MgrMgr:GetMgr("EquipMgr").SetEquipIconHole(equipData, l_holeList)
            self.Parameter.Unidentified.gameObject:SetActiveEx(false)
        end

        if equipData.Damaged then
            --损坏
            self.Parameter.Damage.gameObject:SetActiveEx(true)
            self.Parameter.Damage:SetSprite("Common", "UI_Common_IconPosun.png")
            self.Parameter.Rare.gameObject:SetActiveEx(false)
        elseif equipData.RefineSealLv > 0 then
            --封印
            self.Parameter.Damage.gameObject:SetActiveEx(true)
            self.Parameter.Damage:SetSprite("Common", "UI_Common_IconSeal.png")
            self.Parameter.Rare.gameObject:SetActiveEx(false)
        else
            self.Parameter.Damage.gameObject:SetActiveEx(false)
            self.Parameter.Rare.gameObject:SetActiveEx(MgrMgr:GetMgr("EquipMgr").IsRaity(equipData))
        end
    end
    self.Parameter.Name.LabText = l_text
    self.Parameter.ImageEquipFlag.gameObject:SetActiveEx(MgrMgr:GetMgr("EquipMgr").CheckEquipIsBody(equipData.UID))
    local genreText = MgrMgr:GetMgr("EquipMgr").GetGenreText(equipData.TID)
    if genreText == nil then
        self.Parameter.GenreText.gameObject:SetActiveEx(false)
    else
        self.Parameter.GenreText.gameObject:SetActiveEx(true)
        self.Parameter.GenreText.LabText = Common.Utils.Lang("Equip_Genre") .. "：" .. genreText
    end

    self.Parameter.ItemButton:AddClick(function()
        UIMgr:DeActiveUI(UI.CtrlNames.CommonItemTips)
        self:MethodCallback(self)
        self:SetSelect(true)
    end)
end
function RefineEquipTemplate:SetSelect(isShow)
    self.Parameter.Selected.gameObject:SetActiveEx(isShow)
end
--lua custom scripts end
return RefineEquipTemplate