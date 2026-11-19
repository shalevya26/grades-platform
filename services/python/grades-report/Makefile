# Every service answers the same two commands, so one CI job fits all of them.

install-ci:
	pip install -r requirements-dev.txt

test:
	ruff check .
	pytest -q

.PHONY: install-ci test
