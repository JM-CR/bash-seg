#!/bin/bash

# Importar bibliotecas
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

# Casos de ejecución
if [[ -n ${usuario} && -n ${archivo} ]]; then
  read tiemposPorSesion < <(filtrarLogConUsuario ${usuario} ${archivo})
  read tiempoTotal < <(tiempoDeConexion "${tiemposPorSesion}")
  echo "USUARIO   | TIEMPO"
  imprimeTiempo ${usuario} ${tiempoTotal}
elif [[ -n ${usuario} ]]; then
  ayuda
  exit 2
else  
  read userArray < <(obtenerUsuarios ${archivo})
  echo "USUARIO   |  TIEMPO"
  for usuarioAMandar in ${userArray}; do
	  read tiemposPorSesion < <(filtrarLogConUsuario ${usuarioAMandar} ${archivo})
  	read tiempoTotal < <(tiempoDeConexion "${tiemposPorSesion}")
    imprimeTiempo ${usuarioAMandar} ${tiempoTotal}
  done
fi
