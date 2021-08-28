// This should be the grid ;-D

include <defaults.scad>


module grid(
    x = 1,
    y = 1,
    cut_top = true,
    cut = cut_default,
    length = length_default,
    triangle_height = triangle_height_default,
){
    difference(){
        for (m = [0:y-1]){
            for (n = [0:x-1])
                translate([n*length,m*length,0])
                    field();
        }

        // clean front
        translate([-1,-(triangle_height+2),-1])
            cube([(length*x)+2,triangle_height+2,triangle_height+2]);

        // clean Back
        translate([-1,length*y,-1])
            cube([(length*x)+2,triangle_height+2,triangle_height+2]);

        // clean left
        translate([-(triangle_height+2),-1,-1])
            cube([triangle_height+2,(length*y)+2,triangle_height+2]);

        // clean right
        translate([length*x,-1,-1])
            cube([triangle_height+2,(length*y)+2,triangle_height+2]);

        if (cut_top){
        // cut top
        translate([-e,-e,triangle_height-cut])
            cube([length*x+(2*e),length*y+(2*e),2*cut]);
        }
    }
}

module triangle(
    length=length_default,
    triangle_width = triangle_width_default,
    triangle_height = triangle_height_default,
){
    lifted_triangle(
        length = length,
        triangle_width = triangle_width,
        triangle_height = triangle_height
    );
}

module simple_triangle(
    length=length_default,
    triangle_width = triangle_width_default,
    triangle_height = triangle_height_default,
){
    rotate([-90,0,0])
    linear_extrude(height=length)
        polygon([[-triangle_width/2,0],[0,-triangle_height],[triangle_width/2,0]]);
}


module lifted_triangle(
    length=length_default,
    triangle_width = triangle_width_default,
    triangle_height = triangle_height_default,
    lift = lift_default,
){
    translate([0,0,lift])
    rotate([-90,0,0])
    linear_extrude(height=length)
        polygon([[-triangle_width/2,0],[0,-triangle_height],[triangle_width/2,0]]);

    translate([-triangle_width/2,0,0])
        cube([triangle_width,length,lift]);
}

module field(
    length=length_default,
    triangle_width = triangle_width_default,
    triangle_height = triangle_height_default,
){
    translate([0,0,-e]){
        translate([0,length,0])
        rotate([0,0,-90])
            triangle(
                length = length,
                triangle_width = triangle_width,
                triangle_height = triangle_height
            );

        rotate([0,0,-90])
            triangle(
                length = length,
                triangle_width = triangle_width,
                triangle_height = triangle_height
            );

        translate([length,0,0])
            triangle(
                length = length,
                triangle_width = triangle_width,
                triangle_height = triangle_height
            );

        triangle(
            length = length,
            triangle_width = triangle_width,
            triangle_height = triangle_height
        );
    }
}

module box_solid(
    x = 1,
    y = 1,
    cut = cut_default,
    length = length_default,
    height = height_default,
){
    
    difference(){
        translate([e,e,0])
            cube([x*length-(2*e),y*length-(2*e),height]);
    
        grid(
                x=x,
                y=y,
                cut = cut,
                cut_top=false
                );
        // cut left side of box
        cut_object(
            length = length*y);

        // cut right side of box
        translate([length*x,0,0])
        mirror(v=[1,0,0])
             cut_object(length = length*y);
        
        // cut back of box
        translate([0,length*y,0])
        rotate([0,0,-90])
             cut_object(length = length*x);

        // cut front of box
        rotate([0,0,-90])
        mirror(v=[1,0,0])
             cut_object(length = length*x);

    }
}

module box(
    x = 1,
    y = 1,
    cut = cut_default,
    length=length_default,
    wall_thickness = wall_thickness_default,
){
    difference(){
            box_solid(
                x = x,
                y = y,
                cut = cut
                );


        translate([wall_thickness/2,wall_thickness/2,wall_thickness/2])
            resize([x*length-wall_thickness,y*length-wall_thickness,0])
            box_solid(
                x = x,
                y = y,
                cut = cut
                );

    }
}

module cut_object(
    length=length_default,
    height = height_default,
    diff_bottom = 0.5

){
    rotate([-90,0,0])
    linear_extrude(height=length)
     
        polygon(
            [   [-e,0],
                [-e,-height],
                [0,-height],
                [diff_bottom,0]
            ]
            );
}
