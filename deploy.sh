#!/bin/bash

# Script para automatizar o deploy do Terraform por ambiente
# Uso: ./deploy.sh <ambiente> (ex: dev, homolog, prod)

ENV=$1

if [ -z "$ENV" ]; then
    echo "❌ Erro: Você precisa passar o ambiente como parâmetro."
    echo "Uso: ./deploy.sh <dev|homolog|prod>"
    exit 1
fi

TFVARS="envs/${ENV}.tfvars"

if [ ! -f "$TFVARS" ]; then
    echo "❌ Erro: Arquivo de variáveis não encontrado: $TFVARS"
    exit 1
fi

echo "🚀 Iniciando deploy para o ambiente: [$ENV]"

# 1. Inicializar o Terraform com o backend específico para o ambiente
echo "📦 Inicializando backend (key=${ENV}/terraform.tfstate)..."
terraform init \
    -backend-config="backend.hcl" \
    -backend-config="key=${ENV}/terraform.tfstate" \
    -reconfigure

if [ $? -ne 0 ]; then
    echo "❌ Erro na inicialização do Terraform."
    exit 1
fi

# 2. Executar o Apply
echo "🛠️ Aplicando infraestrutura..."
terraform apply -var-file="$TFVARS" -auto-approve

if [ $? -eq 0 ]; then
    echo "✅ Deploy concluído com sucesso para o ambiente: [$ENV]!"
else
    echo "❌ Erro durante o terraform apply."
    exit 1
fi
