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
---@class IllustrationMonster_ExploratoryRecordTemParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field UnLock_Previous MoonClient.MLuaUICom
---@field UnLock_Next MoonClient.MLuaUICom
---@field Title MoonClient.MLuaUICom
---@field Text_State_Right MoonClient.MLuaUICom
---@field Text_State_Point MoonClient.MLuaUICom
---@field Text_State MoonClient.MLuaUICom
---@field Text_RightTitle MoonClient.MLuaUICom
---@field Text_Reward_Single MoonClient.MLuaUICom
---@field Text_Reward_Headwear MoonClient.MLuaUICom
---@field Text_Lv_Previous MoonClient.MLuaUICom
---@field Text_Lv_Next MoonClient.MLuaUICom
---@field Text_Detailed MoonClient.MLuaUICom
---@field Text_Btn_Receive MoonClient.MLuaUICom
---@field Slide_Right MoonClient.MLuaUICom
---@field Right_LV MoonClient.MLuaUICom
---@field Right_Level_Text MoonClient.MLuaUICom
---@field RewardLoopScroll MoonClient.MLuaUICom
---@field Reward_Single MoonClient.MLuaUICom
---@field Reward_Headwear MoonClient.MLuaUICom
---@field ReceiveRedSign MoonClient.MLuaUICom
---@field LoopScroll MoonClient.MLuaUICom
---@field ItemPos MoonClient.MLuaUICom
---@field Btn_Wenhao MoonClient.MLuaUICom
---@field Btn_Receive MoonClient.MLuaUICom
---@field Btn_Previous MoonClient.MLuaUICom
---@field Btn_Next MoonClient.MLuaUICom
---@field Btn_Map MoonClient.MLuaUICom
---@field Btn_Check MoonClient.MLuaUICom
---@field MonsterRowTem MoonClient.MLuaUIGroup
---@field MonsterBookSingleRewardTem MoonClient.MLuaUIGroup

---@class IllustrationMonster_ExploratoryRecordTem : BaseUITemplate
---@field Parameter IllustrationMonster_ExploratoryRecordTemParameter

IllustrationMonster_ExploratoryRecordTem = class("IllustrationMonster_ExploratoryRecordTem", super)
--lua class define end

--lua functions
function IllustrationMonster_ExploratoryRecordTem:Init()
    super.Init(self)
    self.mgr = MgrMgr:GetMgr("IllustrationMonsterMgr")
    self.data = DataMgr:GetData("IllustrationMonsterData")
    self.data.InitMonsterRewardBook()
    self.TogTem = nil
    self.RewardTem = nil
    self.MonsterRowTem = nil
    self.ItemTem = nil
    self.data.SetRewardBookSelectType(0)
    self.pageData = nil
    self.selectLvl = 0
    self.selectId = 0
    self.selectRowIndex = 1
    self.selectShowIndex = 1
    self.selectItem = 0
    self.TipsStr = nil
    --- 需求更改，不再需要左右切换等级进度
    self.Parameter.Btn_Previous:SetActiveEx(false)
    self.Parameter.Btn_Next:SetActiveEx(false)
    self.Parameter.Btn_Receive:AddClick(function()
        if not self.data.CheckMonsterRewardCanPick(self.selectId, self.selectLvl)
                and self.data.GetMonsterRewardLevelById(self.selectId) >= self.selectLvl then
            self.mgr.GetMonsterAward(MonsterAwardType.MONSTER_AWARD_SINGLE, self.selectLvl, self.selectId)
        end
    end)
    self.Parameter.Btn_Check:AddClick(function()
        local monsterData = TableUtil.GetEntityTable().GetRowById(self.selectId)
        self.MethodCallback(monsterData)
    end)
    self.Parameter.Btn_Map:AddClick(function()
        Common.CommonUIFunc.ShowMonsterTipsById(self.selectId)
    end)
    self.Parameter.Btn_Wenhao:AddClickWithLuaSelf(self.ShowTips, self)

end --func end
--next--
function IllustrationMonster_ExploratoryRecordTem:BindEvents()
    self:BindEvent(self.mgr.EventDispatcher, self.data.ILLUSTRATION_SELECT_MONSTER, self.OnSelectMonster)
    self:BindEvent(self.mgr.EventDispatcher, self.data.ILLUSTRATION_MONSTER_KILL, self.RefreshRightPanel)
    self:BindEvent(self.mgr.EventDispatcher, self.data.ILLUSTRATION_MONSTER_REWARD, self.RefreshRightPanel)
    --解锁魔物
    self:BindEvent(self.mgr.EventDispatcher, self.data.ILLUSTRATION_UNLOCK_MONSTER, self.UnlockMonster)
    self:BindEvent(self.mgr.EventDispatcher, self.data.REWARD_BOOK_PAGE_REFRESH, self.UpdatePage)
end --func end
--next--
function IllustrationMonster_ExploratoryRecordTem:OnDestroy()

    self.TogTem = nil
    self.RewardTem = nil
    self.MonsterRowTem = nil
    self.ItemTem = nil
    self.data.SetRewardBookSelectType(0)
    self.pageData = nil
    self.selectLvl = 0
    self.selectId = 0
    self.selectRowIndex = 1
    self.selectShowIndex = 1
    self.TipsStr = nil

end --func end
--next--
function IllustrationMonster_ExploratoryRecordTem:OnDeActive()


end --func end
--next--
function IllustrationMonster_ExploratoryRecordTem:OnSetData()
    self.data.SetRewardBookSelectType(1)
    self.pageData = self.data.GetMonsterRewardBookDataByType(self.data.GetRewardBookSelectType())
    if self.RewardTem == nil then
        self.RewardTem = self:NewTemplatePool({
            TemplateClassName = "MonsterBookSingleRewardTem",
            TemplatePrefab = self.Parameter.MonsterBookSingleRewardTem.gameObject,
            ScrollRect = self.Parameter.RewardLoopScroll.LoopScroll,
            SetCountPerFrame = 1,
            CreateObjPerFrame = 1,
        })
    end

    if self.MonsterRowTem == nil then
        self.MonsterRowTem = self:NewTemplatePool({
            TemplateClassName = "MonsterRowTem",
            TemplatePrefab = self.Parameter.MonsterRowTem.gameObject,
            ScrollRect = self.Parameter.LoopScroll.LoopScroll,
            SetCountPerFrame = 1,
            CreateObjPerFrame = 1,
        })
    end

    self.MonsterRowTem:ShowTemplates({ Datas = self:GetNowPage() })
    self:OnSelectMonster(self.pageData[1][1])
    local monsterList = self.MonsterRowTem:GetItem(1)
    if monsterList then
        local monsterCell = monsterList:GetTemplatePool():GetItem(1)
        if monsterCell then
            monsterCell:SetMonsterSelectState(true)
        end
    end
end --func end
--next--
--lua functions end

--lua custom scripts
function IllustrationMonster_ExploratoryRecordTem:GetNowPage()
    return self.pageData
end

function IllustrationMonster_ExploratoryRecordTem:UpdatePage()
    self.pageData = self.data.GetMonsterRewardBookDataByType(self.data.GetRewardBookSelectType())
    self.MonsterRowTem:ShowTemplates({ Datas = self:GetNowPage() })
    self:OnSelectMonster(self.pageData[1][1])
end
function IllustrationMonster_ExploratoryRecordTem:OnSelectMonster(monsterData)
    --选中框改变
    self.selectId = monsterData.Id
    self:RefreshRightPanel()
    --清除原来的选择
    local monsterList = self.MonsterRowTem:GetItem(self.selectRowIndex)
    if monsterList then
        local monsterCell = monsterList:GetTemplatePool():GetItem(self.selectShowIndex)
        if monsterCell then
            monsterCell:SetMonsterSelectState(false)
        end
    end
    self.selectRowIndex = monsterData.rowIndex or self.selectRowIndex
    self.selectShowIndex = monsterData.showIndex or self.selectShowIndex
    --选中当前
    monsterList = self.MonsterRowTem:GetItem(self.selectRowIndex)
    if monsterList then
        local monsterCell = monsterList:GetTemplatePool():GetItem(self.selectShowIndex)
        if monsterCell then
            monsterCell:SetMonsterSelectState(true)
        end
    end
end

function IllustrationMonster_ExploratoryRecordTem:RefreshRightPanel()
    local l_entityInfo = TableUtil.GetEntityTable().GetRowById(self.selectId)
    local l_handBookInfo = TableUtil.GetEntityHandBookTable().GetRowByID(self.selectId)
    self.Parameter.Text_RightTitle.LabText = StringEx.Format("{0} Lv.{1}", l_entityInfo.Name, l_entityInfo.UnitLevel)
    local nowLvl = self.data.GetMonsterRewardNowPickLvl(self.selectId)
    local pcikAll = nowLvl > l_handBookInfo.PointAward.Length
    nowLvl = pcikAll and l_handBookInfo.PointAward.Length or nowLvl
    self.selectLvl = nowLvl
    self.Parameter.Right_Level_Text.LabText = nowLvl
    local killnum = self.data.GetMonsterKillNum(self.selectId)
    self.Parameter.Text_Detailed.LabText = StringEx.Format(Common.Utils.Lang("KILL_SLIDER_TEXT"), killnum, l_handBookInfo.PointAward[nowLvl - 1][1])
    self.Parameter.Slide_Right.Img.fillAmount = killnum / l_handBookInfo.PointAward[nowLvl - 1][1]
    self.Parameter.Text_State_Point.LabText = "+" .. l_handBookInfo.PointAward[nowLvl - 1][2]
    self.Parameter.Btn_Receive:SetActiveEx(not pcikAll and killnum >= l_handBookInfo.PointAward[nowLvl - 1][1])
    self.Parameter.ReceiveRedSign:SetActiveEx(killnum >= l_handBookInfo.PointAward[nowLvl - 1][1])
    self.Parameter.Text_State_Right:SetActiveEx(false)
    self.TipsStr = ""
    for i = 0, l_handBookInfo.PointAward.Length - 1 do
        self.TipsStr = self.TipsStr .. Lang("MONSTER_BOOK_KILL_TIPS2", l_handBookInfo.PointAward[i][0], l_handBookInfo.PointAward[i][1], l_handBookInfo.PointAward[i][2])
    end
    self:SetRewardData(l_handBookInfo)
end

function IllustrationMonster_ExploratoryRecordTem:OnSelectBook(monsterdata)
    self:OnSelectMonster(monsterdata)
end

function IllustrationMonster_ExploratoryRecordTem:UnlockMonster(monsterId)
    --解锁魔物
    local monsterList = self.MonsterRowTem:GetItem(self.selectRowIndex)
    if monsterList then
        local monsterCell = monsterList:GetTemplatePool():GetItem(self.selectShowIndex)
        if monsterCell then
            monsterCell:SetMonsterCellUnlockState(monsterId)
            monsterCell:PlayEffect()
        end
    end
end

---@param handBookInfo EntityHandBookTable
function IllustrationMonster_ExploratoryRecordTem:SetRewardData(handBookInfo)
    local awardInfo = Common.Functions.VectorSequenceToTable(handBookInfo.LevelAward)
    local objectAwardId = handBookInfo.ObjectAwardId
    local profilePhotoId = handBookInfo.ProfilePhotoId
    local l_data = {}
    for i = 1, #awardInfo do
        local award = awardInfo[i][2]
        ---@class MonsterBookSingleRewardTemData
        local oneLua = {}
        oneLua.EntityId = self.selectId
        oneLua.Lvl = awardInfo[i][1]
        if award == 1 then
            oneLua.str = TableUtil.GetEntityPrivilegeTable().GetRowByID(1).Description
        elseif award == 2 then
            local l_awardData = TableUtil.GetAwardTable().GetRowByAwardId(objectAwardId)
            local itemDatas = {}
            if l_awardData ~= nil then
                for i = 0, l_awardData.PackIds.Length - 1 do
                    local l_packData = TableUtil.GetAwardPackTable().GetRowByPackId(l_awardData.PackIds[i])
                    if l_packData ~= nil then
                        for j = 0, l_packData.GroupContent.Count - 1 do
                            table.insert(itemDatas, { ID = tonumber(l_packData.GroupContent:get_Item(j, 0)) })
                        end
                    end
                end
            end
            oneLua.str = TableUtil.GetEntityPrivilegeTable().GetRowByID(2).Description
            oneLua.ItemId = itemDatas[1].ID
        elseif award == 3 then
            oneLua.str = TableUtil.GetEntityPrivilegeTable().GetRowByID(3).Description
            oneLua.ItemId = profilePhotoId
        elseif award ~= 0 then
            local itemInfo = Common.Functions.VectorSequenceToTable(TableUtil.GetEntityPrivilegeTable().GetRowByID(award).Content)
            item = TableUtil.GetItemTable().GetRowByItemID(itemInfo[1][1])
            oneLua.str = TableUtil.GetEntityPrivilegeTable().GetRowByID(award).Description
            oneLua.ItemId = itemInfo[1][1]
            oneLua.Count = itemInfo[1][2]
        end
        table.insert(l_data, oneLua)
    end
    self.RewardTem:ShowTemplates({ Datas = l_data })
end

function IllustrationMonster_ExploratoryRecordTem:ShowTips()
    local l_content = Common.Utils.Lang("MONSTER_BOOK_KILL_TIPS1") .. self.TipsStr
    MgrMgr:GetMgr("TipsMgr").ShowExplainPanelTips({
        content = l_content,
        alignment = UnityEngine.TextAnchor.UpperCenter,
        pos = {
            x = 500,
            y = 150,
        },
        width = 400,
    })
end

function IllustrationMonster_ExploratoryRecordTem:OnCtrlUpdate()
    if nil ~= self.RewardTem then
        self.RewardTem:OnUpdate()
    end

    if nil ~= self.MonsterRowTem then
        self.MonsterRowTem:OnUpdate()
    end
end
--lua custom scripts end
return IllustrationMonster_ExploratoryRecordTem