#!/bin/bash

# Libraries
source lib/validaciones.sh
source lib/operaciones.sh

##
# Muestra menú de ayuda.
#
# @author Bruno Valerio
function ayuda() {
  local helpmenu="
Este script calcula el tiempo que un usuario ha estado conectado en Antares.
Este script requiere 2 o 4 argumentos:
para ejecutar con 2, utilice \"-f\" [nombre del archivo con los usuarios]
para ejecutar con 4, utilice tambien \"-u\" [nombre del ususario]
"
  echo "$helpmenu"
}

##
# Filtra los tiempos por sesión de un usuario. 
#
# @author Josue Mosh
# @param ${1} Usuario a filtrar
# @param ${2} Archivo por analizar
# @return Tiempo que duró cada conexión
function filtrarLogConUsuario() {
  local usuario=${1}
  local log=${2}

  # Buscar usuario
  grep --regexp="\b${usuario}\b" < ${log} > logFiltrado

  # Verificar si aún está conectado
  read tiempoSesionActual < <(sesionEnCurso "logFiltrado")

  # Filtrar tiempos por sesión
  local tiempos=$(awk '{print $10}' logFiltrado)
  echo "${tiempos}" > logFiltrado

  if [[ -n ${tiempoSesionActual} ]]; then
    sed -i "/in/d" logFiltrado
    echo "${tiempoSesionActual}" >> logFiltrado
  fi

  # Regresar tiempos
  echo $(cat logFiltrado) && rm logFiltrado
}

##
# Filtra los usuarios que estén dentro del archivo.
#
# @author Jair Hernandez
# @param ${1} Archivo por analizar
# @return Arreglo de usuarios
function obtenerUsuarios() {
  local log=${1}
  local usuarios=$(awk '{print $1}' ${log} | sort -u)

  echo ${usuarios}
}

##
# Calcula el tiempo total de conexiones.
#
# @author Josue Mosh
# @param ${1} Arreglo de tiempos por sesión
# @return Tiempo total
function tiempoDeConexion() {
  local tiemposPorSesion=${1}
  local tiempoTotal="00:00:00"

  for tiempoASumar in ${tiemposPorSesion}; do
    read tiempoTotal < <(sumaHoras ${tiempoTotal} ${tiempoASumar})
  done

  echo ${tiempoTotal}
}

##
# Imprime en consola un usuario y su tiempo de conexión.
# 
# @author Josue Mosh
# @param ${1} Usuario a imprimir
# @param ${2} Tiempo a imprimir
function imprimeTiempo() {
  local usuario=${1}
  local tiempo=${2}

  while (( ${#usuario} < 9 )); do
    usuario+=" "
  done

  echo "${usuario} |  ${tiempo}"
}
