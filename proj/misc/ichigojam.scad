$fa=1;$fs=.1;

w=75;
h=50;
d=3;

a=(w-3*3)/2;
b=(h-3*3)/2;


module hole(d=3){
	for(i=[a,-a])for(j=[b,-b])translate([i,j])circle(d=d);
}

linear_extrude(1)difference(){square([w,h],center=true);hole();}
translate([0,0,1])linear_extrude(d){
	difference(){
		hole(8);
		hole();
	}
	difference(){
		square([w,h],center=true);
		square([w-2,h-2],center=true);
	}
}
