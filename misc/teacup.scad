$fs=1;

scale(.5){
intersection(){
	difference(){
scale([1,1,.4])sphere(30);
		scale(.92)scale([1,1,.4])sphere(30);
	}
translate([-30,-30,-30])cube([60,60,22]);
}
translate([0,0,-12])cylinder(d=17,h=1);

translate([0,0,-12])cylinder(d=8,h=2);


	scale(.6)translate([0,0,2])difference(){
		union(){
	translate([20,0,-8])rotate([90,-10,0])scale([1.6,1,1.6])rotate_extrude()translate([6,0])circle(r=1.2);
			scale([1,1,.9])sphere(22);
		}
		scale(.92)scale([1,1,.9])sphere(22);
		translate([-30,-30,0])cube([60,60,30]);
	}
}