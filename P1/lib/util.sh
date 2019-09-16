#!/bin/bash

##
# Muestra menú de ayuda.
#
# @author Josue Mosh
function ayuda() {
  echo "Escribir menú ayuda"
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
    sed -i "1d" logFiltrado
    echo "${tiempoSesionActual}" >> logFiltrado
  fi

  # Regresar tiempos
  echo $(cat logFiltrado) && rm logFiltrado
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

  while (( ${#usuario} < 10 )); do
    usuario="${usuario} "
  done

  echo "USUARIO    |  TIEMPO"
  echo "${usuario} |  ${tiempo}"
}
