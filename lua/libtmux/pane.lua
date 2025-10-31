local Format = require("libtmux.format")
local Command = require("libtmux.command")
local Logger = require("libtmux.logger")
local Utils = require("libtmux.utils")

---@class Pane
local Pane = {}
Pane.__index = Pane

---@param opts {dst_window: string?, src_pane: string?, window_name: string?, format: Format?}
function Pane.break_pane(opts)
	local command = Command:builder():add("tmux"):add("break-pane")

	if Utils.is_arg_present(opts.format) then
		Logger:TODO("Formatting not implemented yet")
	end

	if Utils.is_arg_present(opts.window_name) then
		command:add("-n")
		command:add(opts.window_name)
	end

	if Utils.is_arg_present(opts.src_pane) then
		command:add("-s")
		command:add(opts.src_pane)
	end

	if Utils.is_arg_present(opts.dst_window) then
		command:add("-t")
		command:add(opts.dst_window)
	end
	if Utils.is_arg_present(opts.src_pane) then
		command:add("-s")
		command:add(opts.src_pane)
	end

	local result = vim.system(command:build(), { text = true }, function(objs)
		vim.schedule(function()
			if objs.code ~= 0 then
				Logger:error("Could not break pane")
				return false
			else
				Logger:info("Break pane executed successfully")
				return true
			end
		end)
	end):wait()
	return result
end

---@param opts {stdout: boolean?, start_line: number?, end_line:number?,alternate_screen: boolean?, buffer_name: string?, no_error: boolean?, with_escape_seq: boolean?, with_non_printable_chars: boolean?, ignore_trailing: boolean?, preserve_trailing: boolean?, preserve_n_join: boolean?}
---@return result [string]
function Pane.capture(opts)
	local command = Command:builder():add("tmux"):add("capture-pane")

	if Utils.is_arg_present(opts.stdout) then
		command:add("-p")
	end

	if Utils.is_arg_present(opts.alternate_screen) then
		command:add("-a")
	end

	if Utils.is_arg_present(opts.no_error) then
		command:add("-q")
	end

	if Utils.is_arg_present(opts.with_escape_seq) then
		command:add("-e")
	end

	if Utils.is_arg_present(opts.with_non_printable_chars) then
		command:add("-C")
	end

	if Utils.is_arg_present(opts.ignore_trailing) then
		command:add("-T")
	end

	if Utils.is_arg_present(opts.preserve_trailing) then
		command:add("-N")
	end

	if Utils.is_arg_present(opts.preserve_trailing) then
		command:add("-J")
	end

	if Utils.is_arg_present(opts.buffer_name) then
		command:add("-b")
		command:add(opts.buffer_name)
	end

	if Utils.is_arg_present(opts.start_line) then
		command:add("-S")
		command:add(opts.start_line)
	end

	if Utils.is_arg_present(opts.end_line) then
		command:add("-E")
		command:add(opts.end_line)
	end

	local result = vim.system(command:build(), { text = true }, function(objs)
		vim.schedule(function()
			if obs.code ~= 0 then
				Logger:error("Error capturing the pane")
				Logger:debug(string.format("with command: %s", command:build()))

				return {}
			else
				Logger:info("Succesfully captured the pane")
				return objs.stdout
			end
		end)
	end):wait()

	return result
end

---@param opts {src_pane: string?, dst_pane: string?, size: number?}
function Pane.join(opts)
	local command = Command:builder():add("tmux"):add("join-pane")

	if Utils.is_arg_present(opts.size) then
		command:add("-l")
		command:add(opts.size)
	end

	if Utils.is_arg_present(opts.src_pane) then
		command:add("-s")
		command:add(opts.src_pane)
	end

	if Utils.is_arg_present(opts.dst_pane) then
		command:add("-t")
		command:add(opts.dst_pane)
	end

	local result = vim.system(command:build(), { text = true }, function(objs)
		vim.schedule(function()
			if obs.code ~= 0 then
				Logger:error("Error joining the pane")
				Logger:debug(string.format("with command: %s", command:build()))

				return false
			else
				Logger:info("Succesfully joined pane")
				return true
			end
		end)
	end):wait()

	return result
end

---@param opts {target: string?, all_but_current: boolean?}
function Pane.kill(opts)
	local command = Command:builder():add("tmux"):add("kill-pane")

	if Utils.is_arg_present(opts.all_but_current) then
		command:add("-a")
	end

	if Utils.is_arg_present(opts.target) then
		command:add("-t")
		command:add(opts.target)
	end

	local result = vim.system(command:build(), { text = true }, function(objs)
		vim.schedule(function()
			if obs.code ~= 0 then
				Logger:error("Error killing the pane")
				Logger:debug(string.format("with command: %s", command:build()))

				return false
			else
				Logger:info("Succesfully killed pane")
				return true
			end
		end)
	end):wait()

	return result
end

---@param opts {target: string?, keep_zoomed: boolean?, enable_input: boolean?}
function Pane.last(opts)
	local command = Command:builder():add("tmux"):add("last-pane")

	if Utils.is_arg_present(opts.keep_zoomed) then
		command:add("-Z")
	end

	if Utils.is_arg_present(opts.enable_input) then
		command:add("-e")
	elseif opts.enable_input == false then
		command:add("-d")
	end

	if Utils.is_arg_present(opts.target) then
		command:add("-t")
		command:add(opts.target)
	end

	local result = vim.system(command:build(), { text = true }, function(objs)
		vim.schedule(function()
			if obs.code ~= 0 then
				Logger:error("Error last pane")
				Logger:debug(string.format("with command: %s", command:build()))

				return false
			else
				Logger:info("Succesfully switched to last pane")
				return true
			end
		end)
	end):wait()

	return result
end

---@param opts {adjustment: number?, target: string?, width: number?, height: number?, direction: Direction?, mouse_resize: boolean?, toggle_zoom: boolean? }
function Pane.resize(opts)
	local command = Command:builder():add("tmux"):add("resize-pane")

	if Utils.is_arg_present(opts.mouse_resize) then
		command:add("-M")
	end

	if Utils.is_arg_present(opts.toggle_zoom) then
		command:add("-Z")
	end

	if Utils.is_arg_present(opts.direction) then
		command.add(opts.direction.str)
	end

	if Utils.is_arg_present(opts.height) then
		command:add("-y")
		command:add(opts.height)
	end

	if Utils.is_arg_present(opts.width) then
		command:add("-x")
		command:add(opts.width)
	end

	if Utils.is_arg_present(opts.target) then
		command:add("-t")
		command:add(opts.target)
	end

	-- Must be last
	if Utils.is_arg_present(opts.adjustment) then
		command:add(opts.adjustment)
	end

	local result = vim.system(command:build(), { text = true }, function(objs)
		vim.schedule(function()
			if obs.code ~= 0 then
				Logger:error("Error resizing pane")
				Logger:debug(string.format("with command: %s", command:build()))

				return false
			else
				Logger:info("Succesfully resized pane")
				return true
			end
		end)
	end):wait()

	return result
end

---@param opts {src_pane: string?, dst_pane: string?, swap_previous: boolean?, swap_next: boolean?, keep_zoomed: boolean?, keep_focus: boolean?}
function Pane.swap(opts)
	local command = Command:builder():add("tmux"):add("swap-pane")

	if Utils.is_arg_present(opts.swap_previous) then
		command:add("-U")
	end
	if Utils.is_arg_present(opts.swap_next) then
		command:add("-D")
	end
	if Utils.is_arg_present(opts.keep_zoomed) then
		command:add("-Z")
	end
	if Utils.is_arg_present(opts.keep_focus) then
		command:add("-d")
	end

	if Utils.is_arg_present(opts.src_pane) then
		command:add("-s")
		command:add(opts.src_pane)
	end

	if Utils.is_arg_present(opts.dst_pane) then
		command:add("-t")
		command:add(opts.dst_pane)
	end

	local result = vim.system(command:build(), { text = true }, function(objs)
		vim.schedule(function()
			if objs.code ~= 0 then
				Logger:error("Could not swap panes")
				Logger:debug(string.format("with command %s", command:build()))
				return false
			else
				Logger:info("Succesfully swapped pane")
				return true
			end
		end)
	end):wait()

	return result
end

---@param opts {target: string?, title: string?, direction: Direction?, keep_zoomed: boolean?, set_mark: boolean?}
function Pane.select(opts)
	local command = Command:builder():add("tmux"):add("select-pane")

	if Utils.is_arg_present(opts.keep_zoomed) then
		command:add("-Z")
	end

	if Utils.is_arg_present(opts.direction) then
		command:add(opts.direction.str)
	end

	if Utils.is_arg_present(opts.set_mark) then
		command:add("-m")
	elseif opts.set_mark and opts.set_mark == false then
		command:add("-M")
	end

	if Utils.is_arg_present(opts.title) then
		command:add("-T")
		command:add(opts.title)
	end

	if Utils.is_arg_present(opts.target) then
		command:add("-t")
		command:add(opts.target)
	end

	local result = vim.system(command:build(), { text = true }, function(objs)
		vim.schedule(function()
			if objs.code ~= 0 then
				Logger:error("Could not swap panes")
				Logger:debug(string.format("with command %s", command:build()))
				return false
			else
				Logger:info("Succesfully swapped pane")
				return true
			end
		end)
	end):wait()

	return result
end

return Pane
