set dotenv-load := true

# By default, run checks and tests, then format and lint
default:
  if [ ! -d venv ]; then just install; fi
  @just format
  @just check
  @just test
  @just lint

#
# Installing, updating and upgrading dependencies
#

_venv:
  if [ ! -d venv ]; then python3 -m venv venv; fi
  . ./venv/bin/activate && pip install --upgrade pip pip-tools wheel

_clean-venv:
  rm -rf venv

# Install all dependencies
install:
  @just _venv
  @just compile
  . ./venv/bin/activate && pip install -r requirements_dev.txt
  . ./venv/bin/activate && pip install -e .
  if [ ! -d .terraform ]; then terraform init; fi

# Update all dependencies
update:
  @just _venv
  . ./venv/bin/activate && pip install pip pip-tools wheel --upgrade
  @just _clean-compile
  @just install

# Update all dependencies and rebuild the environment
upgrade:
  if [ -d venv ]; then just update && just check && just _upgrade; else just update; fi

_upgrade:
  @just _clean-venv
  @just _venv
  @just _clean-compile
  @just compile
  @just install

# Generate locked requirements files based on dependencies in pyproject.toml
compile:
  . ./venv/bin/activate && python -m piptools compile --resolver=backtracking -o requirements.txt pyproject.toml
  . ./venv/bin/activate && python -m piptools compile --resolver=backtracking --extra=dev -o requirements_dev.txt pyproject.toml

_clean-compile:
  rm -f requirements.txt
  rm -f requirements_dev.txt

# Generate the site
generate:
  . ./venv/bin/activate && python3 -m wholesomecoolness.generator

#
# Development tooling - linting, formatting, etc
#

# Format with black and isort
format:
  . ./venv/bin/activate &&  black './generator'
  . ./venv/bin/activate &&  isort --settings-file . './generator'

# Lint with flake8
lint:
  . ./venv/bin/activate && flake8 './generator'
  . ./venv/bin/activate && validate-pyproject ./pyproject.toml

# Check type annotations with pyright
check:
  . ./venv/bin/activate && npx pyright@latest

#
# Shell and console
#

shell:
  . ./venv/bin/activate && bash

console:
  . ./venv/bin/activate && jupyter console

# Clean up loose files
clean: _clean-venv _clean-compile
  rm -rf generator.egg-info
  rm -f generator/*.pyc
  rm -rf generator/__pycache__

deploy:
  terraform apply -auto-approve
