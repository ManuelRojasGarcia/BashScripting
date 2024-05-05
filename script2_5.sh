#!/bin/bash

# Student's name and last name: Manuel Rojas García

# Student's UOC username: mrojasgar

# Date: 29/10/2023

# Script objectives:Loop through the 'numbers' array using a 'for' loop 
# and display, for each item, its absolute value and its percentage relative 
# to the 'sum_numbers' variable; the percentage value shown will be truncated 
# without decimals. The order of appearance of the values should be the same 
# as in the creation of the array in the source file.

# Expected output:
# 0 0%
# 1 6%
# 2 13%
# 3 20%
# 4 26%
# 5 33%


# Initialization
numbers=(0 1 2 3 4 5)
sum_numbers=15

# Your code here:
# Creamos un bucle for y para obtener el porcentaje multiplicamos por 100 y dividimos por sum (15)

for number in "${numbers[@]}"; do
    absolute_value=$((number))

    percentage=$(( (number * 100) / sum_numbers ))

    echo "$absolute_value $percentage%"
done
