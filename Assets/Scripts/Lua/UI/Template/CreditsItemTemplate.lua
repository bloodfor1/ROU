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
---@class CreditsItemTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field UseButton MoonClient.MLuaUICom
---@field ShowDetailsPanelButton MoonClient.MLuaUICom
---@field Name MoonClient.MLuaUICom
---@field Icon MoonClient.MLuaUICom
---@field Count MoonClient.MLuaUICom

---@class CreditsItemTemplate : BaseUITemplate
---@field Parameter CreditsItemTemplateParameter

CreditsItemTemplate = class("CreditsItemTemplate", super)
--lua class define end

--lua functions
function CreditsItemTemplate:Init()

    super.Init(self)
    self.data = nil
    self.Parameter.UseButton:AddClick(function()
        if self.data == nil then
            return
        end
        if self.data == MgrMgr:GetMgr("PropMgr").l_virProp.GuildContribution then
            MgrMgr:GetMgr("ShopMgr").GoToGuildShop()
        else
            local l_functionId = eUseFunctionId[self.data]
            if l_functionId then
                if MgrMgr:GetMgr("OpenSystemMgr").IsSystemOpen(l_functionId) then
                    --寻路成功才关闭对应界面
                    local l_result = Common.CommonUIFunc.InvokeFunctionByFuncId(l_functionId)
                    if l_result then
                        game:ShowMainPanel()
                    end
                else
                    MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("THEME_DUNGEONS_NOT_OPEN"))
                end
            end
        end
        --
    end)
    self.Parameter.ShowDetailsPanelButton:AddClick(function()
        if self.data == nil then
            return
        end
        self.MethodCallback(self.data)
    end)

end --func end
--next--
function CreditsItemTemplate:OnDeActive()
    -- do nothing
end --func end
--next--
function CreditsItemTemplate:OnSetData(data)
    self.data = data
    local itemTableInfo = TableUtil.GetItemTable().GetRowByItemID(data)
    self.Parameter.Name.LabText = itemTableInfo.ItemName
    self.Parameter.Count.LabText = tostring(Data.BagModel:GetCoinOrPropNumById(self.data))
    self.Parameter.Icon:SetSprite(itemTableInfo.ItemAtlas, itemTableInfo.ItemIcon, true)
end --func end
--next--
function CreditsItemTemplate:OnDestroy()
    -- do nothing
end --func end
--next--
function CreditsItemTemplate:BindEvents()
    -- do nothing
end --func end
--next--
--lua functions end

--lua custom scripts
eUseFunctionId = {
    [MgrMgr:GetMgr("PropMgr").l_virProp.ArenaCoin] = MgrMgr:GetMgr("OpenSystemMgr").eSystemId.ArenaShop,
    [MgrMgr:GetMgr("PropMgr").l_virProp.AssistCoin] = MgrMgr:GetMgr("OpenSystemMgr").eSystemId.AssistShop,
    [MgrMgr:GetMgr("PropMgr").l_virProp.MonsterCoin] = MgrMgr:GetMgr("OpenSystemMgr").eSystemId.MonsterShop,
}
--lua custom scripts end
return CreditsItemTemplate