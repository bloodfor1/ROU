--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/SelectServerPanel"
require "UI/Template/ServerBtnTemplate"
require "UI/Template/ServerItemTemplate"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua fields
local super = UI.UIBaseCtrl
--next--
--lua fields end

--lua class define
SelectServerCtrl = class("SelectServerCtrl", super)
--lua class define end

--lua functions
function SelectServerCtrl:ctor()

	super.ctor(self, CtrlNames.SelectServer, UILayer.Function, nil, ActiveType.Normal)

    self.authMgr = game:GetAuthMgr()
end --func end
--next--
function SelectServerCtrl:Init()

	self.panel = UI.SelectServerPanel.Bind(self)
	super.Init(self)

    self.panel.ServerItemTemplate.LuaUIGroup.gameObject:SetActiveEx(false)
    self.panel.ServerBtnTemplate.LuaUIGroup.gameObject:SetActiveEx(false)

    self.btnPool = self:NewTemplatePool({
        UITemplateClass = UITemplate.ServerBtnTemplate,
        TemplatePrefab = self.panel.ServerBtnTemplate.LuaUIGroup.gameObject,
        ScrollRect = self.panel.BtnScroll.LoopScroll
    })

    self.serverItemPool = self:NewTemplatePool({
        UITemplateClass = UITemplate.ServerItemTemplate,
        TemplatePrefab = self.panel.ServerItemTemplate.LuaUIGroup.gameObject,
        ScrollRect = self.panel.SvrScroll.LoopScroll
    })

    self.panel.Btn_closeSelect:AddClick(function()
        UIMgr:DeActiveUI(self.name)
    end)
end --func end
--next--
function SelectServerCtrl:Uninit()

	super.Uninit(self)
	self.panel = nil
	self.btnPool = nil
    self.serverItemPool = nil
end --func end
--next--
function SelectServerCtrl:OnActive()
    self:OnFetchServerInfo()

end --func end
--next--
function SelectServerCtrl:OnDeActive()


end --func end
--next--
function SelectServerCtrl:Update()


end --func end

--next--
function SelectServerCtrl:BindEvents()
    self:BindEvent(self.authMgr.EventDispatcher, EventConst.Names.REQ_QUREY_GATE_IP_SUCCESS, self.OnFetchServerInfo)
end --func end

--next--
--lua functions end

--lua custom scripts
function SelectServerCtrl:OnFetchServerInfo()
    local serverInfo = self.authMgr:GetServerList()
    if serverInfo then
        local btnDatas = self:GetServerBtnDatas(serverInfo)
        self.btnPool:ShowTemplates({Datas = btnDatas})
        self:SelectServerBtn(btnDatas[1].datas, 1)
    end
end

--计算服务器分组按钮的数量
function SelectServerCtrl:GetServerBtnCount(serverInfo)
    local ret = 2
    if serverInfo then
        local allServerCount = table.maxn(serverInfo.allservers)
        local allServer_ten,allServer_one = math.modf(allServerCount/10)
        if allServer_one ~= 0 then
            ret = ret + allServer_ten + 1
        end
    end
    return ret
end

function SelectServerCtrl:GetServerBtnDatas(serverInfo)
    local ret = {}
    table.insert(ret, { name = Lang("RECOMMOND_SERVER_NAME"), datas = { serverInfo.recommandgate }, ctrl = self })

    local selfServers = {}
    for i, v in ipairs(serverInfo.servers) do
        table.insert(selfServers, v.servers)
    end
    table.insert(ret, { name = Lang("MY_SERVER_NAME"), datas = selfServers, ctrl = self })

    local allServerCount = #serverInfo.allservers
    local l_serverList = {}
    for i = 1, math.ceil(allServerCount/10) do
        local startIdx, endIdx = (i-1)*10+1, i*10
        local datas = {}
        local name = StringEx.Format("{0}-{1}{2}", startIdx, endIdx, Lang("OTHER_SERVER_NAME"))
        for j = startIdx, math.min(allServerCount, endIdx) do
            table.insert(datas, serverInfo.allservers[j])
        end
        table.sort(datas, function(a, b) return a.serverid > b.serverid end)
        table.insert(l_serverList, 1, { name = name, datas = datas, ctrl = self })
    end
    for _, v in ipairs(l_serverList) do
        table.insert(ret, v)
    end
    return ret
end

function SelectServerCtrl:SelectServerBtn(datas, index)
    self.btnPool:SelectTemplate(index)
    self.serverItemPool:ShowTemplates({Datas = datas})
end

--lua custom scripts end
return SelectServerCtrl