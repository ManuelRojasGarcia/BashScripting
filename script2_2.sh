#!/bin/bash
# Usamos tail para mostrar omitir la parte del fichero que no nos interesa y head para mostrar las 10 que sí nos interesan. Lo enviamos a out2_a
tail -n +132 "$1" | head -n 10 > out2_a.txt
# Para 2_b incluimos cut para eliminar columnas pero delimitamos con d semicolom y f para field (las columnas que queremos mostrar)
tail -n +132 "$1" | head -n 10 | cut  -d ";" -f 1,4,6 > out2_b.txt
# Para 2_c incluimos tr para sustituir o eliminar caracteres. Sustuimos semicolom por arrobas.
tail -n +132 "$1" | head -n 10 | tr ";" "@" > out2_c.txt
# Para 2_d cambiamos los parametros de tail para evitar la cabecera, seleccionamos cut la columna 4. Sort para ordenar de manera inversa (reverse) y para omitir repetido uniq con c para count. 
tail -n +2 "$1" | cut -d ";" -f 4 | sort -r | uniq -c  > out2_d.txt
