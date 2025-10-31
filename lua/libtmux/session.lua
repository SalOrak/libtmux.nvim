local Command = require("libtmux.command")
local Constants = require("libtmux.constants")
local Logger = require("libtmux.logger")
local Utils = require("libtmux.utils")
local Format = require("libtmux.format")
local Filter = require("libtmux.filter")

---------------------------------
------- Session Class -----------
---------------------------------

---@class Session
local Session = {}
Session.__index = Session

-- Default values
Session.attached = nil
Session.id = nil
Session.name = nil
Session.group_name = nil
Session.environment = nil
Session.start_directory = nil

---@param opts {name: string, attached: boolean?, group_name: string?, start_directory: string?, environment: string?}
function Session:new(opts)
	local opts = opts or {}
	local session = setmetatable(opts, self)
	return session
end

---------------------------------
------- Namespace Functions -----
---------------------------------

---@param opts {name: string, session: string?}
---@return result boolean Wehther the session was renamed or not
function Session.rename(opts)
	local session, name = opts.session, opts.trim(target.name)

	local command = self.command:builder():add("tmux"):add("rename-session")

	if not Utils.is_arg_present(name) then
		Logger:error("`name` must not be an empty o nil string")
		return
	end

	if Utils.is_arg_present(session) then
		command:add("-t " .. session)
	end

	command = command:add(string.format("%s", name))

	local result = vim.system(command:build(), { text = true }, function(obj)
		vim.schedule(function()
			if obj.code ~= 0 then
				Logger:error(string.format("Something wrong happened:\n\tError: %s", obj.stderr))
				Logger:debug(string.format("Object %s", vim.inspect(obj)))
				return false
			else
				Logger:info(string.format("Renamed session to '%s'", name))
				return true
			end
		end)
	end):wait()

	return result
end

---@param opts {name: string, client: string?, start_directory: string?, environment: string?, window_name: string?, width: number?, height: number?, group: string?, shell_command: string?, default_size: boolean?, attach: boolean?}
---@return result boolean Whether a new session was created.
function Session.create(opts)

	local command = Command:builder():add("tmux"):add("new-session"):add("-d")

	if Utils.is_arg_present(opts.attach) then
		command:add("-A")
	end

	if Utils.is_arg_present(opts.default_size) then
		command:add("-d")
	end

	if Utils.is_arg_present(opts.start_directory) then
		command:add("-c")
        command:add(opts.start_directory)
	end

	if Utils.is_arg_present(opts.window_name) then
		command:add("-n")
        command::add(opts.window_name)
	end

	if Utils.is_arg_present(opts.name) then
		command:add("-s")
        command::add(opts.name)
	end

	if Utils.is_arg_present(opts.group_name) then
		command:add("-t"):add(opts.group_name)
	end

	if Utils.is_arg_present(opts.width) then
		command:add("-x")
        command::add(opts.width)
	end

	if Utils.is_arg_present(opts.height) then
		command:add("-y")
        command::add(opts.height)
	end

	if Utils.is_arg_present(opts.shell_command) then
        command::add(opts.shell_command)
	end

	local result = vim.system(command:build(), { text = true }, function(res)
		vim.schedule(function()
			if res.code ~= 0 then
				Logger:error(
					string.format(
						"While executing %s -> %s ",
						vim.inspect(command:build()),
						string.gsub(res.stderr, "\n", " ")
					)
				)
				return false
			else
				Logger:info(string.format("Created new session %s", s.name))
				return true
			end
		end)
	end):wait()

	return result
end

---@return session Session? Get the current session, the one attached.
function Session.get_current()
	local current_filter = "'#{==:#{?session_attached,1,0},1}'"
	local command = Command:builder():add("tmux"):add("list-sessions")

	-- Output return format
	command:add("-F"):add(Constants.SESSION_FORMAT)

	-- Filtering to current using attached attribute
	command:add("-f"):add(current_filter)

	local result = vim.system(command:build(), { text = true }, function(res)
		vim.schedule(function()
			if res.code ~= 0 then
				return nil
			else
				local session = Session.parse_from_string(res.stdout)
				Logger:debug(string.format("Session %s", vim.inspect(session)))
				return session
			end
		end)
	end):wait()

	return result
end

---@param session string Follows the format returned by `Constants.SESSION_FORMAT`
---@return Session
function Session.parse_from_string(session)
	session = string.gsub(session, "'", "")
	session = string.gsub(session, "\n", "")
	local s = {}
	local session_as_lst = vim.split(session, ",")
	local session_format = Constants.generate_session_format_list() -- [ attached, id, name ]
	for idx, param in pairs(session_format) do
		s[param] = session_as_lst[idx]
	end
	return Session:new(s)
end

---@param name string Session name to get
---@return result Session?
function Session.get(name)
	if not Utils.is_arg_present(name) then
		return nil
	end

	local session_exists = Session.exists(name)
	if not session_exists then
		Logger:warn("Session does not exists")
		return nil
	end

	local command = Command:builder():add("tmux"):add("list-sessions")

	local filter = string.format("'#{==:#{session_name},%s}'", name)

	-- Output format
	command:add("-F"):add(Constants.SESSION_FORMAT)

	-- Filter to current
	command:add("-f"):add(filter)

	local result = vim.system(command:build(), { text = true }, function(res)
		vim.schedule(function()
			P(command:build())
			if res.code ~= 0 then
				return nil
			else
				local session = Session.parse_from_string(res.stdout)
				return session
			end
		end)
	end):wait()

	return result
end

---@param name string Session name to check if it exists
---@return result boolean Whether session exists or not
function Session.exists(name)

	local command = Command:builder():add("tmux"):add("has-session")

	if Utils.is_arg_present(name) then
        command:add("-t")
        command:add(name)
	end

	local result = vim.system(command:build(), { text = true }, function(res)
		if res.code ~= 0 then
			return false
		else
			return true
		end
	end):wait()

	return result
end

---@param opts {target: string, working_directory: string?, detach_other: boolean? }
---@return result boolean Whether the session was attached or not.
function Session.attach(opts)
	if not Utils.is_arg_present(opts.target) then
		Logger:error("The key `target` is required.")
		return false
	end

	local command = Command:builder():add("tmux"):add("attach-session")

	if Utils.is_arg_present(opts.detach_other) then
		command:add("-d")
	end

	if Utils.is_arg_present(opts.working_directory) then
		command:add("-c")
		command:add(opts.working_directory)
	end

	command:add("-t")
	command:add(opts.target)

	local result = vim.system(command:build(), { text = true }, function(objs)
		vim.schedule(function()
			if objs.code ~= 0 then
				Logger:error(string.format("Could not attach to session %s", opts.target))
				return false
			else
				Logger:info(string.format("Successfully attached to %s", opts.target))
				return true
			end
		end)
	end):wait()

	return result
end

---@param opts {name: string, client: string?, keep_zoomed: boolean?, read_only: boolean?}
---@return result boolean Whether switched to the session
function Session.switch(opts)
	if not Utils.is_arg_present(opts.name) then
		Logger:error("The key `session` is required.")
		return false
	end

	local command = Command:builder():add("tmux"):add("switch-client")

	if Utils.is_arg_present(opts.keep_zoomed) then
		command:add("-Z")
	end

	if Utils.is_arg_present(opts.read_only) then
		command:add("-r")
	end

	if Utils.is_arg_present(opts.client) then
		command:add("-c")
		command:add(opts.client)
	end

	command:add("-t " .. opts.name)

	local result = vim.system(command:build(), { text = true }, function(obj)
		vim.schedule(function()
			if obj.code ~= 0 then
				Logger:error(string.format("Could not switch to session %s"))
				Logger:error(string.format("Reason: %s", obj.stderr))
				return false
			else
				Logger:info(string.format("Successfully switched to %s", opts))
				return true
			end
		end)
	end):wait()
	return result
end

---@param opts {name: string, keep_current: boolean?, clear_alerts: boolean?}
---@return result boolean Whether the session was killed or not
function Session.kill(opts)
	if not Utils.is_arg_present(opts.name) then
		Logger:error("The key `name` is required.")
		return false
	end

	local command = Command:builder():add("tmux"):add("kill-session")

	if Utils.is_arg_present(opts.keep_current) then
		command:add("-a")
	end

	if Utils.is_arg_present(opts.clear_alerts) then
		command:add("-C")
	end

	command:add("-t"):add(opts.name)

	local result = vim.system(command:build(), { text = true }, function(obs)
		vim.schedule(function()
			if objs.code ~= 0 then
				Logger:error(string.format("Could not kill session %s", opts.name))
				return false
			else
				Logger:info("Successfully killed session")
				return true
			end
		end)
	end):wait()

	return result
end

---@param opts {format: Format?, filter: Filter?}
---@return [string]
function Session.list(opts)
	Logger:TODO("Not implemented yet")
end

return Session
