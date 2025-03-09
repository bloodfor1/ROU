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
---@class RefitTrolleyItemTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field Select MoonClient.MLuaUICom
---@field Prefab MoonClient.MLuaUICom
---@field Lock MoonClient.MLuaUICom
---@field IsUsing MoonClient.MLuaUICom
---@field Icon MoonClient.MLuaUICom
---@field BtnUseText MoonClient.MLuaUICom
---@field BtnUse MoonClient.MLuaUICom
---@field BtnItem MoonClient.MLuaUICom

---@class RefitTrolleyItemTemplate : BaseUITemplate
---@field Parameter RefitTrolleyItemTemplateParameter

RefitTrolleyItemTemplate = class("RefitTrolleyItemTemplate", super)
--lua class define end

--lua functions
function RefitTrolleyItemTemplate:Init()
    
    super.Init(self)
    
end --func end
--next--
function RefitTrolleyItemTemplate:OnDeActive()
    
    
end --func end
--next--
function RefitTrolleyItemTemplate:OnSetData(data)
    
    self.data = data

    local l_itemData = TableUtil.GetItemTable().GetRowByItemID(data.configData.CartID)
    if l_itemData then
        self.Parameter.Icon:SetSprite(l_itemData.ItemAtlas, l_itemData.ItemIcon, true)
    end

    self.Parameter.IsUsing.UObj:SetActiveEx(data.isUsing)
    self.Parameter.Lock.UObj:SetActiveEx(not data.isUnlocked)

    self:SetSelect(self.isSelected or false)

    self.Parameter.BtnUseText.LabText = data.isUnlocked and Lang("Use") or Lang("GO_TO_UNLOCK")
    self.Parameter.BtnUse:AddClick(function()
        if data.isUnlocked then
            --已解锁 使用
            MgrMgr:GetMgr("RefitTrolleyMgr").ReqUseTrolley(data.configData.CartID, data.configData.ProfessionID)
        else
            --技能等级解锁在大嘴鸟商店不判断 20200429  cmd
            --未解锁 前往解锁
            -- if not data.isCondition01Check then
            --     --条件一不满足 打开技能面板
            --     UIMgr:DeActiveUI(UI.CtrlNames.Refitshop)
            --     UIMgr:ActiveUI(UI.CtrlNames.SkillLearning)
            -- else
            --     --条件二不满足 打开经验获取途径
            --     MgrMgr:GetMgr("ItemTipsMgr").ShowTipsDisplayWithId(201, nil, nil, nil, true)
            -- end
            MgrMgr:GetMgr("ItemTipsMgr").ShowTipsDisplayWithId(201, nil, nil, nil, true)
        end
    end)
    

    self.Parameter.BtnItem:AddClick(function()
        self:MethodCallback(self)
    end)
    
end --func end
--next--
function RefitTrolleyItemTemplate:BindEvents()
    
    
end --func end
--next--
function RefitTrolleyItemTemplate:OnDestroy()
    
    
end --func end
--next--
--lua functions end

--lua custom scripts
--设置被选中框是否显示
function RefitTrolleyItemTemplate:SetSelect(isSelected)
    self.isSelected = isSelected
    self.Parameter.Select.UObj:SetActiveEx(self.isSelected)
    self.Parameter.BtnUse.UObj:SetActiveEx((not self.data.isUsing) and self.isSelected)
end
--lua custom scripts end
return RefitTrolleyItemTemplate