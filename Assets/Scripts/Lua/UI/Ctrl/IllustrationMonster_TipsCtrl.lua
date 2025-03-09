--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/IllustrationMonster_TipsPanel"
--lua requires end

--lua model
module("UI", package.seeall)

--lua model end

--lua fields
local super = UI.UIBaseCtrl
--lua fields end

--lua class define
IllustrationMonster_TipsCtrl = class("IllustrationMonster_TipsCtrl", super)
--lua class define end

--lua functions
function IllustrationMonster_TipsCtrl:ctor()

    super.ctor(self, CtrlNames.IllustrationMonster_Tips, UILayer.Function, nil, ActiveType.Normal)

end --func end
--next--
function IllustrationMonster_TipsCtrl:Init()

    self.panel = UI.IllustrationMonster_TipsPanel.Bind(self)
    super.Init(self)
    self.selectItem = 0
    self.panel.Text_Award:GetRichText().onHrefClick:AddListener(function(hrefName)
        MgrMgr:GetMgr("ItemTipsMgr").ShowTipsDisplayWithId(self.selectItem)
    end)
    self.DeleteTime = 3
    self.OpenTime = nil
end --func end
--next--
function IllustrationMonster_TipsCtrl:Uninit()

    super.Uninit(self)
    self.panel = nil
    self.selectItem = 0

end --func end
--next--
function IllustrationMonster_TipsCtrl:OnActive()
    if self.uiPanelData then
        local monsterName = TableUtil.GetEntityTable().GetRowById(self.uiPanelData.id).Name
        local l_monsterReward = TableUtil.GetEntityHandBookTable().GetRowByID(self.uiPanelData.id)
        local levelAwardInfo = Common.Functions.VectorSequenceToTable(l_monsterReward.LevelAward)
        local levelAward = 0
        for i=1,#levelAwardInfo do
            if levelAwardInfo[i][1] == self.uiPanelData.Lvl then
                levelAward = levelAwardInfo[i][2]
                break
            end
        end
        self.panel.Textup.LabText = StringEx.Format(Common.Utils.Lang("ILLUSTRATION_MONSTER_TIPS"), monsterName, self.uiPanelData.Lvl)

        if levelAward == 1 then

            self.panel.Text_Award.LabText = TableUtil.GetEntityPrivilegeTable().GetRowByID(1).Description
            self.panel.Text_Award:SetActiveEx(true)
            self.panel.UniockHeadwear:SetActiveEx(false)
        elseif levelAward == 2 then
            local l_awardData = TableUtil.GetAwardTable().GetRowByAwardId(l_monsterReward.ObjectAwardId)
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
            self.panel.Text_Award.LabText = StringEx.Format(TableUtil.GetEntityPrivilegeTable().GetRowByID(2).Description, TableUtil.GetItemTable().GetRowByItemID(itemDatas[1].ID).ItemName)
            self.selectItem = itemDatas[1].ID
            self.panel.Text_Award:SetActiveEx(true)
            self.panel.UniockHeadwear:SetActiveEx(false)
        elseif levelAward == 3 then
            if self.ItemTem == nil then
                self.ItemTem = self:NewTemplate("ItemTemplate", { TemplateParent = self.panel.Pos.transform })
            end
            self.ItemTem:SetData({ ID = l_monsterReward.ProfilePhotoId })
            self.panel.Text_UniockHeadwear.LabText = TableUtil.GetEntityPrivilegeTable().GetRowByID(3).Description
            self.panel.Text_Award:SetActiveEx(false)
            self.panel.UniockHeadwear:SetActiveEx(true)
        elseif levelAward ~= 0 then
            local itemInfo = Common.Functions.VectorSequenceToTable(TableUtil.GetEntityPrivilegeTable().GetRowByID(levelAward).Content)
            item = TableUtil.GetItemTable().GetRowByItemID(itemInfo[1][1])
            if self.ItemTem == nil then
                self.ItemTem = self:NewTemplate("ItemTemplate", { TemplateParent = self.panel.Pos.transform })
            end
            self.ItemTem:SetData({ ID = itemInfo[1][1], Count = itemInfo[1][2] })
            self.panel.Text_UniockHeadwear.LabText = TableUtil.GetEntityPrivilegeTable().GetRowByID(levelAward).Description
            self.panel.Text_Award:SetActiveEx(false)
            self.panel.UniockHeadwear:SetActiveEx(true)
        else
            self.panel.Text_Award.LabText = Common.Utils.Lang("ILLUSTRATION_MONSTER_AWARD_NULL")
            self.panel.Text_Award:SetActiveEx(true)
            self.panel.UniockHeadwear:SetActiveEx(false)
        end
        self.panel.Text1:SetActiveEx(self.panel.Text_Award.gameObject.activeSelf)
        self.OpenTime = Common.TimeMgr.GetNowTimestamp()

        local presentId = TableUtil.GetEntityTable().GetRowById(self.uiPanelData.id).PresentID
        local monsterPresentData = TableUtil.GetPresentTable().GetRowById(presentId)
        if monsterPresentData then
            self.panel.monstericon:SetActiveEx(true)
            self.panel.monstericon:SetSprite(monsterPresentData.Atlas, monsterPresentData.Icon,true)
        else
            self.panel.monstericon:SetActiveEx(false)
        end

    end
end --func end
--next--
function IllustrationMonster_TipsCtrl:OnDeActive()


end --func end
--next--
function IllustrationMonster_TipsCtrl:Update()
    if self.OpenTime then
        if Common.TimeMgr.GetNowTimestamp() - self.OpenTime >= self.DeleteTime then
            UIMgr:DeActiveUI(UI.CtrlNames.IllustrationMonster_Tips)
        end
    end
end --func end
--next--
function IllustrationMonster_TipsCtrl:BindEvents()


end --func end
--next--
--lua functions end

--lua custom scripts

--lua custom scripts end
return IllustrationMonster_TipsCtrl