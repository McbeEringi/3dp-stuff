$fa=1;$fs=.5;
include <lib/arc.scad>;

// hub params
D1_HUB=5.5;
D2_HUB=15;
H_HUB=5;
// plate params
T_PLATE=2;

// blade params
CLOCK_WISE=true;
NUM_BLADE=12;
T_BLADE=1;
H_BLADE=13;
R1=15;
R2=30;
B1=60;
B2=30;


isNaN=function(x)x!=x;
ifNaN=function(x,y)isNaN(x)?y:x;
sins_B=function(a,b,A)asin(sin(A)/a*b);
sins_C=function(a,b,A)180-A-sins_B(a,b,A);
sins_c=function(a,b,A)a*sin(sins_C(a,b,A))/sin(A);

B2err=function(x)(90-sins_B(R2-T_BLADE/2,R1+T_BLADE/2,90+B1-x/2)-x/2)-B2;
newton=function(n=10,x=0,d=.1)let(a=B2err(x),b=B2err(x+d),y=x-d/(b-a)*a)a&&n-1?newton(n-1,y):y;
curve=newton();

module hub(){linear_extrude(H_HUB)difference(){
	circle(d=D2_HUB);
	circle(d=D1_HUB);
}}

module plate(){linear_extrude(T_PLATE)difference(){
	circle(r=R2);
	circle(d=D1_HUB);
}}

module blade(){
	d=ifNaN(
		sins_c(R2-T_BLADE/2,R1+T_BLADE/2,90+B1-curve/2),
		R2-R1-T_BLADE
	);

	linear_extrude(T_PLATE+H_BLADE)for(i=[0:NUM_BLADE-1])rotate(360/NUM_BLADE*i){
		translate([R1+T_BLADE/2,0,0])rotate(-90+B1-curve/2)darc(d=d,b=T_BLADE,t=curve,cap=true);
	}
}

module main(){
	hub();
	plate();
	scale([CLOCK_WISE?-1:1,1,1])blade();
}
main();
