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
  grep "${usuario}" < ${log} > logFiltrado

  # Verificar si aún está conectado
  read tiempoSesionActual < <(sesionEnCurso "logFiltrado")

  # Filtrar tiempos por sesión
  local tiempos=$(awk '{print $10}' logFiltrado)
  echo "${tiempos}" > logFiltrado

  if [[ -n ${tiempoSesionActual} ]]; then
    sed -i "1d" logFiltrado
    echo "(${tiempoSesionActual})" >> logFiltrado
  fi

  # Regresar tiempos
  echo $(cat logFiltrado) && $(rm logFiltrado)
}