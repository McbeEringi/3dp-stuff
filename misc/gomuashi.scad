$fs=.1;
d=3.5;//4;



difference(){
	rotate([90,0,0])union(){
		hull(){
			cylinder(d=d,h=.001);
			translate([0,0,-1.8])scale([(d+.5)/d,1,1])cylinder(d=d,h=.001);
		}
		scale([1,1,2/3])intersection(){
		minkowski(){
			cube([18,.001,.001],center=true);
			sphere(d=6);
		}
		translate([0,0,16])cube(32,center=true);
		}
	}
	translate([0,0,-16])cube(32,center=true);
	translate([-.25,.001,-.001])cube([.5,5,5]);
}
