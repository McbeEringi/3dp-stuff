$fa=1;$fs=1;

module gear(m=5,z=14, n=4,alpha=20,jt=.1){
	r2d=function(x)x/PI*180;
	d2r=function(x)x*PI/180;
	_sin=function(x)sin(r2d(x));
	_cos=function(x)cos(r2d(x));
	_tan=function(x)tan(r2d(x));
	_atan=function(x)d2r(atan(x));
	mix=function(a,b,x)a*(1-x)+b*x;

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
	add=function(a,b)[a.x+b.x,a.y+b.y];
	rot=function(p,t)let(x=p[0],y=p[1],s=_sin(t),c=_cos(t))[c*x-s*y,s*x+c*y];

	polygon([
		for(j=[0:z-1])each let(t=td*j)[
			for(i=[ 0:n])let(x=ci(i/n*tmax))if(rf(1-f)<norm(x))rot(x,t-tt),
			for(i=[-n:0])let(x=ci(i/n*tmax))if(rf(1-f)<norm(x))rot(x,t+tt),
			for(i=[-n:0])let(i=i/n)rot([rf(1-f*-_cos(PI/2*i))+m*.25*f, m*.25*f],t+tt+_atan(m*df*f*+_sin(PI/2*i)/rf())),
			for(i=[ 0:n])let(i=i/n)rot([rf(1-f*-_cos(PI/2*i))+m*.25*f,-m*.25*f],t+td-tt-_atan(m*df*f*-_sin(PI/2*i)/rf())),
		]
	]);
}

/*
z=14;m=5;
t=$t*360/z;
linear_extrude(3){
	translate([-m*z/2,0])rotate(t)gear(m,z);
	translate([ m*z/2,0])rotate(360/z/2-t)gear(m,z);
}
*/

module yamaba(m=5,z=14,h=5,a=30, n=4,alpha=20,jt=.1){
	module a(){linear_extrude(h/2,slices=1,twist=atan(h*tan(a)/(z*m)))gear(m,z,n,alpha,jt);}
	union(){a();mirror([0,0,1])a();}
}
yamaba();
