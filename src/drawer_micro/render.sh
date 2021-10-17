#!/bin/bash

folder_name=$(basename $(pwd))
output_path="../../stl/$folder_name"
x_max=4
y_max=4

[ -d "$output_path" ] || mkdir -p $output_path

echo "Render boxes"

for ((x=1;x<=x_max;x++)); do
    for ((y=1;y<=y_max;y++)); do
        openscad -o $output_path/box-$x-$y.stl -D x=$x -D y=$y box.scad 1>/dev/null 2>&1 &
    done
done

echo "render grids"

for ((x=1;x<=x_max;x++)); do
    for ((y=1;y<=y_max;y++)); do
        openscad -o $output_path/grid-$x-$y.stl -D x=$x -D y=$y grid.scad 1>/dev/null 2>&1 &
    done
done
