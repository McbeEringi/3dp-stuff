$fa=.5;$fs=.5;
module a(){
	cube([7,4,2]);
	translate([2,2,2])cylinder(d=2,h=2.5);
}
a();
translate([0,5,0])a();