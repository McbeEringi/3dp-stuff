$fa=6;
$fs=.5;

module hook(){
	translate([12.75,-1.7,0])linear_extrude(7){
	square([1,3+1.7]);
	difference(){
	rotate(45)square([sqrt(2),sqrt(2)],center=true);
		translate([-1,0])square();
	}
}
}

//square([25.5,1.8]);
intersection(){
union(){
difference(){
	translate([-12.75,0,0])cube([25.5,3,7]);
	translate([-5,0,0])cube([10,2,7]);
	translate([-15,0,2])cube([30,2,7]);
}
translate([10.5,0,0])rotate([90,0,0])cylinder(d=1.8,h=2);
translate([-10.5,0,0])rotate([90,0,0])cylinder(d=1.8,h=2);
hook();
scale([-1,1,1])hook();
}
translate([-25,-15,0])cube([50,30,30]);
}