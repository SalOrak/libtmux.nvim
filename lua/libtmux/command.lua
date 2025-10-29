-----------------------------------------
--- CommandBuilder class definitions ----
-----------------------------------------

---@class CommandBuilder
local CommandBuilder = {}
CommandBuilder.__index = CommandBuilder

function CommandBuilder:new()
	local commandBuilder = setmetatable({
		shell = vim.o.shell,
		shellcmdflag = vim.o.shellcmdflag,
		commands = {},
	}, self)
	return commandBuilder
end

---@param cmd string Command to append
---@return CommandBuilder
function CommandBuilder:add(cmd)
	table.insert(self.commands, cmd)
	return self
end

function CommandBuilder:withShell()
	local result = {}
	table.insert(result, self.shell)
	table.insert(result, self.shellcmdflag)
	local tmp = self.commands

	vim.list_extend(result, tmp)
	self.commands = result

	return self
end

---@param shell string The shell command to execute. The default is vim.o.shell
---@return CommandBuilder
function CommandBuilder:change_shell(shell)
	self.shell = shell
	return self
end

---@param shellcmdflag string The switch command to make the shell execute a command. The default is vim.o.shellcmdflag
---@return CommandBuilder
function CommandBuilder:change_shellcmdflag(shellcmdflag)
	self.shellcmdflag = shellcmdflag
	return self
end

---@return commands table Table representing the command to execute
function CommandBuilder:build()
	return self.commands
end

-----------------------------------------
--- Command class definition -----------
-----------------------------------------

---@class Command
local Command = {}
Command.__index = Command

---@type Command singleton instance of the Command class
local singleton = nil

function Command:new()
	local command = setmetatable({
		cmd_builder = nil,
	}, self)
	return command
end

singleton = Command:new()

---@return CommandBuilder
function Command:builder()
	self.cmd_builder = CommandBuilder:new()
	return self.cmd_builder
end

return singleton
