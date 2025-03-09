--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/DanmuPanel"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua fields
local super = UI.UIBaseCtrl
--next--
--lua fields end

--lua class define
DanmuCtrl = class("DanmuCtrl", super)
--lua class define end

--lua functions
function DanmuCtrl:ctor()

    super.ctor(self, CtrlNames.Danmu, UILayer.Tips, nil, ActiveType.Standalone)
    self.cacheGrade = EUICacheLv.VeryLow
    self.SceneSize = MUIManager.UIRoot.transform.sizeDelta
    self.SceneSize.x = self.SceneSize.x / 2
    self.SceneSize.y = self.SceneSize.y / 2
    self.DefaultLineNum = 2

end --func end
--next--
function DanmuCtrl:Init()

    self.panel = UI.DanmuPanel.Bind(self)
    super.Init(self)

    self.channelEnum = DataMgr:GetData("ChatData").EChannel
    self.allowWatchChat = MgrMgr:GetMgr("WatchWarMgr").GetSpectatorCharStatus()

    self.DanmuList = {}
    --当前帧的弹幕
    self.DanmuMsgList = {}

end --func end
--next--
function DanmuCtrl:Uninit()

    self.channelEnum = nil
    self.allowWatchChat = nil

    super.Uninit(self)
    self.panel = nil

end --func end
--next--
function DanmuCtrl:OnActive()


end --func end
--next--
function DanmuCtrl:OnDeActive()


end --func end
--next--
function DanmuCtrl:Update()

    self.CurrentLineNum = 0
    if self.DanmuMsgList ~= nil then
        for k, msg in pairs(self.DanmuMsgList) do
            if msg.channel == self.channelEnum.TeamChat and msg.showDanmu then
                local l_danmu = self:CreateDanmu(msg)
            elseif msg.channel == self.channelEnum.WatchChat and self.allowWatchChat then
                self:CreateDanmu(msg)
            elseif msg.subtitlesSend then
                --TODO:徐波说先用这个颜色;
                local l_target = {}
                l_target.playerInfo = msg.playerInfo
                l_target.AudioObj = msg.AudioObj
                l_target.content = GetColorText(msg.content, RoColorTag.Yellow)
                local l_danmu = self:CreateDanmu(l_target)
            end
        end
    end
    self:UpdateDanmu()
    self.DanmuMsgList = {}
    self.CurrentLineNum = 0

end --func end

--next--
function DanmuCtrl:OnLogout()

    if self.DanmuList ~= nil then
        local l_count = #self.DanmuList
        for i = l_count, 1, -1 do
            local l_danmu = self.DanmuList[i]
            MResLoader:DestroyObj(l_danmu.gameObject)
        end
        self.DanmuList = {}
    end
    self.DanmuMsgList = {}

end --func end
--next--
function DanmuCtrl:BindEvents()

    local l_logoutMgr = MgrMgr:GetMgr("LogoutMgr")
    self:BindEvent(l_logoutMgr.EventDispatcher,l_logoutMgr.OnLogoutEvent, self.OnLogout)

    --监听聊天事件
    self:BindEvent(GlobalEventBus,EventConst.Names.NewChatMsg,function(self, msg)
        self.OnNewChatMsg(self, msg)
    end)

    local l_watchWarMgr = MgrMgr:GetMgr("WatchWarMgr")
    self:BindEvent(l_watchWarMgr.EventDispatcher, l_watchWarMgr.ON_SPECTATOR_WATCH_CHAT_STUTAS, self.OnSpectatorWatchCharStatus)
end --func end

--next--
--lua functions end

--lua custom scripts
------------------------弹幕----------------------------------

-- todo 弹幕测试数据
-- todo 弹幕数据是用这个格式进行解析的
---@class BulletScreenData
local l_testData = {
    showDanmu = true,
    content = '恭喜<color=$$Blue$$>剑士丶希拉尔</color>幸运地获得了[li]，又是运气满满的一天呢(>▽<)',
    Param = {
        [1] = { type = 1,
                showInfo = { count = 0 },
                param64 = { [1] = { value = '0' } },
                param32 = { [2] = { value = 0 }, [1] = { value = 10130501 } },
        } },
    showInMainChat = true,
    isSelf = false,
    channel = 2,
    subType = '队伍',
    lineType = 3,
    fontSize = nil,
}

--创建弹幕
---@param msgPack BulletScreenData
function DanmuCtrl:CreateDanmu(msgPack)
    local l_instance = self.panel.TextDanmuInstance
    local l_content = msgPack.content
    local l_fontSize = l_instance.transform:Find("text").gameObject:GetComponent("Text").fontSize
    msgPack.fontSize = l_fontSize

    --动态表情替换
    l_content = MoonClient.DynamicEmojHelp.ReplaceInputTextEmojiContent(l_content)
    --道具链接替换
    l_content = MgrMgr:GetMgr("LinkInputMgr").PackToTag(l_content, msgPack.Param, false, nil, msgPack.fontSize)
    go = self:CloneObj(l_instance.gameObject)

    LayoutRebuilder.ForceRebuildLayoutImmediate(go.transform)

    go.transform.anchorMin = Vector2.New(0.5, 0.5)
    go.transform.anchorMax = go.transform.anchorMin
    go.transform:SetParent(self.panel.Container.transform)
    go.transform:SetLocalScaleOne()
    go:SetRectTransformPos(self.SceneSize.x, 10000)
    go:SetActiveEx(true)

    local l_danmu = {}
    l_danmu.gameObject = go
    l_danmu.transform = go.transform
    l_danmu.com = go:GetComponent("MLuaUICom")
    l_danmu.text = go.transform:Find("text").gameObject:GetComponent("Text")
    if msgPack.playerInfo then
        if msgPack.AudioObj ~= nil then
            l_content = msgPack.playerInfo.name .. GetImageText("Ui_Chat_Play1.png", "Common", 30, 2) .. l_content
        else
            l_content = msgPack.playerInfo.name .. ":" .. l_content
        end
    else
        if msgPack.AudioObj ~= nil then
            l_content = GetImageText("Ui_Chat_Play1.png", "Common", 30, 2) .. l_content
        end
    end
    local l_luaCom = MLuaClientHelper.GetOrCreateMLuaUICom(l_danmu.text.gameObject)
    l_luaCom.LabText = l_content
    l_danmu.text.gameObject:SetRectTransformPos(l_danmu.text.transform.sizeDelta.x / 2, 0)
    l_danmu.text.PopulateMeshAct = function()
        l_danmu.text.PopulateMeshAct = nil
        l_danmu.text.gameObject:SetRectTransformPos(l_danmu.text.transform.sizeDelta.x / 2, 0)
    end

    l_danmu.line = 0
    self.DanmuList[#self.DanmuList + 1] = l_danmu

    --从第三行开始显示
    self:ChangeDanmuY(l_danmu, self.CurrentLineNum + 1)
end

function DanmuCtrl:ChangeDanmuY(danmu, line)
    local l_goPos = danmu.transform.anchoredPosition
    local l_danmuCount = #self.DanmuList

    for i = 1, l_danmuCount do
        local l_danmu = self.DanmuList[i]
        if l_danmu ~= danmu and l_danmu.line == line then
            local l_width = l_danmu.text.transform.sizeDelta.x
            if l_width + l_danmu.transform.localPosition.x > l_goPos.x then
                self:ChangeDanmuY(danmu, line + 1)
                return
            end
        end
    end

    danmu.line = line
    danmu.gameObject:SetRectTransformPos(l_goPos.x, self.SceneSize.y - 100 - line * 40)
    self.CurrentLineNum = line
end

--更新弹幕
function DanmuCtrl:UpdateDanmu()

    if self.panel == nil then
        return
    end

    for i = #self.DanmuList, 1, -1 do
        local l_danmu = self.DanmuList[i]
        if l_danmu.gameObject.activeSelf then
            local l_currentPos = l_danmu.transform.anchoredPosition
            l_danmu.gameObject:SetRectTransformPos(l_currentPos.x - (120 * Time.deltaTime), l_currentPos.y)
            l_danmu.text.gameObject:SetRectTransformPos(l_danmu.text.transform.sizeDelta.x / 2, 0)

            --超出范围回收
            if l_danmu.gameObject.transform.localPosition.x < -self.SceneSize.x - l_danmu.text.transform.sizeDelta.x - 10 then
                l_danmu.text.PopulateMeshAct = nil
                MResLoader:DestroyObj(l_danmu.gameObject)
                table.remove(self.DanmuList, i)
            end
        end
    end

end

--清理释放弹幕
function DanmuCtrl:ReleaseDanmu(sceneId)

    --如果切换的场景不需要显示弹幕 则弹幕直接卡掉 防止切回有弹幕场景继续播放
    local l_isNeedClear = true
    local sceneRow = TableUtil.GetSceneTable().GetRowByID(sceneId, true)
    if sceneRow then
        local mainUiRow = TableUtil.GetMainUiTable().GetRowById(sceneRow.SceneUiId)
        if mainUiRow then
            for i = 0, mainUiRow.MainLuaUi.Count - 1 do
                if mainUiRow.MainLuaUi[i] == self.name then
                    --如果本场景的展示UI中包含弹幕 则不清理
                    l_isNeedClear = false
                    break
                end
            end
        end
    end

    if l_isNeedClear then
        for i = #self.DanmuList, 1, -1 do
            local l_danmu = self.DanmuList[i]
            if l_danmu.gameObject.activeSelf then
                l_danmu.text.PopulateMeshAct = nil
                MResLoader:DestroyObj(l_danmu.gameObject)
                table.remove(self.DanmuList, i)
            end
        end

        self.DanmuList = {}
        self.DanmuMsgList = {}
    end

end

------------------------弹幕----------------------------------
------------------------事件处理------------------------------

--当收到信消息的时候
function DanmuCtrl:OnNewChatMsg(msg)
    
    self.DanmuMsgList[#self.DanmuMsgList + 1] = msg
end

function DanmuCtrl:OnSpectatorWatchCharStatus()

    self.allowWatchChat = MgrMgr:GetMgr("WatchWarMgr").GetSpectatorCharStatus()
end

------------------------事件处理------------------------------
--lua custom scripts end
return DanmuCtrl