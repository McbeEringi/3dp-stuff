use <../lib/gears.scad>
use <../lib/gear.scad>
$fs=1;$fa=1;
function saturate(x)=max(0,min(x,1));
function smoothstep(a,b,x)=let(x=saturate((x-a)/(b-a)))x*x*(3-2*x);

txt="ueckoken kagimod @McbeEringi ";

t=0;
gear_h=5;

module jikuuke(){
	translate([0,0,-.01])cylinder(d=5.2,h=gear_h);
	translate([0,0,2])cylinder(d=8,h=15);
}
module jiku(){
	linear_extrude(2.5)difference(){
		circle(d=5);
		circle(d=3.1);
	}
}
{
	rotate(t)difference(){
		union(){
			translate([0,0,gear_h/2])yamaba(m=2,z=19,h=gear_h);
			translate([0,0,gear_h]){
				difference(){
					union(){
						cylinder(h=3,r=16);
						translate([0,0,3])cylinder(h=5,r1=16,r2=9);
					}
					translate([-3/2,-3/2,-.01])cube(20);
					rotate(180)translate([-3/2,-3/2,-.01])cube(20);
				}
			}
		}
		jikuuke();
	}
	jiku();
}
translate([19+17,0,0]){
	rotate(-t/17*19)difference(){
		translate([0,0,gear_h/2])yamaba(m=2,z=17,h=gear_h,a=-30);
		jikuuke();
	}
	jiku();
}
translate([19+17+17+19,0,0]){
	rotate(t)difference(){
		union(){
			translate([0,0,gear_h/2])yamaba(m=2,z=19,h=gear_h);
			translate([0,0,gear_h])linear_extrude(5)difference(){
				circle(r=16);
				polygon([[6,0],[4,20],[-4,20],[-6,0],[-4,-20],[4,-20]]);
			}
		}
		jikuuke();
	}
	jiku();
}




	// sumturn gear


module text_circle(txt,r,size){
	for(i=[0:len(txt)-1])rotate(-i/len(txt)*360)translate([0,r])text(txt[i],size=size/len(txt),halign="center");
}
