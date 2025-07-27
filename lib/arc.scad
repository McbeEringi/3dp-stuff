/*
r: radius
b: thickness
t: theta
*/
module arc(r,b,t){
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
}

// distance arc
module darc(d,b,t,center,cap){
	//$fs=b*.2;
	r=sqrt(d*d/(2*(1-cos(t))));
	translate([center?-d/2:0,0]){
		if(r!=1/0)translate([d,0])rotate((180-abs(t))/2*sign(t))translate([-r,0])arc(r,b,t);
		else translate([0,-b/2])square([d,b]);
			if(cap){
			circle(d=b);
			translate([d,0])circle(d=b,$fs=b*.2);
		}
	}
}