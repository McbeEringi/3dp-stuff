include <lib/fn.scad>
use <omni2.scad>
$fa=1;$fs=1;
print=$preview?smoothstep(.3,.9,$t):1;

batt=[50,70];
motor=[12,10];
thick=5;
tome_d=15;
tome_h=10;
tome_h_asobi=.4;
tome_o=30;
d=150;
tome_tip=[2,3];

module tomegu(t=thick){
	tip=[2,3];
	
	difference(){
		union(){
			circle(d=tome_d);
			translate([tome_d/2,0,0])scale(-1)square([tome_d,motor.y/2+t+tip.y]);
			translate([-tome_d/2-tip.x,-(motor.y/2+t+tip.y)])square([tome_d+tip.x*2,tip.y-.01]);
		}
		intersection(){
			circle(d=motor.x);
			square(motor,center=true);
		}
		translate([motor.x/2,-motor.y/2*.8,0])scale(-1)square([motor.x,tome_d]);
	}
}


translate([0,0,mix(-thick-10/2,0,print)]){
	linear_extrude(thick)difference(){
		circle(d=d);
		for(i=[0:4-1])rotate(360/4*i){
			translate([d/2,0]){
				scale(-1)omni_bb_2d(2);
				translate([-tome_o,0]){
					s=[tome_h+tome_h_asobi,sqrt(((tome_d-motor.x)/2+tome_tip.x)^2+tome_tip.y^2)];
					translate([-s.x/2,-tome_d/2])square(s);
					scale([1,-1])translate([-s.x/2,-tome_d/2])square(s);
				}
			}
		}
	}
	translate([0,0,thick])linear_extrude(5)difference(){
		rotate(atan(batt.y/batt.x))square([100,20],center=true);
		square(batt,center=true);
	}
}


for(i=[0:4-1])rotate(360/4*i){
	translate([mix(d/2-tome_o-tome_h/2,d/2,print),0,0])rotate([mix(90,0,print),0,mix(90,0,print)])linear_extrude(tome_h)tomegu();

	translate([d/2,0])scale(-1)%omni_ph($fn=16,flip_motor=true);
}
