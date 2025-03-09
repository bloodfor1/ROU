--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/TeamTargetPanel"

--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua class define
local super = UI.UIBaseCtrl
TeamTargetCtrl = class("TeamTargetCtrl", super)
--lua class define end

PAGE_HIGTH = 28
MAX_INDEX = 10
LV_DISTANCE = 5     --生成ITEM等级差
LV_DOWNDISTANCE = 5 --右边比玩家等级小于5
LV_UPDISTANCE = 50  --左边比玩家等级大于50
SCROLL_SHOWITEMNUM = 5 --Scroll显示的玩家能看到的Item数量
SCROLL_BEGINNUM = 3 --从第几个开始显示
--lua functions
function TeamTargetCtrl:ctor()
    super.ctor(self, CtrlNames.TeamTarget, UILayer.Function, nil, ActiveType.Standalone)
    self.InsertPanelName = UI.CtrlNames.Team
end --func end
--next--
function TeamTargetCtrl:Init()
    self.panel = UI.TeamTargetPanel.Bind(self)
    super.Init(self)
    self.isFirstSetNum = 1
end --func end

--next--
function TeamTargetCtrl:Uninit()
    self.isFirstSetNum = 1
    super.Uninit(self)
    self.panel = nil
end --func end
--next--
function TeamTargetCtrl:OnActive()
    --self:SetParent(UI.CtrlNames.Team)
    self:InintPanel()
    self.hasInint = true
end --func end
--next--
function TeamTargetCtrl:OnDeActive()
    self.hasInint = false
end --func end
--next--
function TeamTargetCtrl:Update()
    if not self.hasInint then
        return
    end

    self:PageViewSetLeft()
    self:PageViewSetRight()
end --func end

function TeamTargetCtrl:PageViewSetLeft()
    local l_currentOffset = self.panel.PagesL.RectTransform.anchoredPosition.y
    if l_currentOffset > self.preOffsetL then
        self.dirL = 1
    elseif l_currentOffset < self.preOffsetL then
        self.dirL = -1
    end

    if l_currentOffset == self.preOffsetL then
        local l_offsetDiff = l_currentOffset % PAGE_HIGTH
        if l_offsetDiff > 5 then
            if self.dirL == 1 then
                local l_targetOffset = l_currentOffset - l_offsetDiff + PAGE_HIGTH
                self.panel.PagesL.RectTransform:DOLocalMoveY(l_targetOffset, 0.05)
            elseif self.dirL == -1 then
                local l_targetOffset = l_currentOffset - l_offsetDiff
                self.panel.PagesL.RectTransform:DOLocalMoveY(l_targetOffset, 0.05)
            end
        end
    end

    self.preOffsetL = l_currentOffset
end

function TeamTargetCtrl:PageViewSetRight()
    local l_currentOffset = self.panel.PagesR.RectTransform.anchoredPosition.y
    if l_currentOffset > self.preOffsetR then
        self.dirR = 1
    elseif l_currentOffset < self.preOffsetR then
        self.dirR = -1
    end

    if l_currentOffset == self.preOffsetR then
        local l_offsetDiff = l_currentOffset % PAGE_HIGTH
        if l_offsetDiff > 5 then
            if self.dirR == 1 then
                local l_targetOffset = l_currentOffset - l_offsetDiff + PAGE_HIGTH
                self.panel.PagesR.RectTransform:DOLocalMoveY(l_targetOffset, 0.05)
            elseif self.dirR == -1 then
                local l_targetOffset = l_currentOffset - l_offsetDiff
                self.panel.PagesR.RectTransform:DOLocalMoveY(l_targetOffset, 0.05)
            end
        end
    end

    self.preOffsetR = l_currentOffset
end

function TeamTargetCtrl:GetTargetIndex()
    local l_offsetL = self.panel.PagesL.RectTransform.anchoredPosition.y
    local l_offsetR = self.panel.PagesR.RectTransform.anchoredPosition.y
    return math.floor(math.abs(l_offsetL / PAGE_HIGTH + 0.5)) + SCROLL_BEGINNUM, math.floor(math.abs(l_offsetR / PAGE_HIGTH + 0.5)) + SCROLL_BEGINNUM
end

--next--
function TeamTargetCtrl:BindEvents()
    -- do nothing
end --func end

--next--
--lua functions end

--lua custom scripts
function TeamTargetCtrl:InintPanel()

    self.preOffsetL = 0
    self.preOffsetR = 0
    self.dirL = 0
    self.dirR = 0
    self.indexL = 3
    self.indexR = 3
    self.itemTbL = {}
    self.itemTbR = {}
    self.minLv = 0
    -------------------------

    self:GetData()
    self.teamSetting = DataMgr:GetData("TeamData").GetTempTeamSetting()
    self.itemTb = {}
    self:CreateTargetInfo()
    self:InintTeamSet(DataMgr:GetData("TeamData").myTeamInfo.teamSetting)

    self.panel.ButtonClose:AddClick(function()
        UIMgr:DeActiveUI(UI.CtrlNames.TeamTarget)
    end)

    self.panel.BtnconfirmEdit:AddClick(function()
        local data = DataMgr:GetData("TeamData").myTeamInfo
        local min, max = self:GetTargetIndex()
        self.teamSetting.min_lv = self.leftTb[min]
        self.teamSetting.max_lv = self.leftTb[max]
        if self.teamSetting.min_lv >= self.teamSetting.max_lv then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("CHOOSE_RIGHT_LV"))
            return
        end
        --目标不是无 且 目标是父节点 且 目标子节点>0
        if self.teamSetting.target ~= 1000 and self.teamSetting.target % 1000 == 0 and table.ro_size(self.parentIdTb[self.teamSetting.target]) > 0 then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("CHOOSE_RIGHT_TAREGT"))
            return
        end

        self.teamSetting.name = self.panel.TxtName.Input.text
        MgrMgr:GetMgr("TeamMgr").TeamSetting(self.teamSetting)

        if data then
            if self.panel.AutoPair.Tog.isOn == not DataMgr:GetData("TeamData").isAutoPair then
                if self.panel.AutoPair.Tog.isOn then
                    if self.teamSetting.target == 1000 then
                        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("CHOOSE_TEAM_TARGET_FIRST"))
                        return
                    end
                    local isFreeMatch = TableUtil.GetTeamTargetTable().GetRowByID(self.teamSetting.target).IsDuty
                    if not isFreeMatch then
                        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("TEAM_MATCH_FREE"))
                        MgrMgr:GetMgr("TeamMgr").AutoPairOperate(DataMgr:GetData("TeamData").EAutoPairType.autoTypeStart, self.teamSetting.target)
                    else
                        ---@type TeamMatchParam
                        local l_opendata = {
                            state = GameEnum.ETeamMatchOption.MatchMember,
                        }
                        UIMgr:ActiveUI(UI.CtrlNames.TeamCareerChoice1, l_opendata)
                    end
                    --MgrMgr:GetMgr("TeamMgr").AutoPairOperate(DataMgr:GetData("TeamData").EAutoPairType.autoTypeStart, self.teamSetting.target)
                else
                    MgrMgr:GetMgr("TeamMgr").AutoPairOperate(DataMgr:GetData("TeamData").EAutoPairType.autoTypeEnd, self.teamSetting.target)
                end
            end
        end
        UIMgr:DeActiveUI(UI.CtrlNames.TeamTarget)
    end)

end

function TeamTargetCtrl:InintTeamSet(teamSetting)

    if teamSetting then
        self.panel.TxtName.Input.text = teamSetting.name
    end

    self.panel.TxtName:OnInputFieldChange(function(value)
        value = StringEx.DeleteEmoji(value)
        value = StringEx.DeleteRichText(value)
        self.panel.TxtName.Input.text = value
    end)
    local data = DataMgr:GetData("TeamData").myTeamInfo
    if data then
        --策划需求进如设置界面 默认勾选自动匹配 队伍目标为无 不自动勾选
        if tonumber(teamSetting.target) == tonumber(1000) then
            self.panel.AutoPair.Tog.isOn = false
        else
            --组队人员已满 不设置自动匹配
            self.panel.AutoPair.Tog.isOn = DataMgr:GetData("TeamData").GetTeamNum() ~= DataMgr:GetData("TeamData").maxTeamNumber
        end
        --MgrMgr:GetMgr("TeamMgr").isAutoPair
    end
end

--参数1 意思是当前Scroll可视Item数量基数 minLv maxLv都是配置等级
function TeamTargetCtrl:SetTeamLevel(viewTotalCount, minLv, maxlv)
    minLv = minLv == 1 and 0 or minLv
    --需求变更 原本右边边是队长等级-5 现在改为配置最小等级-5
    local captainLv = minLv --MgrMgr:GetMgr("TeamMgr").myTeamInfo.captainLv
    --右边的初始化等级
    local curMinLv = 0 --最小等级 最小显示等级
    if captainLv <= minLv then
        curMinLv = (math.ceil((minLv - LV_DOWNDISTANCE) / LV_DISTANCE)) * LV_DISTANCE         --最小设置玩家等级小于5级并取5的整数倍
    else
        curMinLv = (math.ceil((captainLv - LV_DOWNDISTANCE) / LV_DISTANCE)) * LV_DISTANCE
    end

    self.newMinLv = curMinLv
    self.newMaxLv = curMinLv + LV_UPDISTANCE
    local leftCount = math.ceil((maxlv - minLv) / LV_DISTANCE) + viewTotalCount
    local rightCount = math.ceil((maxlv - minLv) / LV_DISTANCE) + viewTotalCount
    self.minLv = minLv
    self.maxLv = maxlv
    minLv = math.floor((minLv / LV_DISTANCE)) * LV_DISTANCE --如果minlv不是5的整数 取靠近这个数的5的整数 如 49则赋值为45

    self.leftTb = {}
    self.rightTb = {}
    local emptyItemNum = (viewTotalCount - 1) / 2
    for i = 1, leftCount do
        if i <= emptyItemNum then
            table.insert(self.leftTb, "")
        elseif i > leftCount - emptyItemNum then
            table.insert(self.leftTb, "")
        else
            if LV_DISTANCE * (i - 3) + minLv == 0 then
                table.insert(self.leftTb, 1)
            else
                local insertNum = LV_DISTANCE * (i - 3) + (minLv) + LV_DISTANCE > math.ceil(maxlv / 10) * 10 and maxlv or LV_DISTANCE * (i - 3) + (minLv)
                --如果插入的数字比最小的还小 那么设为最小值
                if insertNum < self.minLv then
                    insertNum = self.minLv
                end
                if insertNum > self.maxLv then
                    insertNum = self.maxLv
                end
                table.insert(self.leftTb, insertNum)
            end
        end
    end

    for z = 1, rightCount do
        if z <= emptyItemNum then
            table.insert(self.rightTb, "")
        elseif z > rightCount - emptyItemNum then
            table.insert(self.rightTb, "")
        else
            if LV_DISTANCE * (z - 3) + minLv == 0 then
                table.insert(self.rightTb, 1)
            else
                local insertNum = LV_DISTANCE * (z - 3) + (minLv) + LV_DISTANCE > math.ceil(maxlv / 10) * 10 and maxlv or LV_DISTANCE * (z - 3) + (minLv)
                --如果插入的数字比最小的还小 那么设为最小值
                if insertNum < self.minLv then
                    insertNum = self.minLv
                end
                if insertNum > self.maxLv then
                    insertNum = self.maxLv
                end
                table.insert(self.rightTb, insertNum)
            end
        end
    end

    self:InitLeftTemPlent(leftCount, self.leftTb)
    self:InitRightTemPlent(rightCount, self.rightTb)

    LayoutRebuilder.ForceRebuildLayoutImmediate(self.panel.PagesL.transform)
    LayoutRebuilder.ForceRebuildLayoutImmediate(self.panel.PagesR.transform)
    local pos = self.panel.PagesR.RectTransform.anchoredPosition
    self.panel.PagesL.RectTransform.anchoredPosition = Vector2.New(pos.x, (self.newMinLv / LV_DISTANCE - self.minLv / LV_DISTANCE) * PAGE_HIGTH)
    self.panel.PagesR.RectTransform.anchoredPosition = Vector2.New(pos.x, (self.newMaxLv / LV_DISTANCE - self.minLv / LV_DISTANCE) * PAGE_HIGTH)
end

function TeamTargetCtrl:InitLeftTemPlent(num, valueTb)

    for z = 1, table.maxn(self.itemTbL) do
        self.itemTbL[z].ui:SetActiveEx(false)
    end

    for i = 1, num do
        if self.itemTbL[i] == nil then
            self.itemTbL[i] = {}
            self.panel.PageLTem.UObj:SetActiveEx(true)
            self.itemTbL[i].ui = self:CloneObj(self.panel.PageLTem.UObj)
            self.itemTbL[i].ui.transform:SetParent(self.panel.PageLTem.transform.parent)
            self.itemTbL[i].ui.transform:SetLocalScaleOne()
            self.itemTbL[i].txt = MLuaClientHelper.GetOrCreateMLuaUICom(self.itemTbL[i].ui.transform:GetChild(0))
            self.itemTbL[i].txt.LabText = valueTb[i]
        else
            self.itemTbL[i].ui:SetActiveEx(true)
            self.itemTbL[i].txt.LabText = valueTb[i]
        end
    end
    self.panel.PageLTem.UObj:SetActiveEx(false)
end

function TeamTargetCtrl:InitRightTemPlent(num, valueTb)
    for z = 1, table.maxn(self.itemTbR) do
        self.itemTbR[z].ui:SetActiveEx(false)
    end

    for i = 1, num do
        if self.itemTbR[i] == nil then
            self.itemTbR[i] = {}
            self.panel.PageRTem.UObj:SetActiveEx(true)
            self.itemTbR[i].ui = self:CloneObj(self.panel.PageRTem.UObj)
            self.itemTbR[i].ui.transform:SetParent(self.panel.PageRTem.transform.parent)
            self.itemTbR[i].ui.transform:SetLocalScaleOne()
            self.itemTbR[i].txt = MLuaClientHelper.GetOrCreateMLuaUICom(self.itemTbR[i].ui.transform:GetChild(0))
            self.itemTbR[i].txt.LabText = valueTb[i]
        else
            self.itemTbR[i].ui:SetActiveEx(true)
            self.itemTbR[i].txt.LabText = valueTb[i]
        end
    end
    self.panel.PageRTem.UObj:SetActiveEx(false)
    self.panel.PagesR.UObj:SetActiveEx(false)
    self.panel.PagesR.UObj:SetActiveEx(true)
end

function TeamTargetCtrl:SendValue(value)
    local l_ui = UIMgr:GetUI(UI.CtrlNames.TeamSet)
    if l_ui then
        l_ui:SetSelfTeamSet(value)
    end
end

function TeamTargetCtrl:CreateTargetInfo()
    self.panel.Templent.gameObject:SetActiveEx(true)
    for i = 1, table.ro_size(self.parentSortTable) do
        local id = self.parentSortTable[i]
        self.itemTb[i] = {}
        self.itemTb[i].id = id
        self.itemTb[i].ui = self:CloneObj(self.panel.Templent.gameObject)
        self.itemTb[i].ui.transform:SetParent(self.panel.Templent.transform.parent)
        self.itemTb[i].ui.transform:SetLocalScaleOne()
        self.itemTb[i].childToogle = {}
        self:ExportElement(self.itemTb[i])
        self:CreateChildItem(id, self.itemTb[i])
        self.itemTb[i].parentItemTxtOn.LabText = DataMgr:GetData("TeamData").GetTargetNameById(id)
        self.itemTb[i].parentItemTxtOff.LabText = DataMgr:GetData("TeamData").GetTargetNameById(id)
        --如果子节点大小<=0 不显示箭头
        if table.ro_size(self.parentIdTb[id]) <= 0 then
            self.itemTb[i].arrowOn.gameObject:SetActiveEx(false)
            self.itemTb[i].arrowOff.gameObject:SetActiveEx(false)
        end
        self.itemTb[i].parentToogle.onValueChanged:AddListener(function(index)
            if index then
                self:ShowChildItemById(id, true)
            else
                self:ShowChildItemById(id, false)
            end
        end)

        --找到目标的父节点
        if self.teamSetting.target - self.teamSetting.target % 1000 == id then
            self.itemTb[i].parentToogle.isOn = false
            self.itemTb[i].parentToogle.isOn = true
        else
            self.itemTb[i].parentToogle.isOn = false
        end

    end
    self.panel.Templent.gameObject:SetActiveEx(false)
end

function TeamTargetCtrl:CreateChildItem(id, sourceItem)
    if self.parentIdTb[id] then
        sourceItem.childItem.gameObject:SetActiveEx(true)
        for x = 1, table.ro_size(self.parentIdTb[id]) do
            local childId = self.parentIdTb[id][x]
            sourceItem.childToogle[childId] = {}
            sourceItem.childToogle[childId].id = self.parentIdTb[id][x]
            sourceItem.childToogle[childId].ui = self:CloneObj(sourceItem.childItem.gameObject)
            sourceItem.childToogle[childId].ui.transform:SetParent(sourceItem.childItem.parent)
            sourceItem.childToogle[childId].ui.gameObject:SetActiveEx(false)
            sourceItem.childToogle[childId].ui.transform:SetLocalScaleOne()
            self:ExportChild(sourceItem.childToogle[childId])
            sourceItem.childToogle[childId].childItemTxtOn.LabText = DataMgr:GetData("TeamData").GetTargetNameById(self.parentIdTb[id][x])
            sourceItem.childToogle[childId].childItemTxtOff.LabText = DataMgr:GetData("TeamData").GetTargetNameById(self.parentIdTb[id][x])
            sourceItem.childToogle[childId].childToogle.IsSetAsLast = false
            sourceItem.childToogle[childId].childToogle.onValueChanged:AddListener(function(index)
                if index then
                    self.teamSetting.target = childId
                    local l_teamTargetData = TableUtil.GetTeamTargetTable().GetRowByID(childId)
                    if l_teamTargetData then
                        self:SetTeamLevel(SCROLL_SHOWITEMNUM, l_teamTargetData.LevelLimit[0], l_teamTargetData.LevelLimit[1])
                        self:SetTimeAndLimit(l_teamTargetData.LevelLimit[0], l_teamTargetData.LevelLimit[1], l_teamTargetData.Time, l_teamTargetData)
                    end
                end
            end)
        end
        sourceItem.childItem.gameObject:SetActiveEx(false)
    end
end

function TeamTargetCtrl:ShowChildItemById(id, show)

    if show then
        self.panel.MercenaryText.gameObject:SetActiveEx(false)
        if self.isFirstSetNum ~= 1 then
            self.teamSetting.target = id
        else
            self.isFirstSetNum = self.isFirstSetNum + 1
        end
        local l_teamTargetData = TableUtil.GetTeamTargetTable().GetRowByID(id, true)
        if l_teamTargetData and show then
            self:SetTeamLevel(SCROLL_SHOWITEMNUM, l_teamTargetData.LevelLimit[0], l_teamTargetData.LevelLimit[1])
            self:SetTimeAndLimit(l_teamTargetData.LevelLimit[0], l_teamTargetData.LevelLimit[1], l_teamTargetData.Time, l_teamTargetData)
        end
    end

    for i = 1, table.ro_size(self.itemTb) do
        if self.itemTb[i].id == id then
            for x = 1, table.ro_size(self.parentIdTb[id]) do
                local childId = self.parentIdTb[id][x]
                self.itemTb[i].childToogle[childId].ui.gameObject:SetActiveEx(show)
                if show then
                    --如果组队设置是父节点 那么取值第一个 如果组队设置是子节点 取子节点
                    local target = self.teamSetting.target % 1000 == 0 and self.parentIdTb[id][1] or self.teamSetting.target
                    if childId == target then
                        self.itemTb[i].childToogle[childId].childToogle.isOn = false
                        self.itemTb[i].childToogle[childId].childToogle.isOn = true
                    else
                        self.itemTb[i].childToogle[childId].childToogle.isOn = false
                    end
                end
            end
        end
    end

    if tonumber(id) == tonumber(1000) then
        self.panel.AutoPair.Tog.isOn = false
    else
        --组队人员已满 不设置自动匹配
        self.panel.AutoPair.Tog.isOn = DataMgr:GetData("TeamData").GetTeamNum() ~= DataMgr:GetData("TeamData").maxTeamNumber
    end

    local rtTrans = self.panel.Content.transform:GetComponent("RectTransform")
    LayoutRebuilder.ForceRebuildLayoutImmediate(rtTrans)
end

function TeamTargetCtrl:GetData()
    self.parentIdTb = {}
    self.parentSortTb = {}
    local l_targetData = TableUtil.GetTeamTargetTable().GetTable()
    local l_captainLv = DataMgr:GetData("TeamData").myTeamInfo.captainLv
    if l_targetData then
        for c, v in pairs(l_targetData) do
            local lvLimit = v.LevelLimit
            if l_captainLv >= lvLimit[0] then
                if v.ID % 1000 == 0 then
                    self.parentIdTb[v.ID] = {}
                    table.insert(self.parentSortTb, v.ID)
                else
                    if v.BelongType ~= 0 then
                        if self.parentIdTb[v.BelongType] then
                            table.insert(self.parentIdTb[v.BelongType], v.ID)
                        else
                            self.parentIdTb[v.BelongType] = {}
                            table.insert(self.parentIdTb[v.BelongType], v.ID)
                        end
                    end
                end
            end
        end
    end
    --排序后的父节点
    self.parentSortTable = {}
    for key, value in pairs(self.parentIdTb) do
        table.insert(self.parentSortTable,key)
    end
    table.sort(self.parentSortTable,function (a,b)
        local l_data_a = TableUtil.GetTeamTargetTable().GetRowByID(a)
        local l_data_b = TableUtil.GetTeamTargetTable().GetRowByID(b)
        return l_data_a and l_data_b and l_data_a.Sort < l_data_b.Sort
    end)
end

function TeamTargetCtrl:ExportElement(element)
    element.parentToogle = element.ui.transform:Find("ParentItem/TogL"):GetComponent("MLuaUICom").TogEx
    element.parentItem = element.ui.transform:Find("ParentItem/TogL")
    element.childItem = element.ui.transform:Find("ChildItem/TogS")
    element.parentItemTxtOn = MLuaClientHelper.GetOrCreateMLuaUICom(element.ui.transform:Find("ParentItem/TogL/ON/Text"))
    element.parentItemTxtOff = MLuaClientHelper.GetOrCreateMLuaUICom(element.ui.transform:Find("ParentItem/TogL/Off/Text"))
    element.arrowOn = element.ui.transform:Find("ParentItem/TogL/ON/Img02")
    element.arrowOff = element.ui.transform:Find("ParentItem/TogL/Off/Img02")
end

function TeamTargetCtrl:ExportChild(element)
    element.childToogle = element.ui.transform:GetComponent("MLuaUICom").TogEx
    element.childItemTxtOn = MLuaClientHelper.GetOrCreateMLuaUICom(element.ui.transform:Find("ON/Text"))
    element.childItemTxtOff = MLuaClientHelper.GetOrCreateMLuaUICom(element.ui.transform:Find("Off/Text"))
end

function TeamTargetCtrl:SetTimeAndLimit(minLv, maxLv, time, tableData)
    if minLv == 0 then
        self.panel.TxtLimit.LabText = Common.Utils.Lang("NOT_LIMIT")
    else
        self.panel.TxtLimit.LabText = "Lv" .. minLv .. "-Lv" .. maxLv
    end
    self.panel.TextTime.LabText = time

    local l_RelativeDungeonId = tableData.RelativeDungeonId
    local l_showMercenaryText = 0
    if l_RelativeDungeonId then
        local l_sceneData = TableUtil.GetSceneTable().GetRowByID(l_RelativeDungeonId, true)
        l_showMercenaryText = l_sceneData and l_sceneData.MerceneryNotAllow or 0
    end
    self.panel.MercenaryText.gameObject:SetActiveEx(l_showMercenaryText == 1)
end

--lua custom scripts end

return TeamTargetCtrl
