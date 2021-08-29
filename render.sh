#!/bin/bash

output_path="stl"

[ -d "$output_path" ] || mkdir -p $output_path


echo "Render boxes"

for x in {1..6}; do
    for y in {1..6}; do
        openscad -o $output_path/box-$x-$y.stl -D x=$x -D y=$y box.scad &
    done
done