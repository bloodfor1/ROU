--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/ViewstickersPanel"
--lua requires end

--lua model
module("UI", package.seeall)

--lua model end

--lua fields
local super = UI.UIBaseCtrl
--lua fields end

--lua class define
ViewstickersCtrl = class("ViewstickersCtrl", super)
--lua class define end

--lua functions
function ViewstickersCtrl:ctor()
    
    super.ctor(self, CtrlNames.Viewstickers, UILayer.Function, nil, ActiveType.Standalone)
    
end --func end
--next--
function ViewstickersCtrl:Init()
    
    self.panel = UI.ViewstickersPanel.Bind(self)
    super.Init(self)

    self:InitPanel()

end --func end
--next--
function ViewstickersCtrl:Uninit()
    
    super.Uninit(self)
    self.panel = nil
    
end --func end
--next--
function ViewstickersCtrl:OnActive()
    
    
end --func end
--next--
function ViewstickersCtrl:OnDeActive()
    
    
end --func end
--next--
function ViewstickersCtrl:Update()
    
    
end --func end
--next--
function ViewstickersCtrl:Refresh()
    
    
end --func end
--next--
function ViewstickersCtrl:OnLogout()
    
    
end --func end
--next--
function ViewstickersCtrl:OnReconnected(roleData)
    
    
end --func end
--next--
function ViewstickersCtrl:Show(withTween)
    
    if not super.Show(self, withTween) then return end
    
end --func end
--next--
function ViewstickersCtrl:Hide(withTween)
    
    if not super.Hide(self, withTween) then return end
    
end --func end
--next--
function ViewstickersCtrl:BindEvents()
    
    
end --func end
--next--
function ViewstickersCtrl:UnBindEvents()
    
    
end --func end
--next--
--lua functions end

--lua custom scripts

function ViewstickersCtrl:InitPanel()
    self.panel.Bg:AddClick(function()
        UIMgr:DeActiveUI(UI.CtrlNames.Viewstickers)
        MLuaClientHelper.ExecuteClickEvents(Input.mousePosition)
    end)

    self.panel.TextName.LabText = MPlayerInfo.Name
    self.panel.LvText.LabText = "Lv." .. MPlayerInfo.Lv
    local l_professionRow = TableUtil.GetProfessionTable().GetRowById(MPlayerInfo.ProfessionId)
    if l_professionRow then
        self.panel.LvClass.LabText = l_professionRow.Name
    end
    local l_guidName =DataMgr:GetData("GuildData").selfGuildMsg.name
    l_guidName = string.ro_isEmpty(l_guidName) and Lang("NO_GUILD") or l_guidName
    self.panel.Guild.LabText = StringEx.Format(Lang("PLAYER_DETAIL_GUILD"), l_guidName)
    local l_teamNum = table.ro_size(DataMgr:GetData("TeamData").myTeamInfo.memberList)
    if l_teamNum == 0 then
        self.panel.TeamText.LabText = Lang("TEAM_MENU_NIL")
    else
        self.panel.TeamText.LabText = Lang("TEAM_MENU_NUM", l_teamNum, 5)
    end

    local l_attr = Common.CommonUIFunc.GetMyselfRoleAttr()
    local l_fxData = {}
    l_fxData.rawImage = self.panel.TargetIcon.RawImg
    l_fxData.attr = l_attr
    l_fxData.defaultAnim = MgrMgr:GetMgr("GarderobeMgr").GetRoleAnim(l_attr)

    if self.model ~= nil then
        self:DestroyUIModel(self.model);
        self.model = nil
    end
    self.model = self:CreateUIModel(l_fxData)


    --半身像处理
    self.model:AddLoadModelCallback(function(m)
        self.model.Trans:SetPos(0, -1.51, -0.17)
        self.model.Trans:SetLocalScale(1.9, 1.9, 1.9)
        self.model.Trans.gameObject:SetRotEuler(-10.295, 180, 0)
        self.panel.TargetIcon:SetActiveEx(true)
    end)

    -- 称号
    local l_titleId = DataMgr:GetData("TitleStickerData").ActiveTitleId
    if l_titleId ~= 0 then
        local l_titleRow = TableUtil.GetTitleTable().GetRowByTitleID(l_titleId)
        local l_itemRow = TableUtil.GetItemTable().GetRowByItemID(l_titleId)
        if l_titleRow then
            self.panel.TitleName.LabText = StringEx.Format("[{0}]", l_titleRow.TitleName)
        end
        if l_itemRow then
            self.panel.TitleName.LabColor = MgrMgr:GetMgr("TitleStickerMgr").GetQualityColor(l_itemRow.ItemQuality)
        end
    else
        self.panel.TitleName.LabText = Lang("TITLE_EMPTY")
        self.panel.TitleName.LabColor = MgrMgr:GetMgr("TitleStickerMgr").GetQualityColor(0)
    end

    -- 贴纸
    self.stickersTemplate = self:NewTemplate("StickerWallTemplent",{
        TemplateParent = self.panel.Sticker.transform,
    })

    local l_stickerId = self.uiPanelData.stickerId
    local l_gridInfos = {}
    table.insert(l_gridInfos, {
        stickerId = l_stickerId,
        status = 2,
        isCovered = false,                 -- 是否被覆盖
    })
    self.stickersTemplate:SetData({bgType = "none", gridInfos = l_gridInfos})
end


--lua custom scripts end
return ViewstickersCtrl