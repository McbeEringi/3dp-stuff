$fa=6;$fs=.5;

linear_extrude(5){difference(){
	union(){
hull(){
translate([5,32.5])circle(2.5);
translate([0,32.5])circle(2.5);
}hull(){
	
translate([0,30])circle(5);
translate([0,0])circle(5);

}hull(){
	translate([0,0])circle(5);
translate([12,0])circle(5);
}
hull(){
		translate([0,0])circle(5);
translate([12,0])circle(5);
		translate([6,-12])circle(5);
}
difference(){
hull(){
			translate([6,-12])circle(5);
			translate([6,-30])circle(5);

}
translate([0,-25])square([6,50]);
translate([4,-30])square([2,10]);

}
}

square([12,30]);
translate([10,16])square([50,50]);
}}