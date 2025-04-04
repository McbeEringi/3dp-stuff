$fa=1;$fs=1;
gap=21;
thick=5;
tip=20;
jaw=70;
pic=20;
r=10;
theta=30;
linear_extrude(10)difference(){
	union(){
		square([gap+thick*2,jaw+thick]);
		translate([-r,jaw+thick]){
			difference(){
				circle(r=r+thick);
				circle(r=r);
				translate([-r-thick,-r-thick])square([(r+thick)*2,r+thick]);
				rotate(-theta)translate([-r-thick,-r-thick])square([(r+thick)*2,r+thick]);
			}
			rotate(-theta)translate([-r-thick,-pic])square([thick,pic+.1]);
		}
	}
	translate([thick,thick])square([gap,jaw]);
	translate([thick,thick+tip])square([gap+thick,jaw]);
}