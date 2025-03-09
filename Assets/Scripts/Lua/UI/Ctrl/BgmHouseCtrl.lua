--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/BgmHousePanel"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua fields
local super = UI.UIBaseCtrl
--next--
--lua fields end

--lua class define
BgmHouseCtrl = class("BgmHouseCtrl", super)
--lua class define end

--lua functions
function BgmHouseCtrl:ctor()

    super.ctor(self, CtrlNames.BgmHouse, UILayer.Function, nil, ActiveType.Exclusive)
    self.idArr = {}
    self.scrollRect = nil
    self.bgmItems = {}
    self.currentIndex = 0
    self.currentPlayingItem = nil
    self.originBGMPath = nil
    self.stopBGMTimer = nil

end --func end
--next--
function BgmHouseCtrl:Init()

    self.panel = UI.BgmHousePanel.Bind(self)
    super.Init(self)
    self.panel.BtnClose:AddClick(function()
        self:OnClose()
    end)
    self.panel.BtnNext:AddClick(function()
        self:OnNext()
    end)
    self.panel.BtnLast:AddClick(function()
        self:OnLast()
    end)
    self.panel.BtnPlay:AddClick(function()
        self:OnPlay()
    end)
    self.panel.BtnStop:AddClick(function()
        self:OnStop()
    end)
    self.panel.BtnStop.gameObject:SetActiveEx(false)

end --func end
--next--
function BgmHouseCtrl:Uninit()

    super.Uninit(self)
    self.panel = nil
    if self.scrollRect then
        self.scrollRect.OnStartDrag=nil
        self.scrollRect.OnEndDrag=nil
        self.scrollRect.OnItemIndexChanged=nil
        self.scrollRect.onInitItem=nil
        self.scrollRect=nil
    end
    self.bgmItems = {}
    self.currentPlayingItem = nil

end --func end
--next--
function BgmHouseCtrl:OnActive()


end --func end
--next--
function BgmHouseCtrl:OnDeActive()

    if self.originBGMPath ~= nil and not self.playing then
        MAudioMgr:PlayBGM(self.originBGMPath)
        self.originBGMPath = nil
    end

end --func end
--next--
function BgmHouseCtrl:Update()
    if self.currentPlayingItem ~= nil and self.currentPlayingItem.tran ~= nil then
        local currentZ = self.currentPlayingItem.tran.eulerAngles.z
        self.currentPlayingItem.tran:SetRotEulerZ(currentZ + 1)
    end
end --func end

--next--
function BgmHouseCtrl:BindEvents()


end --func end

--next--
--lua functions end

--lua custom scripts

function BgmHouseCtrl:InitWithBGMId(idArr)

    --BGM列表是否改变了
    local l_listChanged = false
    if self.idArr ~= nil then
        if #idArr ~= #self.idArr then
            l_listChanged = true
        else
            for i, v in ipairs(idArr) do
                if v ~= self.idArr[i] then
                    l_listChanged = true
                    break
                end
            end
        end
    else
        l_listChanged = true
    end

    self.idArr = idArr
    self.scrollRect = self.panel.ScrollView.gameObject:GetComponent("MoonClient.MRingScrollRect")

    self.scrollRect.OnStartDrag = function()

    end

    self.scrollRect.OnEndDrag = function()
        self:SetIndex(self.scrollRect.CurIndex, false)
    end
    self.bgmItems = {}
    self.scrollRect.onInitItem = function(go, index)
        local l_id = self.idArr[index + 1]
        local l_tran = go.transform:Find("ImageCD")
        local l_com = l_tran:GetComponent("MLuaUICom")
        local l_row = TableUtil.GetBGMHouseTable().GetRowById(l_id)
        if l_row == nil then
            return
        end
        self.bgmItems[index] = {
            index = index,
            bgmId = l_id,
            com = l_com,
            row = l_row,
            tran = l_tran
        }

        l_com:SetSprite(l_row.CoverAtlas, l_row.CoverSprite)
        l_com:AddClick(function()
            self:SetIndex(index, true)
        end)
    end

    self.scrollRect:SetCount(#self.idArr)

    if l_listChanged then
        self.currentIndex = 0
    end

    if self.playing then
        --播放列表改变则直接关闭
        if l_listChanged then
            self:SetIndex(0, true)
            self:OnStop()
        else
            self.currentPlayingItem = self.bgmItems[self.currentIndex]
            self.panel.BtnStop.gameObject:SetActiveEx(true)
            self:SetIndex(self.currentIndex, true, false)
        end
    else
        self:SetIndex(0, true)
    end

    -- todo 917 版本异常，这边会报空指针，可能空指针是因为BGM没找到，所以需要配合其他log查看
    -- todo 疑似由于异步加载导致的生命周期问题
    if not self.playing then
        local cs_obj_bgm_inst = MAudioMgr:GetBGMInstance()
        if nil == cs_obj_bgm_inst then
            logError("[BGMHouse] bgm inst is nil, plis check cs log")
            self.originBGMPath = nil
            MAudioMgr:StopBGM()
            return
        end

        self.originBGMPath = cs_obj_bgm_inst:getPath()
        MAudioMgr:StopBGM()
    end
end

function BgmHouseCtrl:SetIndex(index, scrollRectSelect, tween)
    if tween == nil then
        tween = true
    end
    local item = self.bgmItems[index]
    if scrollRectSelect then
        self.scrollRect:SelectIndex(index, tween)
    end
    self.panel.TxtTitle.LabText = item.row.BGMName
    self.panel.TxtComment.LabText = item.row.Comment
    self.currentIndex = index

    if self.currentPlayingItem ~= nil and self.currentPlayingItem.index ~= index then
        self:OnPlay()
    end

end

---------------普通按钮 start--------------------

function BgmHouseCtrl:OnClose()
    UIMgr:DeActiveUI(self.name)
end

function BgmHouseCtrl:OnNext()
    local l_nextIndex = self.scrollRect.CurIndex + 1
    if l_nextIndex >= #self.idArr then
        l_nextIndex = 0
    end
    self:SetIndex(l_nextIndex, true)
end

function BgmHouseCtrl:OnLast()
    local l_nextIndex = self.scrollRect.CurIndex - 1
    if l_nextIndex < 0 then
        l_nextIndex = #self.idArr - 1
    end
    self:SetIndex(l_nextIndex, true)
end

function BgmHouseCtrl:OnPlay()
    local l_item = self.bgmItems[self.currentIndex]
    MAudioMgr:PlayBGM(l_item.row.BGMEvent)
    self.panel.BtnStop.gameObject:SetActiveEx(true)
    self.playing = true

    if self.currentPlayingItem ~= nil then
        self.currentPlayingItem.tran:SetRotEulerZ(0)
    end
    self.currentPlayingItem = l_item

    local l_bgmLength = MAudioMgr:GetBGMInstance():getDescription():getLength()
    if self.stopBGMTimer ~= nil then
        self:StopUITimer(self.stopBGMTimer)
        self.stopBGMTimer = nil
    end
    self.stopBGMTimer = self:NewUITimer(function(succ)
        if succ then
            self:OnStop()
        end
        self.stopBGMTimer = nil
    end, l_bgmLength / 1000.0 + 2)--2秒缓冲
    self.stopBGMTimer:Start()
end

function BgmHouseCtrl:OnStop()
    if self.stopBGMTimer ~= nil then
        self:StopUITimer(self.stopBGMTimer)
        self.stopBGMTimer = nil
    end

    if not UIMgr:IsActiveUI(self.name) then
        if self.originBGMPath ~= nil then
            MAudioMgr:PlayBGM(self.originBGMPath)
            self.originBGMPath = nil
        end
    else
        MAudioMgr:StopBGM()
    end

    if self.panel ~= nil then
        self.panel.BtnStop.gameObject:SetActiveEx(false)
    end
    self.playing = false
    if self.currentPlayingItem ~= nil then
        self.currentPlayingItem.tran:SetRotEulerZ(0)
    end
    self.currentPlayingItem = nil
end

---------------普通按钮 end--------------------
--lua custom scripts end
