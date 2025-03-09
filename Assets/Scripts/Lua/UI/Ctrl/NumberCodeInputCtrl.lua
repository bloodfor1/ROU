--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/NumberCodeInputPanel"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua fields
local super = UI.UIBaseCtrl
--next--
--lua fields end

--lua class define
NumberCodeInputCtrl = class("NumberCodeInputCtrl", super)
--lua class define end

--lua functions
function NumberCodeInputCtrl:ctor()

	super.ctor(self, CtrlNames.NumberCodeInput, UILayer.Tips, nil, ActiveType.Standalone)

end --func end
--next--
function NumberCodeInputCtrl:Init()

	self.panel = UI.NumberCodeInputPanel.Bind(self)
	super.Init(self)

end --func end
--next--
function NumberCodeInputCtrl:Uninit()

	super.Uninit(self)
	self.panel = nil

end --func end
--next--
function NumberCodeInputCtrl:OnActive()

    self.panel.Floor.gameObject:SetActiveEx(true)
    self.panel.Floor.Listener.onClick=function(obj,data)
        self.panel.Floor.gameObject:SetActiveEx(false)
        UIMgr:DeActiveUI(CtrlNames.NumberCodeInput)
        MLuaClientHelper.ExecuteClickEvents(data.position,CtrlNames.NumberCodeInput)
    end

    self.panel.KeyDel:AddClick(function()
        self:SubValue()
    end)
    self.panel.KeyOk:AddClick(function()
        local l_value = self.value
        self.value = nil
        self:SetValue(l_value)
        UIMgr:DeActiveUI(CtrlNames.NumberCodeInput)
    end)
    self.panel.Key0:AddClick(function()
        self:AddValue("0")
    end)
    self.panel.Key1:AddClick(function()
        self:AddValue("1")
    end)
    self.panel.Key2:AddClick(function()
        self:AddValue("2")
    end)
    self.panel.Key3:AddClick(function()
        self:AddValue("3")
    end)
    self.panel.Key4:AddClick(function()
        self:AddValue("4")
    end)
    self.panel.Key5:AddClick(function()
        self:AddValue("5")
    end)
    self.panel.Key6:AddClick(function()
        self:AddValue("6")
    end)
    self.panel.Key7:AddClick(function()
        self:AddValue("7")
    end)
    self.panel.Key8:AddClick(function()
        self:AddValue("8")
    end)
    self.panel.Key9:AddClick(function()
        self:AddValue("9")
    end)
end --func end
--next--
function NumberCodeInputCtrl:OnDeActive()

    self.ValueChangeCall = nil

end --func end
--next--
function NumberCodeInputCtrl:Update()


end --func end





--next--
function NumberCodeInputCtrl:BindEvents()


end --func end

--next--
--lua functions end

--lua custom scripts
function NumberCodeInputCtrl:InitInput(pos,lenght,defValue,call)
    if not self.panel then
        return
    end

    self.value = ""
    self.Lenght = lenght
    self.ValueChangeCall = call
    self.panel.Main.gameObject:SetPos(pos)
    self:SetValue(defValue or "");
end

function NumberCodeInputCtrl:SetValue(st)
    if self.value ~= st then
        self.value = st

        local num = 0
        if not string.ro_isEmpty(self.value) then
            num = tonumber(self.value)
        end
        if self.ValueChangeCall then
            self.ValueChangeCall(num,st)
        end
    end
end

function NumberCodeInputCtrl:AddValue(st)
    if #self.value < self.Lenght then
        self:SetValue(self.value..st)
    end
end

function NumberCodeInputCtrl:SubValue()
    if #self.value > 0 then
        if #self.value == 1 then
            self:SetValue("")
        else
            self:SetValue(string.sub(self.value, 1, #self.value-1))
        end
    end
end
--lua custom scripts end
