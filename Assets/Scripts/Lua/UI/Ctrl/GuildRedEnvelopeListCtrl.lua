--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/GuildRedEnvelopeListPanel"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua fields
local super = UI.UIBaseCtrl
local l_redMgr = nil
local l_memberId = nil  --对应成员的ID
local l_redInfoList = nil  --红包数据列表
--next--
--lua fields end

--lua class define
GuildRedEnvelopeListCtrl = class("GuildRedEnvelopeListCtrl", super)
--lua class define end

--lua functions
function GuildRedEnvelopeListCtrl:ctor()

    super.ctor(self, CtrlNames.GuildRedEnvelopeList, UILayer.Function, nil, ActiveType.Standalone)

end --func end
--next--
function GuildRedEnvelopeListCtrl:Init()

    self.panel = UI.GuildRedEnvelopeListPanel.Bind(self)
    super.Init(self)

    l_redMgr = MgrMgr:GetMgr("RedEnvelopeMgr")

    self.mask=self:NewPanelMask(BlockColor.Transparent,nil,function()
        MgrMgr:GetMgr("GuildMgr").UpdateGuildMemberListRedListState(l_memberId, l_redInfoList)
        UIMgr:DeActiveUI(UI.CtrlNames.GuildRedEnvelopeList)
    end)

    --遮罩设置
    --self:SetBlockOpt(BlockColor.Transparent, function()
    --    MgrMgr:GetMgr("GuildMgr").UpdateGuildMemberListRedListState(l_memberId, l_redInfoList)
    --    UIMgr:DeActiveUI(UI.CtrlNames.GuildRedEnvelopeList)
    --end)

    --红包列表池
    self.redEnvelopePool = self:NewTemplatePool(
    {
        TemplateClassName = "GuildRedEnvelopeItemTemplate",
        TemplatePrefab = self.panel.GuildRedEnvelopeItemPrefab.LuaUIGroup.gameObject,
        TemplateParent = self.panel.GuildRedEnvelopeItemParent.Transform,
        Method = function(redEnvelopeItem)
            self:OpenRedEnvelope(redEnvelopeItem.data)
        end
    })


end --func end
--next--
function GuildRedEnvelopeListCtrl:Uninit()


    self.redEnvelopePool = nil
    l_memberId = nil
    l_redInfoList = nil
    l_redMgr = nil

    super.Uninit(self)
    self.panel = nil

end --func end
--next--
function GuildRedEnvelopeListCtrl:OnActive()

    if self.uiPanelData then
        if self.uiPanelData.type == DataMgr:GetData("GuildData").EUIOpenType.GuildRedEnvelopeList then
            self:ShowRedEnvelopeList(self.uiPanelData.roleId , self.uiPanelData.redEnvelopeList)
        end
    end

end --func end
--next--
function GuildRedEnvelopeListCtrl:OnDeActive()


end --func end
--next--
function GuildRedEnvelopeListCtrl:Update()


end --func end

--next--
function GuildRedEnvelopeListCtrl:BindEvents()
    --选择红包等级ID后事件
    self:BindEvent(l_redMgr.EventDispatcher,l_redMgr.ON_OPEN_REDENVELOPE,function(self, redInfo)
        self:UpdateRedEnvelopeList(redInfo)
    end)
end --func end
--next--
--lua functions end

--lua custom scripts
--展示红包列表
function GuildRedEnvelopeListCtrl:ShowRedEnvelopeList(memberId, redInfoList)

    l_memberId = memberId
    l_redInfoList = redInfoList or {}
    self.redEnvelopePool:ShowTemplates({Datas = l_redInfoList})

end
--列表打开红包按钮点击
function GuildRedEnvelopeListCtrl:OpenRedEnvelope(redEnvelopeData)

    if redEnvelopeData.is_received or redEnvelopeData.is_finished then
        --如果已经领取过 或者 已经是领取完的红包 则直接请求红包的结果
        l_redMgr.ReqGetRedEnvelopeResultRecord(redEnvelopeData.guild_red_envelope_id)
        --如果原本是未接收的则更新列表显示
        if not redEnvelopeData.is_received then
            redEnvelopeData.is_received = true
            self:UpdateRedEnvelopeList(redEnvelopeData)
        end
    else
        --如果没有领过也不是被领完的红包则 请求确认红包状态
        local l_redIds = {}
        table.insert(l_redIds, redEnvelopeData.guild_red_envelope_id)
        l_redMgr.ReqCheckRedEnvelopeState(l_redIds)
    end

end

--更新红包列表
function GuildRedEnvelopeListCtrl:UpdateRedEnvelopeList(redInfo)
    if l_redInfoList then
        for i = 1, #l_redInfoList do
            if l_redInfoList[i].guild_red_envelope_id == redInfo.guild_red_envelope_id then
                l_redInfoList[i].is_received = redInfo.is_received
                l_redInfoList[i].is_finished = redInfo.is_finished
                break
            end
        end
        self.redEnvelopePool:RefreshCells()
    end
end
--lua custom scripts end
return GuildRedEnvelopeListCtrl