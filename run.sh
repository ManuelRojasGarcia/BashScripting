#!/bin/bash
#Fecha: 03/01/2024


#!/bin/bash

chmod 755 a.sh b.sh c.sh d.awk

# Guardar el tiempo de inicio
start_time=$(date +%s)

# A - Ejecutar el script A.sh con los parámetros proporcionados
echo -e "\nEjecutando ejercicio A..."
./a.sh "https://drive.google.com/uc?export=download&id=11fTCjPK3IgBnTM35Inkh_1tNyStHMTol"

# B - Ejecutar el script B.sh con los casos de prueba proporcionados
echo -e "\nEjecutando ejercicio B..."
echo -e "./marks_PS.csv"
./b.sh ./marks_PS.csv
echo -e "./nonExistingMarksFile.csv ./profiles_PS.csv"
./b.sh ./nonExistingMarksFile.csv ./profiles_PS.csv
echo -e "./ marks_PS.csv ./nonExistingMarksFile.csv"
./b.sh ./marks_PS.csv ./nonExistingProfilesFile.csv
echo -e "./ marks_PS.csv ./profiles_PS.csv nonExistingSubjectCode"
./b.sh ./marks_PS.csv ./profiles_PS.csv nonExistingSubjectCode
echo -e "./ marks_PS.csv ./profiles_PS.csv A48"
./b.sh ./marks_PS.csv ./profiles_PS.csv A48
echo -e "./ marks_PS.csv ./profiles_PS.csv  A12"
./b.sh ./marks_PS.csv ./profiles_PS.csv A12
echo -e "./ marks_PS.csv ./profiles_PS.csv"
./b.sh ./marks_PS.csv ./profiles_PS.csv

# C - Ejecutar el script C.sh con los casos de prueba proporcionados
echo -e "\nEjecutando ejercicio C..."

echo -e "\marks_PS.csv"
./c.sh ./marks_PS.csv
echo -e "./c.sh ./nonExistingMarksFile.csv ./profiles_PS.csv 18 29"
./c.sh ./nonExistingMarksFile.csv ./profiles_PS.csv 18 29
echo -e "./c.sh ./marks_PS.csv ./nonExistinProfilesFiles.csv 18 29"
./c.sh ./marks_PS.csv ./nonExistingProfilesFile.csv 18 29
echo -e "./c.sh ./marks_PS ./profiles_PS.csv -1 10"
./c.sh ./marks_PS.csv ./profiles_PS.csv -1 10
echo -e "./c.sh ./marks_PS ./profiles_PS.csv -1 string"
./c.sh ./marks_PS.csv ./profiles_PS.csv 18 string
echo -e "./c.sh ./marks_PS ./profiles_PS.csv 19 18"
./c.sh ./marks_PS.csv ./profiles_PS.csv 19 18
echo -e "./c.sh ./marks_PS ./profiles_PS.csv 10 12"
./c.sh ./marks_PS.csv ./profiles_PS.csv 10 12
echo -e "./c.sh ./marks_PS ./profiles_PS.csv 18 18"
./c.sh ./marks_PS.csv ./profiles_PS.csv 18 18
echo -e "./c.sh ./marks_PS ./profiles_PS.csv 25 35"
./c.sh ./marks_PS.csv ./profiles_PS.csv 25 35
echo -e "./c.sh ./marks_PS ./profiles_PS.csv 36 45"
./c.sh ./marks_PS.csv ./profiles_PS.csv 36 45
echo -e "./c.sh ./marks_PS ./profiles_PS.csv"
./c.sh ./marks_PS.csv ./profiles_PS.csv




# D - Ejecutar el script D.sh con el comando proporcionado
echo -e "\nEjecutando ejercicio D..."
gawk -f d.awk ./marks_PS.csv ./profiles_PS.csv > informe.html

# Calcular el tiempo total de ejecución
end_time=$(date +%s)
total_time=$((end_time - start_time))
echo -e "\nEl tiempo total de ejecución del script ha sido $total_time segundos"



