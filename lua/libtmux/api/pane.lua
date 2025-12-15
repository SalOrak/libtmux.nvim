local Impl = require'libtmux.api.implementation_state'.states

local M = {
    breakk = {
        name = "break-pane",
        description = "TBD",
        state = Impl.PARTIAL,
        args = {
            {
                name = "dst_window",
                flag = "t",
                param = true,
                must = false
            },
            {
                name = "src_pane",
                flag = "s",
                param = true,
                must = false
            },
            {
                name = "window_name",
                flag = "n",
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
    capture = {
        name = "capture",
        description = "TBD",
        state = Impl.PARTIAL,
        args = {
            {
                name = "stdout",
                flag = "p",
                param = false,
                must = false
            },
            {
                name = "alternate_screen",
                flag = "a",
                param = false,
                must = false
            },
            {
                name = "no_error",
                flag = "q",
                param = false,
                must = false
            },
            {
                name = "with_escape_seq",
                flag = "e",
                param = false,
                must = false
            },
            {
                name = "ignore_trailing",
                flag = "T",
                param = false,
                must = false
            },
            {
                name = "preserve_trailing",
                flag = "N",
                param = false,
                must = false
            },
            {
                name = "preserve_join",
                flag = "J",
                param = false,
                must = false
            },
            {
                name = "buffer_name",
                flag = "b",
                param = true,
                must = false
            },
            {
                name = "start_line",
                flag = "S",
                param = true,
                must = false
            },
            {
                name = "end_line",
                flag = "E",
                param = true,
                must = false
            },

        }
    },
    join = {
        name = "join-pane",
        description = "TBD",
        state = Impl.PARTIAL,
        args = {
            {
                name = "size",
                flag = "l",
                param = true,
                must = true
            },
            {
                name = "src_pane",
                flag = "s",
                param = true,
                must = true
            },
            {
                name = "dst_pane",
                flag = "t",
                param = true,
                must = true
            },
        }
    },

    kill = {
        name = "kill-pane",
        description = "TBD",
        state = Impl.PARTIAL,
        args = {
            {
                name = "all_but_current",
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
    last = {
        name = "last-pane",
        description = "TBD",
        state = Impl.PARTIAL,
        args = {
            {
                name = "keep_zoomed",
                flag = "Z",
                param = false,
                must = false
            },
            {
                name = "enable_input",
                flag = "e",
                param = false,
                must = false
            },
            {
                name = "disable_input",
                flag = "d",
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
    kill = {
        name = "resize-pane",
        description = "TBD",
        state = Impl.PARTIAL,
        args = {
            {
                name = "mouse_resize",
                flag = "M",
                param = false,
                must = false
            },
            {
                name = "toggle_zoom",
                flag = "Z",
                param = false,
                must = false
            },
            {
                name = "direction",
                flag = nil,
                param = true,
                must = false
            },
            {
                name = "height",
                flag = "y",
                param = true,
                must = false
            },
            {
                name = "width",
                flag = "x",
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
                name = "adjustment",
                flag = nil,
                param = true,
                must = false
            },
        }
    },
    swap = {
        name = "swap-pane",
        description = "TBD",
        state = Impl.PARTIAL,
        args = {
            {
                name = "previous",
                flag = "U",
                param = false,
                must = false
            },
            {
                name = "next",
                flag = "D",
                param = false,
                must = false
            },
            {
                name = "keep_zoomed",
                flag = "Z",
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
                name = "src_pane",
                flag = "s",
                param = true,
                must = false
            },
            {
                name = "dst_pane",
                flag = "t",
                param = true,
                must = false
            },
        }
    },
    select = {
        name = "select-pane",
        description = "TBD",
        state = Impl.PARTIAL,
        args = {
            {
                name = "keep_zoomed",
                flag = "Z",
                param = false,
                must = false
            },
            {
                name = "direction",
                flag = nil,
                param = true,
                must = false
            },
            {
                name = "set_mark",
                flag = "m",
                param = false,
                must = false
            },
            {
                name = "unset_mark",
                flag = "M",
                param = false,
                must = false
            },
            {
                name = "title",
                flag = "T",
                param = true,
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
}

return M
