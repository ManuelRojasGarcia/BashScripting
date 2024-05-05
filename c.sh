#!/bin/bash
#Nombre y apellidos del alumno: Manuel Rojas Garcia
#Usuario de la UOC del alumno: mrojasgar
#Fecha:30/12/2023

#CODIGOS PROVISIONAL

# Verificar si se proporcionan rangos personalizados
#if [ "$#" -ge 3 ]; then
#    rangos=("$3"-"$4")
#else
#    rangos=("18-29" "30-39" "40-49" "50-99")

#for rango in $rangos; do
#    if [ $rango == '>=50' ]; then
#		min=50
#		max=99
#	else
#		min=$(echo $rango | cut -d '-' -f 1)
#		max=$(echo $rango | cut -d '-' -f 2)
#	fi

#unir los csv y copiar
#union=$(join -t ';' -1 1 -2 1 -a 1 "$archivo_profiles" "$archivo_marks")
#union_filtrada=$(echo "$union" | grep -E '^[^;]+;[^;]+;[^;]+;[^;]+;1;')

## CODIGO FINAL

#Se incluye algun awk sin abusar para poder estar cerca de rango 15.
#No se incluye cuando no hay argumento y debe ser un rango, se incluye en el provisional lo avanzado hasta tiempo limite de entrega de la PEC.

# Verificar la cantidad de parámetros
if [ "$#" -lt 2 ]; then
    echo "Error: mandatory parameter not found"
    exit 1
fi

# Verificación de la existencia de archivos
if [ ! -f "$1" ] || [ ! -f "$2" ]; then
    echo "Error: mandatory parameter is not a valid file"
    exit 1
fi

# Verificar si el tercer o cuarto parámetro no es un número natural mayor o igual a 0
if ! [[ "$3" =~ ^[0-9]+$ ]] || ! [[ "$4" =~ ^[0-9]+$ ]]; then
    echo "Error: invalid data type when defining age range"
    exit 1
fi

# Verificar si el tercer parámetro es mayor al cuarto parámetro
if [ "$#" -eq 3 ] || [ "$3" -gt "$4" ]; then
    echo "Error: invalid age range"
    exit 1
fi

if [ "$3" -lt 18 ]; then
    echo "Warning: no records found for $3-$4 age range"
    exit 0
fi

# Asignar nombres descriptivos a los argumentos
archivo_marks="$1"
archivo_profiles="$2"
edad_minima="$3"
edad_maxima="$4"

# Tu comando original para filtrar y calcular la edad
resultado_filtrado=$(join -t ';' -1 1 -2 1 <(grep ';1;' "$archivo_profiles" | sort -t ';' -k1,1) <(sort -t ';' -k1,1 -k2,2r "$archivo_marks") | sort -u -t ';' -k1,1 | awk -F';' '{print $0 ";" ($7 - $4)}')

# Obtener el número total de alumnos graduados
alumnosgraduados=$(grep ';1;' "$archivo_profiles" | awk -F';' '{sum += $5} END {print sum}')

# Obtener el número de semestres únicos
semestresunicos=$(echo "$resultado_filtrado" | cut -d ';' -f7 | sort -u | wc -l)

# Obtener el número de asignaturas únicas
asignaturasunicas=$(echo "$resultado_filtrado" | cut -d ';' -f8 | sort -u | wc -l)

# Obtener asignaturas
asignaturas=$(join -t ';' -1 1 -2 1 "$1" "$2" | grep -E ';1;' | sort -u -t ';' -k1,3 )
numeroasignaturas=$(echo "$asignaturas" | wc -l)

# Obtener semestres
semestres=$(echo "$asignaturas" | sort -u -t ';' -k1,2r)
numerosemestres=$(echo "$semestres" | wc -l )

# Obtener perfiles
alumnos=$(echo "$semestres" | sort -u -t ';' -k1,1)
alumnosgraduados=$(echo "$alumnos" | wc -l)

# Obtener media asignatura total
semestresmediatotal=$(awk "BEGIN {printf \"%.3f\", $numerosemestres / $alumnosgraduados}")

# Obtener media total asignatura 
asignaturasmediatotal=$(awk "BEGIN {printf \"%.3f\", $numeroasignaturas / $alumnosgraduados}")

# Mirar si es valor 0 alumnosgraduados

if [ "$alumnosgraduados" -ne 0 ]; then
    # Realizar la operación solo si alumnosgraduados no es cero
    resultado_final=$(join -t ';' -1 1 -2 1 -a 1 <(echo "$resultado_filtrado") <(echo "$union_filtrada_con_edad") | awk -F';' '{if ($5 == "") $5 = 1; print $0}')
else
# Establecer resultado_final a un valor predeterminado si alumnosgraduados es cero
    resultado_final=""
fi

#filtro adicional con el rango de los argumentos(usando awk)
union_filtrada_con_edad_rango=$(awk -F';' -v min="$edad_minima" -v max="$edad_maxima" '$10 >= min && $10 <= max' <<< "$resultado_final")

# Version rapida a 14 seg
#coincidenciasrango=$(awk -F';' -v min="$edad_minima" -v max="$edad_maxima" '$10 >= min && $10 <= max {count++} END {printf "%d", count}' <<< "$resultado_filtrado")

# Contador de coincidencias en el rango de edades (Version lenta a 17 segundos)
coincidenciasrango=0
while IFS=';' read -r col1 col2 col3 col4 col5 col6 col7 col8 col9 col10; do
    if [[ "$col10" =~ ^[0-9]+$ && "$col10" -ge $edad_minima && "$col10" -le $edad_maxima ]]; then
        ((coincidenciasrango++))
    fi
done <<< "$resultado_filtrado"

# Filtrar union_filtrada y conservar líneas con valores únicos y donde columna 1 y 7 sean idénticos3
union_filtrada_semestre=$(echo "$union_filtrada_con_edad_rango" | sort -t ';' -u -k1,1 -k7,7)

# Filtrar union_filtrada y conservar líneas con valores únicos y donde columna 1 y 8 sean idénticos
union_filtrada_asignatura=$(echo "$union_filtrada_con_edad_rango" | sort -t ';' -u -k1,1 -k8,8)

# Obtener el número de filas de la variable union_filtrada_con_edad
numtotalfilasid=$(echo "$union_filtrada_semestre" | wc -l)

numtotalfilasasignatura=$(echo "$union_filtrada_asignatura" | wc -l)

if [ "$coincidenciasrango" -eq 0 ]; then
    media_semestres=0
    media_subject=0
else
    media_semestres=$(awk "BEGIN {printf \"%.3f\", $numtotalfilasid / $semestresunicos}")
    media_subject=$(awk "BEGIN {printf \"%.3f\", $numtotalfilasasignatura / $asignaturasunicas}")
fi

# Imprimir los resultados actualizados
echo "Alumni (N=$coincidenciasrango) $edad_minima-$edad_maxima: $porcentaje%, semester: $media_semestres, subject: $media_subject"
echo "Alumni (Total=$alumnosgraduados) semester: $semestresmediatotal, subject: $asignaturasmediatotal"


