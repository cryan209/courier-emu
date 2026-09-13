VENV ?= .venv
.PHONY: setup clean-venv clean-build

# Create the virtualenv and install every extra, without running the CLI.
setup:
	@./courier --help >/dev/null

clean-venv:
	rm -rf $(VENV)

clean-build:
	rm -rf .build build dist courier_emu.egg-info
