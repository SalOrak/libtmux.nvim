local Impl = require'libtmux.api_contracts.implementation_state'.states

local M = {
    new_window = {
        name = "new-window",
        description = "TBD",
        state = Impl.PARTIAL,
        -- An ordered list of possible arguments
        -- Easiest way to order arguments without adding too much data.
        args = {
            {
                name = "insert_after",
                flag = "a",
                param = false,
                must = false
            },
            {
                name = "insert_before",
                flag = "b",
                param = false,
                must = false
            },
            {
                name = "keep_focus",
                flag = "d",
                param = false,
                must = false
            },
            {
                name = "kill_instead",
                flag = "k",
                param = false,
                must = false
            },
            {
                name = "and_select",
                flag = "S",
                param = false,
                must = false
            },
            {
                name = "format",
                -- TODO: Not implemented
                flag = nil, 
                param = false,
                must = false
            },
            {
                name = "env",
                flag = "e",
                param = true,
                must = false
            },
            {
                name = "start_directory",
                flag = "c",
                param = true,
                must = false
            },
            {
                name = "target",
                flag = "t",
                param = true,
                must = false
            },
            {
                name = "name",
                flag = "n",
                param = true,
                must = false
            },
            {
                name = "shell_command",
                flag = nil,
                param = true,
                must = false
            },
        }
    },
}

return M
