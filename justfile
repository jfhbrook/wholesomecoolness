set dotenv-load := true

setup:
  if [ ! -d .terraform ]; then terraform init; fi

deploy:
  terraform apply -auto-approve
