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
      archivoValido ${archivo}
    ;;
    h)
      ayuda
      exit 0
    ;;
    *)
      echo "Error: Argumento inválido."
      ayuda
      exit 1
    ;;
  esac
done

# Evaluar flags
if [[ -n ${usuario} && -n ${archivo} ]]; then
  read tiemposPorSesion < <(filtrarLogConUsuario ${usuario} ${archivo})
  echo $tiemposPorSesion
else
  echo "To Do"
fi