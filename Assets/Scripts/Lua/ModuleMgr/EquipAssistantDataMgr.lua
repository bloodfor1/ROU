-- 这是一个数据驱动，根据数据的配置来修改开启了装备助手之后一些表现上的数据
module("ModuleMgr.EquipAssistantDataMgr", package.seeall)

-- 装备助手状态
local l_pageState = GameEnum.EEquipAssistType.None

-- 页面标题配置
PageTitleConfig = {
    { mainPageType = GameEnum.EEquipAssistType.RefineAssist, title = Lang("EquipAssist_Title_Refine") },
    { mainPageType = GameEnum.EEquipAssistType.EnchantAssist, title = Lang("EquipAssist_Title_Enchant") },
}

-- 页面显示的配置，主要是决定了什么状态下应该有哪几个页面，哪个页面是默认页面
---@type EquipAssistBgParam[]
PageConfig = {
    -- 精炼助手
    -- 精炼转移
    { mainPageType = GameEnum.EEquipAssistType.RefineAssist,
      isDefault = true,
      HandlerName = UI.HandlerNames.RefineTransfer,
      pageConfig = {
          UI.HandlerNames.RefineTransfer,
          Lang("EquipAssistantBG_RefineTransferHandlerName"),
          "CommonIcon",
          "UI_CommonIcon_Tab_jinglianzhuanyi_01.png",
          "UI_CommonIcon_Tab_jinglianzhuanyi_02.png" }
    },
    -- 精炼解封
    { mainPageType = GameEnum.EEquipAssistType.RefineAssist,
      isDefault = false,
      HandlerName = UI.HandlerNames.RefineUnseal,
      pageConfig = {
          UI.HandlerNames.RefineUnseal,
          Lang("EquipAssistantBG_RefineUnsealHandlerName"),
          "CommonIcon",
          "UI_CommonIcon_Tab_jinglianjiefeng_01.png",
          "UI_CommonIcon_Tab_jinglianjiefeng_02.png" }
    },

    -- 附魔助手
    -- 附魔提炼
    { mainPageType = GameEnum.EEquipAssistType.EnchantAssist,
      isDefault = true,
      HandlerName = UI.HandlerNames.EnchantmentExtract,
      pageConfig = {
          UI.HandlerNames.EnchantmentExtract,
          Lang("EquipAssistantBG_EnchantmentExtractHandlerName"),
          "CommonIcon",
          "UI_CommonIcon_Tab_fumotilian_01.png",
          "UI_CommonIcon_Tab_fumotilian_02.png" }
    },
    -- 附魔继承
    { mainPageType = GameEnum.EEquipAssistType.EnchantAssist,
      isDefault = false,
      HandlerName = UI.HandlerNames.EnchantInherit,
      pageConfig = {
          UI.HandlerNames.EnchantInherit,
          Lang("EquipAssistantBG_EnchantInheritHandlerName"),
          "CommonIcon",
          "UI_CommonIcon_Tab_jinglianjiefeng_01.png",
          "UI_CommonIcon_Tab_jinglianjiefeng_02.png" }
    },

    -- 附魔提炼
    { mainPageType = GameEnum.EEquipAssistType.EnchantAssistOnInherit,
      isDefault = false,
      HandlerName = UI.HandlerNames.EnchantmentExtract,
      pageConfig = {
          UI.HandlerNames.EnchantmentExtract,
          Lang("EquipAssistantBG_EnchantmentExtractHandlerName"),
          "CommonIcon",
          "UI_CommonIcon_Tab_fumotilian_01.png",
          "UI_CommonIcon_Tab_fumotilian_02.png" }
    },
    -- 附魔继承
    { mainPageType = GameEnum.EEquipAssistType.EnchantAssistOnInherit,
      isDefault = true,
      HandlerName = UI.HandlerNames.EnchantInherit,
      pageConfig = {
          UI.HandlerNames.EnchantInherit,
          Lang("EquipAssistantBG_EnchantInheritHandlerName"),
          "CommonIcon",
          "UI_CommonIcon_Tab_jinglianjiefeng_01.png",
          "UI_CommonIcon_Tab_jinglianjiefeng_02.png" }
    },

    -- 附魔提炼
    { mainPageType = GameEnum.EEquipAssistType.EnchantAssistOnPerfect,
      isDefault = true,
      HandlerName = UI.HandlerNames.EnchantmentExtract,
      pageConfig = {
          UI.HandlerNames.EnchantmentExtract,
          Lang("EquipAssistantBG_EnchantmentExtractHandlerName"),
          "CommonIcon",
          "UI_CommonIcon_Tab_fumotilian_01.png",
          "UI_CommonIcon_Tab_fumotilian_02.png" }
    },
    -- 附魔继承
    { mainPageType = GameEnum.EEquipAssistType.EnchantAssistOnPerfect,
      isDefault = false,
      HandlerName = UI.HandlerNames.EnchantInherit,
      pageConfig = {
          UI.HandlerNames.EnchantInherit,
          Lang("EquipAssistantBG_EnchantInheritHandlerName"),
          "CommonIcon",
          "UI_CommonIcon_Tab_jinglianjiefeng_01.png",
          "UI_CommonIcon_Tab_jinglianjiefeng_02.png" }
    },
}

function GetPageState()
    return l_pageState
end

function SetPageState(state)
    l_pageState = state
end

return ModuleMgr.EquipAssistantDataMgr