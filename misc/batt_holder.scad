$fa=6;
$fs=.5;

module AA(){
	cylinder(d=14.6,h=50);translate([0,0,50])cylinder(d=6,h=1.5);
}
module AAA(){
	cylinder(d=10.7,h=45);translate([0,0,45])cylinder(d=3.9,h=1.5);
}
difference(){
	translate([8.5-1.2,-3,0])cube([17*5.5+2.4,17*sqrt(3)/2+6,3]);
	for(i=[1:6])translate([i*17,0,-10])AA();
	for(i=[1:6])translate([(i-.5)*17,17*sqrt(3)/2,-10])AA();
}
translate([0,25,0])difference(){
	translate([6.5-1.15,-2,0])cube([13*5.5+2.3,13*sqrt(3)/2+4,3]);
	for(i=[1:6])translate([i*13,0,-10])AAA();
	for(i=[1:6])translate([(i-.5)*13,13*sqrt(3)/2,-10])AAA();
}