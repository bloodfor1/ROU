--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/BaseUITemplate"
require "UI/Template/CatCaravanCarriageTem"
--lua requires end

--lua model
module("UITemplate", package.seeall)

--lua model end

--lua fields
local super = UITemplate.BaseUITemplate
--lua fields end

--lua class define
---@class CatCaravanTrainTemParameter.CarriagePrefab
---@field PanelRef MoonClient.MLuaUIPanel
---@field Num MoonClient.MLuaUICom
---@field Icon MoonClient.MLuaUICom
---@field Complete MoonClient.MLuaUICom
---@field Color MoonClient.MLuaUICom
---@field Btn MoonClient.MLuaUICom
---@field Anim MoonClient.MLuaUICom

---@class CatCaravanTrainTemParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field OarAnim MoonClient.MLuaUICom
---@field NoneRt MoonClient.MLuaUICom
---@field None MoonClient.MLuaUICom
---@field FxRt_Yan MoonClient.MLuaUICom
---@field FxRt_Shui MoonClient.MLuaUICom
---@field CatAnim MoonClient.MLuaUICom
---@field Box MoonClient.MLuaUICom
---@field Boat MoonClient.MLuaUICom
---@field bg3 MoonClient.MLuaUICom
---@field bg2 MoonClient.MLuaUICom
---@field bg1 MoonClient.MLuaUICom
---@field CarriagePrefab CatCaravanTrainTemParameter.CarriagePrefab

---@class CatCaravanTrainTem : BaseUITemplate
---@field Parameter CatCaravanTrainTemParameter

CatCaravanTrainTem = class("CatCaravanTrainTem", super)
--lua class define end

--lua functions
function CatCaravanTrainTem:Init()
	
	    super.Init(self)
	    self.Mgr = MgrMgr:GetMgr("CatCaravanMgr")
	    self.isFirst = true
	
end --func end
--next--
function CatCaravanTrainTem:OnDestroy()
	
	    self.CarriageTems = nil
	    if self.ShuiEffectID then
	        self:DestroyUIEffect(self.ShuiEffectID)
	        self.ShuiEffectID = nil
	    end
	    if self.YanEffectID then
	        self:DestroyUIEffect(self.YanEffectID)
	        self.YanEffectID = nil
	    end
	    if self.NoneModel then
	        self:DestroyUIModel(self.NoneModel);
	        self.NoneModel = nil
	    end
	    if self.MoveTween then
	        MUITweenHelper.KillTween(self.MoveTween)
	        self.MoveTween = nil
	    end
	
end --func end
--next--
function CatCaravanTrainTem:OnSetData(data)
	
	    self.isFirst = true
	    self:SetInfo(data)
	
end --func end
--next--
function CatCaravanTrainTem:OnDeActive()
	
	
end --func end
--next--
function CatCaravanTrainTem:BindEvents()
	
	
end --func end
--next--
--lua functions end

--lua custom scripts
function CatCaravanTrainTem:ResetData()
    if self.data == nil then
        return
    end
    local l_oldFull = self.isFull
    self.isFirst = false
    self:SetInfo(self.data)

    --开船啦，污污
    if l_oldFull ~= nil and not l_oldFull and self.isFull then
        self:BoatMove(true)
    end
end

function CatCaravanTrainTem:SetInfo(data)
    self.data = data
    self.netData = data.data
    self.index = data.index
    self.isFull = self.netData.is_full
    self.Parameter.CarriagePrefab.LuaUIGroup.gameObject:SetActiveEx(false)
    self.Parameter.FxRt_Yan:SetActiveEx(false)
    self.Parameter.FxRt_Shui:SetActiveEx(false)
    --创建箱子
    self:CreatCarriage()
    --显示已完成 + 一个猫的模型
    self:ShowNoneCatModel(self.isFull and not self.Mgr.AllFull)
    --显示船
    self.Parameter.Boat:SetActiveEx(not self.isFull)
    --停止船
    self:BoatMove(false)
    --背景替换
    local l_sprite = {
        { "UI_Medal_Img_Bgtu01.png", "UI_Medal_Img_qianjing_a01.png", "UI_Medal_Img_qianjing_a02.png" },
        { "UI_Medal_Img_Bgtu02.png", "UI_Medal_Img_qianjing_b01.png", "UI_Medal_Img_qianjing_b02.png" },
        { "UI_Medal_Img_Bgtu03.png", "UI_Medal_Img_qianjing_c01.png", "UI_Medal_Img_qianjing_c02.png" },
    }
    self.Parameter.bg1:SetSprite("Medal", l_sprite[self.index][1])
    self.Parameter.bg2:SetSprite("Medal", l_sprite[self.index][2])
    self.Parameter.bg3:SetSprite("Medal", l_sprite[self.index][3])
    if self.isFirst then
        --self:BoatEntry()
        self.isFirst = false
    else
        if not self.AnimPlaying then
            self:BoatMove(false)
            self.Parameter.Boat.FxAnim:PlayAll()
        end
    end
end

--显示/隐藏装完货之后的猫头像
function CatCaravanTrainTem:ShowNoneCatModel(l_showNone)
    self.Parameter.None:SetActiveEx(l_showNone)
    if self.NoneModel ~= nil and not l_showNone then
        self:DestroyUIModel(self.NoneModel);
        self.NoneModel = nil
        self.Parameter.NoneRt:SetActiveEx(false)
    end
    if self.NoneModel == nil and l_showNone then
        local l_ModelOrigin = {}
        l_ModelOrigin.prefabPath = "Prefabs/NPC_M_FuMo"
        l_ModelOrigin.rawImage = self.Parameter.NoneRt.RawImg
        l_ModelOrigin.useOutLine = false
        l_ModelOrigin.isCameraMatrixCustom = false
        l_ModelOrigin.defaultAnim = MAnimationMgr:GetClipPath("NPC_M_FuMo_JieMian_Idle")
        self.NoneModel = self:CreateUIModel(l_ModelOrigin)
        self.Parameter.NoneRt:SetActiveEx(false)
        self.NoneModel:AddLoadModelCallback(function(m)
            if self.Parameter == nil or self.Parameter.NoneRt == nil then
                return
            end
            self.Parameter.NoneRt:SetActiveEx(true)
            self.NoneModel.Trans:SetPos(0, -1.5, 0.1470049)
            self.NoneModel.Trans:SetLocalScale(2.5, 2.5, 2.5)
            self.NoneModel.UObj:SetRotEuler(0, 161.1, 0)
        end)
    end
end

--移动/停止船
function CatCaravanTrainTem:BoatMove(b)
    --船体移动
    if self.MoveTween ~= nil then
        MUITweenHelper.KillTween(self.MoveTween)
    end
    if b then
        self.Parameter.Boat:SetActiveEx(true)
        self:ShowNoneCatModel(false)
        self.MoveTween = MUITweenHelper.TweenPos(
                self.Parameter.Boat.gameObject,
                self.Parameter.Boat.transform.localPosition,
                Vector3.New(-1000, -38, 0), 6, function()
                    self.Parameter.Boat:SetActiveEx(not self.isFull)
                    self:ShowNoneCatModel(self.isFull and not self.Mgr.AllFull)
                end)
    else
        self.Parameter.Boat.transform:SetLocalPos(16, -38, 0)
    end

    self:ShowMoveEffect(b)
end

function CatCaravanTrainTem:BoatEntry()
    if self.MoveTween ~= nil then
        MUITweenHelper.KillTween(self.MoveTween)
    end
    if self.AnimPlaying then
        self.AnimPlaying = false
        self.Parameter.Boat.FxAnim:StopAll()
    end
    if not self.Parameter.Boat.gameObject.activeSelf then
        return
    end
    self:ShowNoneCatModel(false)
    self.Parameter.Boat.transform:SetLocalPosX(1000)
    self.MoveTween = MUITweenHelper.TweenPos(
            self.Parameter.Boat.gameObject,
            self.Parameter.Boat.transform.localPosition,
            Vector3.New(16, -38, 0), 6, function()
                self:BoatMove(false)
                if not self.AnimPlaying then
                    self.AnimPlaying = true
                    self:BoatMove(false)
                    self.Parameter.Boat.FxAnim:PlayAll()
                end
            end)
    self:ShowMoveEffect(true)
end

--显示/隐藏烟囱和水花特效
function CatCaravanTrainTem:ShowMoveEffect(b)
    --显示特效烟
    if self.YanEffectID ~= nil and not b then
        self:DestroyUIEffect(self.YanEffectID)
        self.YanEffectID = nil
        self.Parameter.FxRt_Yan:SetActiveEx(false)
    end
    if self.YanEffectID == nil and b then
        self.Parameter.FxRt_Yan:SetActiveEx(false)
        local l_fxData = {}
        l_fxData.rawImage = self.Parameter.FxRt_Yan.RawImg
        l_fxData.loadedCallback = function(a)
            self.Parameter.FxRt_Yan:SetActiveEx(true)
        end
        self.YanEffectID = self:CreateUIEffect("Effects/Prefabs/Creature/Ui/Fx_Ui_Cat_Chimney", l_fxData)

    end

    --显示特效水
    if self.ShuiEffectID ~= nil and not b then
        self:DestroyUIEffect(self.ShuiEffectID)
        self.ShuiEffectID = nil
        self.Parameter.FxRt_Shui:SetActiveEx(false)
    end
    if self.ShuiEffectID == nil and b then
        self.Parameter.FxRt_Shui:SetActiveEx(false)
        local l_fxData = {}
        l_fxData.rawImage = self.Parameter.FxRt_Shui.RawImg
        l_fxData.loadedCallback = function(a)
            self.Parameter.FxRt_Shui:SetActiveEx(true)
        end
        self.ShuiEffectID = self:CreateUIEffect("Effects/Prefabs/Creature/Ui/Fx_Ui_Spray_01", l_fxData)

    end

    --轮子
    self.Parameter.OarAnim.SpineAnim.Loop = true
    self.Parameter.OarAnim.SpineAnim.AnimationName = b and "RUN" or "IDLE"
end

--创建箱子
function CatCaravanTrainTem:CreatCarriage()
    self.CarriageTems = self.CarriageTems or {}
    local l_boxObj = self.Parameter.Box.transform
    local l_shouCount = math.min(#self.netData.seat_list, 5)
    l_shouCount = math.min(l_shouCount, l_boxObj.childCount)

    --显示icon
    for i = 1, #self.CarriageTems do
        --self.CarriageTems[i]:ResetData()
        self:UninitTemplate(self.CarriageTems[i])
    end
    self.CarriageTems = {}
    for i = #self.CarriageTems + 1, l_shouCount do
        self.CarriageTems[i] = self:NewTemplate("CatCaravanCarriageTem", {
            TemplatePrefab = self.Parameter.CarriagePrefab.LuaUIGroup.gameObject,
            TemplateParent = l_boxObj:GetChild(i - 1),
            Data = {
                data = self.netData.seat_list[i],
                tData = self.netData,
                index = i,
            }
        })
    end

    --显示/隐藏箱子
    for i = 0, l_boxObj.childCount - 1 do
        l_boxObj:GetChild(i).gameObject:SetActiveEx(i < l_shouCount)
    end
end
--lua custom scripts end
return CatCaravanTrainTem