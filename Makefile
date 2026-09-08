VENV ?= .venv
PYTHON = $(VENV)/bin/python

.PHONY: setup test clean-venv clean-build

# Create the virtualenv and install every extra, without running the CLI.
setup:
	@./courier --help >/dev/null

# pytest, not unittest discover: several of the kept tests are module-level
# functions parametrised over both board images, which discover does not see.
test: setup
	$(PYTHON) -m pytest tests -q

clean-venv:
	rm -rf $(VENV)

clean-build:
	rm -rf .build build dist courier_emu.egg-info
