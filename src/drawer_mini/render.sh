#!/bin/bash

output_path="stl-schublade"
x_max=4
y_max=4

[ -d "$output_path" ] || mkdir -p $output_path

echo "Render boxes"

for ((x=1;x<=x_max;x++)); do
    for ((y=1;y<=y_max;y++)); do
        openscad -o $output_path/box-$x-$y.stl -D x=$x -D y=$y schublade_box_mini.scad 1>/dev/null 2>&1 &
    done
done

echo "render spaced grid"

openscad -o $output_path/grid-2-4_spacer.stl schublade_grid_mini-2x4-spacer.scad 1>/dev/null 2>&1 &

echo "render grids"

for ((x=1;x<=x_max;x++)); do
    for ((y=1;y<=y_max;y++)); do
        openscad -o $output_path/grid-$x-$y.stl -D x=$x -D y=$y schublade_grid_mini.scad 1>/dev/null 2>&1 &
    done
done
