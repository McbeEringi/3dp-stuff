$fa=1;$fs=1;

module gear(m=5,z=14,n=4,alpha=20,jt=.1){
	r2d=function(x)x/PI*180;
	d2r=function(x)x*PI/180;
	_sin=function(x)sin(r2d(x));
	_cos=function(x)cos(r2d(x));
	_tan=function(x)tan(r2d(x));
	mix=function(a,b,x)a*(1-x)+b*x;

	r=m*z/2;
	rb=r*cos(alpha);
	ra=r+m;
	rf=r-m*1.25;

	td=2*PI/z;
	tmax=sqrt((ra/rb)^2-1);
	tt=td/4+tan(alpha)-d2r(alpha)-_tan(jt/r);
	cr=m/(2*sin(alpha));
	ci=function(t)[rb*(_cos(t)+t*_sin(t)),rb*(_sin(t)-t*_cos(t))];
	add=function(a,b)[a.x+b.x,a.y+b.y];
	rot=function(p,t)let(x=p[0],y=p[1],s=_sin(t),c=_cos(t))[c*x-s*y,s*x+c*y];

	//#circle(r=rf);
	//%circle(r=rb);
	//%difference(){circle(r=ra);circle(r=r);}
	polygon([
		for(j=[0:z-1])each let(t=td*j)[
			for(i=[0:n])rot(ci(    i /n*tmax),t-tt),
			for(i=[0:n])rot(ci(-(n-i)/n*tmax),t+tt),
			if(rf<rb)each[rot([rf,0],t+tt),rot([rf,0],t+td-tt)]
		]
	]);
}
t=$t*360/14;
linear_extrude(3){
	rotate(t)gear();
	translate([5*14,0])rotate(360/14/2-t)gear();
}

module yamaba()difference(){
	union(){
		linear_extrude(1.5,slices=2,twist=2)gear();
		scale([1,1,-1])linear_extrude(1.5,slices=2,twist=2)gear();
	}
	//cylinder(r=15,h=5,center=true);
}
//yamaba();
//translate([2*19+.5,0,0])scale([1,-1,1])yamaba();