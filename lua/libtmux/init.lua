-- Tmux API
local Command = require("libtmux.command")
local Constants = require("libtmux.constants")
local Session = require("libtmux.session")

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
function Tmux:new_session(session)
	local s = Session:create(session)
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
