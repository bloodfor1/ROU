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
Mercenary = class("Mercenary", super)
--lua class define end

--lua functions
function Mercenary:Init()
	
	super.Init(self)
	
end --func end
--next--
function Mercenary:OnDestroy()
	
	
end --func end
--next--
function Mercenary:OnDeActive()
	
	
end --func end
--next--
function Mercenary:OnSetData(data)
	
	
end --func end

--next--
--lua functions end

--lua custom scripts

--lua custom scripts end
return Mercenary