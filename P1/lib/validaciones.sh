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

  local totalDeColumnas=$(awk '{print NF}' ${archivo} | sort -nu | tail -n 1)
  if (( ${totalDeColumnas} < 10 )); then
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
  local tiempoEnCurso
  local sesionActiva=$(grep --regexp="\bin\b" ${log} | head -1)

  if [[ ${sesionActiva} =~ "logged" ]]; then 
    # Calcular tiempo de sesión
    local mesInicial=$(awk '{print $5}' <<< ${sesionActiva})
    local diaInicial=$(awk '{print $6}' <<< ${sesionActiva})
    local horaInicial=$(awk '{print $7}' <<< ${sesionActiva})
    local horaFinal=$(date +"%b %d %T")
    local segI=$(date -ud "${mesInicial} ${diaInicial} ${horaInicial}:00" +"%s")
    local segF=$(date -ud "${horaFinal}" +"%s")
    local diferencia=$(( ${segF} - ${segI} ))

    # Formato del tiempo calculado
    if (( ${diferencia} / 3600 > 0 )); then
      tiempoEnCurso=$(date -ud "0 ${diferencia} sec" +"%H+%M:%S")
    else
      tiempoEnCurso=$(date -ud "0 ${diferencia} sec" +"%M:%S")
    fi 

    # Sumar horas de días anteriores
    if (( ${diferencia} >= 3600 * 24 )); then
      local horasExtra=$(( ${diferencia} / 3600 - ${tiempoEnCurso:0:2} ))
      read tiempoEnCurso < <(sumaHoras ${tiempoEnCurso} "${horasExtra}:00:00")
    fi
  fi

  echo ${tiempoEnCurso}
}
