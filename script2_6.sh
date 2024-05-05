#!/bin/bash

# El código es igual a los ejercicios anteriores, pero donde else es OK realizamos un bucle for para obtener los porcentajes.
# Regular file contiene un error que en el anterior código no ocurre.

if [ $# -ne 2 ]; then
    echo "Error: mandatory argument is missing"
    exit 1
fi

file="$1"
year="$2"

declare -a countries_counts

countries_sum=0

while IFS=";" read -r headline_year frequency; do
  if [ "$headline_year" == "$year" ]; then
    countries_counts+=("$frequency")
    countries_sum=$((countries_sum + frequency))
  fi
done < "$file"


if  [ ! -f "$file" ]; then
    echo "Error: first argument is not a regular file"
    exit 1
elif [ "$year" -lt 2010 ] || [ "$year" -gt 2021 ]; then
    echo "Error: second argument is not a valid year"
    exit 1
else
    for freq in "${countries_counts[@]}"; do
    	percentage=$(( (freq * 100) / countries_sum ))
    	echo "$freq $percentage%"
    done
fi
