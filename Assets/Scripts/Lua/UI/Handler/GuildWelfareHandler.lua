--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseHandler"
require "UI/Panel/GuildWelfarePanel"
require "UI/Template/GuildWelfareCellTemplate"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua class define
local super = UI.UIBaseHandler
GuildWelfareHandler = class("GuildWelfareHandler", super)
--lua class define end

local l_guildWelfareDatas = nil

--lua functions
function GuildWelfareHandler:ctor()

    super.ctor(self, HandlerNames.GuildWelfare, 0)

end --func end
--next--
function GuildWelfareHandler:Init()

    self.panel = UI.GuildWelfarePanel.Bind(self)
    super.Init(self)

    --公会福利数据获取
    l_guildWelfareDatas = {}
    local l_table = TableUtil.GetGuildContentTable().GetTable()
    for i = 1, #l_table do
        if l_table[i].ContentOfTab == DataMgr:GetData("GuildData").EGuildContentType.Welfare and
            (l_table[i].OpenSystemId == 0 or MgrMgr:GetMgr("OpenSystemMgr").IsSystemOpen(l_table[i].OpenSystemId)) then

            table.insert(l_guildWelfareDatas, l_table[i])
        end
    end
    table.sort(l_guildWelfareDatas, function (a, b)
        if a.ContentSort < b.ContentSort then
            return true
        else
            return false
        end
    end)

    --展示列表池声明
    self.guildWelfareTemplatePool = self:NewTemplatePool({
        UITemplateClass = UITemplate.GuildWelfareCellTemplate,
        TemplatePrefab = self.panel.GuildWelfareCellPrefab.WelfareItem.gameObject,
        ScrollRect = self.panel.ScrollWelfare.LoopScroll,
    })

    --提示点击关闭
    self.panel.DescribePart:AddClick(function ()
        self.panel.DescribePart.UObj:SetActiveEx(false)
    end)


end --func end
--next--
function GuildWelfareHandler:Uninit()

    self.guildWelfareTemplatePool = nil

    l_guildWelfareDatas = nil

    super.Uninit(self)
    self.panel = nil

end --func end
--next--
function GuildWelfareHandler:OnActive()

    self.guildWelfareTemplatePool:ShowTemplates({
        Datas = l_guildWelfareDatas,
        Method = function(item, contentName, tipContent)
            self.panel.DescribeTitle.LabText = contentName
            self.panel.DescribeText.LabText = tipContent
            self.panel.DescribePart.UObj:SetActiveEx(true)
        end
    })

end --func end
--next--
function GuildWelfareHandler:OnDeActive()

end --func end
--next--
function GuildWelfareHandler:Update()


end --func end


--next--
function GuildWelfareHandler:BindEvents()

    --领取公会福利后事件
    self:BindEvent(MgrMgr:GetMgr("GuildWelfareMgr").EventDispatcher,MgrMgr:GetMgr("GuildWelfareMgr").ON_GUILD_GET_WELFARE_AWARD, function()
        --公会福利领取后 主按钮文字修改
        local welfareCell = self.guildWelfareTemplatePool:GetItem(2)
        if welfareCell then
            welfareCell:ModifyMainButtonText(Common.Utils.Lang("GUILD_WELFARE_CELL_VIEW"))
        end
    end)

end --func end
--next--
--lua functions end

--lua custom scripts

--lua custom scripts end
