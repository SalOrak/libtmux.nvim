--- Session class definition
local Command = require("libtmux.command")
local Constants = require("libtmux.constants")
local Logger = require("libtmux.logger")

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

---@return session Session? Get the current session, the one attached.
function Session.get_current()
	local current_filter = "#{==:#{?session_attached,1,0},1}"
	local command = Command:builder():add("tmux"):add("list-sessions")

	-- Output return format
	command:add("-F"):add(Constants.SESSION_FORMAT)

	-- Filtering to current using attached attribute
	command:add("-f "):add(current_filter)

	local result = vim.system(command:build(), { text = true }, function(res)
		if res.code ~= 0 then
			return nil
		else
			local session = Session.parse_session_from_string(res.output)
			return session
		end
	end)

	return result
end

---@param session string Follows the format returned by `Constants.SESSION_FORMAT`
---@return Session
function Session.parse_session_from_string(session)
	local s = {}
	local session_as_lst = vim.split(session, ",")
	local session_format = Constants.generate_session_format_list() -- [ attached, id, name ]
	for idx, param in pairs(session_format) do
		s[param] = session_as_lst[idx]
	end
	return Session:new(s)
end

---@param session {name: string, client: string?, start_directory: string?, environment: string?, window-name: string?}
---@return result boolean Whether a new session was created.
function Session:create(session)
	local s = Session:new(session)

	local command = Command:builder():add("tmux"):add("new-session"):add("-d")

	if s.name == nil or vim.trim(s.name) == "" then
		Logger:error("Session must have a not empty `name`.")
		return
	end

	if s.start_directory ~= nil then
		command:add("-c"):add(s.start_directory)
	end

	if s.group_name ~= nil then
		command:add("-t"):add(s.group_name)
	end

	command:add("-s"):add(s.name)

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

---@return result boolean Whether session exists or not
function Session:exists()
	local identifier = self.id
	if self.name ~= nil then
		identifier = self.name
	end

	local command = Command:builder():add("tmux"):add("has-session"):add("-t"):add(identifier)
	local result = vim.system(command:build(), { text = true }, function(res)
		if res.status ~= 0 then
			return false
		else
			return true
		end
	end):wait()

	return result
end

---@param session Session the Session to switch to
---@return nil
function Session:switch(session)
	-- Return if switching to the same session
	if session.attached ~= nil and attached then
		return
	end

	local builder = Command:builder():add("tmux"):add("switch-client"):add("-t " .. session.name):build()
	vim.system(builder, { text = true }, function(obj) end):wait()
end

return Session
