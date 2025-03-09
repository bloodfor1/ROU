--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/ArenaSettlementPanel"
require "UI/Template/ArenaSettleRoleItem"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua class define
local super = UI.UIBaseCtrl
ArenaSettlementCtrl = class("ArenaSettlementCtrl", super)
--lua class define end

--lua functions
function ArenaSettlementCtrl:ctor()

    super.ctor(self, CtrlNames.ArenaSettlement, UILayer.Function, UITweenType.UpAlpha, ActiveType.Exclusive)
    self.pvpMgr = MgrMgr:GetMgr("PvpMgr")

end --func end
--next--
function ArenaSettlementCtrl:Init()

    self.panel = UI.ArenaSettlementPanel.Bind(self)
    super.Init(self)
    self.roleItemPool = self:NewTemplatePool({
            UITemplateClass = UITemplate.ArenaSettleRoleItem,
            TemplateParent = self.panel.RoleGroup.Transform,
            TemplatePrefab = self.panel.ArenaSettleRoleItem.LuaUIGroup.gameObject
        })

    self.mask=self:NewPanelMask(BlockColor.Transparent,nil,function()
        UIMgr:DeActiveUI(UI.CtrlNames.ArenaSettlement)
        MgrMgr:GetMgr("DungeonMgr").LeaveDungeon()
    end)

    --遮罩设置
    --self:SetBlockOpt(BlockColor.Transparent, function()
    --    UIMgr:DeActiveUI(UI.CtrlNames.ArenaSettlement)
    --    MgrMgr:GetMgr("DungeonMgr").LeaveDungeon()
    --end)

    self.panel.SaveBtn:AddClick(function()
        self.pvpMgr:Save2Phone()
    end)
    self.panel.MobileBtn:AddClick(function()
        self.pvpMgr.Save2Photo()
    end)

    self.arenaResultInfo=self.uiPanelData

end --func end
--next--
function ArenaSettlementCtrl:Uninit()

    self.roleItemPool=nil
    super.Uninit(self)
    self.panel = nil
    self.arenaResultInfo=nil

end --func end
--next--
function ArenaSettlementCtrl:OnActive()
    self.panel.Title.LabText = Lang("ARENA_FINAL_RESULT", MEntityMgr.PlayerEntity.AttrRole.Floor + 1)

    self.panel.MetalCount.LabText = Lang("ARENA_FINAL_REWARD_TEXT", 20)

    self:RefreshRoles()
end --func end
--next--
function ArenaSettlementCtrl:OnDeActive()


end --func end
--next--
function ArenaSettlementCtrl:Update()


end --func end



--next--
function ArenaSettlementCtrl:BindEvents()

    self:BindEvent(MgrMgr:GetMgr("HeadMgr").EventDispatcher,EventConst.Names.HEAD_SET_HEDA, self.OnSetHead)

end --func end
--next--
--lua functions end
function ArenaSettlementCtrl:RefreshRoles()
    if self.arenaResultInfo == nil then
        return
    end
    local player=self.arenaResultInfo.player
    if player == nil then
        return
    end
    local players = table.ro_keys(player)
    MgrMgr:GetMgr("HeadMgr").SetHead(players)
end

function ArenaSettlementCtrl:OnSetHead(headInfos, roleIdList)
    if self.arenaResultInfo == nil then
        return
    end
    local datas = {}
    local headInfo
    for i, v in ipairs(roleIdList) do
        headInfo = headInfos[tostring(v)]
        if headInfo then
            table.insert(datas, {
                roleId = v,
                attr = headInfo.attr,
                name = headInfo.player.name,
                jobName = DataMgr:GetData("TeamData").GetProfessionImageById(headInfo.player.role_type),
                score = 0,
                isMvp = false,
                lv = headInfo.player.level,
                hideLike = self.arenaResultInfo.hideLike,
            })
        else
            logError("get head info fail: ", v)
        end
    end
    self.roleItemPool:ShowTemplates({Datas = datas})
end
--lua custom scripts

--lua custom scripts end

return ArenaSettlementCtrl
