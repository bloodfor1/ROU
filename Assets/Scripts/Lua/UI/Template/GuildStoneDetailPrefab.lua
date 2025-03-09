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
---@class GuildStoneDetailPrefabParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field Rank MoonClient.MLuaUICom
---@field Name MoonClient.MLuaUICom
---@field Love MoonClient.MLuaUICom
---@field Level MoonClient.MLuaUICom
---@field HelpCount MoonClient.MLuaUICom
---@field GiftNoGet MoonClient.MLuaUICom
---@field GiftGet MoonClient.MLuaUICom
---@field Choose MoonClient.MLuaUICom

---@class GuildStoneDetailPrefab : BaseUITemplate
---@field Parameter GuildStoneDetailPrefabParameter

GuildStoneDetailPrefab = class("GuildStoneDetailPrefab", super)
--lua class define end

--lua functions
function GuildStoneDetailPrefab:Init()
    
    super.Init(self)
    self.mgr = MgrMgr:GetMgr("StoneSculptureMgr")
    self.isGetGift = false            --是否决定给他分配晶石
    self.roleId = -1
    
end --func end
--next--
function GuildStoneDetailPrefab:OnDestroy()
    
    
end --func end
--next--
function GuildStoneDetailPrefab:OnDeActive()
    
    
end --func end
--next--
function GuildStoneDetailPrefab:OnSetData(data)

    self.roleId = data.role_id
    self.Parameter.Name.LabText = data.name
    self.Parameter.Level.LabText = tostring(data.base_level)
    self.Parameter.Rank.LabText = DataMgr:GetData("GuildData").GetPositionName(data.permission_info.permission)
    self.Parameter.HelpCount.LabText = tostring(data.helped_times)
    self.Parameter.Love.LabText = tostring(data.friend_degree)

    self.Parameter.GiftGet:SetActiveEx(data.is_assigned_souvenir_crystal)
    self.Parameter.GiftNoGet:SetActiveEx(not data.is_assigned_souvenir_crystal)

    if self.mgr.chooseId[data.id] == nil then
        self.isGetGift = false
        self.Parameter.Choose:SetActiveEx(false)
    else
        self.isGetGift = self.mgr.chooseId[data.id].isChoose
        self.Parameter.Choose:SetActiveEx(self.mgr.chooseId[data.id].isChoose)
    end
    self.Parameter.GiftNoGet:AddClick(function()
        if self.isGetGift then
            self.mgr.StoneGiftNowChoose = self.mgr.StoneGiftNowChoose - 1
            self.Parameter.Choose:SetActiveEx(false)
            self.isGetGift = false
            self.MethodCallback(data.id, data.role_id, false)
        else
            if data.is_assigned_full then
                MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("CARVE_LIMIT"))
            else
                if self.mgr.StoneGiftNowChoose >= self.mgr.StoneHelpData.giftNum then            --你的纪念晶石已经不够了
                    MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("GIFTSTONE_NO_ENOUGH"))
                    return
                end
                self.mgr.StoneGiftNowChoose = self.mgr.StoneGiftNowChoose + 1
                self.Parameter.Choose:SetActiveEx(true)
                self.isGetGift = true
                self.MethodCallback(data.id, data.role_id, true)
            end
        end
    end)

end --func end
--next--
function GuildStoneDetailPrefab:BindEvents()
    
    
end --func end
--next--
--lua functions end

--lua custom scripts

--lua custom scripts end
return GuildStoneDetailPrefab