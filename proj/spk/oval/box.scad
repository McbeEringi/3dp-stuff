include <lib/fn.scad>;
$fa=1;$fs=1;
print=smoothstep(1,0,$t);

size=[50,50,50];
koma_r=10;
koma_a=1;
wire_d=1;
wall_t=1.5;

module koma(r=koma_r,a=koma_a){scale([1,1,-1])cylinder(h=a,r1=r,r2=r-a);}
module spk(o=-3){minkowski(){
	square([1e-9,7],center=true);
	circle(r=8+o);
}}

module panel(){
	assert(koma_a<=wall_t);
	minkowski(){
		translate([0,0,-(wall_t-koma_a)/2])cube([size.x-koma_r*2,size.y-koma_r*2,wall_t-koma_a],center=true);
		koma();
	}
}
//panel();




module pcb(){
	scale([1,1,-1]){
		linear_extrude(1.2)difference(){
			polygon([
				[-18,22],[-21,19],
				[-21,-19],[-18,-22],
				[18,-22],[23,-17],
				[23,17],[18,22]
			]);
			for(i=[0:3])rotate(90*i)translate([17,17])circle(d=3.2);
			spk(-3);
		}
		translate([0,0,1.2]){
			linear_extrude(3)translate([20,-8])square([20,9],center=true);
			linear_extrude(1.5)translate([19,6])circle(d=15);
			linear_extrude(5)translate([0,-19.2])square([9,50],center=true);
			linear_extrude(6){
				translate([-16,8])square([18,8],center=true);
				translate([-16,-8])square([18,8],center=true);
			}
		}
	}
	translate([-12.5,0])linear_extrude(3)circle(d=6.3);
	linear_extrude(2){
		translate([-13,8])square([2,5],center=true);
		translate([-13,-8])square([2,5],center=true);
		
		translate([0,-19.2])square([11,4],center=true);
	}
	linear_extrude(1){
		// led
		translate([-18,0])square([4,4],center=true);
		// vr
		translate([19,6]){
			translate([-7.5,0])square([2,10],center=true);
			translate([2.5,5])square([3,2],center=true);
			translate([2.5,-5])square([3,2],center=true);
		}
	}
}
//pcb();

module main(){
	translate([0,0,mix(0,koma_a,print)])sub_front();
	translate([0,mix(0,(size.y+10),print),mix(size.z-koma_a*2,0,print)])rotate([mix(180,0,print),0,0])back();
}
//main();

difference(){
linear_extrude(20,center=true)difference(){
minkowski(){square([30,30],center=true);circle(10);}
minkowski(){square([30,30],center=true);circle(8.5);}
}
pcb();
}