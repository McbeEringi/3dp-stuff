$fa=2;$fs=.2;
include <lib/fn.scad>

print=$preview?0:1;

size=120;
stand_size=100;
koma=3;
thick=5;
rnd=20;
wire=2.4;

module rsq(s,r){
	minkowski(){
		square(s.x==undef?s-r*2:[s.x-r*2,s.y-r*2],center=true);
		circle(r=r);
	}
}
module hole(d,l=1e-9){
	for(i=[0:3])rotate(90*i)rotate(45)translate([117/2,0])minkowski(){circle(d=d);square([l,1e-9],center=true);}
}
module koma(r=rnd,a=koma){
	cylinder(a,r,r-a/sqrt(3));
}
module panel()scale(-1)minkowski(){
	linear_extrude(thick-koma)square(size-rnd*2,center=true);
	koma();
}
module rsqn(n,d=0){
	rsq(size-thick*n*2+d,rnd-thick*n);
}
module wall(n){
	difference(){rsqn(n);rsqn(n+1);}
}


module front(){
	difference(){
		union(){
			difference(){
				panel();
				linear_extrude((thick-1)*2,center=true)rsqn(1);
				rotate([-90,0,-45])cylinder(d=wire,h=size);
			}
			translate([0,0,-thick])linear_extrude(thick-(.7+.3))difference(){
				rsqn(2);
				circle(d=102);
			}
			translate([0,0,-thick])linear_extrude(thick-(.7+.3)+.6)hole(5,2);
		}
		linear_extrude(thick*3,center=true)hole(3.2);
		translate([0,0,-thick-1e-2])linear_extrude(2)hole(6);
	}
	translate([0,0,-thick])linear_extrude(2)hole(3.2);

}

module body(){
	difference(){
		union(){
			linear_extrude(5)difference(){
				rsq(size-thick,rnd);
				circle(d=102);
				hole(3);
				minkowski(){circle(d=wire);square([size/2-thick*1.5,1e-9]);}
				minkowski(){circle(d=wire);square([1e-9,size/2-thick*1.5]);}
			}
			linear_extrude(size-thick*2)wall(0);
		}
		rotate([90,0,-45])translate([0,0,-size/2*sqrt(2)])cylinder(d=wire,h=rnd);
	}
}

module back(){
	difference(){
		panel();
		translate([size/2-rnd,size/2-rnd,-thick])linear_extrude(.4,center=true)rotate(135)scale([1,-1]){
			scale(.2)offset(1e-3)import("lib/icon.svg",center=true);
			translate([0,-15])text("Akizuki Denshi [118081]",size=3,font="monospace",halign="center",valign="top");
			translate([0,-20])text("wide range spk unit  10cm 8Ω 10W",size=3,font="monospace",halign="center",valign="top");
			translate([0,-25])text("KITANIHON ONKYO - F02710H0",size=3,font="monospace",halign="center",valign="top");
		}
	}
	difference(){
		minkowski(){
			linear_extrude(20-2)rsqn(1,-1);
			cylinder(2,.5,0);
		}
		linear_extrude(50,center=true)rsqn(2);
	}
}

module stand(){
	difference(){
		union(){
			difference(){
				cylinder(d=stand_size,h=size);
				cylinder(d=stand_size-2*2,h=stand_size*2,center=true);
				difference(){
					translate([0,0,-stand_size/2])for(t=[60,180,-60])rotate([45,0,t])cylinder(d=stand_size*.8,h=stand_size*2);
					cylinder(r=stand_size,h=5);
				}
			}
			intersection(){
				for(t=[60,180,-60])rotate(t)translate([0,stand_size/2-2,0])difference(){
					scale([1,size/stand_size,1])skew(yz=15)cylinder(d=stand_size*.2,h=stand_size*.5);
					translate([0,-5,0])cylinder(d=10,h=3*2,center=true);
				}
				cylinder(d=stand_size,h=stand_size);
			}
		}
		rotate([45,-acos(sqrt(2)/sqrt(3)),30]){
			%cube(size);
			translate([size/2,size/2,thick]){
				panel();
				translate([0,0,-.1])linear_extrude(size-thick+.1)rsqn(0);
			}
		}
	}
}


module main(){
	rotate([mix(45,0,print),mix(-acos(sqrt(2)/sqrt(3)),0,print),mix(30,0,print)])translate([mix(size/2,0,print),mix(size/2,0,print),0]){
		translate([0,0,mix(size-thick,0,print)])rotate([mix(180,0,print),0,0]){
			translate([mix(0,size*1.1,print),0,mix(0,thick,print)])front();
			body();
		}
		translate([mix(0,size*2.2,print),0,thick])back();
	}
	translate([mix(0,size*3.3,print),0,0])stand();
}
main();