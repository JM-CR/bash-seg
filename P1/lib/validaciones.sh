#!/bin/bash

##
# Verifica si el usuario introdujo argumentos válidos.
#
# @author Josue Mosh
# @param Argumentos de consola
function argumentosValidos() {
  if (( ${1} == 0 || ${1} == 3 || ${1} > 4 )); then
    echo "Error: Número de argumentos inválido."
    ayuda
    exit 1
  fi
}

##
# Verifica si el archivo existe y si es un log dado por "last".
#
# @author Josue Mosh
# @param Nombre del archivo
function archivoValido() {
  if [[ ! -e ${1} ]]; then
    echo "Error: El archivo no existe."
    exit 1
  fi

  totalColumnas=$(awk '{print NF}' ${archivo} | sort -nu | tail -n 1)
  if (( ${totalColumnas} != 10 )); then
    echo "Error: El archivo no es un log válido"
    exit 1
  fi
}