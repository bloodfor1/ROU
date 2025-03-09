--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/GuildIconSelectPanel"
require "UI/Template/GuildIconItemTemplate"

--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua class define
local super = UI.UIBaseCtrl
GuildIconSelectCtrl = class("GuildIconSelectCtrl", super)
--lua class define end

local l_guildMgr = nil
local l_curIconId = 0  --当前使用的图标Id
local l_selectId = 0  --选中的图标Id
local l_openType = 0  --打开界面的类型 0创建 1修改

--lua functions
function GuildIconSelectCtrl:ctor()

    super.ctor(self, CtrlNames.GuildIconSelect, UILayer.Function, UITweenType.UpAlpha, ActiveType.Standalone)

    self.GroupMaskType = GroupMaskType.Show
    self.MaskColor=BlockColor.Transparent

end --func end
--next--
function GuildIconSelectCtrl:Init()

    self.panel = UI.GuildIconSelectPanel.Bind(self)
    super.Init(self)

    l_guildMgr = MgrMgr:GetMgr("GuildMgr")

    --关闭按钮
    self.panel.BtnClose:AddClick(function()
        UIMgr:DeActiveUI(UI.CtrlNames.GuildIconSelect)
    end)

    --确定按钮
    self.panel.BtnSure:AddClick(function ()
        if l_selectId == 0 then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("PLEASE_SELECT_ICON"))
            return
        end

        if l_openType == 0 then
            local l_uiCreate = UIMgr:GetUI(UI.CtrlNames.GuildCreate)
            if l_uiCreate then
                l_uiCreate:SetIcon(l_selectId)
            end
            UIMgr:DeActiveUI(UI.CtrlNames.GuildIconSelect)
        else
            MgrMgr:GetMgr("GuildMgr").ReqModifyGuildIcon(l_selectId)
        end
    end)

    --设置遮罩
    --self:SetBlockOpt(BlockColor.Transparent)

end --func end
--next--
function GuildIconSelectCtrl:Uninit()

    self.guildIconTemplatePool=nil
    self.curSelectedItem = nil

    l_guildMgr = nil
    super.Uninit(self)
    self.panel = nil

end --func end
--next--
function GuildIconSelectCtrl:OnActive()

    if self.uiPanelData then
        if self.uiPanelData.type == DataMgr:GetData("GuildData").EUIOpenType.GuildIconSelect then
            self:SetCurIcon(self.uiPanelData.iconId, self.uiPanelData.openType)
        end
    end

end --func end
--next--
function GuildIconSelectCtrl:OnDeActive()


end --func end
--next--
function GuildIconSelectCtrl:Update()


end --func end

--next--
function GuildIconSelectCtrl:BindEvents()
    --被踢出回调
    self:BindEvent(l_guildMgr.EventDispatcher,l_guildMgr.ON_GUILD_KICKOUT,function(self)
        UIMgr:DeActiveUI(UI.CtrlNames.GuildIconSelect)
    end)
end --func end

--next--
--lua functions end

--lua custom scripts
function GuildIconSelectCtrl:ShowIconList()

    --图标列表项的池创建
    self.guildIconTemplatePool = self:NewTemplatePool({
        UITemplateClass = UITemplate.GuildIconItemTemplate,
        TemplatePrefab = self.panel.GuildIconItemPrefab.Prefab.gameObject,
        ScrollRect = self.panel.ScrollView.LoopScroll
    })
    --数据获取
    local l_iconDatas = {}
    local l_iconInfos = TableUtil.GetGuildIconTable().GetTable()
    for i=1, #l_iconInfos do
        local iconData = { id = l_iconInfos[i].GuildIconID,
            iconAltas = l_iconInfos[i].GuildIconAltas,
            iconName = l_iconInfos[i].GuildIconName,
            isCur = (l_iconInfos[i].GuildIconID == l_curIconId)  -- 是否是当前使用的Icon
        }
        table.insert(l_iconDatas, iconData)
    end
    --展示
    self.guildIconTemplatePool:ShowTemplates({Datas = l_iconDatas,Method = function(item)
        --获取选中的id
        l_selectId = item.data.id
        -- 如果之前存在选中项则清除原有选中效果
        if self.curSelectedItem ~= nil then self.curSelectedItem:SetSelect(false) end
        -- 更新当前选中项 且 设置选中效果
        self.curSelectedItem = item
        self.curSelectedItem:SetSelect(true)
    end})
end

--设置当前使用的图标编号
--openType 打开界面的类型 0创建 1修改
function GuildIconSelectCtrl:SetCurIcon(curIconId, openType)
    l_curIconId = curIconId
    l_openType = openType
    l_selectId = 0  --清缓存
    --图标列表显示
    --放在回调里展示 是因为回调在init之后
    --如果在init中显示列表则 无法获取正确的当前选中值
    self:ShowIconList()
end
--lua custom scripts end
