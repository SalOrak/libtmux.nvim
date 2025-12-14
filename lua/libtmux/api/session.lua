local Impl = require'libtmux.api.implementation_state'.states

local M = {
    rename = {
        name = "rename-session",
        description = "TBD",
        state = Impl.PARTIAL,
        -- An ordered list of possible arguments
        -- Easiest way to order arguments without adding too much data.
        args = {
            {
                name = "name",
                flag = nil,
                param = true,
                must = false
            },
            {
                name = "session"
                flag = "t",
                param = true,
                must = false
            },
        }
    },
    new = {
        name = "new-session",
        description = "TBD",
        state = Impl.PARTIAL,
        -- An ordered list of possible arguments
        -- Easiest way to order arguments without adding too much data.
        args = {
            {
                name = "attach",
                flag = "A",
                param = false,
                must = false
            },
            {
                name = "default_size"
                flag = "d",
                param = false,
                must = false
            },
            {
                name = "start_directory"
                flag = "c",
                param = true,
                must = false
            },
            {
                name = "window_name"
                flag = "n",
                param = true,
                must = false
            },
            {
                name = "name"
                flag = "s",
                param = true,
                must = false
            },
            {
                name = "group_name"
                flag = "t",
                param = true,
                must = false
            },
            {
                name = "width"
                flag = "x",
                param = true,
                must = false
            },
            {
                name = "height"
                flag = "y",
                param = true,
                must = false
            },

        }
    },
    exists = {
        name = "has-session",
        description = "TBD",
        state = Impl.PARTIAL,
        -- An ordered list of possible arguments
        -- Easiest way to order arguments without adding too much data.
        args = {
            {
                name = "name",
                flag = "t",
                param = true,
                must = true
            }
        }
    },

    attach = {
        name = "attach-session",
        description = "TBD",
        state = Impl.PARTIAL,
        -- An ordered list of possible arguments
        -- Easiest way to order arguments without adding too much data.
        args = {
            {
                name = "detach_other",
                flag = "d",
                param = false,
                must = false
            },
            {
                name = "working_directory"
                flag = "c",
                param = true,
                must = false
            },
            {
                name = "target"
                flag = "t",
                param = true,
                must = true 
            },
        }
    },
    switch = {
        name = "switch-client",
        description = "TBD",
        state = Impl.PARTIAL,
        -- An ordered list of possible arguments
        -- Easiest way to order arguments without adding too much data.
        args = {
            {
                name = "keep_zoomed",
                flag = "Z",
                param = false,
                must = false
            },
            {
                name = "read_only"
                flag = "r",
                param = false,
                must = false
            },
            {
                name = "client"
                flag = "c",
                param = true,
                must = false
            },
            {
                name = "name"
                flag = "t",
                param = true,
                must = true
            },
        }
    },
    kill = {
        name = "kill-session",
        description = "TBD",
        state = Impl.PARTIAL,
        -- An ordered list of possible arguments
        -- Easiest way to order arguments without adding too much data.
        args = {
            {
                name = "keep_current"
                flag = "a",
                param = false,
                must = false
            },
            {
                name = "clear_alerts"
                flag = "C",
                param = false,
                must = false
            },
            {
                name = "name",
                flag = "t",
                param = true,
                must = true
            },
        }
    },
}

return M
