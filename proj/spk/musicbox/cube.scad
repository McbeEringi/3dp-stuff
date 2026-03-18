include <lib/fn.scad>;
$fa=5;$fs=.2;
print=smoothstep(.9,.1,$t);

size=[50,50,50];
wall_t=1.5;
mesh_t=1;

spk_glue=-3;

spk_guide_h=3;
spk_guide_t=2;
spk_guide_asobi=.2;


m3_d0=3;
m3_d1=3.2;
m3_d2=6.5;

screw_l=5+.5;

pcb_hole_dist=17;

usb_size=[9,3];
zh_h=3.7;
bbox_size=[53,13,25];

koma_r=10;
koma_a=1;

snapfit_l=10;

wire_d=2.4;
wire_press_l=0;//8-wall_t;
pcb_t=0.8;
pcb2front=1.5;

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
module usb(){rsq([usb_size.y+1e-9,usb_size.x],3/2);}
module ifs(){
	// potentiometer
	translate([size.x/2-6,-6,0])cylinder(d=15,h=3);
	// usb
	translate([size.x/2,8,usb_size.y/2])rotate([0,90,0])linear_extrude(wall_t*2.1,center=true)usb();
	// wire
	translate([-size.x/2,8,wire_d/2])rotate([0,90,0])cylinder(d=wire_d,h=wall_t*2.1,center=true);
	// sw
	translate([0,-size.y/2,0])linear_extrude(3)square([3+2,wall_t*2],center=true);
}
module slope(w,h){polygon([[-h,-w-h],[0,-w],[0,w],[-h,w+h]]);}
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
		// usb
		let(w=usb_size.x/2+1,h=usb_size.y/2){
			translate([size.x/2-wall_t/2,8,h])rotate([0,-90,0])linear_extrude(wall_t,center=true)difference(){
				slope(w,h+1);
				usb();
			}
		}
		
		// wire
		let(h=wire_d/2,w=h+1){
			translate([-(size.x/2-wall_t/2),8,h])rotate([0,-90,0])linear_extrude(wall_t,center=true)difference(){
				slope(w,h+1);
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
		rsq([17*2-6.5,size.y-wall_t*2],m3_d2/2);
	}}
	module bbox_area(){minkowski(){bbox2d();circle(koma_r);}}
	module key(t=.1){rotate([0,90,0])linear_extrude(t,center=true){circle(d=wire_d);translate([0,-wire_d/2])square([10,wire_d]);}}

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
				translate([0,0,h])linear_extrude(2,center=true)square([size.x+.01,5],center=true);
			}
			if(wire_press_l)translate([-size.x/2,4,0])mirror([0,-1,1])linear_extrude(pcb_hole_dist-4-m3_d2/2)hull(){
				square([wall_t+wire_press_l,zh_h]);
				square([wall_t,zh_h+wire_press_l]);
			}
		}
	
		// usb
		let(w=usb_size.x/2+1,h=usb_size.y/2){
			translate([size.x/2-wall_t/2,8,h])rotate([0,-90,0]){
				linear_extrude(wall_t+0.2*2,center=true)slope(w,h+1);
				linear_extrude(wall_t*5,center=true){
					usb();
					translate([-usb_size.y/2,0])square([usb_size.y,usb_size.x],center=true);
				}
			}
		}

		// potentiometer
		translate([size.x/2-6,-6,0])cylinder(d=15,h=3*2,center=true);

		// wire
		let(h=wire_d/2,w=h+1){
			translate([-(size.x/2-wall_t/2),8,h]){
				rotate([0,-90,0])linear_extrude(wall_t+.2*2,center=true){
					slope(w,h+1);
					circle(d=wire_d);
				}

				if(wire_press_l)translate([wall_t/2,0,0])let(x=[
						[.2,0],
						[2.5,-.6],
						[wire_press_l-2,-.6],
						[wire_press_l,1.5]
					])for(i=[0:len(x)-2])hull(){
					translate([x[i].x,0,x[i].y])key();
					translate([x[i+1].x,0,x[i+1].y])key();
				}
			}
		}
		
		// sw
		translate([0,-size.y/2,0])linear_extrude(3*2,center=true)square([3+2,wall_t*2.1],center=true);
	}
	//%ifs();
	//%translate([0,0,h-snapfit_l])scale([1,1,-1])linear_extrude(bbox_size.z)bbox2d();
}
module master_back(){
	difference(){
		panel();
		translate([0,0,-wall_t])scale([-1,1,1])linear_extrude(1,center=true){
			scale(.2)offset(.5)import("lib/icon.svg",center=true,convexity=10);
			translate([0,-10])text("avr musicbox",halign="center",valign="center",size=3,font="monospace");
		}
	}
	linear_extrude(snapfit_l)wall(-wall_t);
}
module master_sw(){
	difference(){
		linear_extrude(3+1)translate([-(3+2*2+1)/2,0])square([3+2*2+1,2.75]);
		translate([-2/2,2.75-2,1.5])linear_extrude(3+1)square(2);
	}
	linear_extrude(2.7)translate([-2.7/2,-2.7])square(2.7);
}
module master(){
	a=(size.x+5)*print;
	translate([a*0,0,wall_t])master_front();
	translate([a*1,0,mix(pcb2front+pcb_t+wall_t,0,print)])master_body();
	translate([a*2,0,mix(size.z-wall_t,wall_t,print)])rotate([0,mix(-180,0,print),0])master_back();
	translate([0,mix(-(size.x/2-wall_t),-(size.x/2+5),print),mix(pcb2front+pcb_t+wall_t,0,print)])master_sw();
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
		translate([size.x/2,-8,h])rotate([0,90,0])cylinder(d=wire_d,h=wall_t*2.1,center=true);
	}
}
module sub(){
	a=(size.x+5)*print;
	translate([a*0,0,wall_t])sub_front();
	translate([a*1,0,mix(size.z-wall_t,wall_t,print)])rotate([0,mix(-180,0,print),0])sub_body_back();
}

module main(){
	master();
	translate([0,size.y+5,0])sub();
}
main();