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
  local sesionEnCurso=$(awk '{print $10}' logFiltrado | head -1)

  if [[ ${sesionEnCurso} == "in" ]]; then 
    # Calcular tiempo de sesión actual
    local horaInicial=$(awk '{print $7}' logFiltrado | head -1)
    local horaFinal=$(date +%T)
    local segI=$(date -u -d "${horaInicial}:00" +"%s")
    local segF=$(date -u -d "${horaFinal}" +"%s")

    # Formato del tiempo calculado
    if (( (${segI} - ${segF}) / 3600 > 0 )); then
      local tiempoSesionActual=$(date -ud "0 ${segF} sec - ${segI} sec" +"%H+%M:%S")
    else
      local tiempoSesionActual=$(date -ud "0 ${segF} sec - ${segI} sec" +"%M:%S")
    fi
  fi

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