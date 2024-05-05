#!/bin/bash

# En primer lugar debemos crear la condicion de que tenga 2 argumentos. En caso de no cerrar esta primera y continuar con más condiciones los errores no se muestran correctamente. 

if [ $# -ne 2 ]; then
    echo "Error: mandatory argument is missing"
    exit 1
fi

# Declaramos las variables de los argumentos, file y year.

file="$1"
year="$2"
# creamos la primera condicion de si file es una archivo regular, un filtro si corresponde los años y un else para resto de valores.
if  [ ! -f "$file" ]; then
    echo "Error: first argument is not a regular file"
    exit 1
elif [ "$year" -lt 2010 ] || [ "$year" -gt 2021 ]; then
    echo "Error: second argument is not a valid year"
    exit 1
else
    echo "Ok"
fi
