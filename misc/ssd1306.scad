$fa=6;
$fs=.5;
/*
t=0.8;
module half(){
linear_extrude(5){
	translate([0,-t])square([12.7,t]);
	translate([12.7,-t])square([t,t+3.3+t]);
	translate([12.7+t,3.3])intersection(){
		rotate(45)square(3,center=true);
		scale([-1,1])square([10,t]);
	}
}
linear_extrude(2/sqrt(2))
	translate([10.5-2/sqrt(2)/2,0])square([2/sqrt(2),3.3]);
linear_extrude(t)
	translate([4.5,0]){
		square([12.7-4.5-t,3.3-1.6-.2]);
		square([7-4.5,3.3]);
	}
}
half();scale([-1,1])half();
*/

module main(){
	linear_extrude(2/sqrt(2))translate([1.2+(2-2/sqrt(2))/2,0])square([2/sqrt(2),5]);
	linear_extrude(3.5-(2-2/sqrt(2))/2)square([8,2]);
}

main();
scale([-1,1])translate([5,0,0])main();