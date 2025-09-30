include <../lib/fn.scad>;
$fa=1;$fs=1;

print=saturate($t*2-.5);

d=50;n=5;
roller_arc_ratio=.8;
roller_r_min=1.5;
roller_r_max=(1-sin(90-180/n*roller_arc_ratio))*d/2+roller_r_min;
roller_h=sin(180/n*roller_arc_ratio)*d;
roller_shaft_r=.8;

module shaft(l=4){
	linear_extrude(l)intersection(){
		circle(d=3,$fn=32);
		translate([.5,0])square([3,3],center=true);
	}
}
module motor(){
	shaft();
	translate([0,0,-1])cylinder(d=4,h=1);
	translate([-6,-5,-25.25])cube([12,10,24.25]);
}

//motor();
//arc(25,1,60);

module roller(){
	translate([0,0,mix(0,roller_h/2,print)])
	rotate([mix(90,0,print),0,0])
	rotate_extrude()intersection(){
		translate([roller_r_max-d/2,0])circle(d=d);
		translate([roller_shaft_r,-roller_h/2])square([roller_r_max-roller_shaft_r,roller_h]);
	}
}

circle(d=d);
#for(i=[1:n]){
	rotate(mix(360*i/n,0,print))translate([mix(d/2-roller_r_max,(i-.5)*roller_r_max*3,print),0,0])roller();
}
