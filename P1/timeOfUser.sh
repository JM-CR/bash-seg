#!/bin/bash

# Importar librerías
source lib/validaciones.sh
source lib/util.sh

argumentosValidos ${#}

# Evaluar flags
OPTERR=0   # Desactivar errores de "getopts"
while getopts "hu:f:" opcion; do
  case ${opcion} in
    u)
      usuario=${OPTARG}
    ;;
    f)
      archivo=${OPTARG}
    ;;
    h)
      ayuda
      exit 1
    ;;
    *)
      echo "Error: Argumento inválido."
      ayuda
      exit 1
    ;;
  esac
done
