#!/bin/bash

##
# Verifica si el usuario introdujo argumentos válidos.
#
# @author Josue Mosh
# @param ${1} Total de argumentos por consola
function argumentosValidos() {
  local totalArgs=${1}
  if (( ${totalArgs} == 0 || ${totalArgs} == 3 || ${totalArgs} > 4 )); then
    echo "Error: Número de argumentos inválido."
    ayuda
    exit 1
  fi
}

##
# Verifica si el archivo existe y si es un log dado por "last".
#
# @author Josue Mosh
# @param ${1} Nombre del archivo
function archivoValido() {
  local archivo=${1}
  if [[ ! -e ${archivo} ]]; then
    echo "Error: El archivo no existe."
    exit 1
  fi

  local totalDeColumnas=$(awk '{print NF}' ${1} | sort -nu | tail -n 1)
  if (( ${totalDeColumnas} != 10 )); then
    echo "Error: El archivo no es un log válido."
    exit 1
  fi
}

##
# Verifica si hay una sesión activa y calcula su duración.
#
# @author Josue Mosh
# @param ${1} Archivo log
# @return Devuelve el tiempo de sesión activa o un null
function sesionEnCurso() {
  local log=${1}
  local tiempoSesionActual
  local sesionActiva=$(awk '{print $10}' ${log} | head -1)

  if [[ ${sesionActiva} == "in" ]]; then 
    # Calcular tiempo de sesión
    local horaInicial=$(awk '{print $7}' ${log} | head -1)
    local horaFinal=$(date +%T)
    local segI=$(date -u -d "${horaInicial}:00" +"%s")
    local segF=$(date -u -d "${horaFinal}" +"%s")

    # Formato del tiempo calculado
    if (( (${segI} - ${segF}) / 3600 > 0 )); then
      tiempoSesionActual=$(date -ud "0 ${segF} sec - ${segI} sec" +"%H+%M:%S")
    else
      tiempoSesionActual=$(date -ud "0 ${segF} sec - ${segI} sec" +"%M:%S")
    fi 
  fi

  echo ${tiempoSesionActual}
}