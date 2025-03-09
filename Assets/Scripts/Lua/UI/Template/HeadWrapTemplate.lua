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
---@class HeadWrapTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field Txt_Name_1 MoonClient.MLuaUICom
---@field Txt_lv MoonClient.MLuaUICom
---@field TemplateSelf MoonClient.MLuaUICom
---@field Panel_Head2 MoonClient.MLuaUICom
---@field Img_Pro_1 MoonClient.MLuaUICom
---@field Head2D MoonClient.MLuaUICom
---@field Btn_Member2 MoonClient.MLuaUICom
---@field Bg MoonClient.MLuaUICom

---@class HeadWrapTemplate : BaseUITemplate
---@field Parameter HeadWrapTemplateParameter

HeadWrapTemplate = class("HeadWrapTemplate", super)
--lua class define end

--lua functions
function HeadWrapTemplate:Init()
    super.Init(self)
    ---@type HeadTemplateParam
    self._data = nil
    self.C_SRT_NIL = "NIL"
    self.C_DEFAULT_ATLAS = "Common"
    self.C_PLAYER_INFO_KEY_MAP = {
        ["FashionID"] = { "Fashion", "FashionFromBag" },
        ["HelmetID"] = { "OrnamentHead", "OrnamentHeadFromBag" },
        ["FaceMaskID"] = { "OrnamentFace", "OrnamentFaceFromBag" },
        ["MouthGearID"] = { "OrnamentMouth", "OrnamentMouthFromBag" },
    }

    self.Parameter.Head2D:SetActiveEx(true)
end --func end
--next--
function HeadWrapTemplate:BindEvents()
    -- do nothing
end --func end
--next--
function HeadWrapTemplate:OnDestroy()
    self.Parameter.Btn_Member2:ClearAll()
end --func end
--next--
function HeadWrapTemplate:OnDeActive()
    -- do nothing
end --func end
--next--
function HeadWrapTemplate:OnSetData(data)
    self:_setData(data)
end --func end
--next--
--lua functions end

--lua custom scripts
---@param data HeadTemplateParam
function HeadWrapTemplate:_setData(data)
    if nil == data then
        logError("[HeadWrap] invalid param, set head failed")
        return
    end

    self.Parameter.TemplateSelf.Transform.localPosition = Vector3.zero
    self._data = self:_mergeParam(data)
    self:_setMergedData(self._data)
end

---@param data HeadTemplateParam
function HeadWrapTemplate:_removeNilData(data)
    if nil == data then
        return
    end

    for key, value in pairs(data) do
        if self.C_SRT_NIL == value then
            data[key] = nil
        end
    end
end

--- 合并数据，保证参数当中不包括任何自定义数据
---@param data HeadTemplateParam
---@return HeadTemplateParam
function HeadWrapTemplate:_mergeParam(data)
    ---@type HeadTemplateParam
    local defaultParam = {
        ShowName = false,
        ShowMask = false,
        ShowLv = false,
        ShowProfession = false,
        ShowBg = true,
        ShowFrame = true,
        IsPlayerSelf = false,
        Name = "",
        Level = 0,
        Profession = 0,
        IsMale = true,
        HeadIconID = 0,
        EyeID = 0,
        EyeColorID = 0,
        HairID = 0,
        FashionID = 0,
        FrameID = 0,
        HelmetID = 0,
        FaceMaskID = 0,
        MouthGearID = 0,
        MonsterHeadID = 0,
        NpcHeadID = 0,
        Entity = self.C_SRT_NIL,
        EquipData = self.C_SRT_NIL,
        OnClick = self.C_SRT_NIL,
        OnClickSelf = self.C_SRT_NIL,
        OnClickEvent = self.C_SRT_NIL,
    }

    if nil == data then
        self:_removeNilData(defaultParam)
        return defaultParam
    end

    if data.IsPlayerSelf then
        defaultParam.IsPlayerSelf = true
        defaultParam.IsMale = MPlayerInfo.IsMale
        defaultParam.Name = MPlayerInfo.Name
        defaultParam.Profession = MPlayerInfo.ProID
        defaultParam.Level = MPlayerInfo.Lv
        defaultParam.HeadIconID = MPlayerInfo.HeadID
        defaultParam.EyeID = MPlayerInfo.EyeID
        defaultParam.EyeColorID = MPlayerInfo.EyeColorID
        defaultParam.HairID = MPlayerInfo.HairStyle
        defaultParam.FrameID = MPlayerInfo.FrameID
        self:_setSelfData(defaultParam)
    end

    for key, value in pairs(defaultParam) do
        local realParam = data[key]
        if nil ~= realParam then
            defaultParam[key] = realParam
        end
    end

    self:_removeNilData(defaultParam)
    return defaultParam
end

---@param data HeadTemplateParam
function HeadWrapTemplate:_setSelfData(data)
    if nil == data then
        return
    end

    for key, value in pairs(self.C_PLAYER_INFO_KEY_MAP) do
        data[key] = self:_getValidIDFromPlayer(key)
    end
end

---@param key string
---@return number
function HeadWrapTemplate:_getValidIDFromPlayer(key)
    local data = self.C_PLAYER_INFO_KEY_MAP[key]
    if nil == data then
        logError("[HeadWrap] invalid key: " .. tostring(key))
    end

    for i = 1, #data do
        local singleStrKey = data[i]
        local singleValue = MPlayerInfo[singleStrKey]
        if nil == singleValue then
            logError("[HeadWrap] invalid key: " .. tostring(singleStrKey))
        elseif 0 < singleValue then
            return singleValue
        else
            -- do nothing
        end
    end

    return 0
end

---@param data HeadTemplateParam
---@return EquipData
function HeadWrapTemplate:_genEquipData(data)
    if nil == data then
        logError("[HeadTemplate] invalid data")
        return nil
    end

    local equipData = MoonClient.MEquipData.New()
    equipData.IsMale = data.IsMale
    equipData.ProfessionID = data.Profession
    equipData.HairStyleID = data.HairID
    equipData.EyeID = data.EyeID
    equipData.EyeColorID = data.EyeColorID
    equipData.FashionItemID = data.FashionID
    equipData.HeadID = data.HeadIconID
    equipData.OrnamentHeadItemID = data.HelmetID
    equipData.OrnamentFaceItemID = data.FaceMaskID
    equipData.OrnamentMouthItemID = data.MouthGearID
    equipData.IconFrameID = data.FrameID
    return equipData
end

--- 这个函数当中参数一定是有默认值的，不需要所有的参数都判断是否为空
---@param data HeadTemplateParam
function HeadWrapTemplate:_setMergedData(data)
    if nil == data then
        logError("[HeadTemplate] invalid data")
        return
    end

    if 0 < data.HeadIconID then
        self.Parameter.Head2D.Head2D:SetRoleHead(data.HeadIconID)
    else
        if nil ~= data.Entity then
            self.Parameter.Head2D.Head2D:SetHead(data.Entity)
        elseif nil ~= data.EquipData then
            self.Parameter.Head2D.Head2D:SetRoleHead(data.EquipData)
        elseif 0 < data.MonsterHeadID then
            self.Parameter.Head2D.Head2D:SetMonsterHead(data.MonsterHeadID)
        elseif 0 < data.NpcHeadID then
            self.Parameter.Head2D.Head2D:SetNPCHead(data.NpcHeadID)
        else
            local targetEquipData = self:_genEquipData(data)
            if nil == targetEquipData then
                logError("[HeadTemplate] invalid data")
                return
            end

            self.Parameter.Head2D.Head2D:SetRoleHead(targetEquipData)
        end
    end

    self.Parameter.Bg:SetActiveEx(data.ShowBg)
    self.Parameter.Img_Pro_1:SetActiveEx(data.ShowProfession)
    self.Parameter.Txt_Name_1:SetActiveEx(data.ShowName)
    self.Parameter.Txt_lv:SetActiveEx(data.ShowLv)
    self.Parameter.Head2D.Head2D:UseMask(data.ShowMask)
    self.Parameter.Head2D.Head2D:SetFrameActive(data.ShowFrame)
    if 0 < data.FrameID and data.ShowFrame then
        self.Parameter.Head2D.Head2D:SetFrame(data.FrameID)
    end

    if data.ShowProfession then
        local atlasName, spriteName = self:_getProfessionIconData(data.Profession)
        if nil ~= atlasName and nil ~= spriteName then
            self.Parameter.Img_Pro_1:SetSpriteAsync(atlasName, spriteName)
        end
    end

    if data.ShowName then
        self.Parameter.Txt_Name_1.LabText = tostring(data.Name)
    end

    if data.ShowLv then
        self.Parameter.Txt_lv.LabText = tostring(data.Level)
    end

    self.Parameter.Btn_Member2:ClearAll()
    if nil ~= data.OnClick then
        self.Parameter.Btn_Member2:AddClickWithLuaSelf(data.OnClick, data.OnClickSelf)
    end

    if nil ~= data.OnClickEvent then
        self.Parameter.Btn_Member2.Listener:SetActionClick(data.OnClickEvent, data.OnClickSelf)
    end
end

---@return string, string
function HeadWrapTemplate:_getProfessionIconData(proID)
    local professionConfig = TableUtil.GetProfessionTable().GetRowById(proID, false)
    if nil == professionConfig then
        return nil, nil
    end

    return self.C_DEFAULT_ATLAS, professionConfig.ProfessionIcon
end
--lua custom scripts end
return HeadWrapTemplate