// Variables
//include <defaults.scad>
//include <defaults_mini.scad>
//include <defaults_mini_schublade.scad>

e=0.001;

x = 2;
y = 3;

//box();
//grid();
//slice();
//stack();

function middle(times) = -length_default/2 +(length_default+(times-1)*pitch_default)/2 ;
left   = -length_default/2 ;
front  = -length_default/2 ;
right  =  length_default/2+(x-1)*pitch_default ;
back   =  length_default/2+(y-1)*pitch_default ;
bottom =  0;
top    =  height_default;

module body_form(
A,B,K,L,height
){
    polyhedron(
        points = [
            [-A,-B, 0],  // 0
            [ A,-B, 0],   // 1
            [ A, B, 0],  // 2
            [-A, B, 0], // 3
            [-K,-L, height],  // 0
            [ K,-L, height],   // 1
            [ K, L, height],  // 2
            [-K, L, height]], // 3
        faces = [
            [0,1,2,3],  // bottom
            [4,5,1,0],  // front
            [7,6,5,4],  // top
            [5,6,2,1],  // right
            [6,7,3,2],  // back
            [7,4,0,3]] // left
        );
}

module box_bottom(
  lift = lift_default,
  length = length_default,
  height = height_default ,
  triangle_height = triangle_height_default,
  bottom = true, // if the bottom should be added or not... (the inner one should not have it)
){

    // größere
    K = length/2 ;
    L = K;
    // kleinere
    A = (length-2*triangle_height)/2;
    B = A;
    remaining_height = height - lift - triangle_height;
    if (bottom) {
    translate([0,0,(lift+1)/2])
        cube([2*A,2*B,lift+1],center=true);
    }
    translate([0,0,lift-e])
    // creates an inverted cut pyramid
    body_form(A,B,K,L,triangle_height+e);

}

module solid_box(
  x = x,
  y = y,
  lift = lift_default,
  length = length_default,
  height = height_default ,
  triangle_height = triangle_height_default,
  pitch = pitch_default,
  bottom = true,
  cut_sides = true,
  fill_pyramid_tip = false,
){
    difference(){
    union(){
        remaining_height = height - lift - triangle_height;
        for (m = [0:y-1]){
            for (n = [0:x-1])
                translate([n*pitch,m*pitch,0])
                    box_bottom(length=length,bottom=bottom);
        }
        translate([-length/2,-length/2,lift + triangle_height-e])
            cube([(x-1)*pitch+length,(y-1)*pitch +length,remaining_height]);

        if (fill_pyramid_tip){
            // fill the gaps inside the pyramids *shrug*
            translate([-length/2,-length/2,triangle_height+0.1])
                cube([(x-1)*pitch+length,(y-1)*pitch +length,1]);
        }
    }
    if (cut_sides) {
        // cut left side of box
        translate([-length/2,-length/2-2,0])
            cut_object(length = (y-1)*pitch +length +4 );

        // cut right side of box
        translate([(x-1)*pitch+length/2,-length/2-2,0])
        mirror(v=[1,0,0])
            cut_object(length = (y-1)*pitch +length +4 );

        // cut front side of box
        //translate([(x-1)*pitch+length/2,-length/2-2,0])
        translate([-length/2-2,-length/2,0])
        rotate([0,0,-90])
        mirror(v=[1,0,0])
            cut_object(length = (x-1)*pitch +length +4 );

        // cut back side of box
        translate([-length/2-2,length/2+(y-1)*pitch,0])
        rotate([0,0,-90])
            cut_object(length = (x-1)*pitch +length +4 );
        }
    }

}

module box(){
    difference(){
        solid_box(fill_pyramid_tip=true);
        // inner solid box without the cubed lift on the bottom.. now the wall thickness looks quite okay
        // we have to lower the innter box about lift_default distance again
        translate([0,0,wall_thickness_default- lift_default])
            solid_box(length = length_default - 2* wall_thickness_default,bottom=false);
    }

    // add handle
    translate([
        middle(x),
        -length_default/2+wall_thickness_default,
        height_default-handle_top_distance
    ])
        handle();
}

module grid(
  x = x,
  y = y,
  lift = lift_default,
  length = length_default,
  height = height_default ,
  triangle_height = triangle_height_default,
  pitch = pitch_default
){
    difference(){
    // main body
        union(){
            difference(){
                translate([-length/2,-length/2,0])
                cube([(x-1)*pitch+length,(y-1)*pitch +length,lift+triangle_height]);

                translate([0,0,-e])
                    solid_box(length= length_default + 0.1, cut_sides = false );     // do we need some added clearence here?
            }
        }

    translate([-length/2-1,-length/2-1,lift + triangle_height - cut_default])
        cube([(x-1)*pitch+length+2,(y-1)*pitch +length + 2,2]);
    }
}


module cut_object(
    length = length_default,
    height = height_default,
    diff_bottom = diff_bottom_default,

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

module slice() {
    difference(){
        box();
        translate([-length_default/2-10,-length_default/2-10,-5])
        cube([
            1/2*(length_default+(x-1)*pitch_default + 20),
            length_default+(y-1)*pitch_default +20,
            height_default+10]);
    }
}

module handle(){
    r = 2;
    $fa = 1;
    $fs = 0.4;

    rotate([0,180,0])
    hull(){
        hull(){
            //left corner
            translate([-handle_width/2,0,0])
                cube([1,1,handle_top_height ]);

            // right corner
            translate([handle_width/2,0,0])
            translate([-1,0,0])
                cube([1,1,handle_top_height ]);

            // left round corner
            translate([-handle_width/2,handle_depth])
            translate([r,-r,0])
            cylinder(r=r,h=handle_top_height);

            // right round corner
            translate([handle_width/2,handle_depth])
            translate([-r,-r,0])
            cylinder(r=r,h=handle_top_height );
        }

        // hull anchor
        height = handle_depth / tan(handle_angle);

        translate([-handle_width/2,0,0])
            cube([handle_width,0.1,height]);
    }
}

module stack(){
    // module to preview a stacked box
    slice();
    translate([0,0,height_default-handle_top_distance ])
    slice();
}
