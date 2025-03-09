module("ModuleMgr.ShowEquipPanleMgr", package.seeall)

eShowEquipPanelType = {
    MakeHole = 1, --打洞
    Enchant = 2, --附魔
    EnchantAdvanced = 3, --高级附魔
    EquipCardForge = 4, --插卡
    EnchantmentExtract = 5, --附魔提炼
    RefineTransfer = 6, --精炼转移
    RefineUnseal = 7, --精炼解封
}

CurrentShowEquipPanelType = eShowEquipPanelType.MakeHole

local l_equipAssistDataMgr = MgrMgr:GetMgr("EquipAssistantDataMgr")

function OpenMakeHolePanle()
    CurrentShowEquipPanelType = eShowEquipPanelType.MakeHole
    UIMgr:ActiveUI(UI.CtrlNames.EquipBG)
end

function OpenCardForgePanle(cardId)
    MgrMgr:GetMgr("EquipCardForgeHandlerMgr").OpenCardForgePanle(cardId)
end

function OpenEnchantPanle()
    CurrentShowEquipPanelType = eShowEquipPanelType.Enchant
    UIMgr:ActiveUI(UI.CtrlNames.EquipBG)
end

function OpenEnchantAdvancedPanle()
    CurrentShowEquipPanelType = eShowEquipPanelType.EnchantAdvanced
    UIMgr:ActiveUI(UI.CtrlNames.EquipBG)
end

-- 根据类型来判断开启哪个页面
function OpenEquipAssistPanelByType(pageType)
    l_equipAssistDataMgr.SetPageState(pageType)
    UIMgr:ActiveUI(UI.CtrlNames.EquipAssistantBG)
end

-- todo obsolete
function OpenEnchantmentExtractPanle()
    CurrentShowEquipPanelType = eShowEquipPanelType.EnchantmentExtract
    UIMgr:ActiveUI(UI.CtrlNames.EquipAssistantBG)
end

-- todo obsolete
function OpenRefineTransferPanle()
    CurrentShowEquipPanelType = eShowEquipPanelType.RefineTransfer
    UIMgr:ActiveUI(UI.CtrlNames.EquipAssistantBG)
end

-- todo obsolete
function OpenRefineUnsealPanle()
    CurrentShowEquipPanelType = eShowEquipPanelType.RefineUnseal
    UIMgr:ActiveUI(UI.CtrlNames.EquipAssistantBG)
end

return ModuleMgr.ShowEquipPanleMgr