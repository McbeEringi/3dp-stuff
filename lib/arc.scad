/*
r: radius
b: thickness
t: theta
*/
include <fn.scad>;

module arc(r,b,t,cap,n){
	if(n){
		r1=r-b/2;
		r2=r+b/2;
		polygon([
			for(i=[0:n])let(_t=t*i/n)[r2*cos(_t),r2*sin(_t)],
			if(cap)for(i=[1:cap])let(_t=180*i/(cap+1))rot([r+b/2*cos(_t),b/2*sin(_t)*sign(t)],d2r(t)),
			for(i=[0:n])let(_t=t*(n-i)/n)[r1*cos(_t),r1*sin(_t)],
			if(cap)for(i=[1:cap])let(_t=180*i/(cap+1)+180)[r+b/2*cos(_t),b/2*sin(_t)*sign(t)]
		]);
	}else{
		//$fs=b*.2;
		a=(r+b)*2;
		rot=function(t)[cos(t)*a,sin(t)*a];
		intersection(){
			difference(){circle(r+b/2);circle(r-b/2);}
			polygon([
				for(i=[0:floor(abs(t)/120)])rot(120*i*sign(t)),
				rot(t),[0,0]
			]);
		}
		if(cap){
			$fs=b*.2;
			translate([r,0])circle(d=b);
			rotate(t)translate([r,0])circle(d=b);
		}
	}
}

// distance arc
module darc(d,b,t,center,cap,n){
	//$fs=b*.2;
	r=sqrt(d*d/(2*(1-cos(t))));
	translate([center?-d/2:0,0]){
		if(r!=1/0)translate([d,0])rotate((180-abs(t))/2*sign(t))translate([-r,0])arc(r,b,t,cap,n);
		else translate([0,-b/2])square([d,b]);
	}
}