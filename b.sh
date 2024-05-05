#!/bin/bash

# Nombre y apellidos del alumno: MANUEL ROJAS GARCIA
# Usuario de la UOC del alumno: mrojasgar
# Fecha: 26/12/2023

# Validación de argumentos
if [ $# -lt 2 ]; then
    echo "Error: mandatory parameter not found"
    exit 1
fi

# Verificación de la existencia de archivos
if [ ! -f "$1" ] || [ ! -f "$2" ]; then
    echo "Error: mandatory parameter is not a valid file"
    exit 1
fi

# Verificación de asignatura si se proporciona
if [ $# -eq 3 ]; then
    subject_code="$3"
    if ! grep -q ";$subject_code;" "$1"; then
        echo "Error: subject does not exist"
        exit 1
    fi
fi

# Cálculos adicionales cuando no se proporciona el tercer argumento
if [ $# -ne 3 ]; then
    # Combinar los archivos por el campo "id"
    combined_csv=$(join -t';' -1 1 -2 1 <(sort -t';' -k1 "$1") <(sort -t';' -k1 "$2"))
    
    # Lectura de notas y perfiles combinados
    notas=$(echo "$combined_csv" | cut -d';' -f2-)

    mujeres_suspendidas_totales=$(echo "$notas" | grep -E ";(SU|NP)" | grep ";F;" | wc -l)
    hombres_suspendidos_totales=$(echo "$notas" | grep -E ";(SU|NP)" | grep ";M;" | wc -l)
    suspendidos_totales=$((mujeres_suspendidas_totales + hombres_suspendidos_totales))
fi

# Filtros y cálculos para la asignatura específica si se proporciona
if [ $# -eq 3 ]; then
    # Filtrar las notas para la asignatura específica antes de combinar los archivos
    notas=$(grep ";$subject_code;" "$1" | sort -t';' -k1 | join -t';' -1 1 -2 1 - <(sort -t';' -k1 "$2") | cut -d';' -f2-)
fi

# Filtros y cálculos generales
total_fallos=$(echo "$notas" | grep -E ";(SU|NP)" | wc -l)
total_hombres=$(echo "$notas" | grep ";M;" | wc -l)
total_mujeres=$(echo "$notas" | grep ";F;" | wc -l)
fallos_hombres=$(echo "$notas" | grep ";M;" | grep -E ";(SU|NP)" | wc -l)
fallos_mujeres=$(echo "$notas" | grep ";F;" | grep -E ";(SU|NP)" | wc -l)

# Guardar totales en nuevas variables
total_hombres_guardado=$total_hombres
total_mujeres_guardado=$total_mujeres
total_fallos_guardado=$total_fallos

# Impresión de resultados
if [ $# -eq 3 ]; then
    # Cálculos para una asignatura específica
    echo "Percentage of failures by females for subject $subject_code: $(echo "scale=2; $fallos_mujeres * 100 / $total_mujeres_guardado" | bc)%"
    echo "Percentage of failures by males for subject $subject_code: $(echo "scale=2; $fallos_hombres * 100 / $total_hombres_guardado" | bc)%"
    echo "Percentage of failures for subject $subject_code (Total): $(echo "scale=2; $total_fallos * 100 / ($total_hombres_guardado + $total_mujeres_guardado)" | bc)%"
else
    # Cálculos generales para todas las asignaturas
    echo "Percentage of failures by females for all subjects: $(echo "scale=2; $mujeres_suspendidas_totales * 100 / $total_mujeres" | bc)%"
    echo "Percentage of failures by males for all subjects: $(echo "scale=2; $hombres_suspendidos_totales * 100 / $total_hombres" | bc)%"
    echo "Percentage of failures for all subjects (Total): $(echo "scale=2; $suspendidos_totales * 100 / ($total_hombres + $total_mujeres)" | bc)%"
fi
