include <fn.scad>;
/*
m: modul(mm) Height of the Tooth Tip over the Partial Cone
z: tooth_number(--) Number of Teeth
b: bore(mm) Diameter of the Center Hole
n: seg(--) Segments per Curve
alpha: pressure_angle(deg)
jt: clearance(mm)
*/
module gear2d(m=5,z=14,b=5, n=4,alpha=20,jt=.1){
	df=.25;
	r=m*z/2;
	rb=r*cos(alpha);
	ra=r+m;
	rf=function(x=1)r-m*(1+df*x);

	f=1;
	td=2*PI/z;
	tmax=sqrt((ra/rb)^2-1);
	tt=td/4+tan(alpha)-d2r(alpha)-_tan(jt/r);
	cr=m/(2*sin(alpha));
	ci=function(t)[rb*(_cos(t)+t*_sin(t)),rb*(_sin(t)-t*_cos(t))];

	difference(){
		polygon([
			for(j=[0:z-1])each let(t=td*j)[
				for(i=[ 0:n])let(x=ci(i/n*tmax))if(rf(1-f)<norm(x))rot(x,t-tt),
				for(i=[-n:0])let(x=ci(i/n*tmax))if(rf(1-f)<norm(x))rot(x,t+tt),
				for(i=[-n:0])let(i=i/n)rot([rf(1-f*-_cos(PI/2*i))+m*.25*f, m*.25*f],t+tt+_atan(m*df*f*+_sin(PI/2*i)/rf())),
				for(i=[ 0:n])let(i=i/n)rot([rf(1-f*-_cos(PI/2*i))+m*.25*f,-m*.25*f],t+td-tt-_atan(m*df*f*-_sin(PI/2*i)/rf())),
			]
		]);
		if(b)circle(d=b);
	}
}

/*
h: height(mm)
a: helix_angle(deg)
*/
module hira(m=5,z=14,b=5,h=5, n=4,alpha=20,jt=.1){linear_extrude(h)gear2d(m,z,b,n,alpha,jt);}
module yamaba(m=5,z=14,b=5,h=5,a=30, n=4,alpha=20,jt=.1){
	module a(){linear_extrude(h/2,slices=1,twist=atan(h*tan(a)/(z*m)))gear2d(m,z,b,n,alpha,jt);}
	translate([0,0,h/2])union(){a();mirror([0,0,1])a();}
}
