include <lib/fn.scad>;
$fa=5;$fs=.2;
print=smoothstep(.9,.1,$t);

size=[50,50,50];
wall_t=1.5;
mesh_t=1;
pcb_hole_dist=17;
koma_r=10;
koma_a=1;

spk_glue=-3;
spk_guide_h=3;
spk_guide_t=2;
spk_guide_asobi=.2;

pcb_t=0.8;
pcb2front=1.5;

m3_d0=3;
m3_d1=3.2;
m3_d2=6.5;

zh_h=3.7;
bbox_size=[53,13,25];

screw_l=5+.5;
snapfit_l=10;
snapfit_asobi=.2;
slope_top_l=1;
slope_margin=1;
open_slit_size=[5,1];

usb_size=[9,3];
usb_pos=8;

wire_d=2.4;
wire_pos=8;

vr_size=[[10,1],[15,1.5]];
vr_pos=-6;
vr_inset=6;

sw_travel=2;
sw_knob_in_size=[1.5+.5,2];
sw_knob_out_size=[3,3,1];
sw_knob_out_asobi=.3;
sw2wall=2.75;
sw2pcb=1.5;
sw_margin=1;

layout_gap=5;

module ring(r1,r2){difference(){circle(r=r2);circle(r=r1);}}
module sqsub(s,r){square([s.x-r*2,s.y-r*2],center=true);}
module rsq(s,r){minkowski(){sqsub(s,r);circle(r);}}

module koma(r=koma_r,a=koma_a){cylinder(h=a,r1=r,r2=r-a);}
module insq(){sqsub([size.x,size.y],koma_r);}
module panel(){scale(-1)minkowski(){linear_extrude(wall_t-koma_a)insq();koma();}}
module wall(o=0,t=wall_t){difference(){
	minkowski(){insq();circle(r=koma_r+o);}
	minkowski(){insq();circle(r=koma_r+o-wall_t);}
}}

module spk(o=0){minkowski(){square([1e-9,7],center=true);circle(r=8+o);}}
module spk_ring(o1,o2){difference(){spk(o2);spk(o1);}}
module panel_w_spk(){difference(){
	panel();
	linear_extrude((wall_t-mesh_t)*2,center=true)spk(spk_glue);
}}

module pcb_hole(d){
	for(i=[0:3])rotate(90*i)translate([pcb_hole_dist,pcb_hole_dist])circle(d=d);
}
module usb(o=0){rsq([usb_size.y+o+1e-9,usb_size.x],(usb_size.y+o)/2);}
module vr(){cylinder(d=vr_size[0].x,h=vr_size[0].y*2.1,center=true);translate([0,0,vr_size[0].y])cylinder(d=vr_size[1].x,h=vr_size[1].y);}
module ifs(){
	// potentiometer
	translate([size.x/2-vr_inset,vr_pos,0])vr();
	// usb
	translate([size.x/2,usb_pos,usb_size.y/2])rotate([0,90,0])linear_extrude(wall_t*2.1,center=true)usb();
	// wire
	translate([-size.x/2,wire_pos,wire_d/2])rotate([0,90,0])cylinder(d=wire_d,h=wall_t*2.1,center=true);
	// sw
	translate([0,-size.y/2,0])linear_extrude(sw_knob_out_size.y)square([sw_knob_out_size.x+sw_travel,wall_t*2],center=true);
}
module slope(_h){let(h=_h+slope_margin,w=_h+slope_top_l)polygon([[-h,-w-h],[0,-w],[0,w],[-h,w+h]]);}
module bbox2d(){rotate(-45)square([bbox_size.x,bbox_size.y],center=true);}


module master_front(){
	difference(){
		union(){
			panel_w_spk();
			linear_extrude(pcb2front){
				pcb_hole(m3_d2);
				spk_ring(spk_glue,spk_glue+3);
				difference(){
					translate([0,-16])ring(3,6);
					translate([0,-20.6])circle(d=2);
					translate([+2.5,-17.4])circle(d=2);
					translate([-2.5,-17.4])circle(d=2);
				}
			}
			linear_extrude(pcb2front+pcb_t)wall();
		}
		linear_extrude((pcb2front+pcb_t+wall_t)*2.1,center=true){
			pcb_hole(m3_d0);
			translate([0,16])circle(d=6.3);
		}
	}
	
	translate([0,0,pcb2front+pcb_t]){
		// wire
		let(h=wire_d/2){
			translate([-(size.x/2-wall_t/2),wire_pos,h])rotate([0,-90,0])linear_extrude(wall_t,center=true)difference(){
				slope(h);
				circle(d=wire_d);
			}
		}
		%ifs();
	}
}
module master_body(){
	module lag(){difference(){
		rsq([size.x,size.y],koma_r);
		difference(){
			square(pcb_hole_dist*2,center=true);
			pcb_hole(m3_d2);
		}
		rsq([size.x-wall_t*2,pcb_hole_dist*2-m3_d2],m3_d2/2);
		rsq([pcb_hole_dist*2-m3_d2,size.y-wall_t*2],m3_d2/2);
	}}
	module bbox_area(){minkowski(){bbox2d();circle(koma_r);}}

	h=size.z-(pcb2front+pcb_t+wall_t*2);
	difference(){
		union(){
			linear_extrude(screw_l-(pcb2front+pcb_t+wall_t))difference(){
				lag();
				pcb_hole(m3_d1);
			}
			linear_extrude(h-snapfit_l-bbox_size.z)intersection(){
				bbox_area();
				difference(){
					lag();
					hull()pcb_hole(m3_d2);
				}
			}
			linear_extrude(h-snapfit_l)intersection(){
				bbox_area();
				difference(){
					lag();
					hull()pcb_hole(m3_d2);
					bbox2d();
				}
			}
			difference(){
				linear_extrude(h)wall();
				translate([0,0,h])linear_extrude(open_slit_size.y*2,center=true)square([size.x+.01,open_slit_size.x],center=true);
			}
		}
	
		// usb
		let(w=usb_size.x/2+slope_top_l,h=usb_size.y/2){
			translate([size.x/2-wall_t-.01,usb_pos,h])rotate([0,-90,0]){
				linear_extrude(wall_t*2.1,center=true)usb(-.2);
				linear_extrude(m3_d2/2){
					usb();
					translate([-usb_size.y/2,0])square([usb_size.y,usb_size.x],center=true);
				}
			}
		}

		// potentiometer
		translate([size.x/2-vr_inset,vr_pos,0])vr();

		// wire
		let(h=wire_d/2){
			translate([-(size.x/2-wall_t/2),wire_pos,h]){
				rotate([0,-90,0])linear_extrude(wall_t+snapfit_asobi*2,center=true){
					slope(h);
					circle(d=wire_d);
				}
			}
		}
		
		// sw
		translate([0,-size.y/2,0])linear_extrude(sw_knob_out_size.y*2,center=true)square([sw_knob_out_size.x+sw_travel,wall_t*2.1],center=true);
	}
	//%ifs();
	//%translate([0,0,h-snapfit_l])scale([1,1,-1])linear_extrude(bbox_size.z)bbox2d();
}
module master_back(){
	difference(){
		panel();
		translate([0,0,-wall_t])scale([1,-1,1])linear_extrude(1,center=true){
			scale(.2)offset(.1)import("lib/icon.svg",center=true,convexity=10);
			translate([0,-10])text("avr musicbox",halign="center",valign="center",size=3,font="monospace");
		}
	}
	linear_extrude(snapfit_l)wall(-wall_t);
}
module master_sw(){
	difference(){
		linear_extrude(sw_knob_out_size.y+sw_margin)let(w=sw_knob_out_size.x+sw_travel*2+sw_margin)translate([-w/2,0])square([w,sw2wall]);
		translate([-sw_knob_in_size.x/2,sw2wall-sw_knob_in_size.y,sw2pcb])linear_extrude(sw_knob_out_size.y+sw_margin)square(sw_knob_in_size);
	}
	let(knob=[
		sw_knob_out_size.x-sw_knob_out_asobi,
		sw_knob_out_size.y-sw_knob_out_asobi,
		wall_t+sw_knob_out_size.z
	])linear_extrude(knob.y)translate([-knob.x/2,-knob.z])square([knob.x,knob.z]);
}
module master(){
	a=(size.x+layout_gap)*print;
	translate([a*0,0,wall_t])master_front();
	translate([a*1,0,mix(pcb2front+pcb_t+wall_t,0,print)])master_body();
	translate([a*2,0,mix(size.z-wall_t,wall_t,print)])rotate([0,mix(-180,0,print),0])master_back();
	translate([0,mix(-(size.x/2-wall_t),-(size.x/2+layout_gap),print),mix(pcb2front+pcb_t+wall_t,0,print)])master_sw();
}

module sub_front(){
	wh=pcb2front+pcb_t+wire_d/2;
	panel_w_spk();
	linear_extrude(spk_guide_h)spk_ring(spk_guide_asobi,spk_guide_t);
	difference(){
		union(){
			linear_extrude(wh)wall();
			linear_extrude(wh+snapfit_l)wall(-wall_t);
		}
		translate([-size.x/2,-8,wh])rotate([0,-90,0])linear_extrude(wall_t*4.1,center=true){
			minkowski(){circle(d=wire_d);square([snapfit_l-wire_d,1e-9]);}
			translate([0,-.2/2])square([snapfit_l+1,.2]);
		}
	}
	
}
module sub_body_back(){
	h=size.z-wall_t*2-(pcb2front+pcb_t+wire_d/2);
	panel();
	difference(){
		linear_extrude(h)wall();
		translate([size.x/2,-wire_pos,h])rotate([0,90,0])cylinder(d=wire_d,h=wall_t*2.1,center=true);
	}
}
module sub(){
	a=(size.x+layout_gap)*print;
	translate([a*0,0,wall_t])sub_front();
	translate([a*1,0,mix(size.z-wall_t,wall_t,print)])rotate([0,mix(-180,0,print),0])sub_body_back();
}

module main(){
	master();
	translate([0,size.y+layout_gap,0])sub();
}
main();