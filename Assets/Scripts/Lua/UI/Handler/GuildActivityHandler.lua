--this file is gen by script
--you can edit this file in custom part

--lua requires
require "UI/UIBaseHandler"
require "UI/Panel/GuildActivityPanel"
require "UI/Template/GuildWelfareCellTemplate"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua fields
local super = UI.UIBaseHandler
--next--
--lua fields end

--lua class define
GuildActivityHandler = class("GuildActivityHandler", super)
--lua class define end

local l_guildMgr = nil
local l_guildActivityDatas = nil

--lua functions
function GuildActivityHandler:ctor()
    super.ctor(self, HandlerNames.GuildActivity, 0)
end --func end
--next--
function GuildActivityHandler:Init()
    self.panel = UI.GuildActivityPanel.Bind(self)
    super.Init(self)
    l_guildMgr = MgrMgr:GetMgr("GuildMgr")
    --公会活动数据获取
    l_guildActivityDatas = {}
    local l_table = TableUtil.GetGuildContentTable().GetTable()
    for i = 1, #l_table do
        if l_table[i].ContentOfTab == DataMgr:GetData("GuildData").EGuildContentType.Activity and
            (l_table[i].OpenSystemId == 0 or MgrMgr:GetMgr("OpenSystemMgr").IsSystemOpen(l_table[i].OpenSystemId)) then
                
            table.insert(l_guildActivityDatas, l_table[i])
        end
    end

    table.sort(l_guildActivityDatas, function(a, b)
        if a.ContentSort < b.ContentSort then
            return true
        else
            return false
        end
    end)
    --展示列表池声明
    self.guildActivityTemplatePool = self:NewTemplatePool({
        UITemplateClass = UITemplate.GuildWelfareCellTemplate,
        TemplatePrefab = self.panel.GuildWelfareCellPrefab.WelfareItem.gameObject,
        ScrollRect = self.panel.ScrollView.LoopScroll,
    })

    --提示点击关闭
    self.panel.DescribePart:AddClick(function()
        self.panel.DescribePart.UObj:SetActiveEx(false)
    end)
end --func end
--next--
function GuildActivityHandler:Uninit()
    self.guildActivityTemplatePool = nil
    l_guildMgr = nil
    l_guildActivityDatas = nil
    super.Uninit(self)
    self.panel = nil
end --func end
--next--
function GuildActivityHandler:OnActive()
    self.guildActivityTemplatePool:ShowTemplates({
        Datas = l_guildActivityDatas,
        Method = function(item, contentName, tipContent)
            self.panel.DescribeTitle.LabText = contentName
            self.panel.DescribeText.LabText = tipContent
            self.panel.DescribePart.UObj:SetActiveEx(true)
        end
    })
end --func end
--next--
function GuildActivityHandler:OnDeActive()
    -- do nothing
end --func end
--next--
function GuildActivityHandler:Update()
    -- do nothing
end --func end
--next--
function GuildActivityHandler:BindEvents()
    -- do nothing
end --func end
--next--
--lua functions end

--lua custom scripts

--lua custom scripts end
return GuildActivityHandler