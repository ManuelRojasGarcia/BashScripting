#! /usr/bin/awk -f
#Nombre y apellidos del alumno: Manuel Rojas Garcia
#Usuario de la UOC del alumno: mrojasgar
#Fecha: 31/12/2023
#Objetivo: Procesar datos académicos de estudiantes, específicamente las notas de los estudiantes por género y año. Adicionalmente ver el ratio de por genero por año para ver el ratio hombre/mujer. Todo detallado y que incluyan estadísticas y gráficos.
#Nombre y tipo de los campos de entrada:
#id - string
#semester - date
#gender - string
#year - date
#Operaciones y nº línea o líneas del código fuente donde se realizan:
#Lineas 32-73 Se define el valor a las notas y la estructura del infome (colores fondo, tamaño etc)
#Lineas 74-107 generación de informe HTML y tabla con las notas medias y valores de conteo.
#Lineas 109-170 calculo de nota media, generos y almacenamiento de ambos resultados
#lineas 182-210 generacion de graficos con gnuplot.
#Lineas 211 - 214 eliminacion de datos residuales (txts solamente, zip y csvs, se mantienen los png)
#Nombre y tipo de los nuevos campos generados:
# Año - Date
# Género - String
# Nota Media - Float
# Alumnos por Género - Float
#!/bin/awk -f

BEGIN {
#Separadores de entrada y salida

    FS=";";
    OFS=",";

#Definir las notas según letras se incluye SU como 3.5 (explicado en la memoria)

    notas["NP"] = 0;
    notas["SU"] = 3.5;
    notas["NO"] = 7;
    notas["EX"] = 9;
    notas["A"] = 5;
    notas["M"] = 10;

    print "<!DOCTYPE html>";
    print "<html><head>";
    print "<title>Informe de Notas Medias</title>";
    print "<style>";
    print "  body {";
    print "    margin-top: 50px;";
    print "    text-align: center;";
    print "  }";
    print "  table {";
    print "    border-collapse: collapse;";
    print "    width: 25%;";
    print "    margin: 20px auto;";
    print "  }";
    print "  th, td {";
    print "    border: 1px solid #dddddd;";
    print "    text-align: left;";
    print "    padding: 4px;";
    print "  }";
    print "  th {";
    print "    background-color: #f2f2f2;";
    print "    font-style: italic;";
    print "  }";
    print "  h1 {";
    print "    color: #3498db;";
    print "    font-weight: bold;";
    print "  }";
    print "  .green-bg {";
    print "    background-color: #d9f7d9;";  # Verde claro
    print "  }";
    print "</style>";
    print "</head>";
    print "<body>";
    print "<h1>Informe de Notas Medias por Año y Género</h1>";
    print "<table border='1'><tr><th>Año</th><th>Género</th><th class='green-bg'>Nota Media</th><th>Alumnos por género</th></tr>";
}

#Procesamiento de la primera entrada (archivo marks_PS.csv)

FNR == NR {
    if (FNR > 1) {
        student_id = $1;
        semester = $2;
        split(semester, s, "/");
        year = s[1];
        if (s[2] == "2") year++;

        nota = notas[$4];
#Contar todas las notas (A, EX, M, NO, SU)
        if ($4 == "A" || $4 == "EX" || $4 == "M" || $4 == "NO" || $4 == "SU") {
            marks[student_id, year] += nota;
            counts[student_id, year]++;
        }
        total_lines++;
    }
    next;
}

#Procesamiento de la segunda entrada (archivo profiles_PS.csv) los años se toman de los 4 primeros digitos

{
    if (FNR > 1) {
        student_id = $1;
        gender = $3;
        year = substr($4, 1, 4);
        genders[student_id] = gender;
        profile_years[student_id] = year;
    }
}

#Realización de cálculos finales y generación de HTML

END {
#Inicializar arrays de conteo

    for (key in genders) {
        gender = genders[key];
        year = profile_years[key];
        if (gender == "M") {
            male_count[year]++;
        } else if (gender == "F") {
            female_count[year]++;
        }
    }

#Calcular notas medias y almacenar resultados

    for (key in marks) {
        split(key, k, SUBSEP);
        student_id = k[1];
        year = k[2];
        gender = genders[student_id];
        avg_nota = marks[key] / counts[key];
        totals[year, gender] += avg_nota;
        total_counts[year, gender]++;
    }

#Imprimir la tabla HTML con notas medias y valores de conteo

    for (key in totals) {
        split(key, k, SUBSEP);
        year = k[1];
        gender = k[2];
        avg_nota = totals[key] / total_counts[key];

#Calcula el porcentaje del género actual sobre el total de ambos géneros

        total_both_genders = total_counts[year, "M"] + total_counts[year, "F"];
        percentage = (total_both_genders > 0) ? (total_counts[year, gender] / total_both_genders) * 100 : 0;

        results[year, gender] = sprintf("%.2f,%.2f", avg_nota, percentage);
        if (!(year in unique_years)) {
            unique_years[year];
            years_array[++num_years] = year;
        }
    }

#Imprimir la tabla HTML con notas medias y valores de conteo

    for (i = 1; i <= num_years; i++) {
        year = years_array[i];
        if ((year, "F") in results) {
            split(results[year, "F"], parts, ",");
            print "<tr><td>" year "</td><td>Femenino</td><td class='green-bg'>" parts[1] "</td><td>" parts[2] "%</td></tr>";
        }
        if ((year, "M") in results) {
            split(results[year, "M"], parts, ",");
            print "<tr><td>" year "</td><td>Masculino</td><td class='green-bg'>" parts[1] "</td><td>" parts[2] "%</td></tr>";
        }
    }

    print "</table>";

#Guarda los datos para el gráfico en un archivo temporal para poder luego usarlo para generar el grafico

    print "# Año,Género,Nota_Media,Conteo, Porcentaje" > "datos_grafico.txt"
    for (key in results) {
        split(key, k, SUBSEP);
        year = k[1];
        gender = k[2];
        avg_nota = results[key];
        print year, gender, avg_nota >> "datos_grafico.txt";
    }

#Crea el gráfico de notas con Gnuplot (usando el txt)

    system("gnuplot -e 'set terminal png; set output \"grafico.png\"; set xlabel \"Año\"; set ylabel \"Nota Media\"; set title \"Notas Medias de aprobados por Año\"; set key outside; set grid; set size 1,1; set datafile separator \",\"; plot \"datos_grafico.txt\" using 1:3:xtic(5) with points pointsize 1 pointtype 7 linecolor rgb \"blue\" title \"Nota Media\"'");

#Incluye la imagen en el informe HTML (se valora incrustar el fichero el html y luego eliminarlo, pero se entiende que los png pueden ser de utilidad para el usuario)

    print "<img src='grafico.png' alt='Gráfico de Notas Medias'>";

#Guardar los datos para el gráfico de conteo de alumnos por género en un archivo temporal

    print "# Año,Género,Conteo" > "datos_grafico_alumnos.txt"
    for (key in male_count) {
        print key, "M", male_count[key] >> "datos_grafico_alumnos.txt";
    }
    for (key in female_count) {
        print key, "F", female_count[key] >> "datos_grafico_alumnos.txt";
    }

#Crea el gráfico de alumnos con Gnuplot, se usa el segundo txt para generar el segundo grafico.

system("gnuplot -e 'set terminal png; set output \"grafico_alumnos.png\"; set xlabel \"Año\"; set ylabel \"Cantidad de Alumnos\"; set title \"Rango de Alumnos por Nacimiento y Sexo\"; set key right; set key font \"8,Helvetica\"; set grid; set size 1,1; set datafile separator \",\"; plot \"datos_grafico_alumnos.txt\" using 1:3:xtic(8) with linespoints pointsize 1 pointtype 7 linecolor rgb \"blue\" title \"Cantidad de Alumnos\"'");

#Incluye la imagen en el informe HTML

    print "<img src='grafico_alumnos.png' alt='Gráfico de Cantidad de Alumnos por Género'>";

    print "</body></html>";

#Elimina archivos txt de la carpeta, zip y csvs del ejercicio a para no dejar ficheros residuales.

    system("rm datos_grafico.txt datos_grafico_alumnos.txt dataset.zip marks_PS.csv profiles_PS.csv");
}
