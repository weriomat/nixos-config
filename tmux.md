# Notes on Tmux

# Overview
Tmux consists of sessions, windows, panes
-> the window we are currently on is marked with a `*`

# Keybinds
-> Prefix Key currently `crtrl + a`

## Create New Window -> set as current window
`pref + c`

## change windows 
`pref + <num>` -> number to jump to
`pref + n` -> goto next window
`pref + p` -> goto prev window

## move windows around
`pref + :swapwindow -s 2 -t 1` swaps 2nd with 1st window

## kill a window
-> close all panes with `ctrl + d` | `exit`
-> `pref + &`

## missalenious
`pref + ?` | `pref + :list-keys` -> list keybindings 
`pref + o` -> tmux sessionx

## sessionx
TODO: here
`pref + `

## manage windows
`pref + c` -> create window
`pref + ,` -> rename window
`pref + &` -> close cur window
`pref + w` -> list windows
`pref + p` -> pref window
`pref + n` -> next window
`pref + <number>` -> goto <number> window
`pref + i` -> toggle last active window
`pref + :movew -r` -> renumber windows if gap in numbering
`pref + :movew -s foo:0 -t bar:9` -> move window from s to t

## manage panes
`pref + %` -> split window horizontally
`pref + "` -> split window vertically
`pref + <arrow>` -> switch pane 
`pref + {/}` -> move current pane left/right
`pref + q` -> select to switch to
`pref + z` -> zoom into a pane (makes it fullscreen)
`pref + !` -> make current pane into a new window
`pref + x` -> closes a pane
`pref + ;` -> toggle last active pane
`pref + :join-pane -s 2 -t 1` join two windows as panes 
`pref + <spc>` -> toggle between layouts
`pref + o` -> next pane
`pref + :setw synchronize-panes` -> toggle synchronize-panes (send command to all panes)
`pref + <up>|<down>|<left>|<right>` -> resize current pane


## copy mode
`pref + [` -> enter copy mode
`pref + <PgUp>` -> Enter copy mode and scroll one page up
`q` quit mode
`g` goto top line
`G` goto bottom line
`<up>|<down>` move in that direction
vim keybindings
`/` search forwards
`?` search backwards
`n` next word occurance
`N` prev word occurenca
`<spc>` -> start selectionm
`<esc>` -> clear selection
`<entr>` -> copy selection
`pref + ]` -> paste contents of buffer_0
`pref + :show-buffer` -> displays contents of buffer_0
`:capture-pane` -> copy entire visible contents of pane to a buffer
`:list-buffers`
`:choose-buffer`
`:delete-buffer -b 1`

`pref + ctrl + v` -> copy highlight
`pref + v` -> start highlting
`pref + y` -> yank

# keybindings
`bind-key -T copy-mode-vi v send-keys -X begin-selection`
`bind-key -T copy-mode-vi C-v send-keys -X rectangle-toggle`
`bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel`

## manage sessions
`tmux` -> creates a new session
`tmux new -s <name>` -> creates a new named session
`tmux ls` -> list sessions
`pref + s` -> list all sessions
`tmux attach` -> attaches to the most recent session
`tmux attach -t <name>` -> attaches to a named session
`pref + :kill-session` -> deletes current session
`tmux kill-session -t <name>` -> deletes named session 
`tmux kill-session -a` -> deletes all sessions beside the current one
`pref + $` -> rename a session
`pref + d` -> detach from session
`pref + w` -> session and window preview
`pref + (` -> move to prev session
`pref + )` -> move to next session

## tmux resurrect
`pref + <ctrl> + s` -> saves session
`pref + <ctrl> + r` -> restore session

## tmux fuzzback
`pref + I` -> search through history

## tmux fzf url 
`pref + u` -> open url with xdg-open

## vim tmux navigator
`ctrl + <vimkeys>` -> navigate to that panel

## tmux-sessionx
`pref + O` -> open session manager
`alt + backsp` -> delete session
`ctrl + u|d|n|p`-> scroll preview up|down|up|down 
`ctrl + r` -> rename session
`ctrl + w` -> will reload the list with all available windows and their previews
`ctrl + x` -> will fuzzy read ~/.config or `@session-x-path`
`ctrl + e` -> expand `PWD` and search for local dir to create addition session from
`ctrl + b` -> back reload first query
`ctlr + t` -> reloads preview with sessions
`ctrl + /` -> tmuxinator
`?` -> toggle preview pane
