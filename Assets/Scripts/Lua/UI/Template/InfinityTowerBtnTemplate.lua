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
---@class InfinityTowerBtnTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field TmpClear MoonClient.MLuaUICom
---@field Text MoonClient.MLuaUICom
---@field StageBtn MoonClient.MLuaUICom
---@field MVP MoonClient.MLuaUICom
---@field Image1 MoonClient.MLuaUICom
---@field Image MoonClient.MLuaUICom

---@class InfinityTowerBtnTemplate : BaseUITemplate
---@field Parameter InfinityTowerBtnTemplateParameter

InfinityTowerBtnTemplate = class("InfinityTowerBtnTemplate", super)
--lua class define end

--lua functions
function InfinityTowerBtnTemplate:Init()
	
	    super.Init(self)
	    self.isLeft = nil
	    self.levelId = nil
	
end --func end
--next--
function InfinityTowerBtnTemplate:OnDeActive()
	
	
end --func end
--next--
function InfinityTowerBtnTemplate:OnSetData(data)
	
	    self:CustomSetData(data)
	
end --func end
--next--
function InfinityTowerBtnTemplate:OnDestroy()
	
	    self.isLeft = nil
	    self.levelId = nil
	
end --func end
--next--
function InfinityTowerBtnTemplate:BindEvents()
	
	
end --func end
--next--
--lua functions end

--lua custom scripts
function InfinityTowerBtnTemplate:CustomSetData(data)

    local l_left = data.left
    local l_id = data.ID
    local l_mvp = data.mvp
    local l_index = data.index

    self.levelId = l_id
    self.isLeft = l_left
    -- 翻转底图
    MLuaCommonHelper.SetLocalScaleX(self.Parameter.Image1.gameObject, l_left and -1 or 1)
    -- 根据index设置相对位置
    local l_pos_y = -44 + (l_index - 1) / MgrMgr:GetMgr("InfiniteTowerDungeonMgr").g_towerBlockSplit * 70
    -- logError("l_pos_y", l_pos_y, v.index, v.ID)
    MLuaCommonHelper.SetRectTransformPos(self.Parameter.LuaUIGroup.gameObject, 0, l_pos_y)

    -- 设置锚点
    MLuaCommonHelper.SetRectTransformPivot(self.Parameter.StageBtn.gameObject, l_left and 1 or 0, 0.5)
    if l_left then
        self.Parameter.StageBtn.RectTransform.anchorMin = Vector2.New(0, 0.5)
        self.Parameter.StageBtn.RectTransform.anchorMax = Vector2.New(0, 0.5)
    else
        self.Parameter.StageBtn.RectTransform.anchorMin = Vector2.New(1, 0.5)
        self.Parameter.StageBtn.RectTransform.anchorMax = Vector2.New(1, 0.5)
    end

    -- 设置文本
    self.Parameter.Text.LabText = StringEx.Format(Common.Utils.Lang("LEVEL_NUMBER"), l_id)
    -- 设置记录
    local l_cleared = MgrMgr:GetMgr("InfiniteTowerDungeonMgr").IsCleared(l_id)
    self.Parameter.TmpClear.gameObject:SetActiveEx(l_cleared)
    -- 设置选中态
    self:UpdateSelectState(data.selectId)

    -- 设置mvp标签
    if l_mvp then
        self.Parameter.Image.gameObject:SetLocalPosX(self.Parameter.Image.transform.localPosition.x - 14)
        self.Parameter.Image1.gameObject:SetLocalPosX(self.Parameter.Image1.transform.localPosition.x - 14)
        self.Parameter.MVP:SetSprite("CommonIcon", "UI_CommonIcon_TowerLevelicon_02.png")
    else
        self.Parameter.MVP:SetSprite("CommonIcon", "UI_CommonIcon_TowerLevelicon_01.png")
    end

    self.Parameter.StageBtn:AddClick(function()
        self:MethodCallback(l_id)
    end)
end

function InfinityTowerBtnTemplate:UpdateSelectState(id)
    local l_flag = self.levelId == id
    self.Parameter.Image.gameObject:SetActiveEx(l_flag)

    if l_flag then
        MLuaCommonHelper.SetLocalScaleX(self.Parameter.Image.gameObject, self.isLeft and -1 or 1)
    end
end
--lua custom scripts end
return InfinityTowerBtnTemplate