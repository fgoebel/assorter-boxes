// This should be the grid ;-D

//difference(){

//    rotate([0,45,0])
//    cube(10,center=true);

//    translate([0,0,-5])
//        cube([18,10+0.01,10], center= true);
//}

length=55;
x = 2;
y = 1;

heigth=4;
width=2*heigth;
cut=0.5;
lift=0.5;

module main(){
    difference(){
        for (m = [0:y-1]){
            for (n = [0:x-1])
                translate([n*length,m*length,0])
                    field();
        }

        // clean front
        translate([-1,-(heigth+2),-1])
            cube([(length*x)+2,heigth+2,heigth+2]);

        // clean Back
        translate([-1,length*y,-1])
            cube([(length*x)+2,heigth+2,heigth+2]);

        // clean left
        translate([-(heigth+2),-1,-1])
            cube([heigth+2,(length*y)+2,heigth+2]);

        // clean right
        translate([length*x,-1,-1])
            cube([heigth+2,(length*y)+2,heigth+2]);

        // cut top
        translate([0,0,heigth-cut])
            cube([length*x+0.001,length*y+0.001,2*cut]);
    }
}

module triangle(){
    lifted_triangle();
}

module simple_triangle(){
    rotate([-90,0,0])
    linear_extrude(height=length)
        polygon([[-width/2,0],[0,-heigth],[width/2,0]]);
}


module lifted_triangle(){
    translate([0,0,lift])
    rotate([-90,0,0])
    linear_extrude(height=length)
        polygon([[-width/2,0],[0,-heigth],[width/2,0]]);

    translate([-width/2,0,0])
        cube([width,length,lift]);
}

module field(){
    translate([0,length,0])
    rotate([0,0,-90])
        triangle();

    rotate([0,0,-90])
        triangle();

    translate([length,0,0])
        triangle();

    triangle();
}

main();