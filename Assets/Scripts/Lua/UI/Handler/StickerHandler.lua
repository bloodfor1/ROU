--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseHandler"
require "UI/Panel/StickerPanel"
require "UI/Template/StickItemTemplate"
require "UI/Template/StickerScrollItemTemplate"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua fields
local super = UI.UIBaseHandler
local Vector3Type = System.Type.GetType("UnityEngine.Vector3, UnityEngine.CoreModule")
local lastClickIdx = -1
local lastClickEquipIdx = -1
local chooseGroupIdx = -1
--next--
--lua fields end

--lua class define
StickerHandler = class("StickerHandler", super)
--lua class define end

--lua functions
function StickerHandler:ctor()

	super.ctor(self, HandlerNames.Sticker, 0)
end --func end
--next--
function StickerHandler:Init()
	self.mgr = MgrMgr:GetMgr("StickerMgr")
    self.archieveMgr = MgrMgr:GetMgr("AchievementMgr")
	self.panel = UI.StickerPanel.Bind(self)
	super.Init(self)
	self.equipStickerPool = self:NewTemplatePool({
        UITemplateClass = UITemplate.StickItemTemplate,
        TemplateParent = self.panel.StickerWall.transform,
        TemplatePrefab = self.panel.StickItemTemplate.LuaUIGroup.gameObject
    })
    self.stickerPool = self:NewTemplatePool({
        UITemplateClass = UITemplate.StickerScrollItemTemplate,
        TemplateParent = self.panel.StickerContent.transform,
        TemplatePrefab = self.panel.StickerScrollItemTemplate.LuaUIGroup.gameObject
    })
    self.mgr.g_gridGap = self.panel.StickerWall:GetComponent("HorizontalLayoutGroup").spacing
    self.contentGridLayout = self.panel.StickerContent:GetComponent("GridLayoutGroup")
    self.lastHightGrids = nil
    self.vectorArray1 = System.Array.CreateInstance(Vector3Type, 4)
    self.vectorArray2 = System.Array.CreateInstance(Vector3Type, 4)
    self.fromGridIdx = 0
    self.targetGridIdx = 0
    self.gridInfo = nil
    self.isDraging = false
    self.togs = {}

    -- Info说明
    MLuaUIListener.Get(self.panel.BtnInfo.gameObject)
    self.panel.BtnInfo.Listener.onClick = function(go, ed)
        MgrMgr:GetMgr("TipsMgr").ShowQuestionTip(Lang("PERSONAL_PLASTER_INFO_TIP", unpack(self.mgr.GetGridBuffTexts())), ed, Vector2(1,1))
    end

    self:InitStickerTog()
end --func end
--next--
function StickerHandler:Uninit()
    self.togs = {}
    self.vectorArray1 = nil
    self.vectorArray2 = nil
    self.equipStickerPool = nil
    self.stickerPool = nil
    if not MLuaCommonHelper.IsNull(self.panel.SelectBg.gameObject) then
        MResLoader:ClearObjPool(self.panel.SelectBg.gameObject)
    end
	super.Uninit(self)
	self.panel = nil

end --func end
--next--
function StickerHandler:OnActive()
    self.panel.StickItemTemplate.LuaUIGroup.gameObject:SetActiveEx(false)
    self.panel.SelectBg:SetActiveEx(false)
    self.panel.Tog:SetActiveEx(false)
    self.mgr.RequestGridState()
    self:RefreshStickers()
end --func end
--next--
function StickerHandler:OnDeActive()
    chooseGroupIdx = -1
    self.lastHightGrids = nil
    self.gridInfo = nil
    self.isDraging = false
    self.fromGridIdx = 0
    self.targetGridIdx = 0
end --func end
--next--
function StickerHandler:Update()

end --func end



--next--
function StickerHandler:BindEvents()
    self:BindEvent(self.mgr.EventDispatcher,self.mgr.EVENT_REFRESH_GRIDS, self.RefreshGrids)
    self:BindEvent(self.mgr.EventDispatcher,self.mgr.EVENT_REFRESH_STICKS, self.RefreshStickers)
end --func end
--next--
--lua functions end

--lua custom scripts
function StickerHandler:RefreshGrids()
    self.panel.StickItemTemplate.LuaUIGroup.gameObject:SetActiveEx(false)
    self.panel.SelectBg:SetActiveEx(false)
    local equipStickers = self.mgr.GetEquipStickers()
    self.equipStickerPool:ShowTemplates({Datas = equipStickers})
    if #equipStickers > 0 then
        local idx = lastClickEquipIdx > 0 and lastClickEquipIdx or 1
        local item = self.equipStickerPool:GetItem(idx)
        if item then
            self:OnClickGridNormalBg(item, true)
        end
    end
end

function StickerHandler:GetGridInfo()
    local gridInfo = {}
    for _, v in ipairs(self.equipStickerPool.Items) do
        for i = 1, v.length do
            if v.grids and v.grids[i] then
                table.insert(gridInfo, {
                    grid = v.grids[i],
                    item = v,
                })
            end
        end
    end
    return gridInfo
end

--region 拖拽
function StickerHandler:OnBeginDragStick(item, isHide)
    self.isDraging = false
    self.fromGridIdx = item.ShowIndex
    item:SetIconPivot(Vector2(0, 0.5))
    if isHide then
        item.Parameter.Icon.Img.color = Color(1,1,1,0)
    end
    self.panel.StickerWall:GetComponent("HorizontalLayoutGroup").enabled = false
    if self.equipStickerPool then
        for i, v in pairs(self.equipStickerPool.Items) do
            v:ShowGrids(self.panel.SelectBg.gameObject)
        end
    end
    self.gridInfo = self:GetGridInfo()
end

function StickerHandler:OnDragingStick(item, ed)
    self.isDraging = true
    if self.lastHightGrids then
        for i, v in ipairs(self.lastHightGrids) do
            v.item:Reset(v.grid)
        end
        self.lastHightGrids = nil
    end
    if self.equipStickerPool and item and self.gridInfo then

        local moveObj = item.Parameter.Icon.DragItem:GetMoveObject()
        if not moveObj then 
            return
        end
        local moveObjCom = moveObj:GetComponent("MLuaUICom")
        if moveObjCom.Img.color.a == 0 then
            moveObjCom.Img.color = Color.white
        end
        local pressed = {}
        for _, v in ipairs(self.gridInfo) do
            if Common.Utils.IsRectTransformOverlap(moveObjCom.RectTransform, v.grid:GetComponent("RectTransform"),
                    self.vectorArray1, self.vectorArray2) then
                table.insert(pressed, v)
            end
        end
        for i = 1, item.length do
            if pressed[i] and pressed[i].item then
                if i == 1 then
                    self.targetGridIdx = self:GetPosIdxByGrid(pressed[i].item, pressed[i].grid)
                    break
                end
            end
        end
        if #pressed == 0 then
            self.targetGridIdx = -1
        end
        if self.targetGridIdx > 0 then
            local canDrop = self.mgr.CanDrop(item.id, self.targetGridIdx, item.length)
            for i = 1, item.length do
                if pressed[i] and pressed[i].item then
                    pressed[i].item:HighLight(pressed[i].grid, canDrop)
                end
            end
        end
        self.lastHightGrids = pressed
    end
end

function StickerHandler:OnEndDragStick(item)
    self.isDraging = false
    self.gridInfo = nil
    item.Parameter.Icon:SetGray(not self.mgr.IsOpen(item.id))
    self.panel.StickerWall:GetComponent("HorizontalLayoutGroup").enabled = true
    if self.equipStickerPool then
        for i, v in pairs(self.equipStickerPool.Items) do
            v:ShowNormal()
        end
    end
    if self.targetGridIdx > 0 then
        self.mgr.DropStick(item.id, self.targetGridIdx)
    elseif item.isFromGrid then
        self.mgr.DropStick(item.id)
    end
end
--endregion

function StickerHandler:InitStickerTog()
    local group = self.panel.Toggroup:GetComponent('UIToggleExGroup')
    for i = 1, 5 do
        local groupDatas = self.mgr.GetStickersByLength(i)
        if #groupDatas > 0 then
            local tog = self:CloneObj(self.panel.Tog.gameObject)
            tog:SetActiveEx(true)
            tog.transform:SetParent(self.panel.Tog.transform.parent, false)
            local togCom = tog:GetComponent('MLuaUICom')
            togCom.TogEx.onValueChanged:AddListener(function(value)
                if value then
                    self:OnStickerTogChange(i)
                end
            end)
            togCom.TogEx.group = group
            local l_ui = UIMgr:GetUI(UI.CtrlNames.Personal)
            if l_ui then
                local buttonOnText = l_ui:_getChildText(togCom.TogEx.buttonOn.transform)
                local buttonOffText = l_ui:_getChildText(togCom.TogEx.buttonOff.transform)
                local name = Lang("STICKER_TOGGLE_NAME", i)
                buttonOnText.LabText = name
                buttonOffText.LabText = name
                table.insert(self.togs, togCom)
            end
        end
    end
end

function StickerHandler:RefreshStickers(force)
    self.panel.StickerScrollItemTemplate.LuaUIGroup.gameObject:SetActiveEx(false)
    local idx = 1
    if chooseGroupIdx > 0 then
        idx = chooseGroupIdx
    end
    if force then
        self:OnStickerTogChange(idx, force)
    else
        self.togs[idx].TogEx.isOn = false
        self.togs[idx].TogEx.isOn = true
    end
end

function StickerHandler:OnStickerTogChange(idx, force)
    if idx == chooseGroupIdx and not force then return end
    chooseGroupIdx = idx
    self.contentGridLayout.cellSize = Vector2(self.mgr.g_itemBaseWidth * idx, self.mgr.g_itemBaseWidth)
    self.contentGridLayout.constraintCount = math.floor(self.contentGridLayout:GetComponent("RectTransform").rect.width / self.mgr.g_itemBaseWidth * idx)
    local groupDatas = self.mgr.GetStickersByLength(idx)
    local datas = {}
    for i, v in ipairs(groupDatas) do
        table.insert(datas, {
            id = v.StickersID,
            isUse = self.mgr.IsUse(v.StickersID),
            isOpen = self.mgr.IsOpen(v.StickersID)
        })
    end
    self.stickerPool:ShowTemplates({Datas = datas})
    if #datas > 0 then
        local item = self.stickerPool:GetItem(1)
        if item then
            self:OnClickScrollStick(item)
        end
    end
end

--==============================--
--@Description:点击scroll item
--@Date: 2018/12/14
--@Param: [args]
--@Return:
--==============================--
function StickerHandler:OnClickScrollStick(item)
    if lastClickEquipIdx > 0 then
        local item = self.equipStickerPool:GetItem(lastClickEquipIdx)
        if item then
            item:SetSelect(false)
        end
        lastClickEquipIdx = -1
    end
    if lastClickIdx > 0 then
        local item = self.stickerPool:GetItem(lastClickIdx)
        if item then
            item:SetSelect(false)
        end
    end
    lastClickIdx = item.ShowIndex

    local isOpen = self.mgr.IsOpen(item.id)
    if isOpen then
        self.panel.ActiveTxt.LabText = GetColorText(Lang("STICKER_ACTIVE_TXT"), RoColorTag.Green)
    else
        self.panel.ActiveTxt.LabText = GetColorText(Lang("STICKER_DEACTIVE_TXT"), RoColorTag.Red)
    end

    local achieveSdata
    if item.id > 0 then
        achieveSdata = self.mgr.GetAchieveSdataByStickerId(item.id)
        if not achieveSdata then
            --logError("获取成就静态数据失败 id: ", item.id)
            --return
        end
        self.panel.AchieveDescPart:SetActiveEx(true)
        if item.sdata then
            self.panel.Icon:SetActiveEx(true)
            self.panel.Icon:SetSpriteAsync(item.sdata.StickersAtlas, item.sdata.StickersIcon, nil, true)
            self.panel.Icon:SetGray(not isOpen)
        end
        self.panel.AchieveName.LabText = item.sdata.StickersName
        self.panel.BuffTxt:SetActiveEx(false)

        self.panel.AchieveBg:SetActiveEx(achieveSdata ~= nil)
        if achieveSdata then
            self.panel.ConditionTxt.LabText = Lang("STICKER_UNLOAD_TXT", achieveSdata.Name)
            self.panel.AchieveDesc.LabText = achieveSdata.Desc
            local proc, maxProc = self.archieveMgr.GetAchievementProgressCountWithId(achieveSdata.ID)
            self.panel.Slider.Slider.value =  proc / maxProc
            self.panel.SlideText.LabText = StringEx.Format("{0}/{1}", proc, maxProc)
        end

    end
    self.panel.ConditionTxt:AddClick(function()
        if achieveSdata then
            self.archieveMgr.OpenAchievementPanel(achieveSdata.ID)
        end
    end)

    self.panel.Slider:SetActiveEx(true)
end

--==============================--
--@Description:点击状态栏icon
--@Date: 2018/12/14
--@Param: [args]
--@Return:
--==============================--
function StickerHandler:OnClickGridIcon(item)
    if lastClickEquipIdx > 0 then
        local item = self.equipStickerPool:GetItem(lastClickEquipIdx)
        if item then
            item:SetSelect(false)
        end
    end
    self:OnClickScrollStick(item)
    self.panel.BuffTxt:SetActiveEx(false)
    lastClickEquipIdx = item.ShowIndex

end

--==============================--
--@Description:点击解锁
--@Date: 2018/12/15
--@Param: [args]
--@Return:
--==============================--
function StickerHandler:OnClickGridLock(item)
    self:OnClickGridNormalBg(item)
end

--==============================--
--@Description:点击格子底
--@Date: 2018/12/14
--@Param: [args]
--@Return:
--==============================--
function StickerHandler:OnClickGridNormalBg(item, isRefresh)
    if lastClickIdx > 0 then
        local item = self.stickerPool:GetItem(lastClickIdx)
        if item then
            item:SetSelect(false)
        end
        lastClickIdx = -1
    end
    if lastClickEquipIdx > 0 then
        local item = self.equipStickerPool:GetItem(lastClickEquipIdx)
        if item then
            item:SetSelect(false)
        end
    end
    lastClickEquipIdx = item.ShowIndex

    self.panel.Icon:SetActiveEx(false)
    self.panel.AchieveName.LabText = self.mgr.GetGridName(item.idx)
    self.panel.BuffTxt:SetActiveEx(true)
    local str = self.mgr.GetGridBuffText(item.idx)
    if item.id == 0 then
        if item.status == self.mgr.StickerStatus.open then
            str = GetColorText(str, RoColorTag.Green)
        else
            str = GetColorText(str, RoColorTag.Gray)
        end
    end
    self.panel.BuffTxt.LabText = str

    if item.status == self.mgr.StickerStatus.award and not isRefresh then
        local idx = self:GetPosIdxByItem(item)
        if idx < 0 then
            logError("find item grid idx fail ", item.ShowIndex)
            return
        end
        self.mgr.RequestUnlockGrid(idx)
    end
    local isOpen = self.mgr.IsGridOpen(item.idx)
    if isOpen then
        self.panel.ActiveTxt.LabText = GetColorText(Lang("STICKER_ACTIVE_TXT"), RoColorTag.Green)
    else
        self.panel.ActiveTxt.LabText = GetColorText(Lang("STICKER_DEACTIVE_TXT"), RoColorTag.Red)
    end

    self.panel.ConditionTxt:AddClick(function()
    end)

    -- 显示成就
    self.panel.AchieveBg:SetActiveEx(true)
    local totalAchieve, needAchieve = MgrMgr:GetMgr("AchievementMgr").TotalAchievementPoint, self.mgr.GetNeedTotalAchieve(item.idx)
    self.panel.ConditionTxt.LabText = Lang("STICKER_UNLOAD_Grid_TXT", needAchieve)
    self.panel.Slider:SetActiveEx(needAchieve ~= 0)
    if needAchieve ~= 0 then
        self.panel.Slider.Slider.value = totalAchieve / needAchieve
        self.panel.SlideText.LabText = StringEx.Format("{0}/{1}", totalAchieve, needAchieve)
    end
    self.panel.AchieveDescPart:SetActiveEx(false)
end

function StickerHandler:GetPosIdxByItem(item)
    local ret = -1
    if self.equipStickerPool then
        local _, idx = array.find(self.equipStickerPool.Items, function(v) return v == item end)
        if idx then
            local length = 0
            for i = 1, idx - 1 do
                length = length + self.equipStickerPool.Items[i].length
            end
            ret = length + 1
        end
    end
    return ret
end

function StickerHandler:GetPosIdxByGrid(item, grid)
    local ret = -1
    local itemPos = self:GetPosIdxByItem(item)
    local gridIdx = item:GetGridIdx(grid)
    ret = itemPos + gridIdx - 1
    return ret
end
--lua custom scripts end

return StickerHandler