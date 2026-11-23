$fa=5;$fs=.5;
d_outer=56.2;
d_inner=53.3;
d_latch=51.8;

target=[18,28];
film_w=35;
dist=25;
tape_w=15;


difference(){
	union(){
		translate([0,0,-10])cylinder(d=d_outer,h=10);
		intersection(){
			hull(){
				scale(-1)cylinder(d=d_outer,h=.1);
				translate([0,0,dist])scale(-1)linear_extrude(1)square([d_outer,film_w+tape_w*2],center=true);
			}
		}
	}
	translate([0,0,dist])cube([d_outer*2,film_w,.4],center=true);

	hull(){
		scale(-1)cylinder(d=d_inner,h=.1);
		linear_extrude(dist+1e-2)square(target,center=true);
	}

	rotate(-35){
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

translate([d_outer*1.5,0,0])difference(){
linear_extrude(5)square([d_outer,film_w+tape_w*2],center=true);

translate([0,0,1])minkowski(){
	linear_extrude(5)square(target,center=true);
	cylinder(10,0,10);
}
}

