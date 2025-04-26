use <../lib/gears.scad>
$fs=1;$fa=1;
function saturate(x)=max(0,min(x,1));
function smoothstep(a,b,x)=let(x=saturate((x-a)/(b-a)))x*x*(3-2*x);

t=smoothstep(0,1,$t)*90;
spl=0;//smoothstep(2,1,$t*3);
rot=45;

show_gears=true;
show_frame=true;
show_cover=true;
show_spacer=true;

txt="ueckoken kagimod @McbeEringi ";

if(show_gears)rotate(rot){
	// sumturn gear
	rotate(t+45){
		herringbone_gear(2, 20, 3, 32,helix_angle=30,optimized=false);
		difference(){
			union(){
				cylinder(r=16,h=3+5);
				translate([0,0,3+5])cylinder(r1=16,r2=12,h=2);
			}
			translate([-3/2,-3/2,-1])cube(19);
			rotate(180)translate([-3/2,-3/2,-1])cube(19);
		}
	}
	// idler gear
	translate([0,32,0])rotate(360/12/2+45-t/12*20)herringbone_gear(2, 12, 3, 16,helix_angle=-30,optimized=false);
	// servo gear
	translate([32,32,0])rotate(t+45){
		herringbone_gear(2, 20, 3, 28,helix_angle=30,optimized=false);
		linear_extrude(5)intersection(){
			circle(15);
			difference(){
				square([33,10],center=true);
				translate([ 13,0])circle(d=1.8);
				translate([-13,0])circle(d=1.8);
				circle(10);
			}
		}
	}
}


module window(){
	circle(16.1);
	translate([32,32])circle(16.1);
}
module gearbb(b,bi){
	difference(){
		union(){
			circle(22+b);
			translate([0,32])difference(){
				circle(14+b);
				circle(8-(bi?bi:b));
			}
			translate([32,32])circle(22+b);
		}
		window();
	}
}
module mount(d=0){
	difference(){
		translate([32,32])rotate(135)translate([10,0])difference(){
			minkowski(){square([24.3*2+10-10,20+d-10],center=true);circle(5);}
			translate([24.3,5])circle(2.1);
			translate([24.3,-5])circle(2.1);
		}
		window();
	}
}
module text_circle(txt,r,size){
	for(i=[0:len(txt)-1])rotate(-i/len(txt)*360)translate([0,r])text(txt[i],size=size/len(txt),halign="center");
}

// frame
if(show_frame)translate([50*spl,0,sin(180*spl)*50])rotate([0,180*spl,0])rotate(rot)
translate([0,0,-.25]){
	translate([0,0,3.5])linear_extrude(1){
		gearbb(2);
		mount();
	}
	linear_extrude(3.5)difference(){
		union(){
			gearbb(2);
			mount();
		}
		gearbb(.2,.1);
		translate([0,20])square([22,7],center=true);
		translate([12,32])square([7,22],center=true);
	}
	
	// servo model
	translate([32,32,5.25])%rotate(135){
		translate([-10.2-6.8,-10,15])cube([54,20,2.5]);
		translate([0,0,5])cylinder(r=6.7,h=2);
		translate([-10.2,-10.2,7])cube([40.4,20.4,38.2]);
		translate([0,0,-1])cylinder(r=5,h=6);
		rotate(t){
			translate([-13/2,-43/2,0])cube([13,43,2.5]);
			translate([0,13,-5])cylinder(r=1,h=10);
			translate([0,-13,-5])cylinder(r=1,h=10);
		}
	}
}

// cover
if(show_cover)translate([-75*spl,0,sin(180*spl)*-50])rotate(rot)
translate([0,0,-1.25]){
	difference(){
		linear_extrude(1){gearbb(4);mount();}
		translate([0,0,-.1])linear_extrude(.3)rotate(-138)scale([-1,1])text_circle(txt,r=18,size=120);
	}
	translate([0,0,1])linear_extrude(4.5)difference(){
		gearbb(4);
		gearbb(2.2,2.1);
		mount(.2);
	}
}

// spacer
if(show_spacer)translate([0,50*spl,sin(180*spl)*50])rotate(rot)
translate([32,32])rotate(135)translate([10+24.3,0,3.25]){
	linear_extrude(16.75)difference(){
		intersection(){
			translate([-4,-10])square([9,20]);
			minkowski(){
				square([1e-9,10],center=true);
				circle(5);
			}
		}
		translate([0, 5])circle(2.1);
		translate([0,-5])circle(2.1);
	}
}

// door knob
translate([0,0,100*spl])scale(1-spl)
%translate([0,0,72])scale([1,1,-1]){
	%translate([0,0,-10])linear_extrude(10)circle(200);
	linear_extrude(5)circle(d=72);
	linear_extrude(22)circle(d=32);
	translate([0,0,22])linear_extrude(42)circle(d=52);
}


