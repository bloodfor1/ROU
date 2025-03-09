--this file is gen by script
--you can edit this file in custom part

--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/EquipElevatePanel"

--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua class define
local super = UI.UIBaseCtrl
---@class EquipElevateCtrl:UIBaseCtrl
EquipElevateCtrl = class("EquipElevateCtrl", super)
--lua class define end

--lua functions
function EquipElevateCtrl:ctor()

    super.ctor(self, CtrlNames.EquipElevate, UILayer.Function, UITweenType.None, ActiveType.Exclusive)

end --func end
--next--
function EquipElevateCtrl:Init()

    self.panel = UI.EquipElevatePanel.Bind(self)
    super.Init(self)
    self.panel.ButtonClose:AddClick(function()
        UIMgr:DeActiveUI(UI.CtrlNames.EquipElevate)
    end)

end --func end
function EquipElevateCtrl:SetupHandlers()
    local l_openSysMgr = MgrMgr:GetMgr("OpenSystemMgr")
    local l_handlerTb = {}
    if l_openSysMgr.IsSystemOpen(l_openSysMgr.eSystemId.Compound) then
        table.insert(l_handlerTb, { HandlerNames.Compound, Lang("Compound"), "CommonIcon", "UI_CommonIcon_Tab_hecheng_01.png", "UI_CommonIcon_Tab_hecheng_02.png" })
    end

    --判断商人相关界面是否显示
    local l_materialShow = false
    local l_displacerShow = false
    local l_makeMaterialsSkillIdsStr = TableUtil.GetGlobalTable().GetRowByName("MakeMaterialsSkillId").Value
    local l_makeMaterialsSkillIds = string.ro_split(l_makeMaterialsSkillIdsStr, "|")
    local l_makeDisplacerSkillIdsStr = TableUtil.GetGlobalTable().GetRowByName("MakeEnchantSkillId").Value
    local l_makeDisplacerSkillIds = string.ro_split(l_makeDisplacerSkillIdsStr, "|")
    local l_proIdList = MPlayerInfo.ProfessionIdList
    for i = 0, l_proIdList.Count - 1 do
        local l_proInfo = TableUtil.GetProfessionTable().GetRowById(l_proIdList[i])
        for j = 0, l_proInfo.SkillIds.Count - 1 do
            --判断材料界面是否显示
            if not l_materialShow and l_openSysMgr.IsSystemOpen(l_openSysMgr.eSystemId.MaterialMake) then
                for k = 1, #l_makeMaterialsSkillIds do
                    if l_proInfo.SkillIds[j][0] == tonumber(l_makeMaterialsSkillIds[k]) then
                        table.insert(l_handlerTb, { HandlerNames.MaterialMake, Lang("TRADE_DES_ITEM_3"), "CommonIcon", "UI_CommonIcon_GuildBanquet_Blessing_01.png", "UI_CommonIcon_GuildBanquet_Blessing_02.png" })--材料
                        l_materialShow = true
                        break
                    end
                end
            end

            --判断置换器界面是否显示
            if not l_displacerShow and l_openSysMgr.IsSystemOpen(l_openSysMgr.eSystemId.Displace) then
                for k = 1, #l_makeDisplacerSkillIds do
                    if l_proInfo.SkillIds[j][0] == tonumber(l_makeDisplacerSkillIds[k]) then
                        table.insert(l_handlerTb, { HandlerNames.DisplacerMake, Lang("DISPLACER"), "CommonIcon", "UI_CommonIcon_Tab_zhihuanqizhizuo_01.png", "UI_CommonIcon_Tab_zhihuanqizhizuo_02.png" })--置换器
                        l_displacerShow = true
                        break
                    end
                end
            end

            if l_materialShow and l_displacerShow then
                break
            end
        end

        if l_materialShow and l_displacerShow then
            break
        end
    end

    self:InitHandler(l_handlerTb, self.panel.ToggleTpl)
end

--next--
function EquipElevateCtrl:Uninit()

    super.Uninit(self)
    self.panel = nil
end --func end
--next--
function EquipElevateCtrl:OnActive()
    -- 腾出位置给Currency条
    self.panel.Root.RectTransform.anchoredPosition = Vector2.New(0,-23)
    MgrMgr:GetMgr("CurrencyMgr").SetCurrencyDisplay(nil, 0)
    UIMgr:ActiveUI(UI.CtrlNames.Currency, nil,{InsertPanelName = UI.CtrlNames.EquipElevate})
end --func end
--next--
function EquipElevateCtrl:OnDeActive()
    -- do nothing
end --func end
--next--
function EquipElevateCtrl:Update()
    -- do nothing
end --func end

--next--
function EquipElevateCtrl:BindEvents()
    -- do nothing
end --func end

function EquipElevateCtrl:OnHandlerSwitch(handlerName, lastHandlerName)
    -- self.curHandler:OnHandlerSwitch()
    local gameEventMgr = MgrMgr:GetMgr("GameEventMgr")
    gameEventMgr.RaiseEvent(gameEventMgr.OnCompoundHandlerSwitch)
end

--next--
--lua functions end

--lua custom scripts

--lua custom scripts end
