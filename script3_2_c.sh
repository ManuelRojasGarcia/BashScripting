#!/bin/bash

# Información adicional - https://stackoverflow.com/questions/41446222/matching-decimal-number-in-grep

grep -E 'US.*[1-9][0-9]*(\.[0-9]+)?M.*Female|Female.*[1-9][0-9]*(\.[0-9]+)?M.*US' "$1" 
