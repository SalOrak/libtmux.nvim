#   Tmux Wrapper for Neovim <img src="./assets/libtmux-logo-nobg-1.png" alt="libtmux logo" width="100" height="100">

<img src="./assets/libtmux-logo-nobg-1.png" alt="libtmux logo" width="200" height="200">

Develop your own workflow around tmux using Neovim Lua. 

`libtmux.nvim` offers a clean interface to interact with `tmux` inside Neovim.


*Disclaimer: This is a work in progress. The idea is to wrap the complete TMUX API*

## API

| Tmux Command   | Category | Function              | % implemented |
|----------------|----------|-----------------------|---------------|
| switch-client  | Session  | `Tmux:switch_client`  | 80%           |
| rename-session | Session  | `Tmux:rename_session` | 100%          |
| new-session    | Session  | `Tmux:new_session`    | 80%              |
| has-session    | Session  | `Tmux:session_exists` | 100%              |
| new-window     | Window   | `Tmux:new_window`     |  90%             |
| select-window  | Window   | `Tmux:select_window`  | 60%           |
| kill-window    | Window   | `Tmux:kill_window`    | 100%          |
| send-keys      | Window   | `Tmux:send_keys`      | 70%           |
| run-shell      | Window   | `Tmux:run_shell`      | 100%          |
| break-pane     | Pane     | `Tmux:break_pane`     | 80% (Format)  |
| capture-pane   | Pane     | `Tmux:capture_pane`   | 100%          |
| join-pane      | Pane     | `Tmux:join_pane`      | 100%          |
| kill-pane      | Pane     | `Tmux:kill_pane`      | 100%          |
| last-pane      | Pane     | `Tmux:last_pane`      | 100%          |
| resize-pane    | Pane     | `Tmux:resize_pane`    | 100%          |
| swap-pane      | Pane     | `Tmux:swap_pane`      | 100%          |
| select-pane    | Pane     | `Tmux:select_pane`    | 100%          |


**Attention**: It is highly recommended to use the `Tmux:` functions instead of accessing the different modules for it as those can change and break more often. 



## Contributing

If you want to contribute to the project this is your section.
First of all, thank for considering helping develop and mantain it, I appreciate it.

Now, this project does not try to reinvent the wheel or reimagine what `tmux` is about. Instead it focuses on being the thinnest layer between Neovim and Tmux.  You should use the official tmux manual to implement the missing functions, fix current code or mantain it in different versions.

If you have a workflow that is composed of multiple tmux functions you still can submit a PR and if approved it will be added to an special module of it.

*The guidelines and templates will soon be available.*



