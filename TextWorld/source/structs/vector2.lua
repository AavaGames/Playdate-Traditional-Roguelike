--[[
	
	Made by Hasnain Raza
	Additions by Philip Fertsman (@aavagames)

]]

Vector2 = {}

--// METAMETHODS //--

-- Unary Minus: Negate operand
local function umn(self)
	return (self * -1)
end

local function add(self, value)
	if (type(value) == "number") then
		return Vector2.addFloat(self, value)
	elseif (type(value) == "table") then
		if (value.className) and (value.className == "Vector2") then
			return Vector2.addVectors(self, value)
		else
			error("attempt to perform arithmetic (add) on " .. self.className .. " and unknown")
		end
	else
		error("attempt to perform arithmetic (add) on " .. self.className .. " and " .. type(value))
	end
end

local function sub(self, value)
	if (type(value) == "number") then
		return Vector2.subtractFloat(self, value)
	elseif (type(value) == "table") then
		if (value.className) and (value.className == "Vector2") then
			return Vector2.subtractVectors(self, value)
		else
			error("attempt to perform arithmetic (subtract) on " .. self.className .. " and unknown")
		end
	else
		error("attempt to perform arithmetic (subtract) on " .. self.className .. " and " .. type(value))
	end
end

local function mul(self, value)
	if (type(value) == "number") then
		return Vector2.multiplyFloat(self, value)
	elseif (type(value) == "table") then
		if (value.className) and (value.className == "Vector2") then
			return Vector2.multiplyVectors(self, value)
		else
			error("attempt to perform arithmetic (multiply) on " .. self.className .. " and unknown")
		end
	else
		error("attempt to perform arithmetic (multiply) on " .. self.className .. " and " .. type(value))
	end
end

local function div(self, value)
	if (type(value) == "number") then
		return Vector2.divideFloat(self, value)
	elseif (type(value) == "table") then
		if (value.className) and (value.className == "Vector2") then
			return Vector2.divideVectors(self, value)
		else
			error("attempt to perform arithmetic (divide) on " .. self.className .. " and unknown")
		end
	else
		error("attempt to perform arithmetic (divide) on " .. self.className .. " and " .. type(value))
	end
end

local function tostringMetamethod(self)
	return ("( " .. self.x .. ", " .. self.y .. ")")
end

local function eq(self, value)
	return Vector2.equals(self, value, 0.01)
end

--// CONSTRUCTOR //--

function Vector2.new(x, y)

	-- Handles Input --
	if (x) and (type(x) ~= "number") then error("number expected, got " .. type(x)) end
	if (y) and (type(y) ~= "number") then error("number expected, got " .. type(y)) end
	----
	
	local dataTable = setmetatable(
		{
			x = x or 0,
			y = y or 0,
			className = "Vector2"
		},
		Vector2
	)
	
	local proxyTable = setmetatable(
		{
			
		},
		{
			__index = function(self, index)
				if (index == "magnitude") then
					return Vector2.getMagnitude(self)
				elseif (index == "unit") then
					return Vector2.getUnitVector(self)
				else
					return (dataTable[index])
				end
			end,
			
			__newindex = function(self, index, newValue)
				if (index == "x") or (index == "y") then
					if (newValue) and (type(newValue) ~= "number") then
						error("number expected, got " .. type(index))
					else
						dataTable[index] = newValue
					end
				else
					error(newValue .. " cannot be assigned")
				end
			end,
			
			__unm = umn,
			__add = add,
			__sub = sub,
			__mul = mul,
			__div = div,
			__eq = eq,
			__tostring = tostringMetamethod
		}
	)
	
	return proxyTable
	
end

--// METHODS //--

function Vector2.addVectors(firstVector2, secondVector2)
	return Vector2.new(firstVector2.x + secondVector2.x, firstVector2.y + secondVector2.y)
end

function Vector2.subtractVectors(firstVector2, secondVector2)
	return Vector2.new(firstVector2.x - secondVector2.x, firstVector2.y - secondVector2.y)
end

function Vector2.multiplyVectors(firstVector2, secondVector2)
	return Vector2.new(firstVector2.x * secondVector2.x, firstVector2.y * secondVector2.y)
end

function Vector2.divideVectors(firstVector2, secondVector2)
	return Vector2.new(firstVector2.x / secondVector2.x, firstVector2.y / secondVector2.y)
end

function Vector2.addFloat(vector2, float)
	return Vector2.new(vector2.x + float, vector2.y + float)
end

function Vector2.subtractFloat(vector2, float)
	return Vector2.new(vector2.x - float, vector2.y - float)
end

function Vector2.multiplyFloat(vector2, float)
	return Vector2.new(vector2.x * float, vector2.y * float)
end

function Vector2.divideFloat(vector2, float)
	return Vector2.new(vector2.x / float, vector2.y / float)
end

function Vector2.mapVector(vector2, mapFunction)
	local x, y = mapFunction(vector2.x, vector2.y)
	return Vector2.new(x, y)
end

--[[
	c:mapVector(function(x, y)
        return (x + y), (x - y)
    end)
]]

function Vector2.equals(firstVector2, secondVector2, epsilon)
	return ((firstVector2 - secondVector2).magnitude < epsilon)
end

function Vector2.getMagnitude(vector2)
	return math.sqrt(
		vector2.x^2 +
		vector2.y^2
	)
end

function Vector2.normalize(vector2)
	return (vector2/vector2.magnitude)
end

function Vector2.clamp(vector2, minVector, maxVector)
	vector2.x = math.clamp(vector2.x, minVector.x, maxVector.x)
	vector2.y = math.clamp(vector2.y, minVector.y, maxVector.y)
	return vector2
end

-- Linearly interpolates between two vectors.
function Vector2.lerp(startVector, endVector, time)
	time = math.clamp(time, 0, 1)
	return Vector2.new(
		startVector.x + (endVector.x - startVector.x) * time,
		startVector.y + (endVector.y - startVector.y) * time
	);
end

-- Linearly interpolates between two vectors without clamping the interpolant
function Vector2.lerpUnclamped(startVector, endVector, time)
	return Vector2.new(
		startVector.x + (endVector.x - startVector.x) * time,
		startVector.y + (endVector.y - startVector.y) * time
	);
end

function Vector2.dot(vector1, vector2)
	return vector1.x * vector2.x + vector1.y * vector2.y; 
end

function Vector2.distance(vector1, vector2)
	return Vector2.getMagnitude((vector1-vector2))
end

-- "Static"

function Vector2.zero()
	return Vector2.new(0, 0)
end

function Vector2.one()
	return Vector2.new(1, 1)
end

function Vector2.right() 
	return Vector2.new(1, 0)
end

function Vector2.left() 
	return Vector2.new(-1, 0)
end

function Vector2.up() 
	return Vector2.new(0, -1)
end

function Vector2.down() 
	return Vector2.new(0, 1)
end

--// INSTRUCTIONS //--

Vector2.__index = Vector2

return Vector2