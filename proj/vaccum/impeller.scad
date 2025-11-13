$fa=1;$fs=1;
include <lib/arc.scad>;

// plate params
T_PLATE=2;

// blade params
CLOCK_WISE=true;
NUM_BLADE=10;
T_BLADE=2;
H_BLADE=10;
R1=20;
R2=40;
B1=30;
B2=110;


module hub(){linear_extrude(5)difference(){
	circle(d=15);
	circle(d=5);
}}

module plate(){linear_extrude(T_PLATE)difference(){
	circle(r=R2);
	circle(d=10);
}}

module blade(){
	function sins(a,b,A)=a*sin(180-A-asin(sin(A)/a*b))/sin(A);// return c;

	curve=90-B2-B1;
	theta=90+B1-curve/2;
	d=sins(R2-T_BLADE/2,R1+T_BLADE/2,theta);

	linear_extrude(T_PLATE+H_BLADE)for(i=[0:NUM_BLADE-1])rotate(360/NUM_BLADE*i){
		translate([R1+T_BLADE/2,0,0])rotate(theta-180)darc(d=d,b=T_BLADE,t=curve,cap=true);
	}
}

module main(){
	hub();
	plate();
	scale([CLOCK_WISE?-1:1,1,1])blade();
}
main();