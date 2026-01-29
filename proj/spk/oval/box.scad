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
module wall(o=0,t=wall_t){
	difference(){
		minkowski(){square([size.x-koma_r*2,size.y-koma_r*2],center=true);circle(koma_r+o);}
		minkowski(){square([size.x-koma_r*2,size.y-koma_r*2],center=true);circle(koma_r-t+o);}
	}
}

module wire(){
	translate([-size.x/2,8,0])rotate([90,0,90])
	linear_extrude(wall_t*10,center=true){
		minkowski(){square([wire_d,1e-3],center=true);circle(d=wire_d,$fs=.1);}
		translate([-wire_d/2,0])square([wire_d,20]);
	}
}
module front_spk(){
	difference(){
		union(){
			panel();
			linear_extrude(3)difference(){spk(2);spk(.2);}
			linear_extrude(10)wall(-wall_t);
		}
		linear_extrude(wall_t,center=true)spk();
		wire();
	}
}
module rear_spk(){
	h=size.z-wall_t*2;
	panel();
	difference(){
		linear_extrude(h)wall();
		scale([-1,1,1])translate([0,0,h])wire();
	}
}
module main_spk(){
	translate([0,0,wall_t])front_spk();
	translate([mix(0,size.x*1.5,print),0,mix(size.z-wall_t,wall_t,print)])rotate([0,mix(180,0,print),0])rear_spk();
}
//main_spk();


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
			// usb
			linear_extrude(3)translate([20,-8])square([20,9],center=true);
			// vr
			linear_extrude(2.2)translate([19,6])circle(d=15);
			// sw_spdt
			linear_extrude(5)translate([0,-19.2])square([9,50],center=true);
			linear_extrude(6){
				// out1
				translate([-16,8])square([19,8],center=true);
				// pwr
				translate([-16,-8])square([19,8],center=true);
			}
		}
	}
	// sw_push
	translate([-12.5,0])linear_extrude(4.3)circle(d=6.3);
	linear_extrude(2){
		// xh_pin
		translate([-13,8])square([2,5],center=true);
		translate([-13,-8])square([2,5],center=true);
		// sw_spdt_pin
		translate([0,-19.2])square([11,4],center=true);
	}
	linear_extrude(1){
		// led
		translate([-18,0])square([4,4],center=true);
		// vr_pin
		translate([19,6]){
			translate([-7.5,0])square([2,10],center=true);
			translate([2.5,5])square([3,2],center=true);
			translate([2.5,-5])square([3,2],center=true);
		}
	}
}

module bbox(){
	rotate(45)cube([53,13,25],center=true);
}


module front_pcb(){
	h=size.z-wall_t*2;
	difference(){
		union(){
			panel();
			linear_extrude(h)wall();
			for(i=[0:3])rotate(90*i)translate([17,17,-wall_t])linear_extrude(3)circle(d=6.5);
		}
		linear_extrude(wall_t,center=true)spk();
		for(i=[0:3])rotate(90*i)translate([17,17,0])linear_extrude(wall_t*2.1,center=true)circle(d=3,$fs=.1);
	translate([0,0,-wall_t+3])rotate([0,180,0])pcb();
	}
	translate([0,0,h/2])%bbox();
}
module rear_pcb(){
	panel();
	linear_extrude(10)wall(-wall_t);
}
module pcb_washer(){linear_extrude(5-3-1.2+.5)difference(){circle(d=6.5);circle(d=3.5,$fs=.1);}}
module main_pcb(){
	for(i=[-1.5:1.5])translate([-size.x,i*10,0])pcb_washer();
	translate([0,0,wall_t])front_pcb();
	translate([mix(0,size.x*1.5,print),0,mix(size.z-wall_t,wall_t,print)])rotate([0,mix(180,0,print),0])rear_pcb();
}
module main(){
	main_spk();
	translate([0,size.y*1.5,0])main_pcb();
}
main();