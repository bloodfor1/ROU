--this file is gen by script
--you can edit this file in custom part

--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/Dialog04Panel"

--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua class define
local super = UI.UIBaseCtrl
Dialog04Ctrl = class("Dialog04Ctrl", super)
--lua class define end

--lua functions
function Dialog04Ctrl:ctor()

    super.ctor(self, CtrlNames.Dialog04, UILayer.Tips, nil, ActiveType.Standalone)

end --func end
--next--
function Dialog04Ctrl:Init()
    self.panel = UI.Dialog04Panel.Bind(self)
    super.Init(self)

    self._head2D = self:NewTemplate("HeadWrapTemplate", {
        TemplateParent = self.panel.HeadDummy.transform,
        TemplatePath = "UI/Prefabs/HeadWrapTemplate"
    })

    self.panel.BtnYes:AddClick(function()
        MgrMgr:GetMgr("FriendMgr").RequestDeleteFriend(self.uid)
        UIMgr:DeActiveUI(UI.CtrlNames.Dialog04)
    end)

    self.panel.BtnNo:AddClick(function()
        UIMgr:DeActiveUI(UI.CtrlNames.Dialog04)
    end)
end --func end
--next--
function Dialog04Ctrl:Uninit()

    super.Uninit(self)
    self.panel = nil

end --func end
--next--
function Dialog04Ctrl:OnActive()


end --func end
--next--
function Dialog04Ctrl:OnDeActive()


end --func end
--next--
function Dialog04Ctrl:Update()


end --func end
--next--
function Dialog04Ctrl:BindEvents()

    --dont override this function

end --func end
--next--
--lua functions end

--lua custom scripts
function Dialog04Ctrl:ShowPlayer(playerInfo)
    if playerInfo == nil then
        self.uid = DataMgr:GetData("TeamData").GetSelectedUid()
        local entity = MEntityMgr:GetEntity(self.uid, true)
        if not entity then
            return
        end

        self.panel.Name.LabText = entity.AttrComp.Name
        self.panel.Level.LabText = entity.AttrComp.Level
        ---@type HeadTemplateParam
        local param = {
            ShowProfession = true,
            Profession = entity.AttrComp.ProfessionID,
            Entity = entity,
        }

        self._head2D:SetData(param)
    else
        self.uid = playerInfo.uid
        self.panel.Name.LabText = Common.Utils.PlayerName(playerInfo.name)
        self.panel.Level.LabText = playerInfo.data.base_level
        ---@type HeadTemplateParam
        local param = {
            ShowProfession = true,
            Profession = playerInfo.data.type,
            EquipData = playerInfo:GetEquipData(),
        }

        self._head2D:SetData(param)
    end
end
--lua custom scripts end
