$fs=.2;
linear_extrude(5){
difference(){
union(){
hull(){
circle(5);
	translate([13,0])circle(5);
}
hull(){
	translate([13,0])circle(5);
		translate([13,31])circle(5);
	translate([4,47.5])circle(5);

	}
}
square([13,31]);
translate([-6,3])square([10,300]);
}
intersection(){
	union(){
translate([4,47.5])square([5,15]);
translate([9,57.5])square([2,5]);
translate([11,52.5])square([3,10]);
		}
		union(){
			translate([4,47.5])square([5,10]);

		translate([9,57.5])circle(5);
		}

	}
}