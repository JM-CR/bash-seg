#!/bin/bash

# Importar librerías
source lib/validaciones.sh
source lib/operaciones.sh
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

# Template de salida
echo "USUARIO   |  TIEMPO"

# Casos de ejecución
if [[ -n ${usuario} && -n ${archivo} ]]; then
  read tiemposPorSesion < <(filtrarLogConUsuario ${usuario} ${archivo})
  read tiempoTotal < <(tiempoDeConexion "${tiemposPorSesion}")
  imprimeTiempo ${usuario} ${tiempoTotal}
else
  read userArray < <(obtenerUsuarios ${archivo})
  for usuarioAMandar in ${userArray}; do
	  read tiemposPorSesion < <(filtrarLogConUsuario ${usuarioAMandar} ${archivo})
  	read tiempoTotal < <(tiempoDeConexion "${tiemposPorSesion}")
    imprimeTiempo ${usuarioAMandar} ${tiempoTotal}
  done
fi