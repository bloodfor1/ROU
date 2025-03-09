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
--next--
--lua fields end

--lua class define
BattleLogPanel = class("BattleLogPanel", super)
--lua class define end

--lua functions
function BattleLogPanel:Init()
	
	super.Init(self)
	
end --func end
--next--
function BattleLogPanel:OnDestroy()
	
	
end --func end
--next--
function BattleLogPanel:OnDeActive()
	
	
end --func end
--next--
function BattleLogPanel:OnSetData(data)
	
	
end --func end
--next--
--lua functions end

--lua custom scripts

--lua custom scripts end
return BattleLogPanel