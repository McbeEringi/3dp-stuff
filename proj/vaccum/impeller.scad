$fa=1;$fs=.5;
include <lib/arc.scad>;

D_DUCT=32.5;
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

// turbine params
R3=30.5;
R4=40;
B3=20;
B4=25;
NUM_TURBINE=12;
T_TURBINE=1;

NUM_VOLUTE=12;
T_CASE=2;


isNaN=function(x)x!=x;
ifNaN=function(x,y)isNaN(x)?y:x;
sins_B=function(a,b,A)asin(sin(A)/a*b);
sins_C=function(a,b,A)180-A-sins_B(a,b,A);
sins_c=function(a,b,A)a*sin(sins_C(a,b,A))/sin(A);


module hub(){linear_extrude(H_HUB)difference(){
	circle(d=D2_HUB);
	circle(d=D1_HUB);
}}

module plate(){linear_extrude(T_PLATE)difference(){
	circle(r=R2);
	circle(d=D1_HUB);
}}

module blade(r1,r2,b1,b2,n,t){
	B2err=function(x)(90-sins_B(r2-t/2,r1+t/2,90+b1-x/2)-x/2)-b2;
	newton=function(n=10,x=0,d=.1)let(a=B2err(x),b=B2err(x+d),y=x-d/(b-a)*a)a&&n-1?newton(n-1,y):y;
	curve=newton();

	d=ifNaN(
		sins_c(r2-t/2,r1+t/2,90+b1-curve/2),
		r2-r1-t
	);

	for(i=[0:n-1])rotate(360/n*i){
		translate([r1+t/2,0,0])rotate(-90+b1-curve/2)darc(d=d,b=t,t=curve,cap=true);
	}
}

module impeller(){
	hub();
	plate();
	scale([CLOCK_WISE?-1:1,1,1])linear_extrude(T_PLATE+H_BLADE)blade(R1,R2,B1,B2,NUM_BLADE,T_BLADE);
}
impeller();




module turbine(){scale([CLOCK_WISE?1:-1,1,1])blade(R3,R4,B3,B4,NUM_TURBINE,T_TURBINE);}

module volute(o=0,e=1,d=D_DUCT){
	h=sin(360/NUM_VOLUTE)/2;
	for(i=[0:NUM_VOLUTE-1])let(
		ni=i/NUM_VOLUTE,nii=(i+1)/NUM_VOLUTE,
		ri=d/2*(.5+.5*ni),rii=d/2*(.5+.5*nii),
		di=R4+ri,dii=R4+rii
	)hull(){
		rotate([90,0,(CLOCK_WISE?-1:1)*ni*360])translate([di,0,0])cylinder(r=ri+o,h=h*di,center=true);
		rotate([90,0,(CLOCK_WISE?-1:1)*nii*360])translate([dii,0,0])cylinder(r=rii+o,h=h*dii,center=true);
	}
	translate([R4+d/2,0,0])rotate([90,0,0])cylinder(r=d/2+o,h=R4+d+e);
}

module case(t){
	translate([0,0,-(H_BLADE+T_PLATE)/2])linear_extrude(H_BLADE+T_PLATE)turbine();
	difference(){
		translate([0,0,-D_DUCT/2-t])linear_extrude(D_DUCT+t*2){
			circle(R4+D_DUCT+t);
			scale([1,CLOCK_WISE?-1:1,1])square([R4+D_DUCT+t,R4+D_DUCT]);
		}
		volute(); 
		cylinder(r=R4+D_DUCT/4,h=H_BLADE+T_PLATE,center=true);
		cylinder(r=R3,h=D_DUCT+t*2+1,center=true);
	}
}
translate([0,0,(H_BLADE+T_PLATE)/2])difference(){
	case(T_CASE);
	linear_extrude(50)square(200,center=true);
}
