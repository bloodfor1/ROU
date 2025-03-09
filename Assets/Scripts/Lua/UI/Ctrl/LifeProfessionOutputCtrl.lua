--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/LifeProfessionOutputPanel"

require "UI/Template/ItemTemplate"

local ClassID = MgrMgr:GetMgr("LifeProfessionMgr").ClassID
local Mgr = MgrMgr:GetMgr("LifeProfessionMgr")
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua class define
local super = UI.UIBaseCtrl
LifeProfessionOutputCtrl = class("LifeProfessionOutputCtrl", super)
--lua class define end

--lua functions
function LifeProfessionOutputCtrl:ctor()

	super.ctor(self, CtrlNames.LifeProfessionOutput, UILayer.Function, UITweenType.UpAlpha, ActiveType.Standalone)
    self.InsertPanelName = UI.CtrlNames.LifeProfessionTips
    --self:SetParent(CtrlNames.LifeProfessionTips)
end --func end
--next--
function LifeProfessionOutputCtrl:Init()

	self.panel = UI.LifeProfessionOutputPanel.Bind(self)
	super.Init(self)

    self.panel.CloseBtn:AddClick(function()
        UIMgr:DeActiveUI(CtrlNames.LifeProfessionOutput)
    end,true)

    self.ItemPool = self:NewTemplatePool({
            UITemplateClass = UITemplate.ItemTemplate,
            TemplateParent = self.panel.Parent.transform,
        })

    self.panel.Floor.Listener.onClick = function(obj, data)
        self.panel.Floor.gameObject:SetActiveEx(false)
        UIMgr:DeActiveUI(CtrlNames.LifeProfessionOutput)
        MLuaClientHelper.ExecuteClickEvents(data.position, CtrlNames.LifeProfessionOutput)
        self.panel.Floor.gameObject:SetActiveEx(true)
        self.panel.Floor.Listener.onClick = nil
    end

end --func end
--next--
function LifeProfessionOutputCtrl:Uninit()

    self.ItemPool = nil
    super.Uninit(self)
    self.panel = nil

end --func end
--next--
function LifeProfessionOutputCtrl:OnActive()

end --func end
--next--
function LifeProfessionOutputCtrl:OnDeActive()

end --func end
--next--
function LifeProfessionOutputCtrl:Update()

end --func end

--next--
function LifeProfessionOutputCtrl:BindEvents()
	--dont override this function
end --func end

--next--
--lua functions end

--lua custom scripts
function LifeProfessionOutputCtrl:SetItemData(class, data)

    self.ClassName = data.RecipeType
    local l_curLevel = MgrMgr:GetMgr("LifeProfessionMgr").GetLv(self.ClassName)
    local l_careerName = MgrMgr:GetMgr("LifeProfessionMgr").GetCareerName(self.ClassName)

    self.panel.Title.LabText = Lang("LifeProfession_OutList")--"可产出道具列表"
    self.panel.Content.LabText = self.panel.Title.LabText
    self.panel.Level.LabText = Lang("LifeProfession_CareerLv", l_careerName, l_curLevel)--"当前{0}职业等级：Lv.{1}"

    local l_datas = {}
    if self.ClassName == ClassID.Sweet then
        --制药-甜品显示所有道具
        local l_RecipeId = Mgr.GetRowRecipeIDByLv(self.ClassName)
        for i = 0, l_RecipeId.Length - 1 do
            local l_RecipeData = TableUtil.GetRecipeTable().GetRowByID(l_RecipeId[i])
            if l_RecipeData ~= nil then
                local l_awardData = TableUtil.GetAwardTable().GetRowByAwardId(l_RecipeData.ResultID)
                if l_awardData ~= nil then
                    for i = 0, l_awardData.PackIds.Length - 1 do
                        local l_packData = TableUtil.GetAwardPackTable().GetRowByPackId(l_awardData.PackIds[i])
                        if l_packData ~= nil then
                            for j = 0, l_packData.GroupContent.Count - 1 do
                                local l_id = l_packData.GroupContent:get_Item(j,0)
                                if not self:CanDataContain(l_datas, l_id) then
                                    l_datas[#l_datas + 1] = {
                                        ID = l_id,
										IsShowCloseButton = true,
                                    }
                                end
                            end
                        end
                    end
                end
            end
        end
    else
        local l_awardData = TableUtil.GetAwardTable().GetRowByAwardId(data.ResultID)
        if l_awardData ~= nil then
            for i = 0, l_awardData.PackIds.Length-1 do
                local l_packData = TableUtil.GetAwardPackTable().GetRowByPackId(l_awardData.PackIds[i])
                if l_packData ~= nil then
                    for j = 0, l_packData.GroupContent.Count - 1 do
                        local l_id = l_packData.GroupContent:get_Item(j,0)
                        if not self:CanDataContain(l_datas, l_id) then
                            l_datas[#l_datas + 1] = {
                                ID = l_id,
								IsShowCloseButton = true,
                            }
                        end
                    end
                end
            end
        end
    end
    self.ItemPool:ShowTemplates({Datas = l_datas})

end

function LifeProfessionOutputCtrl:CanDataContain(data, id)

    for i = 1,#data do
        if data[i].ID == id then
            return true
        end
    end
    return false

end
--lua custom scripts end
