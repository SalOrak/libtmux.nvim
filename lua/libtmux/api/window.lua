local Impl = require'libtmux.api.implementation_state'.states

local M = {
    new = {
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
    split = {
        name = "split-window",
        description = "TBD",
        state = Impl.PARTIAL,
        -- An ordered list of possible arguments
        -- Easiest way to order arguments without adding too much data.
        args = {
            {
                name = "horizontal",
                flag = "h",
                param = false,
                must = false
            },
            {
                name = "size",
                flag = "l",
                param = true,
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
                name = "forward_output",
                flag = "I", 
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
                name = "target",
                flag = "t",
                param = true,
                must = false
            },
            {
                name = "shell_command",
                flag = nil,
                param = true,
                must = false
            },
            {
                name = "format",
                flag = "F",
                param = true,
                must = false
            },
        }
    },
    next = {
        name = "next-window",
        description = "TBD",
        state = Impl.PARTIAL,
        -- An ordered list of possible arguments
        -- Easiest way to order arguments without adding too much data.
        args = {
            {
                name = "alert",
                flag = "a",
                param = false,
                must = false
            },
            {
                name = "target",
                flag = "t",
                param = true,
                must = false
            },
        }
    },
    select = {
        name = "select-window",
        description = "TBD",
        state = Impl.PARTIAL,
        -- An ordered list of possible arguments
        -- Easiest way to order arguments without adding too much data.
        args = {
        }
    },
    kill = {
        name = "kill-window",
        description = "TBD",
        state = Impl.PARTIAL,
        -- An ordered list of possible arguments
        -- Easiest way to order arguments without adding too much data.
        args = {
            {
                name = "window",
                flag = "t",
                param = true,
                must = false
            },
            {
                name = "all_but_current",
                flag = "a",
                param = true,
                must = false
            },
        }
    },
    send_keys = {
        name = "send-keys",
        description = "TBD",
        state = Impl.BUGGY,
        -- An ordered list of possible arguments
        -- Easiest way to order arguments without adding too much data.
        args = {
            {
                name = "client",
                flag = "c",
                param = true,
                must = false
            },
            {
                name = "repeat_count",
                flag = "N",
                param = true,
                must = false
            },
            {
                name = "window_name",
                flag = "t",
                param = true,
                must = false
            },
            {
                name = "keys",
                flag = nil,
                param = true,
                must = true,
                type = "list" -- TODO: Implement type based arguments
            },
        }
    },
    run_shell = {
        name = "run-shell",
        description = "TBD",
        state = Impl.PARTIAL,
        -- An ordered list of possible arguments
        -- Easiest way to order arguments without adding too much data.
        args = {
            {
                name = "background",
                flag = "b",
                param = false,
                must = false
            },
            {
                name = "as_tmux_command",
                flag = "C",
                param = false,
                must = false
            },
            {
                name = "start_directory",
                flag = "c",
                param = true,
                must = false
            },
            {
                name = "delay",
                flag = "d",
                param = true,
                must = false
            },
            {
                name = "window_name",
                flag = "t",
                param = true,
                must = true 
            },
            {
                name = "shell_command",
                flag = nil,
                param = true,
                must = true
            }
        }
    },
}

return M
