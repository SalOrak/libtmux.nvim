---@class Direction
local Direction = {}

Direction.DirectionEnum = {
	DOWN = "-D",
	UP = "-U",
	LEFT = "-L",
	RIGHT = "-R",
}

Direction.__index = Direction

---@param direction Direction.DirectionEnum
function Direction:new(direction)
	if direction == nil then
		return nil
	end

	local dir = setmetatable({
		str = direction,
	}, self)
	return dir
end

return Direction
