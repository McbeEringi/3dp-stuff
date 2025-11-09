$fa=1;$fs=1;
ring_h=5;

module koma(r=5,a=2,dir){
	if(!dir||dir=="up")cylinder(h=a,r1=r,r2=r-a);
	if(!dir||dir=="down")scale(-1)cylinder(h=a,r1=r,r2=r-a);
}

module spk(o=0){
	hull(){
		translate([+(70/2-15),30/2-15])circle(r=15+o);
		translate([+(70/2-10),30/2-10])circle(r=10+o);
		translate([-(70/2-15),30/2-15])circle(r=15+o);
		translate([-(70/2-10),30/2-10])circle(r=10+o);
	}
}
module ring(){
	difference(){
		spk();
		minkowski(){
			square([70-15*2,1e-9],center=true);
			circle(r=13);
		}
		translate([-1/2,0])square([1,30]);
	}
}

module plate(){
	difference(){
		minkowski(){
			translate([0,0,2])cube([100,50,1e-9],center=true);
			koma(dir="down");
		}
		translate([0,0,1])linear_extrude(1.01)minkowski(){
			square([70-15*2,1e-9],center=true);
			circle(r=25/2);
		}
	}
	translate([0,0,2]){
		linear_extrude(3+ring_h)difference(){spk(2);spk();}
	}
}
module box(){}

plate();
translate([0,0,5])linear_extrude(ring_h)ring();
box();