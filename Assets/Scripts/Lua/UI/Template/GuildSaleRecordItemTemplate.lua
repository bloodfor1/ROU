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
---@class GuildSaleRecordItemTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field TextTime MoonClient.MLuaUICom
---@field TextContent MoonClient.MLuaUICom
---@field Prefab MoonClient.MLuaUICom

---@class GuildSaleRecordItemTemplate : BaseUITemplate
---@field Parameter GuildSaleRecordItemTemplateParameter

GuildSaleRecordItemTemplate = class("GuildSaleRecordItemTemplate", super)
--lua class define end

--lua functions
function GuildSaleRecordItemTemplate:Init()
	
	    super.Init(self)
	
end --func end
--next--
function GuildSaleRecordItemTemplate:OnDestroy()
	
	
end --func end
--next--
function GuildSaleRecordItemTemplate:OnDeActive()
	
	    self.data = nil
	
end --func end
--next--
function GuildSaleRecordItemTemplate:OnSetData(data)
	
	    self.data = data
	    --获取对应物品数据
	    local l_itemData = TableUtil.GetItemTable().GetRowByItemID(data.itemId)
	    if not l_itemData then
	        return
	    end
	    --物品的超链接的字符串获取
	    local l_itemStr = StringEx.Format("<a href=ShowItemDetail>{0}</a>", GetColorText(l_itemData.ItemName, RoColorTag.Blue))
	    --贡献消耗的字符串获取
	    local l_costItemData = TableUtil.GetItemTable().GetRowByItemID(GameEnum.l_virProp.GuildContribution)
	    local l_iconStr = StringEx.Format(Common.Utils.Lang("RICH_IMAGE"), l_costItemData.ItemIcon, l_costItemData.ItemAtlas, 20, 1)
	    local l_costStr = l_iconStr..data.cost
	    --时间获取
	    local l_timeTable = Common.TimeMgr.GetTimeTable(data.time)
	    --时间设置
	    self.Parameter.TextTime.LabText = Lang("DATE_M_D", l_timeTable.month, l_timeTable.day)
	    --内容设置
	    if data.recordType == 0 then 
	        --公会记录
	        --某成员花费了{0}，获得了[{1}]
	        self.Parameter.TextContent.LabText = Lang("GUILD_SALE_RECORD_PUBLIC", l_costStr, l_itemStr)
	    elseif data.recordType == 1 then
	        --个人成功记录
	        --竞拍[{0}]成功，花费了{1}
	        self.Parameter.TextContent.LabText = Lang("GUILD_SALE_RECORD_SELF_SUCCESS", l_itemStr, l_costStr)
	    else
	        --个人失败记录
	        --竞拍[{0}]失败，返还{1}
	        self.Parameter.TextContent.LabText = Lang("GUILD_SALE_RECORD_SELF_FAILED", l_itemStr, l_costStr)
	    end
	    self.Parameter.TextContent.LabRayCastTarget = true
	    self:SetTextHref()
	
end --func end
--next--
function GuildSaleRecordItemTemplate:BindEvents()
	
	
end --func end
--next--
--lua functions end

--lua custom scripts
function GuildSaleRecordItemTemplate:SetTextHref()
    --先清理再绑定
    self.Parameter.TextContent:GetRichText().onHrefClick:RemoveAllListeners()
    self.Parameter.TextContent:GetRichText().onHrefClick:AddListener(function(hrefName)
        if hrefName == "ShowItemDetail" then
            MgrMgr:GetMgr("ItemTipsMgr").ShowTipsDisplayWithId(self.data.itemId, nil, nil, nil, false)
        end
    end)
end
--lua custom scripts end
return GuildSaleRecordItemTemplate