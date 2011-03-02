#!/bin/bash

gnuplot -e "set title 'Number Genoms';
			set xlabel 'Round';
			set ylabel 'Umgebung/average/averageAge';
			set y2label 'Populatoin';
			set ytics nomirror;
			set y2tics 0,1000;

			plot 'data.txt' using 1:2 axis x1y1 title 'Umgebung' with line,\
				 'data.txt' using 1:3 axis x1y2 title 'Population' with line,\
				 'data.txt' using 1:4 title 'average' with line,\
				 'data.txt' using 1:5 title 'averageAge' with line;
			set output 'data.svg';
			set terminal svg;
			replot;
			"

display data.svg

