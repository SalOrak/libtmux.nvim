---@class Logger
local Logger = {}
Logger.__index = Logger
Logger.VerbosityLevel = {
	TRACE = 0,
	DEBUG = 1,
	INFO = 2,
	WARN = 3,
	ERROR = 4,
	OFF = 5,
}

Logger.VerbosityString = {
	"TRACE",
	"DEBUG",
	"INFO",
	"WARN",
	"ERROR",
	"NONE",
}

Logger.verbosity = Logger.VerbosityLevel.TRACE

---@param opts {verbosity: VerbosityLevel?} @return Logger
function Logger:new(opts)
	local opts = opts or {}
	local logger = setmetatable(opts, self)
	return logger
end

local logger = Logger:new({})

---@param log_level Logger.VerbosityLevel
---@param msg string
function Logger:log(log_level, msg)
	if self.verbosity <= log_level then
		-- Arrays in Lua start in 1, so add 1 to the log_level.
		-- We could increase all values by one but they won't match `vim.log.levels`
		vim.notify(string.format("[%s]: %s", Logger.VerbosityString[log_level + 1], msg), self.verbosity)
	end
end

---@param msg string
function Logger:error(msg)
	self:log(Logger.VerbosityLevel.ERROR, msg)
end

---@param msg string
function Logger:trace(msg)
	self:log(Logger.VerbosityLevel.TRACE, msg)
end

---@param msg string
function Logger:debug(msg)
	self:log(Logger.VerbosityLevel.DEBUG, msg)
end

---@param msg string
function Logger:warn(msg)
	self:log(Logger.VerbosityLevel.WARN, msg)
end

---@param msg string
function Logger:info(msg)
	self:log(Logger.VerbosityLevel.INFO, msg)
end

function Logger:TODO(msg)
	self.log(Logger.VerbosityLevel.ERROR, msg)
end

return logger
