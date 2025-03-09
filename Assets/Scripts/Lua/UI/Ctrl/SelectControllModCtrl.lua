--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/SelectControllModPanel"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua class define
local super = UI.UIBaseCtrl
SelectControllModCtrl = class("SelectControllModCtrl", super)
--lua class define end

local l_selectMod = 1  --选中的操作模式类型 1双轮盘 2经典

--lua functions
function SelectControllModCtrl:ctor()

    super.ctor(self, CtrlNames.SelectControllMod, UILayer.Function, nil, ActiveType.Exclusive)

    self.GroupMaskType = GroupMaskType.Show
    self.MaskColor=BlockColor.Dark

end --func end
--next--
function SelectControllModCtrl:Init()

    self.panel = UI.SelectControllModPanel.Bind(self)
    super.Init(self)
    --设置遮罩
    --self:SetBlockOpt(BlockColor.Dark)
    --初始值赋值
    l_selectMod = 1
    --双轮盘点击
    self.panel.BtnMod01:AddClick(function ()
        self.panel.SelectImg01.UObj:SetActive(true)
        self.panel.SelectImg02.UObj:SetActive(false)
        l_selectMod = 1
    end)
    --经典点击
    self.panel.BtnMod02:AddClick(function ()
        self.panel.SelectImg01.UObj:SetActive(false)
        self.panel.SelectImg02.UObj:SetActive(true)
        l_selectMod = 2
    end)
    --开始游戏点击
    self.panel.BtnStart:AddClick(function ()
        if l_selectMod == 1 then
            MPlayerSetting.SkillCtrlType = ESkillControllerType.DoubleDisk
        else
            MPlayerSetting.SkillCtrlType = ESkillControllerType.Classic
        end
        UIMgr:DeActiveUI(UI.CtrlNames.SelectControllMod)
        MgrMgr:GetMgr("BeginnerGuideMgr").OnOneGuideOver()
    end)

end --func end
--next--
function SelectControllModCtrl:Uninit()

    l_selectMod = 1

    super.Uninit(self)
    self.panel = nil

end --func end
--next--
function SelectControllModCtrl:OnActive()


end --func end
--next--
function SelectControllModCtrl:OnDeActive()


end --func end
--next--
function SelectControllModCtrl:Update()


end --func end





--next--
function SelectControllModCtrl:BindEvents()

    --dont override this function

end --func end

--next--
--lua functions end

--lua custom scripts
function SelectControllModCtrl:SetModTitle(modTitle01, modTitle02)
    self.panel.ModTitle01.LabText = modTitle01
    self.panel.ModTitle02.LabText = modTitle02
end
--lua custom scripts end
