set dotenv-load := true

setup:
  if [ ! -d .terraform ]; then terraform init; fi

lint:
  hadolint Dockerfile

plan:
  terraform plan

serve:
  cd ./public && python -m http.server

deploy:
  terraform apply -auto-approve
