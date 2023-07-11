$fs=.5;
difference(){
	translate([0,-5,0])cube([101,25,3]);
	translate([50,50,0])cylinder(d=100,h=10,center=true);
	translate([101/2,101/2-117/2/sqrt(2),0]){
		translate([-117/4*sqrt(2),0,0]){
			cylinder(3.01,3.5,5);
			translate([-5,-5,0])cube([10,2.5,5]);
		}
		translate([117/4*sqrt(2),0,0]){
			cylinder(3.01,3.5,5);
			translate([-5,-5,0])cube([10,2.5,5]);
		}
	}
}

module stick()translate([0,0,2.5])rotate([90,0,0]){
	difference(){
		translate([0,0,1])cylinder(3,3.5,5);
		translate([-5,-12.5,0])cube(10);
	}
	cylinder(d=5,h=1);
	intersection(){
		translate([0,0,-25])cylinder(50,r=3.5,center=true);
		cube([10,5,1000],center=true);
	}
}
for(i=[1:2])translate([-15*i,0,0])
stick();

for(i=[1:2])translate([0,-10*i,0])cube([10,2.5,3]);