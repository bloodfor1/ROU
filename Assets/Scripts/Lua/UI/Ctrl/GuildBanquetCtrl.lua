--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/GuildBanquetPanel"
require "UI/Template/GuildDinnerDishItemTemplate"

--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua class define
local super = UI.UIBaseCtrl
GuildBanquetCtrl = class("GuildBanquetCtrl", super)
--lua class define end

--lua functions
function GuildBanquetCtrl:ctor()

    super.ctor(self, CtrlNames.GuildBanquet, UILayer.Function, nil, ActiveType.Exclusive)

end --func end
--next--
function GuildBanquetCtrl:Init()

    self.panel = UI.GuildBanquetPanel.Bind(self)
    super.Init(self)

    --公会宴会菜肴选项池
    self.dishTemplatePool = self:NewTemplatePool({
        UITemplateClass = UITemplate.GuildDinnerDishItemTemplate,
        TemplatePrefab = self.panel.GuildDinnerDishItemPrefab.Prefab.gameObject,
        TemplateParent = self.panel.Menu.transform
    })

    self:OnInit()

end --func end
--next--
function GuildBanquetCtrl:Uninit()

    self.dishTemplatePool = nil

    super.Uninit(self)
    self.panel = nil

end --func end
--next--
function GuildBanquetCtrl:OnActive()


end --func end
--next--
function GuildBanquetCtrl:OnDeActive()


end --func end
--next--
function GuildBanquetCtrl:Update()


end --func end



--next--
function GuildBanquetCtrl:BindEvents()

    --dont override this function

end --func end

--next--
--lua functions end

--lua custom scripts

local MAX_ITEM = 5

function GuildBanquetCtrl:OnInit()
    local l_curNpcId = MgrMgr:GetMgr("NpcMgr").GetCurrentNpcId()
    local l_curEntity = MNpcMgr:FindNpcInViewport(l_curNpcId)

    if l_curEntity then
        local l_right_vec = l_curEntity.Model.Rotation * Vector3.right
        local l_temp2 = -0.8
        MPlayerInfo:FocusToOrnamentBarter(l_curNpcId, l_right_vec.x * l_temp2, 1, l_right_vec.z * l_temp2, 4, 10, 5)
    else
        logError(StringEx.Format("找不到场景中的npc npc_id:{0}", l_curNpcId))
        return
    end
    
    if MEntityMgr.PlayerEntity ~= nil then
        MEntityMgr.PlayerEntity.Target = nil
    end

    local l_showData = {}
    for i = 1, #DataMgr:GetData("GuildData").dinnerMenu do
        if i>MAX_ITEM then
            break
        end
        table.insert(l_showData, DataMgr:GetData("GuildData").dinnerMenu[i])
    end

    self.dishTemplatePool:ShowTemplates({Datas = l_showData})


    self.panel.Closed:AddClick(function ()
        game:ShowMainPanel()
        MPlayerInfo:FocusToMyPlayer()
        UIMgr:DeActiveUI(UI.CtrlNames.GuildBanquet)
    end)
end

--lua custom scripts end
