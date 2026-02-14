$fa=1;$fs=.1;

r=.5;
DIST=8;

A_D1=3.2;
A_D2=5;
A_W1=10.4;
A_W2=21;
A_H=4;
B_D1=1;
B_D2=3;
B_W1=14;
B_W2=19;
B_H=2;
B_THETA=30;


difference(){
	hull(){
		cylinder(d=A_D2,h=A_W2,center=true);
		translate([DIST,0,0])cylinder(d=B_D2,h=B_W2,center=true);
		rotate(-60)translate([-A_D2/2,0,0])cylinder(d=2,h=(A_W1+A_W2)/2,center=true);
	}
	cylinder(d=A_D1,h=A_W2*1.1,center=true);
	minkowski(){cylinder(r=A_H-r,h=A_W1-r*2,center=true);sphere(r=r);}
	translate([DIST,0,0]){
		cylinder(d=B_D1,h=B_W2*1.1,center=true);
		rotate(B_THETA)minkowski(){cube([(B_H-r)*2,A_D2*2/cos(B_THETA),B_W1-r*2],center=true);sphere(r=r);}
	}
}
