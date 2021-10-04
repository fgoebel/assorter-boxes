
length_default = 55;
pitch_default = 55 ;

height_default = 75;

triangle_height_default = 4 ;
triangle_width_default  = 2 * triangle_height_default;
cut_default=0.5;
lift_default=0.5;
e=0.001;

wall_thickness_default = 1.2;

x = 2;
y = 3;
// bottom

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
){

    // größere
    K = length/2 ;
    L = K;
    // kleinere
    A = (length-2*triangle_height)/2;
    B = A;
    remaining_height = height - lift - triangle_height;

    translate([0,0,lift/2])
    cube([2*A,2*B,lift],center=true);

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
  pitch = pitch_default
){
    remaining_height = height - lift - triangle_height;
    for (m = [0:y-1]){
        for (n = [0:x-1])
            translate([n*pitch,m*pitch,0])
                box_bottom(length=length);
    }
    translate([-length/2,-length/2,lift + triangle_height-e])
        cube([(x-1)*pitch+length,(y-1)*pitch +length,remaining_height]);
}


module box(){
    difference(){
        solid_box();

        translate([0,0,wall_thickness_default])
            solid_box(length = length_default - 2* wall_thickness_default);
    }
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
    translate([-length/2,-length/2,0])
    cube([(x-1)*pitch+length,(y-1)*pitch +length,lift+triangle_height]);

    translate([0,0,-e])
        solid_box(length= length_default + 0.1);     // do we need some added clearence here?
    }
}


box();
//grid();