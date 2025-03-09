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
---@class TalkDlgBtnTemplateParameter
---@field PanelRef MoonClient.MLuaUIPanel
---@field Text MoonClient.MLuaUICom
---@field Raycast MoonClient.MLuaUICom
---@field Mask MoonClient.MLuaUICom
---@field Image MoonClient.MLuaUICom
---@field BtnTpl MoonClient.MLuaUICom
---@field Animation MoonClient.MLuaUICom

---@class TalkDlgBtnTemplate : BaseUITemplate
---@field Parameter TalkDlgBtnTemplateParameter

TalkDlgBtnTemplate = class("TalkDlgBtnTemplate", super)
--lua class define end

--lua functions
function TalkDlgBtnTemplate:Init()
	
    super.Init(self)
    self.co = nil
	
end --func end
--next--
function TalkDlgBtnTemplate:BindEvents()
	
	local l_mgr = MgrMgr:GetMgr("NpcTalkDlgMgr")
    self:BindEvent(l_mgr.EventDispatcher, l_mgr.ON_NOTIFY_BTN_SHAKE, function()
        self:ShowShake()
    end)
	
end --func end
--next--
function TalkDlgBtnTemplate:OnDestroy()
	
	
end --func end
--next--
function TalkDlgBtnTemplate:OnDeActive()
	
    self:ClearTimer()
	
end --func end
--next--
function TalkDlgBtnTemplate:OnSetData(data)
	
    self.Parameter.Image.gameObject:SetActiveEx(false)
    local l_setSpriteCallback = function()
        self.Parameter.Image.gameObject:SetActiveEx(true)
    end
	local NPC_SELECT_TYPE = MgrMgr:GetMgr("NpcMgr").NPC_SELECT_TYPE
    local l_callback = data.callback
    self.Parameter.Text.LabText = data.selectName
    
    if data.selectType == NPC_SELECT_TYPE.TASK then
        self.Parameter.Image:SetSpriteAsync("NewTalk", "UI_NewTalk_Btn_03.png", l_setSpriteCallback)
        self.Parameter.Text.LabColor = RoColor.GetFontColor(RoColorTag.None)
    elseif data.selectType == NPC_SELECT_TYPE.FUNC then
        self.Parameter.Image:SetSpriteAsync("NewTalk", "UI_NewTalk_Btn_02.png", l_setSpriteCallback)
        self.Parameter.Text.LabColor = RoColor.GetFontColor(RoColorTag.None)
    else
        self.Parameter.Image:SetSpriteAsync("NewTalk", "UI_NewTalk_Btn_03.png", l_setSpriteCallback)
        self.Parameter.Text.LabColor = RoColor.GetFontColor(RoColorTag.None)
    end
    self.initPosXOffset = 0
    self:ClearTimer()
    local l_preferredWidth = self.Parameter.Text:GetText().preferredWidth
    local l_maskWidth = self.Parameter.Mask.RectTransform.sizeDelta.x - self.initPosXOffset
    MLuaCommonHelper.SetRectTransformPosX(self.Parameter.Text.gameObject, self.initPosXOffset)
    if l_preferredWidth > l_maskWidth then
        self.offset = l_preferredWidth - l_maskWidth
        self:PlayTextForwardStep1()
    end
    self.Parameter.Raycast:AddClick(function()
        local l_tmpCallback = l_callback
        l_callback = nil
        MgrMgr:GetMgr("NpcTalkDlgMgr").DoSelectAction(l_tmpCallback, data.hideAfterSelect)
    end)
    local anim = self.Parameter.Animation:GetComponent("Animator")
    if anim ~= nil then
        anim.enabled = false
        MLuaCommonHelper.SetRectTransformPos(self.Parameter.Animation.gameObject, 0, 0)
    end
	
end --func end
--next--
--lua functions end

--lua custom scripts
function TalkDlgBtnTemplate:ClearTimer()

    if self.co ~= nil then
        coroutine.stop(self.co)
        self.co = nil
    end
end

function TalkDlgBtnTemplate:PlayTextForwardStep1()

    self:ClearTimer()
    MLuaCommonHelper.SetRectTransformPosX(self.Parameter.Text.gameObject, self.initPosXOffset)
    
    self.co = coroutine.start(function()
        coroutine.wait(MgrMgr:GetMgr("NpcTalkDlgMgr").TalkDlgBtnMoveStay)
        self:PlayTextForwardStep2()
    end)
end

function TalkDlgBtnTemplate:PlayTextForwardStep2()

    self:ClearTimer()

    self.co = coroutine.start(function()
        local l_trans = self.Parameter.Text.Transform
        local l_obj = l_trans.gameObject
        local l_offset = self.offset - l_trans.localPosition.x
        if l_offset < 0 then
            l_offset = 0
        end

        local l_moveTime = l_offset / MgrMgr:GetMgr("NpcTalkDlgMgr").TalkDlgBtnMoveSpeed
        local l_startTime = Time.realtimeSinceStartup
        if l_moveTime > 0 then
            local l_flag = false
            repeat
                coroutine.step(1)
                local l_percent = (Time.realtimeSinceStartup - l_startTime) / l_moveTime
                if l_percent >= 1 then
                    l_percent = 1
                    l_flag = true
                end
                MLuaCommonHelper.SetRectTransformPosX(l_obj, -self.offset * l_percent + self.initPosXOffset)
            until l_flag

            coroutine.step(1)
        end

        self:PlayTextForwardStep3()
    end)
end

function TalkDlgBtnTemplate:PlayTextForwardStep3()

    self:ClearTimer()
    self.co = coroutine.start(function()
        coroutine.wait(MgrMgr:GetMgr("NpcTalkDlgMgr").TalkDlgBtnMoveExit)
        self:PlayTextForwardStep1()
    end)
end


function TalkDlgBtnTemplate:ShowShake()
    local anim = self.Parameter.Animation:GetComponent("Animator")
    if anim ~= nil then
        anim.enabled = true
        anim:Play("Jitter", -1, 0)
    end

end
--lua custom scripts end
return TalkDlgBtnTemplate