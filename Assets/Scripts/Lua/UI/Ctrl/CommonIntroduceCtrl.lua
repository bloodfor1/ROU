--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/CommonIntroducePanel"
require "UI/Template/BigPicItemTemplate"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua class define
local super = UI.UIBaseCtrl
local ContentType =
{
    Normal = 1,
    BigPic = 2
}
CommonIntroduceCtrl = class("CommonIntroduceCtrl", super)
--lua class define end

--lua functions
function CommonIntroduceCtrl:ctor()

	super.ctor(self, CtrlNames.CommonIntroduce, UILayer.Function, nil, ActiveType.Exclusive)

end --func end
--next--
function CommonIntroduceCtrl:Init()

	self.panel = UI.CommonIntroducePanel.Bind(self)
	super.Init(self)

    self.closeFunction = nil
    self.data = DataMgr:GetData("CommonIntroduceData")
    self.bigPicItemPool = self:NewTemplatePool({
        UITemplateClass = UITemplate.BigPicItemTemplate,
        TemplateParent = self.panel.BigPicContent.transform,
        TemplatePrefab = self.panel.BigPicItemTemplate.LuaUIGroup.gameObject
    })

end --func end
--next--
function CommonIntroduceCtrl:Uninit()

	super.Uninit(self)
	self.panel = nil
    self.bigPicItemPool = nil

end --func end
--next--
function CommonIntroduceCtrl:OnActive()

    if self.uiPanelData then
        if self.uiPanelData.openType == self.data.OpenType.InitInfoAndNpc then
            self:InitInfoAndNpc(self.uiPanelData.title, self.uiPanelData.info, self.uiPanelData.altas, self.uiPanelData.icon)
        end
        if self.uiPanelData.openType == self.data.OpenType.InitInfoOnly then
            self:SetInfo(self.uiPanelData.title, self.uiPanelData.info, self.uiPanelData.altas, self.uiPanelData.icon, self.uiPanelData.fun)
        end
        if self.uiPanelData.openType == self.data.OpenType.SetBigInfo then
            logYellow(self.uiPanelData.title, self.uiPanelData.info, self.uiPanelData.altas, self.uiPanelData.icon, self.uiPanelData.fun)
            self:SetBigPicInfo(self.uiPanelData.title, self.uiPanelData.info, self.uiPanelData.altas, self.uiPanelData.icon, self.uiPanelData.fun)
        end
    end

end --func end
--next--
function CommonIntroduceCtrl:OnDeActive()

    if self.closeFunction ~= nil then
        self.closeFunction()
    end

end --func end
--next--
function CommonIntroduceCtrl:Update()

end --func end

--next--
function CommonIntroduceCtrl:BindEvents()
	--dont override this function
end --func end

--next--
--lua functions end

--lua custom scripts
function CommonIntroduceCtrl:SetHead(title, atlasName, iconName, clickCallBack)

    self.closeFunction = clickCallBack
    self.panel.Title.LabText = title
    self.panel.Icon:SetSpriteAsync(atlasName, iconName, nil, true)
    self.panel.CloseBtn:AddClick(function()
        if clickCallBack then
            clickCallBack()
            self.closeFunction = nil
        end
    end)

end

function CommonIntroduceCtrl:SetContent(info, funcId, type)

    if type == ContentType.Normal then
        self.panel.Content.LabText = info
        self.panel.Content.gameObject.transform.parent.gameObject:SetActive(true)
    else
        local bigPicTipSdata = TableUtil.GetBigPicTipTable().GetRowByID(funcId)
        if bigPicTipSdata then
            local tips = Common.Functions.VectorToTable(bigPicTipSdata.Tips)
            local atlases = Common.Functions.VectorToTable(bigPicTipSdata.Atlases)
            local icons = Common.Functions.VectorToTable(bigPicTipSdata.Icons)
            if #icons ~= #atlases then
                logError("BigPicTipTable.Id[%s] 中的icon和atlas配置数量不一致", funcId)
                return
            end
            local datas = {}
            for i, v in ipairs(tips) do
                table.insert(datas, {tip = v, atlas = atlases[i], icon = icons[i]})
            end
            self.bigPicItemPool:ShowTemplates({Datas = datas})
        end
    end

end

function CommonIntroduceCtrl:InitInfoAndNpc(title, info, altas, icon)

    local l_curNpcId = MgrMgr:GetMgr("NpcMgr").GetCurrentNpcId()
    local l_curEntity = MNpcMgr:FindNpcInViewport(l_curNpcId)
    if l_curEntity then
        local l_right_vec = l_curEntity.Model.Rotation * Vector3.right
        local l_temp2 = -0.8
        MPlayerInfo:FocusToOrnamentBarter(l_curNpcId, l_right_vec.x * l_temp2, 1, l_right_vec.z * l_temp2, 4, 10, 5)
        if MEntityMgr.PlayerEntity ~= nil then
            MEntityMgr.PlayerEntity.Target = nil
        end
    end
    local l_ui = UIMgr:GetUI(UI.CtrlNames.CommonIntroduce)
    if l_ui then
        l_ui:SetInfo(title, info, altas, icon, function()
            UIMgr:DeActiveUI(UI.CtrlNames.CommonIntroduce)
            MPlayerInfo:FocusToMyPlayer()
        end)
    end

end
function CommonIntroduceCtrl:SetInfo(title, info, atlasName, iconName, clickCallBack)

	self.panel.BigPicItemTemplate.LuaUIGroup.gameObject:SetActiveEx(false)
    self.panel.BigPicScroll:SetActiveEx(false)
    self.panel.NormalScroll:SetActiveEx(true)

    self:SetHead(title, atlasName, iconName, clickCallBack)
    self:SetContent(info, nil, ContentType.Normal)

end

function CommonIntroduceCtrl:SetBigPicInfo(title, funcId, atlasName, iconName, clickCallBack)

    self.panel.BigPicItemTemplate.LuaUIGroup.gameObject:SetActiveEx(false)
    self.panel.BigPicScroll:SetActiveEx(true)
    self.panel.NormalScroll:SetActiveEx(false)

    self:SetHead(title, atlasName, iconName, clickCallBack)
    self:SetContent(nil, funcId, ContentType.BigPic)

end

--lua custom scripts end
return CommonIntroduceCtrl