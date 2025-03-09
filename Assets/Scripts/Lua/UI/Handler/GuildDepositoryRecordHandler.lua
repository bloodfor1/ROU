--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseHandler"
require "UI/Panel/GuildDepositoryRecordPanel"
require "UI/Template/GuildSaleRecordItemTemplate"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua fields
local super = UI.UIBaseHandler
local l_guildDepositoryMgr = nil
--next--
--lua fields end

--lua class define
GuildDepositoryRecordHandler = class("GuildDepositoryRecordHandler", super)
--lua class define end

--lua functions
function GuildDepositoryRecordHandler:ctor()
    
    super.ctor(self, HandlerNames.GuildDepositoryRecord, 0)
    
end --func end
--next--
function GuildDepositoryRecordHandler:Init()
    
    self.panel = UI.GuildDepositoryRecordPanel.Bind(self)
    super.Init(self)

    l_guildDepositoryMgr = MgrMgr:GetMgr("GuildDepositoryMgr")

    --公共拍卖记录列表项的池创建
    self.recordsPublicTemplatePool = self:NewTemplatePool({
        UITemplateClass = UITemplate.GuildSaleRecordItemTemplate,
        TemplatePrefab = self.panel.GuildSaleRecordItemPrefab.Prefab.gameObject,
        ScrollRect = self.panel.PublicRecordScrollView.LoopScroll
    })

    --私人拍卖记录列表项的池创建
    self.recordsSelfTemplatePool = self:NewTemplatePool({
        UITemplateClass = UITemplate.GuildSaleRecordItemTemplate,
        TemplatePrefab = self.panel.GuildSaleRecordItemPrefab.Prefab.gameObject,
        ScrollRect = self.panel.SelfRecordScrollView.LoopScroll
    })

end --func end
--next--
function GuildDepositoryRecordHandler:Uninit()
    
    self.recordsPublicTemplatePool = nil
    self.recordsSelfTemplatePool = nil

    self.recordsPublic = nil
    self.recordsSelf = nil

    super.Uninit(self)
    l_guildDepositoryMgr = nil
    self.panel = nil
    
end --func end
--next--
function GuildDepositoryRecordHandler:OnActive()
    
    --请求数据
    l_guildDepositoryMgr.ReqSaleRecordPublic()
    l_guildDepositoryMgr.ReqSaleRecordPersonal()
    
end --func end
--next--
function GuildDepositoryRecordHandler:OnDeActive()
    
    
end --func end
--next--
function GuildDepositoryRecordHandler:Update()
    
    
end --func end


--next--
function GuildDepositoryRecordHandler:OnShow()


    --请求数据
    l_guildDepositoryMgr.ReqSaleRecordPublic()
    l_guildDepositoryMgr.ReqSaleRecordPersonal()
    
end --func end

--next--
function GuildDepositoryRecordHandler:BindEvents()
    
    --收到公会纪录数据
    self:BindEvent(l_guildDepositoryMgr.EventDispatcher,l_guildDepositoryMgr.ON_GET_SALE_RECORD_PUBLIC,function(self, recordsList)
        if #recordsList > 0 then
            self.panel.PublicRecordScrollView.UObj:SetActiveEx(true)
            self.panel.PublicEmptyIcon.UObj:SetActiveEx(false)
            self.recordsPublic = {}
            for i = 1, #recordsList do
                local l_temp = recordsList[i]
                local l_record = {}
                l_record.recordType = 0  --0表示公共记录
                l_record.time = l_temp.time
                l_record.itemId = l_temp.itemid
                l_record.itemUid = l_temp.itemuuid
                l_record.cost = l_temp.cost
                table.insert(self.recordsPublic, l_record)
            end
            table.sort(self.recordsPublic, function(a, b)
                return a.time > b.time
            end)
            self.recordsPublicTemplatePool:ShowTemplates({Datas = self.recordsPublic})
        else
            self.panel.PublicRecordScrollView.UObj:SetActiveEx(false)
            self.panel.PublicEmptyIcon.UObj:SetActiveEx(true)
        end
    end)
    --收到个人纪录数据
    self:BindEvent(l_guildDepositoryMgr.EventDispatcher,l_guildDepositoryMgr.ON_GET_SALE_RECORD_PERSONAL,function(self, recordsList)
        if  #recordsList > 0 then
            self.panel.SelfRecordScrollView.UObj:SetActiveEx(true)
            self.panel.SelfEmptyIcon.UObj:SetActiveEx(false)
            self.recordsSelf = {}
            for i = 1, #recordsList do
                local l_temp = recordsList[i]
                local l_record = {}
                l_record.recordType = l_temp.issuccess and 1 or 2  --1表示个人成功记录 2表示个人失败记录
                l_record.time = l_temp.time
                l_record.itemId = l_temp.itemid
                l_record.itemUid = l_temp.itemuuid
                l_record.cost = l_temp.cost
                table.insert(self.recordsSelf, l_record)
            end
            table.sort(self.recordsSelf, function(a, b)
                return a.time > b.time
            end)
            self.recordsSelfTemplatePool:ShowTemplates({Datas = self.recordsSelf})
        else
            self.panel.SelfRecordScrollView.UObj:SetActiveEx(false)
            self.panel.SelfEmptyIcon.UObj:SetActiveEx(true)
        end
    end)
    
end --func end
--next--
--lua functions end

--lua custom scripts

--lua custom scripts end
return GuildDepositoryRecordHandler