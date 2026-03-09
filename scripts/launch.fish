#!/bin/fish

cd ~/.config/launcher

ls . \
  | fzf --style=minimal \
  | xargs cat \
  | read --list exec

if string match -qr '[^0]' $pipestatus
    exit 1
end

mmsg -d spawn,"env $exec"
