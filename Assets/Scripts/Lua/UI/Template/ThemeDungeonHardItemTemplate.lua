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
local l_difficutyImageSuffix = {
    "", "_Cheng", "_Lan", "_Lv", "_Zi"
}
-- 难度1-5罗马数字配置  1代表I 2代表V
local l_romanNumberConfig = {
    {1},        --I
    {1, 1},     --II
    {1, 1, 1},  --III
    {1, 2},     --IV
    {2},        --V
}
--lua fields end

--lua class define
---@class ThemeDungeonHardItemTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field Text MoonClient.MLuaUICom
---@field Selected MoonClient.MLuaUICom
---@field Num2 MoonClient.MLuaUICom
---@field Num1 MoonClient.MLuaUICom
---@field Num0 MoonClient.MLuaUICom
---@field LockMask MoonClient.MLuaUICom
---@field LevelSuffix MoonClient.MLuaUICom
---@field ImageGrade MoonClient.MLuaUICom
---@field ImageDifficulty MoonClient.MLuaUICom
---@field HardItem MoonClient.MLuaUICom
---@field DifficutyText MoonClient.MLuaUICom
---@field Difficulty MoonClient.MLuaUICom

---@class ThemeDungeonHardItemTemplate : BaseUITemplate
---@field Parameter ThemeDungeonHardItemTemplateParameter

ThemeDungeonHardItemTemplate = class("ThemeDungeonHardItemTemplate", super)
--lua class define end

--lua functions
function ThemeDungeonHardItemTemplate:Init()
	
	    super.Init(self)
	
end --func end
--next--
function ThemeDungeonHardItemTemplate:OnDestroy()
	
	    self.dungeonId = nil
	    self.index = nil
	
end --func end
--next--
function ThemeDungeonHardItemTemplate:OnDeActive()
	
	
end --func end
--next--
function ThemeDungeonHardItemTemplate:OnSetData(data)
	
	    self:CustomSetData(data)
	
end --func end
--next--
function ThemeDungeonHardItemTemplate:BindEvents()
	
	
end --func end
--next--
--lua functions end

--lua custom scripts
function ThemeDungeonHardItemTemplate:CustomSetData(data)
    
    self.dungeonId = data.id
    self.index = data.index

    local l_row = TableUtil.GetGreatSecretTable().GetRowByGreatSecretID(self.dungeonId)

    local l_difficulty = l_row.Difficulty
    local l_serverLevel = MPlayerInfo.ServerLevel or 0

    local string_format = StringEx.Format

    self:SetRomanNumber(l_difficulty)

    self.Parameter.ImageDifficulty:SetSpriteAsync("ThemeArround", string_format("UI_ThemeArround_Img_Ditu0{0}.png", l_difficulty))

    self.Parameter.ImageGrade:SetSpriteAsync("ThemeArround", string_format("UI_ThemeArround_Img_Lv{0}.png", l_difficutyImageSuffix[l_difficulty]))
    
    if (not data.normalLock) and l_serverLevel >= l_row.ServerOpeningLevel then
        local l_themeDungeonRow = TableUtil.GetThemeDungeonTable().GetRowByThemeDungeonID(data.themeId)
        local l_difficultyLevel = self:GetNoticeText(l_themeDungeonRow.ChapterLevel)
        if l_difficultyLevel == 1 then
            self.Parameter.Difficulty.Img.color = Color.New(0x66 / 255, 0xbd / 255, 0x96 / 255, 1)
            self.Parameter.DifficutyText.LabText = Lang("EASY")
            self.Parameter.DifficutyText.LabColor = Color.New(0xee / 255, 0xfc / 255, 0xef / 255, 1) 
        elseif l_difficultyLevel == 2 then
            self.Parameter.Difficulty.Img.color = Color.New(0xf5 / 255, 0xb4 / 255, 0x18 / 255, 1)
            self.Parameter.DifficutyText.LabText = Lang("WARN")
            self.Parameter.DifficutyText.LabColor = Color.New(0xfc / 255, 0xf6 / 255, 0xee / 255, 1) 
        elseif l_difficultyLevel == 3 then
            self.Parameter.Difficulty.Img.color = Color.New(0xff / 255, 0x73 / 255, 0x73 / 255, 1)
            self.Parameter.DifficutyText.LabText = Lang("HARD")
            self.Parameter.DifficutyText.LabColor = Color.New(0xfc / 255, 0xef / 255, 0xee / 255, 1) 
        end
        self.Parameter.Text.LabText = Lang("RECOMMAND_LEVEL_FORMAT", l_row.RecommendLevel)
        self.Parameter.Difficulty.gameObject:SetActiveEx(true)
        self.Parameter.LockMask.gameObject:SetActiveEx(false)
    else
        self.Parameter.Text.LabText = Lang("THEME_DUNGEON_LOCKOF_SERVER", l_row.ServerOpeningLevel)
        self.Parameter.Difficulty.gameObject:SetActiveEx(false)
        self.Parameter.LockMask.gameObject:SetActiveEx(true)
    end

    self.Parameter.HardItem:AddClick(function()
        if self.MethodCallback then
            self.MethodCallback(self.dungeonId, self.index)
        end
    end)
end

function ThemeDungeonHardItemTemplate:UpdateSelectState(flag)
    
    self.Parameter.Selected.gameObject:SetActiveEx(flag)
end

function ThemeDungeonHardItemTemplate:SetRomanNumber(difficulty)
    
    if difficulty > 5 then
        logError("SetRomanNumber fail, 没有对应的资源文件", difficulty)
        return
    end

    local string_format = StringEx.Format

    local l_config = l_romanNumberConfig[difficulty]
    for i, v in ipairs(l_config) do
        local l_com = self.Parameter[string_format("Num{0}", i - 1)]
        l_com:SetSpriteAsync("ThemeArround", string_format("UI_ThemeArround_Img_Shuzi{0}{1}.png", v, l_difficutyImageSuffix[difficulty]), nil, true)
        l_com.gameObject:SetActiveEx(true)
    end

    for i = #l_config + 1, 3 do
        local l_com = self.Parameter[string_format("Num{0}", i - 1)]
        l_com.gameObject:SetActiveEx(false)
    end
end


function ThemeDungeonHardItemTemplate:GetNoticeText(themeDungeonLevel)
    
    local l_targetRow

    local l_playerLevel = MPlayerInfo.Lv
    local l_difficulityTbl = TableUtil.GetGreatSecretDifficultyMap().GetTable()
    for i, v in ipairs(l_difficulityTbl) do
        if l_playerLevel <= v.Level then
            l_targetRow = v
            break
        end
    end

    -- 找不到就用最后一个
    if not l_targetRow then
        l_targetRow = l_difficulityTbl[#l_difficulityTbl]
    end

    -- 还是找不到就返回简单
    if not l_targetRow then
        return 1
    end

    local l_offsetLevel = l_playerLevel - themeDungeonLevel
    if l_offsetLevel >= l_targetRow.Easy then
        return 1
    end
    if l_offsetLevel >= l_targetRow.Warn then
        return 2
    end
    return 3
end
--lua custom scripts end
return ThemeDungeonHardItemTemplate