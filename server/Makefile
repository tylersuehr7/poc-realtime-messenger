SHELL := /bin/sh

setup-dev-environment:
	(set -a && \
	source ./vars.dev.env && \
	set +a && \
	source ./.venv/bin/activate && \
	pip3 install --upgrade pip && \
	pip3 install -r requirements.txt)
	make setup-dev-sqlite

setup-dev-sqlite:
	rm db.sqlite3 || true
	find server -name "00**.py" -type f -delete || true
	(set -a && \
	source ./vars.dev.env && \
	set +a && \
	source ./.venv/bin/activate && \
	./entrypoint.sh)

make-migrations-and-migrate:
	(set -a && \
	source ./vars.dev.env && \
	set +a && \
	source ./.venv/bin/activate && \
	python3 manage.py makemigrations && \
	python3 manage.py migrate)

generate-openapi-clients:
	(set -a && \
	source ./vars.dev.env && \
	set +a && \
	source ./.venv/bin/activate && \
	rm -rf generated-clients && \
  	python3 manage.py spectacular --file schema.yml && \
  	python3 manage.py runscript generate_openapi_clients)
