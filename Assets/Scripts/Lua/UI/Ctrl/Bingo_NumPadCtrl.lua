--this file is gen by script
--you can edit this file in custom part


--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/Bingo_NumPadPanel"
--lua requires end

--lua model
module("UI", package.seeall)

--lua model end

--lua fields
local super = UI.UIBaseCtrl
--lua fields end

--lua class define
Bingo_NumPadCtrl = class("Bingo_NumPadCtrl", super)
--lua class define end

--lua functions
function Bingo_NumPadCtrl:ctor()
	
	super.ctor(self, CtrlNames.Bingo_NumPad, UILayer.Tips, nil, ActiveType.Standalone)

    self.GroupMaskType = GroupMaskType.Show
    self.MaskColor=BlockColor.Dark
	
end --func end
--next--
function Bingo_NumPadCtrl:Init()

	self.panel = UI.Bingo_NumPadPanel.Bind(self)
	super.Init(self)

    self.numIndex = 1

    self.panel.ButtonClose:AddClick(function()
        UIMgr:DeActiveUI(UI.CtrlNames.Bingo_NumPad)
    end)

    self.panel.Btn_Cancel:AddClick(function()
        UIMgr:DeActiveUI(UI.CtrlNames.Bingo_NumPad)
    end)

    self.panel.Btn_Determine:AddClick(function()
        if self.panel.InputField.Input.text == "" then
            MgrMgr:GetMgr("TipsMgr").ShowNormalTips(Lang("BINGO_NUM_INPUT"))
            return
        end
        MgrMgr:GetMgr("BingoMgr").GuessNum(self.numIndex, tonumber(self.panel.InputField.Input.text))
        UIMgr:DeActiveUI(UI.CtrlNames.Bingo_NumPad)
    end)

    self.panel.InputField.Input.onValueChanged:AddListener(function()
        if self.panel.InputField.Input.text ~= "" then
            local l_inputNum = tonumber(self.panel.InputField.Input.text) or 0
            local l_validNum = MgrMgr:GetMgr("BingoMgr").GetValidNum(l_inputNum)
            if l_inputNum ~= l_validNum then
                self.panel.InputField.Input.text = l_validNum
            end
        end
    end)

    self.panel.del:AddClick(function()
        self:DelNum()
    end)

    for i = 1, 10 do
        self.panel.Num[i]:AddClick(function()
            self:AddNum(i%10)
        end)
    end

    self.panel.Tips.LabText = Lang("BINGO_PAD_TIP", MGlobalConfig:GetInt("BingoGuessCD"))
    self.panel.NumRangeTip.LabText = Lang("BINGO_NUM_RANGE", 1, MGlobalConfig:GetInt("BingoNumberArea"))
end --func end
--next--
function Bingo_NumPadCtrl:Uninit()
	
	super.Uninit(self)
	self.panel = nil
	
end --func end
--next--
function Bingo_NumPadCtrl:OnActive()
    if self.uiPanelData and self.uiPanelData.numIndex then
        self.numIndex = self.uiPanelData.numIndex
    end
end --func end
--next--
function Bingo_NumPadCtrl:OnDeActive()
	
	
end --func end
--next--
function Bingo_NumPadCtrl:Update()
	
	
end --func end
--next--
function Bingo_NumPadCtrl:BindEvents()
	
	
end --func end
--next--
--lua functions end

--lua custom scripts

function Bingo_NumPadCtrl:AddNum(num)
    self.panel.InputField.Input.text = self.panel.InputField.Input.text .. tostring(num)
end

function Bingo_NumPadCtrl:DelNum()
    self.panel.InputField.Input.text = string.sub(self.panel.InputField.Input.text, 1, -2)
end

--lua custom scripts end
return Bingo_NumPadCtrl