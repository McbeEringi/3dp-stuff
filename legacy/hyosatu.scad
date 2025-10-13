difference(){
	union(){
		linear_extrude(10)text("NAMENAME",35,"Tsukushi A Round Gothic Bold",halign="center");
		translate([0,0,5/2])intersection(){
			hull(){
				translate([135,0,0])sphere(d=10);
				translate([-135,0,0])sphere(d=10);
			}
			cube([500,10,5],center=true);
		}
		cylinder(d=16,h=9);
	}
	translate([0,0,-1])cylinder(d=7.8,h=15);
	rotate(180)translate([-.5,0,0])cube([1,20,20]);
}