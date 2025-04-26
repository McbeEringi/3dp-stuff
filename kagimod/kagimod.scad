use <../lib/gears.scad>
$fs=1;$fa=1;
function saturate(x)=max(0,min(x,1));
function smoothstep(a,b,x)=let(x=saturate((x-a)/(b-a)))x*x*(3-2*x);

t=smoothstep(0,1,$t)*90;
spl=smoothstep(2,1,$t*3);

rotate(45){
	rotate(t-45){
		herringbone_gear(2, 20, 3, 32,helix_angle=30,optimized=false);
		difference(){
			union(){
				cylinder(r=16,h=3+5);
				translate([0,0,3+5])cylinder(r1=16,r2=8,h=2);
			}
			translate([-3/2,-3/2,-1])cube(19);
			rotate(180)translate([-3/2,-3/2,-1])cube(19);
		}
	}
	translate([0,32,0])rotate(360/12/2+45-t/12*20)herringbone_gear(2, 12, 3, 16,helix_angle=-30,optimized=false);
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
		circle(16.1);
		translate([32,32])circle(16.1);
	}
}

translate([75*spl,0,sin(180*spl)*50])rotate([0,180*spl,0])rotate(45)
translate([0,0,-1.25]){
	translate([0,0,3.5])linear_extrude(1)gearbb(2);
	linear_extrude(3.5)difference(){
		gearbb(2);
		gearbb(.2,.1);
		translate([0,20])square([22,7],center=true);
		translate([12,32])square([7,22],center=true);
	}
	
	translate([32,32,6.25])%rotate(135){
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

translate([-75*spl,0,,sin(180*spl)*-50])rotate(45)
translate([0,0,-2.25]){
	linear_extrude(1)gearbb(4);
	translate([0,0,1])linear_extrude(4.5)difference(){
		gearbb(4);
		gearbb(2.2,2.1);
	}
}