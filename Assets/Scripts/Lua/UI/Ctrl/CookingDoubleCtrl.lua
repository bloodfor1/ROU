--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/CookingDoublePanel"
require "coroutine"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua class define
local super = UI.UIBaseCtrl
CookingDoubleCtrl = class("CookingDoubleCtrl", super)
--lua class define end

local l_mgr = MgrMgr:GetMgr("CookingDoubleMgr")
local OperationType =
{
    Unknown = 0,
    Pick = 1,
    Cut = 2,
    Drop = 3,
    CheckPot = 4,
    Cook = 5,
}

--lua functions
function CookingDoubleCtrl:ctor()

    super.ctor(self, CtrlNames.CookingDouble, UILayer.Normal)

end --func end
--next--
function CookingDoubleCtrl:Init()

    self.panel = UI.CookingDoublePanel.Bind(self)
    super.Init(self)
    self:CustomInit()

end --func end
--next--
function CookingDoubleCtrl:Uninit()

    self:CustomUninit()

    super.Uninit(self)
    self.panel = nil

end --func end
--next--
function CookingDoubleCtrl:OnActive()
    self.panel.Start.gameObject:SetActiveEx(false)
    self.panel.TimeOver.gameObject:SetActiveEx(false)
    self.panel.CookingDoubleMenu.gameObject:SetActiveEx(false)
    self.panel.BtnOperation.gameObject:SetActiveEx(false)

end --func end
--next--
function CookingDoubleCtrl:OnDeActive()

    self:ClearMenus()
    self.opId = 0
    self.objUid = nil
    self.opHint = nil

end --func end
--next--
function CookingDoubleCtrl:Update()


end --func end

--next--
function CookingDoubleCtrl:BindEvents()

    -- start and end
    self:BindEvent(l_mgr.EventDispatcher,l_mgr.COOKING_DOUBLE_START,function ()
        self:PlayStartNotice()
    end)
    self:BindEvent(l_mgr.EventDispatcher,l_mgr.COOKING_DOUBLE_END,function (self, finishCount, finishScore, failedCount, success)
        if success then
            self.panel.TimeOver:SetSpriteAsync("FontSprite", "UI_Cooking_SuccessfuL.png", function()
                self.panel.TimeOver.gameObject:SetActiveEx(true)
            end, true)
        else
            self.panel.TimeOver:SetSpriteAsync("FontSprite", "UI_Cooking_Timeover.png", function()
                self.panel.TimeOver.gameObject:SetActiveEx(true)
            end, true)
        end
        local l_timer = self:NewUITimer(function()
            if self.panel ~= nil then
                self.panel.TimeOver.gameObject:SetActiveEx(false)
                local l_finishUI = UIMgr:ActiveUI(UI.CtrlNames.CookingDoubleFinsh)
                l_finishUI:SetFinishedData(finishCount, finishScore, failedCount, success)
            end
        end, 2, 0, true)
        l_timer:Start()
    end)

    -- menu
    self:BindEvent(l_mgr.EventDispatcher,l_mgr.COOKING_DOUBLE_ADD_MENU,function (self, menuId, uid, remainTime)
        self:AddMenu(menuId, uid, remainTime)
    end)
    self:BindEvent(l_mgr.EventDispatcher,l_mgr.COOKING_DOUBLE_REMOVE_MENU,function (self, menuUid)
        self:RemoveMenu(menuUid)
    end)
    self:BindEvent(l_mgr.EventDispatcher,l_mgr.COOKING_DOUBLE_CLEAR_MENU,function ()
        self:ClearMenus()
    end)
    self:BindEvent(l_mgr.EventDispatcher,l_mgr.COOKING_DOUBLE_MENU_TIME,function (self, menuUid, time)
        self:SetMenuTime(menuUid, time)
    end)
    -- operation
    self:BindEvent(l_mgr.EventDispatcher,l_mgr.COOKING_DOUBLE_OPERATION,function (self, opId, objUid, opHint)
        self.opId = opId
        self.objUid = objUid
        self.opHint = opHint
        if self.opId == OperationType.Unknown then
            return
        end
        self:OnOperationClicked()
    end)
    -- status
    self:BindEvent(l_mgr.EventDispatcher,l_mgr.COOKING_DOUBLE_REMAIN_TIME,function (self, timeStr)
        self.panel.TxtTimeLeft.LabText = timeStr
    end)
    self:BindEvent(l_mgr.EventDispatcher,l_mgr.COOKING_DOUBLE_FINISHED_COUNT,function (self, count)
        self.panel.TxtMenuFinished.LabText = tostring(count)
    end)
    self:BindEvent(l_mgr.EventDispatcher,l_mgr.COOKING_DOUBLE_FINISHED_SCORE,function (self, score)
        self.panel.Txt_MenuScore.LabText = tostring(score)
    end)


end --func end
--next--
--lua functions end

--lua custom scripts
function CookingDoubleCtrl:CustomInit()
    self.menus = {}
    self.menusMap = {}
    self.opId = 0
    self.objUid = nil
    self.opHint = nil

    self.panel.BtnOperation:AddClick(function ()
        self:OnOperationClicked()
    end)

    local l_menus = MCookingMgr:GetMenus()
    for i = 0, l_menus.Count - 1 do
        local l_menu=l_menus[i]
        self:AddMenu(l_menu.Id, l_menu.Uid, l_menu.RemainTime)
    end

    self.panel.TxtTimeLeft.LabText = "00:00"

    self.panel.TxtMenuFinished.LabText = tostring(MCookingMgr.FinishCount)
    self.panel.Txt_MenuScore.LabText = tostring(MCookingMgr.FinishScore)

    self.panel.BtnClose:AddClick(function ()
        local l_msgId = Network.Define.Ptc.LeaveSceneReq
        ---@type NullArg
        local l_sendInfo = GetProtoBufSendTable("NullArg")
        Network.Handler.SendPtc(l_msgId, l_sendInfo)
    end)

    self.notice_co = nil
    self:PlayStartNotice()
end

function CookingDoubleCtrl:CustomUninit()
    self.menusMap = {}
    self:CloseCoroutine()
end

function CookingDoubleCtrl:AddMenu(menuId, uid, remainTime)
    for i, v in ipairs(self.menus) do
        if v.uid == uid then
            logError("Has Add Before")
            return
        end
    end

    local l_menuRow = TableUtil.GetCookMenuTable().GetRowByID(menuId)
    if l_menuRow then
        local l_menuFoods = l_menuRow.Foods
        local l_menu = {}
        local l_offsetY = self.panel.CookingDoubleMenu.RectTransform.anchoredPosition3D.y
        local l_destX = self.panel.MenuDest.RectTransform.anchoredPosition3D.x
        l_menu.id = menuId
        l_menu.uid = uid
        l_menu.time = remainTime
        l_menu.isUrgent = l_menuRow.MenuType==1
        l_menu.data = l_menuRow
        if l_menu.isUrgent then
            l_menu.obj = self:CloneObj(self.panel.CookingDoubleUrgentMenu.UObj)
        else
            l_menu.obj = self:CloneObj(self.panel.CookingDoubleMenu.UObj)
        end
        l_menu.rectTransform = l_menu.obj:GetComponent("RectTransform")
        l_menu.obj.transform:SetParent(self.panel.CookingDoubleMenu.Transform.parent)
        MLuaCommonHelper.SetLocalPos(l_menu.obj, Screen.width, l_offsetY, 0)
        MLuaCommonHelper.SetLocalScale(l_menu.obj, 1, 1, 1)
        l_menu.obj:SetActiveEx(true)

        l_menu.width = 100 + l_menuFoods.Length * 32
        l_menu.obj:GetComponent('RectTransform').sizeDelta = Vector2.New(l_menu.width, 134)

        l_menu.sliderTime = l_menu.obj.transform:Find("BG2/Slider").gameObject:GetComponent("Slider")
        l_menu.sliderTime.value = remainTime / self:getMenuTotalUseTime(l_menu,menuId)

        l_menu.icons = {}
        local l_iconTmp = l_menu.obj.transform:Find("BG1/Icons/Icon").gameObject
        for i = 0, l_menuFoods.Length - 1 do
            local l_foodRow = TableUtil.GetCookFoodTable().GetRowByID(l_menuFoods[i])
            local l_icon = {}
            l_icon.obj = self:CloneObj(l_iconTmp)
            l_icon.obj.transform:SetParent(l_iconTmp.transform.parent)
            if l_foodRow then
                local l_com = l_icon.obj.transform:GetChild(0):GetComponent("MLuaUICom")
                l_com:SetSprite("Cooking", l_foodRow.Icon, true)
            end
            MLuaCommonHelper.SetLocalScale(l_icon.obj, 1, 1, 1)
            l_icon.obj:SetActiveEx(true)
            l_menu.icons[i + 1] = l_icon
        end
        local l_offsetX = 0
        local l_insertIndex=0
        local l_needInsertMenu = false
        for i,v in ipairs(self.menus) do
            if not l_menu.isUrgent and v.isUrgent then
                l_insertIndex = i
                l_needInsertMenu = true
                break
            end
            l_offsetX  = v.width + l_offsetX
        end
        local l_destPos = Vector3.New(0, l_offsetY, 0)
        if l_needInsertMenu then
            l_destPos.x = l_destX + l_offsetX
            self:insertMenu(l_insertIndex,l_destPos,l_menu)
        else
            l_destPos.x = l_destX + l_offsetX + l_menu.width / 2
            MUITweenHelper.TweenAnchoredPos(l_menu.obj, self.panel.CookingDoubleMenu.RectTransform.anchoredPosition3D, l_destPos, 0.3)
            table.insert(self.menus, l_menu)
        end
    end
end
function CookingDoubleCtrl:insertMenu(insertIndex,insertStartPos,menuData)
    if menuData==nil then
        logError("insertMenu error:menuData is nil!")
        return
    end
    local l_insertPos=Vector3.New(insertStartPos.x,insertStartPos.y,insertStartPos.z)
    l_insertPos.x = l_insertPos.x + menuData.width/2
    MUITweenHelper.TweenAnchoredPos(menuData.obj, menuData.rectTransform.anchoredPosition3D, l_insertPos, 0.3)
    local l_offsetX = menuData.width
    for i = insertIndex, #self.menus do
        local l_moveToPos = Vector3.New(insertStartPos.x,insertStartPos.y,insertStartPos.z)
        local l_menu = self.menus[i]
        l_moveToPos.x = l_moveToPos.x + l_offsetX + l_menu.width / 2
        l_offsetX = l_offsetX + l_menu.width
        MUITweenHelper.TweenAnchoredPos(l_menu.obj, l_menu.rectTransform.anchoredPosition3D, l_moveToPos, 0.3)
    end
    table.insert(self.menus,insertIndex,menuData)
end
function CookingDoubleCtrl:RemoveMenu(menuUid)
    local l_menu = nil
    local l_rmIdx = 0
    for i,v in ipairs(self.menus) do
        if v.uid == menuUid then
            l_menu = v
            l_rmIdx = i
            break
        end
    end

    if l_menu ~= nil then
        if l_menu.obj then
            for i,v in ipairs(l_menu.icons) do

                if v.obj then
                    local l_com = v.obj.transform:GetChild(0):GetComponent("MLuaUICom")
                    l_com:ResetSprite()
                    MResLoader:DestroyObj(v.obj)
                end
            end
            MResLoader:DestroyObj(l_menu.obj)
        end

        local l_destX = self.panel.MenuDest.RectTransform.anchoredPosition3D.x
        local l_offsetX = 0
        for i = 1, l_rmIdx - 1 do
            l_offsetX  = self.menus[i].width + l_offsetX
        end
        local l_offsetY = self.panel.CookingDoubleMenu.RectTransform.anchoredPosition3D.y
        for i= l_rmIdx+1, #self.menus do
            local l_destPos = Vector3.New(l_destX + l_offsetX + self.menus[i].width / 2, l_offsetY, 0)
            MUITweenHelper.TweenAnchoredPos(self.menus[i].obj, self.menus[i].rectTransform.anchoredPosition3D, l_destPos, 0.3)
            l_offsetX = self.menus[i].width + l_offsetX
        end

        table.remove(self.menus, l_rmIdx)
    end
end

function CookingDoubleCtrl:ClearMenus()
    for i,v in ipairs(self.menus) do
        if v.obj then
            for ii,vv in ipairs(v.icons) do
                if vv.obj then
                    local l_com = vv.obj.transform:GetChild(0):GetComponent("MLuaUICom")
                    l_com:ResetSprite()
                    MResLoader:DestroyObj(vv.obj)
                end
            end
            MResLoader:DestroyObj(v.obj)
        end
    end
    self.menus = {}
end
function CookingDoubleCtrl:getMenuByMenuUid(uid)
    local l_menu = nil
    for i,v in ipairs(self.menus) do
        if v.uid == uid then
            l_menu = v
            break
        end
    end
    return l_menu
end
function CookingDoubleCtrl:SetMenuTime(menuUid, time)
    local l_menu = self:getMenuByMenuUid(menuUid)
    if l_menu == nil then
        return
    end
    l_menu.time = time
    l_menu.sliderTime.value = time / self:getMenuTotalUseTime(l_menu,menuUid)
end
function CookingDoubleCtrl:getMenuTotalUseTime(menu,menuUid)
    if menu==nil then
        menu = self:getMenuByMenuUid(menuUid)
    end
    local l_useTime=1 --必须非0
    if menu == nil then
        return l_useTime
    end
    l_useTime = menu.data.TimeLimit

    if l_useTime==0 then
        logError("菜单烹饪时间为0 menuUid:"..tostring(menuUid))
        l_useTime=1
    end
    return l_useTime
end
function CookingDoubleCtrl:OnOperationClicked()
    if not string.ro_isEmpty(self.opHint) then
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(self.opHint)
        return
    end

    local l_msgId = Network.Define.Ptc.CookFoodOperationPtc
    ---@type CookFoodOperationData
    local l_sendInfo = GetProtoBufSendTable("CookFoodOperationData")
    if self.opId > 0 and self.objUid then
        l_sendInfo.trigger_id = tostring(self.objUid)
        local l_op = self.opId
        if l_op == OperationType.Cook then
            l_op = OperationType.Drop
        end
        l_sendInfo.operation = l_op
        Network.Handler.SendPtc(l_msgId, l_sendInfo)
    end
end

function CookingDoubleCtrl:CloseCoroutine()

    if self.notice_co then
        coroutine.stop(self.notice_co)
        self.notice_co = nil
    end
end

function CookingDoubleCtrl:PlayStartNotice()

    if not l_mgr.StartFlag then
        return
    end

    l_mgr.StartFlag = false

    self:CloseCoroutine()

    self.panel.Start.gameObject:SetActiveEx(true)

    self.notice_co = coroutine.start(function()
        coroutine.wait(2)
        self.panel.Start.gameObject:SetActiveEx(false)
        MgrMgr:GetMgr("TipsMgr").ShowImportantNotice(Lang("COOKING_DOUBLE_NOTICE1"))
        coroutine.wait(3)
        MgrMgr:GetMgr("TipsMgr").ClearImportantNotice()
        coroutine.wait(1.5)
        MgrMgr:GetMgr("TipsMgr").ShowImportantNotice(Lang("COOKING_DOUBLE_NOTICE2"))
        coroutine.wait(3)
        MgrMgr:GetMgr("TipsMgr").ClearImportantNotice()
        coroutine.wait(1.5)
        MgrMgr:GetMgr("TipsMgr").ShowImportantNotice(Lang("COOKING_DOUBLE_NOTICE3"))
        coroutine.wait(3)
        MgrMgr:GetMgr("TipsMgr").ClearImportantNotice()
    end)
end


--lua custom scripts end
return CookingDoubleCtrl