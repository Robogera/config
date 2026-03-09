#!/usr/bin/env fish

if test -n "$argv[1]"
  set screen_area -g "$(slurp)"
end

grim $screen_area "$HOME/pics/screenshots/s_$(date +'%Y-%m-%d_%H-%M-%S_%3N').png"

