$fs=.1;
d=3.5;//4;
g=1;


/*
difference(){
	rotate([90,0,0])union(){
			scale([1,1,-1])cylinder(d=d,h=1.8);
		hull(){
			translate([0,0,-1.1])scale([(d+g)/d,1,1])cylinder(d=d,h=.001);
			translate([0,0,-1.8])cylinder(d=d,h=.001);
		}
		scale([1,1,2/3])intersection(){
		minkowski(){
			cube([18,.001,.001],center=true);
			sphere(d=6);
		}
		translate([0,0,16])cube(32,center=true);
		}
	}
	//translate([0,0,-16])cube(32,center=true);
	translate([-g/2,.001,-2.5])cube([g,5,5]);
}
*/
		minkowski(){
			cube([18,.001,.001],center=true);
			cylinder(d=6,h=2);
		}
		cylinder(d=d,h=3);