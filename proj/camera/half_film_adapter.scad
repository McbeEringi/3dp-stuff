$fa=5;$fs=.5;
d_outer=56.2;
d_inner=53.3;
d_latch=51.8;

target=[18,25];
width=35;
dist=20;


difference(){
	union(){
	translate([0,0,-10])cylinder(d=d_outer,h=10);
	hull(){
		scale(-1)cylinder(d=d_outer,h=.1);
		linear_extrude(dist)scale(1.1)square(target,center=true);
	}
}
	translate([0,0,dist])cube([d_outer,35,.4],center=true);

	hull(){
		scale(-1)cylinder(d=d_inner,h=.1);
		linear_extrude(dist+1e-2)square(target,center=true);
	}

	rotate(-45){
	scale(-1)linear_extrude(9)difference(){
		circle(d=d_inner);
		for(t=[83,-97])rotate(t)
			translate([d_inner/2,0,0])circle(d=d_inner-d_latch);
	}
	scale(-1)linear_extrude(12){
		circle(d=d_latch);
		for(t=[-5,0,175,180])rotate(t)
			translate([d_latch/2,0,0])circle(d=d_inner-d_latch);
		rotate(-5)difference(){
			circle(d=d_inner);
			square(d_outer);
			scale(-1)square(d_outer);
		}
	}
}
}

