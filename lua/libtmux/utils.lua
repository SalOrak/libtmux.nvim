local Format = require("libtmux.format")
local Filter = require("libtmux.filter")
local Direction = require("libtmux.direction")

local M = {}

---@param arg string Argument to check for validity and existence
---@return boolean
function M.is_arg_present(arg)
	local is = false
	if arg ~= nil then
		if type(arg) == "string" then
			return vim.trim(arg) ~= ""
		elseif type(arg) == "boolean" then
			return arg == true
		elseif type(arg) == "number" then
			return true
		elseif type(arg) == "table" then
			if getmetatable(arg) == "Format" then
				return true
			elseif getmetatable(arg) == "Filter" then
				return true
			elseif getmetatable(arg) == "Direction" then
				return true
			end
		end
	end
	return false
end

return M
