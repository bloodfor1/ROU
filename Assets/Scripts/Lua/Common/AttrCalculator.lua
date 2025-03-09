module("Common", package.seeall)
require "attribute_calculator"
AttrCalculator = class("AttrCalculator")

function AttrCalculator:LuaGetAttr(key)
     return self[key] or 0
end

function AttrCalculator:LuaSetAttr(key, value)
	if value then
    	self[key] = math.floor(value)
    end
end

function AttrCalculator:CalculateAttribute()
	AttributeCalculator.CalculateAttribute(nil, self)
end

return AttrCalculator