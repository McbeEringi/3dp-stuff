$fs=.5;

module rsq(wh,r){
	minkowski(){square([wh[0]-r*2,wh[1]-r*2],center=true);circle(r);}
}

module tume(){
	translate([59.5/2,-4.5/2,0])difference(){
		cube([2.1,4.5,4]);
		translate([1.1,(4.5-5)/2,4])rotate([0,-90-45,0])cube([2,5,4]);
	}
}

linear_extrude(2.5)difference(){
	rsq([70,120],9);
	rsq([70-2,120-2],9-1);
}
for(i=[-1:1])translate([0,i*41.5,0]){
	tume();scale([-1,1,1])tume();
}
translate([0,0,-2.5]){
	linear_extrude(2.5)difference(){
		rsq([70,120],9);
		rsq([70-12,120-12],9-6);
	}
	translate([0,0,-1]){
		linear_extrude(1)difference(){
			rsq([70,120],9);
			//square([43.5,92],center=true);
			for(i=[-1,1])translate([20, 10*i,0])circle(d=3);
		}
	}
}


translate([50,0,0])difference(){
	union(){
		linear_extrude(.5)minkowski(){square([1e-9,66]);circle(d=6);}
		cylinder(d=6,h=3);
		translate([-.5,23,0])cylinder(d=6,h=3.5);
		translate([-.5,43,0])cylinder(d=6,h=3.5);
		translate([0,66,0])cylinder(d=6,h=3);
	}
	cylinder(d=3,h=5);
	translate([-.5,23,0])cylinder(d=3,h=5);
	translate([-.5,43,0])cylinder(d=3,h=5);
	translate([0,66,0])cylinder(d=3,h=5);
}

