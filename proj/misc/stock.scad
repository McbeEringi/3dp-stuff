r=13.2/2;l=32;

module screw(n=4){
	linear_extrude(height=2*n,twist=-360*n,slices=n*l)polygon([
		for(i=[0:l-1])let(x=i/l,t=x*360,s=r+abs(x-.5)*2)[s*cos(t),s*sin(t)]
	]);
}

difference(){
	cylinder(r1=12,r2=10,h=8);
	screw();
}

translate([50,0,0])difference(){
	union(){
		cylinder(d=60,h=6);
		cylinder(r1=15,r2=19/2,h=12);
	}
	cylinder(d=13.7,h=6);
	translate([0,0,6])cylinder(d=15.2,h=6);
	screw();
}