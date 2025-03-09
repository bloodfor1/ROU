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
---@class ScenarioBubbleTemParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field Main MoonClient.MLuaUICom
---@field Text MoonClient.MLuaUICom
---@field Emoji MoonClient.MLuaUICom

---@class ScenarioBubbleTem : BaseUITemplate
---@field Parameter ScenarioBubbleTemParameter

ScenarioBubbleTem = class("ScenarioBubbleTem", super)
--lua class define end

--lua functions
function ScenarioBubbleTem:Init()
	
	    super.Init(self)
	    self.Parameter.Main.CanvasGroup.alpha = 0
	    self.Parameter.Emoji.CanvasGroup.alpha = 0
	    self.fx_scale = MGlobalConfig:GetFloat("ExpressionListScale", 1)
	
end --func end
--next--
function ScenarioBubbleTem:OnDestroy()
	
	    if self.Cor then
	        MgrMgr:GetMgr("CoroutineMgr"):removeCo(self.Cor)
	        self.Cor = nil
	    end
	    if self.EmojiCor then
	        MgrMgr:GetMgr("CoroutineMgr"):removeCo(self.EmojiCor)
	        self.EmojiCor = nil
	    end
	    if self.Tween then
	        MUITweenHelper.KillTween(self.Tween)
	        self.Tween = nil
	    end
	    if self.EmojiTween then
	        MUITweenHelper.KillTween(self.EmojiTween)
	        self.EmojiTween = nil
	    end
	        if self.rewardFx then
	            self:DestroyUIEffect(self.rewardFx)
	            self.rewardFx = nil
	        end
	
end --func end
--next--
function ScenarioBubbleTem:OnDeActive()
	
	
end --func end
--next--
function ScenarioBubbleTem:OnSetData(data)
	
	
end --func end
--next--
function ScenarioBubbleTem:BindEvents()
	
	
end --func end
--next--
--lua functions end

--lua custom scripts
function ScenarioBubbleTem:ctor(data)
	if data==nil then
		data={}
	end
	data.TemplatePath="UI/Prefabs/ScenarioBubbleTem"
	super.ctor(self,data)
end

function ScenarioBubbleTem:SetFontSize(size)
    self.Parameter.Text:GetText().fontSize = size
end

function ScenarioBubbleTem:Chat(Content,ShowTime)
    local l_content = Content or ""
    --动态表情替换
    l_content = MoonClient.DynamicEmojHelp.ReplaceInputTextEmojiContent(l_content)
    self.Parameter.Text.LabText = l_content

    local l_canShow = not string.ro_isEmpty(l_content)
    local l_showTime = ShowTime or 3

    if self.Cor then
        MgrMgr:GetMgr("CoroutineMgr"):removeCo(self.Cor)
        self.Cor = nil
    end

    self.Cor= MgrMgr:GetMgr("CoroutineMgr"):addCo(function()

        self:ChatTweenToAlpha(l_canShow and 1 or 0, 0.3)

        if l_showTime > 0 then
            AwaitTime(l_showTime)
        end

        if l_canShow then
            self:ChatTweenToAlpha(0,0.3)
        end
    end)
end

function ScenarioBubbleTem:Emoji(EmojiID,ShowTime)

    local l_row = TableUtil.GetShowExpressionTable().GetRowByID(EmojiID)
    local l_canShow = l_row ~= nil
    local l_showTime = ShowTime or 3

    -- MLuaCommonHelper.SetLocalScale(self.Parameter.LuaUIGroup.gameObject, 0.9, 0.9, 1)
    if l_canShow then
    	local l_fxId = l_row.FxID
    	local l_fxData = {}
        l_fxData.rawImage = self.Parameter.Emoji.RawImg
        l_fxData.playTime = -1
        local l_zero_rotation = Quaternion.Euler(0, 0, 0)
        l_fxData.rotation = l_zero_rotation

        local l_com_face_ctrl = nil
        l_fxData.loadedCallback = function(go)
        	l_com_face_ctrl = go:GetComponent("FaceToCameraObjPrepareData")
        	if l_com_face_ctrl then
        		l_com_face_ctrl:CustomActive(false)
                local l_objs = l_com_face_ctrl.FaceToCameraObjs
                for i = 0, l_objs.Length - 1 do
                    l_objs[i].transform.localRotation = l_zero_rotation
                end
        	end
        end

        l_fxData.destroyHandler = function()
        	if l_com_face_ctrl then
        		l_com_face_ctrl:CustomActive(true)
        	end
        end

        if self.rewardFx then
            self:DestroyUIEffect(self.rewardFx)
            self.rewardFx = nil
        end

        self.rewardFx = self:CreateUIEffect(l_fxId, l_fxData)
        
    end


    if self.EmojiCor then
        MgrMgr:GetMgr("CoroutineMgr"):removeCo(self.EmojiCor)
        self.EmojiCor = nil
    end

    self.EmojiCor= MgrMgr:GetMgr("CoroutineMgr"):addCo(function()

        self:EmojiTweenToAlpha(l_canShow and 1 or 0, 0.3)

        if l_showTime > 0 then
            AwaitTime(l_showTime)
        end

        if l_canShow then
            self:EmojiTweenToAlpha(0,0.3)
        end

    end)
end


function ScenarioBubbleTem:ChatTweenToAlpha(alpha, time)
    if self.Tween then
        MUITweenHelper.KillTween(self.Tween)
        self.Tween = nil
    end

    if self.Parameter.Main.CanvasGroup.alpha ~= alpha then
        self.Tween = MUITweenHelper.TweenAlpha(
            self.Parameter.Main.gameObject,
            self.Parameter.Main.CanvasGroup.alpha, alpha, time)
    end
end
function ScenarioBubbleTem:EmojiTweenToAlpha(alpha, time)
    if self.EmojiTween then
        MUITweenHelper.KillTween(self.EmojiTween)
        self.EmojiTween = nil
    end

    if self.Parameter.Emoji.CanvasGroup.alpha ~= alpha then
        self.EmojiTween = MUITweenHelper.TweenAlpha(
            self.Parameter.Emoji.gameObject,
            self.Parameter.Emoji.CanvasGroup.alpha, alpha, time)
    end
end
--lua custom scripts end
return ScenarioBubbleTem