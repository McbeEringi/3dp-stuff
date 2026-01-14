$fa=1;$fs=.5;
include <lib/arc.scad>;
include <lib/fn.scad>;

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

NUM_VOLUTE=32;
RATIO_VOLUTE=4;
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

module volute(ri=R4,out_d=D_DUCT,ratio=RATIO_VOLUTE){
	n=NUM_VOLUTE;
	m=NUM_VOLUTE*2;
	s=((D_DUCT/2)^2)/ratio;

	polyhedron([
		for(j=[0:m])let(
			p=j*2*PI/m,
			_r=sqrt(s*mix(1,ratio,j/m)),
			r=ri+_r+(1-j/m)*1e-3,
			c=[r*_cos(p),r*_sin(p)]
		)for(i=[0:n-1])let(
			t=i*2*PI/n,
			x=rot([_r*_cos(t),0],p)
		)[c.x+x.x,(CLOCK_WISE?-1:1)*(c.y+x.y),_r*_sin(t)],
	],[
		for(j=[0:m])let(nj=n*j,njj=n*((j+1)%(m+1)))
			for(i=[0:n-1])let(ii=(i+1)%n)[nj+ii,nj+i,njj+i,njj+ii],
	]);
}
//volute();


module case(t){
	translate([0,0,-(H_BLADE+T_PLATE)/2])linear_extrude(H_BLADE+T_PLATE)turbine();
	difference(){
		translate([0,0,-D_DUCT/2-t])linear_extrude(D_DUCT+t*2){
			circle(R4+D_DUCT+t);
			scale([1,CLOCK_WISE?-1:1,1])square([R4+D_DUCT+t,R4+D_DUCT]);
		}
		volute(); 
		translate([R4+D_DUCT/2,.5,0])rotate([90,0,0])cylinder(r=D_DUCT/2,h=R4+D_DUCT+1);
		cylinder(r=R4+D_DUCT/(2*sqrt(RATIO_VOLUTE)),h=H_BLADE+T_PLATE,center=true);
		cylinder(r=R3,h=D_DUCT+t*2+1,center=true);
	}
}

translate([0,0,(H_BLADE+T_PLATE)/2])difference(){
	case(T_CASE);
	linear_extrude(50)square(200,center=true);
}
