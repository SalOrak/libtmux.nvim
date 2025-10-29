-- Tmux API
local Command = require("libtmux.command")
local Constants = require("libtmux.constants")
local Session = require("libtmux.session")
local Logger = require("libtmux.logger")

---@class Tmux
---@field command table
local Tmux = {}
Tmux.__index = Tmux

---@type Tmux the singleton Tmux instance
local singleton = nil

---@return Tmux
function Tmux:init()
	local tmux = setmetatable({
		command = Command,
	}, self)

	return tmux
end

singleton = Tmux:init()

---@param target Table Keys should be:
---@param session string [REQUIRED] The session to switch to
---@param client string (OPTIONAL)The target client
function Tmux:switch_client(target)
	local session, client = target
	if session == nil then
		return
	end

	local command = self.command:builder():add("tmux switch-client")
	command:add("-t " .. session)

	if client ~= nil then
		command:add("-c " .. client)
	end

	vim.system(command:build(), { text = true }, function(obj)
		if obj.status ~= 0 then
			vim.notify("[ERROR] Something wrong happened")
			print(obj.stdout)
			print(obj.stderr)
		end
	end):wait()
end

---@param target {name: string, session: string?}
function Tmux:rename_session(target)
	local session, name = target.session, vim.trim(target.name)
	local command = self.command:builder():add("tmux"):add("rename-session")

	if not name or name == nil or name == "" then
		vim.notify("[ERROR]: `name` must not be an empty o nil string")
		return
	end

	if session ~= nil then
		command:add("-t " .. session)
	end

	command = command:add(string.format("%s", name))

	P(command:build())
	vim.system(command:build(), { text = true }, function(obj)
		vim.schedule(function()
			if obj.code ~= 0 then
				vim.notify(string.format("[ERROR] Something wrong happened:\n\tError: %s", obj.stderr))
				vim.notify(string.format("[DEBUG]: Object %s", vim.inspect(obj)))
			else
				vim.notify(string.format("[LOG] Renamed session to '%s'", name))
			end
		end)
	end):wait()
end

---@param session {name: string, client: string?, start-directory: string?, environment: string?, window-name: string?}
---@return is_created boolean Whether the session has created.
function Tmux:new_session(session)
	local is_created = Session:create(session)
	return is_created
end

function Tmux:get_current_session()
	local session = Session.get_current()
	if session == nil then
		Logger:warn("No session found")
		return false
	end
	Logger:info(string.format("Found session: %s", vim.inspect(session)))
	return true
end

---@param opt {name: string, session: string?, start_directory: string?, command: string?}
---@param result boolean Whehter the Window was created.
function Tmux:new_window(opt)
	-- Window name is required
	if not opt.name or vim.trim(opt.name) then
		Logger:warn("Window name is required.")
		return false
	end

	local s = opt.session
	if not opt.session or vim.trim(opt.session) == "" then
		s = "" -- TODO: Get current session but can we skip it?
	end

	local command = self.command:builder():add("tmux"):add("new-window")
	command:add("-n"):add(opt.name)

	if opt.start_directory and vim.trim(opt.start_directory) ~= "" then
		command:add("-c"):add(opt.start_directory)
	end

	-- Command to execute must be the last argument.
	if opt.command and vim.trim(opt.command) ~= "" then
		command:add(opt.command)
	end

	local result = vim.system(command:build(), { text = true }, function(obj)
		vim.schedule(function()
			if obj.code ~= 0 then
				Logger:error(string.format("While creating window with name %s", opt.name))
				Logger:debug(string.format("Creating window command: %s", vim.inspect(command:build())))
				return false
			else
				Logger:info(string.format("Created new window with name %s", opt.name))
				return true
			end
		end)
	end)

	return result
end

---@param name string Window to select
---@return result boolean Whether the window was selected or not
function Tmux:select_window(name)
	if not name or vim.trim(name) == "" then
		Logger:error("Window name must be valid")
		Logger:debug(string.format("Window name: %s", name))
		return false
	end

	local command = self.command:builder():add("tmux"):add("select-window")

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
	end)

	return result
end

---@param name string Window to kill
---@return result boolean Whether the window was killed or not
function Tmux:kill_window(name)
	if not name or vim.trim(name) == "" then
		Logger:error("Window name must be valid")
		Logger:debug(string.format("Window name: %s", name))
		return false
	end

	local command = self.command:builder():add("tmux"):add("kill-window")

	command:add("-t"):add(name)

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
	end)

	return result
end

---@param opt {window_name: string?, keys: [string]}
function Tmux:send_keys(opt)
	if not opt.window_name or vim.trim(opt.window_name) == "" then
		Logger:error("Window name must be valid")
		Logger:debug(string.format("Window name: %s", opt.window_name))
		return false
	end

	local command = self.command:builder():add("tmux"):add("send-keys")

	command:add("-t"):add(opt.window_name)

	-- Append the keys to the end
	for _, key in pairs(opt.keys) do
		command:add(key)
	end

	local result = vim.system(command:build(), { text = true }, function(obj)
		vim.schedule(function()
			if obj.code ~= 0 then
				Logger:error(string.format("While sending keys to window %s", opt.window_name))
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

---@alias Tmux:run_shell(opt)
---@param opt {window_name: string, shell_command: string, start_directory: string?, background: boolean?, view_mode: boolean? }
---@return result boolean Whether it ran the command.
function Tmux:run_command(opt)
	local result = self:run_shell(opt)
	return result
end

---@param opt {window_name: string, shell_command: string, start_directory: string?, background: boolean?}
---@return result boolean Whether it ran the command.
function Tmux:run_shell(opt)
	if not opt.window_name or vim.trim(opt.window_name) == "" then
		Logger:error("Window name must be valid")
		Logger:debug(string.format("Window name: %s", opt.window_name))
		return false
	end

	local command = self.command:builder():add("tmux"):add("run-shell")

	if not opt.start_directory or vim.trim(opt.start_directory) then
		command:add("-c")
		command:add(opt.start_directory)
	end

	if opt.background ~= nil and not opt.background then
		command:add("-b")
	end

	command:add("-t"):add(opt.window_name)

	-- Append the command to the end
	command:add(opt.shell_command)

	local result = vim.system(command:build(), { text = true }, function(obj)
		vim.schedule(function()
			if obj.code ~= 0 then
				Logger:error(string.format("While running shell to window %s", opt.window_name))
				Logger:debug(string.format("Command: %s", vim.inspect(command:build())))
				Logger:debug(string.format("Result: %s", vim.inspect(obj)))
				return false
			else
				Logger:debug(string.format("Command: %s", vim.inspect(command:build())))
				Logger:info(string.format("Ran command to window %s", opt.window_name))
				return true
			end
		end)
	end)

	return result
end

function Tmux:switch_to_all_sessions()
	local command = self.command:builder():add("tmux"):add("list-sessions"):add("-F"):add(Constants.SESSION_FORMAT)

	vim.system(command:build(), { text = true }, function(obj)
		vim.schedule(function()
			local sessions = vim.fn.split(obj.stdout, "\n")
			local goback = nil
			for _, session in pairs(sessions) do
				session = vim.fn.split(session, ",")
				local is_attached, to_session = tonumber(session[1]), session[2]

				to_session = "'" .. to_session .. "'"
				if is_attached == 1 then
					print("Going back to " .. to_session)
					goback = to_session
					break
				end

				print("Switching to " .. to_session)
				vim.loop.new_timer():start(1000, 0, function()
					vim.schedule(function()
						vim.system({
							vim.o.shell,
							vim.o.shellcmdflag,
							string.format("tmux switch-client -t %s", to_session),
						}):wait()
					end)
				end)
			end

			vim.loop.new_timer():start(3000, 0, function()
				vim.schedule(function()
					print("Switching back to " .. goback)
					vim.system({ vim.o.shell, vim.o.shellcmdflag, string.format("tmux switch-client -t %s", goback) })
						:wait()
				end)
			end)
		end)
	end):wait()
end

return singleton
