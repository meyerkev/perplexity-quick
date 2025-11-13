.PHONY: install run upgrade venv

venv:
	@if [ ! -d "venv" ]; then \
		python3 -m venv venv; \
	fi

install: venv
	venv/bin/pip install -r requirements.txt

run: venv
	venv/bin/python app.py

upgrade: venv
	venv/bin/pip install --upgrade -r requirements.base.txt
	venv/bin/pip freeze | grep -E "^Flask==|^requests==" > requirements.txt

