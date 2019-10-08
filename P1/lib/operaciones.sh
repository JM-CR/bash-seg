#!/bin/bash

##
# Calcula la suma de dos horas en formato (hh+mm:ss) ó (mm:ss).
#
# @author Josue Mosh
# @param ${1} Primer hora
# @param ${2} Segunda hora
# @return Suma en formato hh:mm:ss
function sumaHoras() {
    # Convertir a formato hh:mm:ss
    read hora_1 < <(convierteHora ${1})
    read hora_2 < <(convierteHora ${2})

    # Convertir a segundos
    read segs_1 < <(convierteASegundos ${hora_1})
    read segs_2 < <(convierteASegundos ${hora_2})

    # Calcular tiempo
    local total=$(( ${segs_1} + ${segs_2} ))
    local horasT=$(( ${total} / 3600 ))
    local minsT=$(( (${total} - ${horasT} * 3600) / 60 ))
    local segsT=$(( ${total} - ${horasT} * 3600 - ${minsT} * 60 ))

    # Formatear
    (( ${horasT} < 10 )) && horasT="0${horasT}"
    (( ${minsT} < 10 )) && minsT="0${minsT}"
    (( ${segsT} < 10 )) && segsT="0${segsT}"

    echo "${horasT}:${minsT}:${segsT}"
}

##
# Convierte una hora a formato hh:mm:ss.
#
# @author Josue Mosh
# @param ${1} Hora a convertir en formato (hh+mm:ss) ó (mm:ss)
# @return Hora en formato hh:mm:ss
function convierteHora() {
  local hora=${1}

  if [[ ${hora} =~ :[0-9]{2}: ]]; then
    :
  elif [[ ${hora} =~ "+" ]]; then
    hora=${hora#"("}
    hora=${hora%")"}
    local dias=$(( ${hora:0:1} * 24 ))
    dias="${dias}:00:00"
    hora="${hora:2:6}:00"
    read hora < <(sumaHoras ${dias} ${hora})
  else
    hora=${hora#"("}
    hora="${hora%")":00}"
  fi

  echo ${hora}
}

##
# Convierte una hora en formato hh:mm:ss a segundos.
#
# @author Josue Mosh
# @param ${1} Hora en formato hh:mm:ss
# @return Tiempo en segundos
function convierteASegundos() {
  local hora=${1}
  local segs

  if [[ ${hora} =~ ^[0-9]{3}: ]]; then
    segs=$(( ${hora:0:3} * 3600 + 10#${hora:4:2} * 60 + 10#${hora:7:2} ))
  else
    segs=$(( 10#${hora:0:2} * 3600 + 10#${hora:3:2} * 60 + 10#${hora:6:2} ))
  fi

  echo ${segs}
}
