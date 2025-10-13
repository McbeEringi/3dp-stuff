include <lib/fn.scad>
use <lib/gear.scad>
$fs=1;$fa=1;

t=$t*180;
spl=smoothstep(2,1,$t*3);
rot=45;

show_gears=true;
show_frame=true;
show_cover=true;
show_spacer=true;
show_deco=false;

txt="ueckoken kagimod @McbeEringi ";

if(show_gears)rotate(rot){
	// sumturn gear
	rotate(t+45){
		yamaba(2,20,32, 3,30);
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
	translate([0,32,0])rotate(360/12/2+45-t/12*20)yamaba(2,12,16, 3,-30);
	// servo gear
	translate([32,32,0])rotate(t+45){
		yamaba(2,20,28, 3,30);
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


module servo(){
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
module knob(){
	linear_extrude(5)circle(d=72);
	linear_extrude(22)circle(d=32);
	translate([0,0,22])linear_extrude(42)circle(d=52);
}
module block(){
	difference(){
		minkowski(){square([10,1e-9],center=true);circle(5);}
		translate([ 5,0])circle(1.7);
		translate([-5,0])circle(1.7);
	}
}

// holder
translate([-75*spl,0,0])rotate(rot)translate([0,0,30])linear_extrude(10)translate([32,32])rotate(45)translate([0,10]){
translate([0,25])#block();
}
// spacer_base
translate([0,75*spl,0])rotate(rot)translate([0,0,30])linear_extrude(30)translate([32,32])rotate(45)translate([0,10-25])
block();


module mag(){
	linear_extrude(5)square([20,10],center=true);
	linear_extrude(15){
		translate([ 5,0])circle(d=2.5);
		translate([-5,0])circle(d=2.5);
	}
}

//base
translate([100*spl,0,0])rotate(rot)translate([0,0,60])difference(){
	linear_extrude(12)difference(){
		union(){
			circle(d=97);
			translate([32,32])rotate(45)translate([0,10-25])block();
		}
		circle(d=77);
		translate([32,32])rotate(45)translate([0,10-25]){
			translate([ 5,0])circle(d=2.5);
			translate([-5,0])circle(d=2.5);
		}
		translate([-32,-32])rotate(45)square(36,center=true);
	}
	for(i=[0:2])rotate(i*360/3-45)translate([0,87/2,12.01])scale([1,1,-1])mag();
	translate([0,0,12-5+.01])linear_extrude(5)translate([32,32])rotate(45)translate([0,10-25]){
		translate([ 5,0])circle(d=8.5);
		translate([-5,0])circle(d=8.5);
	}
}







// deco
if(show_deco&&1-spl)translate([0,0,100*spl])scale(1-spl){
	// servo model
	rotate(rot)translate([32,32,5])%rotate(135)servo();

	// door knob
	%translate([0,0,72])scale([1,1,-1]){
		%translate([0,0,-10])linear_extrude(10)circle(200);
		knob();
	}
}

