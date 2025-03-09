--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/BaseUITemplate"
--lua requires end

--lua model
module("UITemplate", package.seeall)

--lua model end

--lua fields
local super = UITemplate.BaseUITemplate
--lua fields end

--lua class define
---@class ServerLevelTipsTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field Text_06 MoonClient.MLuaUICom
---@field Text_05 MoonClient.MLuaUICom
---@field Text_04 MoonClient.MLuaUICom
---@field Text_03 MoonClient.MLuaUICom
---@field Text_02 MoonClient.MLuaUICom
---@field Text_01 MoonClient.MLuaUICom
---@field ServerLevelTips MoonClient.MLuaUICom
---@field OtherTips MoonClient.MLuaUICom

---@class ServerLevelTipsTemplate : BaseUITemplate
---@field Parameter ServerLevelTipsTemplateParameter

ServerLevelTipsTemplate = class("ServerLevelTipsTemplate", super)
--lua class define end

--lua functions
function ServerLevelTipsTemplate:Init()
	
	super.Init(self)
	self.Parameter.Btn_Help:AddClick(function()
        MgrMgr:GetMgr("CapraFAQMgr").OpenConsultationPanel(Lang("SEVER_LEVEL_FAQ"))
    end)
end --func end
--next--
function ServerLevelTipsTemplate:BindEvents()
	
	
end --func end
--next--
function ServerLevelTipsTemplate:OnDestroy()
	
	
end --func end
--next--
function ServerLevelTipsTemplate:OnDeActive()
	
	
end --func end
--next--
function ServerLevelTipsTemplate:OnSetData(data)
	self:_showData(data)
	
end --func end
--next--
--lua functions end

--lua custom scripts
ServerLevelTipsTemplate.TemplatePath = "UI/Prefabs/ServerLevelTipsPrefab"
function ServerLevelTipsTemplate:_showData(data)
    if data.serverlevel ~= nil then
        --七日版本 关闭Job经验显示
        self.Parameter.Text_03.Transform.parent.gameObject:SetActiveEx(false)
        local serverBaseLimit = self:GetBaseLevelUpperLimitByServerLevel(data.serverlevel)
        --[[
        if data.basebonus < 0 and data.jobbonus < 0 then
            self.Parameter.Text_02.Transform.parent.gameObject:SetActiveEx(false)
            self.Parameter.Text_03.Transform.parent.gameObject:SetActiveEx(false)
            self.Parameter.OtherTips.gameObject:SetActiveEx(false)
        end
        ]]--
        local data_1 = TableUtil.GetGlobalTable().GetRowByName("ExpFixServerLevelLimit").Value
        local data_2 = TableUtil.GetGlobalTable().GetRowByName("ExpFixBaseLevelLimit").Value
        if data.basebonus > 0 then
            self.Parameter.Text_02.Transform.parent.gameObject:SetActiveEx(true)
            self.Parameter.Text_03.Transform.parent.gameObject:SetActiveEx(false)
            self.Parameter.OtherTips.gameObject:SetActiveEx(true)
            self.Parameter.OtherTips.LabText = Common.Utils.Lang("SEVER_OTHERTIPS1", data_1, data_2)
        elseif data.basebonus == 0 then
            self.Parameter.Text_02.Transform.parent.gameObject:SetActiveEx(false)
            self.Parameter.Text_03.Transform.parent.gameObject:SetActiveEx(false)
            self.Parameter.OtherTips.gameObject:SetActiveEx(false)
        else
            self.Parameter.Text_02.Transform.parent.gameObject:SetActiveEx(false)
            self.Parameter.Text_03.Transform.parent.gameObject:SetActiveEx(false)
            self.Parameter.OtherTips.gameObject:SetActiveEx(true)
            self.Parameter.OtherTips.LabText = Common.Utils.Lang("SEVER_OTHERTIPS2", data_1, data_2)
        end

        if tonumber(data.nextrefreshtime) <= 0 then
            self.Parameter.Text_04.gameObject:SetActiveEx(false)
        end

        --玩家等级达到配置的上限 显示
        self.Parameter.Text_05.gameObject:SetActiveEx(MPlayerInfo.Lv >= serverBaseLimit)
        --玩家Base等级达到上限后 显示服务器真实等级
        self.Parameter.Text_06.Transform.parent.gameObject:SetActiveEx(MPlayerInfo.Lv >= serverBaseLimit)

        self.Parameter.Text_01.LabText = data.serverlevel
        self.Parameter.Text_02.LabText = (data.basebonus / 100) .. "%"
        self.Parameter.Text_03.LabText = (data.jobbonus / 100) .. "%"
        self.Parameter.Text_04.LabText = Common.Utils.Lang("SEVER_OPEN_TIME_TEXT", Common.TimeMgr.GetChatTimeFormatStr(data.nextrefreshtime))--服务器开放时间设置
        self.Parameter.Text_05.LabText = Common.Utils.Lang("FULL_LEVEL_TIPS")  --满级Tips提示
        self.Parameter.Text_06.LabText = data.hiddenbaselevel                --服务器真实等级
        self.Parameter.Text_07.LabText = data.serverlevel + 5                --下一级服务器等级
        self.Parameter.Bottom.gameObject:SetActiveEx(false)
        self.Parameter.Center.gameObject:SetActiveEx(self.Parameter.Text_02.Transform.parent.gameObject.activeSelf
                or self.Parameter.Text_03.Transform.parent.gameObject.activeSelf
                or self.Parameter.Text_05.gameObject.activeSelf
                or self.Parameter.OtherTips.gameObject.activeSelf)
    end
    LayoutRebuilder.ForceRebuildLayoutImmediate(self.Parameter.ServerLevelTips.transform)
end

function ServerLevelTipsTemplate:GetBaseLevelUpperLimitByServerLevel(serverLv)
	local l_rows = TableUtil.GetServerLevelTable().GetTable()
	local l_rowCount = #l_rows
	for i=1,l_rowCount do
		local l_row = l_rows[i]
		if l_row.ServeLevel == serverLv then
			return l_row.BaseLevelUpperLimit
		end
	end
	return 0
end
--lua custom scripts end
return ServerLevelTipsTemplate