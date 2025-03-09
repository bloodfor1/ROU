--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/BaseUITemplate"
--lua requires end

--lua model
module("UITemplate", package.seeall)

--lua model end

--lua fields
local super = UITemplate.BaseUITemplate
--lua fields end

--lua class define
---@class AttrRecomItemTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field StarIcon MoonClient.MLuaUICom[]
---@field Select MoonClient.MLuaUICom
---@field SchoolIcon MoonClient.MLuaUICom
---@field Name MoonClient.MLuaUICom
---@field Info MoonClient.MLuaUICom
---@field FeatureTxt MoonClient.MLuaUICom[]
---@field FeatureImg MoonClient.MLuaUICom[]
---@field BG MoonClient.MLuaUICom
---@field AttrInfo MoonClient.MLuaUICom[]

---@class AttrRecomItemTemplate : BaseUITemplate
---@field Parameter AttrRecomItemTemplateParameter

AttrRecomItemTemplate = class("AttrRecomItemTemplate", super)
--lua class define end

--lua functions
function AttrRecomItemTemplate:Init()
    super.Init(self)
    self.featureInfos = {
        { atlas = "Role1", sprite = "UI_Role_Panel_Small_leixing_02.png", text = Lang("SKILL_RECOMMOND_2")},
        { atlas = "Role1", sprite = "UI_Role_Panel_Small_leixing_01.png", text = Lang("SKILL_RECOMMOND_1")},
        { atlas = "Role1", sprite = "UI_Role_Panel_Small_leixing_03.png", text = Lang("SKILL_RECOMMOND_3")},
    }
end --func end
--next--
function AttrRecomItemTemplate:OnDestroy()


end --func end
--next--
function AttrRecomItemTemplate:OnDeActive()


end --func end
--next--
function AttrRecomItemTemplate:OnSetData(data)

    local genreDetailInfo = MgrMgr:GetMgr("RoleInfoMgr").GetGenreDetailInfo(data.recommendId)
    if genreDetailInfo == nil then
        return
    end
    self.Parameter.SchoolIcon:SetSpriteAsync(genreDetailInfo.atlas, genreDetailInfo.sprite)
    self.Parameter.Name.LabText = genreDetailInfo.cname
    self.Parameter.Info.LabText = genreDetailInfo.text1
    for i = 1, 3 do
        if i <= genreDetailInfo.star then
            self.Parameter.StarIcon[i].Img.fillAmount = 1
        else
            self.Parameter.StarIcon[i].Img.fillAmount = 0
        end
    end
    local strTb = string.ro_split(genreDetailInfo.text2, '、')
    local valueTb = Common.Functions.VectorToTable(genreDetailInfo.recommendPoint)
    for i = 1, 4 do
        if i <= table.maxn(strTb) then
            self.Parameter.AttrInfo[i].gameObject:SetActiveEx(true)
            local attrname = MLuaClientHelper.GetOrCreateMLuaUICom(self.Parameter.AttrInfo[i].transform:Find("Image/ItemName1"))
            local attrValue = MLuaClientHelper.GetOrCreateMLuaUICom(self.Parameter.AttrInfo[i].transform:Find("ItemCount1"))
            attrname.LabText = strTb[i]
            attrValue.LabText = valueTb[i]
        else
            self.Parameter.AttrInfo[i].gameObject:SetActiveEx(false)
        end
    end
    local features = Common.Functions.VectorToTable(genreDetailInfo.FeatureText)
    for i, v in ipairs(features) do
        local featureInfo = self.featureInfos[v]
        self.Parameter.FeatureImg[i]:SetSpriteAsync(featureInfo.atlas, featureInfo.sprite)
        self.Parameter.FeatureTxt[i].LabText = featureInfo.text
    end
    self:Select(false)
    self.Parameter.BG:AddClick(function()
        local ui = UIMgr:GetUI(UI.CtrlNames.AddAttrSchools)
        if ui then
            ui:SelectAttr(data)
            self:Select(true)
        end
    end)

end --func end
--next--
function AttrRecomItemTemplate:BindEvents()


end --func end
--next--
--lua functions end

--lua custom scripts
function AttrRecomItemTemplate:Select(flag)
    self.Parameter.Select:SetActiveEx(flag)
end
--lua custom scripts end
return AttrRecomItemTemplate