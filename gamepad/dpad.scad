$fa=2;

difference(){
union(){
	translate([0,0,2])union(){
		cube([16,5,4],center=true);
		cube([5,16,4],center=true);
	}
	cylinder(d=20);
}
translate([0,0,1])cube([2,2,2],center=true);
translate([0,0,53])sphere(r=50);
}