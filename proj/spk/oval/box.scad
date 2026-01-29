include <lib/fn.scad>;
$fa=1;$fs=1;
print=smoothstep(1,0,$t);
size=[50,50,50];
koma_r=10;
koma_a=1;
wire_d=1;
wall_t=1.5;
pcb_offset=3.01;
pcb_t=1.2;

module koma(r=koma_r,a=koma_a){scale([1,1,-1])cylinder(h=a,r1=r,r2=r-a);}
module spk(o=-3){minkowski(){
	square([1e-9,7],center=true);
	circle(r=8+o);
}}

module icon(p){scale(10/6.35)translate([0,-6.35])import(str("lib/material_icon/",p),center=true);}

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
	linear_extrude(wall_t*6,center=true){
		minkowski(){
			union(){
				square([1e-3,5]);
				square([wire_d,1e-3],center=true);
			}
			circle(d=wire_d,$fs=.1);
		}
		translate([-.1/2,0])square([.1,20]);
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
	d=(size.x-wall_t)/2;
	module txt(s,t=.5){rotate([-90,0,0])translate([0,0,wall_t/2])linear_extrude(t*2,center=true)text(s,size=4,halign="center",valign="center",font="monospace");}
	module ico(s,t=.5){rotate([-90,0,0])translate([0,0,wall_t/2])linear_extrude(t*2,center=true)scale(.75)icon(s);}
	
	scale([1,1,-1])linear_extrude(pcb_t)difference(){
		polygon([
			[-18,22],[-21,19],
			[-21,-19],[-18,-22],
			[18,-22],[23,-17],
			[23,17],[18,22]
		]);
		for(i=[0:3])rotate(90*i)translate([17,17])circle(d=3.2);
		spk();
	}
	translate([0,0,-pcb_t]){
		// vr
		translate([19,6,0])scale(-1)linear_extrude(3)circle(d=15);
		translate([d,6,-8])rotate(-90)ico("volume_up.svg");
		// usb
		translate([d,-8,-3/2])rotate([0,90,0])linear_extrude(wall_t*1.1,center=true)minkowski(){square([1e-3,9-3],center=true);circle(d=3);}
		translate([d,-8,-8])rotate(-90)ico("cable.svg");
		// sw_pow
		translate([0,-d,-3])rotate([90,0,0])linear_extrude(wall_t*1.1,center=true)square([5,3],center=true);
		translate([-8,-d,-3])rotate(180)ico("battery_android_full.svg");
		translate([8,-d,-3])rotate(180)ico("cable.svg");
		// xt_pow
		%translate([-d,-8,-6/2-.5])rotate([0,90,0])linear_extrude(wall_t*1.1,center=true)square([6,8],center=true);
		%translate([-d,-8,-11.5])rotate(90)ico("battery_android_full.svg");
		// xt_out1
		translate([-d,8,-6/2-.5])rotate([0,90,0])linear_extrude(wall_t*1.1,center=true)square([6,8],center=true);
		translate([-d,8,-11.5])rotate(90)ico("speaker.svg");
	}
	// sw_push
	translate([-12.5,0])linear_extrude(4.3)circle(d=6.3);
	
	linear_extrude(2){
		// xh_pin
		translate([-13.5,8])square([2,4],center=true);
		translate([-13.5,-8])square([2,4],center=true);
		// sw_spdt_pin
		translate([0,-19.2])square([10.4,3.5],center=true);
	}
	linear_extrude(1){
		// led
		translate([-18,0])square([2.8,2.8],center=true);
		// vr_pin
		translate([19,6]){
			translate([-7.5,0])square([2,10],center=true);
			translate([2.5,5])square([2,1.5],center=true);
			translate([2.5,-5])square([2,1.5],center=true);
		}
	}
}
module bbox(){
	translate([0,0,25/2])rotate(45)cube([53,13,25],center=true);
}


module front_pcb(){
	h=size.z-wall_t*2;
	difference(){
		union(){
			panel();
			linear_extrude(h)wall();
			translate([0,0,-wall_t])linear_extrude(pcb_offset){
				for(i=[0:3])rotate(90*i)translate([17,17])circle(d=6.5);
					spk(0);
			}
		}
		translate([0,0,-wall_t/2])linear_extrude(pcb_offset)spk();
		for(i=[0:3])rotate(90*i)translate([17,17,-wall_t+pcb_offset/2])linear_extrude(pcb_offset*1.05,center=true)circle(d=3,$fs=.1);
		translate([0,0,-wall_t+pcb_offset])rotate([0,180,0])pcb();
		translate([0,-size.x/2,h/2+5])rotate([90,0,0])linear_extrude(1,center=true){
			scale(.2)offset(.5)import("lib/icon.svg",center=true,convexity=10);
			translate([0,-10])text("avr musicbox",halign="center",valign="center",size=3,font="monospace");
		}
		translate([0,0,h])linear_extrude(2,center=true){square([size.x+.01,5],center=true);square([5,size.y+.01],center=true);}
	}
	translate([0,0,h-10-25])%bbox();
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
