$fs=.5;
linear_extrude(1)minkowski(){
	circle(r=19);
	square(101-19*2);
}