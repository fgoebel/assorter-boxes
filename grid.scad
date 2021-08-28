// This should be the grid ;-D

//difference(){

//    rotate([0,45,0])
//    cube(10,center=true);

//    translate([0,0,-5])
//        cube([18,10+0.01,10], center= true);
//}

length_default=55;

triangle_height_default=4;
triangle_width_default=2*triangle_height_default;
cut_default=0.5;
lift=0.5;
e=0.001;

wall_thickness_default = 1.2;


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
    length=length_default,
){
    difference(){
        translate([e,e,0])
            cube([x*length-(2*e),y*length-(2*e),75]);
            grid(
                x=x,
                y=y,
                cut = cut,
                cut_top=false
                );
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

box(x=2,y=3);
// grid();
// field();