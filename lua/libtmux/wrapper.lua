local WindowContract = require'libtmux.api.window'
local SessionContract = require'libtmux.api.session'
local PaneContract = require'libtmux.api.pane'

local Impl = require'libtmux.api.implementation_state'
local ImplStates = Impl.states
local Command = require'libtmux.command'
local Logger = require 'libtmux.logger'
local Utils = require'libtmux.utils'

local M = {
    last = nil,
    last_contract = nil,
    ContractSection = {
        SESSION= 1,
        WINDOW = 2,
        PANE = 3
    }
}

local ContractSectionsRev = {}
for k,v in pairs(M.ContractSection) do
    ContractSectionsRev[v] = k
end

local function get_contract(contract_section) 
    if ContractSectionsRev[contract_section] == "SESSION" then
        return SessionContract
    elseif ContractSectionsRev[contract_section] == "WINDOW" then
        return WindowContract
    elseif ContractSectionsRev[contract_section] == "PANE" then
        return PaneContract
    end
    return nil
end


---@param contract ContractSection Contract section. Options "Window"
---@param name string Name of the function to execute
---@param uargs table Arguments passed from the user
---@param cb function(obj) Passed to `vim.system` on exit. Accepts one param.
M.execute = function(section, name, uargs, cb)
    local contract = get_contract(section)

    if contract == nil then
        Logger:debug(string.format("Section %d is not found", section))
        return
    end

    local fn = contract[name]

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
                if arg.type == "list" then
                    if not vim.islist(uargs[arg.name]) then
                        Logger:error(string.format("Expected parameter type `%s` but found `%s` for argument `%s` on function `%s`", arg.type, type(uargs[arg.name]), arg.name, name))
                        return
                    end
                    for _,v in pairs(uargs[arg.name]) do
                        command:add(v)
                    end

                else
                    command:add(uargs[arg.name])
                end
            end
        else
            -- Argument not found but required!
            if arg.must then
                Logger:error(string.format("Expected argument `%s` when executing tmux function `%s`", arg.name, name))
                return
            end
        end
    end

    M.last = command:build()
    M.last_contract = contract

    return vim.system(command:build(), {text = true}, cb)
end

return M
