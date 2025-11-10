include <lib/fn.scad>;
$fa=1;$fs=1;
print=smoothstep(1,0,$t);

size=[50,50,50];
koma_r=size.x/3;
koma_a=2;
wire_d=1;

module koma(r=koma_r,a=koma_a){scale([1,1,-1])cylinder(h=a,r1=r,r2=r-a);}
module spk(o=0){minkowski(){
	square([7,1e-9],center=true);
	circle(r=8+o);
}}

module plate(){
	minkowski(){
		cube([size.x-koma_r*2,size.y-koma_r*2,1e-9],center=true);
		koma();
	}
}
module wire(){
	translate([0,0,wire_d/2])rotate([90,0,45])linear_extrude(50)minkowski(){
		square([1e-9,50]);
		circle(d=wire_d);
	}
}

module front(){
	difference(){
		plate();
		translate([0,0,-1])linear_extrude(2)spk(-3);
	}
	linear_extrude(3)difference(){spk(2);spk(.2);}

	difference(){
		linear_extrude(size.z-koma_a*2)difference(){
			offset(koma_r  )square([size.x-koma_r*2,size.y-koma_r*2],center=true);
			offset(koma_r-koma_a)square([size.x-koma_r*2,size.y-koma_r*2],center=true);
		}
		translate([0,0,size.z-koma_a*2-wire_d*3]){
			wire();
			rotate(90)wire();
		}
	}
}
module back(){
	difference(){
		union(){
			plate();
			linear_extrude(10)difference(){
				offset(koma_r-koma_a  )square([size.x-koma_r*2,size.y-koma_r*2],center=true);
				offset(koma_r-koma_a*2)square([size.x-koma_r*2,size.y-koma_r*2],center=true);
			}
		}
		wire();
	}
}

module main(){
	translate([0,0,mix(0,koma_a,print)])front();
	translate([0,mix(0,(size.y+10),print),mix(size.z-koma_a*2,0,print)])rotate([mix(180,0,print),0,0])back();
}
main();