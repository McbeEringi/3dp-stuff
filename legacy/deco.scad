$fa=1;$fs=1;

module rsq(w=50,h=50,r=5){
	translate([r,r])minkowski(){
		square([w-r-r,h-r-r]);
		circle(r);
	}
}

module nejiana(d=6.6){
	translate([30,55]){
		circle(d=d);
		translate([105.5,20.5])circle(d=d);
		translate([39,-37])circle(d=d);
	}
}
module conn(){
		translate([7,56])square([9,7]);
}

module main(c=0){
difference(){
	linear_extrude(3.5)difference(){
		translate([-3,-8])rsq(165,105,5);
		nejiana(3.5);
		if(c)conn();
	}
	translate([0,0,1])linear_extrude(3)nejiana(d=6);
}
}


scale([-1,1,1])main();
