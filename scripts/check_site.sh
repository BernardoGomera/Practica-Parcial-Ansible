#!/usr/bin/env bash
set -euo pipefail

hosts=("http://localhost:8085" "http://localhost:8095")

echo "[check] Validando sitios desplegados..."

for url in "${hosts[@]}"; do
  echo "--> ${url}"
  body=$(curl -fsSL "${url}")
  if [[ "${body}" != *"2020-9643"* ]]; then
    echo "Contenido inesperado en ${url}" >&2
    exit 1
  fi
  echo "    OK"
  sleep 1
 done

echo "Todos los sitios respondieron correctamente."
