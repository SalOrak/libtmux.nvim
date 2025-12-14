local Command = require("libtmux.command")
local Logger = require("libtmux.logger")
local Utils = require("libtmux.utils")

---@class Window
local Window = {}
Window.__index = Window

---@param opts {name: string?, target: string?, start_directory: string?, shell_command: string?, insert_after: boolean?, insert_before: boolean?, keep_focus: boolean?, kill_instead: boolean?, and_select: boolean?, env: string?, format: Format?}
---@param result boolean Whehter the Window was created.
function Window.new(opts)
	local command = Command:builder():add("tmux"):add("new-window")

	if Utils.is_arg_present(opts.insert_after) then
		command:add("-a")
	end

	if Utils.is_arg_present(opts.insert_before) then
		command:add("-b")
	end

	if Utils.is_arg_present(opts.keep_focus) then
		command:add("-d")
	end

	if Utils.is_arg_present(opts.kill_instead) then
		command:add("-k")
	end

	if Utils.is_arg_present(opts.and_select) then
		command:add("-S")
	end

	if Utils.is_arg_present(opts.env) then
		command:add("-e")
		command:add(opts.env)
	end

	if Utils.is_arg_present(opts.format) then
		Logger:TODO("Not implemented yet")
	end

	if Utils.is_arg_present(opts.start_directory) then
		command:add("-c"):add(opts.start_directory)
	end

	if Utils.is_arg_present(opts.target) then
		command:add("-t")
		command:add(opts.target)
	end

	if Utils.is_arg_present(opts.name) then
		command:add("-n")
		command:add(opts.name)
	end

	-- Command to execute must be the last argument.
	if Utils.is_arg_present(opts.shell_command) then
		command:add(opts.shell_command)
	end

	local result = vim.system(command:build(), { text = true }, function(obj)
		vim.schedule(function()
			if obj.code ~= 0 then
				Logger:error(string.format("While creating window with name %s", opts.name))
				Logger:error(obj.stderr)
				Logger:debug(string.format("Creating window command: %s", vim.inspect(command:build())))
				return false
			else
				Logger:info(string.format("Created new window with name %s", opts.name))
				Logger:debug(string.format("Creating window command: %s", vim.inspect(command:build())))
				return true
			end
		end)
	end):wait()

	return result
end

---@param opts {name: string?, target: string?, horizontal: bool?, start_directory: string?, shell_command: string?, size: string?, env: string?, format: Format?, forward_output: bool?}
---@return result boolean Whehter the Window was splitted
function Window.split_window(opts)
	local command = Command:builder():add("tmux"):add("split-window")

	if Utils.is_arg_present(opts.horizontal) then
		command:add("-h")
	end

	if Utils.is_arg_present(opts.size) then
		command:add("-l")
		command:add(opts.size)
	end

	if Utils.is_arg_present(opts.env) then
		command:add("-e")
		command:add(opts.env)
	end


	if Utils.is_arg_present(opts.start_directory) then
		command:add("-c"):add(opts.start_directory)
	end

	if Utils.is_arg_present(opts.target) then
		command:add("-t")
		command:add(opts.target)
	end

	if Utils.is_arg_present(opts.forward_output) then
		command:add("-I")
	end

	-- Command to execute before format.
	if Utils.is_arg_present(opts.shell_command) then
		command:add(opts.shell_command)
	end

	if Utils.is_arg_present(opts.format) then
		command:add("-F")
		command:add(opts.env)
	end

	local result = vim.system(command:build(), { text = true }, function(obj)
		vim.schedule(function()
			if obj.code ~= 0 then
				Logger:error(string.format("While splliting window with name %s", opts.name))
				Logger:error(obj.stderr)
				Logger:debug(string.format("Split window command: %s", vim.inspect(command:build())))
				return false
			else
				Logger:info(string.format("Splitted new window with name %s", opts.name))
				Logger:debug(string.format("Splitted window command: %s", vim.inspect(command:build())))
				return true
			end
		end)
	end):wait()

	return result
end

---@param opts {alert: bool?, target_session: string?}
---@return result boolean Whether the command was successful or not
function Window.next_window(opts)
    local command = Command:builder():add("tmux"):add("next-window")

    if Utils.is_arg_present(opts.alert) then
        command.add("-a")
    end

    if Utils.is_arg_present(opts.target_session) then
        command.add("-t")
        command.add(opts.target_session)
    end

	local obj = vim.system(command:build(), { text = true }, function() 
	end):wait()

    if obj.code ~= 0 then
        Logger:error(string.format("Error selecting next window"))
        Logger:debug(string.format("Command: %s", vim.inspect(command:build())))
        return false
    else
        Logger:info(string.format("Next window"))
        return false
    end
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

---@param opts {window: string?, all_but_current: boolean?}
---@return result boolean Whether the window was killed or not
function Window.kill(opts)
	local command = Command:builder():add("tmux"):add("kill-window")

	if Utils.is_arg_present(opts.all_but_current) then
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

---@return window {id: string?, name: string?, session: string?} Current window
function Window.get_current()
	local command = Command:builder()

	command:add("tmux"):add("list-windows")
	command:add("-F"):add("#{window_id},#{window_name},#{session_name}")
	command:add("-f"):add("#{==:#{window_active},1}")

	local result = vim.system(command:build(), { text = true }):wait()

	if result.code ~= 0 then
		Logger:error("Cannot get the current window")
		Logger:debug(string.format("Command %s", command:build()))
		return {}
	else
		Logger:debug(string.format("Command %s", vim.inspect(command:build())))
		local window_splitted = vim.split(result.stdout, ",")
		Logger:debug("Window splitted: " .. vim.inspect(window_splitted))

		Logger:debug("Window splitted at 1: " .. window_splitted[1])
		return {
			id = window_splitted[1],
			name = window_splitted[2],
			session = window_splitted[3],
		}
	end
end

--- TODO: format should be its own class? Or keep it a thin layer?
--- TODO: filter should be its own class? Or keep it a thin layer?
---@param opt { list_all: boolean?, format: string?, filter: string?, target_session: string?}
---@return windows [string] Array of windows names
function Window.list(opt)
	local command = Command:builder():add("tmux"):add("list-windows")

	if Utils.is_arg_present(opt.list_all) then
		command:add("-a")
	end

	if Utils.is_arg_present(opt.format) then
		command:add("-F")
		command:add(opt.format)
	end

	if Utils.is_arg_present(opt.filter) then
		command:add("-f")
		command:add(opt.filter)
	end

	if Utils.is_arg_present(opt.target_session) then
		command:add("-t")
		command:add(opt.target_session)
	end

	local ret = vim.system(command:build(), { text = true }):wait()

	Logger:debug(string.format("Command: %s", vim.inspect(command:build())))
	if ret.code ~= 0 then
		Logger:error(string.format("While listing windows"))
		Logger:debug(string.format("Command: %s", vim.inspect(command:build())))
		return {}
	else
		Logger:info(string.format("Listed windows"))
		return vim.split(ret.stdout, "\n")
	end
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
				Logger:debug(string.format("Command: %s", vim.inspect(command:build())))
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

	if not Utils.is_arg_present(opts.window_name) then
		Logger:error("The key `window_name` must be valid")
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

	-- Append the window
	command:add("-t")
	command:add(opts.window_name)

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
