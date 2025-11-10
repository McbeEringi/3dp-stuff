include <lib/fn.scad>
$fa=1;$fs=1;
print=smoothstep(1,0,$t);

size=[100,50];
ring_h=5;
koma_r=size.y/3;
koma_a=2;
wall_t=2;
wire_d=1.3;
spk_asobi=.2;
ring_asobi=.2;

module koma(r=koma_r,a=koma_a,dir){
	if(!dir||dir=="up")cylinder(h=a,r1=r,r2=r-a);
	if(!dir||dir=="down")scale(-1)cylinder(h=a,r1=r,r2=r-a);
}

module spk(o=0){
	hull(){
		translate([+(70/2-15),30/2-15])circle(r=15+o);
		translate([+(70/2-10),30/2-10])circle(r=10+o);
		translate([-(70/2-15),30/2-15])circle(r=15+o);
		translate([-(70/2-10),30/2-10])circle(r=10+o);
	}
}
module ring(){linear_extrude(ring_h)difference(){
	spk(spk_asobi);
	minkowski(){
		square([70-15*2,1e-9],center=true);
		circle(r=13+ring_asobi);
	}
	//translate([-1/2,0])square([1,30]);
}}

module panel(){
	minkowski(){
		translate([0,0,koma_a])cube([size.x-koma_r*2,size.y-koma_r*2,1e-9],center=true);
		koma(dir="down");
	}
	translate([0,0,koma_a])linear_extrude(10)difference(){
		offset(koma_r-koma_a  )square([size.x-koma_r*2,size.y-koma_r*2],center=true);
		offset(koma_r-koma_a*2)square([size.x-koma_r*2,size.y-koma_r*2],center=true);
	}
}
module wire(){
	translate([(size.x-size.y)/2,0,wire_d/2])rotate([0,-90,-135])linear_extrude(50)minkowski(){
		square([50,1e-9]);
		circle(d=wire_d);
	}
}

module front(){
	difference(){
		panel();
		translate([0,0,1])linear_extrude(1.01)minkowski(){
			square([70-15*2,1e-9],center=true);
			circle(r=25/2);
		}
	}
	translate([0,0,koma_a]){
		linear_extrude(3+ring_h)difference(){spk(wall_t+spk_asobi);spk(spk_asobi);}
	}
}
module middle(){difference(){
	linear_extrude(50-koma_a*2)difference(){
		offset(koma_r)square([size.x-koma_r*2,size.y-koma_r*2],center=true);
		offset(koma_r-koma_a)square([size.x-koma_r*2,size.y-koma_r*2],center=true);
	}
	translate([0,0,wire_d*2])scale([1,1,-1])wire();
	translate([0,0,50-koma_a*2-wire_d*2])wire();
}}
module back(){
	difference(){
		panel();
		translate([0,0,koma_a]){
			wire();
			scale([-1,1,1])wire();
		}
	}
}

module main(){
	front();
	translate([0,mix(0,60,print),mix(koma_a+3,0,print)])ring();
	translate([0,mix(0,60,print),mix(koma_a,0,print)])middle();
	translate([0,mix(0,120,print),mix(50,0,print)])rotate([mix(180,0,print),0,0])back();
}
main();
//koma();