--this file is gen by script
--you can edit this file in custom part

--lua requires
require "UI/UIBaseCtrl"
require "UI/Panel/EnchantInheritPanel"
--lua requires end

--lua model
module("UI", package.seeall)
--lua model end

--lua fields
local super = UI.UIBaseCtrl
--next--
--lua fields end

--lua class define
EnchantInheritCtrl = class("EnchantInheritCtrl", super)
--lua class define end

--lua functions
function EnchantInheritCtrl:ctor()

    super.ctor(self, CtrlNames.EnchantInherit, UILayer.Function, nil, ActiveType.Exclusive)

end --func end
--next--
function EnchantInheritCtrl:Init()

    self.panel = UI.EnchantInheritPanel.Bind(self)
    super.Init(self)

end --func end
--next--
function EnchantInheritCtrl:Uninit()

    super.Uninit(self)
    self.panel = nil

end --func end
--next--
function EnchantInheritCtrl:OnActive()


end --func end
--next--
function EnchantInheritCtrl:OnDeActive()


end --func end
--next--
function EnchantInheritCtrl:Update()


end --func end

--next--
function EnchantInheritCtrl:BindEvents()
end --func end

--next--
--lua functions end

--lua custom scripts

--lua custom scripts end
return EnchantInheritCtrl