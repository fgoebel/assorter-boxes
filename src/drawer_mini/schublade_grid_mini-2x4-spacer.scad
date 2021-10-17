// grids ;-D

include <defaults.scad>
include <../assorter.scad>

x = 2;
y = 4;

gap = 2.4 ; // gap between the grid in x axis and the inner Wall of the Drawer box

grid(x=x,y=y);

// Schubladen helper bumper
// this should help that the grid stays in the middle of the Schublade
bumper_x_width = 40 ;
translate(
    [
        -gap/2 - length_default/2 + e,
        -bumper_x_width/2 + middle(y),
        ,0
    ])
cube([gap/2,bumper_x_width,grid_height/2]);

translate(
    [
        (x-1)*pitch_default+length_default/2 - e,
        -bumper_x_width/2 + middle(y),
        ,0
    ])
cube([gap/2,bumper_x_width,1]);
