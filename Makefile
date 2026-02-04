.PHONY: lint test tf-validate ci-local

ci-local: lint tf-validate test

lint:
	@echo "Cleaning..."
	black .
	@echo "Check Flake8..."
	flake8 . --count --exit-zero --max-complexity=10 --max-line-length=127 --statistics

tf-validate:
	@echo "Check Terraform..."
	terraform -chdir=terraform fmt
	terraform -chdir=terraform init -backend=false
	terraform -chdir=terraform validate

test:
	@echo "Unit tests..."
	pytest tests/