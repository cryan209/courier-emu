VENV ?= .venv
PYTHON = $(VENV)/bin/python

.PHONY: setup test clean-venv clean-build

# Create the virtualenv and install every extra, without running the CLI.
setup:
	@./courier --help >/dev/null

test: setup
	$(PYTHON) -m unittest discover -s tests -v

clean-venv:
	rm -rf $(VENV)

clean-build:
	rm -rf .build build dist courier_emu.egg-info
