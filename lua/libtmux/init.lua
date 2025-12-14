-- Tmux API
local Constants = require("libtmux.constants")
local Session = require("libtmux.session")
local Window = require("libtmux.window")
local Pane = require("libtmux.pane")
local Logger = require("libtmux.logger")
local Wrapper = require("libtmux.wrapper")
local Contracts = Wrapper.ContractSection

---@class Tmux
local Tmux = {}
Tmux.__index = Tmux

---@type Tmux the singleton Tmux instance
local singleton = nil

---@return Tmux
function Tmux:init()
	local tmux = setmetatable({}, self)
	return tmux
end

singleton = Tmux:init()

------------------------------------------
------------ SESSION ---------------------
------------------------------------------

---@param opts {name: string, client: string?, keep_zoomed: boolean?, read_only: boolean?}
---@param boolean Whether the session was switched to or not
function Tmux:switch_client(opts)
	local res = Wrapper.execute(Contracts.SESSION, "switch", opts, on_exit)
	return res
end

---@param opts {name: string, session: string?}
---@param boolean Whether the session was renamed or not
function Tmux:rename_session(opts)
	local res = Wrapper.execute(Contracts.SESSION, "rename", opts, on_exit)
	return res
end

---@param opts {name: string, client: string?, start_directory: string?, environment: string?, window_name: string?, width: number?, height: number?, group: string?, shell_command: string?, default_size: boolean?, attach: boolean?}
---@return result boolean Whether a new session was created.
function Tmux:new_session(opts)
	local result = Wrapper.execute(Contracts.SESSION, "new", opts, on_exit)
	return result
end

---@return session Session?
function Tmux:get_current_session()
	local session = Session.get_current()
	if session == nil then
		Logger:warn("No session found")
		return nil
	end
	Logger:info(string.format("Found session: %s", vim.inspect(session)))
	return session
end

---@param name string Session name
---@return session Session?
function Tmux:get_session(name)
	local session = Session.get(name)
	return session
end

---@param session string Identifier of the session. Can be name or id
---@return result boolean Whether the session exists or no
function Tmux:session_exists(session)
	local result = Wrapper.execute(Contracts.SESSION, "exists", opts, on_exit)
	return exists
end

------------------------------------------
------------ WINDOW ----------------------
------------------------------------------

---@param opts {name: string?, target: string?, start_directory: string?, shell_command: string?, insert_after: boolean?, insert_before: boolean?, keep_focus: boolean?, kill_instead: boolean?, and_select: boolean?, env: string?, format: Format?}
---@param result boolean Whehter the Window was created.
function Tmux:new_window(opts)
	local result = Wrapper.execute(Contracts.WINDOW, "new", opts, on_exit)
	return result
end

---@param opts {name: string?, target: string?, horizontal: bool?,
---start_directory: string?, shell_command: string?, insert_after: boolean?,
---insert_before: boolean?, keep_focus: boolean?, kill_instead: boolean?,
---and_select: boolean?, size: string?, env: string?, format: Format?}
---@param result boolean Whehter the Window was splitted
function Tmux:split_window(opts)
	local result = Wrapper.execute(Contracts.WINDOW, "split", opts, on_exit)
	return result
end

---@param opts {alert: bool?, target_session: string?}
---@return result boolean Whether the command was successful or not
function Tmux:next_window(opts)
	local result = Wrapper.execute(Contracts.WINDOW, "next", opts, on_exit)
	return result
end

---@param opts { name: string?}
---@return result boolean Whether the window was selected or not
function Tmux:select_window(opts)
	local result = Wrapper.execute(Contracts.WINDOW, "select", opts, on_exit)
	return result
end

---@param opts {window: string?, all_but_current: boolean?}
---@return result boolean Whether the window was killed or not
function Tmux:kill_window(opts)
	local result = Wrapper.execute(Contracts.WINDOW, "kill", opts, on_exit)
	return result
end

---@param opts { list_all: boolean?, format: string?, filter: string?, target_session: string?}
---@return windows [string] Array of windows names
function Tmux:list_windows(opts)
	local result = Window.list(opts)
	return result
end

---@return window {id: string?, name: string?, session: string?} Current window
function Tmux:current_window()
	local result = Window.get_current()
	return result
end

---@param opts {keys: [string], window_name: string?, repeat_count: number?, client: string? }
function Tmux:send_keys(opts)
	local result = Wrapper.execute(Contracts.WINDOW, "send_keys", opts, on_exit)
	return result
end

---@alias Tmux:run_shell(opt)
---@param opts { shell_command: string, window_name: string?, start_directory: string?, background: boolean?, as_tmux_command: boolean?, delay: number?}
---@return result boolean Whether it ran the command.
function Tmux:run_command(opts)
	local result = self:run_shell(opts)
	return result
end

---@param opts { shell_command: string, window_name: string?, start_directory: string?, background: boolean?, as_tmux_command: boolean?, delay: number?}
---@return result boolean Whether it ran the command.
function Tmux:run_shell(opts)
	local result = Wrapper.execute(Contracts.WINDOW, "run_shell", opts, on_exit)
	return result
end

------------------------------------------
------------ Pane   ----------------------
------------------------------------------

---@param opts {dst_window: string?, src_pane: string?, window_name: string?, format: Format?}
function Tmux:break_pane(opts)
	local res = Wrapper.execute(Contracts.PANE, "breakk", opts, on_exit)
	return res
end

---@param opts {stdout: boolean?, start_line: number?, end_line:number?,alternate_screen: boolean?, buffer_name: string?, no_error: boolean?, with_escape_seq: boolean?, with_non_printable_chars: boolean?, ignore_trailing: boolean?, preserve_trailing: boolean?, preserve_n_join: boolean?}
---@return result [string]
function Tmux:capture_pane(opts)
	local res = Wrapper.execute(Contracts.PANE, "capture", opts, on_exit)
	return res
end

---@param opts {src_pane: string?, dst_pane: string?, size: number?}
function Tmux:join_pane(opts)
	local res = Wrapper.execute(Contracts.PANE, "join", opts, on_exit)
	return res 
end

---@param opts {target: string?, all_but_current: boolean?}
function Tmux:kill_pane(opts)
	local res = Wrapper.execute(Contracts.PANE, "kill", opts, on_exit)
	return res 
end

---@param opts {target: string?, keep_zoomed: boolean?, enable_input: boolean?}
function Tmux:last_pane(opts)
	local res = Wrapper.execute(Contracts.PANE, "last", opts, on_exit)
	return res
end

---@param opts {adjustment: number?, target: string?, width: number?, height: number?, direction: Direction?, mouse_resize: boolean?, toggle_zoom: boolean? }
function Tmux:resize_pane(opts)
	local res = Wrapper.execute(Contracts.PANE, "resize", opts, on_exit)
	return res
end

---@param opts {src_pane: string?, dst_pane: string?, swap_previous: boolean?, swap_next: boolean?, keep_zoomed: boolean?, keep_focus: boolean?}
function Tmux:swap_pane(opts)
	local res = Wrapper.execute(Contracts.PANE, "swap", opts, on_exit)
	return res
end

---@param opts {target: string?, title: string?, direction: Direction?, keep_zoomed: boolean?, set_mark: boolean?}
function Tmux:select_pane(opts)
	local res = Wrapper.execute(Contracts.PANE, "select", opts, on_exit)
	return res
end

return singleton
