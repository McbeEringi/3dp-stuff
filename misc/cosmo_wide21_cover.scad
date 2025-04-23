$fs=.5;

module rsq(wh,r){
	minkowski(){square([wh[0]-r*2,wh[1]-r*2],center=true);circle(r);}
}

module tume(){
	translate([59.5/2,-2,0])difference(){
		cube([2.2,4,4]);
		translate([1.1,-.5,4])rotate([0,-90-45,0])cube([2,5,4]);
	}
}



linear_extrude(2.5)difference(){
	rsq([70,120],9);
	rsq([70-2,120-2],9-1);
}
for(i=[-1:1])translate([0,i*41.5,0]){
	tume();scale([-1,1,1])tume();
}
translate([0,0,-7.5]){
	linear_extrude(7.5)difference(){
		rsq([70,120],9);
		rsq([70-12,120-12],9-6);
	}
	translate([0,0,-1]){
		linear_extrude(1)difference(){
			rsq([70,120],9);
			//square([43.5,92],center=true);
		}
	}
}


