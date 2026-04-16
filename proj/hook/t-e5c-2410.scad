$fa=5;$fs=.2;
d=[6.4,156.6,28];
a=16;

size=[191,43,1];
foot=[165,43];
t=8;

difference(){
	hull(){
		translate([-d[1]/2-d[2],-size[1]/2,0])cube(size);
		translate([0,0,t])linear_extrude(1e-9)square(foot,center=true);
	}
	translate([ d[1]/2,-size[1]/2+a,0])cylinder(d=3-.2,h=3);
	translate([-d[1]/2,-size[1]/2+a,0])cylinder(d=3-.2,h=3);
}