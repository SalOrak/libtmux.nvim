local WindowContract = require'libtmux.api.window'
local Impl = require'libtmux.api.implementation_state'
local ImplStates = Impl.states
local Command = require'libtmux.command'
local Logger = require 'libtmux.logger'
local Utils = require'libtmux.utils'

---@param name string Name of the function to execute
---@param uargs table Arguments passed from the user
---@param cb function(obj) Passed to `vim.system` on exit. Accepts one param.
function test(name, uargs, cb)
    local fn = WindowContract[name]
    local command = Command:builder()

    if fn == nil then
        Logger:debug(string.format("There is no function called %s", name))
        return nil
    end

    local args = fn.args
    local state = fn.state
    local description = fn.description
    local name = fn.name
    
    if state ~= Impl.get_state(ImplStates.FULLY) then
        Logger:warn(string.format("Function `%s` implementation state is `%s`", name, Impl.get_state(state)))

        if state == Impl.get_state(ImplStates.NOT_IMPLEMENTED) then
            return
        end
    end

    command:add("tmux"):add(name)

    local uargs_keys = vim.tbl_keys(uargs)
    -- Iterate over arguments inserting into the `command`
    for _,arg in ipairs(args) do
        local has_arg = vim.tbl_contains(uargs_keys, arg.name)
        if has_arg then
            if arg.flag ~= nil then
                command:add(string.format("-%s", arg.flag))
            end

            if arg.param then
                if not Utils.is_arg_present(uargs[arg.name]) then
                    Logger:error(string.format("Expected parameter for argument `%s` when executing tmux function `%s`", arg.name, name))
                    return
                end
                command:add(uargs[arg.name])
            end
        else
            -- Argument not found but required!
            if arg.must then
                Logger:error(string.format("Expected argument `%s` when executing tmux function `%s`", arg.name, name))
                return
            end
        end
    end

    vim.system(command:build(), {text = true}, cb)
end

test("new_window", { insert_after = "NULL"}, function(obj) 
    print(obj.code)
end)
