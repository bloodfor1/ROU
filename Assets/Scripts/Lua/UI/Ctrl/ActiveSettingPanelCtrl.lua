--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/ActiveSettingPanelPanel"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua class define
local super = UI.UIBaseCtrl
ActiveSettingPanelCtrl = class("ActiveSettingPanelCtrl", super)
--lua class define end

--lua functions
function ActiveSettingPanelCtrl:ctor()

    super.ctor(self, CtrlNames.ActiveSettingPanel, UILayer.Function, nil, ActiveType.Exclusive)

end --func end
--next--
function ActiveSettingPanelCtrl:Init()

    self.panel = UI.ActiveSettingPanelPanel.Bind(self)
    super.Init(self)

    self.panel.BtnClose:AddClick(function()
        UIMgr:DeActiveUI(UI.CtrlNames.ActiveSettingPanel)
    end)

    self.panel.BtnSceneSet:AddClick(function()

        self:SetSceneActive()
    end)

    self.panel.BtnAllEntity:AddClick(function()

        self:SetAllEntityActive()
    end)

    self.panel.BtnMonster:AddClick(function()
        self:SetMonsterActive()
    end)

    self.panel.BtnRole:AddClick(function()
        self:SetRoleActive()
    end)

    self.panel.BtnNPC:AddClick(function()
        self:SetNPCActive()
    end)

    self.panel.BtnOther:AddClick(function()
        self:SetOtherEntityActive()
    end)

    self.panel.BtnVTransparentFXSet:AddClick(function()
        self:SetBtnVTransparentFXSetActive()
    end)

    self.panel.BtnSceneFXSet:AddClick(function()
        self:SetSenceFXActive()
    end)

    self.panel.Btn640:AddClick(function()
        self:ReRestButton()
        self:SetResolution640()
    end)

    self.panel.Btn720:AddClick(function()
        self:ReRestButton()
        self:SetResolution720()
    end)

    self.panel.Btn1080:AddClick(function()
        self:ReRestButton()
        self:SetResolution1080()
    end)

    self.panel.BtnReSet:AddClick(function()
        self:ReRestButton()
        self:ReSetResolution()
    end)
end --func end

--打开关闭游戏场景
function ActiveSettingPanelCtrl:SetSceneActive()
    MoonClient.GM.MCloseOpenObjGM.ClickHideSceneOnOff()

end

--打开关闭所有的Entity
function ActiveSettingPanelCtrl:SetAllEntityActive()
    MoonClient.GM.MCloseOpenObjGM.ClickHideAllEntityOnOff()

end

--打开关闭所有的怪物
function ActiveSettingPanelCtrl:SetMonsterActive()
    MoonClient.GM.MCloseOpenObjGM.ClickHideAllMonsterOnOff()

end

--打开关闭所有的角色
function ActiveSettingPanelCtrl:SetRoleActive()
    MoonClient.GM.MCloseOpenObjGM.ClickHideAllRoleOnOff()

end

--打开关闭所有的NPC
function ActiveSettingPanelCtrl:SetNPCActive()
    MoonClient.GM.MCloseOpenObjGM.ClickHideAllNPCOnOff()

end

--打开关闭其他Entity
function ActiveSettingPanelCtrl:SetOtherEntityActive()
    MoonClient.GM.MCloseOpenObjGM.ClickHideOtherEntityOnOff()

end

--打开关闭透明特效
function ActiveSettingPanelCtrl:SetBtnVTransparentFXSetActive()
    MoonClient.GM.MCloseOpenObjGM.ClickHideTransparentFXOnOff()

end

--打开关闭场景特效
function ActiveSettingPanelCtrl:SetSenceFXActive()
    MoonClient.GM.MCloseOpenObjGM.ClickHideSceneFXOnOff()
end


--降安卓分辨率为高度640
function ActiveSettingPanelCtrl:SetResolution640()
    MoonClient.GM.MSetResolutionGM.SetResolution(640)
    --self.ReRestButton()

    self.panel.Btn640.Btn.interactable = false;

end

--降安卓分辨率为高度720
function ActiveSettingPanelCtrl:SetResolution720()
    MoonClient.GM.MSetResolutionGM.SetResolution(720)
    self.panel.Btn720.Btn.interactable = false

end

--降安卓分辨率为高度1080
function ActiveSettingPanelCtrl:SetResolution1080()
    MoonClient.GM.MSetResolutionGM.SetResolution(1080)
    --self.ReRestButton()
    self.panel.Btn1080.Btn.interactable = false;
end

--将分辨率设置成机器屏幕分辨率
function ActiveSettingPanelCtrl:ReSetResolution()
    MoonClient.GM.MSetResolutionGM.ResetResolution()
    --self.ReRestButton()
    self.panel.BtnReSet.Btn.interactable = false;
end

function ActiveSettingPanelCtrl:ReRestButton( )
    self.panel.Btn640.Btn.interactable = true
    self.panel.Btn720.Btn.interactable = true
    self.panel.Btn1080.Btn.interactable = true
    self.panel.BtnReSet.Btn.interactable = true
end

--next--
function ActiveSettingPanelCtrl:Uninit()

    super.Uninit(self)
    self.panel = nil

end --func end
--next--
function ActiveSettingPanelCtrl:OnActive()


end --func end
--next--
function ActiveSettingPanelCtrl:OnDeActive()


end --func end
--next--
function ActiveSettingPanelCtrl:Update()


end --func end



--next--
function ActiveSettingPanelCtrl:BindEvents()

    --dont override this function

end --func end

--next--
--lua functions end

--lua custom scripts

--lua custom scripts end
