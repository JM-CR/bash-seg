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