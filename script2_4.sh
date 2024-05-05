#!/bin/bash

# Declaramos las variables y declaramos countries_count
file="$1"
year="$2"


declare -a countries_counts

# Iniciacilizamos la variable.

countries_sum=0

# Leemos el archivo con un bucle while.
while IFS=";" read -r headline_year frequency; do
  if [ "$headline_year" == "$year" ]; then
    countries_counts+=("$frequency")
    countries_sum=$((countries_sum + frequency))
  fi
done < "$file"

# Imprimimos los valores indicados.

echo "${countries_counts[@]}"

echo "$countries_sum"
