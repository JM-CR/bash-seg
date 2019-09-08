#!/bin/bash

##
# Verifica si el usuario introdujo argumentos válidos.
#
# @author Josue Mosh
# @param Argumentos de consola
function argumentosValidos() {
  if (( ${1} == 0 || ${1} == 3 || ${1} > 4)); then
    echo "Error: Número de argumentos inválido."
    ayuda
    exit 1
  fi
}