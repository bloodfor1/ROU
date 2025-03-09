--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseHandler"
require "UI/Panel/RecommendPanel"
--lua requires end

--lua model
module("UI", package.seeall)

--lua model end

--lua fields
local super = UI.UIBaseHandler
--lua fields end

--lua class define
RecommendHandler = class("RecommendHandler", super)
--lua class define end

--lua functions
function RecommendHandler:ctor()

    super.ctor(self, HandlerNames.Recommend, 0)

end --func end
--next--
function RecommendHandler:Init()

    self.panel = UI.RecommendPanel.Bind(self)
    super.Init(self)
    self.TogIndex = 0
    self.panel.ButtonList.TogPanel.OnTogOn = function(index)
        self:_onTogPanel(index)
    end
    self._roleNurturanceTem = nil

end --func end
--next--
function RecommendHandler:Uninit()

    super.Uninit(self)
    self.panel = nil
    self._roleNurturanceTem = nil

end --func end
--next--
function RecommendHandler:OnActive()

    local l_indexs = {}
    table.insert(l_indexs, 1)
    table.insert(l_indexs, 2)
    --table.insert(l_indexs,3)
    local l_names = {}
    table.insert(l_names, Lang("Recommend_RoleNurturanceTitle"))
    table.insert(l_names, Lang("Recommend_RoleNurturanceText"))
    --table.insert(l_names,"养成推荐1")
    self.panel.ButtonList.TogPanel:AddTogGroup(l_indexs, l_names)
    --local l_indexs={}
    --table.insert(l_indexs,11)
    --table.insert(l_indexs,12)
    --table.insert(l_indexs,13)
    --local l_names={}
    --table.insert(l_names,"养成小贴士11")
    --table.insert(l_names,"养成推荐12")
    --table.insert(l_names,"养成推荐13")
    --self.panel.ButtonList.TogPanel:AddTogGroup(l_indexs,l_names)
    self.panel.ButtonList.TogPanel:SetTogOn(2)
    self.panel.ButtonList.TogPanel:SetDefaultSelectIndexOnParentToggle(1)

end --func end
--next--
function RecommendHandler:OnDeActive()


end --func end
--next--
function RecommendHandler:Update()


end --func end
--next--
function RecommendHandler:BindEvents()


end --func end
--next--
function RecommendHandler:OnShow()
    self:RefreshPanel()

end --func end
--next--
function RecommendHandler:OnHide()


end --func end
--next--
--lua functions end

--lua custom scripts
local RoleNurturanceTemIndex = 2

function RecommendHandler:_onTogPanel(index)
    self.TogIndex = index
    self:RefreshPanel()
end

function RecommendHandler:RefreshPanel()
    if self.TogIndex == RoleNurturanceTemIndex then
        if self._roleNurturanceTem == nil then
            self._roleNurturanceTem = self:NewTemplate("RoleNurturanceTem", {
                TemplateParent = self.panel.Right.transform,
            })
        end
        self._roleNurturanceTem:SetData({})
    end
end
--lua custom scripts end
return RecommendHandler