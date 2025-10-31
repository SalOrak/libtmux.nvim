# Tmux Wrapper for Neovim

Develop your own workflow around tmux using Neovim Lua. 

`libtmux.nvim` offers a clean interface to interact with `tmux` inside Neovim.

## API

| Tmux Command   | Category | Function              | % immplemented |
|----------------|----------|-----------------------|----------------|
| switch-client  | Session  | `Tmux:switch_client`  |                |
|----------------|----------|-----------------------|----------------|
| rename-session | Session  | `Tmux:rename_session` |                |
|----------------|----------|-----------------------|----------------|
| new-session    | Session  | `Tmux:new_session`    |                |
|----------------|----------|-----------------------|----------------|
| has-session    | Session  | `Tmux:session_exists` |                |
|----------------|----------|-----------------------|----------------|
| new-window     | Window   | `Tmux:new_window`     |                |
|----------------|----------|-----------------------|----------------|
| select-window  | Window   | `Tmux:select_window`  | 60%                |
|----------------|----------|-----------------------|----------------|
| kill-window    | Window   | `Tmux:kill_window`    |   100%             |
|----------------|----------|-----------------------|----------------|
| send-keys      | Window   | `Tmux:send_keys`      |   70%             |
|----------------|----------|-----------------------|----------------|
| run-shell      | Window   | `Tmux:run_shell`      | 100%                |
|----------------|----------|-----------------------|----------------|
| break-pane     | Pane     | `Tmux:break_pane`     | 80% (Format)   |
|----------------|----------|-----------------------|----------------|
| capture-pane   | Pane     | `Tmux:capture_pane`   | 100%           |
|----------------|----------|-----------------------|----------------|
| join-pane      | Pane     | `Tmux:join_pane`      | 100%           |
|----------------|----------|-----------------------|----------------|
| kill-pane      | Pane     | `Tmux:kill_pane`      | 100%           |
|----------------|----------|-----------------------|----------------|
| last-pane      | Pane     | `Tmux:last_pane`      | 100%           |
|----------------|----------|-----------------------|----------------|
| resize-pane    | Pane     | `Tmux:resize_pane`    | 100%           |
|----------------|----------|-----------------------|----------------|
| swap-pane      | Pane     | `Tmux:swap_pane`      | 100%           |
|----------------|----------|-----------------------|----------------|
| select-pane    | Pane     | `Tmux:select_pane`    | 100%           |
|----------------|----------|-----------------------|----------------|




