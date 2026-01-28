$fa=1;$fs=.1;
dist=9;
hole=true;
module rsq(s,r){minkowski(){square([s.x-r*2,s.y-r*2],center=true);circle(r);}}

difference(){
	linear_extrude(21,center=true)difference(){
		hull(){
			circle(d=5);
			translate([dist,0])circle(d=3);
			//translate([dist,0])square(3/2);
		}
		if(hole){
			circle(d=.8);
			translate([dist,0])circle(d=.8);
		}
	}
	if(!hole){
		translate([0,0,21/2])sphere(d=1);
		translate([0,0,-21/2])sphere(d=1);
		translate([dist,0,21/2])sphere(d=1);
		translate([dist,0,-21/2])sphere(d=1);
	}
	rotate([90,0,0])linear_extrude(10,center=true){
			rsq([4*2,10.5],.5);
			translate([dist,0])rsq([3*2,18],.5);
	}
}