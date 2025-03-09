--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseHandler"
require "UI/Panel/GuildDepositoryAllPanel"
require "UI/Template/GuildDepositorySelectTemplate"
require "UI/Template/GuildDepositoryItemTemplate"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua fields
local super = UI.UIBaseHandler
local l_guildDepositoryMgr = nil
local l_guildData = nil
--next--
--lua fields end

--lua class define
GuildDepositoryAllHandler = class("GuildDepositoryAllHandler", super)
--lua class define end

--lua functions
function GuildDepositoryAllHandler:ctor()
    
    super.ctor(self, HandlerNames.GuildDepositoryAll, 0)
    
end --func end
--next--
function GuildDepositoryAllHandler:Init()
    
    self.panel = UI.GuildDepositoryAllPanel.Bind(self)
    super.Init(self)
    l_guildDepositoryMgr = MgrMgr:GetMgr("GuildDepositoryMgr")
    l_guildData = DataMgr:GetData("GuildData")

    --初始化数据
    self.curPage = 1  --当前页
    self.availablePage = 1  --可用页数
    self.availableCellNum = 20  --可用格子数
    self.pageList = nil   --仓库页列表
    self.itemList = nil   --物品列表
    self.showItemList = nil  --当前展示的物品列表
    self.curSelectItem = nil  --当前选中的物品项

    self.countDownTextKey = nil  --倒计时本地化字符串Key
    self.countDownLab = nil  --倒计时的文本组件

    --获取最大格子数和最大页数
    self.maxCellNum = 20
    self.maxPage = 1
    local l_guildUpgradingTable = TableUtil.GetGuildUpgradingTable().GetTable()
    for i = 1, #l_guildUpgradingTable do
        if l_guildUpgradingTable[i].WarehouseStorageLimits > self.maxCellNum then
            self.maxCellNum = l_guildUpgradingTable[i].WarehouseStorageLimits
        end
    end
    self.maxPage = math.ceil(self.maxCellNum / l_guildData.GUILD_DEPOSITORY_PAGE_CAPACITY)

    --按钮点击事件绑定
    self:ButtonEventBind()

    --规则说明赋值
    self.panel.ExplainText.LabText = Lang("GUILD_DEPOSITORY_TIPS")

    --仓库列表池
    self.depositoryTemplatePool = self:NewTemplatePool({
        UITemplateClass = UITemplate.GuildDepositorySelectTemplate,
        TemplatePrefab = self.panel.GuildDepositorySelectPrefab.Prefab.gameObject,
        TemplateParent = self.panel.DepositoryListContent.transform
    })
    --物品列表池
    self.itemTemplatePool = self:NewTemplatePool({
        UITemplateClass = UITemplate.GuildDepositoryItemTemplate,
        TemplatePrefab = self.panel.GuildDepositoryItemPrefab.Prefab.gameObject,
        TemplateParent = self.panel.ItemListContent.transform
    })

    --删除按钮置灰设置
    self.panel.BtnDelete:SetGray(l_guildData.GetSelfGuildPosition() > l_guildData.EPositionType.ViceChairman)

    --初始化两种倒计时面板隐藏 防止美术误操作引起刷屏感
    self.panel.EndCount.UObj:SetActiveEx(false)
    self.panel.BeginCount.UObj:SetActiveEx(false)

end --func end
--next--
function GuildDepositoryAllHandler:Uninit()

    self.pageList = nil   
    self.itemList = nil   
    self.showItemList = nil
    self.curSelectItem = nil

    self.depositoryTemplatePool = nil
    self.itemTemplatePool = nil

    self.countDownTextKey = nil
    self.countDownLab = nil

    super.Uninit(self)
    l_guildDepositoryMgr = nil
    l_guildData = nil
    self.panel = nil
    
end --func end
--next--
function GuildDepositoryAllHandler:OnActive()
 
end --func end
--next--
function GuildDepositoryAllHandler:OnDeActive()
    
    
end --func end
--next--
function GuildDepositoryAllHandler:Update()
    
    
end --func end


--next--
function GuildDepositoryAllHandler:OnShow()

    --请求公会仓库数据
    l_guildDepositoryMgr.ReqGetGuildDepositoryInfo()
    
end --func end

--next--
function GuildDepositoryAllHandler:BindEvents()
    
    --公会仓库数据
    self:BindEvent(l_guildDepositoryMgr.EventDispatcher,l_guildDepositoryMgr.ON_GET_GUILD_DEPOSITORY_DATA,function(self, depositoryInfo)
        --获取仓库和物品信息
        self:GetDepositoryAndItemInfo(depositoryInfo)
        --初始化倒计时
        self:InitCountDown(depositoryInfo)
    end)

    --倒计时数据推送
    self:BindEvent(l_guildDepositoryMgr.EventDispatcher,l_guildDepositoryMgr.ON_TIME_COUNT_DOWN,function(self, timeTable)
        if self.countDownLab then
            self.countDownLab.LabText = Lang(self.countDownTextKey, timeTable.day, timeTable.hour, timeTable.min)
        end
    end)

    --物品关注状态改变
    self:BindEvent(l_guildDepositoryMgr.EventDispatcher,l_guildDepositoryMgr.ON_MODIFY_ATTENTION_STATE,function(self, itemUid, isAttented)
        --刷新显示
        self.itemTemplatePool:RefreshCells()
        --刷新操作按钮界面
        if itemUid == self.curSelectItem.itemUid then
            self:OnSelectItem(self.curSelectItem)
        end
        --提示
        if isAttented then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("GUILD_DEPOSITORY_SET_ATTENTION_SUCCESS"))
        else
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("GUILD_DEPOSITORY_CANCEL_ATTENTION_SUCCESS"))
        end
    end)

    --职位被修改事件监听 修改对应界面显示
    self:BindEvent(MgrMgr:GetMgr("GuildMgr").EventDispatcher,MgrMgr:GetMgr("GuildMgr").ON_GUILD_POSITION_CHANGED, function(self)
        --删除按钮置灰设置
        self.panel.BtnDelete:SetGray(l_guildData.GetSelfGuildPosition() > l_guildData.EPositionType.ViceChairman)
    end)

end --func end

--next--
--lua functions end

--lua custom scripts

--按钮绑定事件
function GuildDepositoryAllHandler:ButtonEventBind()

    --当前仓库按钮点击
    self.panel.BtnCurDepository:AddClick(function ()
        self.panel.DepositorySelectPanel.UObj:SetActiveEx(true)
    end)

    --仓库选择面板点击空白处点击关闭
    self.panel.DepositorySelectPanel:AddClick(function ()
        self.panel.DepositorySelectPanel.UObj:SetActiveEx(false)
    end)

    --库存按钮点击（库存数量）
    self.panel.BtnStock:AddClick(function ()
        if self.itemList and #self.itemList == self.availableCellNum then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Common.Utils.Lang("DEPOSITORY_IS_FULL"))
        end
    end)

    --规则说明按钮点击
    self.panel.BtnTips:AddClick(function ()
        self.panel.ExplainPanel.UObj:SetActiveEx(true)
    end)

    --规则说明点击关闭
    self.panel.BtnCloseExplain:AddClick(function ()
        self.panel.ExplainPanel.UObj:SetActiveEx(false)
    end)

    --关注按钮点击
    self.panel.BtnAttent:AddClick(function ()
        --若无选中 提示先选目标
        if self.curSelectItem == nil then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("PLEASE_SELECT_ITEM_TO_ATTENT"))
            return
        end
        --请求关注
        l_guildDepositoryMgr.ReqSetAttention(self.curSelectItem.itemUid, true)
    end)

    --取消关注按钮点击
    self.panel.BtnCancel:AddClick(function ()
        --若无选中 提示先选目标
        if self.curSelectItem == nil then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("PLEASE_SELECT_ITEM_TO_ATTENT"))
            return
        end
        --请求取消关注
        l_guildDepositoryMgr.ReqSetAttention(self.curSelectItem.itemUid, false)
    end)

    --删除按钮点击
    self.panel.BtnDelete:AddClick(function ()
        --职位判断 只有会长和副会长可操作
        if l_guildData.GetSelfGuildPosition() > l_guildData.EPositionType.ViceChairman then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("NEED_CHAIRMAN_OR_VICECHAIRMAN_TO_OPERATE"))
            return
        end
        --判断是否选中
        if self.curSelectItem == nil then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("PLEASE_SELECT_ITEM_TO_DELETE"))
            return
        end
        --判断稀有度
        local l_itemData = TableUtil.GetItemTable().GetRowByItemID(self.curSelectItem.itemId)
        if l_itemData.ItemQuality < 3 then 
            --低于A稀有度的二次确认删除
            CommonUI.Dialog.ShowYesNoDlg(true, nil, 
                Lang("CHECK_DELETE_ITEM_FROM_GUILD_DEPOSITORY", l_itemData.ItemName), 
                function()
                    if self.curSelectItem then
                        l_guildDepositoryMgr.ReqRemoveItem(self.curSelectItem.itemUid)
                    else
                        MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("THIS_ITEM_IS_ALREALDY_REMOVED"))
                    end
                end, nil, nil, nil, nil, nil, CommonUI.Dialog.DialogTopic.GUILD_DEPOSITORY_MGR, nil, nil)
        else
            --A、S的稀有度提示不允许删除
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("TOO_RARITY_TO_DELETE"))
        end
    end)
end

--获取仓库和物品信息
function GuildDepositoryAllHandler:GetDepositoryAndItemInfo()
    --可用格子数和页数获取
    self.availableCellNum = l_guildData.guildDepositoryInfo.capacity
    self.availablePage = math.ceil(self.availableCellNum / l_guildData.GUILD_DEPOSITORY_PAGE_CAPACITY)
    self.pageList = {}
    for i = 1, self.maxPage do
        local l_pageData = {}
        l_pageData.index = i
        l_pageData.isLock = i > self.availablePage
        table.insert(self.pageList, l_pageData)
    end
    self.depositoryTemplatePool:ShowTemplates({Datas = self.pageList,
        Method = function(pageItem)
            self:ShowItemListByPage(pageItem.data.index)
            self.panel.DepositorySelectPanel.UObj:SetActiveEx(false)
        end})
    --物品列表获取
    self.itemList = l_guildData.guildDepositoryInfo.itemList
    --展示当前页数据
    self:ShowItemListByPage(self.curPage)
    --库存数量显示
    local l_colorTag = #self.itemList < self.availableCellNum and RoColorTag.Gray or RoColorTag.Red
    self.panel.StockNum.LabText = Lang("GUILD_DEPOSITORY_STOCK", l_colorTag, 
        tostring(#self.itemList), tostring(self.availableCellNum))
end

--设置倒计时
function GuildDepositoryAllHandler:InitCountDown(depositoryInfo)

    self.panel.CountContent.UObj:SetActiveEx(true)
    --判断倒计时格式
    local l_saleList = depositoryInfo.auctions
    if l_saleList.items and #l_saleList.items > 0 then
        --如果有拍卖列表则表示正在拍卖 显示距离结束的倒计时
        self.panel.BeginCount.UObj:SetActiveEx(false)
        self.panel.EndCount.UObj:SetActiveEx(true)
        self.countDownTextKey = "REMAIN_TIME_01"
        self.countDownLab = self.panel.EndTime
    else
        --如果没有则表示还未进行拍卖 显示距离开始的倒计时
        self.panel.EndCount.UObj:SetActiveEx(false)
        self.panel.BeginCount.UObj:SetActiveEx(true)
        self.countDownTextKey = "REMAIN_TIME_02"
        self.countDownLab = self.panel.BeginTime
    end
    --倒计时初始展示
    local l_timeTable = Common.TimeMgr.GetCountDownDayTimeTable(l_guildDepositoryMgr.NextTime)
    self.countDownLab.LabText = Lang(self.countDownTextKey, l_timeTable.day, l_timeTable.hour, l_timeTable.min)
   
end


--根据页码展示仓库内容
function GuildDepositoryAllHandler:ShowItemListByPage(pageIndex)

    --显示物品栏
    self.panel.ItemListContent.UObj:SetActiveEx(true)

    --当前页按钮文字变化
    self.panel.TextCurDepository.LabText = Lang("GUILD_DEPOSITORY_PAGE", pageIndex)
    self.curPage = pageIndex

    --当前页的物品索引获取
    local l_startIndex = (pageIndex - 1) * l_guildData.GUILD_DEPOSITORY_PAGE_CAPACITY + 1
    local l_endInex = pageIndex * l_guildData.GUILD_DEPOSITORY_PAGE_CAPACITY

    --当前页展示物品列表获取
    self.showItemList = {}
    for i = l_startIndex, l_endInex do
        local l_item = {}
        l_item.index = i
        l_item.itemInfo = self.itemList[i]
        table.insert(self.showItemList, l_item)
    end

    --物品展示
    self.itemTemplatePool:ShowTemplates({Datas = self.showItemList,
        Method = function(item)
            self:OnSelectItem(item.data.itemInfo)
            self.itemTemplatePool:SelectTemplate(item.ShowIndex)
        end})

    --展示新页 重置选中
    self:OnSelectItem(nil)
    self.itemTemplatePool:CancelSelectTemplate()

end

--选中一个物品
function GuildDepositoryAllHandler:OnSelectItem(itemData)
    
    self.curSelectItem = itemData
    if itemData and itemData.isAttented then
        --有物品选中 并且 是关注状态 显示取消关注按钮
        self.panel.BtnAttent.UObj:SetActiveEx(false)
        self.panel.BtnCancel.UObj:SetActiveEx(true)
    else
        --无物品 或 不是关注的 显示关注按钮
        self.panel.BtnAttent.UObj:SetActiveEx(true)
        self.panel.BtnCancel.UObj:SetActiveEx(false)
    end

end
--lua custom scripts end
return GuildDepositoryAllHandler