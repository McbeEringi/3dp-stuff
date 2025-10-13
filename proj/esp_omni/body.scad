include <lib/fn.scad>
use <omni2.scad>
$fa=1;$fs=1;
print=$preview?smoothstep(.3,.9,$t):1;

batt=[48,68,17.5];
bread=[46,35];
motor=[12,10];
thick=5;
tome_d=15;
tome_h=10;
tome_h_asobi=.4;
tome_o=30;
tome_btm=[5,2];
d=150;

module tomegu(t=thick){
	difference(){
		union(){
			circle(d=tome_d);
			translate([tome_d/2,0])scale(-1)square([tome_d,motor.y/2+t+tome_btm.y]);
		}
		intersection(){
			circle(d=motor.x);
			square(motor,center=true);
		}
		translate([-tome_d/2,motor.y/2*.9])square([tome_d,t]);
		translate([tome_btm.x/2,-motor.y/2])scale(-1)square([tome_btm.x,t]);
	}
}


#translate([0,0,mix(motor.y/2,0,print)]){
	linear_extrude(thick)difference(){
		circle(d=d);
		square(bread,center=true);
		for(i=[0:4-1])rotate(360/4*i){
			translate([d/2,0]){
				scale(-1)omni_bb_2d(2);
				translate([-tome_o,0]){
					s=[tome_h+tome_h_asobi,(tome_d-tome_btm.x)/2+tome_h_asobi];
					o=[-s.x/2,-(tome_d+tome_h_asobi)/2];
					translate(o)square(s);
					scale([1,-1])translate(o)square(s);
					translate([-tome_h,tome_d])circle(d=7);
				}
			}
		}
		translate([-batt.x/2,-batt.y/2])square([20,12]);
	}
	linear_extrude(1)square([bread.x/3,bread.y],center=true);
}
	%translate([0,0,motor.y/2-batt.z/2-1])cube(batt,center=true);


for(i=[0:4-1])rotate(mix(360/4*i,0,print)){
	translate([mix(d/2-tome_o-tome_h/2,d*.6,print),mix(0,i*(tome_d+1),print),0])rotate([mix(-90,0,print),0,-90])linear_extrude(tome_h)tomegu();

	translate([d/2,0])scale(-1)%omni_ph($fn=16,flip_motor=true);
}
