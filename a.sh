#URL "https://drive.google.com/uc?export=download&id=11fTCjPK3IgBnTM35Inkh_1tNyStHMTol"


# CODIGO INICIAL

#!/bin/bash


# Comprobar si se proporcionó el número correctos de argumentos (-ne).
# https://stackoverflow.com/questions/18568706/check-number-of-arguments-passed-to-a-bash-script
 

#if [ "$#" -ne 1 ]; then
#    echo "Error - Falta introducir URL"
#    exit 1
#fi

# Descomprimimos el fichero desde nuestro argumento 1. Hacemos una pequeña investigación de cual es
# el mejor código de descompresión si curl o wget y se determina que es más completo wget
# https://reqbin.com/req/curl/c-ojpjkl15/wget-vs-curl

#wget -O dataset.zip "$1" && unzip dataset.zip



# Calcular la suma de verificación MD5 de ambos archivos CSV
# https://www.cyberciti.biz/faq/linux-md5-hash-string-based-on-any-input-string/

#MD5_1=$(md5sum "marks_PS.csv" | awk '{print $1}')
#MD5_2=$(md5sum "profiles_PS.csv" | awk '{print $1}')

#nombre1=$(basename "marks_PS.csv" .csv)
#nombre2=$(basename "profiles_PS.csv" .csv)

#Información relativa a Charset, para imprimir solo lo indicado en el ejercicio se usa sed
#https://stackoverflow.com/questions/805418/how-can-i-find-encoding-of-a-file-via-a-script-on-linux

#codificacion1=$(file -bi "marks_PS.csv"| sed -n 's/.*charset=\(.*\)/\1/p')
#codificacion2=$(file -bi "profiles_PS.csv"| sed -n 's/.*charset=\(.*\)/\1/p')

#Aplicamos ejemplos de PECs anteriores para hacer el conteo de filas y columnas eliminando el título de la columna

#filas1=$(tail -n +2 "marks_PS.csv" | wc -l)
#filas2=$(tail -n +2 "profiles_PS.csv" | wc -l)
#columnas1=$(head -1 "marks_PS.csv" | sed 's/[^,]//g' | wc -c)
#columnas2=$(head -1 "profiles_PS.csv"| sed 's/[^,]//g' | wc -c)


#echo " "
#echo "MD5: $MD5_1"
#echo "Filename_1: $nombre1"
#echo "Charset: $codificacion1"
#echo "Total Records: $filas1"
#echo "Total Columns: $columnas1"
#awk -F ';' 'NR==1 {for(i=1;i<=NF;i++) print "Type Column "i" - "$i}' "marks_PS.csv"
#echo " "
#echo "MD5: $MD5_2"
#echo "Filename_2: $nombre2"
#echo "Charset: $codificacion2"
#echo "Total Records: $filas2"
#echo "Total Columns: $columnas2"
#awk -F ';' 'NR==1 {for(i=1;i<=NF;i++) print "Type Column "i" - "$i}' "profiles_PS.csv"
#echo " "


#CÓDIGO OPTIMIZADO

#!/bin/bash
# Nombre y apellidos del alumno: MANUEL ROJAS GARCIA
# Usuario de la UOC del alumno: mrorjasgar
# Fecha: 21/12/2023


if [ "$#" -ne 1 ]; then
    echo "Error - Falta introducir URL"
    exit 1
fi

# Descargar y descomprimir el archivo ZIP
wget -O dataset.zip "$1" && unzip dataset.zip

# Contar el número total de archivos CSV
totaldecsv=$(ls -1 *.csv | wc -l)
csvactual=0

# Procesar cada archivo CSV
for csv in *.csv; do
    csvactual=$((csvactual + 1))

    md5=$(md5sum "$csv" | awk '{print $1}')
    filename=$(basename "$csv" .csv)
    charset=$(file -bi "$csv" | sed -n 's/.charset=\(.\)/\1/p' | sed 's/.*;//')

    records=$(tail -n +2 "$csv" | wc -l)
    columns=$(head -2 "$csv" | tail -1 | tr ';' '\n' | wc -l)
    
    # Modificación para cambiar el orden de impresión
    echo "MD5: $md5"
    echo "Filename_$csvactual: $filename"
    echo "Charset: $charset"
    echo "Total Records: $records"
    echo "Total Columns: $columns"

    # Obtener los nombres de las columnas desde la primera fila
    IFS=';' read -ra column_names <<< "$(head -1 "$csv")"
    
    # Obtener los valores de las columnas desde la segunda fila
    IFS=';' read -ra column_values <<< "$(head -2 "$csv" | tail -1)"

    # Procesar cada columna
    {
        for ((i=0; i<columns; i++)); do
            col_name="${column_names[$i]}"
            col_value="${column_values[$i]}"
            
            if [[ $col_value =~ ^[0-9]{4}(/[0-9]+)?$ ]]; then
                echo "Type Column$((i+1)): $col_name, date"
            elif [[ $col_value =~ ^[0-9]+$ && ${#col_value} -eq 4 ]]; then
                echo "Type Column$((i+1)): $col_name, integer"
            elif [[ $col_value =~ ^[0-9]*\.[0-9]+$ ]]; then
                echo "Type Column$((i+1)): $col_name, float"
            elif [[ $col_value == "Yes" || $col_value == "No" || $col_value == "Accepted" ]] && [[ ${#col_value} -le 7 ]]; then
                echo "Type Column$((i+1)): $col_name, boolean"
            else
                echo "Type Column$((i+1)): $col_name, string"
            fi
        done
    } | column -t -s ';'

    if [ "$csvactual" -lt "$totaldecsv" ]; then
        echo -e "\n********************\n"
    fi
done
