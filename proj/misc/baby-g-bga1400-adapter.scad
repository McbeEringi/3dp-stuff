$fa=1;$fs=.1;
hole=false;
fin=false;
r=.5;
WIDTH=21;
DIST=9;

D1_OUT=5;
D1_IN=3.2;
W1=4;
H1=10.5;
D2_OUT=3;
D2_IN=1;
W2=3;
H2=18;

module rsq(s,r=r){minkowski(){square([s.x-r*2,s.y-r*2],center=true);circle(r);}}

difference(){
	linear_extrude(WIDTH,center=true)difference(){
		union(){
			hull(){
				circle(d=D1_OUT);
				translate([DIST,0])circle(d=D2_OUT);
			}
			if(fin)translate([DIST,0])rotate(-atan((D1_OUT-D2_OUT)*.5/DIST))square(D2_OUT/2);
		}
		if(hole){
			circle(d=D1_IN);
			translate([DIST,0])circle(d=D2_IN);
		}
	}
	if(!hole)for(s=[1,-1])for(x=[0,DIST]){
		translate([x,0,s*WIDTH*.5])sphere(d=1);
	}
	rotate([90,0,0])linear_extrude(D1_OUT,center=true){
			rsq([W1*2,H1]);
			translate([DIST,0])rsq([W2*2,H2]);
	}
}