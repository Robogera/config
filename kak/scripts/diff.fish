#!/usr/bin/env fish

if test (count $argv) -lt 2
    echo 'need two files to diff'
    return 1
end

if test (count $argv) -gt 2
    echo 'cannot diff more than two files'
    return 1
end

for file in $argv
    if not test -e $file
        echo "$file does not exist"
        return 1
    end
end

# Create temporary file for diff
set -l diff (mktemp --tmpdir="$XDG_RUNTIME_DIR")

# Set absolute paths so diff-jump works from the temporary file
set -l old (realpath $argv[1])
set -l new (realpath $argv[2])

diff -u $old $new >$diff

# Exit if files are the same
if test $status -eq 0
    echo 'files are identical'
    return 1
end

# Exit if diff fails
if test $status -eq 2
    return 1
end

# Update diff when files change
printf %s\n $argv | entr -nps "diff -u $old $new >$diff" &>/dev/null &
set -l entr $last_pid

kak $diff

# Clean up after editor exits
kill $entr
rm $diff

