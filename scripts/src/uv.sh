#!/usr/bin/env bash

# shellcheck disable=SC2154
# shellcheck disable=SC1091

# @name uv
# @version 0.1.0
# @description A uv wrapper
# @author Guzmán Monné

# @cmd Prints to `stderr` in `red`
# @any Any message to print
# @private
red() {
	gum style --foreground '#E53935' "$rargs_other_args"
}

# @cmd Activates a local virtual environment
# @arg source="." Source directory from where to activate the environment
va() {
	source "${rargs_source}/.venv/bin/activate" 2>/dev/null || source "${rargs_source}/../.venv/bin/activate" 2>/dev/null || red 'No .venv directory found on this or parent directory'
}

# @cmd Creates a new virtual environment
# @any Other 'uv venv' options
vc() {
	uv venv --seed --python-preference managed "$rargs_other_args"
}

# @cmd Deactivates a virtual environment
vd() {
	deactivate
}

# @cmd Fakes poetry install with uv
poetry-install() {
	uv pip install --no-deps -r <(POETRY_WARNINGS_EXPORT=false poetry export --without-hashes --with dev -f requirements.txt)
	poetry install --only-root
}
