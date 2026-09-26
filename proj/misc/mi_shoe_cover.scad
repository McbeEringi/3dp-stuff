$fa=5;$fs=.2;
thickness=1.7;

translate([0,0,0]){
	linear_extrude(thickness)translate([-18.5/2,-2])square([18.5,16]);
}
translate([0,0,thickness]){
	difference(){
		linear_extrude(1){
			translate([-12.5/2,0])square([12.5,14]);
			translate([-21/2,-2])square([21,2]);

		}
		translate([0,14/2,.5])linear_extrude(1)scale(.15)offset(1)import("lib/icon.svg",center=true);
	}
	scale([1,1,-1])translate([-14.5/2,14-1,.2])linear_extrude(.5)square([14.5,3+1]);
	intersection(){
		
		translate([0,0,1])scale([1,-1,-1]){
			linear_extrude(6)translate([-21/2,1])square([21,1.2]);
		}
		rotate([90,0,0])#linear_extrude(10)minkowski(){
			square([21-1*2,8],center=true);
			circle(r=1);
	}
	}
}