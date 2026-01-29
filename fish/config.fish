if status is-interactive
    # Commands to run in interactive sessions can go here
end

function nv
  set SOCKET_FILE $(fd -1 "nvim.*.*" /run/user/$(id -u $(whoami)))
  echo $SOCKET_FILE
  if test -n "$SOCKET_FILE"
    nvim --server "$SOCKET_FILE" --remote-send '<C-\><C-N>:vsplit<CR>'
    nvim --server "$SOCKET_FILE" --remote $argv
  else
    nvim $argv
  end
end

# BEGIN opam configuration
# This is useful if you're using opam as it adds:
#   - the correct directories to the PATH
#   - auto-completion for the opam binary
# This section can be safely removed at any time if needed.
test -r '/home/gera/.opam/opam-init/init.fish' && source '/home/gera/.opam/opam-init/init.fish' > /dev/null 2> /dev/null; or true
# END opam configuration
