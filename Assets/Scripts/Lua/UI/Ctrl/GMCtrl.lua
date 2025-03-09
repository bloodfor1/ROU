--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/GMPanel"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua fields
local super = UI.UIBaseCtrl
--next--
--lua fields end

--lua class define
GMCtrl = class("GMCtrl", super)
--lua class define end

--lua functions
function GMCtrl:ctor()
    super.ctor(self, CtrlNames.GM, UILayer.Function, nil, ActiveType.Standalone)
end --func end
--next--
function GMCtrl:Init()
    self.panel = UI.GMPanel.Bind(self)
    self.canvasGroup = self.uObj:GetComponent("CanvasGroup")
    self.panel.InputTextCommand.Input.text = Common.Serialization.LoadData("GM_LAST_COMMAND", Common.Utils.Long2Num(MPlayerInfo.UID))
    super.Init(self)
    MgrMgr:GetMgr("MapInfoMgr").ShowMapPanel(false)
    self.panel.ButtonPrefab.gameObject:SetActiveEx(false)
    self.panel.BtnBaseLv:AddClick(function()
        local l_lv = self.panel.InputBaseLv.Input.text
        MgrMgr:GetMgr("GmMgr").SendCommand(StringEx.Format("baselevel {0}", tostring(l_lv)))
    end)
    self.panel.BtnBaseExp:AddClick(function()
        local l_exp = self.panel.InputBaseExp.Input.text
        MgrMgr:GetMgr("GmMgr").SendCommand(StringEx.Format("addexp {0}", tostring(l_exp)))
    end)
    self.panel.BtnJobLv:AddClick(function()
        local l_lv = self.panel.InputJobLv.Input.text
        MgrMgr:GetMgr("GmMgr").SendCommand(StringEx.Format("joblevel {0}", tostring(l_lv)))
    end)
    self.panel.BtnJobExp:AddClick(function()
        local l_exp = self.panel.InputJobExp.Input.text
        MgrMgr:GetMgr("GmMgr").SendCommand(StringEx.Format("addjobexp {0}", tostring(l_exp)))
    end)
    self.panel.BtnClose:AddClick(function()
        UIMgr:DeActiveUI(UI.CtrlNames.GM)
    end)
    self.panel.QualitySettingPanelBtn:AddClick(function()
        UIMgr:ActiveUI(UI.CtrlNames.PictureQualitySetting)
    end)
    self.panel.EnvironWeatherGMPanelBtn:AddClick(function()
        UIMgr:ActiveUI(UI.CtrlNames.GMEnvironWeather)
    end)
    self.panel.SetObjActiveBtn:AddClick(function()
        UIMgr:ActiveUI(UI.CtrlNames.ActiveSettingPanel)
    end)
    self.panel.DoShowReporterGuiBtn:AddClick(function()
        Reporter.Instance:DoShow()
        Reporter.Instance.gameObject:SetActiveEx(true)
    end)
    self.panel.OpenMainButtonBtn:AddClick(function()
        local mainCtrl = UIMgr:GetUI(UI.CtrlNames.Main)
        if mainCtrl then
            for i, id in pairs(MgrMgr:GetMgr("OpenSystemMgr").eSystemId) do
                local button = mainCtrl:GetButton(id)
                if button and button.SetGameObjectActive then
                    button:SetGameObjectActive(true)
                end
            end
        end
    end)
    self.panel.TextCommandBtn:AddClick(function()
        local command_text = self.panel.InputTextCommand.Input.text
        log("[LocalGMCmd]" .. tostring(command_text))
        local l_info = tostring(command_text)
        if IsEmptyOrNil(l_info) then
            return
        end
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(l_info)
        if self:ExecuteClientCommond(l_info) then
            return ;
        end
        MgrMgr:GetMgr("GmMgr").SendCommand(command_text)
        local lower_text = string.lower(command_text)
        if string.find(lower_text, "settime") then
            MgrMgr:GetMgr("DailyTaskMgr").RequestSyncServerTime()
        end
        Common.Serialization.StoreData("GM_LAST_COMMAND", self.panel.InputTextCommand.Input.text, Common.Utils.Long2Num(MPlayerInfo.UID))
        self:InsertNewKey(command_text)
    end)
    self.panel.Btn_Profession:AddClick(function()
        UIMgr:ActiveUI(UI.CtrlNames.Profession)
    end)
    self.panel.BtnCookingTest:AddClick(function()
        UIMgr:DeActiveUI(self.name)
        UIMgr:ActiveUI(UI.CtrlNames.CookingSingle)
    end)
    self.panel.DoDumpLogCatBtn:AddClick(function()
        if MGameContext.IsAndroid then
            logGreen("!!!!!!!!!!!!!!!!!!!!! DumpLogcat")
            MDevice.DumpLogcat()
        end
    end)
    self:addButton("获取客户端时间", function()
        local time = MServerTimeMgr.ServerTime
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(tostring(time) .. " " .. tostring(time.DayOfWeek))
    end)
    self:addButton("查看当前开启的功能", function()
        for i = 1, #MgrMgr:GetMgr("OpenSystemMgr").OpenSystem do
            logGreen("开启的功能：" .. tostring(MgrMgr:GetMgr("OpenSystemMgr").OpenSystem[i]))
        end
    end)
    self:addButton("便捷测试", function()
        self.panel.TempTestBg:SetActiveEx(true)
    end)
    self:addButton("Mono堆增加10M", function()
        MDevice.AllocMonoHeap(CJson.encode({ size = 10 }))
    end)
    self:addButton("Mono堆增加100M", function()
        MDevice.AllocMonoHeap(CJson.encode({ size = 100 }))
    end)
    self:addButton("Java堆增加10M", function()
        MDevice.AllocJavaHeap(CJson.encode({ size = 10 }))
    end)
    self:addButton("Java堆增加100M", function()
        MDevice.AllocJavaHeap(CJson.encode({ size = 100 }))
    end)
    self:addButton("开启所有功能，客户端假数据", function()
        local l_info = {}
        l_info.noticesys_ids = {}
        l_info.closesys_ids = {}
        l_info.opensys_ids = {}
        local l_mgr = MgrMgr:GetMgr("OpenSystemMgr")
        for i, id in pairs(l_mgr.eSystemId) do
            local l_open = {}
            l_open.value = id
            table.insert(l_info.opensys_ids, l_open)
        end
        l_mgr.SetOpenSystemInfo(l_info)
    end)

    self:addButton("客户端测试使用，开启某个功能", function()
        local l_info = {}
        l_info.noticesys_ids = {}
        l_info.closesys_ids = {}
        l_info.opensys_ids = {}
        local l_mgr = MgrMgr:GetMgr("OpenSystemMgr")
        local command_text = self.panel.InputTextCommand.Input.text
        local l_id=tonumber(command_text)
        local l_open = {}
        l_open.value = l_id
        table.insert(l_info.opensys_ids, l_open)
        l_mgr.SetOpenSystemInfo(l_info)
    end)

    self:addButton("设置拖拽灵敏度,现在默认是10", function()
        local commandText = self.panel.InputTextCommand.Input.text
        local pixelDragThreshold=tonumber(commandText)
        if pixelDragThreshold == nil then
            return
        end
        MUIManager:SetPixelDragThreshold(pixelDragThreshold)
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips("设置完成")
    end)

    self.panel.BtnPayTest:AddClick(function()
        UIMgr:ActiveUI(CtrlNames.GMPay)
    end)
    self.panel.AlphaSlider:OnSliderChange(function(a)
        self.canvasGroup.alpha = a
        if a < 0.1 then
            self.panel.BG.gameObject:SetActiveEx(false)
        else
            self.panel.BG.gameObject:SetActiveEx(true)
        end
    end)
    self.panel.serverTimeBtn:AddClick(function()
        MgrMgr:GetMgr("DailyTaskMgr").RequestSyncServerTime()
    end)
    self.timer = self:NewUITimer(function()
        if not self.panel then
            return
        end
        local time = MServerTimeMgr.ServerTime
        local serverLevel = tonumber(MgrMgr:GetMgr("RoleInfoMgr").SeverLevelData.serverlevel)
        self.panel.ServerTimeTxt.LabText = tostring(os.date("!%Y-%m-%d-%H-%M-%S",
                Common.TimeMgr.GetLocalNowTimestamp())) .. " " .. tostring(time.DayOfWeek) .. " 服务器等级:" .. tostring(serverLevel)
    end, 1, -1)
    self.timer:Start()
    --设置时间Button处理
    self.panel.serverTimeSettingBtn:AddClick(function()
        self.panel.InputTextCommand.Input.text = "settime " .. os.date("!%Y %m %d %H %M %S", Common.TimeMgr.GetLocalNowTimestamp())
    end)
    -- test lua
    self.panel.BtnTestLua:AddClick(function()
        g_Globals.DEBUG_NETWORK = true
        self.panel.TestLua:SetActiveEx(true)
    end)
    self.panel.BtnCloseTestLua:AddClick(function()
        g_Globals.DEBUG_NETWORK = false
        self.panel.TestLua:SetActiveEx(false)
    end)
    self.panel.BtnRPCExam:AddClick(function()
        self.panel.InputTestLua.Input.text = MgrMgr:GetMgr("GmMgr").GetRPCExam()
    end)
    self.panel.BtnPtcExam:AddClick(function()
        self.panel.InputTestLua.Input.text = MgrMgr:GetMgr("GmMgr").GetPtcExam()
    end)
    self.panel.BtnUIExam:AddClick(function()
        self.panel.InputTestLua.Input.text = MgrMgr:GetMgr("GmMgr").GetUIExam()
    end)
    self.panel.BtnExcuteLua:AddClick(function()
        MLuaClientHelper.DoLuaString(self.panel.InputTestLua.Input.text)
    end)
    self.panel.Btn_luahotreload:AddClick(function()
        HU.Open()
    end)
    self.panel.ButtonOpenHttp:AddClick(function()
        -- 开启httpserver
        local l_port, l_tips = 8008, nil
        if not MoonClient.GM.MProtocolHSGM.StartHttpServer(l_port) then
            l_tips = "start httpserver http://127.0.0.1:" .. tostring(l_port)
                    .. " failed，please makesure your port is valid and free, otherwise contact with tmgege!!!"
        else
            l_tips = "start httpserver at http://127.0.0.1:" .. tostring(l_port) .. " success"
        end
        self:ShowGMInfo(l_tips)
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(l_tips)
    end)
    self.panel.ButtonCloseHttp:AddClick(function()
        -- 关闭httpserver
        MoonClient.GM.MProtocolHSGM.CloseHttpServer()
        local l_tips = "close httpserver success"
        self:ShowGMInfo(l_tips)
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(l_tips)
    end)
    self.panel.ButtonAddListen:AddClick(function()
        local l_tips = nil
        local l_protoId = tonumber(self.panel.TextListener.Input.text) or nil
        if l_protoId == nil then
            l_tips = "please enter valid numbers for protocol id!!!"
        else
            MoonClient.GM.MProtocolHSGM.AddWaitResponse(l_protoId)
            l_tips = "listenmsg by protoId:" .. tostring(l_protoId) .. " success"
        end
        self:ShowGMInfo(l_tips)
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(l_tips)
    end)
    self.panel.ButtonClearListen:AddClick(function()
        MoonClient.GM.MProtocolHSGM.ClearWaitResponse()
        local l_tips = "clearlistenmsg success"
        self:ShowGMInfo(l_tips)
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(l_tips)
    end)
    self.panel.UIAutoTest:AddClick(function()
        UIMgr:DeActiveUI(UI.CtrlNames.GM)
        local l_uiAuto = UIAutoTest.AddToGo()
        l_uiAuto:StartAutoTest()
    end)
    self.panel.UIAutoRandomTest:AddClick(function()
        UIMgr:DeActiveUI(UI.CtrlNames.GM)
        local l_uiAuto = UIAutoTest.AddToGo()
        l_uiAuto:StartRandomAutoTest()
    end)
    self.panel.BtnDps:AddClick(function()
        UIMgr:DeActiveUI(UI.CtrlNames.GM)
        MgrMgr:GetMgr("TipsMgr").ShowNormalTips("Dps Open")
        MgrMgr:GetMgr("GmMgr").SendCommand("dps")
    end)

    self.historyData = {}
    self.panel.DropdownHistory.DropDown.onValueChanged:AddListener(function(index)
        local l_str = self.historyData[index + 1]
        if l_str and string.len(l_str) > 0 then
            self.panel.InputTextCommand.Input.text = l_str
        end
    end)
    self:RefreshGMHistory()

    -- test lua end
    self:initTempTestPanel()


    -- 初始化快速建号
    self:InitFastCreateRole()
end --func end
--next--
function GMCtrl:Uninit()
    if self.timer then
        self:StopUITimer(self.timer)
        self.timer = nil
    end

    super.Uninit(self)
    self.panel = nil
end --func end
--next--
function GMCtrl:OnActive()

end --func end
--next--
function GMCtrl:OnDeActive()

    g_Globals.DEBUG_NETWORK = false
    self.panel.TestLua:SetActiveEx(false)
    self.TempTestPool = nil
    if self.updateInputFTimer ~= nil then
        self:StopUITimer(self.updateInputFTimer)
        self.updateInputFTimer = nil
    end

end --func end
--next--
function GMCtrl:Update()


end --func end
--next--
function GMCtrl:BindEvents()

end --func end
--next--
function GMCtrl:Show(withTween)

    if not super.Show(self, withTween) then
        return
    end

end --func end
--next--
function GMCtrl:Hide(withTween)

    if not super.Hide(self, withTween) then
        return
    end

end --func end

--next--
--lua functions end

--lua custom scripts

-- 初始化快速建号
function GMCtrl:InitFastCreateRole()
    self.payLvShowText = {
        [1] = "非R",
        [2] = "小R",
        [3] = "中R",
        [4] = "大R"
    }
    self.convenientAccountInfos = {}
    for _, v in pairs(TableUtil.GetConvenientAccountTable().GetTable()) do
        if not self.convenientAccountInfos[v.Profession] then
            self.convenientAccountInfos[v.Profession] = {}
            -- 用于排序，保证表前面的流派排序在前面
            self.convenientAccountInfos[v.Profession].sortId = v.ID
            self.convenientAccountInfos[v.Profession].name = v.Professiontext
            self.convenientAccountInfos[v.Profession].payLvInfos = {}
        end
        if not self.convenientAccountInfos[v.Profession].payLvInfos[v.Paylv] then
            self.convenientAccountInfos[v.Profession].payLvInfos[v.Paylv] = {}
            self.convenientAccountInfos[v.Profession].payLvInfos[v.Paylv].payLv = v.Paylv
            self.convenientAccountInfos[v.Profession].payLvInfos[v.Paylv].lvLimits = {}
        end
        -- 用于映射查询到表id
        table.insert(self.convenientAccountInfos[v.Profession].payLvInfos[v.Paylv].lvLimits, { lvMin = v.Lvmin, lvMax = v.Lvmax, id = v.ID })
    end

    -- 显示用数据
    self.convenientAccountInfoForShow = {}
    for _, v in pairs(self.convenientAccountInfos) do
        table.insert(self.convenientAccountInfoForShow, v)
        -- 用于显示
        v.payLvInfosForShow = {}
        for _, payLvInfo in pairs(v.payLvInfos) do
            table.insert(v.payLvInfosForShow, payLvInfo)
        end
        table.sort(v.payLvInfosForShow, function(a, b)
            return a.payLv < b.payLv
        end)
    end
    table.sort(self.convenientAccountInfoForShow, function(a, b)
        return a.sortId < b.sortId
    end)

    local l_schoolDropStrs = {}
    for _, v in ipairs(self.convenientAccountInfoForShow) do
        table.insert(l_schoolDropStrs, v.name)
    end

    self.panel.SchoolDrop.DropDown:ClearOptions()
    self.panel.SchoolDrop:SetDropdownOptions(l_schoolDropStrs)
    local l_onValueChanged = function(index)
        local l_accountInfo = self.convenientAccountInfoForShow[index + 1]
        local l_modelDropStrs = {}
        for _, v in ipairs(l_accountInfo.payLvInfosForShow) do
            table.insert(l_modelDropStrs, self.payLvShowText[v.payLv])
        end

        self.panel.ModelDrop.DropDown:ClearOptions()
        self.panel.ModelDrop:SetDropdownOptions(l_modelDropStrs)
    end

    -- 初始化
    l_onValueChanged(0)
    self.panel.SchoolDrop.DropDown.onValueChanged:AddListener(l_onValueChanged)
    self.panel.FastCreateBtn:AddClick(function()
        local l_tableId = nil
        local l_baseLv = tonumber(self.panel.RoleLvInput.Input.text)
        if not l_baseLv then
            self:ShowGMInfo("Failed, 等级输入非法！！！")
            return
        end
        local l_schoolIndex = self.panel.SchoolDrop.DropDown.value + 1
        local l_modelIndex = self.panel.ModelDrop.DropDown.value + 1
        local l_lvLimits = self.convenientAccountInfoForShow[l_schoolIndex].payLvInfosForShow[l_modelIndex].lvLimits
        for _, v in ipairs(l_lvLimits) do
            if l_baseLv >= v.lvMin and l_baseLv <= v.lvMax then
                l_tableId = v.id
                break
            end
        end
        if l_tableId then
            -- createrole id level
            MgrMgr:GetMgr("GmMgr").SendCommand(StringEx.Format("createrole {0} {1}", l_tableId, l_baseLv))
        else
            self:ShowGMInfo("Failed, ConvenientAccountTable表中无对应数据！！！")
        end
    end)
end

function GMCtrl:addButton(name, method)
    local gameObject = self:CloneObj(self.panel.ButtonPrefab.gameObject, false)
    gameObject:SetActiveEx(true)
    gameObject.transform:SetParent(self.panel.ButtonParent.transform, false)

    local text = gameObject.transform:Find("Text"):GetComponent("MLuaUICom")
    text.LabText = name

    local button = gameObject:GetComponent("MLuaUICom")
    button:AddClick(method)
end

function GMCtrl:ExecuteClientCommond(info)
    if string.sub(info, 1, 2) == "sg" then
        MgrMgr:GetMgr("SmallGameMgr").ShowSmallGameByID(tonumber(string.sub(info, 3, -1)))
        return true
    end

    return false
end

--在面板上显示信息
function GMCtrl:ShowGMInfo(msg)
    self.panel.InputInfo.Input.text = msg
end

--==============================--
--@Description: 根据道具类型获取所有的道具
--@Date: 2018/8/23
--@Param: [args]
--@Return:
--==============================--
function GMCtrl:getItemByTypeTab(itemType)
    local ids = array.filter(TableUtil.GetItemTable().GetTable(), function(v)
        if v.TypeTab == itemType then
            return v.ItemID
        end
    end)
    for i, v in ipairs(ids) do
        MgrMgr:GetMgr("GmMgr").SendCommand(StringEx.Format("{0} 1", v))
    end
end

--==============================--
--@Description: 根据道具Subclass类型获取所有道具
--@Date: 2018/8/23
--@Param: [args]
--@Return:
--==============================--
function GMCtrl:getItemByItemType(itemSubclass)
    local ids = array.filter(TableUtil.GetItemTable().GetTable(), function(v)
        if v.Subclass == itemSubclass then
            return v.ItemID
        end
    end)
    for i, v in ipairs(ids) do
        MgrMgr:GetMgr("GmMgr").SendCommand(StringEx.Format("{0} 1", v))
    end
end

--==============================--
--@Description: 获取一套可以穿的装备
--@Date: 2018/8/27
--@Param: [args] forgeSecction 锻造区间
--@Return:
--==============================--
function GMCtrl:getEquipsByLv(forgeSection)
    forgeSection = forgeSection or 5
    local equipDatas = MgrMgr:GetMgr("ForgeMgr").GetEquips(forgeSection)
    local ids = array.map(equipDatas, function(v)
        return v.Id
    end)

    for i, v in ipairs(ids) do
        MgrMgr:GetMgr("GmMgr").SendCommand(StringEx.Format("{0} 1", v))
    end

    local magnifyingGlass = 3020021
    MgrMgr:GetMgr("GmMgr").SendCommand(StringEx.Format("{0} 99", magnifyingGlass))
end
function GMCtrl:initTempTestPanel(forgeSection)
    self.panel.Btn_Close:AddClick(function()
        self.panel.TempTestBg:SetActiveEx(false)
    end, true)
    self.panel.Btn_ClearTotalInfo:AddClick(function()
        self.panel.Input_TotalMsg.Input.text = ""
    end, true)
    self.TempTestPool = self:NewTemplatePool({
        TemplateClassName = "TestFuncTemplate",
        ScrollRect = self.panel.MsgShowScroll.LoopScroll,
        TemplatePrefab = self.panel.Btn_TestFuncTemplate.gameObject,
    })

    self.TempTestPool:ShowTemplates({ Datas = MgrMgr:GetMgr("GmMgr").GetTestFuncData() })
end

function GMCtrl:AddTempTestInfo(msg)
    if not self:IsShowing() or msg == nil then
        return
    end

    local l_totalMsg = self.panel.Input_TotalMsg.Input.text .. "\n" .. tostring(msg)
    self.panel.Input_TotalMsg.Input.text = l_totalMsg
    self.panel.Input_NewMsg.Input.text = msg
    EventSystem.current:SetSelectedGameObject(self.panel.Input_TotalMsg.UObj)
    local l_updateInputFunc = function()
        self.panel.Input_TotalMsg.Input:MoveTextEnd(false)
    end

    if self.updateInputFTimer ~= nil then
        self.updateInputFTimer:Reset(l_updateInputFunc, 0.001, 1, true)
    else
        self.updateInputFTimer = self:NewUITimer(l_updateInputFunc, 0.001, 1, true)
    end

    self.updateInputFTimer:Start()
end

function GMCtrl:InsertNewKey(key, notNeedSet)
    if string.len(key) <= 0 then
        return
    end

    local l_find = false
    local l_findIndex = 1
    for i, v in ipairs(self.historyData) do
        if v == key then
            l_find = true
            l_findIndex = i
            break
        end
    end

    if not l_find then
        table.insert(self.historyData, 1, key)
    else
        for i = l_findIndex, 2, -1 do
            self.historyData[i] = self.historyData[i - 1]
        end
        self.historyData[1] = key
    end

    if #self.historyData > 10 then
        table.remove(self.historyData, #self.historyData)
    end

    local l_ret = table.concat(self.historyData, "#")
    Common.Serialization.StoreData("GM_HISTORY_COMMAND", l_ret, 0)
    if notNeedSet then
        return
    end

    self.panel.DropdownHistory.DropDown:ClearOptions()
    self.panel.DropdownHistory:SetDropdownOptions(self.historyData)
    self.panel.DropdownHistory.DropDown.value = 0
end

function GMCtrl:RefreshGMHistory()
    self.historyData = {}
    self.panel.DropdownHistory.DropDown:ClearOptions()
    local l_str = Common.Serialization.LoadData("GM_HISTORY_COMMAND", 0) or ""
    local l_keys = string.ro_split(l_str, "#")
    for i = #l_keys, 1, -1 do
        self:InsertNewKey(l_keys[i], true)
    end

    self.panel.DropdownHistory.DropDown:ClearOptions()
    self.panel.DropdownHistory:SetDropdownOptions(self.historyData)
end

--lua custom scripts end
return GMCtrl