#!/usr/bin/env bash
# @name ollama
# @version 0.1.0
# @description A rargs script template
# @author

# Remember that all comments will be striped by default. You can use `##` to keep them around.

# This function will be called if no sub-sommand it's passed to it. I'll inherit the `@flags`,
# `@options`, `@args`, etc., from the global scope.
root() {
  echo "Root command"
}

# This function will be called if the subcommand `subcommand` is passed to it. It will override any
# `@flags`, `@options`, `@args`, etc., from the global scope, and inherit the rest.
# @cmd Subcommand example
subcommand() {
  echo "Subcommand"
}
