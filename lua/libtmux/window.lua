local Command = require("libtmux.command")
local Logger = require("libtmux.logger")
local Utils = require("libtmux.utils")

---@class Window
local Window = {}
Window.__index = Window

---@param opts {name: string, session: string?, start_directory: string?, command: string?}
---@param result boolean Whehter the Window was created.
function Window.new(opts)
	-- Window name is required
	--
	if not Utils.is_arg_present(opts.name) then
		Logger:warn("Window name is required.")
		return false
	end

	local s = opts.session
	if not Utils.is_arg_present(opts.session) then
		s = "" -- TODO: Get current session but can we skip it?
	end

	local command = Command:builder():add("tmux"):add("new-window")
	command:add("-n"):add(opts.name)

	if Utils.is_arg_present(opts) then
		command:add("-c"):add(opts.start_directory)
	end

	-- Command to execute must be the last argument.
	if Utils.is_arg_present(opts.command) then
		command:add(opts.command)
	end

	local result = vim.system(command:build(), { text = true }, function(obj)
		vim.schedule(function()
			if obj.code ~= 0 then
				Logger:error(string.format("While creating window with name %s", opts.name))
				Logger:debug(string.format("Creating window command: %s", vim.inspect(command:build())))
				return false
			else
				Logger:info(string.format("Created new window with name %s", opts.name))
				return true
			end
		end)
	end):wait()

	return result
end

---@param name string Window to select
---@return result boolean Whether the window was selected or not
function Window.select(name)
	if not Utils.is_arg_present(name) then
		Logger:error("Window name must be valid")
		Logger:debug(string.format("Window name: %s", name))
		return false
	end

	local command = Command:builder():add("tmux"):add("select-window")

	command:add("-t"):add(name)

	local result = vim.system(command:build(), { text = true }, function(obj)
		vim.schedule(function()
			if obj.code ~= 0 then
				Logger:error(string.format("While selecting window %s", name))
				Logger:debug(string.format("Command: %s", vim.inspect(command:build())))
				return false
			else
				Logger:info(string.format("Selected window %s", name))
				return true
			end
		end)
	end):wait()

	return result
end

---@param opts {window: string?, except_current: boolean?}
---@return result boolean Whether the window was killed or not
function Window.kill(opts)
	local command = Command:builder():add("tmux"):add("kill-window")

	if Utils.is_arg_present(opts.except_current) then
		command:add("-a")
	end

	if Utils.is_arg_present(opts.window) then
		command:add("-t")
		command:add(opts.window)
	end

	local result = vim.system(command:build(), { text = true }, function(obj)
		vim.schedule(function()
			if obj.code ~= 0 then
				Logger:error(string.format("While killing window %s", name))
				Logger:debug(string.format("Command: %s", vim.inspect(command:build())))
				return false
			else
				Logger:info(string.format("Killed window %s", name))
				return true
			end
		end)
	end):wait()

	return result
end

---@param opts {keys: [string], window_name: string?, repeat_count: number?, client: string? }
function Window.send_keys(opts)
	if not Utils.is_arg_present(opts.keys) then
		Logger:error("The key `keys` must be valid")
		return false
	end

	local command = Command:builder():add("tmux"):add("send-keys")

	if Utils.is_arg_present(opts.client) then
		command:add("-c")
		command:add(opts.client)
	end

	if Utils.is_arg_present(opts.repeat_count) then
		command:add("-N")
		command:add(opts.repeat_count)
	end

	if Utils.is_arg_present(opts.window_name) then
		command:add("-t")
		command:add(opts.window_name)
	end

	-- Append the keys to the end
	for _, key in pairs(opts.keys) do
		command:add(key)
	end

	local result = vim.system(command:build(), { text = true }, function(obj)
		vim.schedule(function()
			if obj.code ~= 0 then
				Logger:error(string.format("While sending keys to window %s", opts.window_name))
				Logger:debug(string.format("Command: %s", vim.inspect(command:build())))
				Logger:debug(string.format("Result: %s", vim.inspect(obj)))
				return false
			else
				Logger:info(string.format("Sent keys to window %s", name))
				return true
			end
		end)
	end)

	return result
end

---@param opts { shell_command: string, window_name: string?, start_directory: string?, background: boolean?, as_tmux_command: boolean?, delay: number?}
---@return result boolean Whether it ran the command.
function Window.run_shell(opts)
	if not Utils.is_arg_present(opts.shell_command) then
		Logger:error("The key `shell_command` must be valid")
		return false
	end

	local command = Command:builder():add("tmux"):add("run-shell")

	if Utils.is_arg_present(opts.background) then
		command:add("-b")
	end

	if Utils.is_arg_present(opts.as_tmux_command) then
		command:add("-C")
	end

	if Utils.is_arg_present(opts.start_directory) then
		command:add("-c")
		command:add(opts.start_directory)
	end

	if Utils.is_arg_present(opts.delay) then
		command:add("-d")
		command:add(opts.delay)
	end

	if Utils.is_arg_present(opts.window_name) then
		command:add("-t")
		command:add(opts.window_name)
	end

	-- Append the command to the end
	command:add(opts.shell_command)

	local result = vim.system(command:build(), { text = true }, function(obj)
		vim.schedule(function()
			if obj.code ~= 0 then
				Logger:error(string.format("While running shell to window %s", opts.window_name))
				Logger:debug(string.format("Command: %s", vim.inspect(command:build())))
				Logger:debug(string.format("Result: %s", vim.inspect(obj)))
				return false
			else
				Logger:debug(string.format("Command: %s", vim.inspect(command:build())))
				Logger:info(string.format("Ran command to window %s", opts.window_name))
				return true
			end
		end)
	end):wait()

	return result
end

return Window
