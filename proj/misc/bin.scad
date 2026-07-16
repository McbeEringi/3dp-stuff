$fa=5;$fs=1;

a=100;
h=120;
r=10;
t=1;

difference(){
	linear_extrude(h)minkowski(){
		square(a-r*2,center=true);
		circle(r);
	}
	translate([0,0,r])minkowski(){
		linear_extrude(h+r)square(a-r*2,center=true);
		sphere(r-t);
	}
	linear_extrude(.4,center=true)scale([.5,-.5])offset(.01)import("lib/icon.svg",center=true);
}
