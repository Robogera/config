#!/usr/bin/env fish

set file_path "$HOME/pics/screenshots/s_$(date +'%Y-%m-%d_%H-%M-%S_%3N').png"

if test -n "$argv[1]"
  set screen_area -g "$(slurp)"
end

grim $screen_area $file_path

magick $file_path PNG:- | wl-copy
