#!/usr/bin/fish

read | string split --no-empty "'" | sed '/^[[:space:]]*$/d'
