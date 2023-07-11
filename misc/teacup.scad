$fs=.5;
$fa=6;

scale(1.1){

translate([0,0,13.5]){
	intersection(){
		difference(){
			scale([1,1,.45])sphere(30);
			scale([1,1,.4])sphere(30);
		}
		translate([-30,-30,-30])cube([60,60,21]);
	}
	translate([0,0,-13.5])difference(){
		cylinder(d=24,h=2.5);
		translate([0,0,1])cylinder(d=15,h=2);
	}
}

translate([0,40,12])intersection(){
	union(){
		scale([1,1,.9])difference(){
			union(){
				translate([12.5,0,-5.5])rotate([90,-10,0])scale([1.5,1,1.5])rotate_extrude()translate([4,0])circle(r=.7);
				sphere(14);
			}
			scale(.92)sphere(14);
		}
		translate([0,0,-12])cylinder(d=14,h=1);
	}
	translate([-20,-20,-12])cube([40,40,12]);
}

}